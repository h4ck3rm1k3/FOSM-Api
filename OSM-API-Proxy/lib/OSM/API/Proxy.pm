package OSM::API::Proxy;
use Dancer ':syntax';
use YAML;
use Dancer::Plugin::DBIC qw(schema);
use Data::Dumper;
our $VERSION = '0.01';

#use Inline CPP => dirname(__FILE__).'/Proxy.cpp',	    ENABLE => 'STD_IOSTREAM',    TYPEMAPS =>  dirname(__FILE__).'/HashInline.map',    INC => '-I/usr/include/stlport/',     BUILD_NOISY => 1,     BUILD_TIMERS => 1 ,     ;

#use Inline CPP ;

# sub get_oauth_test {
#     my $param
# #http://api06.dev.openstreetmap.org/oauth/request_token
#     my $url = 'http://api06.dev.openstreetmap.org/oauth/request_token' . $param;
# #/OSM-API-Proxy/public/dispatch.cgi/oauth/request_token?oauth_consumer_key=yUV5Mk9FZYEGdFEfZ786AiMl6R9D0flYWXsu10bQ&oauth_nonce=7FC225BF-FD81-3D53-49AC-60FD5BD81893&oauth_signature=XYvNFs0L%2Bdl2h72pskA47l7jEBw%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1333067078
#     warn "Url $url";
# #http://api06.dev.openstreetmap.org/oauth/request_token?oauth_signature=XYvNFs0L+dl2h72pskA47l7jEBw=&oauth_timestamp=1333067078&oauth_nonce=7FC225BF-FD81-3D53-49AC-60FD5BD81893&oauth_consumer_key=yUV5Mk9FZYEGdFEfZ786AiMl6R9D0flYWXsu10bQ&oauth_signature_method=HMAC-SHA1&
#     my $req = HTTP::Request->new("GET", $url);
#     my $res= $ua->request($req,)->as_string;
#     warn $res;
#     print $res;
# }

get '/' => sub {
    template 'index.tt', {}, { layout => undef };
};

get '/api' => sub {
    template 'api.tt', {}, { layout => undef };
};

get '/api/capabilities/test' => sub {
    template 'capabilities.tt', {}, { layout => undef };
};

get '/api/changes' => sub {
    my $zoom = params->{zoom} || 12;
	my $start = params->{start} ;
    my $end = params->{end} ;
    my $hours = params->{end} ;
    # query nodes table 
    # TODO 
    template 'changes.tt', {}, { layout => undef };
};

# see source code 
#  def capabilities in api_controller.rb in rails/app/controllers/api_controller.rb
get '/api/capabilities' => sub {


     
    ' <osm version="0.6" generator="Interface to OpenStreetMap server via dancer">
   <api>
     <version minimum="0.6" maximum="0.6"/>
     <area maximum="0.25"/>
     <tracepoints per_page="5000"/>
     <waynodes maximum="2000"/>
     <changesets maximum_elements="50000"/>
     <timeout seconds="300"/>
   </api>
 </osm>';
};

# get 'http://www.openstreetmap.org/api/0.6/map' => sub 
# {
#     template 'getmapbbox.tt', 
#     { 
#     }
#     , 
#     { layout => undef };

# };
# #http://www.openstreetmap.org/api/0.6/user/preferences/MerkaartorPrefsXML005
# #http://www.openstreetmap.org/api/0.6/user/preferences/MerkaartorPrefsXML006

get '/api/0.6/user/preferences/' => sub {
'<osm version="0.6" generator="OpenStreetMap server">
    <preferences>
       <preference k="somekey" v="somevalue" />
    </preferences>
  </osm>
';
};

# /api/0.6/user/details
get '/api/0.6/user/details' => sub {
'<osm version="0.6" generator="OpenStreetMap server">
    <user>
       <preference k="somekey" v="somevalue" />
    </usr>
  </osm>
';
};

get '/api/0.6/trackpoints' => sub {
};

