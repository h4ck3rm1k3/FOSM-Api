
///////////////////////////////////////////////////////////////////////////
// XML node

//! Class representing a node of XML document. 
//! Each node may have associated name and value strings, which are available through name() and value() functions. 
//! Interpretation of name and value depends on type of the node.
//! Type of node can be determined by using type() function.
//! <br><br>
//! Note that after parse, both name and value of node, if any, will point interior of source text used for parsing. 
//! Thus, this text must persist in the memory for the lifetime of node.
//! \param Ch Character type to use.
  
template<class Ch = char>
class xml_node: public xml_base<Ch>
{      
public:

  ///////////////////////////////////////////////////////////////////////////
  // Construction & destruction
    
  //! Constructs an empty node with the specified type. 
  //! Consider using memory_pool of appropriate document to allocate nodes manually.
  //! \param type Type of node to construct.
  xml_node(node_type type)
    : m_type(type)
    , m_first_node(0)
    , m_first_attribute(0)
  {
  }

  ///////////////////////////////////////////////////////////////////////////
  // Node data access
    
  //! Gets type of node.
  //! \return Type of node.
  node_type type() const
  {
    return m_type;
  }

  ///////////////////////////////////////////////////////////////////////////
  // Related nodes access
    
  //! Gets document of which node is a child.
  //! \return Pointer to document that contains this node, or 0 if there is no parent document.
  xml_document<Ch> *document() const
  {
    xml_node<Ch> *node = const_cast<xml_node<Ch> *>(this);
    while (node->parent())
      node = node->parent();
    return node->type() == node_document ? static_cast<xml_document<Ch> *>(node) : 0;
  }

