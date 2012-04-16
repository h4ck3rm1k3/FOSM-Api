using namespace std;


template <class T> class DataFile
{
public:
  vector<T> data;
  ofstream  file;
  string    filename;
  long long total_count;
  
  DataFile(const char * filename)
    :file(filename),
     total_count(0),
     filename(filename)
  {
    
  }           

  ~DataFile()
  {
    int count =data.size();
    write(count);
    file.close();
    cout << "Closing file " << filename << ", wrote " << total_count << endl;
  }      
  
  void write(int count)
  {
    // append the data to the file
    file.write((const char*)&data[0], count * sizeof(T));
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

    t_tag,
    t_nd,
    t_member
    
  } current_element_type;
  
  long int current_id;
  istream::pos_type marker; // position in the file
  DataFile<long int> node_positions;
  DataFile<long int> way_positions;
  DataFile<long int> rel_positions;

  OSMWorld () :
    current_id(0),
    current_element_type(t_none),
    node_positions("node_positions"),
    way_positions("way_positions"),
    rel_positions("relation_positions")
  {

  }

  element_type_t  get_current_element_type (){
    return current_element_type;
  }

  void  set_current_element_type_node (){
    current_element_type=t_node;
  }

  void  set_current_element_type_way (){
    current_element_type=t_way;
  }

  void  set_current_element_type_rel (){
    current_element_type=t_relation;
  }


  void  set_current_element_type_tag (){
    current_element_type=t_tag;
  }

  void  set_current_element_type_nd (){
    current_element_type=t_nd;
  }

  void  set_current_element_type_member (){
    current_element_type=t_member;
  }

  void  set_current_element_type_none (){
    current_element_type=t_none;
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

  void set_current_id(long int id) {
    current_id=id;
  }

  void record_start_position() {
    switch (get_current_element_type()) {

    case         t_none:
      cout << "This should never happen none" << endl;
      break;
      
    case t_node:
      add_node_position();            
      break;
      
    case    t_way:
      break;
      
    case    t_relation:
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

};


