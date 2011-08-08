use Geo::HashInline;
use Geo::HashFast;
use Geo::Hash;

#print add(9,16);

use Benchmark qw(:all);
my $gh = Geo::Hash->new;
my $gh = Geo::HashFast->new;


timethese($count, {
'normal' => sub {
    my	 $lat =43;
    my	 $lon =18;
    my $hash = $gh->encode( $lat, $lon );		 
},
'inline' => sub {
    my	 $lat =43;
    my	 $lon =18;
    my $hash = $gh2->encode( $lat, $lon );		 

	 } 
});
