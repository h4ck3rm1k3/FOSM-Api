use Test;
BEGIN { plan tests => 10 }

ok(1);

my $obj1 = Soldier->new('Benjamin', 'Private', 11111);
my $obj2 = Soldier->new('Sanders', 'Colonel', 22222);
my $obj3 = Soldier->new('Matt', 'Sergeant', 33333);

for my $obj ($obj1, $obj2, $obj3) {
   print $obj->get_serial, ") ",
         $obj->get_name, " is a ",
         $obj->get_rank, "\n";
}

ok($obj1->get_serial, 11111);
ok($obj1->get_name,   'Benjamin');
ok($obj1->get_rank,   'Private');

ok($obj2->get_serial, 22222);
ok($obj2->get_name,   'Sanders');
ok($obj2->get_rank,   'Colonel');

ok($obj3->get_serial, 33333);
ok($obj3->get_name,   'Matt');
ok($obj3->get_rank,   'Sergeant');

###############################################################################

use File::Basename qw(dirname);
use Inline CPP => dirname(__FILE__).'/soldier.cpp',	
  ENABLE => STD_IOSTREAM,
  INC => '-I/usr/include/stlport/', 
  BUILD_NOISY => 1, 
  BUILD_TIMERS => 1 , 
#  PRINT_INFO=>1,
#  REPORTBUG =>1 
   ;
#use Inline 'C++' => <<END;

1;
