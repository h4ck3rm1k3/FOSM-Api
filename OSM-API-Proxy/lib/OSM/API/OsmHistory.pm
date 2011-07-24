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

sub process_bzip_parts
{
    my @listoffiles= @_;
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
	    while (@stack)
	    {
		my $f1= pop @stack;
		warn "Processing $f1";
	    }
	}
#	 0 dev      device number of filesystem
#                 1 ino      inode number
#                 2 mode     file mode  (type and permissions)
#                 3 nlink    number of (hard) links to the file
#                 4 uid      numeric user ID of file's owner
#                 5 gid      numeric group ID of file's owner
#                 6 rdev     the device identifier (special files only)
#                 7 size     total size of file, in bytes
#                 8 atime    last access time in seconds since the epoch
#                 9 mtime    last modify time in seconds since the epoch
#                10 ctime    inode change time in seconds since the epoch (*)
#                11 blksize  preferred block size for file system I/O
#                12 blocks   actual number of blocks allocated

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
    warn "bzip2recover $filename ";
    die "$filename not there" unless -f $filename;

    my $newfile = "error";

    my $pattern = "";

    if ($filename =~ /data\/(.+)/)
    {
	$newfile = "data/rec00001${1}";
	$pattern = "data/rec?????${1}";
	warn "new file is $newfile";

    }

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
		    die "file not there $1";
		}
	    }

	    else
	    {
		warn "Other $_";
	    }
#	print $_;
	}
	
	close BZ;
    }
    else
    {
	warn "data has already been split, in $newfile for example";
	#data/rec?????osm_planet_dump_part_5663_.bz2

    }

    process_bzip_parts glob ($pattern);
    
}


sub Download
{
    my $partno=shift;
    my $url =shift;

    mkdir "data" unless -d "data";


    my $filename = sprintf("data/osm_planet_dump_part_%0.4d_.bz2",$partno);
    if (! -f $filename)
    {
	print "getting $filename\n";    
	print  " chunksize " . chunksize . "\n";
	
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
