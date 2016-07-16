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
// This banner class how to create and use reusable components 
// using java package oracle.html.
// This class takes a string as an argument in its main function
// and creates a a simple banner. 
//
public
class banner extends CompoundItem {

public banner (String Banner)  {
  addItem(SimpleItem.HorizontalRule);
  addItem(SimpleItem.Paragraph);
  addItem(new SimpleItem(Banner).setHeading(2));
  addItem(SimpleItem.Paragraph);
  addItem(SimpleItem.HorizontalRule);
  addItem(SimpleItem.Paragraph);
}

}

