# copyright 2009 h4ck3rm1k3@flossk.org
# licensed under GNU Affero General Public License
# http://www.fsf.org/licensing/licenses/agpl-3.0.html
# 
package OSM::API::OsmHistory;

use LWP::UserAgent;
use Compress::Bzip2 qw(:all );
use strict;
use warnings;
use constant overlap => 700000;
use constant blocksize => 5000000;
use constant  chunksize => 5000000;

sub c 
{
    return shift;
}

sub bunzip {
    my $data = shift;
    my $ret = '';   
    my $stream = Compress::Bzip2::decompress_init();
    $ret = $stream->add($data);
    $stream->finish;    
    return $ret;
}

sub checkbz2
{
    my $filename=shift;

    open BZ,"bzip2recover $filename 2>&1 | ";
    while (<BZ>)
    {
	if (/block (\d+) runs from (\d+) to (\d+)/)
	{
	    my $block = $1;
	    my $from = $2;
	    my $to   = $3;
	    my $size = $to-$from;
	    my $fromb = $from/8; # bytes
	    warn "Found $_";
	    warn "Block $block size $size";
	    warn "Block $block from $fromb";
	}
	else
	{
#		warn "Other $_";
	}
	print $_;
    }
    close BZ;
    
}

sub callback
{
    my($data, $response, $protocol) = @_; 
    print OUT $data;
    my $len = length($data);
}


sub Download
{
    my $partno=shift;
    my $url =shift;

    mkdir "data" unless -d "data";

    my $filename = sprintf("data/osm_planet_dump_part_%0.4d_.bz2",$partno);
    print "getting $filename\n";    
    print  " chunksize " . chunksize . "\n";
    
    my  $ua = LWP::UserAgent->new;
    $ua->agent("WikipediaDownload/0.1 ");
    
    my $head = $ua->request(HTTP::Request->new('HEAD'=>$url));
    die "HEAD error: ", $head->request->url, ' - ',
    $head->headers_as_string, "\n"
	unless $head->is_success;
    
    
    my $cl = $head->content_length();
    die "No content length\n" unless defined $cl;
    die "content length is 0.\n" unless $cl;
    print "$url\nLength on server: ", $cl, "\n";
    
    
    my $stream = undef;
    $stream = Compress::Bzip2::decompress_init();
    
    
    my $startpos =  (blocksize * $partno ) -  overlap ; # starting point
    $startpos = 0 if $startpos < 0;
    
    my $endpos   =  $startpos + blocksize + overlap;
    
    $endpos = $cl if $endpos > $cl;
    
    my $blocks = $cl / chunksize ;
    
    printf " getting chunk # %d of # %d \n", $partno, $blocks;
    
    printf "Requesting %s - %s\n", $startpos, $endpos - 1;
    my $req = HTTP::Request->new('GET' => $url);
    $req->init_header('Range' => sprintf("bytes=%s-%s",
					 $startpos ,
					 $endpos - 1
		      ));
    
    open OUT,">$filename";
    
    my $response = $ua->request($req,	\&callback );
    
    print "finished";
    print "\n", $url, " ", scalar(localtime), "\n\n";   
    close OUT;
    
    checkbz2 $filename;

}


sub Main
{
    my $partno = shift ;
    $partno = 0 unless defined $partno;
    my $url = shift || 'http://planet.openstreetmap.org/full-experimental/full-planet-110619-1430.osm.bz2';
 
    if ($partno =~ /^(\d+)$/)
{
    warn "going to get  $1";
    Download $1,$url;
}
elsif ($partno =~ /^(\d+)\-(\d+)$/)
{
    if ($1<$2)
    {
	warn "going to get from $1 to $2";

	for (my $x = $1; $x <= $2; $x++)
	{

	    warn "getting $x\n";
	    Download $x,$url;
	}
    }
}

}

#Main (@ARGV);
1;
