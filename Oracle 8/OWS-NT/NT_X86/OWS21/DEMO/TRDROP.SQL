Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      trdrop.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

rem
rem Cleanup
rem

drop procedure panic;
drop package tx;
drop sequence tx_seq;
drop table tx_data;
drop package trip;
drop sequence trip_seq;
drop table trip_data;
drop package customer;
drop sequence cust_seq;
drop table customer_data;
drop package event;
drop sequence event_seq;
drop table event_data;
drop package dimg;
drop table dest_img_data;
drop sequence dimg_seq;
drop package image;
drop table image_data;
drop package destination;
drop sequence dest_seq;
drop table destination_data;
drop package description;
drop sequence desc_seq;
drop table description_data;
drop package message;
drop sequence msg_seq;
drop table message_data;
drop table language_data;
drop package state;
drop sequence state_seq;
drop table state_data;
