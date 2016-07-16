/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
**    NAME
**      list.java
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
import java.util.*;
import java.net.URL;
import java.net.MalformedURLException;

//
// This simple demo demonstrates the list handling capability
// of package oracle.html. 
// 
public
class list {

  // the entry point of this program
public static void main(String args[]) throws MalformedURLException
{
  // Create the HTML Page Object
  HtmlPage hp = new HtmlPage();

  // Create the head
  HtmlHead hd = new HtmlHead("List Demo");
  hp.setHead(hd);
  
  // Create the HTML body Object
  HtmlBody bd = new HtmlBody();
  // Sets various attributes of HtmlBody
  bd.setBackgroundColor("#fffff2");
  bd.setUnfollowedLinkColor("#cc0000");
  bd.setActivatedLinkColor("#ff3300");
  bd.setFollowedLinkColor("#000055");
  hp.setBody(bd);

  // Create a Definition List
  DefinitionList dl = new DefinitionList();
  dl.addDef( new SimpleItem("Term1"),
	     new SimpleItem("Definition1"));
  Container dt2 = new Container();
  dt2.addItem(new SimpleItem("Term2.1"));
  dt2.addItem(new SimpleItem("Term2.2"));
  dl.addDef( dt2, new SimpleItem("Definition2"));

  // Create a Menu List
  MenuList ml = new MenuList();
  ml.addItem(new SimpleItem("Menu1").setBold());
  ml.addItem(new SimpleItem("Menu2").setItal());

  // Create a Directory List
  DirectoryList drl = new DirectoryList();
  drl.addItem(new SimpleItem("Dir1"));
  drl.addItem(new SimpleItem("Dir2"));
  drl.addItem(new SimpleItem("Dir3"));

  // Create an Ordered List
  OrderedList ol = new OrderedList();
  ol.addItem(new SimpleItem("Ordered1"));
  ol.addItem(new SimpleItem("Ordered2"));
  ol.addItem(new SimpleItem("Ordered3"));
  
  // Create an UnOrdered List
  UnOrderedList ul = new UnOrderedList();
  ul.addItem(new SimpleItem("UnOrdered1"));
  ul.addItem(new SimpleItem("UnOrdered2"));
  ul.addItem(new SimpleItem("UnOrdered3"));

  // Put Everything together
  bd.addItem(new banner("List Handling in Oracle.html"));
  bd.addItem(ol).addItem(ul).addItem(drl).addItem(ml).addItem(dl);
  bd.addItem(new trailer("list.java"));

  // Print out header information
  hp.printHeader();
  // Print out content
  hp.print();
}
}

