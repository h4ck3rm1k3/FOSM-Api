#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <string.h>
#include <stdlib.h>

%%{
machine osmkeys;

el_node = (
'node' @{
       world.set_current_element_type_node();
       }
     );

el_way = (
'way' @{
       world.set_current_element_type_way();
       }
     );

el_relation = (
'relation' @{
       world.set_current_element_type_rel();
       }
     );

el_tag = (
'tag' @{
       world.set_current_element_type_tag();
       }
     );

el_nd = (
'nd' @{
       world.set_current_element_type_nd();
       }
     );
el_member = (
'member' @{
       world.set_current_element_type_member();
       }
     );

tags = (
el_node | 
el_way |
el_relation |
el_nd |
el_member |
el_tag
);

std_attr = (
'version' |
'changeset' |
'uid' |
'user' |
'timestamp' |
'visible' 
);

node_attr = (
'lat' |
'lon' |
std_attr
);

way_attr = (
std_attr
);

nd_attr = (
'ref' 
);

relation_attr = (
              std_attr
);

member_attr = (
'type' |
'ref'  |
'role' 
);

tag_attr = (
'k' |
'v'  
);


tag_k_names = (
'natural' |
'highway' |
'name'  |
'landuse'  |
'ref'  |
'type'  |
'place'  |
'amenity'

);

coord = (
      /-?\d+\.\d+/ |
      /-?\d+/
      );

attrs = (
      node_attr |
      tag_attr  | 
      way_attr  |
      nd_attr  |
      relation_attr  |
      member_attr 
      );

attrs_val = ( attrs '=' '\'' [^']+ '\'' |
              attrs '=' '\"' [^"]+ '\"' 
            );

#   fgoto main;
end_element  = ('/>'
                |'>'
                ) @{
                world.set_current_element_type_none();
                };

action ActEnterAttribute {
           cout << "enter Attributes \n" ;      
            cout << "str:\'" << fpc << "\'" <<endl;     
           cout << "CS:" << fcurs << endl;     
       }

action ActEndAttribute {
           res = 2; 
           cout << "Attribute CS" << cs << endl;     
       }

action AddChar {
     currenttoken.push_back(fc);
}

action StartValue {
     currenttoken.clear();  
}

action FinishID {
     char *endptr;   // ignore
     world.set_current_id(strtol(currenttoken.c_str(), &endptr, 10));
//     cout << "ID " << id << endl;  
}

action RecordStart {
       // record the start of a type of object
       world.record_start_position();
}

quote = ('\''|'\"' );

id_val_start = ( 'id' '=' quote  @StartValue);
id_val_value = (  '-'? digit+  $AddChar );
id_val_end   = (  quote  @ FinishID );
id_val = ( id_val_start id_val_value id_val_end );

start_element = ( '<' tags @ RecordStart );
starter = ( start_element  | 
            id_val    |
            attrs_val |
            end_element
        @{
//                cout << "S"  << fcurs << ",";
          } );

#attrs_val 
#attrs

main := starter @{ res = 1; 
//        cout << "Main \n" ;
     };  

}%%

%% write data nofinal;

#define BUFSIZE 128
#include "fileindexer.hpp"

int scanner(OSMWorld & world,const char *s)
{
  int cs;
  int res = 0;
  string currenttoken;
  char *p= (char *)s;
  char *pe = (char *)s + strlen(s) +1 ;
  %% write init;
  %% write exec;
  
  return res;
}

int main (int argc, char ** argv)
{

  OSMWorld world; 

  if (argc!=2)
  {
        cerr << "first argument must be a file name:"  << argc << endl;
        return 1;
  }   

  string filename(argv[1]);

  cerr << "file name:"  << filename << endl;

  ifstream  stream(filename.c_str(),ios::binary);

  while(stream)
    {
      std::string s;
      stream >> s;
      int size =s.length();
      int test =stream.tellg();
      world.set_cur_position(test);

      int ret= scanner(world,s.c_str());
//      cout << "Found:" << s << " status:" << ret <<  endl;
//      cout << "CS:" << cs << endl;
    }
}
