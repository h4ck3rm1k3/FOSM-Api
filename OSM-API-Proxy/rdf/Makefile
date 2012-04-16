
all : test

viz : indexer.rl
	ragel -V indexer.rl > indexer.dot
	dotty indexer.dot

test : indexer
	./indexer  ../data/offenbach.osm

indexer : indexer.c  fileindexer.hpp
	g++ -o indexer  indexer.c

indexer.c : indexer.rl
	ragel -G1 indexer.rl