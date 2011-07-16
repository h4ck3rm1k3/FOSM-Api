# Use the program 'html2pod' that comes in this dist, or:
use Pod::HTML2Pod;
my $file = shift @ARGV;

print Pod::HTML2Pod::convert(
    'file' => $file,  # input file
    'a_href' => 1,  # try converting links
    );