get '/oauth/crossdomain.xml' => sub {
    template 'crossdomain.xml.tt', {},
    { layout => undef };
};

#use Net::OAuth::Client;
use LWP::UserAgent;
use YAML;
use URI::Escape ();


#public/dispatch.cgi/oauth/callback?oauth_token=BXg9GZJsuJgS6JVVKpM6xLZo2OnzALAmTgIzwkW1&oauth_verifier=z8hz4Fd7tLhkkdg5pqOA
get '/oauth/callback' => sub 
{
    my %querystring_params = params('query');
    my $verifier= $querystring_params{"oauth_verifier"} ;
    my $dumpstr=	  Dump({ headers => request->headers,
			 params  => request->params
		       });
    return "<h1>verifier : $verifier</h1>"
	. "<h2>Hello WOrld</h2>" .$dumpstr;

};


#use OAuth::Lite::Util qw(:all);
#use OAuth::Lite::ServerUtil;
#use OAuth::Lite::AuthMethod qw(:all);
#use OAuth::Lite::Problems qw(:all);
use Net::OAuth::RequestTokenRequest;
use Net::OAuth::AccessTokenResponse;
use Try::Tiny;
#from Jifty::Plugin::OAuth::Token
sub generate_token {
    return join '', map { unpack('H2', chr(int rand 256)) } 1..10;
}


#/FOSM-Api/OSM-API-Proxy/public/dispatch.cgi/oauth/access_token?
#oauth_consumer_key=yUV5Mk9FZYEGdFEfZ786AiMl6R9D0flYWXsu10bQ
#oauth_nonce=F45F84A9-BB0C-4EAC-9C14-685E376B8F82
#oauth_signature=bYccFXFyVxDdJaADU%2F9rHMJtsz0%3D
#oauth_signature_method=HMAC-SHA1
#oauth_timestamp=1333190866
#oauth_token=19a8829c206931010a2d

get '/oauth/access_token' => sub {
#    "OK";
#     my %params = request->params;
#     my $oarequest = Net::OAuth->request("access token")->from_hash(
# 	{
# 	    %params,
# #	    'oauth_token'=>$params{oauth_token},
# 	    'callback'=>'oob',
# 	},
# 	'consumer_secret' => 'jJs8XFPjywSyrVlwkNvLanh7ZVyHaJWTQHWFOn1U',
# 	'consumer_key' => 'jJs8XFPjywSyrVlwkNvLanh7ZVyHaJWTQHWFOn1U',
# 	'token_secret' => 'jJs8XFPjywSyrVlwkNvLanh7ZfsdfsfdVyHaJWTQHWFOn1U',
# 	'request_method' => 'GET',
# 	'timestamp' => '1333185703',
# 	'nonce' => 'F2EBB736-C47E-BF79-5A65-680F6D2DC424',
# 	'signature_method' => 'HMAC-SHA1',
# 	'request_url' => 'http://pine02.fosm.org/FOSM-Api/OSM-API-Proxy/public/dispatch.cgi/oauth/request_token',
# 	);

    my $oaresponse = Net::OAuth::AccessTokenResponse->new(
	token => 'abcdef',
	token_secret => '0123456',
	extra_params => {
	    foo => 'bar',
	},
	);

    my $output = $oaresponse->to_post_body;
    warn "check output:".  $output;
    $output;
};

#/oauth/authorize?oauth_token=19a8829c206931010a2d
get '/oauth/authorize' => sub {
    "OK";

};

