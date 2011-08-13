package Geo::HashInline;
use Inline::Struct;
use Inline CPP,
    CONFIG => 
    ENABLE => 'STRUCTS',
    ENABLE => STD_IOSTREAM,
    INC => '-I/usr/include/stlport/', 
    BUILD_NOISY => 1, 
    BUILD_TIMERS => 1 , 
    PRINT_INFO=>1,
#    REPORTBUG =>1 
    ;

#use Inline ;

#use Inline CPP CONFIG => (INC => '-I/usr/include/stlport/', BUILD_NOISY => 1, BUILD_TIMERS => 1 , PRINT_INFO=>1,REPORTBUG =>1 );



1;
__END__
__CPP__
class GeoHash
{
public:
    int add(int x, int y) { 
	return x + y;
};

int subtract(int x, int y) {
    return x - y;
};

};
