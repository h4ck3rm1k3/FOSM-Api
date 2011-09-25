
///////////////////////////////////////////////////////////////////////////
// XML document
    
//! This class represents root of the DOM hierarchy. 
//! It is also an xml_node and a memory_pool through public inheritance.
//! Use parse() function to build a DOM tree from a zero-terminated XML text string.
//! parse() function allocates memory for nodes and attributes by using functions of xml_document, 
//! which are inherited from memory_pool.
//! To access root node of the document, use the document itself, as if it was an xml_node.
//! \param Ch Character type to use.
template<class Ch = char>
class xml_document: public xml_node<Ch>, public memory_pool<Ch>
{
    
public:
  Ch *firsterror;// the position of the first error
  Ch *firsttext;// the position of the first text found
  Ch *lastNode;// the position of the last node found, everything after goes to the next file
  Ch *starttext;// the start of the text to parse
  Ch *endtext;
  Ch *curtext;

  Ch * getText() // called many many times
  {
    return curtext;
  }

  void endPos(Ch *node)
  {
    lastNode=node;	 
  }

  void setError(Ch *error)
  {
    if (!firsterror)
      {
	firsterror=error;
      }
  }

  void setFirstNode(Ch *text)
  {
    firsttext=text;
  }

  void setStartText(Ch *text)
  {
    starttext=text;
  }

  void setText(Ch *text)
  {
    if (&curtext[0] <= text)
      {
	if (text <= endtext)
	  {
	    curtext=text;
	  }
	else
	  {
	    cerr << (unsigned long)&curtext[0] << " < " << (unsigned long)text << " < " << (unsigned long) endtext << endl;
	    ParseError("access past end of string1");
	  }
      }
    else
      {
	cerr << (unsigned long)&curtext[0] << " < " << (unsigned long)text << " < " << (unsigned long) endtext << endl;
	ParseError("access past end of string 3");
      }
    
  }

  void setTextEnd(Ch *text)
  {
    endtext=text;
  }



  Ch getChar(char pos=0)
  {
    if (&curtext[pos] <= endtext)
      {
	return curtext[pos];
      }
    else
      {
	cerr << (unsigned long)&curtext[0] << " < " << (unsigned long)&curtext[pos] << " < " << (unsigned long) endtext << endl;
	ParseError("access past end of string");
      }
  }

  void ParseError(const char * error, const char * text="")
  {
    cerr << "Error" << error << " text " << text; 
  }
  // set the text char
  void setTextChar( char c,int offset)
  {
    curtext[offset]=c;
  }
      
  bool incrementText(int size=1)
  {
    if (curtext + size < endtext -1)
      {
	curtext+=size;
	return 1;
      }
    else
      {
	cerr << "at the end of the buffer, cannot continue";
	return 0;
      }
  }

  //! Constructs empty XML document
  xml_document()
    : xml_node<Ch>(node_document),
      firsterror (0),
      firsttext(0),
      lastNode(0),
      endtext(0),
      starttext(0),
      curtext(0)
  {
  }

      
  //! Parses zero-terminated XML string according to given flags.
  //! Passed string will be modified by the parser, unless rapidxml::parse_non_destructive flag is used.
  //! The string must persist for the lifetime of the document.
  //! In case of error, rapidxml::parse_error exception will be thrown.
  //! <br><br>
  //! If you want to parse contents of a file, you must first load the file into the memory, and pass pointer to its beginning.
  //! Make sure that data is zero-terminated.
  //! <br><br>
  //! Document can be parsed into multiple times. 
  //! Each new call to parse removes previous nodes and attributes (if any), but does not clear memory pool.
  //! \param text XML data to parse; pointer is non-const to denote fact that this data may be modified by the parser.
  template<int Flags>
  bool parse( )
  {
    curtext=starttext; // the start of the text
    assert(getText());
            
    // Remove current contents
    this->remove_all_nodes();
    this->remove_all_attributes();
            
    // Parse BOM, if any
    parse_bom<Flags>();

    int startup=1;
    // Parse children
    while (1)
      {
	// Skip whitespace before node
	skip<whitespace_pred, Flags>();
	if (*getText() == 0)
	  break;

	// Parse and append new child
	if (*getText() == Ch('<'))
	  {
	    if (startup)
	      {
		startup=0;// we are no longer in the startup
		setFirstNode(getText()); //
	      }
		  
	    if (incrementText())     // Skip '<'
	      {
		if (xml_node<Ch> *node = parse_node<Flags>())
		  {
		    this->append_node(node);
		    
		  }
		else
		  {
		    cerr << "no node returned " << endl;
		    return 0;
		  }
	      }
	    else
	      {
		return 0; // return 
	      }


	  }
	else
	  {
	    incrementText();     // Skip the nex char... 
	    if (startup)
	      {
		//*skipped_start++; // we count all the data skipped on the startup, and add that to the data skipped at the end of the last block
	      }
	    else
	      {
		cerr << "internal error: expected <, got :" << getChar() << endl;			
		return 0;
	      }

	    // all the data 
	  }
      }
    return 1;
  }

