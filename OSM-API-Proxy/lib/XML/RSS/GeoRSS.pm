package XML::RSS::GeoRSS;
use strict;
use warnings;
use YAML;
use XML::GML::Point;
use XML::GML::Point::pos;

#	$self->{'items'}->[$self->{num_items}-1]->{$ns}->{ $el }=
	    #http://www.georss.org/georss where
	    #http://www.opengis.net/gml Point
	    #http://www.opengis.net/gml pos
#		    warn "Check $ns :" . Dump($self->current_element);
#		    warn "Check" . Dump($cdata);

#		<georss:where>
#<gml:Point>
#<gml:pos>47.05 -66.22</gml:pos>

sub new
{
    my $class=shift;
    my $self ={
	stack =>[],
#	chars => "",
    };
    return bless $self,$class;
}

sub handle_char
{
    my $self=shift;
    my $parser =shift;
    my $cdata  = shift;

    if ($cdata=~ /^\s+$/)
    {
	return; # skip ws
    }
#    warn "char $cdata";
#    warn Dump($self);
    my $top =    $self->{stack}->[-1];
    if ($top)
    {
	$top->handle_char($cdata);
    }
    else
    {
#	$self ->{chars} .= $cdata;
	die "we dont need chars here";
    }
}

sub handle_start {
    my $self = shift;
    my $parser =shift;
    my $el   = shift;
    my $attribs = shift;
#    warn "start $el";
#    push @{$self->{stack}},[$el,$attribs];

    if ($el eq "Point")
    {
	my $point =XML::GML::Point->new();	
	push @{$self->{stack}},$point;
    }
    elsif ($el eq "pos")
    {
	my $pos =XML::GML::Point::pos->new();	
	my $point =$self->{stack}->[-1]; 
	# todo check 
	$point->set_pos($pos);
	push @{$self->{stack}},$pos;	
    } 
    else
    {
	die "unknown $el";
    }
}

sub handle_end {
    my $self = shift;
    my $parser =shift;
    my $el   = shift;
#    warn "end $el";
    my $obj=pop @{$self->{stack}};
    
    if (!@{$self->{stack}})
    {
	delete $self->{stack};
	$self->{GeoObj}=$obj;
    }
}

# 
1;
