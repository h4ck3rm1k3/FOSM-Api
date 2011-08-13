#use Geo::HashInline;
#    ENABLE => 'STRUCTS',
#package Geo::HashInline;

use strict; 
use warnings;

#use Inline::Struct;
use File::Basename qw(dirname);
use YAML;
use Inline CPP => dirname(__FILE__).'/017_inline.cpp',	
#  CONFIG => 
  #STRUCTS =>  ["GeoHash"],
#  ENABLE => 'STRUCTS',
    ENABLE => 'STD_IOSTREAM',
    TYPEMAPS =>  dirname(__FILE__).'/017_typemap.map',
    INC => '-I/usr/include/stlport/', 
  BUILD_NOISY => 1, 
  BUILD_TIMERS => 1 , 
#  PRINT_INFO=>1,
 # REPORTBUG =>1 
    ;

#use Inline 

my $gh = new main::GeoHash();
$gh->init();
my $p = new main::Point(32,29);

#warn "Check" . Dump(\%main::Geohash::);
#warn "Check" . Dump(\%main::);
#warn Dump($gh);

#$p->set_lat(32);
#$p->set_lon(29);
#32,29
#warn Dump  $gh->encode1(10,23);
#warn Dump  $gh->encode2($p);

#warn main::GeoHash::encode2($p);
#warn encode(12,23);
#main::GeoHash::encode($p);
#main::testmain();
use Geo::Hash;

our $gh2 = Geo::Hash->new;
my $hash = doencode( 12, 23 );

warn "we got " . main::encodestr(12,23);
use Benchmark;

foreach my $lat (1 .. 10){    
    foreach my $lon (1 .. 10)
    {       	my $a=5*$lat;	my $b= 7 * $lon;	

		my $oldret = doencode($a,$b);
		my $newret = main::encodestr($a,$b);
		warn "$a $b old:$oldret new:$newret";
    }}


sub doencode
{
    return $gh2->encode(@_);
}

#[][[[[[[[]

#Benchmark: timing 10000 iterations of New, Old...
#       New:  2 wallclock secs ( 2.22 usr +  0.01 sys =  2.23 CPU) @ 4484.30/s (n=10000)
#       Old: 57 wallclock secs (53.49 usr +  0.47 sys = 53.96 CPU) @ 185.32/s (n=10000)

use Benchmark qw(:all) ;

#    timethis ($count, "code");

    # Use Perl code in strings...
    timethese(500, {
        'New' => 'foreach my $lat (1 .. 10){    foreach my $lon (1 .. 10){       	my $a=5*$lat;	my $b= 7 * $lon;	main::encodestr($a,$b);}}',
        'Old' => 'foreach my $lat (1 .. 10){    foreach my $lon (1 .. 10){       	my $a=5*$lat;	my $b= 7 * $lon;	doencode($a,$b);}}',
    });


#$gh->input=$p;
#$gh->encode3();
#warn Dump  $gh->output;



1;