  //! Clears the document by deleting all nodes and clearing the memory pool.
  //! All nodes owned by document pool are destroyed.
  void clear()
  {
    this->remove_all_nodes();
    this->remove_all_attributes();
    memory_pool<Ch>::clear();
  }
        
private:

  ///////////////////////////////////////////////////////////////////////
  // Internal character utility functions
        
  // Detect whitespace character
  struct whitespace_pred
  {
    static unsigned char test(Ch ch)
    {
      //	      cout << "test:" << ch << endl;
      // sometimes this char is uninitialized
      return internal::lookup_tables<0>::lookup_whitespace[static_cast<unsigned char>(ch)];
    }
  };

  // Detect node name character
  struct node_name_pred
  {
    static unsigned char test(Ch ch)
    {
      return internal::lookup_tables<0>::lookup_node_name[static_cast<unsigned char>(ch)];
    }
  };

  // Detect attribute name character, xml_internal.hpp:124:        const unsigned char lookup_tables<Dummy>::lookup_attribute_name[256]  this is a table of xml attribute valid characters.
  struct attribute_name_pred
  {
    static unsigned char test(Ch ch)
    {
      return internal::lookup_tables<0>::lookup_attribute_name[static_cast<unsigned char>(ch)];
    }
  };

  // Detect text character (PCDATA)
  struct text_pred
  {
    static unsigned char test(Ch ch)
    {
      return internal::lookup_tables<0>::lookup_text[static_cast<unsigned char>(ch)];
    }
  };

  // Detect text character (PCDATA) that does not require processing
  struct text_pure_no_ws_pred
  {
    static unsigned char test(Ch ch)
    {
      return internal::lookup_tables<0>::lookup_text_pure_no_ws[static_cast<unsigned char>(ch)];
    }
  };

  // Detect text character (PCDATA) that does not require processing
  struct text_pure_with_ws_pred
  {
    static unsigned char test(Ch ch)
    {
      return internal::lookup_tables<0>::lookup_text_pure_with_ws[static_cast<unsigned char>(ch)];
    }
  };

  // Detect attribute value character, checks if it is a quote char
  template<Ch Quote>
  struct attribute_value_pred
  {
    static unsigned char test(Ch ch)
    {
      if (Quote == Ch('\''))
	return internal::lookup_tables<0>::lookup_attribute_data_1[static_cast<unsigned char>(ch)];
      if (Quote == Ch('\"'))
	return internal::lookup_tables<0>::lookup_attribute_data_2[static_cast<unsigned char>(ch)];
      return 0;       // Should never be executed, to avoid warnings on Comeau
    }
  };

  // Detect attribute value character
  template<Ch Quote>
  struct attribute_value_pure_pred
  {
    static unsigned char test(Ch ch)
    {
      if (Quote == Ch('\''))
	return internal::lookup_tables<0>::lookup_attribute_data_1_pure[static_cast<unsigned char>(ch)];
      if (Quote == Ch('\"'))
	{
	  char c =static_cast<unsigned char>(ch);
	  return internal::lookup_tables<0>::lookup_attribute_data_2_pure[c];
	}
      return 0;       // Should never be executed, to avoid warnings on Comeau
    }
  };

