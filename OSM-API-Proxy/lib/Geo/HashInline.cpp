#include <iostream>
#include <string>
using namespace std;


class Id
{
public:
	long id;
};

class User : public Id
{
public:
	string name;
};

class Changeset : public Id
{
public:
	User user;
};

class Point 
{
public:
  //  Point ()  {}

  Point (double _lat,double _lon)
    :lon(_lon),
     lat(_lat)
  {
    
  }
  double lon;
  double lat;
  
  double set_lon(double nlon )
  {
    lon=nlon;
    return lon;
  }

  double set_lat(double n )
  {
    lat=n;
    return lat;
  }
};

class Time
{

};
class Version  : public Id
{
public:
  Time c_time;
};

class Node : public Id, public Point 
{

public:
  Node(double lat, double lon)
    :Point(lat,lon)
  {

  }
  User user;
  Changeset changeset;
  Version version;
  
};

class Hash 
{
public:
  const char * even;
  const char * odd;
};

class HashLoc
{
public:
  Hash  right,  left,  top, bottom;
};

class GeoHash
{
public:

  //HashLoc NEIGHBORS,BORDERS;
  int init ();

  string encode1(  double lat, double lon) 
  {
    return encode2(   Point (lat,lon) ) ;
  }

  string encode2(   Point node) ;

};

class BBox
{
public:
  Point min;
  Point max;
  BBox(  Point _min,
	 Point _max)
    :min(_min),
     max(_max) {};
  GeoHash Hash();
};

// BITS = [16, 8, 4, 2, 1];

// BASE32 = "0123456789bcdefghjkmnpqrstuvwxyz";
// NEIGHBORS = { right : { even : "bc01fg45238967deuvhjyznpkmstqrwx" },
// left : { even : "238967debc01fg45kmstqrwxuvhjyznp" },
// top : { even : "p0r21436x8zb9dcf5h7kjnmqesgutwvy" },
// bottom : { even : "14365h7k9dcfesgujnmqp0r2twvyx8zb" } };
// BORDERS = { right : { even : "bcfguvyz" },
// left : { even : "0145hjnp" },
// top : { even : "prxz" },
// bottom : { even : "028b" } };

// NEIGHBORS.bottom.odd = NEIGHBORS.left.even;
// NEIGHBORS.top.odd = NEIGHBORS.right.even;
// NEIGHBORS.left.odd = NEIGHBORS.bottom.even;
// NEIGHBORS.right.odd = NEIGHBORS.top.even;

// BORDERS.bottom.odd = BORDERS.left.even;
// BORDERS.top.odd = BORDERS.right.even;
// BORDERS.left.odd = BORDERS.bottom.even;
// BORDERS.right.odd = BORDERS.top.even;


// from https://github.com/davetroy/geohash-js/blob/master/geohash.js
//

const char * NEIGHBORS_right_even_s = "bc01fg45238967deuvhjyznpkmstqrwx";
HashLoc NEIGHBORS = { 
  // right 
  {
    //even
    NEIGHBORS_right_even_s,
    0
  },
  // left
  {
    0,
    0
  },
  // top
  {
    0,
    0
  }
  // bottom
};

  //right : { even : "bc01fg45238967deuvhjyznpkmstqrwx" },
 
//HashLoc GeoHash::NEIGHBORS {
//  NEIGHBORS_right_even
//}
//HashLoc GeoHash::BORDERS = {};

int GeoHash::init ()
{
// NEIGHBORS = { right : { even : "bc01fg45238967deuvhjyznpkmstqrwx" },
// left : { even : "238967debc01fg45kmstqrwxuvhjyznp" },
// top : { even : "p0r21436x8zb9dcf5h7kjnmqesgutwvy" },
// bottom : { even : "14365h7k9dcfesgujnmqp0r2twvyx8zb" } };
// BORDERS = { right : { even : "bcfguvyz" },
// left : { even : "0145hjnp" },
// top : { even : "prxz" },
// bottom : { even : "028b" } };
};

