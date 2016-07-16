/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      frame.java
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

//
// This simple demo demonstrates the frame handling capability
// of package oracle.html. 
// 
public
class frame {

  // main: the entry point of this program
public static void main(String args[]) 
  
{
  // Create the head
  HtmlHead hd = new HtmlHead("Frame for Oracle.HTML Package");
  hd.addMetaInfo(new MetaInfo("Expires", "Sunday, 27 June 1996"));

  // Alternat HTML Items to be displayed if frame support is not built-in
  CompoundItem altHtml = new CompoundItem();
  altHtml
    .addItem(SimpleItem.HorizontalRule)
    .addItem(SimpleItem.Paragraph)
    .addItem("This page is designed with FRAME support in mind.")
    .addItem(SimpleItem.LineBreak)
    .addItem("If you do not have access to a browser with FRAME support, you can click ")  
    .addItem(SimpleItem.LineBreak)
    .addItem(new Link("toc", "here"))
    .addItem(new SimpleItem(" to view our TOC page.").setBold())
    .addItem(SimpleItem.Paragraph)
    .addItem(SimpleItem.HorizontalRule);

  // Create the frames
  Frameset frameset = new Frameset();
  frameset.setCols("25%,75%");
  frameset.setAltHtml(altHtml);
  Frame frames[] = new Frame[2];
  frames[0]=new Frame("toc", "toc");
  frames[1]=new Frame("table", "content");
  for (int i=0; i< 2; i++)
    frameset.addFrame(frames[i]);

  // Put the page together and Print it
  HtmlPage hp = new HtmlPage(hd,frameset);
  // Print out content header
  hp.printHeader();
  // Print out Html content
  hp.print();
}

}