  // Insert coded character, using UTF8 or 8-bit ASCII
  template<int Flags>
  static void insert_coded_character( unsigned long code)
  {
    if (Flags & parse_no_utf8)
      {
	// Insert 8-bit ASCII character
	// Todo: possibly verify that code is less than 256 and use replacement char otherwise?
	setTextChar( static_cast<unsigned char>(code));
	//	      text += 1;
      }
    else
      {
	// Insert UTF8 sequence
	if (code < 0x80)    // 1 byte sequence
	  {
	    setTextChar( static_cast<unsigned char>(code));
	    //                    text += 1;
	    incrementText();
	  }
	else if (code < 0x800)  // 2 byte sequence
	  {
	    setTextChar( static_cast<unsigned char>((code | 0x80) & 0xBF));
	    code >>= 6,1;
	    setTextChar( static_cast<unsigned char>(code | 0xC0),0);
	    //text += 2;
	    incrementText(2);
	  }
	else if (code < 0x10000)    // 3 byte sequence
	  {
	    setTextChar(static_cast<unsigned char>((code | 0x80) & 0xBF),2);
	    code >>= 6;
	    setTextChar(static_cast<unsigned char>((code | 0x80) & 0xBF),1);
	    code >>= 6;
	    setTextChar( static_cast<unsigned char>(code | 0xE0,0));
	    //			       text += 3;
	    incrementText(3);
	  }
	else if (code < 0x110000)   // 4 byte sequence
	  {
	    setTextChar(static_cast<unsigned char>((code | 0x80) & 0xBF),3);
	    code >>= 6;
	    setTextChar(static_cast<unsigned char>((code | 0x80) & 0xBF),2);
	    code >>= 6;
	    setTextChar(static_cast<unsigned char>((code | 0x80) & 0xBF),1);
	    code >>= 6;
	    setTextChar(static_cast<unsigned char>(code | 0xF0,0));
	    incrementText(4);
	  }
	else    // Invalid, only codes up to 0x10FFFF are allowed in Unicode
	  {
	    ParseError("invalid numeric character entity",getText());
	  }
      }
  }
      
  // Skip characters until predicate evaluates to true
  template<class StopPred, int Flags>
  void skip()
  {
    Ch *tmp = getText();
    while (StopPred::test(*tmp))
      ++tmp;
    if (tmp != getText())
      {
	if (tmp < endtext)
	  {
	    setText(tmp);
	  }
	else
	  {
	    // end of string
	  }
      }
  }

  // Skip characters until predicate evaluates to true while doing the following:
  // - replacing XML character entity references with proper characters (&apos; &amp; &quot; &lt; &gt; &#...;)
  // - condensing whitespace sequences to single space character
  template<class StopPred, class StopPredPure, int Flags>
  Ch *skip_and_expand_character_refs()
  {
    // If entity translation, whitespace condense and whitespace trimming is disabled, use plain skip
    if (Flags & parse_no_entity_translation && 
	!(Flags & parse_normalize_whitespace) &&
	!(Flags & parse_trim_whitespace))
      {
	skip<StopPred, Flags>();
	return getText();
      }
            
    // Use simple skip until first modification is detected
    skip<StopPredPure, Flags>();

    // Use translation skip
    Ch *src = getText();
    Ch *dest = src;
    while (StopPred::test(*src))
      {
	// If entity translation is enabled    
	if (!(Flags & parse_no_entity_translation))
	  {
	    // Test if replacement is needed
	    if (src[0] == Ch('&'))
	      {
		switch (src[1])
		  {

		    // &amp; &apos;
		  case Ch('a'): 
		    if (src[2] == Ch('m') && src[3] == Ch('p') && src[4] == Ch(';'))
		      {
			*dest = Ch('&');
			++dest;
			src += 5;
			continue;
		      }
		    if (src[2] == Ch('p') && src[3] == Ch('o') && src[4] == Ch('s') && src[5] == Ch(';'))
		      {
			*dest = Ch('\'');
			++dest;
			src += 6;
			continue;
		      }
		    break;

		    // &quot;
		  case Ch('q'): 
		    if (src[2] == Ch('u') && src[3] == Ch('o') && src[4] == Ch('t') && src[5] == Ch(';'))
		      {
			*dest = Ch('"');
			++dest;
			src += 6;
			continue;
		      }
		    break;

		    // &gt;
		  case Ch('g'): 
		    if (src[2] == Ch('t') && src[3] == Ch(';'))
		      {
			*dest = Ch('>');
			++dest;
			src += 4;
			continue;
		      }
		    break;

		    // &lt;
		  case Ch('l'): 
		    if (src[2] == Ch('t') && src[3] == Ch(';'))
		      {
			*dest = Ch('<');
			++dest;
			src += 4;
			continue;
		      }
		    break;

		    // &#...; - assumes ASCII

		  case Ch('#'): 
		    if (src[2] == Ch('x'))
		      {
			unsigned long code = 0;
			src += 3;   // Skip &#x
			while (1)
			  {
			    unsigned char digit = internal::lookup_tables<0>::lookup_digits[static_cast<unsigned char>(*src)];
			    if (digit == 0xFF)
			      break;
			    code = code * 16 + digit;
			    ++src;
			  }
			ParseError("TODO insert_coded_character");
			//insert_coded_character<Flags>(dest, code);    // Put character in output
		      }
		    else
		      {
			unsigned long code = 0;
			src += 2;   // Skip &#
			while (1)
			  {
			    unsigned char digit = internal::lookup_tables<0>::lookup_digits[static_cast<unsigned char>(*src)];
			    if (digit == 0xFF)
			      break;
			    code = code * 10 + digit;
			    ++src;
			  }
			ParseError("TODO insert_coded_character");
			//insert_coded_character<Flags>(dest, code);    // Put character in output
		      }
		    if (*src == Ch(';'))
		      ++src;
		    else
		      ParseError("expected ;", src);
		    continue;

		    // Something else
		  default:
		    // Ignore, just copy '&' verbatim
		    break;

		  }
	      }
	  }
                
	// If whitespace condensing is enabled
	if (Flags & parse_normalize_whitespace)
	  {
	    // Test if condensing is needed                 
	    if (whitespace_pred::test(*src))
	      {
		*dest = Ch(' '); ++dest;    // Put single space in dest
		++src;                      // Skip first whitespace char
		// Skip remaining whitespace chars
		while (whitespace_pred::test(*src))
		  ++src;
		continue;
	      }
	  }

	// No replacement, only copy character
	*dest++ = *src++;

      }

    // Return new end
    setText(src);
    return dest;

  }

