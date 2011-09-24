tester : test.cpp memory_pool.hpp  rapidxml_iterators.hpp  rapidxml_utils.hpp  xml_base.hpp      xml_flags.hpp     xml_internal_hdr.hpp  xml_osm.hpp rapidxml.hpp     rapidxml_print.hpp      xml_attribute.hpp   xml_document.hpp  xml_internal.hpp  xml_node.hpp
	g++ -g3 -pg test.cpp -o tester

testern : test.cpp memory_pool.hpp  rapidxml_iterators.hpp  rapidxml_utils.hpp  xml_base.hpp      xml_flags.hpp     xml_internal_hdr.hpp  xml_osm.hpp rapidxml.hpp     rapidxml_print.hpp      xml_attribute.hpp   xml_document.hpp  xml_internal.hpp  xml_node.hpp

	g++ -g3 -pg test.cpp -o tester
#	g++  test.cpp -o testern

test: tester
	./tester /home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy/data/debug_output17910.xml

oprofile: testern
	sudo opcontrol --reset
	sudo opcontrol --start
	./testern /home/mdupont/experiments/osm/dist/dancer/OSM-API-Proxy/data/debug_output17910.xml
	sudo opcontrol --shutdown
	opreport -lt1

