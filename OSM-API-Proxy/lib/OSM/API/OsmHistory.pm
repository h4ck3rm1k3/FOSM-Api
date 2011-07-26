# copyright 2009 h4ck3rm1k3@flossk.org
# licensed under GNU Affero General Public License
# http://www.fsf.org/licensing/licenses/agpl-3.0.html
# 
package OSM::API::OsmHistory;

use LWP::UserAgent;
use Compress::Bzip2 qw(:all );
use strict;
use warnings;
use constant overlap    => 1024;
use constant blocksize  => 280148 * 4; 
use YAML;
use IO::Uncompress::Bunzip2 ;

sub process_bzip_parts
{
    my @listoffiles= @_;
    warn join "\n",@listoffiles;
    my @stack;
    foreach my $f (@listoffiles)
    {
#	print "going to process $f\n";
	my @stat=stat($f);
	print $stat[7] . "\n";
	if ($stat[7] < 1000)
	{
	    push @stack,$f;
	}
	else
	{
	    warn "Begin Processing Stack";
	    my @data;
	    while (@stack)
	    {
		my $f1= pop @stack;
		warn "Processing zip file $f1";
		my $data;
		IO::Uncompress::Bunzip2::bunzip2($f1 => \@data);

		warn "Got data" . join "\n", Dump(@data);
	    }
	}
    }

    warn "Begin Processing Final";
    while (@stack)
    {
	my $f1= pop @stack;
	warn "Processing $f1";
    }

}

sub checkbz2
{
    my $filename=shift;
    warn "bzip2recover $filename "; # we will process the input file
    warn "$filename not there" unless -f $filename;

    my $newfile = "error";

    my $pattern = "";

    if ($filename =~ /data\/(.+)/)
    {
	$newfile = "data/rec00002${1}";
	$pattern = "data/rec?????${1}";
	warn "new file is $newfile";

    }
    warn "going to extract $newfile with bzip2recover";
    if (!-f "$newfile"   )
    {
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
#	    warn "Found $_";
#	    warn "Block $block size $size";
#	    warn "Block $block from $fromb";
	    }
	    elsif (/writing block \d+ to .(data\/rec\d+osm_planet_dump_part_\d+_.bz2)/)
	    {
		if (-f $1)
		{
		    warn "to process file $1";
		}
		else
		{
		    warn "file not there yet $1";
		}
	    }
	    elsif (/\(incomplete/)
	    {
		die "Downloaded file incomplete\n";
		rename ($filename, "$filename.bad");
		die "filename is bad";

	    }
	    else
	    {
		warn "Other $_";
	    }

	    warn "Bzip2 recover said $_";
	}
	
	close BZ;
    }
    else
    {
	warn "data has already been split, in $newfile for example";
	#data/rec?????osm_planet_dump_part_5663_.bz2

    }
    
    warn "going to look for $pattern";
    process_bzip_parts glob ($pattern);
    
}


sub Download
{
    my $partno=shift;
    my $url =shift;

    mkdir "data" unless -d "data";
    my $filename = sprintf("data/osm_planet_dump_part_%0.4d_.bz2",$partno);
    my $startpos =  (blocksize * $partno ) -  overlap ; # starting point
    $startpos = 0 if $startpos < 0;    
    my $endpos   =  $startpos + blocksize + overlap;   
    my $filesize = $endpos - $startpos;    


    if (-f $filename)
    {
	my @stat = stat($filename);
	if ($stat[7]== $filesize)
	{
	    warn "$filename has $filesize";
	}
	else
	{
	    warn "$filename has wrong $filesize";
	    unlink($filename); #remove it, lets download again
	}	    
    }
   

    if (
	! -f $filename
	)
    {
	print "getting $filename\n";    
	print  " blocksize " . blocksize . "\n";
	
	my  $ua = LWP::UserAgent->new;
	$ua->agent("FOSM API/0.1 ");
	
	my $head = $ua->request(HTTP::Request->new('HEAD'=>$url));
	die "HEAD error: ", $head->request->url, ' - ',
	$head->headers_as_string, "\n"
	    unless $head->is_success;
	
	
	my $cl = $head->content_length();
	die "No content length\n" unless defined $cl;
	die "content length is 0.\n" unless $cl;
	print "$url\nLength on server: ", $cl, "\n";
	
	$endpos = $cl if $endpos > $cl;    
	my $blocks = $cl / blocksize ; # now many blocks in the file	
	printf " getting block # %d of # %d \n", $partno, $blocks;
	
	printf "Requesting %s - %s\n", $startpos, $endpos - 1;
	my $req = HTTP::Request->new('GET' => $url);
	$req->init_header('Range' => sprintf("bytes=%s-%s",
					     $startpos ,
					     $endpos - 1
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
	
    }

    if (-f $filename)
    {
	my @stat = stat($filename);
	if ($stat[7]== $filesize)
	{
	    warn "$filename has $filesize";
	    checkbz2 $filename;
	}
	else
	{
	    warn "$filename has wrong $filesize";
	    unlink($filename); #remove it, lets download again
	    die "cannot get the file $filename";
	}	    
    }
    
    

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