  ///////////////////////////////////////////////////////////////////////
  // Internal parsing functions
        
  // Parse BOM, if any
  template<int Flags>
  void parse_bom()
  {
    // UTF-8?
    Ch * text = getText();
    if (static_cast<unsigned char>(getChar()) == 0xEF && 
	static_cast<unsigned char>(text[1]) == 0xBB && 
	static_cast<unsigned char>(text[2]) == 0xBF)
      {

	incrementText(3);
      }
  }

  // Parse and append data
  // Return character that ends data.
  // This is necessary because this character might have been overwritten by a terminating 0
  template<int Flags>
  Ch parse_and_append_data(xml_node<Ch> *node,  Ch *contents_start)
  {
    // Backup to contents start if whitespace trimming is disabled
    if (!(Flags & parse_trim_whitespace))
      setText(contents_start);     
            
    // Skip until end of data
    Ch *value = getText(), *end;
    if (Flags & parse_normalize_whitespace)
      end = skip_and_expand_character_refs<text_pred, text_pure_with_ws_pred, Flags>();   
    else
      end = skip_and_expand_character_refs<text_pred, text_pure_no_ws_pred, Flags>();

    if (end - value <= 0)
      {
	cout << "reached the end in parse and append" <<endl;
	return -1;
      }

    // Trim trailing whitespace if flag is set; leading was already trimmed by whitespace skip after >
    if (Flags & parse_trim_whitespace)
      {
	if (Flags & parse_normalize_whitespace)
	  {
	    // Whitespace is already condensed to single space characters by skipping function, so just trim 1 char off the end
	    if (*(end - 1) == Ch(' '))
	      --end;
	  }
	else
	  {
	    // Backup until non-whitespace character is found
	    while (whitespace_pred::test(*(end - 1)))
	      --end;
	  }
      }
            
    // If characters are still left between end and value (this test is only necessary if normalization is enabled)
    // Create new data node
    if (!(Flags & parse_no_data_nodes))
      {
	static xml_node<Ch> adata(node_data);// = this->allocate_node(node_data);
	xml_node<Ch> *data = &adata;// = this->allocate_node(node_data);
	data->value(value, end - value);
	node->append_node(data);
      }

    // Add data to parent node if no data exists yet
    if (!(Flags & parse_no_element_values)) 
      if (*node->value() == Ch('\0'))
	node->value(value, end - value);

    // Place zero terminator after value
    if (!(Flags & parse_no_string_terminators))
      {
	Ch ch = *getText();
	*end = Ch('\0');
	return ch;      // Return character that ends data; this is required because zero terminator overwritten it
      }

    // Return character that ends data
    return getChar();
  }
        
