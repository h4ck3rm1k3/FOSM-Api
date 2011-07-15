package OSM::API::User;
use OSM::API::User;

use Moose;
use Moose::Util::TypeConstraints;
#use MooseX::SemiAffordanceAccessor;

has 'name' => (is=>'rw', isa=>'Str');
has 'uid' => (is=>'rw', isa=>'Int');
has 'password' => (is=>'rw', isa=>'Str');
has 'home_location' => (is=>'rw', isa=>'OSM::API::Point');

has 'Foaf' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'ChangeSets' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# we want to allow users to define styles 
has 'Styles' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# gallery
has 'Pictures' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# Websites
# Facebook
# Diapora
# twitter
has 'Website' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'OpenIds' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# a list of other api servers
has 'ApiServers' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# a list of other api servers
has 'Tasks' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'Projects' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'Meetings' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'Schedule' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

has 'Servers' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# a list of other users we follow
has 'Friends' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

# the internal blog
has 'Blog' => (
    is=>'rw', 
    isa=>'ArrayRef'

);

sub get_uid
{
    my $self=shift;
    return $self->userObj()->uid();
}

sub user
{
    my $self=shift;
    return $self->userObj()->name();
}

1;
