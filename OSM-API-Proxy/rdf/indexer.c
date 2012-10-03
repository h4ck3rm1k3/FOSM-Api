
#line 1 "indexer.rl"


#line 287 "indexer.rl"



#line 10 "indexer.c"
static const int osmkeys_start = 1;
static const int osmkeys_error = 0;

static const int osmkeys_en_main = 1;


#line 290 "indexer.rl"

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

#line 302 "indexer.rl"
  
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
		case 108: goto tr6;
		case 114: goto tr7;
		case 116: goto tr8;
		case 117: goto tr9;
		case 118: goto tr10;
	}
	goto tr1;
case 0:
	goto _out;
case 2:
	if ( (*p) == 62 )
		goto tr3;
	goto tr1;
case 125:
	goto tr1;
case 3:
	switch( (*p) ) {
		case 109: goto tr11;
		case 110: goto tr12;
		case 114: goto tr13;
		case 116: goto tr14;
		case 119: goto tr15;
	}
	goto tr1;
case 4:
	if ( (*p) == 101 )
		goto tr16;
	goto tr1;
case 5:
	if ( (*p) == 109 )
		goto tr17;
	goto tr1;
case 6:
	if ( (*p) == 98 )
		goto tr18;
	goto tr1;
case 7:
	if ( (*p) == 101 )
		goto tr19;
	goto tr1;
case 8:
	if ( (*p) == 114 )
		goto tr20;
	goto tr1;
case 9:
	switch( (*p) ) {
		case 100: goto tr21;
		case 111: goto tr22;
	}
	goto tr1;
case 10:
	if ( (*p) == 100 )
		goto tr23;
	goto tr1;
case 11:
	if ( (*p) == 101 )
		goto tr24;
	goto tr1;
case 12:
	if ( (*p) == 101 )
		goto tr25;
	goto tr1;
case 13:
	if ( (*p) == 108 )
		goto tr26;
	goto tr1;
case 14:
	if ( (*p) == 97 )
		goto tr27;
	goto tr1;
case 15:
	if ( (*p) == 116 )
		goto tr28;
	goto tr1;
case 16:
	if ( (*p) == 105 )
		goto tr29;
	goto tr1;
case 17:
	if ( (*p) == 111 )
		goto tr30;
	goto tr1;
case 18:
	if ( (*p) == 110 )
		goto tr31;
	goto tr1;
case 19:
	if ( (*p) == 97 )
		goto tr32;
	goto tr1;
case 20:
	if ( (*p) == 103 )
		goto tr33;
	goto tr1;
case 21:
	if ( (*p) == 97 )
		goto tr34;
	goto tr1;
case 22:
	if ( (*p) == 121 )
		goto tr35;
	goto tr1;
case 23:
	if ( (*p) == 104 )
		goto tr36;
	goto tr1;
case 24:
	if ( (*p) == 97 )
		goto tr37;
	goto tr1;
case 25:
	if ( (*p) == 110 )
		goto tr38;
	goto tr1;
case 26:
	if ( (*p) == 103 )
		goto tr39;
	goto tr1;
case 27:
	if ( (*p) == 101 )
		goto tr40;
	goto tr1;
case 28:
	if ( (*p) == 115 )
		goto tr41;
	goto tr1;
case 29:
	if ( (*p) == 101 )
		goto tr42;
	goto tr1;
case 30:
	if ( (*p) == 116 )
		goto tr43;
	goto tr1;
case 31:
	if ( (*p) == 61 )
		goto tr44;
	goto tr1;
case 32:
	switch( (*p) ) {
		case 34: goto tr45;
		case 39: goto tr45;
	}
	goto tr1;
case 33:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr46;
	goto tr1;
