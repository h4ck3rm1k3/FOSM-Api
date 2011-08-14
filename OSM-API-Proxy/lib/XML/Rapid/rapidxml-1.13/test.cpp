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
  string text;
  string filename(argv[1]);
  cerr << "going to read file " << filename << endl;

  ifstream inf(filename.c_str());
  while(inf)
    {
      string l;
      inf >> l;
      text.append(l);
      text.append(" \n");// new line
      //      cout << "read " << l << endl;
    }
  doc.parse<0>((char*)text.c_str());    // 0 means default parse flags


  xml_node<> *node = doc.first_node("node");
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
  rapidxml::print(cout, doc, 0); 
  //cout << doc;   
}




