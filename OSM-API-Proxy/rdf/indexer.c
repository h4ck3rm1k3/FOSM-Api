
#line 1 "indexer.rl"


#line 202 "indexer.rl"



#line 10 "indexer.c"
static const int osmkeys_start = 1;
static const int osmkeys_error = 0;

static const int osmkeys_en_main = 1;


#line 205 "indexer.rl"

#define BUFSIZE 128
#include "fileindexer.hpp"

int scanner(OSMWorld & world,const char *s)
{
  int cs;
  int res = 0;
  string currenttoken;
  char *p= (char *)s;
  char *pe = (char *)s + strlen(s) +1 ;
  
#line 30 "indexer.c"
	{
	cs = osmkeys_start;
	}

#line 217 "indexer.rl"
  
#line 37 "indexer.c"
	{
	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	switch ( cs ) {
case 1:
	switch( (*p) ) {
		case 47: goto tr0;
		case 60: goto tr2;
		case 62: goto tr3;
		case 99: goto tr4;
		case 105: goto tr5;
		case 107: goto tr6;
		case 108: goto tr7;
		case 114: goto tr8;
		case 116: goto tr9;
		case 117: goto tr10;
		case 118: goto tr11;
	}
	goto tr1;
case 0:
	goto _out;
case 2:
	if ( (*p) == 62 )
		goto tr3;
	goto tr1;
case 80:
	goto tr1;
case 3:
	switch( (*p) ) {
		case 109: goto tr12;
		case 110: goto tr13;
		case 114: goto tr14;
		case 116: goto tr15;
		case 119: goto tr16;
	}
	goto tr1;
case 4:
	if ( (*p) == 101 )
		goto tr17;
	goto tr1;
case 5:
	if ( (*p) == 109 )
		goto tr18;
	goto tr1;
case 6:
	if ( (*p) == 98 )
		goto tr19;
	goto tr1;
case 7:
	if ( (*p) == 101 )
		goto tr20;
	goto tr1;
case 8:
	if ( (*p) == 114 )
		goto tr21;
	goto tr1;
case 9:
	switch( (*p) ) {
		case 100: goto tr22;
		case 111: goto tr23;
	}
	goto tr1;
case 10:
	if ( (*p) == 100 )
		goto tr24;
	goto tr1;
case 11:
	if ( (*p) == 101 )
		goto tr25;
	goto tr1;
case 12:
	if ( (*p) == 101 )
		goto tr26;
	goto tr1;
case 13:
	if ( (*p) == 108 )
		goto tr27;
	goto tr1;
case 14:
	if ( (*p) == 97 )
		goto tr28;
	goto tr1;
case 15:
	if ( (*p) == 116 )
		goto tr29;
	goto tr1;
case 16:
	if ( (*p) == 105 )
		goto tr30;
	goto tr1;
case 17:
	if ( (*p) == 111 )
		goto tr31;
	goto tr1;
case 18:
	if ( (*p) == 110 )
		goto tr32;
	goto tr1;
case 19:
	if ( (*p) == 97 )
		goto tr33;
	goto tr1;
case 20:
	if ( (*p) == 103 )
		goto tr34;
	goto tr1;
case 21:
	if ( (*p) == 97 )
		goto tr35;
	goto tr1;
case 22:
	if ( (*p) == 121 )
		goto tr36;
	goto tr1;
case 23:
	if ( (*p) == 104 )
		goto tr37;
	goto tr1;
case 24:
	if ( (*p) == 97 )
		goto tr38;
	goto tr1;
case 25:
	if ( (*p) == 110 )
		goto tr39;
	goto tr1;
case 26:
	if ( (*p) == 103 )
		goto tr40;
	goto tr1;
case 27:
	if ( (*p) == 101 )
		goto tr41;
	goto tr1;
case 28:
	if ( (*p) == 115 )
		goto tr42;
	goto tr1;
case 29:
	if ( (*p) == 101 )
		goto tr43;
	goto tr1;
case 30:
	if ( (*p) == 116 )
		goto tr44;
	goto tr1;
case 31:
	if ( (*p) == 61 )
		goto tr45;
	goto tr1;
case 32:
	switch( (*p) ) {
		case 34: goto tr46;
		case 39: goto tr46;
	}
	goto tr1;
case 33:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr47;
	goto tr1;
case 34:
	switch( (*p) ) {
		case 34: goto tr48;
		case 39: goto tr48;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr47;
	goto tr1;
case 35:
	if ( (*p) == 100 )
		goto tr49;
	goto tr1;
case 36:
	if ( (*p) == 61 )
		goto tr50;
	goto tr1;
case 37:
	switch( (*p) ) {
		case 34: goto tr51;
		case 39: goto tr51;
	}
	goto tr1;
case 38:
	if ( (*p) == 45 )
		goto tr52;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr53;
	goto tr1;
case 39:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr53;
	goto tr1;
case 40:
	switch( (*p) ) {
		case 34: goto tr54;
		case 39: goto tr54;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr53;
	goto tr1;
case 41:
	if ( (*p) == 61 )
		goto tr55;
	goto tr1;
case 42:
	switch( (*p) ) {
		case 34: goto tr56;
		case 39: goto tr57;
	}
	goto tr1;
case 43:
	if ( (*p) == 34 )
		goto tr1;
	goto tr58;
case 44:
	if ( (*p) == 34 )
		goto tr59;
	goto tr58;
case 45:
	if ( (*p) == 39 )
		goto tr1;
	goto tr60;
case 46:
	if ( (*p) == 39 )
		goto tr59;
	goto tr60;
case 47:
	switch( (*p) ) {
		case 97: goto tr61;
		case 111: goto tr62;
	}
	goto tr1;
case 48:
	if ( (*p) == 116 )
		goto tr6;
	goto tr1;
case 49:
	if ( (*p) == 110 )
		goto tr6;
	goto tr1;
case 50:
	switch( (*p) ) {
		case 101: goto tr63;
		case 111: goto tr64;
	}
	goto tr1;
case 51:
	if ( (*p) == 102 )
		goto tr6;
	goto tr1;
case 52:
	if ( (*p) == 108 )
		goto tr65;
	goto tr1;
case 53:
	if ( (*p) == 101 )
		goto tr6;
	goto tr1;
case 54:
	switch( (*p) ) {
		case 105: goto tr66;
		case 121: goto tr67;
	}
	goto tr1;
case 55:
	if ( (*p) == 109 )
		goto tr68;
	goto tr1;
case 56:
	if ( (*p) == 101 )
		goto tr69;
	goto tr1;
case 57:
	if ( (*p) == 115 )
		goto tr70;
	goto tr1;
case 58:
	if ( (*p) == 116 )
		goto tr71;
	goto tr1;
case 59:
	if ( (*p) == 97 )
		goto tr72;
	goto tr1;
case 60:
	if ( (*p) == 109 )
		goto tr73;
	goto tr1;
case 61:
	if ( (*p) == 112 )
		goto tr6;
	goto tr1;
case 62:
	if ( (*p) == 112 )
		goto tr65;
	goto tr1;
case 63:
	switch( (*p) ) {
		case 105: goto tr74;
		case 115: goto tr75;
	}
	goto tr1;
case 64:
	if ( (*p) == 100 )
		goto tr6;
	goto tr1;
case 65:
	if ( (*p) == 101 )
		goto tr76;
	goto tr1;
case 66:
	if ( (*p) == 114 )
		goto tr6;
	goto tr1;
case 67:
	switch( (*p) ) {
		case 61: goto tr55;
		case 101: goto tr77;
		case 105: goto tr78;
	}
	goto tr1;
case 68:
	if ( (*p) == 114 )
		goto tr79;
	goto tr1;
case 69:
	if ( (*p) == 115 )
		goto tr80;
	goto tr1;
case 70:
	if ( (*p) == 105 )
		goto tr81;
	goto tr1;
case 71:
	if ( (*p) == 111 )
		goto tr82;
	goto tr1;
case 72:
	if ( (*p) == 110 )
		goto tr83;
	goto tr1;
case 73:
	if ( (*p) == 61 )
		goto tr84;
	goto tr1;
case 74:
	switch( (*p) ) {
		case 34: goto tr85;
		case 39: goto tr85;
	}
	goto tr1;
case 75:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr86;
	goto tr1;
case 76:
	switch( (*p) ) {
		case 34: goto tr87;
		case 39: goto tr87;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr86;
	goto tr1;
case 77:
	if ( (*p) == 115 )
		goto tr88;
	goto tr1;
case 78:
	if ( (*p) == 105 )
		goto tr89;
	goto tr1;
case 79:
	if ( (*p) == 98 )
		goto tr64;
	goto tr1;
	}

	tr1: cs = 0; goto _again;
	tr0: cs = 2; goto _again;
	tr2: cs = 3; goto _again;
	tr12: cs = 4; goto _again;
	tr17: cs = 5; goto _again;
	tr18: cs = 6; goto _again;
	tr19: cs = 7; goto _again;
	tr20: cs = 8; goto _again;
	tr13: cs = 9; goto _again;
	tr23: cs = 10; goto _again;
	tr24: cs = 11; goto _again;
	tr14: cs = 12; goto _again;
	tr26: cs = 13; goto _again;
	tr27: cs = 14; goto _again;
	tr28: cs = 15; goto _again;
	tr29: cs = 16; goto _again;
	tr30: cs = 17; goto _again;
	tr31: cs = 18; goto _again;
	tr15: cs = 19; goto _again;
	tr33: cs = 20; goto _again;
	tr16: cs = 21; goto _again;
	tr35: cs = 22; goto _again;
	tr4: cs = 23; goto _again;
	tr37: cs = 24; goto _again;
	tr38: cs = 25; goto _again;
	tr39: cs = 26; goto _again;
	tr40: cs = 27; goto _again;
	tr41: cs = 28; goto _again;
	tr42: cs = 29; goto _again;
	tr43: cs = 30; goto _again;
	tr44: cs = 31; goto _again;
	tr45: cs = 32; goto _again;
	tr46: cs = 33; goto f7;
	tr47: cs = 34; goto f8;
	tr5: cs = 35; goto _again;
	tr49: cs = 36; goto _again;
	tr50: cs = 37; goto _again;
	tr51: cs = 38; goto f7;
	tr52: cs = 39; goto f10;
	tr53: cs = 40; goto f8;
	tr6: cs = 41; goto _again;
	tr55: cs = 42; goto _again;
	tr56: cs = 43; goto _again;
	tr58: cs = 44; goto _again;
	tr57: cs = 45; goto _again;
	tr60: cs = 46; goto _again;
	tr7: cs = 47; goto _again;
	tr61: cs = 48; goto _again;
	tr62: cs = 49; goto _again;
	tr8: cs = 50; goto _again;
	tr63: cs = 51; goto _again;
	tr64: cs = 52; goto _again;
	tr65: cs = 53; goto _again;
	tr9: cs = 54; goto _again;
	tr66: cs = 55; goto _again;
	tr68: cs = 56; goto _again;
	tr69: cs = 57; goto _again;
	tr70: cs = 58; goto _again;
	tr71: cs = 59; goto _again;
	tr72: cs = 60; goto _again;
	tr73: cs = 61; goto _again;
	tr67: cs = 62; goto _again;
	tr10: cs = 63; goto _again;
	tr74: cs = 64; goto _again;
	tr75: cs = 65; goto _again;
	tr76: cs = 66; goto _again;
	tr11: cs = 67; goto _again;
	tr77: cs = 68; goto _again;
	tr79: cs = 69; goto _again;
	tr80: cs = 70; goto _again;
	tr81: cs = 71; goto _again;
	tr82: cs = 72; goto _again;
	tr83: cs = 73; goto _again;
	tr84: cs = 74; goto _again;
	tr85: cs = 75; goto f7;
	tr86: cs = 76; goto f8;
	tr78: cs = 77; goto _again;
	tr88: cs = 78; goto _again;
	tr89: cs = 79; goto _again;
	tr3: cs = 80; goto f0;
	tr21: cs = 80; goto f1;
	tr22: cs = 80; goto f2;
	tr25: cs = 80; goto f3;
	tr32: cs = 80; goto f4;
	tr34: cs = 80; goto f5;
	tr36: cs = 80; goto f6;
	tr48: cs = 80; goto f9;
	tr54: cs = 80; goto f11;
	tr59: cs = 80; goto f12;
	tr87: cs = 80; goto f13;

f7:
#line 142 "indexer.rl"
	{
     currenttoken.clear();  
}
	goto _again;
f8:
#line 145 "indexer.rl"
	{
     currenttoken.push_back((*p));
}
	goto _again;
f10:
#line 149 "indexer.rl"
	{
//       cerr << fc << endl;
     currenttoken.push_back((*p));
}
	goto _again;
f12:
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f0:
#line 119 "indexer.rl"
	{
                     world.finish_current_object();

                }
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f11:
#line 155 "indexer.rl"
	{
     char *endptr;   // ignore  
//     cerr << "currenttoken" << currenttoken << endl;
     world.set_current_id(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f9:
#line 168 "indexer.rl"
	{
     char *endptr;   // ignore
     world.set_current_cs(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f13:
#line 179 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "Version " << currenttoken << endl;
     world.set_current_ver(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f3:
#line 6 "indexer.rl"
	{
       world.set_current_element_type_node();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f6:
#line 12 "indexer.rl"
	{
       world.set_current_element_type_way();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f4:
#line 18 "indexer.rl"
	{
       world.set_current_element_type_rel();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f5:
#line 24 "indexer.rl"
	{
       world.set_current_element_type_tag();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f2:
#line 30 "indexer.rl"
	{
       world.set_current_element_type_nd();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;
f1:
#line 35 "indexer.rl"
	{
       world.set_current_element_type_member();
       }
#line 136 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 200 "indexer.rl"
	{ res = 1;      }
	goto _again;

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	_out: {}
	}

#line 218 "indexer.rl"
  
  return res;
}

int main (int argc, char ** argv)
{

  OSMWorld world; 

  if (argc!=2)
  {
        cerr << "first argument must be a file name:"  << argc << endl;
        return 1;
  }   

  string filename(argv[1]);

  cerr << "file name:"  << filename << endl;

  ifstream  stream(filename.c_str(),ios::binary);

  while(stream)
    {
      std::string s;
      stream >> s;
      int size =s.length();
      int test =stream.tellg();
      world.set_cur_position(test);

      int ret= scanner(world,s.c_str());
//      cout << "Found:" << s << " status:" << ret <<  endl;
//      cout << "CS:" << cs << endl;
    }
}
