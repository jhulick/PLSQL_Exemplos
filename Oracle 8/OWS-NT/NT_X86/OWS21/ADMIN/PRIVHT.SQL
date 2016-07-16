Rem  Copyright (c) 1994, 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     ht.sql - Hyper Text packages
Rem   PURPOSE
Rem     Provide utility functions for producing HTML documents
Rem     from pl/sql.
Rem   NOTES
Rem     This script should be run in SQL*DBA, not SQL*Plus.
Rem     To run it in SQL*Plus, you must uncomment the "set define off" below.
Rem
Rem     Two sets of packages - one is all functions/constants (htf)
Rem                          - one is all procedures (htp)
Rem
Rem     A PL/SQL table of varchar2 is used to buffer output.
Rem       htp.print() buffers the output.
Rem       owa.get_page() fetches it out.
Rem
Rem     This script should be run by the owner of the OWA packages.
Rem   HISTORY
Rem	mpal	   08/19/96 -  Fix bug #393305
Rem     mpal       06/24/96 -  Adding escape sequence support '%'    
Rem     mbookman   03/11/96 -  Adding NLS fixes (substrB and lengthB)
Rem	kireland   02/02/96 -  HTML 3.0, Netscape and Microsoft extensions
Rem     mbookman   07/26/95 -  Added mailto support
Rem     mbookman   05/23/95 -  Full HTML 2.0 support
Rem                            Numerous function/procedure name
Rem                            changes for standardization
Rem     mloennro   09/05/94 -  Creation
Rem

Rem set define off

REM Creating HTF package body...
create or replace package body htf as

/* This function is private to the HTF package */
function IFNOTNULL(str1 in varchar2, str2 in varchar2) return varchar2 is
begin
   if (str1 is NULL)
     then return (NULL);
     else return (str2);
   end if;
end;

