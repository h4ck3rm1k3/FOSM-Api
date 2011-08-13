package Geo::HashInline;
use Inline::Struct;
use File::Basename qw(dirname);
use YAML;
use warnings;
use strict;
use Carp;

use Inline CPP => dirname(__FILE__).'/HashInline.cpp',	
    ENABLE => 'STD_IOSTREAM',
    TYPEMAPS =>  dirname(__FILE__).'/HashInline.map',
    INC => '-I/usr/include/stlport/', 
    BUILD_NOISY => 1, 
    BUILD_TIMERS => 1 , 
    ;

sub encode
{
    my $a=shift;
    my $b=shift;
    my $newret = Geo::HashInline::encodestr($a,$b);
    return $newret;
}

1;
__END__
__CPP__