case 34:
	switch( (*p) ) {
		case 34: goto tr47;
		case 39: goto tr47;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr46;
	goto tr1;
case 35:
	if ( (*p) == 100 )
		goto tr48;
	goto tr1;
case 36:
	if ( (*p) == 61 )
		goto tr49;
	goto tr1;
case 37:
	switch( (*p) ) {
		case 34: goto tr50;
		case 39: goto tr50;
	}
	goto tr1;
case 38:
	if ( (*p) == 45 )
		goto tr51;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr52;
	goto tr1;
case 39:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr52;
	goto tr1;
case 40:
	switch( (*p) ) {
		case 34: goto tr53;
		case 39: goto tr53;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr52;
	goto tr1;
case 41:
	switch( (*p) ) {
		case 97: goto tr54;
		case 111: goto tr55;
	}
	goto tr1;
case 42:
	if ( (*p) == 116 )
		goto tr56;
	goto tr1;
case 43:
	if ( (*p) == 61 )
		goto tr57;
	goto tr1;
case 44:
	switch( (*p) ) {
		case 34: goto tr58;
		case 39: goto tr58;
	}
	goto tr1;
case 45:
	if ( (*p) == 45 )
		goto tr59;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr60;
	goto tr1;
case 46:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr60;
	goto tr1;
case 47:
	switch( (*p) ) {
		case 34: goto tr61;
		case 39: goto tr61;
		case 46: goto tr62;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr60;
	goto tr1;
case 48:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr63;
	goto tr1;
case 49:
	switch( (*p) ) {
		case 34: goto tr61;
		case 39: goto tr61;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr63;
	goto tr1;
case 50:
	if ( (*p) == 110 )
		goto tr64;
	goto tr1;
case 51:
	if ( (*p) == 61 )
		goto tr65;
	goto tr1;
case 52:
	switch( (*p) ) {
		case 34: goto tr66;
		case 39: goto tr66;
	}
	goto tr1;
case 53:
	if ( (*p) == 45 )
		goto tr67;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr68;
	goto tr1;
case 54:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr68;
	goto tr1;
case 55:
	switch( (*p) ) {
		case 34: goto tr69;
		case 39: goto tr69;
		case 46: goto tr70;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr68;
	goto tr1;
case 56:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr71;
	goto tr1;
case 57:
	switch( (*p) ) {
		case 34: goto tr69;
		case 39: goto tr69;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr71;
	goto tr1;
case 58:
	switch( (*p) ) {
		case 101: goto tr72;
		case 111: goto tr73;
	}
	goto tr1;
case 59:
	if ( (*p) == 102 )
		goto tr74;
	goto tr1;
case 60:
	if ( (*p) == 61 )
		goto tr75;
	goto tr1;
case 61:
	switch( (*p) ) {
		case 34: goto tr76;
		case 39: goto tr77;
	}
	goto tr1;
case 62:
	if ( (*p) == 34 )
		goto tr1;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr79;
	goto tr78;
case 63:
	if ( (*p) == 34 )
		goto tr80;
	goto tr78;
case 64:
	switch( (*p) ) {
		case 34: goto tr81;
		case 39: goto tr82;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr79;
	goto tr78;
case 126:
	if ( (*p) == 34 )
		goto tr80;
	goto tr78;
case 65:
	if ( (*p) == 39 )
		goto tr1;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr84;
	goto tr83;
case 66:
	if ( (*p) == 39 )
		goto tr80;
	goto tr83;
case 67:
	switch( (*p) ) {
		case 34: goto tr85;
		case 39: goto tr81;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr84;
	goto tr83;
case 127:
	if ( (*p) == 39 )
		goto tr80;
	goto tr83;
case 68:
	if ( (*p) == 108 )
		goto tr86;
	goto tr1;
case 69:
	if ( (*p) == 101 )
		goto tr87;
	goto tr1;
case 70:
	if ( (*p) == 61 )
		goto tr88;
	goto tr1;
case 71:
	switch( (*p) ) {
		case 34: goto tr89;
		case 39: goto tr90;
	}
	goto tr1;
case 72:
	if ( (*p) == 34 )
		goto tr1;
	goto tr78;
case 73:
	if ( (*p) == 39 )
		goto tr1;
	goto tr83;
case 74:
	switch( (*p) ) {
		case 105: goto tr91;
		case 121: goto tr92;
	}
	goto tr1;
case 75:
	if ( (*p) == 109 )
		goto tr93;
	goto tr1;
case 76:
	if ( (*p) == 101 )
		goto tr94;
	goto tr1;
case 77:
	if ( (*p) == 115 )
		goto tr95;
	goto tr1;
case 78:
	if ( (*p) == 116 )
		goto tr96;
	goto tr1;
case 79:
	if ( (*p) == 97 )
		goto tr97;
	goto tr1;
case 80:
	if ( (*p) == 109 )
		goto tr98;
	goto tr1;
case 81:
	if ( (*p) == 112 )
		goto tr99;
	goto tr1;
case 82:
	if ( (*p) == 61 )
		goto tr100;
	goto tr1;
case 83:
	switch( (*p) ) {
		case 34: goto tr101;
		case 39: goto tr101;
	}
	goto tr1;
case 84:
	switch( (*p) ) {
		case 45: goto tr102;
		case 84: goto tr102;
		case 90: goto tr102;
	}
	if ( 48 <= (*p) && (*p) <= 58 )
		goto tr102;
	goto tr1;
case 85:
	switch( (*p) ) {
		case 34: goto tr103;
		case 39: goto tr103;
		case 45: goto tr102;
		case 84: goto tr102;
		case 90: goto tr102;
	}
	if ( 48 <= (*p) && (*p) <= 58 )
		goto tr102;
	goto tr1;
case 86:
	if ( (*p) == 112 )
		goto tr86;
	goto tr1;
case 87:
	switch( (*p) ) {
		case 105: goto tr104;
		case 115: goto tr105;
	}
	goto tr1;
case 88:
	if ( (*p) == 100 )
		goto tr106;
	goto tr1;
case 89:
	if ( (*p) == 61 )
		goto tr107;
	goto tr1;
case 90:
	switch( (*p) ) {
		case 34: goto tr108;
		case 39: goto tr108;
	}
	goto tr1;
case 91:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr109;
	goto tr1;
case 92:
	switch( (*p) ) {
		case 34: goto tr110;
		case 39: goto tr110;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr109;
	goto tr1;
case 93:
	if ( (*p) == 101 )
		goto tr111;
	goto tr1;
case 94:
	if ( (*p) == 114 )
		goto tr112;
	goto tr1;
case 95:
	if ( (*p) == 61 )
		goto tr113;
	goto tr1;
case 96:
	switch( (*p) ) {
		case 34: goto tr114;
		case 39: goto tr114;
	}
	goto tr1;
case 97:
	if ( (*p) == 39 )
		goto tr1;
	goto tr115;
case 98:
	switch( (*p) ) {
		case 34: goto tr116;
		case 39: goto tr117;
	}
	goto tr115;
case 128:
	switch( (*p) ) {
		case 34: goto tr116;
		case 39: goto tr117;
	}
	goto tr115;
case 99:
	switch( (*p) ) {
		case 101: goto tr118;
		case 105: goto tr119;
	}
	goto tr1;
case 100:
	if ( (*p) == 114 )
		goto tr120;
	goto tr1;
case 101:
	if ( (*p) == 115 )
		goto tr121;
	goto tr1;
case 102:
	if ( (*p) == 105 )
		goto tr122;
	goto tr1;
case 103:
	if ( (*p) == 111 )
		goto tr123;
	goto tr1;
case 104:
	if ( (*p) == 110 )
		goto tr124;
	goto tr1;
case 105:
	if ( (*p) == 61 )
		goto tr125;
	goto tr1;
case 106:
	switch( (*p) ) {
		case 34: goto tr126;
		case 39: goto tr126;
	}
	goto tr1;
case 107:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr127;
	goto tr1;
case 108:
	switch( (*p) ) {
		case 34: goto tr128;
		case 39: goto tr128;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr127;
	goto tr1;
case 109:
	if ( (*p) == 115 )
		goto tr129;
	goto tr1;
case 110:
	if ( (*p) == 105 )
		goto tr130;
	goto tr1;
case 111:
	if ( (*p) == 98 )
		goto tr131;
	goto tr1;
case 112:
	if ( (*p) == 108 )
		goto tr132;
	goto tr1;
case 113:
	if ( (*p) == 101 )
		goto tr133;
	goto tr1;
case 114:
	if ( (*p) == 61 )
		goto tr134;
	goto tr1;
case 115:
	switch( (*p) ) {
		case 34: goto tr135;
		case 39: goto tr135;
	}
	goto tr1;
case 116:
	switch( (*p) ) {
		case 102: goto tr136;
		case 116: goto tr137;
	}
	goto tr1;
case 117:
	if ( (*p) == 97 )
		goto tr138;
	goto tr1;
case 118:
	if ( (*p) == 108 )
		goto tr139;
	goto tr1;
case 119:
	if ( (*p) == 115 )
		goto tr140;
	goto tr1;
case 120:
	if ( (*p) == 101 )
		goto tr141;
	goto tr1;
case 121:
	switch( (*p) ) {
		case 34: goto tr80;
		case 39: goto tr80;
	}
	goto tr1;
case 122:
	if ( (*p) == 114 )
		goto tr142;
	goto tr1;
case 123:
	if ( (*p) == 117 )
		goto tr143;
	goto tr1;
case 124:
	if ( (*p) == 101 )
		goto tr144;
	goto tr1;
	}

	tr1: cs = 0; goto _again;
	tr0: cs = 2; goto _again;
	tr2: cs = 3; goto _again;
	tr11: cs = 4; goto _again;
	tr16: cs = 5; goto _again;
	tr17: cs = 6; goto _again;
	tr18: cs = 7; goto _again;
	tr19: cs = 8; goto _again;
	tr12: cs = 9; goto _again;
	tr22: cs = 10; goto _again;
	tr23: cs = 11; goto _again;
	tr13: cs = 12; goto _again;
	tr25: cs = 13; goto _again;
	tr26: cs = 14; goto _again;
	tr27: cs = 15; goto _again;
	tr28: cs = 16; goto _again;
	tr29: cs = 17; goto _again;
	tr30: cs = 18; goto _again;
	tr14: cs = 19; goto _again;
	tr32: cs = 20; goto _again;
	tr15: cs = 21; goto _again;
	tr34: cs = 22; goto _again;
	tr4: cs = 23; goto _again;
	tr36: cs = 24; goto _again;
	tr37: cs = 25; goto _again;
	tr38: cs = 26; goto _again;
	tr39: cs = 27; goto _again;
	tr40: cs = 28; goto _again;
	tr41: cs = 29; goto _again;
	tr42: cs = 30; goto _again;
	tr43: cs = 31; goto _again;
	tr44: cs = 32; goto _again;
	tr45: cs = 33; goto f7;
	tr46: cs = 34; goto f8;
	tr5: cs = 35; goto _again;
	tr48: cs = 36; goto _again;
	tr49: cs = 37; goto _again;
	tr50: cs = 38; goto f7;
	tr51: cs = 39; goto f10;
	tr52: cs = 40; goto f8;
	tr6: cs = 41; goto _again;
	tr54: cs = 42; goto _again;
	tr56: cs = 43; goto _again;
	tr57: cs = 44; goto _again;
	tr58: cs = 45; goto f7;
	tr59: cs = 46; goto f8;
	tr60: cs = 47; goto f8;
	tr62: cs = 48; goto f8;
	tr63: cs = 49; goto f8;
	tr55: cs = 50; goto _again;
	tr64: cs = 51; goto _again;
	tr65: cs = 52; goto _again;
	tr66: cs = 53; goto f7;
	tr67: cs = 54; goto f8;
	tr68: cs = 55; goto f8;
	tr70: cs = 56; goto f8;
	tr71: cs = 57; goto f8;
	tr7: cs = 58; goto _again;
	tr72: cs = 59; goto _again;
	tr74: cs = 60; goto _again;
	tr75: cs = 61; goto _again;
	tr76: cs = 62; goto f7;
	tr78: cs = 63; goto _again;
	tr79: cs = 64; goto f8;
	tr77: cs = 65; goto f7;
	tr83: cs = 66; goto _again;
	tr84: cs = 67; goto f8;
	tr73: cs = 68; goto _again;
	tr86: cs = 69; goto _again;
	tr87: cs = 70; goto _again;
	tr88: cs = 71; goto _again;
	tr89: cs = 72; goto _again;
	tr90: cs = 73; goto _again;
	tr8: cs = 74; goto _again;
	tr91: cs = 75; goto _again;
	tr93: cs = 76; goto _again;
	tr94: cs = 77; goto _again;
	tr95: cs = 78; goto _again;
	tr96: cs = 79; goto _again;
	tr97: cs = 80; goto _again;
	tr98: cs = 81; goto _again;
	tr99: cs = 82; goto _again;
	tr100: cs = 83; goto _again;
	tr101: cs = 84; goto f7;
	tr102: cs = 85; goto f8;
	tr92: cs = 86; goto _again;
	tr9: cs = 87; goto _again;
	tr104: cs = 88; goto _again;
	tr106: cs = 89; goto _again;
	tr107: cs = 90; goto _again;
	tr108: cs = 91; goto f7;
	tr109: cs = 92; goto f8;
	tr105: cs = 93; goto _again;
	tr111: cs = 94; goto _again;
	tr112: cs = 95; goto _again;
	tr113: cs = 96; goto _again;
	tr114: cs = 97; goto f7;
	tr115: cs = 98; goto f8;
	tr10: cs = 99; goto _again;
	tr118: cs = 100; goto _again;
	tr120: cs = 101; goto _again;
	tr121: cs = 102; goto _again;
	tr122: cs = 103; goto _again;
	tr123: cs = 104; goto _again;
	tr124: cs = 105; goto _again;
	tr125: cs = 106; goto _again;
	tr126: cs = 107; goto f7;
	tr127: cs = 108; goto f8;
	tr119: cs = 109; goto _again;
	tr129: cs = 110; goto _again;
	tr130: cs = 111; goto _again;
	tr131: cs = 112; goto _again;
	tr132: cs = 113; goto _again;
	tr133: cs = 114; goto _again;
	tr134: cs = 115; goto _again;
	tr135: cs = 116; goto f7;
	tr136: cs = 117; goto _again;
	tr138: cs = 118; goto _again;
	tr139: cs = 119; goto _again;
	tr140: cs = 120; goto _again;
	tr141: cs = 121; goto f21;
	tr144: cs = 121; goto f22;
	tr137: cs = 122; goto _again;
	tr142: cs = 123; goto _again;
	tr143: cs = 124; goto _again;
	tr3: cs = 125; goto f0;
	tr20: cs = 125; goto f1;
	tr21: cs = 125; goto f2;
	tr24: cs = 125; goto f3;
	tr31: cs = 125; goto f4;
	tr33: cs = 125; goto f5;
	tr35: cs = 125; goto f6;
	tr47: cs = 125; goto f9;
	tr53: cs = 125; goto f11;
	tr61: cs = 125; goto f12;
	tr69: cs = 125; goto f13;
	tr80: cs = 125; goto f14;
	tr81: cs = 125; goto f15;
	tr103: cs = 125; goto f16;
	tr110: cs = 125; goto f17;
	tr117: cs = 125; goto f19;
	tr128: cs = 125; goto f20;
	tr82: cs = 126; goto f15;
	tr85: cs = 127; goto f15;
	tr116: cs = 128; goto f18;

f7:
#line 109 "indexer.rl"
	{
     currenttoken.clear();  
}
	goto _again;
f8:
#line 112 "indexer.rl"
	{
     currenttoken.push_back((*p));
}
	goto _again;
f10:
#line 116 "indexer.rl"
	{
//       cerr << fc << endl;
     currenttoken.push_back((*p));
}
	goto _again;
f22:
#line 227 "indexer.rl"
	{
     world.set_current_vis(1);
}
	goto _again;
f21:
#line 230 "indexer.rl"
	{
     world.set_current_vis(0);
}
	goto _again;
f14:
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f0:
#line 86 "indexer.rl"
	{
                     world.finish_current_object();

                }
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f11:
#line 122 "indexer.rl"
	{
     char *endptr;   // ignore  
//     cerr << "currenttoken" << currenttoken << endl;
     world.set_current_id(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f9:
#line 135 "indexer.rl"
	{
     char *endptr;   // ignore
     world.set_current_cs(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f20:
#line 146 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "Version " << currenttoken << endl;
     world.set_current_ver(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f17:
#line 159 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "user " << currenttoken << endl;
     world.set_current_uid(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f16:
#line 203 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "timestamp " << currenttoken << endl;
     world.set_current_ts(currenttoken.c_str());
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f19:
#line 215 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "user " << currenttoken << endl;
     world.set_current_user(currenttoken.c_str());
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f12:
#line 244 "indexer.rl"
	{
     char *endptr;   // ignore
     cerr << "lat" << currenttoken << endl;
     world.set_current_lat(strtod(currenttoken.c_str(), &endptr));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f13:
#line 254 "indexer.rl"
	{
     char *endptr;   // ignore
     cerr << "lon" << currenttoken << endl;
     world.set_current_lon(strtod(currenttoken.c_str(), &endptr));
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f3:
#line 6 "indexer.rl"
	{
       world.set_current_element_type_node();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f6:
#line 12 "indexer.rl"
	{
       world.set_current_element_type_way();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f4:
#line 18 "indexer.rl"
	{
       world.set_current_element_type_rel();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f5:
#line 24 "indexer.rl"
	{
       world.set_current_element_type_tag();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f2:
#line 30 "indexer.rl"
	{
       world.set_current_element_type_nd();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f1:
#line 35 "indexer.rl"
	{
       world.set_current_element_type_member();
       }
#line 103 "indexer.rl"
	{
       // record the start of a type of object
       world.record_start_position();
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f18:
#line 112 "indexer.rl"
	{
     currenttoken.push_back((*p));
}
#line 215 "indexer.rl"
	{
     char *endptr;   // ignore
//     cerr << "user " << currenttoken << endl;
     world.set_current_user(currenttoken.c_str());
}
#line 285 "indexer.rl"
	{ res = 1;      }
	goto _again;
f15:
#line 192 "indexer.rl"
	{
     char *endptr;   // ignore
     world.set_way_node_ref(strtol(currenttoken.c_str(), &endptr, 10));
}
#line 172 "indexer.rl"
	{
     char *endptr;   // ignore
     world.set_way_tag_key(currenttoken.c_str());
}
#line 182 "indexer.rl"
	{
     char *endptr;   // ignore
     world.set_way_tag_val(currenttoken.c_str());
}
#line 285 "indexer.rl"
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

#line 303 "indexer.rl"
  
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