get '/oauth/request_token' => sub 
{
 #   "Hmmm";
#    redirect "http://api.fosm.org/oauth/request_token";
#    redirect "http://api.osm.org/oauth/request_token";
#    redirect "http://api06.dev.openstreetmap.org/oauth/request_token";
    my $ua = LWP::UserAgent->new;
    my %params = request->params;
 #   warn Dump(request->params);
    # my $param="?";
    # if (!exists($params{oauth_version}))
    # {
    # 	$params{oauth_version}="1.0";

    # }
    warn "Params";
    for my $paramname (keys %params)
     {
	 warn "Check params:".  $paramname . "=". URI::Escape::uri_escape( $params{$paramname}) . "\n";
     }

#     my %request_arg = (
# 	consumer_key =>  $params{oauth_consumer_key},
#         consumer_secret => 'jJs8XFPjywSyrVlwkNvLanh7ZVyHaJWTQHWFOn1U',
#         request_method => 'GET',
# #	callback => $params{oauth_callback} || 'oob',
# #	protocol_version => '1',
# #	version => '1.0',
#         signature_method => $params{oauth_signature_method},
#         signature => $params{oauth_signature},
#         timestamp => $params{oauth_timestamp},
# 	nonce => $params{oauth_nonce},
# 	extra_params => {},
# 	request_url => 'http://pine02.fosm.org/FOSM-Api/OSM-API-Proxy/public/dispatch.cgi/oauth/request_token',

#     );

    try {
	warn "going to try to decode the params";

	my $oareqhash =    {
		'oauth_consumer_key' => $params{oauth_consumer_key},
		'oauth_nonce' => $params{oauth_nonce},
		'oauth_signature' => $params{oauth_signature},
		'oauth_timestamp' => $params{oauth_timestamp},
		'oauth_signature_method' => $params{oauth_signature_method},
	};
	$oareqhash->{oauth_version} =$params{oauth_version} if exists($params{oauth_version});
	my $oarequest = Net::OAuth->request("request token")->from_hash(
	    $oareqhash,
	    'consumer_secret' => 'jJs8XFPjywSyrVlwkNvLanh7ZVyHaJWTQHWFOn1U',
	    'request_method' => 'GET',
	    'request_url' => 'http://pine02.fosm.org/FOSM-Api/OSM-API-Proxy/public/dispatch.cgi/oauth/request_token',
	    );


	warn "going to try to verify";
	if (! $oarequest->verify)
	{
	    warn "failed";
	    status 401;
	    return halt "Invalid signature (type: $params{oauth_signature_method}).";
	}
	else
	{
	    warn "OK!";
	}
    }
    catch {
	warn "caught error: $_"; # not $@
	status 500;
	return halt "internal error $_";
    };

    warn "after try3";

    # now we create and issue a token.
    my $token  = generate_token();
    my $secret = generate_token();

    warn "new token and secret $token $secret!";
    my $oauthresp = Net::OAuth::AccessTokenResponse->new(
	token => $token,
	token_secret => $secret,
	extra_params => {},
	);

    my $output = $oauthresp->to_post_body;
    warn "check output:".  $output;
    return $output;
    
};

get '/api/0.6/map' => sub {
    my $ua = LWP::UserAgent->new;
    my %params = request->params;
    my $param="?";
    for my $paramname (keys %params)
    {
	$param .= $paramname . "=". URI::Escape::uri_escape( $params{$paramname}) . '&';
    }
    my $url = 'http://api.fosm.org/api/0.6/map' . $param;

    warn "Url $url";
    my $req = HTTP::Request->new("GET", $url);
    my $response= $ua->request($req);
#    warn $res;
#    print $res;

    if ($response->is_success) {
#	print $response->decoded_content;  # or whatever
	return $response->decoded_content;  # or whatever
    }
#    else {
#	$response->status_line;
#    }
#    return $res;
    return "error";
#GET /api/0.6/map?bbox=left,bottom,right,top
    #params->{left}
    #params->{bottom}
    #params->{right}
    #params->{top}
    template 'getmapbbox.tt', 
    { 
#	bbox => {
#	    min => { lon => params->{left},lat => params->{top}},
#	    max => { lon => params->{right},lat => params->{bottom}}
#	},	 
    }
    , 
    { layout => undef };
};

