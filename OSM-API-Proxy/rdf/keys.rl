#include <iostream>

#include <string>
#include <string.h>


%%{
machine osmkeys;

tags = (
'node' |
'way' |
'nd' |
'relation' |
'member' |
'tag' 
);

nodeattr = (
'lat' |
'lon' |
'id' |
'version' |
'changeset' |
'uid' |
'timestamp' |
'visible' 
);

relationattr = (
'id' |
'version' |
'changeset' |
'uid' |
'timestamp' |
'visible' 
);

wayattr = (
'id' |
'version' |
'changeset' |
'uid' |
'timestamp' |
'visible' 
);

ndattr = (
'ref' 
);

relationattr = (
'type' |
'ref'  |
'role' 
);

tagattr = (
'k' |
'v'  |
);

tagnames = (
'natural' |
'highway' |
'name'  |
'landuse'  |
'ref'  |
'type'  |
'place'  |
'amenity'
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
