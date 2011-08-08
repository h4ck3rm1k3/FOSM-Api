# copyright 2009 h4ck3rm1k3@flossk.org
# licensed under GNU Affero General Public License
# http://www.fsf.org/licensing/licenses/agpl-3.0.html
# 
package OSM::API::OsmHistory;

use LWP::UserAgent;
use Compress::Bzip2 qw(:all );
use strict;
use warnings;
use constant overlap    => 1024 * 100;
use constant blocksize  => 280148 * 4; 
use YAML;
#use OSM::API::OsmFile;
use IO::Uncompress::Bunzip2 qw ($Bunzip2Error);
use IO::File;
use XML::SAX;
use OSM::API::OsmHistory::SaxHandler;

sub new
{
    my $class=shift;
    my $self=shift;
    return bless $self,$class;
}
sub     cleanup
{
    my $self=shift;
    my $xml=shift || die "no input";
    my $partno=$self->{partno};
    my $handler = OSM::API::OsmHistory::SaxHandler->new( $partno );
    warn "processing $partno with data len:". length($xml); # 9000066 bytes of data collected
    my $patterns = 
    {
	changeset => '(<changeset.+<\/changeset>)',
	node => '(<node.+(\/>|<\/node>))',
	way => '(<way.+<\/way>)',
	relation => '(<relation.+<\/relation>)',
    };
    warn "key is " . $self->{key};

    my $pattern = $patterns->{$self->{key}}; # lookup the patter
    warn "Pattern is $pattern";

    #..."/><tag k="..." v="..."/></changeset><
    while (
#	($xml =~ /[^\<](<(changeset|node|way|tag|relation|bounds|nd|member)[^\>]+(\/\>|\<\/$2\>))/g)# 
#<\/(changeset|node|way|relation|bounds)>
#	($xml =~ /(<(changeset|node|way|relation|bounds)>.+)/g)# 
#	($xml =~ /(<changeset.+<\/changeset>)/g)# 
	($xml =~ /$pattern/g)# 
	)
    {	
#	warn "Check this 1 $1" ;
#	warn "Check this 2 $2" if $2;
#	warn "Check this 3 $3" if $3;
    	my $data = "<osm>$1</osm>";
#	warn "parse $data";
	my $parser = XML::SAX::ParserFactory->parser(
	    Handler => $handler
	    );
	$parser->parse_string($data);
	$handler->finish_current(); # process the last one 
    }
    $handler->tagstatsdump();

}

sub extract
{
    my $file=shift;
#    warn "Processing zip file $file";
    my @data;
    my $str;
    my $fh=IO::Uncompress::Bunzip2->new( $file) or die "Couldn't open bzipped input file: $Bunzip2Error\n";
    
    while(<$fh>)
    {
	$str .= $_;
    }
#    IO::Uncompress::Bunzip2::bunzip2($file => \@data);
#    $str = join ("",map { $$_ } @data);
#    warn "got $str";
    return $str;
}

sub process_bzip_parts
{

    my @listoffiles= @_;
#    warn join "\n",@listoffiles;
    my @stack;
    my $str;
    foreach my $f (@listoffiles)
    {
#	print "going to process $f\n";
	my @stat=stat($f);
	# print $stat[7] . "\n";
	# if ($stat[7] < 1000)
	# {
#	push @stack,$f;
	# }
	# else
	# {
#	warn "Begin Processing Stack";
#	while (@stack)
#	    {
#		my $f1= pop @stack;
	$str .= extract($f);
	
#	    }
#	}
    }
    # warn "Begin Processing Final";
    # while (@stack)
    # {
    # 	my $f1= pop @stack;
    # 	warn "Processing $f1";
    # 	$str .= extract($f1);
    # }

    return $str;
}

sub checkbz2
{
    my $self=shift;
    my $filename=$self->{filename};
    my $partno =$self->{partno};
    #warn "bzip2recover $filename "; # we will process the input file
#    warn "$filename not there" unless -f $filename;
    my $debugfilename="data/debug_output" .$partno . ".xml";
    my $xml = "";
    if (! -f $debugfilename)
    {
	my $newfile = "error";
	my $pattern = "";
	if ($filename =~ /data\/(.+)/)
	{
	    $newfile = "data/rec00002${1}";
	    $pattern = "data/rec?????${1}";
	    warn "new file is $newfile";
	}
	#   warn "going to extract $newfile with bzip2recover";
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
#		    warn "to process file $1";
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
#	    warn "Bzip2 recover said $_";
	    }
	    
	    close BZ;
	}
	else
	{
#	warn "data has already been split, in $newfile for example";
	    #data/rec?????osm_planet_dump_part_5663_.bz2
	}
	
	#   warn "going to look for $pattern";
	$xml = process_bzip_parts (glob ($pattern));
	
	open DBG ,">$debugfilename";
	print DBG $xml;
	close DBG;
    }
    else
    {
	open IN, "<$debugfilename";
	while (<IN>)
	{
	    $xml .= $_; 
	}
	close IN;
    }

## process
#    my $len = length($xml);
#    my $blocksize = 2048 *1000;
#    my $part = substr($xml,0,$blocksize);
#    warn "len:" . length($part);
#    warn "data:" . substr($part,0,80) . "\n";
#    cleanup($self,$part);

    
    #last part 
#    $part = substr($xml,$len - $blocksize,$len);
#    warn "lenend:" . length($part);
#    warn "dataend:" . substr($part,0,80) . "\n";
#    cleanup($self,$part);
    
    cleanup($self,$xml); # all of it    
}

sub Download
{
    my $self=shift;
    my $partno=$self->{partno};
    my $url =$self->{url};
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
#	    warn "$filename has $filesize";
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
#	    warn "$filename has $filesize";
	    $self->{filename}=$filename,
	    checkbz2 $self;
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
    
    my $positions = 
    {
	changeset => 1,
	node => 272,
	way => 17910,
	relation => 25029,
#	end => 25282
    };

    
    if ($partno =~ /^(\d+)$/)
    {
	warn "going to get  $1";
	my $self = OSM::API::OsmHistory->new ({
	    positions => $positions,
	    url => $url,
	    partno => $partno
	});
	
	foreach my $k (keys %{$positions})
#	foreach my $k ("way")
	{
	    $self->{partno}=$positions->{$k};
	    $self->{key}=$k;
	    $self->{offset}=$partno;# the offset into the indexes we want to get
	    $self->Download ();
	}
    }
    elsif ($partno =~ /^(\d+)\-(\d+)$/)
    {
	if ($1<$2)
	{
	    warn "going to get from $1 to $2";
	    
	    for (my $x = $1; $x <= $2; $x++)
	    {		
		warn "getting $x\n";
		Download 
		{
		    positions => $positions,
		    url => $url,
		    partno => $x
		};
#$x,$url;
	    }
	}
    }
    
}

#Main (@ARGV);
1;
