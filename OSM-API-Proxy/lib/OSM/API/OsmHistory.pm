# copyright 2009 h4ck3rm1k3@flossk.org
# licensed under GNU Affero General Public License
# http://www.fsf.org/licensing/licenses/agpl-3.0.html
# 
package OSM::API::OsmHistory::Handler;
use  OSM::API::OsmObjects;
use strict;
use warnings;
# borrowed from SAXOsmHandler - Osmrender implementation
# http://svn.openstreetmap.org/applications/rendering/osmarender/orp/SAXOsmHandler.pm
use YAML;
sub new
{
    my $class=shift;
    my $partno =shift;

    my $self={
	partno => $partno
    };

    return bless $self,$class;
}
use base qw(XML::SAX::Base);

sub finish_current
{
    my $self=shift;
    if (exists($self->{current}))
    {
	if ($self->{current})
	{
	    my $type = ref $self->{current};
	    warn "check type $type";
	    if ($type ne "HASH")
	    {
		$self->{current}->Split();
#	warn Dump($self->{current}) if (keys %{$self->{current}{tags}});
	    }
	    delete $self->{current};
	    $self->{current} = undef;
	}
    }

}

sub tagstats
{
    my $self = shift;
    my $element = shift;
    my $name=$element->{Name};
    warn "got $name\n";
    $self->{stats}{$name}++;# count the stats
}
sub tagstatsdump
{
    my $self = shift;
    warn Dump($self->{stats});
}

sub start_element {
    my $self = shift;
    my $element = shift;
#    warn "Got element " . Dump($element);
    $self->tagstats($element);# count the stats
    if ($element->{Name} eq 'node') 
    {

	my $n = OSM::API::OsmObjects::Node->new(
	    {
		partno => $self->{partno},
		id        => $element->{'Attributes'}{'{}id'}{"Value"}, 
		lat       => $element->{'Attributes'}{'{}lat'}{"Value"}, 
		lon       => $element->{'Attributes'}{'{}lon'}{"Value"}, 
		changeset      => $element->{'Attributes'}{'{}changeset'}{"Value"}, 
		version      => $element->{'Attributes'}{'{}version'}{"Value"}, 
		visible      => $element->{'Attributes'}{'{}visible'}{"Value"}, 
		timestamp => $element->{'Attributes'}{'{}timestamp'}{"Value"}
	    }
	    );
	$n->Hash();
	$self->finish_current();# finish the last one
	$self->{current}=$n;
    }
    elsif ($element->{Name} eq 'tag')
    {
	$self->{current}{tags}{$element->{Attributes}{'{}k'}{Value}}= $element->{Attributes}{'{}v'}{Value};
    }

    elsif ($element->{Name} eq 'changeset') 
    {
	my $n = OSM::API::OsmObjects::ChangeSet->new(
	    {
		partno => $self->{partno},
		id        => $element->{'Attributes'}{'{}id'}{"Value"}, 
		created_at => $element->{'Attributes'}{'{}created_at'}{"Value"},
		closed_at => $element->{'Attributes'}{'{}closed_at'}{"Value"},
		max_lon => $element->{'Attributes'}{'{}max_lon'}{"Value"},
		max_lat => $element->{'Attributes'}{'{}max_lat'}{"Value"},
		min_lon => $element->{'Attributes'}{'{}min_lon'}{"Value"},
		min_lat => $element->{'Attributes'}{'{}min_lat'}{"Value"},
		user => $element->{'Attributes'}{'{}user'}{"Value"},
		uid => $element->{'Attributes'}{'{}uid'}{"Value"},
		open => $element->{'Attributes'}{'{}open'}{"Value"}
	    }
	    );
	$n->Hash();
	$self->finish_current();# finish the last one
	$self->{current}=$n;	
    }
    elsif ($element->{Name} eq 'way')
    {
	my $n = OSM::API::OsmObjects::Way->new(
	    {
		partno => $self->{partno},
		id        => $element->{'Attributes'}{'{}id'}{"Value"}, 
		changeset      => $element->{'Attributes'}{'{}changeset'}{"Value"}, 
		version      => $element->{'Attributes'}{'{}version'}{"Value"}, 
		visible      => $element->{'Attributes'}{'{}visible'}{"Value"}, 
		timestamp => $element->{'Attributes'}{'{}timestamp'}{"Value"}
	    }
	    );
	$self->finish_current();# finish the last one
	$self->{current}=$n;
    }
    elsif ($element->{Name} eq 'relation')
    {
#         undef $self->{current};
#         return if defined $element->{'Attributes'}{'action'}
#                && $element->{'Attributes'}{'action'} eq 'delete';
        
#         my $id = $element->{'Attributes'}{'id'};
# #        $self->{relation}{$id} =
# #              $self->{current} = {id        => $id, 
# #                                  user      => $element->{'Attributes'}{'user'}, 
# #                                  timestamp => $element->{'Attributes'}{'timestamp'}, 
# #                                  members   => [],
# #                                  relations => [] };             
#        bless $self->{current}, 'relation';
    }
    elsif ($element->{Name} eq 'nd')
    {
        push(@{$self->{current}{'nodes'}},
             $self->{node}{$element->{'Attributes'}->{'{}ref'}});
    }
    elsif (($element->{Name} eq 'member') and (ref $self->{current} eq 'relation'))
    {
        # relation members are temporarily stored as symbolic references (e.g. a
        # string that contains "way:1234") and only later replaced by proper 
        # references.
        
#        push(@{$self->{current}{'members'}}, 
#            [ $element->{Attributes}{role}, 
#              $element->{Attributes}{type}.':'.
#              $element->{Attributes}{ref } ]);
    }
    elsif ($element->{Name} eq 'bounds')
    {
        # my $b = $self->{bounds}; # Just a shortcut
        # my $minlat = $element->{Attributes}{minlat};
        # my $minlon = $element->{Attributes}{minlon};
        # my $maxlat = $element->{Attributes}{maxlat};
        # my $maxlon = $element->{Attributes}{maxlon};

        # $b->{minlat} = $minlat if !defined($b->{minlat}) || $minlat < $b->{minlat};
        # $b->{minlon} = $minlon if !defined($b->{minlon}) || $minlon < $b->{minlon};
        # $b->{maxlat} = $maxlat if !defined($b->{maxlat}) || $maxlat > $b->{maxlat};
        # $b->{maxlon} = $maxlon if !defined($b->{maxlon}) || $maxlon > $b->{maxlon};
    }
    else
    {
        # ignore for now
    }

    # do something
    #$self->{Handler}->start_element($data); # BAD
  }

