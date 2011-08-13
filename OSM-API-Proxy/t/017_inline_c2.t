use File::Spec;
use lib (File::Spec->catdir(File::Spec->updir(),'blib','lib'), File::Spec->catdir(File::Spec->curdir(),'blib','lib'));
use strict;
use Test;
use diagnostics;
#use Inline Config => DIRECTORY => '_Inline_test';

BEGIN {
    plan(tests => 5, 
	 todo => [],
	 onfail => sub {},
	);
}
#use Inline Config => 
#           DIRECTORY => '_Inline_test';

# test 1 - Check string syntax
ok(add(3, 7) == 10);
# test 2 - Check string syntax again
ok(subtract(3, 7) == -4);
# test 3 - Check DATA syntax
ok(multiply(3, 7) == 21);
# test 4 - Check DATA syntax again
ok(divide(7, -3) == -2);

use Inline 'C';
use Inline C => 'DATA';
use Inline C => <<'END_OF_C_CODE';

int add(int x, int y) {
    return x + y;
}

int subtract(int x, int y) {
    return x - y;
}
END_OF_C_CODE

Inline->bind(C => <<'END');

int incr(int x) {
    return x + 1;
}
END

# test 5 - Test Inline->bind() syntax
ok(incr(incr(7)) == 9);

__END__

# unused code or maybe AutoLoader stuff
sub crap {
    return 'crap';
}

__C__

int multiply(int x, int y) {
    return x * y;
}

__C__

int divide(int x, int y) {
    return x / y;
}
