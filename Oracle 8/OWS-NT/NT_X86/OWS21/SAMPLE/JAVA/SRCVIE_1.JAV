/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      srcview.java
**    DESCRIPTION
**      
**    RETURNS
** 
**    NOTES
**      
**    MODIFIED   (MM/DD/YY)
**     mfreedma      09/11/96 -  Added Banner
*/

import oracle.html.*;
import java.io.*;

//
// This program takes a filename and display the content of the file
//
public
class srcview {

public static void main (String args[]) {

  HtmlHead hd = new HtmlHead("srcview");
  HtmlBody bd = new HtmlBody();
  bd.setBackgroundColor("#fffff2");
  bd.setUnfollowedLinkColor("#cc0000");
  bd.setActivatedLinkColor("#ff3300");
  bd.setFollowedLinkColor("#000055");
  
  HtmlPage hp = new HtmlPage(hd,bd);
  
  if (args[0].length() != 0) {
    if (args[0].startsWith("filename",0)) {
      int pos = args[0].indexOf("=");
      String filename = args[0].substring(pos + 1);
      String userDir = System.getProperty("ORACLE_HOME") + "\\ows21\\sample\\java\\";
      String pathname = new String(userDir + filename);
      if (!pathname.endsWith(".java")) {
	pathname = pathname + ".java";
      }
      try {
	File file = new File(pathname);
	DataInputStream ds = new DataInputStream(new FileInputStream(file));
	StringBuffer buf = new StringBuffer();

	try {
	  String line;
	  while ((line = ds.readLine()) != null) {
	    buf.append(line);
	    buf.append("\n");
	  }
	} catch (EOFException e) {
	  // reached the end of stream
	  ds.close();
	}
	
	bd
	  .addItem(new banner(filename.toUpperCase()))
	  .addItem(SimpleItem.Paragraph)
	  .addItem(new Preformat().addItem(buf.toString()))
	  .addItem(SimpleItem.Paragraph)
	  .addItem(new trailer("srcview.java"));

      } catch (FileNotFoundException e) {
	bd.addItem("FileNotFoundException caught\n").addItem(SimpleItem.Paragraph);  
	bd.addItem("args[0]=").addItem(args[0]).addItem(SimpleItem.Paragraph);  
	bd.addItem("pathname=").addItem(pathname).addItem(SimpleItem.Paragraph);
      } catch (IOException e) {
	bd.addItem("IOException caught\n").addItem(SimpleItem.Paragraph);    
	bd.addItem("args[0]=").addItem(args[0]).addItem(SimpleItem.Paragraph); 
	bd.addItem("pathname=").addItem(pathname).addItem(SimpleItem.Paragraph);
      }
      
    }
  } else {
    bd.addItem("args[0]=").addItem(args[0]);    
  }
  
  hp.printHeader();
  hp.print();
}
  
}
