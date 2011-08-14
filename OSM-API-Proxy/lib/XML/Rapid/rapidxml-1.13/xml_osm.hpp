
  template<class Ch> class xml_node_osm_node
  {
  public:
    static void process(xml_base<char> * self)
    {
      //      cout << "call back in the node" << endl;
    };


  };

  template<class Ch> class xml_node_osm_way
  {
  public:
    static void process(xml_base<char> * self)
    {
      //      cout << "we are in a way" << endl;
    };
  };

  template<class Ch> class xml_node_osm_tag
  {
  public:
    static void process(xml_base<char> * self)
    {
      //      cout << "we are in a tag" << endl;
    };
  };

  template<class Ch> class xml_node_osm_nd
  {
  public:
    static void process(xml_base<char> * self)
    {
      //      cout << "we are in a nd" << endl;
    };
  };


  template <>
  int xml_base<char>::name_mapper_loaded=0;

  //  template<class Ch = char>
  template <>
  void xml_base<char>::load_classes()
  {
    if (!name_mapper_loaded)
      {
	name_mapper["node"] = xml_node_osm_node<char>::process;
	name_mapper["way"] = xml_node_osm_way<char>::process;
	name_mapper["tag"] = xml_node_osm_tag<char>::process;
	name_mapper["nd"] = xml_node_osm_nd<char>::process;
	name_mapper_loaded++;
      }       
  };

  typedef void (*t_process_func)(xml_base<char> *) ;
  //      typedef std::map<std::string, t_process_func > t_name_mapper;
  typedef std::map<std::string, t_process_func > t_name_mapper;
  template <>
  t_name_mapper xml_base<char>::name_mapper=t_name_mapper();