get '/api/0.6/changesets' => sub {

    template 'changesets.tt', { 
	changesets => 
	    [ 
	      {
		  id => 1,
		  user=>"mike",
		  uid=>"1",
		  created_at=>"now",
		  open=>1,
		  bbox => {
		      min => { lon => 0,lat =>0},
		      max => { lon => 100,lat =>100}
		  },
		  tags => [
		      {
			  name => "funky",
			  value => "for sure",
		      }
		      ]
			  
	      }
	      
	    ]
    }, { layout => undef };
# http://wiki.openstreetmap.org/wiki/API_v0.6#Query:_GET_.2Fapi.2F0.6.2Fchangesets
# Query: GET /api/0.6/changesets

# This is an API method for querying changesets. It supports querying by different criteria.

# Where multiple queries are given the result will be those which match all of the requirements. The contents of the returned document are the changesets and their tags. To get the full set of changes associated with a changeset, use the download method on each changeset ID individually.

# Modification and extension of the basic queries above may be required to support rollback and other uses we find for changesets.
# Parameters

# bbox=min_lon,min_lat,max_lon,max_lat (W,S,E,N)
#     Find changesets within the given bounding box 
# user=#uid or display_name=#name
#     Find changesets by the user with the given user id or display name. Providing both is an error. 
# time=T1
#     Find changesets closed after T1 
# time=T1,T2
#     Find changesets that were closed after T1 and created before T2 
# open
#     Only finds changesets that are still open but excludes changesets that are closed or have reached the element limit for a changeset (50.000 at the moment) 
# closed
#     Only finds changesets that are closed or have reached the element limit 

# Time format: Anything that this Ruby function will parse. The default str is ’-4712-01-01T00:00:00+00:00’; this is Julian Day Number day 0.
# Response

# Returns a list of all changeset ordered by creation date. The <osm> element may be empty if there were no results for the query. The response is send with a content type of text/xml.
# Error codes

# HTTP status code 400 (Bad Request) - text/plain
#     On misformed parameters. A text message explaining the error is returned. In particular, trying to provide both the UID and display name as user query parameters will result in this error. 
# HTTP status code 404 (Not Found)
#     When no user with the given uid or display_name could be found. 

# Notes

#     Only changesets by public users are returned.
#     I'm not sure if the time query makes sense as it is implemented now. The original documentation for this feature states:
#         One-sided to query changesets where the start time is after the given time.
#         Bounded (?time=T1,T2) to query where the start time is between the given times. 
#     Returns at most 100 changesets 
};


my $changesetid = scalar time() ;#. $$. int rand 1024; # timestamp with pid, should be enough!
warn "changeset is now ". $changesetid;

put '/api/0.6/changeset/create' => sub {       
    
    header('Content-Type' => 'text/plain');	
#header('Server: Apache/2.2.16 (Debian)
    header('Set-cookie' => '_osm_session=46jsstvc0neelurdmxrnvpcn2rzx26nb; path=/; HttpOnly');
    header('Vary' => 'Authorization,Accept-Encoding');
    header('Keep-Alive' => 'timeout=15, max=100');
    header('Connection' => 'Keep-Alive');
    #header('Transfer-Encoding' => 'chunked');
#    debug Dump(request->{body});    
    #$changesetid++ . "\n";
    $changesetid . "\n";

# send this to another server 
# HTTP/1.1 200 OK
# Date: Fri, 15 Jul 2011 17:49:34 GMT
# Server: Apache/2.2.16 (Debian)
# Set-cookie: _osm_session=46jsstvc0neelurdmxrnvpcn2rzx26nb; path=/; HttpOnly
# Vary: Authorization,Accept-Encoding
# Keep-Alive: timeout=15, max=100
# Connection: Keep-Alive
# Transfer-Encoding: chunked
# Content-Type: text/plain
# a
# 1000001383


};

=head2 upload: POST /api/0.6/changeset/#id/upload