  // Parse element node
  template<int Flags>
  xml_node<Ch> *parse_element()
  {
    // Create element node
    //xml_node<Ch> *element = this->allocate_node(node_element);
    static xml_node<Ch> aelement(node_element); // just one 
    xml_node<Ch> * element=&aelement; 

    // Extract element name
    Ch *name = getText();
    skip<node_name_pred, Flags>();
    if (getText() == name)
      {
	//RAPIDXML_PARSE_ERROR("expected element name", text);
	cerr << "expected element name, got: "<< getChar()  << endl;
	setError(getText());
      }
    element->name(name, getText() - name);
            
    // Skip whitespace between element name and attributes or >
    skip<whitespace_pred, Flags>();

    // Parse attributes, if any
    if (parse_node_attributes<Flags>(element) == 0)
      {

      }
    else
      {
	return element;
      }

    // Determine ending type
    if (getChar() == Ch('>'))
      {


	int ret=parse_node_contents<Flags>(element);
	if ( ret ==0)
	  {
	    endPos(getText());
	  }
	else
	  {
	    cerr << "aborting with error" << ret << "text:"<< getChar() << endl;
	    setError(getText());
	    return element; // problem 
	  }
      }
    else if (getChar() == Ch('/'))
      {

	incrementText();
	if (getChar() != Ch('>'))
	  {
	    //++text;
	    cerr << "expected >, got :" <<  getChar() << endl;
	    setError(getText());
	  }
	incrementText();
      }
    else
      {
	cerr << "expected >, got :" <<  getChar() << endl;
	setError(getText());
	incrementText();
      }

    // Place zero terminator after name
    if (!(Flags & parse_no_string_terminators))
      element->name()[element->name_size()] = Ch('\0');


    // Return parsed element
    return element;
  }

  // Determine node type, and parse it
  template<int Flags>
  xml_node<Ch> *parse_node()
  {
    // Parse proper node type
    switch (getChar())
      {

	// <...
      default: 
	// Parse and append element node
	return parse_element<Flags>();

	// <?...
      case Ch('?'): 
	incrementText();     // Skip ?
	if ((getChar(0) == Ch('x') || getChar(0) == Ch('X')) &&
	    (getChar(1) == Ch('m') || getChar(1) == Ch('M')) && 
	    (getChar(2) == Ch('l') || getChar(2) == Ch('L')) &&
	    whitespace_pred::test(getChar(3)))
	  {
	    // '<?xml ' - xml declaration
	    incrementText( 4);      // Skip 'xml '
	    //return parse_xml_declaration<Flags>(getText());
	    exit(0);
	  }
	else
	  {
	    // Parse PI
	    //  return parse_pi<Flags>(getText());
	    exit(0);
	  }
            
	// <!...
      case Ch('!'): 

	// Parse proper subset of <! node
	switch (getChar(1))    
	  {
                
	    // <!-
	  case Ch('-'):
	    if (getChar(2) == Ch('-'))
	      {
		// '<!--' - xml comment
		incrementText(3);     // Skip '!--'
		//return parse_comment<Flags>(getText());
		return 0;
	      }
	    break;


	    }   // switch

	    // Attempt to skip other, unrecognized node types starting with <!
	    incrementText();     // Skip !
	    while (getChar() != Ch('>'))
	      {
		if (getChar() == 0)
		  ParseError("unexpected end of data", getText());
		incrementText();
	      }
	    incrementText();     // Skip '>'
	    return 0;   // No node recognized

	  }
      }