/* STRUCTURE tags */
function bodyOpen(cbackground in varchar2 DEFAULT NULL,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BODY'||
              IFNOTNULL(cbackground,' BACKGROUND="'||cbackground||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;
/* END STRUCTURE tags */

/* HEAD Related elements tags */
function title  (ctitle in varchar2) return varchar2 is
begin return ('<TITLE>'||ctitle||'</TITLE>'); end;

function htitle(ctitle      in varchar2,
                nsize       in integer  DEFAULT 1,
                calign      in varchar2 DEFAULT NULL,
                cnowrap     in varchar2 DEFAULT NULL,
                cclear      in varchar2 DEFAULT NULL,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return (title(ctitle)||
              header(nsize,ctitle,calign,cnowrap,cclear,cattributes)); end;

function base(	ctarget 	in varchar2 DEFAULT NULL,
		cattributes 	in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BASE'||
		IFNOTNULL(ctarget,' TARGET="'||ctarget||'"')||
              	IFNOTNULL(cattributes,' '||cattributes)||
		' HREF="http://'||owa_util.get_cgi_env('SERVER_NAME')||':'||
                                    owa_util.get_cgi_env('SERVER_PORT')||
                                    owa_util.get_cgi_env('SCRIPT_NAME')||
                                    owa_util.get_cgi_env('PATH_INFO')||'">');
end;

function isindex(cprompt in varchar2 DEFAULT NULL,
                 curl    in varchar2 DEFAULT NULL) return varchar2 is
begin return('<ISINDEX'||
              IFNOTNULL(cprompt,' PROMPT="'||cprompt||'"')||
              IFNOTNULL(curl,' HREF="'||curl||'"')||
             '>'); end;

function linkRel(crel   in varchar2, 
                 curl   in varchar2, 
                 ctitle in varchar2 DEFAULT NULL) return varchar2 is
begin return('<LINK REL="'||crel||'"'||
                  ' HREF="'||curl||'"'||
               IFNOTNULL(ctitle,' TITLE="'||ctitle||'"')||
             '>'); end;

function linkRev(crev   in varchar2, 
                 curl   in varchar2, 
                 ctitle in varchar2 DEFAULT NULL) return varchar2 is
begin return('<LINK REV="'||crev||'"'||
                  ' HREF="'||curl||'"'||
               IFNOTNULL(ctitle,' TITLE="'||ctitle||'"')||
             '>'); end;

function meta(chttp_equiv in varchar2,
              cname       in varchar2,
              ccontent    in varchar2) return varchar2 is
begin return('<META HTTP-EQUIV="'||chttp_equiv||
                       '" NAME="'||cname||
                    '" CONTENT="'||ccontent||
                    '">');
end;

function nextid(cidentifier in varchar2) return varchar2 is
begin return ('<NEXTID N="'||cidentifier||'>'); end;

/* END HEAD Related elements tags */

/* BODY ELEMENT tags */
function hr  (cclear      in varchar2 DEFAULT NULL,
              csrc        in varchar2 DEFAULT NULL,
              cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<HR'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(csrc,' SRC="'||csrc||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function line(cclear      in varchar2 DEFAULT NULL,
              csrc        in varchar2 DEFAULT NULL,
              cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(hr(cclear, csrc, cattributes)); end;

function br(cclear      in varchar2 DEFAULT NULL,
            cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BR'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function nl(cclear      in varchar2 DEFAULT NULL,
            cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(br(cclear, cattributes)); end;

function header(nsize   in integer,
                cheader in varchar2,
                calign  in varchar2 DEFAULT NULL,
                cnowrap in varchar2 DEFAULT NULL,
                cclear  in varchar2 DEFAULT NULL,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
	ch varchar2(2);
begin
	ch := 'H'||to_char(least(abs(nsize),6));
	return('<'||ch||
                IFNOTNULL(calign,' ALIGN="'||calign||'"')||
                IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
                IFNOTNULL(cnowrap,' NOWRAP')||
                IFNOTNULL(cattributes,' '||cattributes)||
               '>'||cheader||
               '</'||ch||'>');
end;

function anchor(curl        in varchar2,
                ctext       in varchar2,
                cname       in varchar2 DEFAULT NULL,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(	anchor2(curl,
			ctext,
			cname,
			NULL,
			cattributes));
end;

function anchor2(curl       in varchar2,
                ctext       in varchar2,
                cname       in varchar2 DEFAULT NULL,
		ctarget	    in varchar2 DEFAULT NULL,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
	curl_cname_null EXCEPTION;
begin 
	if curl is NULL and cname is NULL then
		RAISE curl_cname_null;
	end if;
	
	if curl is NULL then
		return('<A NAME="'||cname||'"'||
 			IFNOTNULL(ctext,'> '||ctext||' </A')||
                       '>');
	else
		return('<A HREF="'||curl||'"'||
        	       	IFNOTNULL(cname,' NAME="'||cname||'"')||
			IFNOTNULL(ctarget,' TARGET="'||ctarget||'"')||
               		IFNOTNULL(cattributes,' '||cattributes)||
              		'>'||ctext||
              		'</A>');
	end if;
exception
	when curl_cname_null then
		raise_application_error(-20001, 
			'curl and cname cannot be NULL');
end;


function mailto(caddress in varchar2,
                ctext    in varchar2,
                cname       in varchar2 DEFAULT NULL,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return (anchor('mailto:'||caddress,ctext,cname,cattributes)); end;

function img(curl        in varchar2,
             calign      in varchar2 DEFAULT NULL,
             calt        in varchar2 DEFAULT NULL,
             cismap      in varchar2 DEFAULT NULL,
             cattributes in varchar2 DEFAULT NULL
             ) return varchar2 is
begin return('<IMG SRC="'||curl||'"'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(calt,' ALT="'||calt||'"')||
               IFNOTNULL(cismap,' ISMAP')||
               IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

function img2(curl        in varchar2,
             calign      in varchar2 DEFAULT NULL,
             calt        in varchar2 DEFAULT NULL,
             cismap      in varchar2 DEFAULT NULL,
             cusemap     in varchar2 DEFAULT NULL,
             cattributes in varchar2 DEFAULT NULL
             ) return varchar2 is
begin return('<IMG SRC="'||curl||'"'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(calt,' ALT="'||calt||'"')||
               IFNOTNULL(cismap,' ISMAP')||
               IFNOTNULL(cusemap,' USEMAP="'||cusemap||'"')||
               IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;


function area(	ccoords	in varchar2,
             	cshape	in varchar2 DEFAULT NULL,
             	chref	in varchar2 DEFAULT NULL,
             	cnohref	in varchar2 DEFAULT NULL,
		ctarget in varchar2 DEFAULT NULL,
		cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<AREA'||
		IFNOTNULL(cshape,' SHAPE="'||cshape||'"')||
		' COORDS="'||ccoords||'"'||
                IFNOTNULL(chref,' HREF="'||chref||'"')||
                IFNOTNULL(cnohref,' NOHREF')||
                IFNOTNULL(ctarget,' CTARGET="'||ctarget||'"')||
		IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

function mapOpen(cname	in varchar2,cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<MAP NAME="'||cname||'"'||
		IFNOTNULL(cattributes,' '||cattributes)||
		'>'); end;

function bgsound(csrc	in varchar2,
		 cloop	in varchar2 DEFAULT NULL,
		 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BGSOUND SRC="'||csrc||'"'||
		IFNOTNULL(cloop,' LOOP="'||cloop||'"')||
		IFNOTNULL(cattributes,' '||cattributes)||
		'>');end;


function paragraph(calign       in varchar2 DEFAULT NULL,
                   cnowrap      in varchar2 DEFAULT NULL,
                   cclear       in varchar2 DEFAULT NULL,
                   cattributes  in varchar2 DEFAULT NULL) return varchar2 is
begin return('<P'||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cnowrap,' NOWRAP')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function div(	calign       in varchar2 DEFAULT NULL,
               	cattributes  in varchar2 DEFAULT NULL) return varchar2 is
begin return('<DIV'||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function address(cvalue       in varchar2,
                 cnowrap      in varchar2 DEFAULT NULL,
                 cclear       in varchar2 DEFAULT NULL,
                 cattributes  in varchar2 DEFAULT NULL) return varchar2 is
begin return('<ADDRESS'||
               IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
               IFNOTNULL(cnowrap,' NOWRAP')||
               IFNOTNULL(cattributes,' '||cattributes)||
             '>'||cvalue||
             '</ADDRESS>'); end;

function comment(ctext in varchar2) return varchar2 is
begin return('<!-- '||ctext||' -->'); end;

function preOpen(cclear      in varchar2 DEFAULT NULL,
                 cwidth      in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<PRE'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cwidth,' WIDTH="'||cwidth||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

function nobr(ctext in varchar2) return varchar2 is
begin return('<NOBR>'||ctext||'</NOBR>'); end;

function center(ctext in varchar2) return varchar2 is
begin return('<CENTER>'||ctext||'</CENTER>'); end;


function blockquoteOpen(cnowrap      in varchar2 DEFAULT NULL,
                        cclear       in varchar2 DEFAULT NULL,
                        cattributes  in varchar2 DEFAULT NULL) return varchar2
 is
begin return('<BLOCKQUOTE'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cnowrap,' NOWRAP')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

/* LIST tags */
function listHeader(ctext in varchar2,
                    cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<LH'||
              IFNOTNULL(cattributes,' '||cattributes)||
            '>'||ctext||
            '</LH>'); end;

function listItem(ctext       in varchar2 DEFAULT NULL,
                  cclear      in varchar2 DEFAULT NULL,
                  cdingbat    in varchar2 DEFAULT NULL,
                  csrc        in varchar2 DEFAULT NULL,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<LI'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cdingbat,' DINGBAT="'||cdingbat||'"')||
              IFNOTNULL(csrc,' SRC="'||csrc||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext);
end;

function ulistOpen(cclear      in varchar2 DEFAULT NULL,
                   cwrap       in varchar2 DEFAULT NULL,
                   cdingbat    in varchar2 DEFAULT NULL,
                   csrc        in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<UL'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cwrap,' WRAP="'||cwrap||'"')||
              IFNOTNULL(cdingbat,' DINGBAT="'||cdingbat||'"')||
              IFNOTNULL(csrc,' SRC="'||csrc||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function olistOpen(cclear      in varchar2 DEFAULT NULL,
                   cwrap       in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<OL'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cwrap,' WRAP="'||cwrap||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function dlistOpen(cclear      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<DL'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function dlistTerm(ctext       in varchar2 DEFAULT NULL,
                   cclear      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<DT'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext);
end;

function dlistDef(ctext       in varchar2 DEFAULT NULL,
                  cclear      in varchar2 DEFAULT NULL,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<DD'||
              IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext);
end;
/* END LIST tags */

/* SEMANTIC FORMAT ELEMENTS */
function dfn(ctext in varchar2,
              cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<DFN'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</DFN>'); end;

function cite(ctext in varchar2,
              cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<CITE'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</CITE>'); end;

function code(ctext in varchar2,
              cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<CODE'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</CODE>'); end;

function em   (ctext  in varchar2,
               cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<EM'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</EM>'); end;

function emphasis(ctext in varchar2,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(em(ctext,cattributes)); end;

function kbd(ctext in varchar2,
             cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<KBD'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</KBD>'); end;

function keyboard(ctext in varchar2,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(kbd(ctext,cattributes)); end;

function sample(ctext in varchar2,
                cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<SAMP'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</SAMP>'); end;

function strong   (ctext  in varchar2,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<STRONG'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</STRONG>'); end;

function variable(ctext in varchar2,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<VAR'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</VAR>'); end;

function big(	ctext  		in varchar2,
                cattributes 	in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BIG'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</BIG>'); end;

function small(	ctext  		in varchar2,
                cattributes 	in varchar2 DEFAULT NULL) return varchar2 is
begin return('<SMALL'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</SMALL>'); end;

function sub( 	ctext  		in varchar2,
		calign		in varchar2 DEFAULT NULL,
                cattributes 	in varchar2 DEFAULT NULL) return varchar2 is
begin return('<SUB'||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</SUB>'); end;

function sup(	ctext  		in varchar2,
		calign		in varchar2 DEFAULT NULL,
                cattributes 	in varchar2 DEFAULT NULL) return varchar2 is
begin return('<SUP'||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</SUP>'); end;

/* END SEMANTIC FORMAT ELEMENTS */

/* PHYSICAL FORMAT ELEMENTS */
function basefont(nsize in integer,
		  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<BASEFONT SIZE="'||nsize||'"'||
		IFNOTNULL(cattributes,' '||cattributes)||
		'>'); end;


function fontOpen(	ccolor	in varchar2 DEFAULT NULL,
		cface	in varchar2 DEFAULT NULL,
		csize	in varchar2 DEFAULT NULL,
		cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<FONT'||
		IFNOTNULL(ccolor,' COLOR="'||ccolor||'"')||
		IFNOTNULL(cface,' FACE="'||cface||'"')||
		IFNOTNULL(csize,' SIZE="'||csize||'"')||
		IFNOTNULL(cattributes,' '||cattributes)||
		'>');end;

function bold   (ctext  in varchar2,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<B'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</B>'); end;

function italic (ctext  in varchar2,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<I'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</I>'); end;

function teletype(ctext in varchar2,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<TT'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</TT>'); end;

function plaintext   (ctext  in varchar2,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<PLAINTEXT'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</PLAINTEXT>'); end;
function s   (ctext  in varchar2,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<S'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</S>'); end;
function strike   (ctext  in varchar2,
                 cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<STRIKE'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||ctext||'</STRIKE>'); end;
/* END PHYSICAL FORMAT ELEMENTS */


/* HTML FORMS */

function formOpen(curl in varchar2,
                  cmethod  in varchar2 DEFAULT 'POST',
		  ctarget  in varchar2 DEFAULT NULL,
		  cenctype in varchar2 DEFAULT NULL,
		  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<FORM ACTION="'||curl||'" METHOD="'||cmethod||'"'||
		IFNOTNULL(ctarget,' TARGET="'||ctarget||'"')||
		IFNOTNULL(cenctype,' ENCTYPE="'||cenctype||'"')||
		IFNOTNULL(cattributes,' '||cattributes)||
		'>'); end;

function formCheckbox(cname in varchar2,
                      cvalue      in varchar2 DEFAULT 'on',
                      cchecked    in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin 
   return('<INPUT TYPE="checkbox" NAME="'||cname||'"'||
           IFNOTNULL(cvalue,' VALUE="'||cvalue||'"')||
           IFNOTNULL(cchecked,' CHECKED')||
           IFNOTNULL(cattributes,' '||cattributes)||
          '>');
end;

function formHidden(cname       in varchar2,
                    cvalue      in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin 
   return('<INPUT TYPE="hidden" NAME="'||cname||'"'||' VALUE="'||cvalue||'"'||
           IFNOTNULL(cattributes,' '||cattributes)||
          '>'); 
end;

function formImage(cname       in varchar2,
                   csrc        in varchar2,
                   calign      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<INPUT TYPE="image" NAME="'||cname||'"'||
                                 ' SRC="'||csrc||'"'||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end; 

function formPassword(cname       in varchar2,
                      csize       in varchar2 DEFAULT NULL,
                      cmaxlength  in varchar2 DEFAULT NULL,
                      cvalue      in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin
   return('<INPUT TYPE="password" NAME="'||cname||'"'||
           IFNOTNULL(csize,' SIZE="'||csize||'"')||
           IFNOTNULL(cmaxlength,' MAXLENGTH="'||cmaxlength||'"')||
           IFNOTNULL(cvalue,' VALUE="'||cvalue||'"')||
           IFNOTNULL(cattributes,' '||cattributes)||
          '>'); 
end;

function formRadio(cname       in varchar2,
                   cvalue      in varchar2,
                   cchecked    in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<INPUT TYPE="radio" NAME="'||cname||'"'||
                               ' VALUE="'||cvalue||'"'||
              IFNOTNULL(cchecked,' CHECKED')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;

function formReset(cvalue      in varchar2 DEFAULT 'Reset',
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<INPUT TYPE="reset" VALUE="'||cvalue||'"'||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

function formSubmit(cname       in varchar2 DEFAULT NULL,
                    cvalue      in varchar2 DEFAULT 'Submit',
                    cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<INPUT TYPE="submit"'||
              IFNOTNULL(cname,' NAME="'||cname||'"')||
              IFNOTNULL(cvalue,' VALUE="'||cvalue||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'); end;

function formText(cname       in varchar2,
                  csize       in varchar2 DEFAULT NULL,
                  cmaxlength  in varchar2 DEFAULT NULL,
                  cvalue      in varchar2 DEFAULT NULL,
                  cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin
   return('<INPUT TYPE="text" NAME="'||cname||'"'||
           IFNOTNULL(csize,' SIZE="'||csize||'"')||
           IFNOTNULL(cmaxlength,' MAXLENGTH="'||cmaxlength||'"')||
           IFNOTNULL(cvalue,' VALUE="'||cvalue||'"')||
           IFNOTNULL(cattributes,' '||cattributes)||
          '>'); 
end;

function formSelectOpen(cname       in varchar2,
                        cprompt     in varchar2 DEFAULT NULL,
                        nsize       in integer  DEFAULT NULL,
                        cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return(cprompt||
            '<SELECT NAME="'||cname||'"'||
             IFNOTNULL(nsize,' SIZE="'||nsize||'"')||
             IFNOTNULL(cattributes,' '||cattributes)||
            '>');
end;

function formSelectOption(cvalue      in varchar2,
                          cselected   in varchar2 DEFAULT NULL,
                          cattributes in varchar2) return varchar2 is 
begin return('<OPTION'||
              IFNOTNULL(cselected,' SELECTED')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>'||cvalue); end;

function formTextarea(cname       in varchar2,
                      nrows       in integer,
                      ncolumns    in integer,
                      calign      in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<TEXTAREA NAME="'||cname||'"'||
                      ' ROWS='||to_char(nrows)||
                      ' COLS='||to_char(ncolumns)||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '></TEXTAREA>');
end;


function formTextarea2(cname       in varchar2,
                      nrows       in integer,
                      ncolumns    in integer,
                      calign      in varchar2 DEFAULT NULL,
                      cwrap       in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return('<TEXTAREA NAME="'||cname||'"'||
                      ' ROWS='||to_char(nrows)||
                      ' COLS='||to_char(ncolumns)||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cwrap,' WRAP="'||cwrap||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '></TEXTAREA>');
end;

function formTextareaOpen(cname       in varchar2,
                          nrows       in integer,
                          ncolumns    in integer,
                          calign      in varchar2 DEFAULT NULL,
                          cattributes in varchar2 DEFAULT NULL) return varchar2
 is
begin return('<TEXTAREA NAME="'||cname||'"'||
                      ' ROWS='||to_char(nrows)||
                      ' COLS='||to_char(ncolumns)||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;


function formTextareaOpen2(cname       in varchar2,
                          nrows       in integer,
                          ncolumns    in integer,
                          calign      in varchar2 DEFAULT NULL,
                          cwrap       in varchar2 DEFAULT NULL,
                          cattributes in varchar2 DEFAULT NULL) return varchar2
 is
begin return('<TEXTAREA NAME="'||cname||'"'||
                      ' ROWS='||to_char(nrows)||
                      ' COLS='||to_char(ncolumns)||
              IFNOTNULL(calign,' ALIGN="'||calign||'"')||
              IFNOTNULL(cwrap,' WRAP="'||cwrap||'"')||
              IFNOTNULL(cattributes,' '||cattributes)||
             '>');
end;
/* END HTML FORMS */

/* HTML TABLES */
function tableOpen(cborder     in varchar2 DEFAULT NULL,
                   calign      in varchar2 DEFAULT NULL,
                   cnowrap     in varchar2 DEFAULT NULL,
                   cclear      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return ('<TABLE '||
               IFNOTNULL(cborder,' '||cborder)||
               IFNOTNULL(cnowrap,' NOWRAP')||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(cclear,' CLEAR="'||cclear||'"')||
               IFNOTNULL(cattributes,' '||cattributes)||
              '>'); end;

function tableCaption(ccaption in varchar2,
                      calign   in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return ('<CAPTION'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(cattributes,' '||cattributes)||
              '>'||
              ccaption||'</CAPTION>'); end;

function tableRowOpen(calign      in varchar2 DEFAULT NULL,
                      cvalign     in varchar2 DEFAULT NULL,
                      cdp         in varchar2 DEFAULT NULL,
                      cnowrap     in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return ('<TR'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(cvalign,' VALIGN="'||cvalign||'"')||
               IFNOTNULL(cdp,' DP="'||cdp||'"')||
               IFNOTNULL(cnowrap,' NOWRAP')||
               IFNOTNULL(cattributes,' '||cattributes)||
              '>'); end;

function tableHeader(cvalue      in varchar2 DEFAULT NULL,
                     calign      in varchar2 DEFAULT NULL,
                     cdp         in varchar2 DEFAULT NULL,
                     cnowrap     in varchar2 DEFAULT NULL,
                     crowspan    in varchar2 DEFAULT NULL,
                     ccolspan    in varchar2 DEFAULT NULL,
                     cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return ('<TH'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(cdp,' DP="'||cdp||'"')||
               IFNOTNULL(crowspan,' ROWSPAN="'||crowspan||'"')||
               IFNOTNULL(ccolspan,' COLSPAN="'||ccolspan||'"')||
               IFNOTNULL(cnowrap,' NOWRAP')||
               IFNOTNULL(cattributes,' '||cattributes)||
              '>'||
              cvalue||'</TH>'); end;
 
function tableData(cvalue      in varchar2 DEFAULT NULL,
                   calign      in varchar2 DEFAULT NULL,
                   cdp         in varchar2 DEFAULT NULL,
                   cnowrap     in varchar2 DEFAULT NULL,
                   crowspan    in varchar2 DEFAULT NULL,
                   ccolspan    in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) return varchar2 is
begin return ('<TD'||
               IFNOTNULL(calign,' ALIGN="'||calign||'"')||
               IFNOTNULL(cdp,' DP="'||cdp||'"')||
               IFNOTNULL(crowspan,' ROWSPAN="'||crowspan||'"')||
               IFNOTNULL(ccolspan,' COLSPAN="'||ccolspan||'"')||
               IFNOTNULL(cnowrap,' NOWRAP')||
               IFNOTNULL(cattributes,' '||cattributes)||
              '>'||
              cvalue||'</TD>'); end;
/* END HTML TABLES */

/* BEGIN HTML FRAMES - Netscape Extensions FRAMESET, FRAME tags */
function framesetOpen(	crows	in varchar2 DEFAULT NULL,			/* row height value list */
			ccols	in varchar2 DEFAULT NULL,
			cattributes in varchar2 DEFAULT NULL) return varchar2 is	/* column width list */
begin  
 return('<FRAMESET'||
	IFNOTNULL(crows, ' ROWS="'||crows||'"')||
	IFNOTNULL(ccols, ' COLS="'||ccols||'"')||
	IFNOTNULL(cattributes,' '||cattributes)||
	'>'); 
end framesetOpen;


function frame(		csrc	in varchar2,				/* URL */
			cname	in varchar2 DEFAULT NULL,		/* Window name */
			cmarginwidth 	in varchar2 DEFAULT NULL,	/* value in pixels */
			cmarginheight	in varchar2 DEFAULT NULL,	/* value in pixels */
			cscrolling	in varchar2 DEFAULT NULL,	/* yes | no | auto */
			cnoresize	in varchar2 DEFAULT NULL,
			cattributes	in varchar2 DEFAULT NULL) return varchar2 is	/* user cannot resize frame */
begin 
 return('<FRAME SRC="'||csrc||'"'||
	IFNOTNULL(cname, ' NAME="'||cname||'"')||
	IFNOTNULL(cmarginwidth, ' MARGINWIDTH="'||cmarginwidth||'"')||
	IFNOTNULL(cmarginheight, ' MARGINHEIGHT="'||cmarginheight||'"')||
	IFNOTNULL(cscrolling, ' SCROLLING="'||cscrolling||'"')||
	IFNOTNULL(cnoresize, ' NORESIZE')||
	IFNOTNULL(cattributes,' '||cattributes)||
	'>');
end frame;


/* END HTML FRAMES */


/* SPECIAL FUNCTIONS */
function escape_sc(ctext in varchar2) return varchar2 is
begin return(replace(
             replace(
             replace(
             replace(
             replace(ctext, '&', '&amp;' ),
                            '%', '%25'   ),
                            '"', '&quot;'),
                            '<', '&lt;'  ),
                            '>', '&gt;'  ));
end;
/* END SPECIAL FUNCTIONS */

/* END BODY ELEMENT tags */
end;
/
show errors

REM Creating HTP package body...
create or replace package body htp as

/* STRUCTURE tags */
procedure htmlOpen is
begin p(htf.htmlOpen); end;

procedure htmlClose is
begin p(htf.htmlClose); end;

procedure headOpen is
begin p(htf.headOpen); end;

procedure headClose is
begin p(htf.headClose); end;

procedure bodyOpen(cbackground in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.bodyOpen(cbackground,cattributes)); end;

procedure bodyClose is
begin p(htf.bodyClose); end;
/* END STRUCTURE tags */

/* HEAD Related elements tags */
procedure title  (ctitle in varchar2) is
begin p(htf.title(ctitle)); end;

procedure htitle(ctitle      in varchar2,
                 nsize       in integer  DEFAULT 1,
                 calign      in varchar2 DEFAULT NULL,
                 cnowrap     in varchar2 DEFAULT NULL,
                 cclear      in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.htitle(ctitle,nsize,calign,cnowrap,cclear,cattributes)); end;

procedure base(	ctarget 	in varchar2 DEFAULT NULL,
		cattributes	in varchar2 DEFAULT NULL) is
begin p(htf.base(ctarget,cattributes)); end;

procedure isindex(cprompt in varchar2 DEFAULT NULL,
                  curl    in varchar2 DEFAULT NULL) is
begin p(htf.isindex(cprompt, curl)); end;

procedure linkRel(crel   in varchar2,
                  curl   in varchar2, 
                  ctitle in varchar2 DEFAULT NULL) is
begin p(htf.linkRel(crel, curl, ctitle)); end;

procedure linkRev(crev   in varchar2,
                  curl   in varchar2, 
                  ctitle in varchar2 DEFAULT NULL) is
begin p(htf.linkRev(crev, curl, ctitle)); end;

procedure meta(chttp_equiv in varchar2,
               cname       in varchar2,
               ccontent    in varchar2) is 
begin p(htf.meta(chttp_equiv, cname, ccontent)); end;

procedure nextid(cidentifier in varchar2) is 
begin p(htf.nextid(cidentifier)); end;
/* END HEAD Related elements tags */

/* BODY ELEMENT tags */
procedure hr  (cclear      in varchar2 DEFAULT NULL,
               csrc        in varchar2 DEFAULT NULL,
               cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.hr(cclear, csrc, cattributes)); end;

procedure line(cclear      in varchar2 DEFAULT NULL,
               csrc        in varchar2 DEFAULT NULL,
               cattributes in varchar2 DEFAULT NULL) is 
begin htp.hr(cclear, csrc, cattributes); end;

procedure nl  (cclear      in varchar2 DEFAULT NULL,
               cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.nl(cclear,cattributes)); end;

procedure br  (cclear      in varchar2 DEFAULT NULL,
               cattributes in varchar2 DEFAULT NULL) is 
begin htp.nl(cclear,cattributes); end;

procedure header(nsize   in integer,
                 cheader in varchar2,
                 calign  in varchar2 DEFAULT NULL,
                 cnowrap in varchar2 DEFAULT NULL,
                 cclear  in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.header(nsize,cheader,calign,cnowrap,cclear,cattributes)); end;

procedure anchor(curl        in varchar2,
                 ctext       in varchar2,
                 cname       in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.anchor(curl,ctext,cname,cattributes)); end;

procedure anchor2(curl        in varchar2,
                 ctext       in varchar2,
                 cname       in varchar2 DEFAULT NULL,
		 ctarget     in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.anchor2(curl,ctext,cname,ctarget,cattributes)); end;

procedure mailto(caddress    in varchar2,
                 ctext       in varchar2,
                 cname       in varchar2 DEFAULT NULL,
                 cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.mailto(caddress,ctext,cname,cattributes)); end;

procedure img(curl        in varchar2,
              calign      in varchar2 DEFAULT NULL,
              calt        in varchar2 DEFAULT NULL,
              cismap      in varchar2 DEFAULT NULL,
              cattributes in varchar2 DEFAULT NULL) is
begin p(htf.img(curl,calign,calt,cismap,cattributes)); end;

procedure img2(curl        in varchar2,
              calign      in varchar2 DEFAULT NULL,
              calt        in varchar2 DEFAULT NULL,
              cismap      in varchar2 DEFAULT NULL,
              cusemap     in varchar2 DEFAULT NULL,
              cattributes in varchar2 DEFAULT NULL) is
begin p(htf.img2(curl,calign,calt,cismap,cusemap,cattributes)); end;

procedure area(	ccoords	in varchar2,
              	cshape	in varchar2 DEFAULT NULL,
              	chref	in varchar2 DEFAULT NULL,
             	cnohref	in varchar2 DEFAULT NULL,
		ctarget in varchar2 DEFAULT NULL,
		cattributes in varchar2 DEFAULT NULL) is
begin p(htf.area(ccoords,cshape,chref,cnohref,ctarget,cattributes));end;

procedure mapOpen(cname	in varchar2,cattributes in varchar2 DEFAULT NULL) is
begin p(htf.mapOpen(cname,cattributes)); end;
procedure mapClose is
begin p(htf.mapClose); end;

procedure bgsound(csrc	in varchar2,
		  cloop	in varchar2 DEFAULT NULL,
		  cattributes in varchar2 DEFAULT NULL) is
begin p(htf.bgsound(csrc,cloop,cattributes));end;

procedure para is
begin p(htf.para); end;

procedure paragraph(calign       in varchar2 DEFAULT NULL,
                    cnowrap      in varchar2 DEFAULT NULL,
                    cclear       in varchar2 DEFAULT NULL,
                    cattributes  in varchar2 DEFAULT NULL) is
begin p(htf.paragraph(calign,cnowrap,cclear,cattributes)); end;

procedure div(	calign       in varchar2 DEFAULT NULL,
                cattributes  in varchar2 DEFAULT NULL) is
begin p(htf.div(calign,cattributes)); end;

procedure address(cvalue       in varchar2,
                  cnowrap      in varchar2 DEFAULT NULL,
                  cclear       in varchar2 DEFAULT NULL,
                  cattributes  in varchar2 DEFAULT NULL) is
begin p(htf.address(cvalue, cnowrap, cclear, cattributes)); end;

procedure comment(ctext in varchar2) is
begin p(htf.comment(ctext)); end;

procedure preOpen(cclear      in varchar2 DEFAULT NULL,
                  cwidth      in varchar2 DEFAULT NULL,
                  cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.preOpen(cclear,cwidth,cattributes)); end;

procedure preClose is
begin p(htf.preClose); end;

procedure listingOpen is
begin p(htf.listingOpen); end;
procedure listingClose is
begin p(htf.listingClose); end;

procedure nobr(ctext in varchar2) is
begin p(htf.nobr(ctext)); end;
procedure wbr is
begin p(htf.wbr); end;

procedure center(ctext in varchar2) is
begin p(htf.center(ctext)); end;

procedure centerOpen is
begin p(htf.centerOpen); end;

procedure centerClose is
begin p(htf.centerClose); end;



procedure blockquoteOpen(cnowrap      in varchar2 DEFAULT NULL,
                         cclear       in varchar2 DEFAULT NULL,
                         cattributes  in varchar2 DEFAULT NULL) is
begin p(htf.blockquoteOpen(cnowrap,cclear,cattributes)); end;

procedure blockquoteClose is
begin p(htf.blockquoteClose); end;

/* LIST tags */
procedure listHeader(ctext in varchar2,
                     cattributes in varchar2 DEFAULT NULL) is
begin p(htf.listHeader(ctext,cattributes)); end;

procedure listItem(ctext       in varchar2 DEFAULT NULL,
                   cclear      in varchar2 DEFAULT NULL,
                   cdingbat    in varchar2 DEFAULT NULL,
                   csrc        in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.listItem(ctext,cclear,cdingbat,csrc,cattributes)); end;

procedure ulistOpen(cclear      in varchar2 DEFAULT NULL,
                    cwrap       in varchar2 DEFAULT NULL,
                    cdingbat    in varchar2 DEFAULT NULL,
                    csrc        in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.ulistOpen(cclear,cwrap,cdingbat,csrc,cattributes)); end;

procedure ulistClose is
begin p(htf.ulistClose); end;

procedure olistOpen(cclear      in varchar2 DEFAULT NULL,
                    cwrap       in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.olistOpen(cclear,cwrap,cattributes)); end;

procedure olistClose is
begin p(htf.olistClose); end;

procedure dlistOpen(cclear      in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.dlistOpen(cclear,cattributes)); end;

procedure dlistTerm(ctext       in varchar2 DEFAULT NULL,
                    cclear      in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.dlistTerm(ctext,cclear,cattributes)); end;

procedure dlistDef(ctext       in varchar2 DEFAULT NULL,
                   cclear      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) is 
begin p(htf.dlistDef(ctext,cclear,cattributes)); end;

procedure dlistClose is
begin p(htf.dlistClose); end;

procedure menulistOpen is
begin p(htf.menulistOpen); end;

procedure menulistClose is
begin p(htf.menulistClose); end;

procedure dirlistOpen is
begin p(htf.dirlistOpen); end;

procedure dirlistClose is
begin p(htf.dirlistClose); end;
/* END LIST tags */

/* SEMANTIC FORMAT ELEMENTS */
procedure dfn(ctext in varchar2,
               cattributes in varchar2 DEFAULT NULL) is
begin p(htf.dfn(ctext,cattributes)); end;

procedure cite(ctext in varchar2,
               cattributes in varchar2 DEFAULT NULL) is
begin p(htf.cite(ctext,cattributes)); end;

procedure code(ctext in varchar2,
               cattributes in varchar2 DEFAULT NULL) is
begin p(htf.code(ctext,cattributes)); end;

procedure em(ctext  in varchar2,
             cattributes in varchar2 DEFAULT NULL) is
begin p(htf.em(ctext,cattributes)); end;

procedure emphasis(ctext in varchar2,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.emphasis(ctext,cattributes)); end;

procedure kbd(ctext in varchar2,
              cattributes in varchar2 DEFAULT NULL) is
begin p(htf.kbd(ctext,cattributes)); end;

procedure keyboard(ctext in varchar2,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.keyboard(ctext,cattributes)); end;

procedure sample(ctext in varchar2,
                 cattributes in varchar2 DEFAULT NULL) is
begin p(htf.sample(ctext,cattributes)); end;

procedure strong (ctext  in varchar2,
                  cattributes in varchar2 DEFAULT NULL) is
begin p(htf.strong(ctext,cattributes)); end;

procedure variable(ctext in varchar2,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.variable(ctext,cattributes)); end;

procedure big(	ctext  		in varchar2,
                cattributes 	in varchar2 DEFAULT NULL) is
begin p(htf.big(ctext,cattributes)); end;

procedure small(ctext  		in varchar2,
                cattributes 	in varchar2 DEFAULT NULL) is
begin p(htf.small(ctext,cattributes)); end;

procedure sub(	ctext  		in varchar2,
		calign		in varchar2 DEFAULT NULL,
                cattributes 	in varchar2 DEFAULT NULL) is
begin p(htf.sub(ctext,calign,cattributes)); end;

procedure sup(	ctext  		in varchar2,
		calign		in varchar2 DEFAULT NULL,
                cattributes 	in varchar2 DEFAULT NULL) is
begin p(htf.sup(ctext,calign,cattributes)); end;


/* END SEMANTIC FORMAT ELEMENTS */

/* PHYSICAL FORMAT ELEMENTS */
procedure basefont(nsize in integer) is
begin p(htf.basefont(nsize));end;

procedure fontOpen(ccolor	in varchar2 DEFAULT NULL,
		   cface	in varchar2 DEFAULT NULL,
		   csize 	in varchar2 DEFAULT NULL,
		   cattributes	in varchar2 DEFAULT NULL) is
begin p(htf.fontOpen(ccolor,cface,csize,cattributes)); end;
	
procedure fontClose is
begin p(htf.fontClose); end;

procedure bold   (ctext  in varchar2,
                  cattributes in varchar2 DEFAULT NULL) is
begin p(htf.bold(ctext,cattributes)); end;

procedure italic (ctext  in varchar2,
                  cattributes in varchar2 DEFAULT NULL) is
begin p(htf.italic(ctext,cattributes)); end;

procedure teletype(ctext in varchar2,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.teletype(ctext,cattributes)); end;

procedure plaintext(ctext  in varchar2,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.plaintext(ctext,cattributes)); end;

procedure s(ctext  in varchar2,
            cattributes in varchar2 DEFAULT NULL) is
begin p(htf.s(ctext,cattributes)); end;

procedure strike (ctext  in varchar2,
                  cattributes in varchar2 DEFAULT NULL) is
begin p(htf.strike(ctext,cattributes)); end;

/* END PHYSICAL FORMAT ELEMENTS */

/* HTML FORMS */

procedure formOpen(curl     in varchar2,
                   cmethod  in varchar2 DEFAULT 'POST',
		   ctarget  in varchar2 DEFAULT NULL,
		   cenctype in varchar2 DEFAULT NULL,
		   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formOpen(curl,cmethod,ctarget,cenctype,cattributes)); end;

procedure formCheckbox(cname       in varchar2,
                       cvalue      in varchar2 DEFAULT 'on',
                       cchecked    in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formCheckbox(cname,cvalue,cchecked,cattributes)); end;

procedure formHidden(cname       in varchar2,
                     cvalue      in varchar2 DEFAULT NULL,
                     cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formHidden(cname,cvalue,cattributes)); end;

procedure formImage(cname       in varchar2,
                    csrc        in varchar2,
                    calign      in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formImage(cname,csrc,calign,cattributes)); end;

procedure formPassword(cname       in varchar2,
                       csize       in varchar2 DEFAULT NULL,
                       cmaxlength  in varchar2 DEFAULT NULL,
                       cvalue      in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formPassword(cname,csize,cmaxlength,cvalue,cattributes)); end;

procedure formRadio(cname       in varchar2,
                    cvalue      in varchar2,
                    cchecked    in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formRadio(cname,cvalue,cchecked,cattributes)); end;

procedure formReset(cvalue      in varchar2 DEFAULT 'Reset',
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formReset(cvalue,cattributes)); end;

procedure formSubmit(cname       in varchar2 DEFAULT NULL,
                     cvalue      in varchar2 DEFAULT 'Submit',
                     cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formSubmit(cname,cvalue,cattributes)); end;

procedure formText(cname       in varchar2,
                   csize       in varchar2 DEFAULT NULL,
                   cmaxlength  in varchar2 DEFAULT NULL,
                   cvalue      in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formText(cname,csize,cmaxlength,cvalue,cattributes)); end;

procedure formSelectOpen(cname       in varchar2,
                         cprompt     in varchar2 DEFAULT NULL,
                         nsize       in integer  DEFAULT NULL,
                         cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formSelectOpen(cname,cprompt,nsize,cattributes)); end;

procedure formSelectOption(cvalue      in varchar2,
                           cselected   in varchar2 DEFAULT NULL,
                           cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formSelectOption(cvalue,cselected,cattributes)); end;

procedure formSelectClose is
begin p(htf.formSelectClose); end;

procedure formTextarea(cname       in varchar2,
                       nrows       in integer,
                       ncolumns    in integer,
                       calign      in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formTextarea(cname,nrows,ncolumns,calign,cattributes)); end;
 

procedure formTextarea2(cname       in varchar2,
                       nrows       in integer,
                       ncolumns    in integer,
                       calign      in varchar2 DEFAULT NULL,
                       cwrap       in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formTextarea2(cname,nrows,ncolumns,calign,cwrap,cattributes)); end;
 

procedure formTextareaOpen(cname       in varchar2,
                           nrows       in integer,
                           ncolumns    in integer,
                           calign      in varchar2 DEFAULT NULL,
                           cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formTextareaOpen(cname,nrows,ncolumns,calign,cattributes)); end;
 

procedure formTextareaOpen2(cname       in varchar2,
                           nrows       in integer,
                           ncolumns    in integer,
                           calign      in varchar2 DEFAULT NULL,
                           cwrap       in varchar2 DEFAULT NULL,
                           cattributes in varchar2 DEFAULT NULL) is
begin p(htf.formTextareaOpen2(cname,nrows,ncolumns,calign,cwrap,cattributes)); end;
 
procedure formTextareaClose is
begin p(htf.formTextareaClose); end;

procedure formClose is
begin p(htf.formClose); end;
/* END HTML FORMS */

/* HTML TABLES */
procedure tableOpen(cborder in varchar2 DEFAULT NULL,
                   calign in varchar2 DEFAULT NULL,
                   cnowrap in varchar2 DEFAULT NULL,
                   cclear in varchar2 DEFAULT NULL,
                   cattributes in varchar2 DEFAULT NULL) is
begin p(htf.tableOpen(cborder,calign,cnowrap,cclear,cattributes)); end;

procedure tableCaption(ccaption    in varchar2,
                       calign      in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.tableCaption(ccaption,calign,cattributes)); end;

procedure tableRowOpen(calign      in varchar2 DEFAULT NULL,
                       cvalign     in varchar2 DEFAULT NULL,
                       cdp         in varchar2 DEFAULT NULL,
                       cnowrap     in varchar2 DEFAULT NULL,
                       cattributes in varchar2 DEFAULT NULL) is
begin p(htf.tableRowOpen(calign,cvalign,cdp,cnowrap,cattributes)); end;

procedure tableHeader(cvalue      in varchar2 DEFAULT NULL,
                      calign      in varchar2 DEFAULT NULL,
                      cdp         in varchar2 DEFAULT NULL,
                      cnowrap     in varchar2 DEFAULT NULL,
                      crowspan    in varchar2 DEFAULT NULL,
                      ccolspan    in varchar2 DEFAULT NULL,
                      cattributes in varchar2 DEFAULT NULL) is
begin p(htf.tableHeader(cvalue,calign,cdp,cnowrap,
                        crowspan,ccolspan,cattributes)); end;

procedure tableData(cvalue      in varchar2 DEFAULT NULL,
                    calign      in varchar2 DEFAULT NULL,
                    cdp         in varchar2 DEFAULT NULL,
                    cnowrap     in varchar2 DEFAULT NULL,
                    crowspan    in varchar2 DEFAULT NULL,
                    ccolspan    in varchar2 DEFAULT NULL,
                    cattributes in varchar2 DEFAULT NULL) is
begin p(htf.tableData(cvalue,calign,cdp,cnowrap,
                      crowspan,ccolspan,cattributes)); end;

procedure tableRowClose is
begin p(htf.tableRowClose); end;

procedure tableClose is
begin p(htf.tableClose); end;
/* END HTML TABLES */

/* BEGIN HTML FRAMES - Netscape Extensions FRAMESET, FRAME tags */
procedure framesetOpen(	crows	in varchar2 DEFAULT NULL,	/* row height value list */
			ccols	in varchar2 DEFAULT NULL,
			cattributes in varchar2 DEFAULT NULL) is	/* column width list */
begin 
 p(htf.framesetOpen( crows, ccols, cattributes )); 
end framesetOpen;

procedure framesetClose is
begin 
 p(htf.framesetClose); 
end framesetClose;

procedure frame(	csrc	in varchar2,				/* URL */
			cname	in varchar2 DEFAULT NULL,		/* Window Name */
			cmarginwidth 	in varchar2 DEFAULT NULL,	/* Value in pixels */
			cmarginheight	in varchar2 DEFAULT NULL,	/* Value in pixels */
			cscrolling	in varchar2 DEFAULT NULL,	/* yes | no | auto */
			cnoresize	in varchar2 DEFAULT NULL,
			cattributes 	in varchar2 DEFAULT NULL) is	/* Not resizable by user */
begin 
 p(htf.frame( csrc, cname, cmarginwidth, cmarginheight, cscrolling, cnoresize, cattributes )); 
end frame;

procedure noframesOpen is
begin 
 p(htf.noframesOpen); 
end noframesOpen;

procedure noframesClose is
begin 
 p(htf.noframesClose); 
end noframesClose;

/* END HTML FRAMES */




/* SPECIAL PROCEDURES */
procedure print (cbuf in varchar2 DEFAULT NULL) is
   loc integer:=0;
   len integer:=lengthb(cbuf);
begin
   while ((len - loc) >= HTBUF_LEN )
   loop
      rows_in := rows_in + 1;
      htbuf(rows_in) := substrb(cbuf, loc+1, HTBUF_LEN);
      loc := loc + HTBUF_LEN;
   end loop;

   rows_in := rows_in + 1;
   htbuf(rows_in) := substrb(cbuf,loc+1)||'
'; 
   /* The above broken line is intentional.  Do not modify */
end;

/* Print, but without the newline */
procedure prn (cbuf in varchar2 DEFAULT NULL) is
   loc integer:=0;
   len integer:=lengthb(cbuf);
begin
   while ((len - loc) >= HTBUF_LEN )
   loop
      rows_in := rows_in + 1;
      htbuf(rows_in) := substrb(cbuf, loc+1, HTBUF_LEN);
      loc := loc + HTBUF_LEN;
   end loop;

   rows_in := rows_in + 1;
   htbuf(rows_in) := substrb(cbuf,loc+1);
end;

procedure print (dbuf in date) is
begin print(to_char(dbuf)); end;

procedure print (nbuf in number) is
begin print(to_char(nbuf)); end;

procedure prn (dbuf in date) is
begin prn(to_char(dbuf)); end;

procedure prn (nbuf in number) is
begin prn(to_char(nbuf)); end;

procedure p (cbuf in varchar2 DEFAULT NULL) is
begin print(cbuf); end;

procedure p (dbuf in date) is
begin print(to_char(dbuf)); end;

procedure p (nbuf in number) is
begin print(to_char(nbuf)); end;

procedure prints(ctext in varchar2) is
begin p(htf.escape_sc(ctext)); end;

procedure ps(ctext in varchar2) is
begin p(htf.escape_sc(ctext)); end;

procedure escape_sc(ctext in varchar2) is
begin p(htf.escape_sc(ctext)); end;
/* END SPECIAL PROCEDURES */

end;
/
show errors

