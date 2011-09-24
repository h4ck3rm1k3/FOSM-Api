#include <iostream>

#include <string>
#include <string.h>


%%{
machine osmkeys;

key = (
'4wd_only' |
'TMC:LocationCode' |
'abutters' |
'access' |
'access:bdouble' |
'access:lhv' |
'access:roadtrain' |
'addr:city' |
'addr:country' |
'addr:housename' |
'addr:housenumber' |
'addr:inclusion' |
'addr:interpolation' |
'addr:postcode' |
'addr:street' |
'admin_level' |
'aerialway' |
'aeroway' |
'agricultural' |
'alt_name' |
'amenity' |
'area' |
'attribution' |
'atv' |
'barrier' |
'bicycle' |
'boat' |
'border_type' |
'boundary' |
'bridge' |
'building' |
'cables' |
'charge' |
'construction' |
'covered' |
'craft' |
'created_by' |
'crossing' |
'cutting' |
'cycleway' |
'date_off' |
'date_on' |
'day_off' |
'day_on' |
'description' |
'dispensing' |
'disused' |
'ele' |
'electrified' |
'email' |
'embankment' |
'emergency' |
'end_date' |
'est_width' |
'fax' |
'fenced' |
'fixme' |
'foot' |
'frequency' |
'geological' |
'goods' |
'hazmat' |
'hgv' |
'highway' |
'historic' |
'history' |
'horse' |
'hour_off' |
'hour_on' |
'iata' |
'icao' |
'image' |
'incline' |
'int_name' |
'int_ref' |
'internet_access' |
'is_in' |
'junction' |
'landuse' |
'lanes' |
'layer' |
'lcn_ref' |
'leisure' |
'length' |
'lit' |
'loc_name' |
'loc_ref' |
'lock' |
'man_made' |
'maxheight' |
'maxlength' |
'maxspeed' |
'maxstay' |
'maxweight' |
'maxwidth' |
'military' |
'minspeed' |
'mooring' |
'motor_vehicle' |
'motorboat' |
'motorcar' |
'motorcycle' |
'motorroad' |
'mountain_pass' |
'mtb:description' |
'mtb:scale' |
'mtb:scale:imba' |
'mtb:scale:uphill' |
'name' |
'name:lg' |
'narrow' |
'nat_name' |
'nat_ref' |
'natural' |
'ncn_ref' |
'noexit' |
'note' |
'office' |
'official_name' |
'old_name' |
'old_ref' |
'oneway' |
'opening_hours' |
'operator' |
'passing_places' |
'phone' |
'place' |
'place_name' |
'place_numbers' |
'point' |
'population' |
'postal_code' |
'power' |
'proposed' |
'psv' |
'railway' |
'rcn_ref' |
'ref' |
'reg_name' |
'reg_ref' |
'religion' |
'route' |
'rtc_rate' |
'sac_scale' |
'service' |
'shop' |
'shoulder' |
'smoothness' |
'source' |
'source:name' |
'source:ref' |
'source_ref' |
'sport' |
'start_date' |
'surface' |
'tactile_paving' |
'toll' |
'tourism' |
'tracktype' |
'traffic_calming' |
'traffic_sign' |
'trail_visibility' |
'tunnel' |
'url' |
'usage' |
'vehicle' |
'voltage' |
'waterway' |
'way_area' |
'website' |
'wheelchair' |
'width' |
'wikipedia' |
'wires' |
'wood'
);

main := key @{ res = 1; };

}%%

%% write data nofinal;

#define BUFSIZE 128


int scanner(const char *s)
{
  int cs;
  int res = 0;
  char *p= (char *)s;
  char *pe = (char *)s + strlen(s) +1 ;
  %% write init;
  %% write exec;
  
  return res;
}

using namespace std;

int main ()
{
  while(std::cin)
    {
      std::string s;
      cin >> s;
      int ret= scanner(s.c_str());
      cout << s << ret <<  endl;
    }
}