    // Parse contents of the node - children, data etc.
    template<int Flags>
      int parse_node_contents( xml_node<Ch> *node)
    {
      // For all children and text
      while (1)
	{
	  // Skip whitespace between > and node contents
	  Ch *contents_start = getText();      // Store start of node contents before whitespace is skipped
	  skip<whitespace_pred, Flags>();
	  Ch next_char = getChar();

	  // After data nodes, instead of continuing the loop, control jumps here.
	  // This is because zero termination inside parse_and_append_data() function
	  // would wreak havoc with the above code.
	  // Also, skipping whitespace after data nodes is unnecessary.
	after_data_node:    
                
	  // Determine what comes next: node closing, child node, data node, or 0?
	  switch (next_char)
	    {
                
	      // Node closing or child node
	    case Ch('<'):
	      if (getChar(1) == Ch('/'))
		{
		  // Node closing
		  incrementText(2);      // Skip '</'
		  if (Flags & parse_validate_closing_tags)
		    {
		      // Skip and validate closing tag name
		      Ch *closing_name = getText();
		      skip<node_name_pred, Flags>();
		      if (!internal::compare(node->name(), node->name_size(), closing_name, getText() - closing_name, true))
			ParseError("invalid closing tag name", getText());
		    }
		  else
		    {
		      // No validation, just skip name
		      skip<node_name_pred, Flags>();
		    }
		  // Skip remaining whitespace after node name
		  skip<whitespace_pred, Flags>();
		  if (getChar() != Ch('>'))
		    {
		      cerr << "expected >, got:" << getChar(0)  << endl;
		      setError(getText());
		      //RAPIDXML_PARSE_ERROR("expected >", text);
		    }
		  incrementText();     // Skip '>'
		  return 0;     // Node closed, finished parsing contents
		}
	      else
		{
		  // Child node
		  incrementText();     // Skip '<'
		  if (xml_node<Ch> *child = parse_node<Flags>())
		    {
		      node->append_node(child);
			    

		    }
		}
	      break;

	      // End of data - error
	    case Ch('\0'):
	      {
		cerr << "unexpected end of data" << endl;
		setError(getText());
		return -1;
	      }

	      // Data node
	    default:
	      {
		next_char = parse_and_append_data<Flags>(node, contents_start);
		if (next_char == -1)
		  {
		    cerr << "parse and append failed" << endl;
		    setError(getText());
		    return -1;
		  }
		goto after_data_node;   // Bypass regular processing after data nodes
	      }

	    }
	}
      return 0;
    }
        
    // Parse XML attributes of the node
    template<int Flags>
      int parse_node_attributes( xml_node<Ch> *node)
    {
      // For all attributes 
      while (attribute_name_pred::test(getChar()))
	{
	  // Extract attribute name
	  Ch *name = getText();
	  incrementText();     // Skip first character of attribute name
	  skip<attribute_name_pred, Flags>();
	  if (getText() == name)
	    ParseError("expected attribute name", name);

	  // Create new attribute
	  static xml_attribute<Ch> aattribute; // = this->allocate_attribute();
	  xml_attribute<Ch> *attribute = &aattribute;
	  attribute->name(name, getText() - name);
	  node->append_attribute(attribute);

	  // now here we could try and call the right method on the node, assuming the node is a certain type.

	  // Skip whitespace after attribute name
	  skip<whitespace_pred, Flags>();

	  // Skip =
	  if (getChar() != Ch('='))
	    {
	      cerr << "expected =, got:" << getChar(0) << endl;
	      setError(getText());
	    }
		    
	  incrementText();

	  // Add terminating zero after name
	  if (!(Flags & parse_no_string_terminators))
	    attribute->name()[attribute->name_size()] = 0;

	  // Skip whitespace after =
	  skip<whitespace_pred, Flags>();

	  // Skip quote and remember if it was ' or "
	  Ch quote = getChar();
	  if (quote != Ch('\'') && quote != Ch('"'))
	    {
	      cerr << "expected ' or \", got:" <<  getChar(0) << endl;
	      setError(getText());
	    }
	  incrementText();

	  // Extract attribute value and expand char refs in it
	  Ch *value = getText(), *end;
	  const int AttFlags = Flags & ~parse_normalize_whitespace;   // No whitespace normalization in attributes
	  if (quote == Ch('\''))
	    end = skip_and_expand_character_refs<attribute_value_pred<Ch('\'')>, attribute_value_pure_pred<Ch('\'')>, AttFlags>();
	  else
	    end = skip_and_expand_character_refs<attribute_value_pred<Ch('"')>, attribute_value_pure_pred<Ch('"')>, AttFlags>();
	  if (end - value <= 0)
	    {
	      cout << "reached the end parsing attributes" <<endl;
	      return -1 ;
	    }

                
	  // Set attribute value
	  attribute->value(value, end - value);
                
	  // Make sure that end quote is present
	  if (getChar() != quote)
	    {
	      cerr << "expected ' or \" got:" <<  getChar(0) << endl;
	      setError(getText());
	    }

	  incrementText();     // Skip quote

	  // Add terminating zero after value
	  if (!(Flags & parse_no_string_terminators))
	    attribute->value()[attribute->value_size()] = 0;

	  // Skip whitespace after attribute value
	  skip<whitespace_pred, Flags>();
	}
      return 0;
    }
      
  };