Diff upload: POST /api/0.6/changeset/#id/upload
With this API call files in the OsmChange format can be uploaded to the server. This is guaranteed to be running in a transaction. So either all the changes are applied or none.
To upload an OSC file it has to conform to the OsmChange specification with the following additions:
each element must carry a changeset and a version attribute, except when you are creating an element where the version is not required as the server sets that for you. The changeset must be the same as the changeset ID being uploaded to.
a <delete> block in the OsmChange document may have an if-unused attribute (the value of which is ignored). If this attribute is present, then the delete operation(s) in this block are conditional and will only be executed if the object to be deleted is not used by another object. Without the if-unused, such a situation would lead to an error, and the whole diff upload would fail.
Parameters
id
The ID of the changeset this diff belongs to.
POST data
The OsmChange file data
Response
If a diff is successfully applied a XML (content type text/xml) is returned in the following format
<diffResult generator="OpenStreetMap Server" version="0.6">
  <node|way|relation old_id="#" new_id="#" new_version="#"/>
  ...
</diffResult>
with one element for every element in the upload. Note that this can be counter-intuitive when the same element has appeared multiple times in the input then it will appear multiple times in the output.
Attribute	 create	 modify	 delete
old_id	 same as uploaded element.
new_id	 new ID	 same as uploaded	 not present
new_version	 new version	 not present
Error codes
HTTP status code 400 (Bad Request) - text/plain
When there are errors parsing the XML. A text message explaining the error is returned.
When an placeholder ID is missing or not unique
HTTP status code 405 (Method Not Allowed)
If the request is not a HTTP POST request
HTTP status code 409 (Conflict) - text/plain
If the changeset in question has already been closed (either by the user itself or as a result of the auto-closing feature). A message with the format "The changeset #id was closed at #closed_at." is returned
If, while uploading, the max. size of the changeset is exceeded. A message with the format "The changeset #id was closed at #closed_at." is returned
Or if the user trying to update the changeset is not the same as the one that created it
Or if the diff contains elements with changeset IDs which don't match the changeset ID that the diff was uploaded to
Any of the error codes that could occur an a create, update or delete operation for one of the elements
See the according sections in this page
Notes
Processing stops at the first error, so if there are multiple conflicts in one diff upload, only the first problem is reported.
There is currently no limit in the diff size but this will probably be changed later.
Changeset summary
The procedure for successful creation of a changeset is summarized in the following picture:

Elements

There are create, read, update and delete calls for all of the three basic elements in OpenStreetMap (Nodes, Ways and Relations). These calls are very similar except for the payload and a few special error messages so they are documented only once.

=cut

#POST http://localhost:3000/api/0.6/changeset/1000001384/upload
post '/api/0.6/changeset/*/upload' => sub {
      my ($id) = splat;

      ############################################
      header('Content-Type' => 'text/plain');	
      header('Set-cookie' => '_osm_session=46jsstvc0neelurdmxrnvpcn2rzx26nb; path=/; HttpOnly');
      header('Vary' => 'Authorization,Accept-Encoding');
      header('Keep-Alive' => 'timeout=15, max=100');
      header('Connection' => 'Keep-Alive');
      ##########################################

#      warn "got changeset $id";
      # now lets process it 
      debug Dump(request->{body});

      ## now update
      my $newid = $id . time() . $$. int rand 1024;
      my $changesetfile="/pine02/www/FOSM-Api/OSM-API-Proxy/public/changesets/osmupdate_${newid}.osm";
      open OUT, ">$changesetfile" or die "cannot open $changesetfile" ;
      print OUT request->{body};
      close OUT;

# #<osmChange version="0.6" generator="JOSM">
# <modify>
#   <node id='1287731165' action='modify' timestamp='2011-05-16T14:56:18Z' uid='355102' user='BesfortGuri/Besfort Guri/BesfortGuri/Besfort Guri/Besfort Guri/BesfortGuri' visible='true' version='2' changeset='1000001384' lat='42.61893168122738' lon='20.57614856619908' />
# </modify>
# </osmChange>

      "<?xml version='1.0' encoding='UTF-8'?>
<diffResult version='0.6' generator='FOSM API 0.6'>
</diffResult>
";

#<node old_id='-4368' new_id='1000000073409' new_version='1'/>
};