1;

package OSM::API::OsmHistory;

use LWP::UserAgent;
use Compress::Bzip2 qw(:all );
use strict;
use warnings;
use constant overlap    => 1024 * 100;
use constant blocksize  => 280148 * 4; 
use YAML;
use OSM::API::OsmFile;
use IO::Uncompress::Bunzip2 qw ($Bunzip2Error);
use IO::File;


#use XML::LibXML;
#XML::LibXML::SAX
use XML::SAX;
sub     cleanup
{
    my $xml=shift || die "no input";
    my $partno=shift;

    my $handler = OSM::API::OsmHistory::Handler->new( $partno );
    warn "processing $partno with data len:". length($xml); # 9000066 bytes of data collected

    #..."/><tag k="..." v="..."/></changeset><
    while (
#	($xml =~ /[^\<](<(changeset|node|way|tag|relation|bounds|nd|member)[^\>]+(\/\>|\<\/$2\>))/g)# 
#<\/(changeset|node|way|relation|bounds)>
#	($xml =~ /(<(changeset|node|way|relation|bounds)>.+)/g)# 
	($xml =~ /(<changeset.+<\/changeset>)/g)# 
	)
    {	
	warn "Check this 1 $1" ;
	warn "Check this 2 $2" if $2;
	warn "Check this 3 $3" if $3;
    	my $data = "<osm>$1</osm>";
	warn "parse $data";
	my $parser = XML::SAX::ParserFactory->parser(
	    Handler => $handler
	    );
	$parser->parse_string($data);
	$handler->finish_current(); # process the last one 
    }
    $handler->tagstatsdump();

}

sub extract
{
    my $file=shift;
#    warn "Processing zip file $file";
    my @data;
    my $str;
    my $fh=IO::Uncompress::Bunzip2->new( $file) or die "Couldn't open bzipped input file: $Bunzip2Error\n";
    
    while(<$fh>)
    {
	$str .= $_;
    }
#    IO::Uncompress::Bunzip2::bunzip2($file => \@data);
#    $str = join ("",map { $$_ } @data);
#    warn "got $str";
    return $str;
}

sub process_bzip_parts
{

    my @listoffiles= @_;
#    warn join "\n",@listoffiles;
    my @stack;
    my $str;
    foreach my $f (@listoffiles)
    {
#	print "going to process $f\n";
	my @stat=stat($f);
	# print $stat[7] . "\n";
	# if ($stat[7] < 1000)
	# {
#	push @stack,$f;
	# }
	# else
	# {
#	warn "Begin Processing Stack";
#	while (@stack)
#	    {
#		my $f1= pop @stack;
	$str .= extract($f);
	
#	    }
#	}
    }
    # warn "Begin Processing Final";
    # while (@stack)
    # {
    # 	my $f1= pop @stack;
    # 	warn "Processing $f1";
    # 	$str .= extract($f1);
    # }

    return $str;
}

