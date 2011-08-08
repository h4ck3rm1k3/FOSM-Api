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
	double lon;
	double lat;
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

  static HashLoc NEIGHBORS,BORDERS;
  
  static int init ();

  static string encode(	Node & node) ;
};

class BBox
{
public:
  Point min;
  Point max;
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
HashLoc GeoHash::BORDERS = {};

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

string GeoHash::encode(
		       Node & node  // what node we operate on
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
  BBox latlon;
  int bit=0;
  char ch=0;
  int precision = 12;
  string geohash = "";
  
  latlon.min.lat= 90; //90
  latlon.max.lat= latlon.min.lat * -1;// -90
  
  latlon.min.lon= latlon.min.lat *2; // 180
  latlon.max.lon= latlon.min.lon * -1; // -180
  
  //#    lat[0] = -90.0; lat[1] = 90.0;
  //lon[0] = -180.0; lon[1] = 180.0;
  
  while (geohash.length() < precision) {
    if (is_even) {
      double mid = (latlon.min.lon + latlon.max.lon) / 2;
      if (node.lon > mid) {
	ch |= BITS[bit];
	latlon.min.lon = mid;
      } else
	latlon.max.lon = mid;
    } else {
      double mid = (latlon.min.lat + latlon.max.lat) / 2;
      if (node.lat > mid) {
	ch |= BITS[bit];
	latlon.min.lat = mid;
      } else
	latlon.max.lat = mid;
    }
    
    is_even = !is_even;
    if (bit < 4)
      bit++;
    else {
      geohash += BASE32[ch];
      bit = 0;
      ch = 0;
    }
  }
  return geohash;
};