# Update: PUT /api/0.6/changeset/#id
# For updating tags on the changeset, e.g. changeset comment=foo.
# Payload should be an OSM document containing the new version of a single changeset. Bounding box, update time and other attributes are ignored and cannot be updated by this method. For updating the bounding box see the expand_bbox method.
# <osm>
#   <changeset>
#     <tag k="comment" v="Just adding some streetnames and a restaurant"/>
#   </changeset>
# </osm>
# Parameters
# id
# The id of the changeset to update. The user issuing this API call has to be the same that created the changeset
# Response
# An OSM document containing the new version of the changeset with a content type of text/xml
# Error codes
# HTTP status code 400 (Bad Request)
# When there are errors parsing the XML
# HTTP status code 404 (Not Found)
# When no changeset with the given id could be found
# HTTP status code 405 (Method Not Allowed)
# If the request is not a HTTP PUT request
# HTTP status code 409 (Conflict) - text/plain
# If the changeset in question has already been closed (either by the user itself or as a result of the auto-closing feature). A message with the format "The changeset #id was closed at #closed_at." is returned
# Or if the user trying to update the changeset is not the same as the one that created it
# Notes
# Unchanged tags have to be repeated in order to not be deleted.
# What's really cool is that you can use regex to match and capture URL elements...


#  get qr{} => sub {
#    # named capture requires at least 5.10
#    my $decode = decode_base36(uc captures->{'code'});
#  };
#  get '/:code/stats' => sub {
#    my $decode = decode_base36(uc params->{'code'});
#  };
#/api/0.6/changeset/1000001384/close
put '/api/0.6/changeset/*/close' => sub {
      my ($id) = splat;
#      warn "close changeset $id";
      # now lets process it 
      
      print "";

};

# from merkaator
post '/api/0.6/changeset/*' => sub {
      my ($id) = splat();
#      warn "got changeset $id";
      # now lets process it 
      debug Dump(request->{body});
    template 'changeset.tt', { 
	changeset => 
	    [ 
	      {
		  id => 1,
		  user=>"mike",
		  uid=>"1",
		  created_at=>"now",
		  open=>1,
		  bbox => {
		      min => { lon => 0,lat =>0},
		      max => { lon => 100,lat =>100}
		  },
		  tags => [
		      {
			  name => "funky",
			  value => "for sure",
		      }
		      ]
			  
	      }
	      
	    ]
    }, { layout => undef };

};


=pod 

&lt;?xml version=&#39;1.0&#39; encoding=&#39;UTF-8&#39;?&gt;
&lt;osm version=&#39;0.6&#39; generator=&#39;JOSM&#39;&gt;
  &lt;changeset  id=&#39;1000001384&#39; open=&#39;false&#39;&gt;
    &lt;tag k=&#39;comment&#39; v=&#39;test of move&#39; /&gt;
    &lt;tag k=&#39;created_by&#39; v=&#39;JOSM/1.5 (4018 en)&#39; /&gt;
  &lt;/changeset&gt;
