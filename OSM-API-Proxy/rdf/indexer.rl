
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


end_element  = ('/>'
                |'>'
                ) @{
                     world.finish_current_object();

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


action RecordStart {
       // record the start of a type of object
       world.record_start_position();
}
quote = ('\''|'\"' );

action StartValue {
     currenttoken.clear();  
}
action AddChar {
     currenttoken.push_back(fc);
}

action AddChar2 {
//       cerr << fc << endl;
     currenttoken.push_back(fc);
}

# ID Field
action FinishID {
     char *endptr;   // ignore  
//     cerr << "currenttoken" << currenttoken << endl;
     world.set_current_id(strtol(currenttoken.c_str(), &endptr, 10));
}
id_val_start = ( 'id' '=' quote  @StartValue);
id_val_negvalue = (  '-'?  $AddChar2 );
id_val_value = (  id_val_negvalue digit+  $AddChar );
id_val_end   = (  quote  @ FinishID );
id_val = ( id_val_start id_val_value id_val_end );


#changeset
action FinishChangeset {
     char *endptr;   // ignore
     world.set_current_cs(strtol(currenttoken.c_str(), &endptr, 10));
}
cs_val_start = ( 'changeset' '=' quote  @StartValue);
cs_val_value = (   digit+  $AddChar );
cs_val_end   = (  quote  @ FinishChangeset );
cs_val = ( cs_val_start cs_val_value cs_val_end );


#versions
action FinishVersion {
     char *endptr;   // ignore
//     cerr << "Version " << currenttoken << endl;
     world.set_current_ver(strtol(currenttoken.c_str(), &endptr, 10));
}
ver_val_start = ( 'version' '=' quote  @StartValue);
ver_val_value = ( digit+  $AddChar );
ver_val_end   = ( quote  @ FinishVersion );
ver_val       = ( ver_val_start ver_val_value ver_val_end );


start_element = ( '<' tags @ RecordStart );
starter = ( start_element  | 
            id_val    |
            cs_val    |
            ver_val   | 
            attrs_val |
            end_element
           );


main := starter @{ res = 1;      };  

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