  //! Gets first child node, optionally matching node name.
  //! \param name Name of child to find, or 0 to return first child regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found child, or 0 if not found.
  xml_node<Ch> *first_node(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_node<Ch> *child = m_first_node; child; child = child->next_sibling())
	  if (internal::compare(child->name(), child->name_size(), name, name_size, case_sensitive))
	    return child;
	return 0;
      }
    else
      return m_first_node;
  }

  //! Gets last child node, optionally matching node name. 
  //! Behaviour is undefined if node has no children.
  //! Use first_node() to test if node has children.
  //! \param name Name of child to find, or 0 to return last child regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found child, or 0 if not found.
  xml_node<Ch> *last_node(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    assert(m_first_node);  // Cannot query for last child if node has no children
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_node<Ch> *child = m_last_node; child; child = child->previous_sibling())
	  if (internal::compare(child->name(), child->name_size(), name, name_size, case_sensitive))
	    return child;
	return 0;
      }
    else
      return m_last_node;
  }

  //! Gets previous sibling node, optionally matching node name. 
  //! Behaviour is undefined if node has no parent.
  //! Use parent() to test if node has a parent.
  //! \param name Name of sibling to find, or 0 to return previous sibling regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found sibling, or 0 if not found.
  xml_node<Ch> *previous_sibling(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    assert(this->m_parent);     // Cannot query for siblings if node has no parent
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_node<Ch> *sibling = m_prev_sibling; sibling; sibling = sibling->m_prev_sibling)
	  if (internal::compare(sibling->name(), sibling->name_size(), name, name_size, case_sensitive))
	    return sibling;
	return 0;
      }
    else
      return m_prev_sibling;
  }

  //! Gets next sibling node, optionally matching node name. 
  //! Behaviour is undefined if node has no parent.
  //! Use parent() to test if node has a parent.
  //! \param name Name of sibling to find, or 0 to return next sibling regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found sibling, or 0 if not found.
  xml_node<Ch> *next_sibling(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    assert(this->m_parent);     // Cannot query for siblings if node has no parent
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_node<Ch> *sibling = m_next_sibling; sibling; sibling = sibling->m_next_sibling)
	  if (internal::compare(sibling->name(), sibling->name_size(), name, name_size, case_sensitive))
	    return sibling;
	return 0;
      }
    else
      return m_next_sibling;
  }

  //! Gets first attribute of node, optionally matching attribute name.
  //! \param name Name of attribute to find, or 0 to return first attribute regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found attribute, or 0 if not found.
  xml_attribute<Ch> *first_attribute(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_attribute<Ch> *attribute = m_first_attribute; attribute; attribute = attribute->m_next_attribute)
	  if (internal::compare(attribute->name(), attribute->name_size(), name, name_size, case_sensitive))
	    return attribute;
	return 0;
      }
    else
      return m_first_attribute;
  }

  //! Gets last attribute of node, optionally matching attribute name.
  //! \param name Name of attribute to find, or 0 to return last attribute regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
  //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
  //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
  //! \return Pointer to found attribute, or 0 if not found.
  xml_attribute<Ch> *last_attribute(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
  {
    if (name)
      {
	if (name_size == 0)
	  name_size = internal::measure(name);
	for (xml_attribute<Ch> *attribute = m_last_attribute; attribute; attribute = attribute->m_prev_attribute)
	  if (internal::compare(attribute->name(), attribute->name_size(), name, name_size, case_sensitive))
	    return attribute;
	return 0;
      }
    else
      return m_first_attribute ? m_last_attribute : 0;
  }

  ///////////////////////////////////////////////////////////////////////////
  // Node modification
    
  //! Sets type of node.
  //! \param type Type of node to set.
  void type(node_type type)
  {
    m_type = type;
  }

  ///////////////////////////////////////////////////////////////////////////
  // Node manipulation

  //! Prepends a new child node.
  //! The prepended child becomes the first child, and all existing children are moved one position back.
  //! \param child Node to prepend.
  void prepend_node(xml_node<Ch> *child)
  {
    assert(child && !child->parent() && child->type() != node_document);
    if (first_node())
      {
	child->m_next_sibling = m_first_node;
	m_first_node->m_prev_sibling = child;
      }
    else
      {
	child->m_next_sibling = 0;
	m_last_node = child;
      }
    m_first_node = child;
    child->m_parent = this;
    child->m_prev_sibling = 0;
  }

  //! Appends a new child node. 
  //! The appended child becomes the last child.
  //! \param child Node to append.
  bool should_append()
  {
    return this->m_subclass != 0;
  }


  void print (std::ostream & os)
  {
    string name(this->name(),this->name_size());
    os << "Node:" << name << endl;
    //if (attribute->name() && attribute->value())

  }

  void append_node(xml_node<Ch> *child)
  {
    //    this->checkclass ();
    //    child->checkclass(); // on the child
    child->print(std::cerr);
    if (this->should_append())
      {
	//	assert(child && !child->parent() && child->type() != node_document);
	assert(child && child->type() != node_document);
	if (first_node())
	  {
	    child->m_prev_sibling = m_last_node;
	    m_last_node->m_next_sibling = child;
	  }
	else
	  {
	    child->m_prev_sibling = 0;
	    m_first_node = child;
	  }
	m_last_node = child;
	child->m_parent = this;
	child->m_next_sibling = 0;

	// now do the right blessings inside
	// check the class of the parent
	// check the class of the child


	
      }
    else
      {
	//	cout << "going to remove the child object" << endl;
	child->clear();
	// delete child;
      }
	    
  }

  //! Inserts a new child node at specified place inside the node. 
  //! All children after and including the specified node are moved one position back.
  //! \param where Place where to insert the child, or 0 to insert at the back.
  //! \param child Node to insert.
  void insert_node(xml_node<Ch> *where, xml_node<Ch> *child)
  {
    assert(!where || where->parent() == this);
    assert(child && !child->parent() && child->type() != node_document);
    if (where == m_first_node)
      prepend_node(child);
    else if (where == 0)
      append_node(child);
    else
      {
	child->m_prev_sibling = where->m_prev_sibling;
	child->m_next_sibling = where;
	where->m_prev_sibling->m_next_sibling = child;
	where->m_prev_sibling = child;
	child->m_parent = this;
      }
  }

  //! Removes first child node. 
  //! If node has no children, behaviour is undefined.
  //! Use first_node() to test if node has children.
  void remove_first_node()
  {
    assert(first_node());
    xml_node<Ch> *child = m_first_node;
    m_first_node = child->m_next_sibling;
    if (child->m_next_sibling)
      child->m_next_sibling->m_prev_sibling = 0;
    else
      m_last_node = 0;
    child->m_parent = 0;
  }

  //! Removes last child of the node. 
  //! If node has no children, behaviour is undefined.
  //! Use first_node() to test if node has children.
  void remove_last_node()
  {
    assert(first_node());
    xml_node<Ch> *child = m_last_node;
    if (child->m_prev_sibling)
      {
	m_last_node = child->m_prev_sibling;
	child->m_prev_sibling->m_next_sibling = 0;
      }
    else
      m_first_node = 0;
    child->m_parent = 0;
  }

  //! Removes specified child from the node
  // \param where Pointer to child to be removed.
  void remove_node(xml_node<Ch> *where)
  {
    assert(where && where->parent() == this);
    assert(first_node());
    if (where == m_first_node)
      remove_first_node();
    else if (where == m_last_node)
      remove_last_node();
    else
      {
	where->m_prev_sibling->m_next_sibling = where->m_next_sibling;
	where->m_next_sibling->m_prev_sibling = where->m_prev_sibling;
	where->m_parent = 0;
      }
  }

  //! Removes all child nodes (but not attributes).
  void remove_all_nodes()
  {
    for (xml_node<Ch> *node = first_node(); node; node = node->m_next_sibling)
      node->m_parent = 0;
    m_first_node = 0;
  }

  //! Prepends a new attribute to the node.
  //! \param attribute Attribute to prepend.
  void prepend_attribute(xml_attribute<Ch> *attribute)
  {
    cerr << "prepend_attribute" << endl;
    //    assert(attribute && !attribute->parent());
    assert(attribute);
    if (first_attribute())
      {
	attribute->m_next_attribute = m_first_attribute;
	m_first_attribute->m_prev_attribute = attribute;
      }
    else
      {
	attribute->m_next_attribute = 0;
	m_last_attribute = attribute;
      }
    m_first_attribute = attribute;
    attribute->m_parent = this;
    attribute->m_prev_attribute = 0;
  }

  //! Appends a new attribute to the node.
  //! \param attribute Attribute to append.
  void append_attribute(xml_attribute<Ch> *attribute)
  {
    string name(attribute->name(),attribute->name_size());
    string val(attribute->value(),attribute->value_size());
    cerr << "attribute: " << name << " val " << val  << endl;
    
    //    assert(attribute && !attribute->parent());
    assert(attribute);
    if (first_attribute())
      {
	attribute->m_prev_attribute = m_last_attribute;
	m_last_attribute->m_next_attribute = attribute;
      }
    else
      {
	attribute->m_prev_attribute = 0;
	m_first_attribute = attribute;
      }
    m_last_attribute = attribute;
    attribute->m_parent = this;
    attribute->m_next_attribute = 0;
  }

  //! Inserts a new attribute at specified place inside the node. 
  //! All attributes after and including the specified attribute are moved one position back.
  //! \param where Place where to insert the attribute, or 0 to insert at the back.
  //! \param attribute Attribute to insert.
  void insert_attribute(xml_attribute<Ch> *where, xml_attribute<Ch> *attribute)
  {
    cerr << "insert_attribute" << endl;
    assert(!where || where->parent() == this);
    //    assert(attribute && !attribute->parent());
    assert(attribute);
    if (where == m_first_attribute)
      prepend_attribute(attribute);
    else if (where == 0)
      append_attribute(attribute);
    else
      {
	attribute->m_prev_attribute = where->m_prev_attribute;
	attribute->m_next_attribute = where;
	where->m_prev_attribute->m_next_attribute = attribute;
	where->m_prev_attribute = attribute;
	attribute->m_parent = this;
      }
  }

  //! Removes first attribute of the node. 
  //! If node has no attributes, behaviour is undefined.
  //! Use first_attribute() to test if node has attributes.
  void remove_first_attribute()
  {
    assert(first_attribute());
    xml_attribute<Ch> *attribute = m_first_attribute;
    if (attribute->m_next_attribute)
      {
	attribute->m_next_attribute->m_prev_attribute = 0;
      }
    else
      m_last_attribute = 0;
    attribute->m_parent = 0;
    m_first_attribute = attribute->m_next_attribute;
  }

  //! Removes last attribute of the node. 
  //! If node has no attributes, behaviour is undefined.
  //! Use first_attribute() to test if node has attributes.
  void remove_last_attribute()
  {
    assert(first_attribute());
    xml_attribute<Ch> *attribute = m_last_attribute;
    if (attribute->m_prev_attribute)
      {
	attribute->m_prev_attribute->m_next_attribute = 0;
	m_last_attribute = attribute->m_prev_attribute;
      }
    else
      m_first_attribute = 0;
    attribute->m_parent = 0;
  }

  //! Removes specified attribute from node.
  //! \param where Pointer to attribute to be removed.
  void remove_attribute(xml_attribute<Ch> *where)
  {
    assert(first_attribute() && where->parent() == this);
    if (where == m_first_attribute)
      remove_first_attribute();
    else if (where == m_last_attribute)
      remove_last_attribute();
    else
      {
	where->m_prev_attribute->m_next_attribute = where->m_next_attribute;
	where->m_next_attribute->m_prev_attribute = where->m_prev_attribute;
	where->m_parent = 0;
      }
  }

  //! Removes all attributes of node.
  void remove_all_attributes()
  {
    for (xml_attribute<Ch> *attribute = first_attribute(); attribute; attribute = attribute->m_next_attribute)
      attribute->m_parent = 0;
    m_first_attribute = 0;
  }
        
private:

  ///////////////////////////////////////////////////////////////////////////
  // Restrictions

  // No copying
  xml_node(const xml_node &);
  void operator =(const xml_node &);
    
  ///////////////////////////////////////////////////////////////////////////
  // Data members
    
  // Note that some of the pointers below have UNDEFINED values if certain other pointers are 0.
  // This is required for maximum performance, as it allows the parser to omit initialization of 
  // unneded/redundant values.
  //
  // The rules are as follows:
  // 1. first_node and first_attribute contain valid pointers, or 0 if node has no children/attributes respectively
  // 2. last_node and last_attribute are valid only if node has at least one child/attribute respectively, otherwise they contain garbage
  // 3. prev_sibling and next_sibling are valid only if node has a parent, otherwise they contain garbage

  node_type m_type;                       // Type of node; always valid
  xml_node<Ch> *m_first_node;             // Pointer to first child node, or 0 if none; always valid
  xml_node<Ch> *m_last_node;              // Pointer to last child node, or 0 if none; this value is only valid if m_first_node is non-zero
  xml_attribute<Ch> *m_first_attribute;   // Pointer to first attribute of node, or 0 if none; always valid
  xml_attribute<Ch> *m_last_attribute;    // Pointer to last attribute of node, or 0 if none; this value is only valid if m_first_attribute is non-zero
  xml_node<Ch> *m_prev_sibling;           // Pointer to previous sibling of node, or 0 if none; this value is only valid if m_parent is non-zero
  xml_node<Ch> *m_next_sibling;           // Pointer to next sibling of node, or 0 if none; this value is only valid if m_parent is non-zero

};
