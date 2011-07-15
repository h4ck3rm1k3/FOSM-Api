package OSM::API::Proxy;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index.tt', {}, { layout => undef };
};

get '/api' => sub {
    template 'api.tt', {}, { layout => undef };
};

get '/api/capabilities/test' => sub {
    template 'capabilities.tt', {}, { layout => undef };
};

my $changetsetid = 1000001384;

put '/api/0.6/changeset/create' => sub {       
    header('Content-Type' => 'text/plain');	
#header('Server: Apache/2.2.16 (Debian)
    header('Set-cookie' => '_osm_session=46jsstvc0neelurdmxrnvpcn2rzx26nb; path=/; HttpOnly');
    header('Vary' => 'Authorization,Accept-Encoding');
    header('Keep-Alive' => 'timeout=15, max=100');
    header('Connection' => 'Keep-Alive');
    #header('Transfer-Encoding' => 'chunked');
    
    $changetsetid++ . "\n";

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

get 'http://www.openstreetmap.org/api/0.6/map' => sub 
{
    template 'getmapbbox.tt', 
    { 
    }
    , 
    { layout => undef };

};
#http://www.openstreetmap.org/api/0.6/user/preferences/MerkaartorPrefsXML005
#http://www.openstreetmap.org/api/0.6/user/preferences/MerkaartorPrefsXML006

get '/api/0.6/user/preferences/' => sub {
'<osm version="0.6" generator="OpenStreetMap server">
    <preferences>
       <preference k="somekey" v="somevalue" />
    </preferences>
  </osm>
';
};

get '/api/0.6/map' => sub {
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


1;
