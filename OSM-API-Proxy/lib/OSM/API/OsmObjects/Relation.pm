package OSM::API::OsmObjects::Relation;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;

our @ISA = qw[OSM::API::OsmObjects::BaseGeo];
BEGIN
{
    open RPT, ">data/debugreportrelation.txt";
}

END
{
    close RPT;
}

sub new 
{
    my $class=shift;
    my $self =shift;
    $self->{tags}=    $self->{tags} ||{}; # create an empty hash of the tags
    $self->{nodes}=    $self->{nodes} ||[]; # create an empty array of the nodes
    return bless $self,$class;
}
sub hash
{
    my $self=shift;
    $self->{hash}="todo12";
}

sub Split
{
    my $self =shift;
    #write this node to the right file
    my $hash = $self->hash();
    my @path = split (//, $hash);
    
    my $split = 5;
    my $len = scalar(@path);
    if ($len <= $split)
    {
	$split = $len -2; # 1    
    }	

    my @dirs = @path[0 .. $split];
    my @name = @path[$split+1 .. scalar(@path) -1];
#    my $test= join ("/",@path);
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);

    print RPT $self->SUPER::BasicInfoStr("$hash is split to $out and $out_file"); 
    my $file = $out. "/nodes_" . ${out_file} . "_p" . $self->{partno} . ".osm";
    open OUT,">>$file";
    binmode OUT, ":utf8";
#<relation id="2284" version="9" timestamp="2008-12-16T17:03:15Z" changeset="419694" user="Cerritus" uid="12919" visible="true"><member type="node" ref="41847021" role="stop_5"/><member type="node" ref="46932840" role="stop_9"/><
    my $str = "<relation " .  join (" ", 
				map { 
				    if ($self->{$_})
				    {
					$_ . "='"  . $self->{$_} . "'"
				    }
				    else
				    {
					""	
				    }
				} ('id', 'uid', 'user',  'visible',  'version',  'changeset')
	) ;
    $str .= ">"; # end of node start	
	# emit the tags, very cheap
    $str .= join (" ", map {
	my $k = $_;
	my $v = $self->{tags}{$k};
	"<tag k='$k' v='$v' />"
		  } (keys %{$self->{tags}}))	;
    

    my @types = (keys %{$self->{members}});		  
    $str .= join (" ", map 
		  {
		      my $type = $_;	
		      map {
			  my $role = $_;
			  map {
			      my $ref=$_;
			      "<member type=$type role=$role  ref=$ref/>";
			  } (@{$self->{members}{$type}{$role}});
		      } (keys %{$self->{members}{$type}});
		  } @types
	);
    $str .= "</relation>\n;"; 
    
    print OUT $str;
    close OUT;
}

sub addMember
{
    my $self=shift;
    my $type=shift;
    my $role=shift;
    my $ref=shift;
    
    push(@{$self->{'members'}{$type}{$role}},$ref);

}
1;