&lt;/osm&gt;
</pre><div class="title">Stack</div><pre class="content">main in ./bin/app.pl l. 4
Dancer in /usr/local/share/perl/5.10.1/Dancer.pm l. 353
Dancer::Handler in /usr/local/share/perl/5.10.1/Dancer/Handler.pm l. 179
Dancer::Handler::Standalone in /usr/local/share/perl/5.10.1/Dancer/Handler/Standalone.pm l. 36
HTTP::Server::Simple in /usr/share/perl5/HTTP/Server/Simple.pm l. 296
HTTP::Server::Simple in /usr/share/perl5/HTTP/Server/Simple.pm l. 332
HTTP::Server::Simple in /usr/share/perl5/HTTP/Server/Simple.pm l. 427
HTTP::Server::Simple::PSGI in /usr/local/share/perl/5.10.1/HTTP/Server/Simple/PSGI.pm l. 103
HTTP::Server::Simple::PSGI in /usr/local/share/perl/5.10.1/HTTP/Server/Simple/PSGI.pm l. 103
Dancer::Handler in /usr/local/share/perl/5.10.1/Dancer/Handler.pm l. 102
Dancer::Handler in /usr/local/share/perl/5.10.1/Dancer/Handler.pm l. 71
Dancer::Handler in /usr/local/share/perl/5.10.1/Dancer/Handler.pm l. 78
Dancer::Handler in /usr/local/share/perl/5.10.1/Dancer/Handler.pm l. 79
Dancer::Renderer in /usr/local/share/perl/5.10.1/Dancer/Renderer.pm l. 28
Dancer::Renderer in /usr/local/share/perl/5.10.1/Dancer/Renderer.pm l. 125
Dancer::Route in /usr/local/share/perl/5.10.1/Dancer/Route.pm l. 169
Dancer::Route in /usr/local/share/perl/5.10.1/Dancer/Route.pm l. 241
Dancer::Object in /usr/local/share/perl/5.10.1/Dancer/Object.pm l. 15
Dancer::Error in /usr/local/share/perl/5.10.1/Dancer/Error.pm l. 34
Dancer::Error in /usr/local/share/perl/5.10.1/Dancer/Error.pm l. 248</pre> <div class="title">Settings</div><pre class="content">{
  <span class="key">engines</span>  =&gt; {
    <span class="key">template_toolkit</span>  =&gt; {
      <span class="key">start_tag</span>  =&gt; '[%',
      <span class="key">end_tag</span>  =&gt; '%]',
      <span class="key">encoding</span>  =&gt; 'utf8'
    }
  },
  <span class="key">plugins</span>  =&gt; {},
  <span class="key">import_warnings</span>  =&gt; 1,
  <span class="key">appname</span>  =&gt; 'OSM::API::Proxy',
  <span class="key">views</span>  =&gt; '/home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy/views',
  <span class="key">layout</span>  =&gt; 'main',
  <span class="key">confdir</span>  =&gt; '/home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy',
  <span class="key">public</span>  =&gt; '/home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy/public',
  <span class="key">show_errors</span>  =&gt; '1',
  <span class="key">server</span>  =&gt; '0.0.0.0',
  <span class="key">log</span>  =&gt; 'core',
  <span class="key">daemon</span>  =&gt; 0,
  <span class="key">logger</span>  =&gt; 'console',
  <span class="key">warnings</span>  =&gt; '1',
  <span class="key">template</span>  =&gt; 'template_toolkit',
  <span class="key">traces</span>  =&gt; 0,
  <span class="key">charset</span>  =&gt; 'utf-8',
  <span class="key">appdir</span>  =&gt; '/home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy',
  <span class="key">handlers</span>  =&gt; {},
  <span class="key">startup_info</span>  =&gt; 1,
  <span class="key">port</span>  =&gt; '3000',
  <span class="key">environment</span>  =&gt; 'development',
  <span class="key">content_type</span>  =&gt; 'text/html',
  <span class="key">apphandler</span>  =&gt; 'Standalone',
  <span class="key">auto_reload</span>  =&gt; '0'
}
</pre>  <div class="title">Environment</div><pre class="content">{
  <span class="key">SCRIPT_NAME</span>  =&gt; '',
  <span class="key">SERVER_NAME</span>  =&gt; '0.0.0.0',
  <span class="key">'psgi.multiprocess'</span>  =&gt; 0,
  <span class="key">PATH_INFO</span>  =&gt; '/api/0.6/changeset/1000001384',
  <span class="key">HTTP_CONNECTION</span>  =&gt; 'keep-alive',
  <span class="key">CONTENT_LENGTH</span>  =&gt; '233',
  <span class="key">REQUEST_METHOD</span>  =&gt; 'PUT',
  <span class="key">HTTP_ACCEPT</span>  =&gt; 'text/html, image/gif, image/jpeg, *; q=.2, */*; q=.2',
  <span class="key">'psgi.multithread'</span>  =&gt; 0,
  <span class="key">QUERY_STRING</span>  =&gt; '',
  <span class="key">HTTP_USER_AGENT</span>  =&gt; 'JOSM/1.5 (4018 en) Java/1.6.0_20',
  <span class="key">SERVER_PORT</span>  =&gt; '3000',
  <span class="key">HTTP_COOKIE</span>  =&gt; undef,
  <span class="key">REMOTE_ADDR</span>  =&gt; '127.0.0.1',
  <span class="key">CONTENT_TYPE</span>  =&gt; 'text/xml',
  <span class="key">SERVER_PROTOCOL</span>  =&gt; 'HTTP/1.1',
  <span class="key">'psgi.streaming'</span>  =&gt; 1,
  <span class="key">'psgi.errors'</span>  =&gt; *::STDERR,
  <span class="key">REQUEST_URI</span>  =&gt; '/api/0.6/changeset/1000001384',
  <span class="key">'psgi.version'</span>  =&gt; [
    1,
    1
  ],
  <span class="key">'psgi.nonblocking'</span>  =&gt; 0,
  <span class="key">'psgix.io'</span>  =&gt; bless( \*Symbol::GEN30, 'FileHandle' ),
  <span class="key">HTTP_AUTHORIZATION</span>  =&gt; 'Basic aDRjazNybTFrMzp2ZXJpdGFzYmVybGlub3Nt',
  <span class="key">'psgi.url_scheme'</span>  =&gt; 'http',
  <span class="key">'psgi.run_once'</span>  =&gt; 0,
  <span class="key">HTTP_HOST</span>  =&gt; 'localhost:3000',
  <span class="key">'psgi.input'</span>  =&gt; $VAR1->{'psgix.io'}
}
=cut 
put '/api/0.6/changeset/*' => sub {
      my ($id) = splat();
#      warn "got changeset $id";
      # now lets process it 
       my $all_uploads = request->uploads;
#      warn Dump($all_uploads);
      #request->input_handle;
      debug Dump(request->{body});
# called before upload
# <?xml version='1.0' encoding='UTF-8'?>
# <osm version='0.6' generator='JOSM'>
#   <changeset  id='1000001384' open='true'>
#     <tag k='comment' v='fsdfsdfsdfsd' />
#     <tag k='created_by' v='JOSM/1.5 (4018 en)' />
#   </changeset>
# </osm> 


#      open ">data/${id}."
    template 'changeset.tt', { 
	changeset => 
	    [ 
	      {
		  id => 1,
		  user=>"mike",
		  uid=>"1",
		  created_at=>"now",
		  open=>1,
		  bbox => {
		      min => { lon => 0,lat =>0},
		      max => { lon => 100,lat =>100}
		  },
		  tags => [
		      {
			  name => "funky",
			  value => "for sure",
		      }
		      ]
			  
	      }
	      
	    ]
    }, { layout => undef };
      

#<node old_id='-4368' new_id='1000000073409' new_version='1'/>
};

get '/browse/node/*' => sub 
{
    my ($id) = splat();
    my $node = schema("osm")->resultset('Node')->find( { id => $id });
#    my @node = schema("osm")->resultset('Node')->search_rs( { id => $id });
    $Data::Dumper::Maxdepth=2;
    debug Dumper(\$node);
#    debug Dump($node);    
#    debug Dump(\@node);    
#    while(my $n = $node->next())
#    foreach (@node)
    {
	template 'browse_node.tt', {node => $node }, { layout => undef };
    }
};

1;

