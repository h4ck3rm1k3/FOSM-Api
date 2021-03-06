package OSM::API::OsmHistory::SaxHandler;
use  OSM::API::OsmObjects;
use  OSM::API::OsmObjects::Relation;
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
#	    warn "check type $type";
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
#    warn "got $name\n";
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

	my $n = OSM::API::OsmObjects::Relation->new(
	    {
		partno => $self->{partno},
		id        => $element->{'Attributes'}{'{}id'}{"Value"}, 
		changeset      => $element->{'Attributes'}{'{}changeset'}{"Value"}, 
		version      => $element->{'Attributes'}{'{}version'}{"Value"}, 
		visible      => $element->{'Attributes'}{'{}visible'}{"Value"}, 
		timestamp => $element->{'Attributes'}{'{}timestamp'}{"Value"},
		user => $element->{'Attributes'}{'{}user'}{"Value"},
		uid => $element->{'Attributes'}{'{}uid'}{"Value"}
	    }
	    );
	$self->finish_current();# finish the last one
	$self->{current}=$n;

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
#	warn Dump()
        push(@{$self->{current}{'nodes'}},
             $element->{'Attributes'}->{'{}ref'}{Value});
#	$self->{node}{
    }
    elsif (($element->{Name} eq 'member') )
    {
#	warn Dump($element);
# Attributes:
#   '{}ref':
#     Value: 8662500
#   '{}role':
#     Name: role
#     Value: ''
#   '{}type':
#     Value: way

	$self->{current}->addMember(
	    $element->{'Attributes'}->{'{}type'}{Value},
	    $element->{'Attributes'}->{'{}role'}{Value} ,
	    $element->{'Attributes'}->{'{}ref'}{Value}
	    );


        # push(
	#     @{

	# 	$self->{current}{'members'}
	# 	{
	# 	    $element->{'Attributes'}->{'{}type'}{Value}
	# 	}
	# 	{
	# 	    $element->{'Attributes'}->{'{}role'}{Value} 
	# 	}

	#      },
	#     $element->{'Attributes'}->{'{}ref'}{Value}
	#     );

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
