    //! Class representing attribute node of XML document. 
    //! Each attribute has name and value strings, which are available through name() and value() functions (inherited from xml_base).
    //! Note that after parse, both name and value of attribute will point to interior of source text used for parsing. 
    //! Thus, this text must persist in memory for the lifetime of attribute.
    //! \param Ch Character type to use.
    template<class Ch = char>
    class xml_attribute: public xml_base<Ch>
    {

        friend class xml_node<Ch>;
    
    public:

        ///////////////////////////////////////////////////////////////////////////
        // Construction & destruction
    
        //! Constructs an empty attribute with the specified type. 
        //! Consider using memory_pool of appropriate xml_document if allocating attributes manually.
        xml_attribute()
        {
        }

        ///////////////////////////////////////////////////////////////////////////
        // Related nodes access
    
        //! Gets document of which attribute is a child.
        //! \return Pointer to document that contains this attribute, or 0 if there is no parent document.
        xml_document<Ch> *document() const
        {
            if (xml_node<Ch> *node = this->parent())
            {
                while (node->parent())
                    node = node->parent();
                return node->type() == node_document ? static_cast<xml_document<Ch> *>(node) : 0;
            }
            else
                return 0;
        }

        //! Gets previous attribute, optionally matching attribute name. 
        //! \param name Name of attribute to find, or 0 to return previous attribute regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
        //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
        //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
        //! \return Pointer to found attribute, or 0 if not found.
        xml_attribute<Ch> *previous_attribute(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
        {
            if (name)
            {
                if (name_size == 0)
                    name_size = internal::measure(name);
                for (xml_attribute<Ch> *attribute = m_prev_attribute; attribute; attribute = attribute->m_prev_attribute)
                    if (internal::compare(attribute->name(), attribute->name_size(), name, name_size, case_sensitive))
                        return attribute;
                return 0;
            }
            else
                return this->m_parent ? m_prev_attribute : 0;
        }

        //! Gets next attribute, optionally matching attribute name. 
        //! \param name Name of attribute to find, or 0 to return next attribute regardless of its name; this string doesn't have to be zero-terminated if name_size is non-zero
        //! \param name_size Size of name, in characters, or 0 to have size calculated automatically from string
        //! \param case_sensitive Should name comparison be case-sensitive; non case-sensitive comparison works properly only for ASCII characters
        //! \return Pointer to found attribute, or 0 if not found.
        xml_attribute<Ch> *next_attribute(const Ch *name = 0, std::size_t name_size = 0, bool case_sensitive = true) const
        {
            if (name)
            {
                if (name_size == 0)
                    name_size = internal::measure(name);
                for (xml_attribute<Ch> *attribute = m_next_attribute; attribute; attribute = attribute->m_next_attribute)
                    if (internal::compare(attribute->name(), attribute->name_size(), name, name_size, case_sensitive))
                        return attribute;
                return 0;
            }
            else
                return this->m_parent ? m_next_attribute : 0;
        }

    private:

        xml_attribute<Ch> *m_prev_attribute;        // Pointer to previous sibling of attribute, or 0 if none; only valid if parent is non-zero
        xml_attribute<Ch> *m_next_attribute;        // Pointer to next sibling of attribute, or 0 if none; only valid if parent is non-zero
    
    };