string GeoHash::encode2(
		       Point  node  // what node we operate on
		       )
{
  int BITS [] = {16, 8, 4, 2, 1,0};
  
  string BASE32 = "0123456789bcdefghjkmnpqrstuvwxyz";
  //NEIGHBORS = { right : { even : "bc01fg45238967deuvhjyznpkmstqrwx" },
  //		   left : { even : "238967debc01fg45kmstqrwxuvhjyznp" },
  // top : { even : "p0r21436x8zb9dcf5h7kjnmqesgutwvy" },
  //		   bottom : { even : "14365h7k9dcfesgujnmqp0r2twvyx8zb" } };
  
  // BORDERS = { right : { even : "bcfguvyz" },
  // left : { even : "0145hjnp" },
  // top : { even : "prxz" },
  // bottom : { even : "028b" } };
  
  // NEIGHBORS.bottom.odd = NEIGHBORS.left.even;
  // NEIGHBORS.top.odd = NEIGHBORS.right.even;
  // NEIGHBORS.left.odd = NEIGHBORS.bottom.even;
  // NEIGHBORS.right.odd = NEIGHBORS.top.even;
  
  // BORDERS.bottom.odd = BORDERS.left.even;
  // BORDERS.top.odd = BORDERS.right.even;
  // BORDERS.left.odd = BORDERS.bottom.even;
  // BORDERS.right.odd = BORDERS.top.even;
  
  //    int flip;
  //    double lab = int( length node.lat * 3.32192809488736 + 1 ) + 8;
  //    function encodeGeoHash(latitude, longitude) {
  int is_even=1;
  int i=0;
  //    var lat = []; var lon = [];
  Point p1(-90,-180);
  Point p2(90,180);
  BBox latlon(p1,p2);
  //  latlon.print();
  int bit=0;
  char ch=0;
  int precision = 12;
  string geohash = "";
  
  /*
  cout <<   latlon.min.lat << " ";
  cout <<   latlon.max.lat << " ";
  cout <<   latlon.min.lon << " ";
  cout <<   latlon.max.lon << endl;

  latlon.min.lat= -90; //90
  latlon.max.lat= 90;// -90
  
  latlon.min.lon= -180; // 180
  latlon.max.lon= 180; // -180 


  cout <<   latlon.min.lat << " ";
  cout <<   latlon.max.lat << " ";
  cout <<   latlon.min.lon << " ";
  cout <<   latlon.max.lon << endl;
  */

  //#    lat[0] = -90.0; lat[1] = 90.0;
  //lon[0] = -180.0; lon[1] = 180.0;
  
  while (geohash.length() < precision) {
    //        //    cout << "geohash is now "<< geohash << endl;
    if (is_even) {


      double mid = (latlon.min.lon + latlon.max.lon) / 2;
      //     cout <<	"(latlon.min.lon + latlon.max.lon) / 2 : " 	   << latlon.min.lon  << ","	   << latlon.max.lon  <<  "="<< mid << endl;      cout << "node.lon:" << node.lon << endl;
      //      cout << "even:" << mid << endl;
      if (node.lon > mid) {
	//	cout << "node.lon > mid : "<< node.lon << ">" <<  mid << endl;
	//	cout << "char was : "<< hex << (int)ch << endl;
	ch |= BITS[bit];
	//    cout << "adding bits: " << hex << (int)BITS[bit] << endl;
	//    cout << "char is now : " << hex << (int)ch << endl;
	latlon.min.lon = mid;
      } else
	{
	  //    cout << "latlon.max.lon - mid : "<< latlon.max.lon  << "=" <<  mid << endl;
	  latlon.max.lon = mid;
	}
    } else {
      double mid = (latlon.min.lat + latlon.max.lat) / 2;
      //    cout <<      "(latlon.min.lat + latlon.max.lat) / 2" 	   << latlon.min.lat  << ","	   << latlon.max.lat  <<  "="<< mid<< endl;
          //    cout << "odd:" << mid << endl;
          //    cout << "node.lat:" << node.lat << endl;

      if (node.lat > mid) {
	    //    cout << "node.lat > mid : "<< node.lat << ">" <<  mid << endl;
	    //    cout << "ch was :"<< hex << (int) ch << endl;
	    //    cout << "bit :" << bit << endl;
	    //    cout << "bits :" << BITS[bit] << endl;
	//	cout<< "was" << hex << (int) ch << endl;
	ch |= BITS[bit];
	    //    cout << "is now" << '0' + ch << endl;
	latlon.min.lat = mid;

      } 
      else
	{
	      //    cout << "latlon.max.lat - mid : "<< latlon.max.lat  << "=" <<  mid << endl;
	  latlon.max.lat = mid;
	}
    }
    
    is_even = !is_even;
        //    cout << "is_even :" << is_even << endl;
    
    if (bit < 4)
      {
	    //    cout << "add bit :" << bit << endl;
	bit++;
      }
    else {
          //    cout << "in base32 :" << BASE32[ch] << endl;
      geohash += BASE32[ch];
          //    cout << "add this char  in BASE32 " << hex << (int) ch << endl;
          //    cout << BASE32[ch] << endl;
      bit = 0;
      ch = 0;
    }
  }
  return geohash;
};


string encode(double lat, double lon)
{
  Point  node(
	      lat,
	      lon)	      
;  // what node we operate on
	      //  node.lat=42.64245;
	      //  node.lon=21.167883;
  GeoHash gh;
  gh.init();
  string ret = gh.encode2(node);
  //cout << ret << endl;
  return ret;
}

char * encodestr(double lat, double lon)
{
  Point  node(
 	      lat,
 	      lon)	      
    ;  // what node we operate on
  //  node.lat=42.64245;
  //  node.lon=21.167883;
  GeoHash gh;
  gh.init();
  string ret = gh.encode2(node);
  //cout << ret << endl;
  return (char*)ret.c_str();
}
