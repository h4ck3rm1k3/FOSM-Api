package OSM::API::OsmObjects::Node;
#use Moose;
#use MooseX::Types::DateTimeX qw( DateTime );
use Geo::Hash;


my $gh = Geo::Hash->new;

# has 'id' =>
#     is => "rw",
#     isa => "Num",
#     ;

# has 'timestamp' =>
#     is => "rw",
# #    isa => "DateTime",
#     isa => "Str",
#     ;

# # what part of the osm planet is this
# has 'partno' =>
#     is => "rw",
#     isa => "Num",
#     ;

# has 'user' =>
#     is => "rw",
#     isa => "Str",
#     ;

# has 'visible' =>
#     is => "rw",
#     isa => "Str", #true
#     ;

# has 'version' =>
#     is => "rw",
#     isa => "Num", #true
#     ;

# has 'changeset' =>
#     is => "rw",
#     isa => "Num", #true
#     ;

# has 'lat' =>
#     is => "rw",
#     isa => "Num", #true
#     ;

# has 'lon' =>
#     is => "rw",
#     isa => "Num", #true
#     ;

# has 'hash' =>
#      is => "rw",
#      isa => "Str", #true
#     ;

# #has_element 'tags' =>
# #    is => "ro",

sub lat
{
    my $self=shift;
    return $self->{lat};
}

sub hash
{
    my $self=shift;
    my $val =shift;
    if ($val)
    {
	$self->{hash}=$val;
    }
    else
    {
	return $self->{hash};
    }
}

sub lon
{
    my $self=shift;
    return $self->{lon};
}

sub partno
{
    my $self=shift;
    return $self->{partno};
}

sub new 
{
    my $class=shift;
    my $self =shift;
    return bless $self,$class;
}

sub Hash
{
    my $self=shift;
    my $hash = $gh->encode( $self->lat, $self->lon );
    $self->hash($hash);
#    warn $self->lat . ",".  $self->lon . " " . $self->hash;
}

sub ProcessHistory
{
    my $self=shift;
    $self->Hash();
}

#use YAML;
use File::Path qw(make_path remove_tree);
sub Split
{
    my $self =shift;
    #write this node to the right file
    my $hash = $self->hash();
    my @path = split (//, $hash);
    
    my $split = 5;
    my @dirs = @path[0 .. $split];
    my @name = @path[$split+1 .. scalar(@path) -1];
#    my $test= join ("/",@path);
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);
#    warn "$hash is split to $out and $out_file" ;
    my $file = $out. "/nodes_" . ${out_file} . "_p" . $self->partno . ".osm";
    open OUT,">>$file";
    my $str = "<node " .  join (" ", 
				map { 
				    if ($self->{$_})
				    {
					$_ . "='"  . $self->{$_} . "'"
				    }
				    else
				    {
					""	
				    }
				} ('id' , 'timestamp',  'user',  'visible',  'version',  'changeset',  'lat', 'lon')
	) . "></node>\n";
#    warn $str;
    print OUT $str;
    close OUT;
}

1;
