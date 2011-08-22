#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include <iostream>
#include <fstream>
#include <string>
using namespace rapidxml;
using namespace std;

int main(int argc, char ** argv )
{
  xml_document<> doc;    // character type defaults to char
  string text; //("<osm version='0.6'><node id='106070' timestamp='2006-05-16T05:22:53Z'  visible='false' version='1' changeset='16352' lat='-0.0000038' lon='0.0000000'></node><node id='106070' timestamp='2006-05-16T05:22:53Z'  visible='false' version='1' changeset='16352' lat='-0.0000038' lon='0.0000000'></node></osm>");
  string filename(argv[1]);
  cerr << "going to read file " << filename << endl;

  
  //  ifstream inf(filename.c_str());
  FILE *fp ;
  fp = fopen ( filename.c_str(), "r" ) ;

  const int blocksize=10000;
  char buffer[blocksize+1];
  //  while(inf)
  int res =1;
  while (res > 0)
    {
      res = fread(buffer,1,blocksize,fp);
      if(res > 0)
	{
	  //	/  int bread = inf.gcount();
	  cerr << "read " << res << endl;
	  buffer[res]=0;

	  doc.setStartText(&buffer[0]);// set the end of the buffer
	  doc.setTextEnd(&buffer[blocksize]);// set the end of the buffer

	  doc.parse<0>();    // parse the buffer we set...
	  if (doc.firsterror)
	    {
	      cerr << "first error:" << (int)( doc.firsterror - &buffer[0]  )<< endl;
	    }
	  if (doc.firsttext)
	    {
	      cerr << "first text:" << (int) (doc.firsttext - &buffer[0]) << endl;
	    }

	  if (doc.lastNode)
	    {
	      cerr << "lastNode:" << (int) (doc.lastNode - &buffer[0]) << endl;
	    }

	}
      else
	{
	  cerr << "error reading " << res << endl;
	}
    }

  //  cout << "read " << text << endl;  
  //  return 0;



    /*  xml_node<> *node = doc.first_node("node");
  if (node)
    {
      cout << "Name of my first node is: " << node->name() << "\n";
      cout << "Node foobar has value " << node->value() << "\n";
      for (xml_attribute<> *attr = node->first_attribute();
	   attr; attr = attr->next_attribute())
	{
	  cout << "Node foobar has attribute " << attr->name() << " ";
	  cout << "with value " << attr->value() << "\n";
	}
    }
    */
  rapidxml::print(cout, doc, 0); 
  //cout << doc;   
}