sub checkbz2
{
    my $filename=shift;
    my $partno =shift;
    #warn "bzip2recover $filename "; # we will process the input file
#    warn "$filename not there" unless -f $filename;
    my $newfile = "error";
    my $pattern = "";
    if ($filename =~ /data\/(.+)/)
    {
	$newfile = "data/rec00002${1}";
	$pattern = "data/rec?????${1}";
	warn "new file is $newfile";
    }
 #   warn "going to extract $newfile with bzip2recover";
    if (!-f "$newfile"   )
    {
	open BZ,"bzip2recover $filename 2>&1 | ";
	while (<BZ>)
	{
	    if (/block (\d+) runs from (\d+) to (\d+)/)
	    {
		my $block = $1;
		my $from = $2;
		my $to   = $3;
		my $size = $to-$from;
		my $fromb = $from/8; # bytes
#	    warn "Found $_";
#	    warn "Block $block size $size";
#	    warn "Block $block from $fromb";
	    }
	    elsif (/writing block \d+ to .(data\/rec\d+osm_planet_dump_part_\d+_.bz2)/)
	    {
		if (-f $1)
		{
		    warn "to process file $1";
		}
		else
		{
		    warn "file not there yet $1";
		}
	    }
	    elsif (/\(incomplete/)
	    {
		die "Downloaded file incomplete\n";
		rename ($filename, "$filename.bad");
		die "filename is bad";
	    }
	    else
	    {
		warn "Other $_";
	    }
	    warn "Bzip2 recover said $_";
	}
	
	close BZ;
    }
    else
    {
#	warn "data has already been split, in $newfile for example";
	#data/rec?????osm_planet_dump_part_5663_.bz2
    }
    
 #   warn "going to look for $pattern";
    my $xml = process_bzip_parts (glob ($pattern));
    open DBG ,">data/debug_output" .$partno . ".xml";
    print DBG $xml;
    close DBG;
    #strip out the leading chars until the final closing tag of any nodes that might be open
    # 
#    if ($xml =~ (/.*<\/node|way|changeset|relation>(.+)/))
    {
	my $len = length($xml);
	my $part = substr($xml,0,1024);
	warn "len:" . length($part);
	warn "data:" . $part . "\n";
	cleanup($part,$partno);

	#last part 
	$part = substr($xml,$len - 1024,$len);
	warn "lenend:" . length($part);
	warn "dataend:" . $part . "\n";
	
    }
    
}

sub Download
{
    my $partno=shift;
    my $url =shift;
    mkdir "data" unless -d "data";
    my $filename = sprintf("data/osm_planet_dump_part_%0.4d_.bz2",$partno);
    my $startpos =  (blocksize * $partno ) -  overlap ; # starting point
    $startpos = 0 if $startpos < 0;    
    my $endpos   =  $startpos + blocksize + overlap;   
    my $filesize = $endpos - $startpos;    
    if (-f $filename)
    {
	my @stat = stat($filename);
	if ($stat[7]== $filesize)
	{
#	    warn "$filename has $filesize";
	}
	else
	{
	    warn "$filename has wrong $filesize";
	    unlink($filename); #remove it, lets download again
	}	    
    }
    if (
	! -f $filename
	)
    {
	print "getting $filename\n";    
	print  " blocksize " . blocksize . "\n";
	
	my  $ua = LWP::UserAgent->new;
	$ua->agent("FOSM API/0.1 ");
	
	my $head = $ua->request(HTTP::Request->new('HEAD'=>$url));
	die "HEAD error: ", $head->request->url, ' - ',
	$head->headers_as_string, "\n"
	    unless $head->is_success;
	
	
	my $cl = $head->content_length();
	die "No content length\n" unless defined $cl;
	die "content length is 0.\n" unless $cl;
	print "$url\nLength on server: ", $cl, "\n";
	
	$endpos = $cl if $endpos > $cl;    
	my $blocks = $cl / blocksize ; # now many blocks in the file	
	printf " getting block # %d of # %d \n", $partno, $blocks;
	
	printf "Requesting %s - %s\n", $startpos, $endpos - 1;
	my $req = HTTP::Request->new('GET' => $url);
	$req->init_header('Range' => sprintf("bytes=%s-%s",
					     $startpos ,
					     $endpos - 1
			  ));
	
	open OUT,">$filename";
	
	my $totaldata = "";
	my $response = $ua->request($req,	
				    sub 
				    {
					my($data, $response, $protocol) = @_; 
					print OUT $data;
				    }
				    
	    );
	print "finished";
	print "\n", $url, " ", scalar(localtime), "\n\n";   
	close OUT;
	
    }
    if (-f $filename)
    {
	my @stat = stat($filename);
	if ($stat[7]== $filesize)
	{
#	    warn "$filename has $filesize";
	    checkbz2 $filename,$partno;
	}
	else
	{
	    warn "$filename has wrong $filesize";
	    unlink($filename); #remove it, lets download again
	    die "cannot get the file $filename";
	}	    
    }
}

sub Main
{
    my $partno = shift ;
    $partno = 0 unless defined $partno;
    my $url = shift || 'http://planet.openstreetmap.org/full-experimental/full-planet-110619-1430.osm.bz2';
    
    if ($partno =~ /^(\d+)$/)
    {
	warn "going to get  $1";
	Download $1,$url;
    }
    elsif ($partno =~ /^(\d+)\-(\d+)$/)
    {
	if ($1<$2)
	{
	    warn "going to get from $1 to $2";
	    
	    for (my $x = $1; $x <= $2; $x++)
	    {
		
		warn "getting $x\n";
		Download $x,$url;
	    }
	}
    }
    
}

#Main (@ARGV);
1;
