///////////////////////////////////////////////////////////////////////////
// XML base

//! Base class for xml_node and xml_attribute implementing common functions: 
//! name(), name_size(), value(), value_size() and parent().
//! \param Ch Character type to use

template<class Ch = char>
class xml_base 
{
public:        

  typedef void (*t_process_func)(xml_base<Ch> *) ;
  typedef std::map<std::string, t_process_func > t_name_mapper;
  
  ///////////////////////////////////////////////////////////////////////////
  // Construction & destruction
  static int name_mapper_loaded;
  static t_name_mapper name_mapper;
  
  static void load_classes();
  void clear()
  {
    //cerr << "going to remove this object" <<  name ()<< endl;
  }
  
  void checkclass () // TODO slowest function
  {
    if (m_name)
      {	
	load_classes();	
	string tname = string(name(),m_name_size);
	//	    typename std::map::iterator t;
	typename t_name_mapper::iterator found;
	found = name_mapper.find( tname ); 
	if ( found != name_mapper.end() )
	  {
	    // data was found
	    //	    cerr << "found data object" <<  name ()<< endl;
	    (*found).second(this); // call it 
	    
	  }
	else
	  {
	    //	    cout << "xml_base name:" << tname << "test" << endl;
	    //	    cout << "Missing type "<< tname << endl;
	  }
      }
    if (m_value)
      {
	//	    cout <<  "value:"   <<  m_value;
      }
    //	cout << endl;	
  };
  
  // Construct a base with empty name, value and parent
  xml_base()
    : m_name(0)
    , m_value(0)
    , m_parent(0)
    , m_subclass (0)
  {
  }
  
  ///////////////////////////////////////////////////////////////////////////
  // Node data access
  
  //! Gets name of the node. 
  //! Interpretation of name depends on type of node.
  //! Note that name will not be zero-terminated if rapidxml::parse_no_string_terminators option was selected during parse.
  //! <br><br>
  //! Use name_size() function to determine length of the name.
  //! \return Name of node, or empty string if node has no name.
  Ch *name() const
  {
            return m_name ? m_name : nullstr();
  }
  
  //! Gets size of node name, not including terminator character.
  //! This function works correctly irrespective of whether name is or is not zero terminated.
  //! \return Size of node name, in characters.
  std::size_t name_size() const
  {
    return m_name ? m_name_size : 0;
  }
  
  //! Gets value of node. 
  //! Interpretation of value depends on type of node.
  //! Note that value will not be zero-terminated if rapidxml::parse_no_string_terminators option was selected during parse.
  //! <br><br>
  //! Use value_size() function to determine length of the value.
  //! \return Value of node, or empty string if node has no value.
  Ch *value() const
  {
    return m_value ? m_value : nullstr();
  }

  //! Gets size of node value, not including terminator character.
  //! This function works correctly irrespective of whether value is or is not zero terminated.
  //! \return Size of node value, in characters.
  std::size_t value_size() const
  {
    return m_value ? m_value_size : 0;
  }

  ///////////////////////////////////////////////////////////////////////////
  // Node modification
    
  //! Sets name of node to a non zero-terminated string.
  //! See \ref ownership_of_strings.
  //! <br><br>
  //! Note that node does not own its name or value, it only stores a pointer to it. 
  //! It will not delete or otherwise free the pointer on destruction.
  //! It is reponsibility of the user to properly manage lifetime of the string.
  //! The easiest way to achieve it is to use memory_pool of the document to allocate the string -
  //! on destruction of the document the string will be automatically freed.
  //! <br><br>
  //! Size of name must be specified separately, because name does not have to be zero terminated.
  //! Use name(const Ch *) function to have the length automatically calculated (string must be zero terminated).
  //! \param name Name of node to set. Does not have to be zero terminated.
  //! \param size Size of name, in characters. This does not include zero terminator, if one is present.
  void name(const Ch *name, std::size_t size)
  {
    m_name = const_cast<Ch *>(name);
    m_name_size = size;
    // TODO : now we look up the right object for this name and allocate it
  }

  //! Sets name of node to a zero-terminated string.
  //! See also \ref ownership_of_strings and xml_node::name(const Ch *, std::size_t).
  //! \param name Name of node to set. Must be zero terminated.
  void name(const Ch *name)
  {
    this->name(name, internal::measure(name));
  }

  //! Sets value of node to a non zero-terminated string.
  //! See \ref ownership_of_strings.
  //! <br><br>
  //! Note that node does not own its name or value, it only stores a pointer to it. 
  //! It will not delete or otherwise free the pointer on destruction.
  //! It is reponsibility of the user to properly manage lifetime of the string.
  //! The easiest way to achieve it is to use memory_pool of the document to allocate the string -
  //! on destruction of the document the string will be automatically freed.
  //! <br><br>
  //! Size of value must be specified separately, because it does not have to be zero terminated.
  //! Use value(const Ch *) function to have the length automatically calculated (string must be zero terminated).
  //! <br><br>
  //! If an element has a child node of type node_data, it will take precedence over element value when printing.
  //! If you want to manipulate data of elements using values, use parser flag rapidxml::parse_no_data_nodes to prevent creation of data nodes by the parser.
  //! \param value value of node to set. Does not have to be zero terminated.
  //! \param size Size of value, in characters. This does not include zero terminator, if one is present.
  void value(const Ch *value, std::size_t size)
  {
    m_value = const_cast<Ch *>(value);
    m_value_size = size;
  }

  //! Sets value of node to a zero-terminated string.
  //! See also \ref ownership_of_strings and xml_node::value(const Ch *, std::size_t).
  //! \param value Vame of node to set. Must be zero terminated.
  void value(const Ch *value)
  {
    this->value(value, internal::measure(value));
  }

  ///////////////////////////////////////////////////////////////////////////
  // Related nodes access
    
  //! Gets node parent.
  //! \return Pointer to parent node, or 0 if there is no parent.
  xml_node<Ch> *parent() const
  {
    return m_parent;
  }

  bool should_append()
  {
    return this->m_subclass != 0;
  }
protected:

  // Return empty string
  static Ch *nullstr()
  {
    static Ch zero = Ch('\0');
    return &zero;
  }

  Ch *m_name;                         // Name of node, or 0 if no name
  Ch *m_value;                        // Value of node, or 0 if no value
  std::size_t m_name_size;            // Length of node name, or undefined of no name
  std::size_t m_value_size;           // Length of node value, or undefined if no value
  xml_node<Ch> *m_parent;             // Pointer to parent node, or 0 if none
  t_process_func m_subclass;
};
