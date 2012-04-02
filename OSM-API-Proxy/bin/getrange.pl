use LWP::UserAgent;
use HTTP::Request;
my  $ua = LWP::UserAgent->new;
$ua->agent("FOSM API/0.1 ");
my $url = 'http://fosm.org/planet/earth-20120328140729.osm.bz2';
my $head = $ua->request(HTTP::Request->new('HEAD'=>$url));
my $startpos=635177;
my $endpos=805375;
my $filename= "test.bz2";
printf "Requesting %s - %s\n", $startpos, $endpos ;
my $req = HTTP::Request->new('GET' => $url);
$req->init_header('Range' => sprintf("bytes=%s-%s",
                                     $startpos ,
                                     $endpos 
                  ));
open OUT,">$filename";
my $totaldata = "";
my $response = $ua->request($req,	
                            sub 
                            {
                                my($data, $response, $protocol) = @_; 
                                print OUT $data;
                            }                           
    );
print "finished";
print "\n", $url, " ", scalar(localtime), "\n\n";   
close OUT;

