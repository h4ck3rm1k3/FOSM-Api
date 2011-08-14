    ///////////////////////////////////////////////////////////////////////
    // Memory pool
    
    //! This class is used by the parser to create new nodes and attributes, without overheads of dynamic memory allocation.
    //! In most cases, you will not need to use this class directly. 
    //! However, if you need to create nodes manually or modify names/values of nodes, 
    //! you are encouraged to use memory_pool of relevant xml_document to allocate the memory. 
    //! Not only is this faster than allocating them by using <code>new</code> operator, 
    //! but also their lifetime will be tied to the lifetime of document, 
    //! possibly simplyfing memory management. 
    //! <br><br>
    //! Call allocate_node() or allocate_attribute() functions to obtain new nodes or attributes from the pool. 
    //! You can also call allocate_string() function to allocate strings.
    //! Such strings can then be used as names or values of nodes without worrying about their lifetime.
    //! Note that there is no <code>free()</code> function -- all allocations are freed at once when clear() function is called, 
    //! or when the pool is destroyed.
    //! <br><br>
    //! It is also possible to create a standalone memory_pool, and use it 
    //! to allocate nodes, whose lifetime will not be tied to any document.
    //! <br><br>
    //! Pool maintains <code>RAPIDXML_STATIC_POOL_SIZE</code> bytes of statically allocated memory. 
    //! Until static memory is exhausted, no dynamic memory allocations are done.
    //! When static memory is exhausted, pool allocates additional blocks of memory of size <code>RAPIDXML_DYNAMIC_POOL_SIZE</code> each,
    //! by using global <code>new[]</code> and <code>delete[]</code> operators. 
    //! This behaviour can be changed by setting custom allocation routines. 
    //! Use set_allocator() function to set them.
    //! <br><br>
    //! Allocations for nodes, attributes and strings are aligned at <code>RAPIDXML_ALIGNMENT</code> bytes.
    //! This value defaults to the size of pointer on target architecture.
    //! <br><br>
    //! To obtain absolutely top performance from the parser,
    //! it is important that all nodes are allocated from a single, contiguous block of memory.
    //! Otherwise, cache misses when jumping between two (or more) disjoint blocks of memory can slow down parsing quite considerably.
    //! If required, you can tweak <code>RAPIDXML_STATIC_POOL_SIZE</code>, <code>RAPIDXML_DYNAMIC_POOL_SIZE</code> and <code>RAPIDXML_ALIGNMENT</code> 
    //! to obtain best wasted memory to performance compromise.
    //! To do it, define their values before rapidxml.hpp file is included.
    //! \param Ch Character type of created nodes. 
    template<class Ch = char>
    class memory_pool
    {
        
    public:

        //! \cond internal
        typedef void *(alloc_func)(std::size_t);       // Type of user-defined function used to allocate memory
        typedef void (free_func)(void *);              // Type of user-defined function used to free memory
        //! \endcond
        
        //! Constructs empty pool with default allocator functions.
        memory_pool()
            : m_alloc_func(0)
            , m_free_func(0)
        {
            init();
        }

        //! Destroys pool and frees all the memory. 
        //! This causes memory occupied by nodes allocated by the pool to be freed.
        //! Nodes allocated from the pool are no longer valid.
        ~memory_pool()
        {
            clear();
        }

        //! Allocates a new node from the pool, and optionally assigns name and value to it. 
        //! If the allocation request cannot be accomodated, this function will throw <code>std::bad_alloc</code>.
        //! If exceptions are disabled by defining RAPIDXML_NO_EXCEPTIONS, this function
        //! will call rapidxml::parse_error_handler() function.
        //! \param type Type of node to create.
        //! \param name Name to assign to the node, or 0 to assign no name.
        //! \param value Value to assign to the node, or 0 to assign no value.
        //! \param name_size Size of name to assign, or 0 to automatically calculate size from name string.
        //! \param value_size Size of value to assign, or 0 to automatically calculate size from value string.
        //! \return Pointer to allocated node. This pointer will never be NULL.
        xml_node<Ch> *allocate_node(node_type type, 
                                    const Ch *name = 0, const Ch *value = 0, 
                                    std::size_t name_size = 0, std::size_t value_size = 0)
        {
            void *memory = allocate_aligned(sizeof(xml_node<Ch>));
            xml_node<Ch> *node = new(memory) xml_node<Ch>(type);
            if (name)
            {
                if (name_size > 0)
                    node->name(name, name_size);
                else
                    node->name(name);
		
		// now we typecast this into an instance of the right type.
		//		string classname = "xml_node_osm_"; 
		//		classname += node->name();		
		//		cout << "going to create an instance of "<< classname << endl;


            }
            if (value)
            {
                if (value_size > 0)
                    node->value(value, value_size);
                else
                    node->value(value);


		//		string classname = "xml_node_value_"; 
		//		classname += node->name();		
		//		cout << "going to create an value of "<< classname << endl;

            }

	    node->checkclass();

            return node;
        }

        //! Allocates a new attribute from the pool, and optionally assigns name and value to it.
        //! If the allocation request cannot be accomodated, this function will throw <code>std::bad_alloc</code>.
        //! If exceptions are disabled by defining RAPIDXML_NO_EXCEPTIONS, this function
        //! will call rapidxml::parse_error_handler() function.
        //! \param name Name to assign to the attribute, or 0 to assign no name.
        //! \param value Value to assign to the attribute, or 0 to assign no value.
        //! \param name_size Size of name to assign, or 0 to automatically calculate size from name string.
        //! \param value_size Size of value to assign, or 0 to automatically calculate size from value string.
        //! \return Pointer to allocated attribute. This pointer will never be NULL.
        xml_attribute<Ch> *allocate_attribute(const Ch *name = 0, const Ch *value = 0, 
                                              std::size_t name_size = 0, std::size_t value_size = 0)
        {
            void *memory = allocate_aligned(sizeof(xml_attribute<Ch>));
            xml_attribute<Ch> *attribute = new(memory) xml_attribute<Ch>;
            if (name)
            {
                if (name_size > 0)
                    attribute->name(name, name_size);
                else
                    attribute->name(name);
            }
            if (value)
            {
                if (value_size > 0)
                    attribute->value(value, value_size);
                else
                    attribute->value(value);
            }
            return attribute;
        }

        //! Allocates a char array of given size from the pool, and optionally copies a given string to it.
        //! If the allocation request cannot be accomodated, this function will throw <code>std::bad_alloc</code>.
        //! If exceptions are disabled by defining RAPIDXML_NO_EXCEPTIONS, this function
        //! will call rapidxml::parse_error_handler() function.
        //! \param source String to initialize the allocated memory with, or 0 to not initialize it.
        //! \param size Number of characters to allocate, or zero to calculate it automatically from source string length; if size is 0, source string must be specified and null terminated.
        //! \return Pointer to allocated char array. This pointer will never be NULL.
        Ch *allocate_string(const Ch *source = 0, std::size_t size = 0)
        {
            assert(source || size);     // Either source or size (or both) must be specified
            if (size == 0)
                size = internal::measure(source) + 1;
            Ch *result = static_cast<Ch *>(allocate_aligned(size * sizeof(Ch)));
            if (source)
                for (std::size_t i = 0; i < size; ++i)
                    result[i] = source[i];
            return result;
        }

        //! Clones an xml_node and its hierarchy of child nodes and attributes.
        //! Nodes and attributes are allocated from this memory pool.
        //! Names and values are not cloned, they are shared between the clone and the source.
        //! Result node can be optionally specified as a second parameter, 
        //! in which case its contents will be replaced with cloned source node.
        //! This is useful when you want to clone entire document.
        //! \param source Node to clone.
        //! \param result Node to put results in, or 0 to automatically allocate result node
        //! \return Pointer to cloned node. This pointer will never be NULL.
        xml_node<Ch> *clone_node(const xml_node<Ch> *source, xml_node<Ch> *result = 0)
        {
	  cerr << "clone called" <<endl;
            // Prepare result node
            if (result)
            {
                result->remove_all_attributes();
                result->remove_all_nodes();
                result->type(source->type());
            }
            else
                result = allocate_node(source->type());

            // Clone name and value
            result->name(source->name(), source->name_size());
            result->value(source->value(), source->value_size());

            // Clone child nodes and attributes
            for (xml_node<Ch> *child = source->first_node(); child; child = child->next_sibling())
                result->append_node(clone_node(child));
            for (xml_attribute<Ch> *attr = source->first_attribute(); attr; attr = attr->next_attribute())
                result->append_attribute(allocate_attribute(attr->name(), attr->value(), attr->name_size(), attr->value_size()));

            return result;
        }

        //! Clears the pool. 
        //! This causes memory occupied by nodes allocated by the pool to be freed.
        //! Any nodes or strings allocated from the pool will no longer be valid.
        void clear()
        {
            while (m_begin != m_static_memory)
            {
                char *previous_begin = reinterpret_cast<header *>(align(m_begin))->previous_begin;
                if (m_free_func)
                    m_free_func(m_begin);
                else
                    delete[] m_begin;
                m_begin = previous_begin;
            }
            init();
        }

        //! Sets or resets the user-defined memory allocation functions for the pool.
        //! This can only be called when no memory is allocated from the pool yet, otherwise results are undefined.
        //! Allocation function must not return invalid pointer on failure. It should either throw,
        //! stop the program, or use <code>longjmp()</code> function to pass control to other place of program. 
        //! If it returns invalid pointer, results are undefined.
        //! <br><br>
        //! User defined allocation functions must have the following forms:
        //! <br><code>
        //! <br>void *allocate(std::size_t size);
        //! <br>void free(void *pointer);
        //! </code><br>
        //! \param af Allocation function, or 0 to restore default function
        //! \param ff Free function, or 0 to restore default function
        void set_allocator(alloc_func *af, free_func *ff)
        {
            assert(m_begin == m_static_memory && m_ptr == align(m_begin));    // Verify that no memory is allocated yet
            m_alloc_func = af;
            m_free_func = ff;
        }

    private:

        struct header
        {
            char *previous_begin;
        };

        void init()
        {
            m_begin = m_static_memory;
            m_ptr = align(m_begin);
            m_end = m_static_memory + sizeof(m_static_memory);
        }
        
        char *align(char *ptr)
        {
            std::size_t alignment = ((RAPIDXML_ALIGNMENT - (std::size_t(ptr) & (RAPIDXML_ALIGNMENT - 1))) & (RAPIDXML_ALIGNMENT - 1));
            return ptr + alignment;
        }
        
        char *allocate_raw(std::size_t size)
        {
            // Allocate
            void *memory;   
            if (m_alloc_func)   // Allocate memory using either user-specified allocation function or global operator new[]
            {
                memory = m_alloc_func(size);
                assert(memory); // Allocator is not allowed to return 0, on failure it must either throw, stop the program or use longjmp
            }
            else
            {
                memory = new char[size];
#ifdef RAPIDXML_NO_EXCEPTIONS
                if (!memory)            // If exceptions are disabled, verify memory allocation, because new will not be able to throw bad_alloc
                    RAPIDXML_PARSE_ERROR("out of memory", 0);
#endif
            }
            return static_cast<char *>(memory);
        }
        
        void *allocate_aligned(std::size_t size)
        {
            // Calculate aligned pointer
            char *result = align(m_ptr);

            // If not enough memory left in current pool, allocate a new pool
            if (result + size > m_end)
            {
                // Calculate required pool size (may be bigger than RAPIDXML_DYNAMIC_POOL_SIZE)
                std::size_t pool_size = RAPIDXML_DYNAMIC_POOL_SIZE;
                if (pool_size < size)
                    pool_size = size;
                
                // Allocate
                std::size_t alloc_size = sizeof(header) + (2 * RAPIDXML_ALIGNMENT - 2) + pool_size;     // 2 alignments required in worst case: one for header, one for actual allocation
                char *raw_memory = allocate_raw(alloc_size);
                    
                // Setup new pool in allocated memory
                char *pool = align(raw_memory);
                header *new_header = reinterpret_cast<header *>(pool);
                new_header->previous_begin = m_begin;
                m_begin = raw_memory;
                m_ptr = pool + sizeof(header);
                m_end = raw_memory + alloc_size;

                // Calculate aligned pointer again using new pool
                result = align(m_ptr);
            }

            // Update pool and return aligned pointer
            m_ptr = result + size;
            return result;
        }

        char *m_begin;                                      // Start of raw memory making up current pool
        char *m_ptr;                                        // First free byte in current pool
        char *m_end;                                        // One past last available byte in current pool
        char m_static_memory[RAPIDXML_STATIC_POOL_SIZE];    // Static raw memory
        alloc_func *m_alloc_func;                           // Allocator function, or 0 if default is to be used
        free_func *m_free_func;                             // Free function, or 0 if default is to be used
    };

