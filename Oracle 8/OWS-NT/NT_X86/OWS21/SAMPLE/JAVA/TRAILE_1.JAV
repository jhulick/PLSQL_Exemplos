/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
**    NAME
**      banner.java
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
// This trailer class how to create and use reusable components 
// using java package oracle.html.
// This class takes a string as an argument in its main function
// and creates a a simple trailer. 
//
public
class trailer extends CompoundItem {

public trailer (String src_name)  {
  addItem(SimpleItem.Paragraph);
  addItem(SimpleItem.HorizontalRule);
  addItem(SimpleItem.Paragraph);
  addItem(new Link("srcview?filename=" + src_name, 
		   new SimpleItem("Click here to view the java source code")));
  addItem(SimpleItem.LineBreak);
}

}

