using namespace std;
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <string.h>
#include <stdlib.h>


template <class T> class DataFile {

public:

  vector<T> data;
  ofstream  file;
  ofstream  txtfile;
  string    filename;
  long long total_count;
  
  DataFile(const char * filename)
    :file(string(string(filename) + ".bin").c_str()),
     txtfile(string(string(filename) + ".txt").c_str()),
     total_count(0),
     filename(filename)
  {    
  }           

  ~DataFile()
  {
    int count =data.size();
    write(count);
    file.close();
    txtfile.close();
    cout << "Closing file " << filename << ", wrote " << total_count << endl;
  }

  void flush()
  {
    write(data.size());
  }

  long long count()
  {
    return total_count;
  }

  void write(int count)
  {
    // append the data to the file
    file.write((const char*)&data[0], count * sizeof(T));

    typename vector<T>::iterator i;
    for(i=data.begin();i!=data.end();i++)
      {
        txtfile << *i << endl;
      }
    data.clear(); // erase the data
  }
  
  void push_back (const T& v){
    total_count++;
    //    cout << "pushing " << v << endl;
    data.push_back(v);
    int count =data.size();
    if (count > 4096)    
      {
        write(count);
      }           
  }
       
};


class OSMWorld
{
public:
  enum element_type_t{
    t_none=0,
    t_node,
    t_way,
    t_relation,

    ///subobjects
    t_tag,
    t_nd,
    t_member
    
  } current_element_type;
  
  long int object_count;
  long int current_id;
  long int current_cs;
  istream::pos_type marker; // position in the file

  DataFile<long int> node_positions;
  DataFile<long int> node_ids;
  DataFile<long int> node_cs;

  DataFile<long int> way_positions;
  DataFile<long int> way_ids;
  DataFile<long int> way_cs;

  DataFile<long int> rel_positions;
  DataFile<long int> rel_ids;
  DataFile<long int> rel_cs;

  OSMWorld () :
    current_id(0),
    object_count(0),
    current_cs(-1),
    current_element_type(t_none),

    // positions
    node_positions("node_positions"),
    way_positions("way_positions"),
    rel_positions("relation_positions"),

    //ids
    node_ids("node_ids"),
    way_ids("way_ids"),
    rel_ids("relation_ids"),

    // changesets
    node_cs("node_cs"),
    way_cs("way_cs"),
    rel_cs("relation_cs")
  {

  }

  element_type_t  get_current_element_type (){
    return current_element_type;
  }

  void  set_current_element_type_node (){
    check_counts_nodes();
    current_element_type=t_node;
  }

  void  set_current_element_type_way (){
    check_counts_ways();
    set_current_element_type_none ();
    current_element_type=t_way;
  }

  void  set_current_element_type_rel (){
    set_current_element_type_none ();
    current_element_type=t_relation;
  }

  void  set_current_element_type_tag (){
    set_current_element_type_none ();
    current_element_type=t_tag;
  }

  void  set_current_element_type_nd (){
    set_current_element_type_none ();
    current_element_type=t_nd;
  }

  void  set_current_element_type_member (){
    set_current_element_type_none ();
    current_element_type=t_member;
  }

  void  set_current_element_type_none (){
    //cerr << "set_current_element_type_none" << endl;
    if (get_current_element_type()!=t_none) {
      if (current_cs==-1)   {
        //  cerr<< "get_current_element_type:" << get_current_element_type() << endl;
        //cerr<< "current_id:" << current_id << endl;
        set_current_cs(-4); // was not set by the user
      }
      else   {
        //cerr << "cs is"<< current_cs << endl;
      }      
      current_element_type=t_none;
    }
    else {
      if (object_count)
        {
          //cerr << "element type was null" << endl;
        }
    }
    object_count++;
  }

  void add_node_position(){
    node_positions.push_back(marker);
  }

  void add_way_position(){
    way_positions.push_back(marker);
  }

  void add_rel_position(){
    rel_positions.push_back(marker);
  }

  void set_cur_position(int pos)
  {
    // cout << "Current pos is " << pos << endl;
    marker =pos;
  }

  void check_counts_nodes()
  {
    // make sure they all have the same count
    if (!(
          (node_positions.count() == node_ids.count() )
          &&
          (node_ids.count() ==  node_cs.count())
          ))
      {
        cerr << "current id " << current_id << endl;
        cerr << "node counts not aligned" << endl;
        cerr << "pos:" << node_positions.count() << endl;
        cerr << "ids: " << node_ids.count()       << endl;
        cerr << "cs :" << node_cs.count()       << endl;

        // write the files
        node_positions.flush();
        node_ids.flush();
        node_cs.flush();

        exit (233);
      }
  }

  void check_counts_ways()
  {
    // make sure they all have the same count
    if (!
        (
         (way_positions.count() ==  way_ids.count())
         &&
         (way_ids.count() ==  way_cs.count()
          )
         )
        )
      
      {
        cerr << current_id << endl;
        cerr << "way counts not aligned" << endl;
        cerr << way_positions.count() << endl;
        cerr << way_ids.count()       << endl;
        cerr << way_cs.count()       << endl;
        exit (233);
      }
  }

  void check_counts_rels()
  {
    // make sure they all have the same count
    if (!
        (rel_positions.count() ==  rel_ids.count() 
         &&
         rel_ids.count()  ==  rel_cs.count()
         )
        )
      {
        cerr << current_id << endl;
        cerr << "rel counts not aligned" << endl;
        cerr << rel_positions.count() << endl;
        cerr << rel_ids.count()       << endl;
        cerr << rel_cs.count()       << endl;
        exit (233);
      }
  }

  
  void set_current_id(long int id) {

    current_id=id;

    // write to disk
    switch (get_current_element_type()) {
    case t_node:
      node_ids.push_back(id);
      break;
      
    case    t_way:
      way_ids.push_back(id);
      break;
      
    case    t_relation:
      rel_ids.push_back(id);
      break;

    default:
      break;
    };
  }

  void set_current_cs(long int cs) {
    current_cs=cs;
    // write to disk
    switch (get_current_element_type()) {
    case t_node:
      node_cs.push_back(cs);
      break;      
    case    t_way:
      way_cs.push_back(cs);
      break;      
    case    t_relation:
      rel_cs.push_back(cs);
      break;

    case t_tag:
    case t_nd:
    case t_member:
      //      cerr << "these types dont have changesets type: " << get_current_element_type() << " cs "<< cs << endl;
      break;

    default:
      cerr << "wrong type for cs " << cs << endl;
      break;
    };   
  }

  void record_start_position() {
    // now we close the previous object if it is not closed

    switch (get_current_element_type()) {
    case         t_none:
      cout << "This should never happen none" << endl;
      break;      
    case t_node:
      add_node_position();            
      break;      
    case    t_way:
      add_way_position();            
      break;      
    case    t_relation:
      add_rel_position();            
      break;
    case    t_tag :
      break;
    case    t_nd :
      break;
    case    t_member :
      break;
    default:
      cout << "This should never happen other:" << get_current_element_type() << endl;
      break;
    };
  }

  void finish_current_object()
  {
    set_current_element_type_none ();
    // check default values
    current_cs=-1;// set the current value back to 0
    current_id=0;// set the current value back to 0

  }

};


