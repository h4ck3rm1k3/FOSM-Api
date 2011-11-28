package OSM::API::Tag;

use Moose;
use Moose::Util::TypeConstraints;
#use MooseX::SemiAffordanceAccessor;

has 'k' => (is=>'rw', isa=>'Str');
has 'v' => (is=>'rw', isa=>'Str');
#use XML::Code;
use HTML::Entities;
sub emit_OSM
{
    my $self=shift;

    print "<tag " .
	" k=\"" . $self->{k} . '"' .
	" v=\"" . encode_entities($self->{v}) . '"' .
        "/>\n";
}


1;
