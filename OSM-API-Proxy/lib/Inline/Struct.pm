package Inline::Struct;

use strict;
use Carp;
require Inline;
require Inline::Struct::grammar;
use Data::Dumper;

use vars qw($VERSION);
$VERSION = '0.06';

#=============================================================================
# Inline::Struct is NOT an ILSM: no register() function
#=============================================================================

#=============================================================================
# parse -- gets all C/C++ struct definitions and binds them to Perl
#=============================================================================
sub parse {
    require Parse::RecDescent;
    my $o = shift;
    return if $o->{STRUCT}{'.parser'};
    return unless $o->{STRUCT}{'.any'};

    # Figure out whether to grab all structs
    my $nstructs = scalar grep { $_ =~ /^[_a-z][_0-9a-z]*$/i } 
      keys %{$o->{STRUCT}};
    $o->{STRUCT}{'.all'} = 1 
      if $nstructs == 0;

    # Load currently-defined types (stored in $o->{ILSM}{typeconv})
    $o->get_maps;
    $o->get_types;

    # Parse structs
    $::RD_HINT++;
    my $grammar = Inline::Struct::grammar::grammar()
      or croak "Can't find Struct grammar!\n";
    my $parser = $o->{STRUCT}{'.parser'} = Parse::RecDescent->new($grammar);
    $parser->{data}{typeconv} = $o->{ILSM}{typeconv};
    $parser->code($o->{ILSM}{code});
    $o->{ILSM}{typeconv} = $parser->{data}{typeconv};

    $o->{STRUCT}{'.xs'} = "";
    $o->{STRUCT}{'.macros'} = <<END;
#define NEW_INLINE_STRUCT(targ,type) INLINE_STRUCT_NEW_##type(targ)
#define INLINE_STRUCT_FIELDS(type) INLINE_STRUCT_FIELDS_##type
#define INLINE_STRUCT_INIT_LIST(targ,type) INLINE_STRUCT_INITL_##type(targ)
#define INLINE_STRUCT_INIT_AREF(src,targ,type) INLINE_STRUCT_INITA_##type(src,targ)
#define INLINE_STRUCT_INIT_HREF(src,targ,type) INLINE_STRUCT_INITH_##type(src,targ)
#define INLINE_STRUCT_ARRAY(src,targ,type) INLINE_STRUCT_ARRAY_##type(src,targ)
#define INLINE_STRUCT_VALUES(src,targ,type) INLINE_STRUCT_ARRAY_##type(src,targ)
#define INLINE_STRUCT_HASH(src,targ,type) INLINE_STRUCT_HASH_##type(src,targ)
#define INLINE_STRUCT_KEYS(src,targ,type) INLINE_STRUCT_KEYS_##type(src,targ)
END

    my @struct_list;
    if ($o->{STRUCT}{'.all'}) { 
	if ($parser->{data}{structs})
	{
	    @struct_list = @{$parser->{data}{structs}} 
	}
	else
	{
	    @struct_list = (); 
	}
    }
    else { 
	@struct_list = grep { $_ =~ /^[_a-z][_a-z0-9]*$/i } 
	  keys %{$o->{STRUCT}} 
    }
    for my $struct (@struct_list) {
	unless (defined $parser->{data}{struct}{$struct}) {
	    warn "Struct $struct requested but not found" if $^W;
	    next;
	}
	$o->{STRUCT}{'.bound'}{$struct}++;
	my $cname = $parser->{data}{struct}{$struct}{cname};
	my ($NEW, $FIELDS, $INITL, $INITA, $INITH, $HASH, $ARRAY, $KEYS);

	# Set up the initial part of the macros
	$NEW = <<END;
#define INLINE_STRUCT_NEW_${struct}(targ) { \\
	HV *hv = get_hv("Inline::Struct::${struct}::_map_", 1); \\
	HV *entry = newHV(); \\
	SV *entrv = (SV*)newRV((SV*)entry); \\
	SV *lookup; \\
	char *key; \\
	STRLEN klen; \\
	Newz(1564,targ,1,$cname); \\
	lookup = newSViv((IV)targ); \\
	key = SvPV(lookup, klen); \\
	hv_store(entry, "REFCNT", 6, newSViv(0), 0); \\
	hv_store(entry, "FREE", 4, newSViv(1), 0); \\
	hv_store(hv, key, klen, entrv, 0); \\
}
END
	$FIELDS = "#define INLINE_STRUCT_FIELDS_$struct " .
	  (scalar @{$parser->{data}{struct}{$struct}{fields}}) . "\n";
	$INITL = "#define INLINE_STRUCT_INITL_$struct(targ) {\\\n";
	$INITA = <<END;
#define INLINE_STRUCT_INITA_$struct(src,targ) { \\
AV *av = (AV*)SvRV(src); \\
int l = av_len(av) + 1; \\
int i; \\
for (i=0; i<l; i++) { \\
SV *val = *av_fetch(av, i, 0); \\
END
	$INITH = <<END;
#define INLINE_STRUCT_INITH_$struct(src,targ) { \\
HV *hv = (HV*)SvRV(src); \\
int l = hv_iterinit(hv); \\
int i; \\
for (i=0; i<l; i++) { \\
I32 retlen; \\
HE *he = hv_iternext(hv); \\
char *k = hv_iterkey(he,&retlen); \\
SV *val = hv_iterval(hv,he); \\
END
        $HASH = <<END;
#define INLINE_STRUCT_HASH_$struct(src,targ) \\
hv_clear(targ); \\
END
        $ARRAY = <<END;
#define INLINE_STRUCT_ARRAY_$struct(src,targ) \\
av_clear(targ); \\
END

	$KEYS = <<END;
#define INLINE_STRUCT_KEYS_$struct(src,targ) \\
av_clear(targ); \\
END

        my $maxi = scalar @{$parser->{data}{struct}{$struct}{fields}};
	next unless $maxi > 0;

	$o->{STRUCT}{'.xs'} .= <<END;
MODULE = $o->{API}{module}		PACKAGE = Inline::Struct::$struct

PROTOTYPES: DISABLE

$cname *
new(klass, ...)
        char *klass
    PREINIT:
        int _items = items - 1;
    CODE:
	NEW_INLINE_STRUCT(RETVAL,$struct);
	if (_items == 0) { }
	else if (SvROK(ST(1)) && SvTYPE(SvRV(ST(1)))==SVt_PVAV) {
	    INLINE_STRUCT_INIT_AREF(ST(1),RETVAL,$struct);
	}
	else if (SvROK(ST(1)) && SvTYPE(SvRV(ST(1)))==SVt_PVHV) {
	    INLINE_STRUCT_INIT_HREF(ST(1),RETVAL,$struct);
	}
	else {
            INLINE_STRUCT_INIT_LIST(RETVAL,$struct);
	}
    OUTPUT:
        RETVAL

void
DESTROY(object)
        $cname *object
    PREINIT:
        HV *map = get_hv("Inline::Struct::${struct}::_map_", 1);
        SV *lookup;
        STRLEN klen;
        char *key;
    CODE:
        lookup = newSViv((IV)object);
        key = SvPV(lookup, klen);
        if (hv_exists(map, key, klen)) {
            HV *info = (HV*)SvRV(*hv_fetch(map, key, klen, 0));
            SV *refcnt = *hv_fetch(info, "REFCNT", 6, 0);
            int tofree = SvIV(*hv_fetch(info, "FREE", 4, 0));
            if (tofree && SvIV(refcnt) == 1) {
              Safefree(object);
              hv_delete(map, key, klen, 0);
            }
            else
              sv_dec(refcnt);
        }

HV *
_HASH(object)
        $cname *object
    CODE:
        RETVAL = newHV();
	INLINE_STRUCT_HASH(object, RETVAL, $struct);
    OUTPUT:
        RETVAL

AV *
_VALUES(object)
        $cname *object
    CODE:
        RETVAL = newAV();
	INLINE_STRUCT_VALUES(object, RETVAL, $struct);
    OUTPUT:
        RETVAL

AV *
_ARRAY(object)
        $cname *object
    CODE:
        RETVAL = newAV();
	INLINE_STRUCT_ARRAY(object, RETVAL, $struct);
    OUTPUT:
        RETVAL

AV *
_KEYS(object)
        $cname *object
    CODE:
        RETVAL = newAV();
        INLINE_STRUCT_KEYS(object, RETVAL, $struct);
    OUTPUT:
        RETVAL

END

        my $i=1;
	for my $field (@{$parser->{data}{struct}{$struct}{fields}}) {
	    my $flen = length $field;
	    my $type = $parser->{data}{struct}{$struct}{field}{$field};
	    my $q = ($i == 1 ? 'if' : 'else if');
	    my $t =
	      typeconv($o, "targ->$field",
			   "val",
			   $type,
			   "input_expr",
			   1,
			  );
	    my $s =
	      typeconv($o, "src->$field",
			   "tmp",
			   $type,
			   "output_expr",
			   1,
			  );
	    $INITL .=
	      (typeconv($o, "targ->$field",
			    "ST($i)",
			    $type,
			    "input_expr",
			    1
			   ) .
	       "; \\\n");
	    $INITA .= qq{$q(i == ${\($i-1)}) \\\n$t; \\\n};
	    $INITH .= qq{$q(strEQ(k, "$field")) \\\n$t;\\\n};
	    $HASH .= (qq{{\\\n\tSV*tmp=newSViv(0);\\\n$s \\
\thv_store(targ, "$field", $flen, tmp, 0); \\\n}} .
		      ($i == $maxi ? "" : "\\") .
		      "\n"
		     );
	    $ARRAY .= (qq{{\\\n\tSV*tmp=newSViv(0);\\\n$s \\
\tav_push(targ, tmp); \\\n}} .
		       ($i == $maxi ? "" : "\\") .
		       "\n"
		      );
	    $KEYS .= (qq{av_push(targ, newSVpv("$field", 0));} .
		      ($i == $maxi ? "" : "\\") .
		      "\n"
		     );
	    $o->{STRUCT}{'.xs'} .=
	       ("void\n" .
	        $field . "(object, ...)\n\t" .
		$cname . " *object\n" .
		"    PREINIT:\n" .
		"\tSV *retval = newSViv(0);\n" .
		"    PPCODE:\n" .
		"\tif (items != 1) {\n" .
		typeconv($o, "object->$field",
		             "ST(1)",
			     $type,
			     "input_expr",
			    ) . ";\n" .
		typeconv($o, "object", "retval", "$cname *", "output_expr")."\n" .
		"\t}\n" .
		"\telse {\n" .
		typeconv($o, "object->$field", "retval", $type, "output_expr") .
		"\n\t}\n\t" .
		"XPUSHs(retval);\n\n"
	       );
            $i++;
	}
	$INITA .= "}}\n";
	$INITL .= "}\n";
	$INITH .=
	  qq|else \\\n\tcroak("No such field '%s' in $cname\\n", k);}}\n|;

	$o->{STRUCT}{'.macros'} .= <<END;
$NEW
$FIELDS
$INITA
$INITL
$INITH
$HASH
$ARRAY
$KEYS
END

    }

    # Write a typemap file containing typemaps for each thingy
    write_typemap($o);
}

sub write_typemap {
    my $o = shift;
    my $data = $o->{STRUCT}{'.parser'}{data};

    my ($TYPEMAP, $INPUT, $OUTPUT);
    for my $struct (@{$data->{structs}}) {
	my $type = "O_OBJECT_$struct";
	my @ctypes = grep { $data->{typeconv}{type_kind}{$_} eq $type } 
	   keys %{$data->{typeconv}{type_kind}};
	$TYPEMAP .= join "\n", map { "$_\t\t$type" } @ctypes;
	$INPUT .= $type."\n".$data->{typeconv}{input_expr}{$type};
	$OUTPUT .= $type."\n".$data->{typeconv}{output_expr}{$type};
    }

    $o->mkpath($o->{API}{build_dir})
      unless -d $o->{API}{build_dir};
    my $fh;
    my $fname = $o->{API}{build_dir}.'/Struct.map'; 
    open $fh, ">$fname"
      or die $!;
    print $fh <<END;
TYPEMAP
$TYPEMAP

INPUT
$INPUT

OUTPUT
$OUTPUT
END

    close $fh;
    $o->validate( TYPEMAPS => $fname );
}

sub typeconv {
    my $o = shift;
    my $var = shift;
    my $arg = shift;
    my $type = shift;
    my $dir = shift;
    my $preproc = shift;
    my $tkind = $o->{ILSM}{typeconv}{type_kind}{$type};
    my $ret =
      eval qq{qq{$o->{ILSM}{typeconv}{$dir}{$tkind}}};
    chomp $ret;
    $ret =~ s/\n/\\\n/g if $preproc;
    return $ret;
}

#=============================================================================
# Return a little info about the structs we bound to.
#=============================================================================
sub info {
    my $o = shift;
    my $info = "";
    parse($o) unless defined $o->{STRUCT}{'.parser'};
    my $data = $o->{STRUCT}{'.parser'}{data};
    if (defined $o->{STRUCT}{'.bound'}) {
	$info .= "The following structs have been bound to Perl:\n";
	for my $struct (keys %{$o->{STRUCT}{'.bound'}}) {
	    $info .= "\tstruct $struct {\n";
	    for my $field (@{$data->{struct}{$struct}{fields}}) {
		my $type = $data->{struct}{$struct}{field}{$field};
		$info .= "\t\t$type $field;\n";
	    }
	    $info .= "\t};\n";
	}
    }
    else {
	$info .= "No structs were bound to Perl.\n";
    }
    return $info;
}

1;

__END__
