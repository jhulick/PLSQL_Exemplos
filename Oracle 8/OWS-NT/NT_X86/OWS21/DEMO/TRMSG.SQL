rem Copyright (c) 1995, 1996 Oracle Corporation. All rights reserved.
rem 
rem Created
rem 03/20/96    mbookman - Fixed up bugs preventing installation
rem 08/18/95	mlonnrot - Created
rem
rem Translations
rem 	Dutch		Sergio Leunissen
rem 	German		Robert Gasch
rem 	Spanish		Juan Soriano
rem	Swedish		Magnus Lonnroth
rem
rem Modified
rem
rem Description
rem	Create NLS message strings

rem
rem English, Language=1
rem

insert into message_data (id,lang_id,msg) values
(1,1,'Welcome to Oracle Travel');

insert into message_data (id,lang_id,msg) values
(2,1,'Image of a train');

insert into message_data (id,lang_id,msg) values
(3,1,'Enjoy the comfort of travelling by train!');

insert into message_data (id,lang_id,msg) values
(4,1,'Login failed after 3 attempts');

insert into message_data (id,lang_id,msg) values
(5,1,'Security Alert');

insert into message_data (id,lang_id,msg) values
(6,1,'You have unsuccessfully attempted to authenticate yourself 3 times. This ' ||
	'server is now monitoring all traffic from your node (');

insert into message_data (id,lang_id,msg) values
(7,1,') and will use this as evidence in a court of law.');

insert into message_data (id,lang_id,msg) values
(8,1,'You entered an invalid username/password combination.');

insert into message_data (id,lang_id,msg) values
(9,1,'Authentication attempt ');

insert into message_data (id,lang_id,msg) values
(10,1,' Home Page');

insert into message_data (id,lang_id,msg) values
(11,1,'Oracle Travel Home Page');

insert into message_data (id,lang_id,msg) values
(12,1,'Map of the United States');

insert into message_data (id,lang_id,msg) values
(13,1,', welcome to Oracle Travel on the Web. This page provides historical information ' ||
	'about what you have done during previous visits. You may book a new trip by visiting our');

insert into message_data (id,lang_id,msg) values
(14,1,'list of available destinations.');

insert into message_data (id,lang_id,msg) values
(15,1,' Preferences');

insert into message_data (id,lang_id,msg) values
(16,1,'This page allows you to modify information about yourself.');

insert into message_data (id,lang_id,msg) values
(17,1,'Invalid Balance');

insert into message_data (id,lang_id,msg) values
(18,1,'You entered an invalid value in the ');

insert into message_data (id,lang_id,msg) values
(19,1,'balance');

insert into message_data (id,lang_id,msg) values
(20,1,' field.  Please correct and resubmit this form.');

insert into message_data (id,lang_id,msg) values
(21,1,'Your preferences have been updated!');

insert into message_data (id,lang_id,msg) values
(22,1,', let us tell you about some of our wonderful travel destinations!');

insert into message_data (id,lang_id,msg) values
(23,1,'Oracle Travel Destinations');

insert into message_data (id,lang_id,msg) values
(24,1,'Destinations');

insert into message_data (id,lang_id,msg) values
(25,1,'Noname');

insert into message_data (id,lang_id,msg) values
(26,1,'I''m interested in a train ride to ');

insert into message_data (id,lang_id,msg) values
(27,1,' between these dates:');

insert into message_data (id,lang_id,msg) values
(28,1,'Invalid Date Format');

insert into message_data (id,lang_id,msg) values
(29,1,'You entered an invalid date or combination of dates.');

insert into message_data (id,lang_id,msg) values
(30,1,'Taking the Train to ');

insert into message_data (id,lang_id,msg) values
(31,1,', please fill in the form to purchase your tickets.');

insert into message_data (id,lang_id,msg) values
(32,1,'Each ticket costs $');

insert into message_data (id,lang_id,msg) values
(33,1,'Date of Departure:');

insert into message_data (id,lang_id,msg) values
(34,1,'No of tickets ');

insert into message_data (id,lang_id,msg) values
(35,1,'Overbooked');

insert into message_data (id,lang_id,msg) values
(36,1,'Sorry, you have requested more tickets than what we have available.');

insert into message_data (id,lang_id,msg) values
(37,1,'Invalid Input');

insert into message_data (id,lang_id,msg) values
(38,1,'You have entered an invalid ticket quantity.');

insert into message_data (id,lang_id,msg) values
(39,1,'Credit Limit Exceeded');

insert into message_data (id,lang_id,msg) values
(40,1,'You do not have enough money to complete this transaction.');

insert into message_data (id,lang_id,msg) values
(41,1,'Going to ....');

insert into message_data (id,lang_id,msg) values
(42,1,'You have just purchased ');

insert into message_data (id,lang_id,msg) values
(43,1,' tickets to ');

insert into message_data (id,lang_id,msg) values
(44,1,'Passengers');

insert into message_data (id,lang_id,msg) values
(45,1,'User');

insert into message_data (id,lang_id,msg) values
(46,1,'Name');

insert into message_data (id,lang_id,msg) values
(47,1,'Comment');

insert into message_data (id,lang_id,msg) values
(48,1,'none');

insert into message_data (id,lang_id,msg) values
(49,1,'Login');

insert into message_data (id,lang_id,msg) values
(50,1,'Create');

insert into message_data (id,lang_id,msg) values
(51,1,'Filesystem');

insert into message_data (id,lang_id,msg) values
(52,1,'Delete');

insert into message_data (id,lang_id,msg) values
(53,1,'Update');

insert into message_data (id,lang_id,msg) values
(54,1,'Oracle Travel');

insert into message_data (id,lang_id,msg) values
(55,1,'A City View');

insert into message_data (id,lang_id,msg) values
(56,1,'Database');

insert into message_data (id,lang_id,msg) values
(57,1,'<IMG SRC="/tr-img/ehome.gif" ALT="[Home]">');

insert into message_data (id,lang_id,msg) values
(58,1,'<IMG SRC="/tr-img/eprefs.gif" ALT="[Prefs]">');

insert into message_data (id,lang_id,msg) values
(59,1,'<IMG SRC="/tr-img/edestin.gif" ALT="[Destinations]">');

insert into message_data (id,lang_id,msg) values
(60,1,'<IMG SRC="/tr-img/erestart.gif" ALT="[Restart]">');

rem
rem These messages must be aligned!
rem

insert into message_data (id,lang_id,msg) values
(61,1,'     Name ');

insert into message_data (id,lang_id,msg) values
(62,1,'  Address ');

insert into message_data (id,lang_id,msg) values
(63,1,'     City ');

insert into message_data (id,lang_id,msg) values
(64,1,'  Zipcode ');

insert into message_data (id,lang_id,msg) values
(65,1,'    State ');

insert into message_data (id,lang_id,msg) values
(66,1,'  Country ');

insert into message_data (id,lang_id,msg) values
(67,1,'    Email ');

insert into message_data (id,lang_id,msg) values
(68,1,'Balance $ ');

insert into message_data (id,lang_id,msg) values
(69,1,' Language ');

insert into message_data (id,lang_id,msg) values
(70,1,'   Images ');

rem
rem End of Aligned fields
rem

insert into message_data (id,lang_id,msg) values
(71,1,'Comments about yourself');

rem
rem These messages must be aligned
rem

insert into message_data (id,lang_id,msg) values
(72,1,'    User: ');

insert into message_data (id,lang_id,msg) values
(73,1,'Password: ');

insert into message_data (id,lang_id,msg) values
(74,1,'  Action: ');

rem
rem End of aligned messages
rem

insert into message_data (id,lang_id,msg) values
(75,1,'error.gif');

insert into message_data (id,lang_id,msg) values
(76,1,'Lost control in module ');

insert into message_data (id,lang_id,msg) values
(77,1,'. Processing halted.');

insert into message_data (id,lang_id,msg) values
(78,1,'Restart Demo');

insert into message_data (id,lang_id,msg) values
(79,1,'success.gif');

insert into message_data (id,lang_id,msg) values
(80,1,'Unhandled Exception in tru.title_gif');

insert into message_data (id,lang_id,msg) values
(81,1,'save_state (called from ');

insert into message_data (id,lang_id,msg) values
(82,1,'You have visited this page on the following occasions');

insert into message_data (id,lang_id,msg) values
(83,1,'Timestamp');

insert into message_data (id,lang_id,msg) values
(84,1,'Client');

insert into message_data (id,lang_id,msg) values
(85,1,'Client Software');

insert into message_data (id,lang_id,msg) values
(86,1,'Server');

insert into message_data (id,lang_id,msg) values
(87,1,'Server Software');

insert into message_data (id,lang_id,msg) values
(88,1,'This is the first time you have visited this dynamic page.');

insert into message_data (id,lang_id,msg) values
(89,1,'You have visited this dynamic page ');

insert into message_data (id,lang_id,msg) values
(90,1,' times. The contents may be significantly different each time.');

insert into message_data (id,lang_id,msg) values
(91,1,' seconds');

insert into message_data (id,lang_id,msg) values
(92,1,' minutes');

insert into message_data (id,lang_id,msg) values
(93,1,' hours');

insert into message_data (id,lang_id,msg) values
(94,1,' days');

insert into message_data (id,lang_id,msg) values
(95,1,'You were here on ');

insert into message_data (id,lang_id,msg) values
(96,1,', exactly ');

insert into message_data (id,lang_id,msg) values
(97,1,' ago.');

insert into message_data (id,lang_id,msg) values
(98,1,'tr.tx_save (called from ');

insert into message_data (id,lang_id,msg) values
(99,1,'Invalid TX code: ');

insert into message_data (id,lang_id,msg) values
(100,1,'t_splash.gif');

insert into message_data (id,lang_id,msg) values
(101,1,'t_security.gif');

insert into message_data (id,lang_id,msg) values
(102,1,'t_home.gif');

insert into message_data (id,lang_id,msg) values
(103,1,'t_dests.gif');

insert into message_data (id,lang_id,msg) values
(104,1,'t_ticket.gif');

insert into message_data (id,lang_id,msg) values
(105,1,'Non smoker, aisle seat');

insert into message_data (id,lang_id,msg) values
(106,1,'Non smoker, window seat');

insert into message_data (id,lang_id,msg) values
(107,1,'Smoker, aisle seat');

insert into message_data (id,lang_id,msg) values
(108,1,'Smoker, window seat');

insert into message_data (id,lang_id,msg) values
(109,1,' tickets have been purchased for the departure on');

insert into message_data (id,lang_id,msg) values
(110,1,'There are ');

insert into message_data (id,lang_id,msg) values
(111,1,' seats left on this train distributed as follows: ');

insert into message_data (id,lang_id,msg) values
(112,1,' non smoker aisle seats');

insert into message_data (id,lang_id,msg) values
(113,1,' non smoker window seats');

insert into message_data (id,lang_id,msg) values
(114,1,' smoker aisle seats');

insert into message_data (id,lang_id,msg) values
(115,1,' smoker window seats');

insert into message_data (id,lang_id,msg) values
(116,1,'t_purchase.gif');

insert into message_data (id,lang_id,msg) values
(117,1,'t_passengers.gif');

insert into message_data (id,lang_id,msg) values
(118,1,'t_prefs.gif');

insert into message_data (id,lang_id,msg) values
(119,1,'Page History');

insert into message_data (id,lang_id,msg) values
(120,1,' Yes');

insert into message_data (id,lang_id,msg) values
(121,1,' No');

insert into message_data (id,lang_id,msg) values
(122,1,'You have visited this page on the following occasions');

insert into message_data (id,lang_id,msg) values
(123,1,'That username already exists. Please choose something else!');

insert into message_data (id,lang_id,msg) values
(124,1,'Tickets Purchased');

insert into message_data (id,lang_id,msg) values
(125,1,'Status');

insert into message_data (id,lang_id,msg) values
(126,1,'Destination');

insert into message_data (id,lang_id,msg) values
(127,1,'Departure Date');

insert into message_data (id,lang_id,msg) values
(128,1,'Return Date');

insert into message_data (id,lang_id,msg) values
(129,1,'No of Seats');

insert into message_data (id,lang_id,msg) values
(130,1,'Total Price');

insert into message_data (id,lang_id,msg) values
(131,1,'Purchase Date');

insert into message_data (id,lang_id,msg) values
(132,1,'In Progress');

insert into message_data (id,lang_id,msg) values
(133,1,'Been There');

insert into message_data (id,lang_id,msg) values
(134,1,' days left');

insert into message_data (id,lang_id,msg) values
(135,1,'. However, this is the list price. We are pleased to offer you the following discount prices:');

insert into message_data (id,lang_id,msg) values
(136,1,'Price');

insert into message_data (id,lang_id,msg) values
(137,1,'Your current balance is $');

insert into message_data (id,lang_id,msg) values
(138,1,', your new balance is $');

Commit;

rem
rem Swedish, Language=2
rem

insert into message_data (id,lang_id,msg) values
(1,2,'V&auml;lkommen till Oracle Travel');

insert into message_data (id,lang_id,msg) values
(2,2,'En bild av ett t&aring;g');

insert into message_data (id,lang_id,msg) values
(3,2,'Njut av en behaglig t&aring;gresa!!');

insert into message_data (id,lang_id,msg) values
(4,2,'P&aring;loggning misslyckades efter 3 f&ouml;rs&ouml;k.');

insert into message_data (id,lang_id,msg) values
(5,2,'S&auml;kerhetsvarning!');

insert into message_data (id,lang_id,msg) values
(6,2,'Du har inte lyckats logga p&aring; efter 3 f&ouml;rs&ouml;k. ' ||
	'Fr&aring;not och med nu kommer all n&auml;tverkstrafik fr&aring;n din maskin (');

insert into message_data (id,lang_id,msg) values
(7,2,') att &ouml;vervakas och kan leda till &aring;tal.');

insert into message_data (id,lang_id,msg) values
(8,2,'Du angav ett ogiltigt anv&auml;ndarnamn eller l&ouml;senord.');

insert into message_data (id,lang_id,msg) values
(9,2,'P&aring;loggningsf&ouml;rs&ouml;k nr ');

insert into message_data (id,lang_id,msg) values
(10,2,' Hemsida');

insert into message_data (id,lang_id,msg) values
(11,2,'Oracle Travel Hemsida');

insert into message_data (id,lang_id,msg) values
(12,2,'Karta &ouml;ver F&ouml;renta Staterna');

insert into message_data (id,lang_id,msg) values
(13,2,', v&auml;lkommen till Oracle Travel p&aring; WWW. Den h&auml;r sidan ger dig en historisk ' ||
	'&ouml;versikt &ouml;ver dina t&aring;gresor. Du kan boka nya resor genom att granska v&aring;r');

insert into message_data (id,lang_id,msg) values
(14,2,'lista &ouml;ver aktuella resm&aring;l.');

insert into message_data (id,lang_id,msg) values
(15,2,' Inst&auml;llningar');

insert into message_data (id,lang_id,msg) values
(16,2,'Den h&auml;r sidan l&aring;ter dig &auml;ndra information om dig sj&auml;lv.');

insert into message_data (id,lang_id,msg) values
(17,2,'Ogiltig Kredit');

insert into message_data (id,lang_id,msg) values
(18,2,'Du angav ett ogiltigt v&auml;rde i ');

insert into message_data (id,lang_id,msg) values
(19,2,'kredit');

insert into message_data (id,lang_id,msg) values
(20,2,'f&auml;ltet, v.g. r&auml;tta och f&ouml;rs&ouml;k igen.');

insert into message_data (id,lang_id,msg) values
(21,2,'Inst&auml;llningarna har sparats.');

insert into message_data (id,lang_id,msg) values
(22,2,', l&aring;t oss ber&auml;tta om v&aring;ra underbara resm&aring;l!');

insert into message_data (id,lang_id,msg) values
(23,2,'Oracle Travel Resm&aring;l');

insert into message_data (id,lang_id,msg) values
(24,2,'Resm&aring;l');

insert into message_data (id,lang_id,msg) values
(25,2,'Namnl&ouml;s');

insert into message_data (id,lang_id,msg) values
(26,2,'Jag &auml;r intresserad av att resa med t&aring;g till ');

insert into message_data (id,lang_id,msg) values
(27,2,' inom det h&auml;r datum intervallet:');

insert into message_data (id,lang_id,msg) values
(28,2,'Ogilitgt datum format.');

insert into message_data (id,lang_id,msg) values
(29,2,'Du angav ett ogiltigt datum eller ogiltig datum kombination.');

insert into message_data (id,lang_id,msg) values
(30,2,'Resa med t&aring;g till ');

insert into message_data (id,lang_id,msg) values
(31,2,', v&auml;lj resdatum och billjettantal.');

insert into message_data (id,lang_id,msg) values
(32,2,'Varje biljett kostar Kr ');

insert into message_data (id,lang_id,msg) values
(33,2,'Resdatum:');

insert into message_data (id,lang_id,msg) values
(34,2,'Antal biljetter ');

insert into message_data (id,lang_id,msg) values
(35,2,'Fullbokat');

insert into message_data (id,lang_id,msg) values
(36,2,'Vi &auml;r mycket ledsna, men du har f&ouml;rs&ouml;kt k&ouml;pa fler biljetter ' ||
	'&auml;n vad som finns tillg&auml;ngligt f&ouml;r den h&auml;r resan.');

insert into message_data (id,lang_id,msg) values
(37,2,'Ogiltigt v&auml;rde.');

insert into message_data (id,lang_id,msg) values
(38,2,'Du har angivit ett ogiltigt biljettantal.');

insert into message_data (id,lang_id,msg) values
(39,2,'Du har &ouml;vertrasserat din kredit.');

insert into message_data (id,lang_id,msg) values
(40,2,'Du har inte tillr&auml;ckligt med pengar f&ouml;r att k&ouml;pa s&aring; m&aring;nga biljetter.');

insert into message_data (id,lang_id,msg) values
(41,2,'P&aring; v&auml;g till ....');

insert into message_data (id,lang_id,msg) values
(42,2,'Du har just k&ouml;pt ');

insert into message_data (id,lang_id,msg) values
(43,2,' biljetter till ');

insert into message_data (id,lang_id,msg) values
(44,2,'Resen&auml;rer');

insert into message_data (id,lang_id,msg) values
(45,2,'Anv&auml;ndarnamn');

insert into message_data (id,lang_id,msg) values
(46,2,'Namn');

insert into message_data (id,lang_id,msg) values
(47,2,'Beskrivning');

insert into message_data (id,lang_id,msg) values
(48,2,'saknas');

insert into message_data (id,lang_id,msg) values
(49,2,'Logga p&aring;');

insert into message_data (id,lang_id,msg) values
(50,2,'Skapa Ny');

insert into message_data (id,lang_id,msg) values
(51,2,'Filsystemet');

insert into message_data (id,lang_id,msg) values
(52,2,'Radera Mig');

insert into message_data (id,lang_id,msg) values
(53,2,'Spara');

insert into message_data (id,lang_id,msg) values
(54,2,'Oracle Travel');

insert into message_data (id,lang_id,msg) values
(55,2,'Utsikt &ouml;ver staden');

insert into message_data (id,lang_id,msg) values
(56,2,'Databasen');

insert into message_data (id,lang_id,msg) values
(57,2,'<IMG SRC="/tr-img/shem.gif" ALT="[Hem]">');

insert into message_data (id,lang_id,msg) values
(58,2,'<IMG SRC="/tr-img/sinstall.gif" ALT="[Inst&auml;llningar]">');

insert into message_data (id,lang_id,msg) values
(59,2,'<IMG SRC="/tr-img/sresmal.gif" ALT="[Resm&aring;l]">');

insert into message_data (id,lang_id,msg) values
(60,2,'<IMG SRC="/tr-img/sstrtaom.gif" ALT="[Starta Om]">');

rem
rem These messages must be aligned!
rem

insert into message_data (id,lang_id,msg) values
(61,2,'     Namn ');

insert into message_data (id,lang_id,msg) values
(62,2,'   Adress ');

insert into message_data (id,lang_id,msg) values
(63,2,'     Stad ');

insert into message_data (id,lang_id,msg) values
(64,2,'   Postnr ');

insert into message_data (id,lang_id,msg) values
(65,2,'     Stat ');

insert into message_data (id,lang_id,msg) values
(66,2,'     Land ');

insert into message_data (id,lang_id,msg) values
(67,2,'    Email ');

insert into message_data (id,lang_id,msg) values
(68,2,'Kredit Kr ');

insert into message_data (id,lang_id,msg) values
(69,2,'    Spr&aring;k ');

insert into message_data (id,lang_id,msg) values
(70,2,'   Bilder ');

rem
rem End of Aligned fields
rem

insert into message_data (id,lang_id,msg) values
(71,2,'Beskrivning av dig sj&auml;lv');

rem
rem These messages must be aligned
rem

insert into message_data (id,lang_id,msg) values
(72,2,' Anv&auml;ndare: ');

insert into message_data (id,lang_id,msg) values
(73,2,'  L&ouml;senord: ');

insert into message_data (id,lang_id,msg) values
(74,2,'G&ouml;r det h&auml;r ');

rem
rem End of aligned messages
rem
insert into message_data (id,lang_id,msg) values
(75,2,'error.se.gif');

insert into message_data (id,lang_id,msg) values
(76,2,'Tappade kontrollen i ');

insert into message_data (id,lang_id,msg) values
(77,2,'. Bearbetning avslutad.');

insert into message_data (id,lang_id,msg) values
(78,2,'Start Om');

insert into message_data (id,lang_id,msg) values
(79,2,'success.se.gif');

insert into message_data (id,lang_id,msg) values
(80,2,'Ett ov&auml;ntat fel intr&auml;ffade i modulen tru.title_gif');

insert into message_data (id,lang_id,msg) values
(81,2,'save_state (anropades fr&aring; ');

insert into message_data (id,lang_id,msg) values
(82,2,'Bes&ouml;kstillf&auml;llen f&ouml;r den h&auml;r sidan');

insert into message_data (id,lang_id,msg) values
(83,2,'Datum');

insert into message_data (id,lang_id,msg) values
(84,2,'Klient');

insert into message_data (id,lang_id,msg) values
(85,2,'Klient Program');

insert into message_data (id,lang_id,msg) values
(86,2,'Server');

insert into message_data (id,lang_id,msg) values
(87,2,'Server Program');

insert into message_data (id,lang_id,msg) values
(88,2,'Det h&auml;r &auml;r f&ouml;rsta g&aring;ngen du bes&ouml;ker den h&auml;r dynamiska sidan.');

insert into message_data (id,lang_id,msg) values
(89,2,'Du har bes&ouml;kt den h&auml;r dynamiska sidan ');

insert into message_data (id,lang_id,msg) values
(90,2,' g&aring;nger. Inneh&aring;llet kan variera varje g&aring;ng.');

insert into message_data (id,lang_id,msg) values
(91,2,' sekunder');

insert into message_data (id,lang_id,msg) values
(92,2,' minuter');

insert into message_data (id,lang_id,msg) values
(93,2,' timmar');

insert into message_data (id,lang_id,msg) values
(94,2,' dagar');

insert into message_data (id,lang_id,msg) values
(95,2,'Du var h&auml;r ');

insert into message_data (id,lang_id,msg) values
(96,2,', vilket &auml;r exakt ');

insert into message_data (id,lang_id,msg) values
(97,2,' sedan.');

insert into message_data (id,lang_id,msg) values
(98,2,'tr.tx_save (anropades av ');

insert into message_data (id,lang_id,msg) values
(99,2,'Ogiltig TX kod: ');

insert into message_data (id,lang_id,msg) values
(100,2,'t_splash.se.gif');

insert into message_data (id,lang_id,msg) values
(101,2,'t_security.se.gif');

insert into message_data (id,lang_id,msg) values
(102,2,'t_home.se.gif');

insert into message_data (id,lang_id,msg) values
(103,2,'t_dests.se.gif');

insert into message_data (id,lang_id,msg) values
(104,2,'t_ticket.se.gif');

insert into message_data (id,lang_id,msg) values
(105,2,'Icke r&ouml;kare, g&aring;ngplats');

insert into message_data (id,lang_id,msg) values
(106,2,'Icke r&ouml;kare, f&ouml;nsterplats');

insert into message_data (id,lang_id,msg) values
(107,2,'R&ouml;kare, g&aring;ngplats');

insert into message_data (id,lang_id,msg) values
(108,2,'R&ouml;kare, f&ouml;nsterplats');

insert into message_data (id,lang_id,msg) values
(109,2,' biljetter har bokats f&ouml;r avg&aring;ng den');

insert into message_data (id,lang_id,msg) values
(110,2,'Det finns ');

insert into message_data (id,lang_id,msg) values
(111,2,' platser kvar p&aring; det h&auml;r t&aring;get f&ouml;rdelade enligt f&ouml;ljande: ');

insert into message_data (id,lang_id,msg) values
(112,2,' icke r&ouml;kare g&aring;ngplats');

insert into message_data (id,lang_id,msg) values
(113,2,' icke r&ouml;kare f&ouml;nsterplats');

insert into message_data (id,lang_id,msg) values
(114,2,' r&ouml;kare g&aring;ngplats');

insert into message_data (id,lang_id,msg) values
(115,2,' r&ouml;kare, f&ouml;nsterplats');

insert into message_data (id,lang_id,msg) values
(116,2,'t_purchase.se.gif');

insert into message_data (id,lang_id,msg) values
(117,2,'t_passengers.se.gif');

insert into message_data (id,lang_id,msg) values
(118,2,'t_prefs.se.gif');

insert into message_data (id,lang_id,msg) values
(119,2,'Transaktionshistorik');

insert into message_data (id,lang_id,msg) values
(120,2,' Visa');

insert into message_data (id,lang_id,msg) values
(121,2,' Visa Inte');

insert into message_data (id,lang_id,msg) values
(122,2,'Tidigare Bes&ouml;kstillf&auml;llen');

insert into message_data (id,lang_id,msg) values
(123,2,'Det anv&auml;ndarnamnet &auml;r upptaget. V&auml;lj ett annat!');

insert into message_data (id,lang_id,msg) values
(124,2,'Biljetter');

insert into message_data (id,lang_id,msg) values
(125,2,'Status');

insert into message_data (id,lang_id,msg) values
(126,2,'Resm&aring;l');

insert into message_data (id,lang_id,msg) values
(127,2,'Avresa');

insert into message_data (id,lang_id,msg) values
(128,2,'Hemkomst');

insert into message_data (id,lang_id,msg) values
(129,2,'Antal Sittplatser');

insert into message_data (id,lang_id,msg) values
(130,2,'Summa');

insert into message_data (id,lang_id,msg) values
(131,2,'F&ouml;rs&auml;ljningsdatum');

insert into message_data (id,lang_id,msg) values
(132,2,'P&aring;g&aring;r nu');

insert into message_data (id,lang_id,msg) values
(133,2,'Har varit d&auml;r');

insert into message_data (id,lang_id,msg) values
(134,2,' dagar kvar');

insert into message_data (id,lang_id,msg) values
(135,2,'. Detta &auml;r listpriset. Vi har n&ouml;jet att kunna erbjuda dig f&ouml;ljande kampanjpriser:');

insert into message_data (id,lang_id,msg) values
(136,2,'Pris');

insert into message_data (id,lang_id,msg) values
(137,2,'Ditt nya kreditbelopp &auml;r ');

insert into message_data (id,lang_id,msg) values
(138,2,', ditt kreditbelopp &auml;r nu ');

Commit;
rem
rem Spanish, Language=3
rem

insert into message_data (id,lang_id,msg) values
(1,3,'Bienvenido a Oracle Travel');

insert into message_data (id,lang_id,msg) values
(2,3,'Imagen de un tren');

insert into message_data (id,lang_id,msg) values
(3,3,'&#161;Disfrute la comodidad de viajar en tren!');

insert into message_data (id,lang_id,msg) values
(4,3,'Conexi&oacute;n fallida despu&eacute;s de 3 intentos');

insert into message_data (id,lang_id,msg) values
(5,3,'Alerta de Seguridad');

insert into message_data (id,lang_id,msg) values
(6,3,'Ha tratado infructuosamente de autorizarce a si mismo 3 veces.  Este ' ||
        'servidor est&aacute; ahora observando toda la actividad desde su nodo (');

insert into message_data (id,lang_id,msg) values
(7,3,') y usara &eacute;sto como prueba en una corte.');
 
insert into message_data (id,lang_id,msg) values
(8,3,'Ha pulsado una combinaci&oacute;n inv&aacute;lida de usuario/contrase&ntilde;a.');

insert into message_data (id,lang_id,msg) values
(9,3,'Intento de autorizaci&oacute;n ');

insert into message_data (id,lang_id,msg) values
(10,3,' P&aacute;gina Base');

insert into message_data (id,lang_id,msg) values
(11,3,'P&aacute;gina Base de Oracle Travel');

insert into message_data (id,lang_id,msg) values
(12,3,'Mapa de Estados Unidos');

insert into message_data (id,lang_id,msg) values
(13,3,', bienvenido a Oracle Travel en la Red. Esta p&aacute;gina presenta informaci&oacute;n hist&oacute;rica ' ||
        'acerca de lo que usted ha hecho durante sus visitas previas.  Usted puede reservar un nuevo viaje al visitar nuestra');

insert into message_data (id,lang_id,msg) values
(14,3,'lista de destinos disponibles.');

insert into message_data (id,lang_id,msg) values
(15,3,' Preferencias');

insert into message_data (id,lang_id,msg) values
(16,3,'Esta p&aacute;gina le permite modificar informaci&oacute;n personal.');

insert into message_data (id,lang_id,msg) values
(17,3,'Balance incorrecto');

insert into message_data (id,lang_id,msg) values
(18,3,'Ha pulsado un valor incorrecto en el ');

insert into message_data (id,lang_id,msg) values
(19,3,'balance');

insert into message_data (id,lang_id,msg) values
(20,3,' campo, por favor corrija y presente nuevamente esta forma.');

insert into message_data (id,lang_id,msg) values
(21,3,'&#161;Sus preferencias han sido modificadas!');

insert into message_data (id,lang_id,msg) values
(22,3,', &#161;perm&iacute;tanos informarle acerca de nuestros maravillosos destinos para viajar!');

insert into message_data (id,lang_id,msg) values
(23,3,'Destinos de Oracle Travel');

insert into message_data (id,lang_id,msg) values
(24,3,'Destinos');

insert into message_data (id,lang_id,msg) values
(25,3,'Sin nombre');

insert into message_data (id,lang_id,msg) values
(26,3,'Estoy interesado en un viaje por tren a ');

insert into message_data (id,lang_id,msg) values
(27,3,' entre estas fechas:');

insert into message_data (id,lang_id,msg) values
(28,3,'Formato de Fecha Incorrecto');

insert into message_data (id,lang_id,msg) values
(29,3,'Ha pulsado una fecha o una combinaci&oacute;n de fechas incorrectas.');

insert into message_data (id,lang_id,msg) values
(30,3,'Tomando el Tren hacia ');

insert into message_data (id,lang_id,msg) values
(31,3,', por favor llene la forma para comprar sus boletos.');

insert into message_data (id,lang_id,msg) values
(32,3,'Cada boleto cuesta $');

insert into message_data (id,lang_id,msg) values
(33,3,'Fecha de Salida:');

insert into message_data (id,lang_id,msg) values
(34,3,'N&uacute;mero de boletos ');

insert into message_data (id,lang_id,msg) values
(35,3,'Reservado en exeso');

insert into message_data (id,lang_id,msg) values
(36,3,'Disculpe, usted ha solicitado m&aacute;s boletos de los que tenemos disponibles.');

insert into message_data (id,lang_id,msg) values
(37,3,'La informaci&oacute;n pulsada es incorrecta');

insert into message_data (id,lang_id,msg) values
(38,3,'Ha pulsado una cantidad incorrecta de boletos.');

insert into message_data (id,lang_id,msg) values
(39,3,'Su l&iacute;mite de cr&eacute;dito se ha sobrepasado');

insert into message_data (id,lang_id,msg) values
(40,3,'Usted no tiene fondos suficientes para completar esta transacci&oacute;n.');

insert into message_data (id,lang_id,msg) values
(41,3,'Con destino a ....');

insert into message_data (id,lang_id,msg) values
(42,3,'Usted ha comprado ');

insert into message_data (id,lang_id,msg) values
(43,3,' boletos a ');

insert into message_data (id,lang_id,msg) values
(44,3,'Pasajeros');

insert into message_data (id,lang_id,msg) values
(45,3,'Usuario');

insert into message_data (id,lang_id,msg) values
(46,3,'Nombre');

insert into message_data (id,lang_id,msg) values
(47,3,'Comentario');

insert into message_data (id,lang_id,msg) values
(48,3,'ningun');

insert into message_data (id,lang_id,msg) values
(49,3,'Login');

insert into message_data (id,lang_id,msg) values
(50,3,'Crear');

insert into message_data (id,lang_id,msg) values
(51,3,'Filesystem');

insert into message_data (id,lang_id,msg) values
(52,3,'Borrar');

insert into message_data (id,lang_id,msg) values
(53,3,'Modificar');

insert into message_data (id,lang_id,msg) values
(54,3,'Oracle Travel');

insert into message_data (id,lang_id,msg) values
(55,3,'Vista de la Ciudad');

insert into message_data (id,lang_id,msg) values
(56,3,'Base de Datos');

insert into message_data (id,lang_id,msg) values
(57,3,'<IMG SRC="/tr-img/esbase.gif" ALT="[Base]">');

insert into message_data (id,lang_id,msg) values
(58,3,'<IMG SRC="/tr-imgesprefs.gif" ALT="[Prefs]">');

insert into message_data (id,lang_id,msg) values
(59,3,'<IMG SRC="/tr-imgesdestin.gif" ALT="[Destinos]">');

insert into message_data (id,lang_id,msg) values
(60,3,'<IMG SRC="/tr-imgesempezr.gif" ALT="[Empezar]">');

rem
rem These messages must be aligned!
rem

insert into message_data (id,lang_id,msg) values
(61,3,'       Nombre ');

insert into message_data (id,lang_id,msg) values
(62,3,'    Direcci&oacute;n ');

insert into message_data (id,lang_id,msg) values
(63,3,'       Ciudad ');

insert into message_data (id,lang_id,msg) values
(64,3,'C&oacute;digo Postal ');

insert into message_data (id,lang_id,msg) values
(65,3,'       Estado ');

insert into message_data (id,lang_id,msg) values
(66,3,'         Pa&iacute;s ');

insert into message_data (id,lang_id,msg) values
(67,3,'        Email ');

insert into message_data (id,lang_id,msg) values
(68,3,'    Balance $ ');

insert into message_data (id,lang_id,msg) values
(69,3,'     Lenguaje ');

insert into message_data (id,lang_id,msg) values
(70,3,'     Im&aacute;genes ');

rem
rem End of Aligned fields
rem

insert into message_data (id,lang_id,msg) values
(71,3,'Comentarios acerca de Usted');

rem
rem These messages must be aligned
rem

insert into message_data (id,lang_id,msg) values
(72,3,'   Usuario: ');

insert into message_data (id,lang_id,msg) values
(73,3,'Contrase&ntilde;a: ');

insert into message_data (id,lang_id,msg) values
(74,3,'    Acci&oacute;n: ');

rem
rem End of aligned messages
rem

insert into message_data (id,lang_id,msg) values
(75,3,'error.es.gif');

insert into message_data (id,lang_id,msg) values
(76,3,'P&eacute;rdida de control en el m&oacute;dulo ');

insert into message_data (id,lang_id,msg) values
(77,3,'. Proceso interrumpido.');

insert into message_data (id,lang_id,msg) values
(78,3,'Empezar Demo');

insert into message_data (id,lang_id,msg) values
(79,3,'success.es.gif');

insert into message_data (id,lang_id,msg) values
(80,3,'Condici&oacute;n no controlada en tru.title_gif');

insert into message_data (id,lang_id,msg) values
(81,3,'save_state (called from ');

insert into message_data (id,lang_id,msg) values
(82,3,'Usted ha visitado esta p&aacute;gina en las siguientes ocasiones');

insert into message_data (id,lang_id,msg) values
(83,3,'Timestamp');

insert into message_data (id,lang_id,msg) values
(84,3,'Cliente');

insert into message_data (id,lang_id,msg) values
(85,3,'Software Cliente');

insert into message_data (id,lang_id,msg) values
(86,3,'Servidor');

insert into message_data (id,lang_id,msg) values
(87,3,'Server Software');

insert into message_data (id,lang_id,msg) values
(88,3,'Esta es la primera vez que usted visita esta p&aacute;gina din&aacute;mica.');

insert into message_data (id,lang_id,msg) values
(89,3,'Usted ha visitado esta p&aacute;gina din&aacute;mica ');

insert into message_data (id,lang_id,msg) values
(90,3,' veces. El contenido puede ser considerablemente diferente cada vez.');

insert into message_data (id,lang_id,msg) values
(91,3,' segundos');

insert into message_data (id,lang_id,msg) values
(92,3,' minutos');

insert into message_data (id,lang_id,msg) values
(93,3,' horas');

insert into message_data (id,lang_id,msg) values
(94,3,' dias');

insert into message_data (id,lang_id,msg) values
(95,3,'Usted estuvo aqu&iacute; el ');

insert into message_data (id,lang_id,msg) values
(96,3,', hace exactamente ');

insert into message_data (id,lang_id,msg) values
(97,3,'.');

insert into message_data (id,lang_id,msg) values
(98,3,'tr.tx_save (called from ');

insert into message_data (id,lang_id,msg) values
(99,3,'Invalid TX code: ');

insert into message_data (id,lang_id,msg) values
(100,3,'t_splash.es.gif');

insert into message_data (id,lang_id,msg) values
(101,3,'t_security.es.gif');

insert into message_data (id,lang_id,msg) values
(102,3,'t_home.es.gif');

insert into message_data (id,lang_id,msg) values
(103,3,'t_dests.es.gif');

insert into message_data (id,lang_id,msg) values
(104,3,'t_ticket.es.gif');

insert into message_data (id,lang_id,msg) values
(105,3,'Asiento en pasillo, No Fumador');

insert into message_data (id,lang_id,msg) values
(106,3,'Asiento en ventanilla, No Fumador');

insert into message_data (id,lang_id,msg) values
(107,3,'Asiento en pasillo, Fumador');

insert into message_data (id,lang_id,msg) values
(108,3,'Asiento en ventanilla, Fumador');

insert into message_data (id,lang_id,msg) values
(109,3,' los boletos han sido comprados para la salir el');

insert into message_data (id,lang_id,msg) values
(110,3,'Hay ');

insert into message_data (id,lang_id,msg) values
(111,3,' asientos disponibles en este tren, distribuidos como sigue: ');

insert into message_data (id,lang_id,msg) values
(112,3,' asientos en pasillo no fumador');

insert into message_data (id,lang_id,msg) values
(113,3,' asientos en ventanilla no fumador');

insert into message_data (id,lang_id,msg) values
(114,3,' asientos en pasillo fumador');

insert into message_data (id,lang_id,msg) values
(115,3,' asientos en ventanilla fumador');

insert into message_data (id,lang_id,msg) values
(116,3,'t_purchase.es.gif');

insert into message_data (id,lang_id,msg) values
(117,3,'t_passengers.es.gif');

insert into message_data (id,lang_id,msg) values
(118,3,'t_prefs.es.gif');

insert into message_data (id,lang_id,msg) values
(119,3,'Historia de P&aacute;ginas');

insert into message_data (id,lang_id,msg) values
(120,3,' Si');

insert into message_data (id,lang_id,msg) values
(121,3,' No');

insert into message_data (id,lang_id,msg) values
(122,3,'Usted ha visitado esta p&aacute;gina en las siguientes ocasiones');

insert into message_data (id,lang_id,msg) values
(123,3,'Ese nombre de usuario ya est&aacute; definido. &#161;Por favor seleccione otro!');

insert into message_data (id,lang_id,msg) values
(124,3,'Boletos Comprados');

insert into message_data (id,lang_id,msg) values
(125,3,'Estatus');

insert into message_data (id,lang_id,msg) values
(126,3,'Destino');

insert into message_data (id,lang_id,msg) values
(127,3,'Fecha de Salida');

insert into message_data (id,lang_id,msg) values
(128,3,'Fecha de Regreso');

insert into message_data (id,lang_id,msg) values
(129,3,'N&uacute;mero de Asientos');

insert into message_data (id,lang_id,msg) values
(130,3,'Precio Total');

insert into message_data (id,lang_id,msg) values
(131,3,'Fecha de Compra');

insert into message_data (id,lang_id,msg) values
(132,3,'En Proceso');

insert into message_data (id,lang_id,msg) values
(133,3,'Estado Ah&iacute;');

insert into message_data (id,lang_id,msg) values
(134,3,' dias por transcurrir');

insert into message_data (id,lang_id,msg) values
(135,3,'. Sin embargo, este es el precio de lista. Nos complace ofrecerle los siguientes descuentos en nuestros precios:');

insert into message_data (id,lang_id,msg) values
(136,3,'Precio');

insert into message_data (id,lang_id,msg) values
(137,3,'Su balance actual es $');

insert into message_data (id,lang_id,msg) values
(138,3,', su nuevo balance es $');

commit;

rem
rem Deutch, Language=4
rem

insert into message_data (id,lang_id,msg) values
(1,4,'Willkommen zu Oracle Travel');

insert into message_data (id,lang_id,msg) values
(2,4,'Bild eines Zugs');

insert into message_data (id,lang_id,msg) values
(3,4,'Genie&szlig;en sie den Komfort einer Zugreise!');

insert into message_data (id,lang_id,msg) values
(4,4,'Login nach 3 Versuchen erfolgslos');

insert into message_data (id,lang_id,msg) values
(5,4,'Sicherheits Alert');

insert into message_data (id,lang_id,msg) values
(6,4,'Sie haben 3 Mal erfolgslos versucht sich zu identifizieren. Dieser ' || 
'server &uuml;berwacht jetzt jeden Kontakt mit ihrer Node (');

insert into message_data (id,lang_id,msg) values
(7,4,') und wird dies als Beweismaterial im Gericht verwenden.');

insert into message_data (id,lang_id,msg) values
(8,4,'Sie haven eine ung&uuml;ltige gebraucher/password kombination eingegeben.');

insert into message_data (id,lang_id,msg) values
(9,4,'Identifikationsversuch');

insert into message_data (id,lang_id,msg) values
(10,4,' Home Page');

insert into message_data (id,lang_id,msg) values
(11,4,'Oracle Reisen Home Page');

insert into message_data (id,lang_id,msg) values
(12,4,'Karte der Vereinigten Staaten');

insert into message_data (id,lang_id,msg) values
(13,4,', Willkommen im Oracle Reisen auf dem Web. Diese Seite gibt ihnen historische informationen ' ||
        'dar&uuml;ber was sie auf vorherigen Besuchen getan haben. Sie k&ouml;nnen eine neue Reise buchen in dem sie ');

insert into message_data (id,lang_id,msg) values
(14,4,'unsere Liste von verf&uuml;gbaren Zielen besuchen.');

insert into message_data (id,lang_id,msg) values
(15,4,' Einstellungen');

insert into message_data (id,lang_id,msg) values
(16,4,'Diese Seite l&auml;&szlig;t sie informationen &uuml;ber sich selbt ver&auml;ndern.');

insert into message_data (id,lang_id,msg) values
(17,4,'Ung&uuml;ltiges Saldo');

insert into message_data (id,lang_id,msg) values
(18,4,'Sie haben einen ung&uuml;ltigen Wert in das Feld');

insert into message_data (id,lang_id,msg) values
(19,4,'Saldo eingegeben');

insert into message_data (id,lang_id,msg) values
(20,4,' Bitte korrigieren sie ihre Eingabe.');

insert into message_data (id,lang_id,msg) values
(21,4,'Ihre Einstellungen sind erneuerd!');

insert into message_data (id,lang_id,msg) values
(22,4,', Lassen sie uns &uuml;ber einige unserer wunderbaren Reiseziele informieren!');

insert into message_data (id,lang_id,msg) values
(23,4,'Oracle Reise Reiseziele ');

insert into message_data (id,lang_id,msg) values
(24,4,'Reiseziele');

insert into message_data (id,lang_id,msg) values
(25,4,'Kein name');

insert into message_data (id,lang_id,msg) values
(26,4,'Ich interessiere mich f&uuml;r eine Zugfahrt nach ');

insert into message_data (id,lang_id,msg) values
(27,4,' zwischen diesen Tagen:');

insert into message_data (id,lang_id,msg) values
(28,4,'Ung&uuml;ltiges Datum Format');

insert into message_data (id,lang_id,msg) values
(29,4,'Sie haben ein ung&uuml;ltiges Datum oder eine ung&uuml;ltige Kombination von Daten 
eingegeben.');

insert into message_data (id,lang_id,msg) values
(30,4,'Den Zug nach ');

insert into message_data (id,lang_id,msg) values
(31,4,', Bitte f&uuml;llen sie das Formulier aus um ihre Tickets zu kaufen.');

insert into message_data (id,lang_id,msg) values
(32,4,'Jedes Ticket kostet $');

insert into message_data (id,lang_id,msg) values
(33,4,'Reiseanfangsdatum:');

insert into message_data (id,lang_id,msg) values
(34,4,'Anzahl der Tickets');

insert into message_data (id,lang_id,msg) values
(35,4,'&Uuml;berbucht');

insert into message_data (id,lang_id,msg) values
(36,4,'Sie haben leider mehr Tickets bestellt als wir vorr&auml;tig haben.');

insert into message_data (id,lang_id,msg) values
(37,4,'Ung&uuml;ltige Eingabe');

insert into message_data (id,lang_id,msg) values
(38,4,'Sie haben eine ung&uuml;ltige Anzahl Tickets eingegeben.');

insert into message_data (id,lang_id,msg) values
(39,4,'Kreditlimit &uuml;berschritten');

insert into message_data (id,lang_id,msg) values
(40,4,'Sie haben nicht genug Geld um diese transaktion durchzuf&uuml;hren.');

insert into message_data (id,lang_id,msg) values
(41,4,'Sie gehen nach ....');

insert into message_data (id,lang_id,msg) values
(42,4,'Sie haben gerade ');

insert into message_data (id,lang_id,msg) values
(43,4,' Tickets nach gekauft ');

insert into message_data (id,lang_id,msg) values
(44,4,'Passagiere');

insert into message_data (id,lang_id,msg) values
(45,4,'Anwender');

insert into message_data (id,lang_id,msg) values
(46,4,'Name');

insert into message_data (id,lang_id,msg) values
(47,4,'Kommentar');

insert into message_data (id,lang_id,msg) values
(48,4,'keiner');

insert into message_data (id,lang_id,msg) values
(49,4,'Login');

insert into message_data (id,lang_id,msg) values
(50,4,'Machen');

insert into message_data (id,lang_id,msg) values
(51,4,'Filesystem');

insert into message_data (id,lang_id,msg) values
(52,4,'Delete');

insert into message_data (id,lang_id,msg) values
(53,4,'Update');

insert into message_data (id,lang_id,msg) values
(54,4,'Oracle Reise');

insert into message_data (id,lang_id,msg) values
(55,4,'Ein Blick auf die Stadt');

insert into message_data (id,lang_id,msg) values
(56,4,'Datenbank');

insert into message_data (id,lang_id,msg) values
(57,4,'<IMG SRC="/tr-img/dhome.gif" ALT="[Home]">');

insert into message_data (id,lang_id,msg) values
(58,4,'<IMG SRC="/tr-img/deinstel.gif" ALT="[Einstellungen]">');

insert into message_data (id,lang_id,msg) values
(59,4,'<IMG SRC="/tr-img/dreisezl.gif" ALT="[Reiseziele]">');

insert into message_data (id,lang_id,msg) values
(60,4,'<IMG SRC="/tr-img/dneustrt.gif" ALT="[Neustart]">');

rem
rem These messages must be aligned!
rem

insert into message_data (id,lang_id,msg) values
(61,4,'     Name ');

insert into message_data (id,lang_id,msg) values
(62,4,'  Adresse ');

insert into message_data (id,lang_id,msg) values
(63,4,'    Stadt ');

insert into message_data (id,lang_id,msg) values
(64,4,'Postleitz ');

insert into message_data (id,lang_id,msg) values
(65,4,'    Staat ');

insert into message_data (id,lang_id,msg) values
(66,4,'     Land ');

insert into message_data (id,lang_id,msg) values
(67,4,'    Email ');

insert into message_data (id,lang_id,msg) values
(68,4,'  Saldo $ ');

insert into message_data (id,lang_id,msg) values
(69,4,'  Sprache ');

insert into message_data (id,lang_id,msg) values
(70,4,'   Bilder ');

rem
rem End of Aligned fields
rem

insert into message_data (id,lang_id,msg) values
(71,4,'Ankerkungen &uuml;ber sich selbst');

rem
rem These messages must be aligned
rem

insert into message_data (id,lang_id,msg) values
(72,4,'Anwender: ');

insert into message_data (id,lang_id,msg) values
(73,4,'Password: ');

insert into message_data (id,lang_id,msg) values
(74,4,'  Aktion: ');

rem
rem End of aligned messages
rem

insert into message_data (id,lang_id,msg) values
(75,4,'error.de.gif');

insert into message_data (id,lang_id,msg) values
(76,4,'Kontrolle im Modul ');

insert into message_data (id,lang_id,msg) values
(77,4,'verloren. Verarbeitung gestoppt.');

insert into message_data (id,lang_id,msg) values
(78,4,'Neustart Demo');

insert into message_data (id,lang_id,msg) values
(79,4,'success.de.gif');

insert into message_data (id,lang_id,msg) values
(80,4,'Nichtabgefangene Ausnahme in in tru.title_gif');

insert into message_data (id,lang_id,msg) values
(81,4,'save_state (angerufen von ');

insert into message_data (id,lang_id,msg) values
(82,4,'Sie haben diese Seite zu den folgenden Zeiten besucht');

insert into message_data (id,lang_id,msg) values
(83,4,'Timestamp');

insert into message_data (id,lang_id,msg) values
(84,4,'Client');

insert into message_data (id,lang_id,msg) values
(85,4,'Client Software');

insert into message_data (id,lang_id,msg) values
(86,4,'Server');

insert into message_data (id,lang_id,msg) values
(87,4,'Server Software');

insert into message_data (id,lang_id,msg) values
(88,4,'Dies ist das erste Mal da&szlig; sie diese dynamische Seite besuchen.');

insert into message_data (id,lang_id,msg) values
(89,4,'Sie haben diese dynamische Seite ');

insert into message_data (id,lang_id,msg) values
(90,4,' Mal besucht. Der Inhalt kann jedes mal ein bi&szlig;chen anders sein.');

insert into message_data (id,lang_id,msg) values
(91,4,' Sekunden');

insert into message_data (id,lang_id,msg) values
(92,4,' Minuten');

insert into message_data (id,lang_id,msg) values
(93,4,' Stunden');

insert into message_data (id,lang_id,msg) values
(94,4,' Tage');

insert into message_data (id,lang_id,msg) values
(95,4,'Sie waren hier am ');

insert into message_data (id,lang_id,msg) values
(96,4,', genau');

insert into message_data (id,lang_id,msg) values
(97,4,' her.');

insert into message_data (id,lang_id,msg) values
(98,4,'tr.tx_save (angerufen von ');

insert into message_data (id,lang_id,msg) values
(99,4,'Ung&uuml;ltiger TX code: ');

insert into message_data (id,lang_id,msg) values
(100,4,'t_splash.de.gif');

insert into message_data (id,lang_id,msg) values
(101,4,'t_security.de.gif');

insert into message_data (id,lang_id,msg) values
(102,4,'t_home.de.gif');

insert into message_data (id,lang_id,msg) values
(103,4,'t_dests.de.gif');

insert into message_data (id,lang_id,msg) values
(104,4,'t_ticket.de.gif');

insert into message_data (id,lang_id,msg) values
(105,4,'Nichtraucher, Sitzplatz am Gang');

insert into message_data (id,lang_id,msg) values
(106,4,'Nichtraucher, Sitzplatz am Fenster');

insert into message_data (id,lang_id,msg) values
(107,4,'Raucher, Sitzplatz am Gang');

insert into message_data (id,lang_id,msg) values
(108,4,'Raucher, Sitzplatz am Fenster');

insert into message_data (id,lang_id,msg) values
(109,4,' Tickets sind gekauft f&uuml;r die Abreise am');

insert into message_data (id,lang_id,msg) values
(110,4,'Es sind');

insert into message_data (id,lang_id,msg) values
(111,4,' Pl&auml;tze auf diesem Zug volgenderma&szlig;en verteilt: ');

insert into message_data (id,lang_id,msg) values
(112,4,' Nichtraucherpl&auml;tze am Gang');

insert into message_data (id,lang_id,msg) values
(113,4,' Nichtraucherpl&auml;tze am Fenster');

insert into message_data (id,lang_id,msg) values
(114,4,' Raucherpl&auml;tze am Gang');

insert into message_data (id,lang_id,msg) values
(115,4,' Raucherpl&auml;tze am Fenster');

insert into message_data (id,lang_id,msg) values
(116,4,'t_purchase.de.gif');

insert into message_data (id,lang_id,msg) values
(117,4,'t_passengers.de.gif');

insert into message_data (id,lang_id,msg) values
(118,4,'t_prefs.de.gif');

insert into message_data (id,lang_id,msg) values
(119,4,'Seitengeschichte');

insert into message_data (id,lang_id,msg) values
(120,4,' Ja');

insert into message_data (id,lang_id,msg) values
(121,4,' Nein');

insert into message_data (id,lang_id,msg) values
(122,4,'You have visited this page on the following occasions');

insert into message_data (id,lang_id,msg) values
(123,4,'That username already exists. Please choose something else!');

insert into message_data (id,lang_id,msg) values
(124,4,'Tickets Purchased');

insert into message_data (id,lang_id,msg) values
(125,4,'Status');

insert into message_data (id,lang_id,msg) values
(126,4,'Destination');

insert into message_data (id,lang_id,msg) values
(127,4,'Departure Date');

insert into message_data (id,lang_id,msg) values
(128,4,'Return Date');

insert into message_data (id,lang_id,msg) values
(129,4,'No of Seats');

insert into message_data (id,lang_id,msg) values
(130,4,'Total Price');

insert into message_data (id,lang_id,msg) values
(131,4,'Purchase Date');

insert into message_data (id,lang_id,msg) values
(132,4,'In Progress');

insert into message_data (id,lang_id,msg) values
(133,4,'Been There');

insert into message_data (id,lang_id,msg) values
(134,4,' days left');

insert into message_data (id,lang_id,msg) values
(135,4,'. However, this is the list price. We are pleased to offer you the following discount prices:');

insert into message_data (id,lang_id,msg) values
(136,4,'Price');

insert into message_data (id,lang_id,msg) values
(137,4,'Your current balance is $');

insert into message_data (id,lang_id,msg) values
(138,4,', your new balance is $');

commit;

rem
rem Dutch, Language=5
rem

insert into message_data (id,lang_id,msg) values 
(1,5,'Welkom bij Oracle Travel'); 
 
insert into message_data (id,lang_id,msg) values 
(2,5,'Foto van een trein'); 
 
insert into message_data (id,lang_id,msg) values 
(3,5,'Beleef het comfort van reizen per trein!'); 
 
insert into message_data (id,lang_id,msg) values 
(4,5,'Inloggen mislukt na 3 pogingen'); 
 
insert into message_data (id,lang_id,msg) values 
(5,5,'Waarschuwing'); 
 
insert into message_data (id,lang_id,msg) values 
(6,5,'U bent er niet in geslaagd in te loggen. Deze ' || 
	'server houdt nu al het verkeer van uw machine in de gaten('); 
 
insert into message_data (id,lang_id,msg) values 
(7,5,') en zal dit bewijs gebruiken in de rechtzaal.'); 
 
insert into message_data (id,lang_id,msg) values 
(8,5,'U heeft een ongeldige combinatie gebruikersnaam/password gebruikt.'); 
 
insert into message_data (id,lang_id,msg) values 
(9,5,'Poging tot inloggen '); 
 
insert into message_data (id,lang_id,msg) values 
(10,5,' Home Page'); 
 
insert into message_data (id,lang_id,msg) values 
(11,5,'Oracle Travel Home Page'); 
 
insert into message_data (id,lang_id,msg) values 
(12,5,'Kaart van de Verenigde Staten'); 
 
insert into message_data (id,lang_id,msg) values 
(13,5,', welkom bij Oracle Travel. Deze pagina geeft u informatie over ' || 
	'uw voorgaande bezoeken. U kunt een nieuwe reis boeken door'); 
 
insert into message_data (id,lang_id,msg) values 
(14,5,'lijst van bestemmingen te bezoeken.'); 
 
insert into message_data (id,lang_id,msg) values 
(15,5,' Voorkeursinstellingen'); 
 
insert into message_data (id,lang_id,msg) values 
(16,5,'Hier kunt u uw gegevens veranderen.'); 
 
insert into message_data (id,lang_id,msg) values 
(17,5,'Ongeldig saldo'); 
 
insert into message_data (id,lang_id,msg) values 
(18,5,'U heeft een ongeldige waarde ingevuld in het '); 
 
insert into message_data (id,lang_id,msg) values 
(19,5,'saldo'); 
 
insert into message_data (id,lang_id,msg) values 
(20,5,' veld.  Vul opnieuw in en zend het formulier nogmaals.'); 
 
insert into message_data (id,lang_id,msg) values 
(21,5,'Uw voorkeursinstellingen zijn veranderd!'); 
 
insert into message_data (id,lang_id,msg) values 
(22,5,', wij hebben de volgende geweldige reisbestemmingen voor u!'); 
 
insert into message_data (id,lang_id,msg) values 
(23,5,'Oracle Travel reisbestemmingen'); 
 
insert into message_data (id,lang_id,msg) values 
(24,5,'Reisbestemmingen'); 
 
insert into message_data (id,lang_id,msg) values 
(25,5,'Mijnheer, Mevouw'); 
 
insert into message_data (id,lang_id,msg) values 
(26,5,'Ik ben ge&iuml;nteresseerd in een treinreis naar '); 
 
insert into message_data (id,lang_id,msg) values 
(27,5,' tussen deze twee data:'); 
 
insert into message_data (id,lang_id,msg) values 
(28,5,'Ongeldige datum'); 
 
insert into message_data (id,lang_id,msg) values 
(29,5,'U heeft een ongeldige datum of combinatie van data ingevuld.'); 
 
insert into message_data (id,lang_id,msg) values 
(30,5,'Met de trein naar '); 
 
insert into message_data (id,lang_id,msg) values 
(31,5,', vul dit formulier in om uw tickets te bestellen.'); 
 
insert into message_data (id,lang_id,msg) values 
(32,5,'Prijs per stuk Dfl'); 
 
insert into message_data (id,lang_id,msg) values 
(33,5,'Vertrekdatum:'); 
 
insert into message_data (id,lang_id,msg) values 
(34,5,'Aantal tickets '); 
 
insert into message_data (id,lang_id,msg) values 
(35,5,'Volgeboekt'); 
 
insert into message_data (id,lang_id,msg) values 
(36,5,'Helaas, u heeft meer tickets besteld dan beschikbaar zijn.'); 
 
insert into message_data (id,lang_id,msg) values 
(37,5,'Ongeldige invoer'); 
 
insert into message_data (id,lang_id,msg) values 
(38,5,'U heeft een ongeldig aantal tickets ingevoerd.'); 
 
insert into message_data (id,lang_id,msg) values 
(39,5,'Credietlimiet overschreden'); 
 
insert into message_data (id,lang_id,msg) values 
(40,5,'U heeft onvoldoende geld voor deze transactie.'); 
 
insert into message_data (id,lang_id,msg) values 
(41,5,'Naar ...'); 
 
insert into message_data (id,lang_id,msg) values 
(42,5,'U heeft zojuist geboekt '); 
 
insert into message_data (id,lang_id,msg) values 
(43,5,' tickets naar '); 
 
insert into message_data (id,lang_id,msg) values 
(44,5,'Passagiers'); 
 
insert into message_data (id,lang_id,msg) values 
(45,5,'Gebruiker'); 
 
insert into message_data (id,lang_id,msg) values 
(46,5,'Naam'); 
 
insert into message_data (id,lang_id,msg) values 
(47,5,'Opmerkingen'); 
 
insert into message_data (id,lang_id,msg) values 
(48,5,'geen'); 
 
insert into message_data (id,lang_id,msg) values 
(49,5,'Login'); 
 
insert into message_data (id,lang_id,msg) values 
(50,5,'Cre&euml;er'); 
 
insert into message_data (id,lang_id,msg) values 
(51,5,'Filesystem'); 
 
insert into message_data (id,lang_id,msg) values 
(52,5,'Verwijder'); 
 
insert into message_data (id,lang_id,msg) values 
(53,5,'Verander'); 
 
insert into message_data (id,lang_id,msg) values 
(54,5,'Oracle Travel'); 
 
insert into message_data (id,lang_id,msg) values 
(55,5,'Een stadsgezicht'); 
 
insert into message_data (id,lang_id,msg) values 
(56,5,'Database'); 
 
insert into message_data (id,lang_id,msg) values 
(57,5,'<IMG SRC="/tr-img/nlhome.gif" ALT="[Home]">'); 
 
insert into message_data (id,lang_id,msg) values 
(58,5,'<IMG SRC="/tr-img/nlvoorku.gif" ALT="[Voorkeuren]">'); 
 
insert into message_data (id,lang_id,msg) values 
(59,5,'<IMG SRC="/tr-img/nlbestmn.gif" ALT="[Bestemmingen]">'); 
 
insert into message_data (id,lang_id,msg) values 
(60,5,'<IMG SRC="/tr-img/nlbegino.gif" ALT="[Begin opnieuw]">'); 
 
rem 
rem These messages must be aligned! 
rem 
 
insert into message_data (id,lang_id,msg) values 
(61,5,'       Naam '); 
 
insert into message_data (id,lang_id,msg) values 
(62,5,'      Adres '); 
 
insert into message_data (id,lang_id,msg) values 
(63,5,' Woonplaats '); 
 
insert into message_data (id,lang_id,msg) values 
(64,5,'   Postcode '); 
 
insert into message_data (id,lang_id,msg) values 
(65,5,'      Staat '); 
 
insert into message_data (id,lang_id,msg) values 
(66,5,'       Land '); 
 
insert into message_data (id,lang_id,msg) values 
(67,5,'      Email '); 
 
insert into message_data (id,lang_id,msg) values 
(68,5,'   Saldo Dfl '); 
 
insert into message_data (id,lang_id,msg) values 
(69,5,'       Taal '); 
 
insert into message_data (id,lang_id,msg) values 
(70,5,'    Foto''s '); 
 
rem 
rem End of Aligned fields 
rem 
 
insert into message_data (id,lang_id,msg) values 
(71,5,'Opmerkingen over uzelf'); 
 
rem 
rem These messages must be aligned 
rem 
 
insert into message_data (id,lang_id,msg) values 
(72,5,'Gebruiker: '); 
 
insert into message_data (id,lang_id,msg) values 
(73,5,' Password: '); 
 
insert into message_data (id,lang_id,msg) values 
(74,5,'    Actie: '); 
 
rem 
rem End of aligned messages 
rem 
 
insert into message_data (id,lang_id,msg) values 
(75,5,'error.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(76,5,'Lost control in module '); 
 
insert into message_data (id,lang_id,msg) values 
(77,5,'. Processing halted.'); 
 
insert into message_data (id,lang_id,msg) values 
(78,5,'Herstart demo'); 
 
insert into message_data (id,lang_id,msg) values 
(79,5,'success.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(80,5,'Unhandled Exception in tru.title_gif'); 
 
insert into message_data (id,lang_id,msg) values 
(81,5,'save_state (called from '); 
 
insert into message_data (id,lang_id,msg) values 
(82,5,'U was hier eerder op de volgende tijdstippen'); 
 
insert into message_data (id,lang_id,msg) values 
(83,5,'Tijdstempel'); 
 
insert into message_data (id,lang_id,msg) values 
(84,5,'Client'); 
 
insert into message_data (id,lang_id,msg) values 
(85,5,'Client software'); 
 
insert into message_data (id,lang_id,msg) values 
(86,5,'Server'); 
 
insert into message_data (id,lang_id,msg) values 
(87,5,'Server software'); 
 
insert into message_data (id,lang_id,msg) values 
(88,5,'Dit is uw eerste bezoek aan deze dynamische pagina.'); 
 
insert into message_data (id,lang_id,msg) values 
(89,5,'U heeft deze dynamische pagina '); 
 
insert into message_data (id,lang_id,msg) values 
(90,5,' keren bezocht. De inhoud kan iedere keer weer anders zijn.'); 
 
insert into message_data (id,lang_id,msg) values 
(91,5,' seconden'); 
 
insert into message_data (id,lang_id,msg) values 
(92,5,' minuten'); 
 
insert into message_data (id,lang_id,msg) values 
(93,5,' uur'); 
 
insert into message_data (id,lang_id,msg) values 
(94,5,' dagen'); 
 
insert into message_data (id,lang_id,msg) values 
(95,5,'U was hier eerder op '); 
 
insert into message_data (id,lang_id,msg) values 
(96,5,', precies '); 
 
insert into message_data (id,lang_id,msg) values 
(97,5,' geleden.'); 
 
insert into message_data (id,lang_id,msg) values 
(98,5,'tr.tx_save (called from '); 
 
insert into message_data (id,lang_id,msg) values 
(99,5,'Invalid TX code: '); 
 
insert into message_data (id,lang_id,msg) values 
(100,5,'t_splash.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(101,5,'t_security.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(102,5,'t_home.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(103,5,'t_dests.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(104,5,'t_ticket.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(105,5,'Niet roken, stoel bij het gangpad'); 
 
insert into message_data (id,lang_id,msg) values 
(106,5,'Niet roken, stoel bij het raam'); 
 
insert into message_data (id,lang_id,msg) values 
(107,5,'Roken, stoel bij het gangpad'); 
 
insert into message_data (id,lang_id,msg) values 
(108,5,'Roken, stoel bij het raam'); 
 
insert into message_data (id,lang_id,msg) values 
(109,5,' tickets zijn geboekt voor vertrek op'); 
 
insert into message_data (id,lang_id,msg) values 
(110,5,'Er zijn nog '); 
 
insert into message_data (id,lang_id,msg) values 
(111,5,' stoelen beschikbaar op deze trein in de volgende categorie&eumlaut;n: 
'); 
 
insert into message_data (id,lang_id,msg) values 
(112,5,' niet roken bij het gangpad'); 
 
insert into message_data (id,lang_id,msg) values 
(113,5,' niet roken bij het raam'); 
 
insert into message_data (id,lang_id,msg) values 
(114,5,' roken bij het gangpad'); 
 
insert into message_data (id,lang_id,msg) values 
(115,5,' roken bij het raam'); 
 
insert into message_data (id,lang_id,msg) values 
(116,5,'t_purchase.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(117,5,'t_passengers.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(118,5,'t_prefs.nl.gif'); 
 
insert into message_data (id,lang_id,msg) values 
(119,5,'Historie voor deze pagina'); 
 
insert into message_data (id,lang_id,msg) values 
(120,5,' Ja'); 
 
insert into message_data (id,lang_id,msg) values 
(121,5,' Nee'); 
 
insert into message_data (id,lang_id,msg) values 
(122,5,'U heeft deze pagina eerder bezocht op de volgende momenten'); 
 
insert into message_data (id,lang_id,msg) values 
(123,5,'Deze gebruikersnaam is al in gebruik.  Kies een andere!'); 
 
insert into message_data (id,lang_id,msg) values 
(124,5,'Geboekte tickets'); 
 
insert into message_data (id,lang_id,msg) values 
(125,5,'Status'); 
 
insert into message_data (id,lang_id,msg) values 
(126,5,'Bestemmingen'); 
 
insert into message_data (id,lang_id,msg) values 
(127,5,'Vertrekdatum'); 
 
insert into message_data (id,lang_id,msg) values 
(128,5,'Retourdatum'); 
 
insert into message_data (id,lang_id,msg) values 
(129,5,'Aantal stoelen'); 
 
insert into message_data (id,lang_id,msg) values 
(130,5,'Totaalprijs'); 
 
insert into message_data (id,lang_id,msg) values 
(131,5,'Geboekt op'); 
 
insert into message_data (id,lang_id,msg) values 
(132,5,'In behandeling'); 
 
insert into message_data (id,lang_id,msg) values 
(133,5,'Hier ben ik al geweest'); 
 
insert into message_data (id,lang_id,msg) values 
(134,5,' dagen over'); 
 
insert into message_data (id,lang_id,msg) values 
(135,5,'. Dit is echter de offici&euml;le prijs.  Wij bieden u graag de 
volgende speciale prijzen aan:'); 
 
insert into message_data (id,lang_id,msg) values 
(136,5,'Prijs'); 
 
insert into message_data (id,lang_id,msg) values 
(137,5,'Uw huidige saldo is Dfl'); 
 
insert into message_data (id,lang_id,msg) values 
(138,5,', uw nieuwe saldo is Dfl');

commit;

rem
rem French, Language=6
rem

insert into message_data (id,lang_id,msg) values
(1,6,'Oracle Travel vous souhaite la bienvenue');

insert into message_data (id,lang_id,msg) values
(2,6,'Image d''un train');

insert into message_data (id,lang_id,msg) values
(3,6,'D&eacute;tendez-vous en prenant le train !');

insert into message_data (id,lang_id,msg) values
(4,6,'Echec de connexion apr&egrave;s 3 essais');

insert into message_data (id,lang_id,msg) values
(5,6,'Alerte s&eacute;curit&eacute;');

insert into message_data (id,lang_id,msg) values
(6,6,'Vous avez essay&eacute; trois fois de vous identifier sans succ&egrave;s. Ce serveur ' ||
     'va maintenant contr&ocirc;ler toutes les op&eacute;rations effectu&eacute;es &agrave; partir de ce noeud (');

insert into message_data (id,lang_id,msg) values
(7,6,') ce qui servira de preuve au tribunal.');

insert into message_data (id,lang_id,msg) values
(8,6,'Combinaison Nom utilisateur/mot de passe invalide.');

insert into message_data (id,lang_id,msg) values
(9,6,'Essai d''identification ');

insert into message_data (id,lang_id,msg) values
(10,6,' Page principale');

insert into message_data (id,lang_id,msg) values
(11,6,'Page principale de Oracle Travel');

insert into message_data (id,lang_id,msg) values
(12,6,'Carte des Etats-Unis');

insert into message_data (id,lang_id,msg) values
(13,6,', Bienvenue &agrave; Oracle Travel sur le Web. Vous trouverez ici des informations ' ||
      'sur ce que vous avez fait lors de visites pr&eacute;c&eacute;dentes. Vous pouvez ' ||
      'faire une nouvelle r&eacute;servation en consultant notre ');

insert into message_data (id,lang_id,msg) values
(14,6,'liste de destinations possibles');

insert into message_data (id,lang_id,msg) values
(15,6,' Pr&eacute;f&eacute;rences');

insert into message_data (id,lang_id,msg) values
(16,6,'Vous pouvez ici modifier des informations personnelles.');

insert into message_data (id,lang_id,msg) values
(17,6,'Solde incorrect');

insert into message_data (id,lang_id,msg) values
(18,6,'aleur non valide dans le champ');

insert into message_data (id,lang_id,msg) values
(19,6,'Solde.');

insert into message_data (id,lang_id,msg) values
(20,6,'Veuillez corriger et renvoyer le formulaire.');

insert into message_data (id,lang_id,msg) values
(21,6,'Vos pr&eacute;f&eacute;rences ont &eacute;t&eacute; mises &agrave; jour !');

insert into message_data (id,lang_id,msg) values
(22,6,', laissez-nous vous pr&eacute;senter quelques-unes de nos destinations !');

insert into message_data (id,lang_id,msg) values
(23,6,'Oracle Travel Destinations');

insert into message_data (id,lang_id,msg) values
(24,6,'Destinations');

insert into message_data (id,lang_id,msg) values
(25,6,'Noname');

insert into message_data (id,lang_id,msg) values
(26,6,'Je suis int&eacute;ress&eacute; par un voyage en train vers ' );

insert into message_data (id,lang_id,msg) values
(27,6,' entre les dates suivantes:');

insert into message_data (id,lang_id,msg) values
(28,6,'Format de date incorrect.');

insert into message_data (id,lang_id,msg) values
(29,6,'Date ou combinaison de date incorrecte.');

insert into message_data (id,lang_id,msg) values
(30,6,'Train pour ');

insert into message_data (id,lang_id,msg) values
(31,6,', veuillez remplir ce formulaire pour acheter vos billets.');

insert into message_data (id,lang_id,msg) values
(32,6,'Co&ucirc;t d''un billet (en $) ');

insert into message_data (id,lang_id,msg) values
(33,6,'Date de d&eacute;part:');

insert into message_data (id,lang_id,msg) values
(34,6,'No de billets ');

insert into message_data (id,lang_id,msg) values
(35,6,'Surr&eacute;servation');

insert into message_data (id,lang_id,msg) values
(36,6,'D&eacute;sol&eacute;, vous avez demand&eacute; plus de billets qu''il n''y en a de disponible.');

insert into message_data (id,lang_id,msg) values
(37,6,'Entr&eacute;e incorrecte');

insert into message_data (id,lang_id,msg) values
(38,6,'Nombre de billets non valide.');

insert into message_data (id,lang_id,msg) values
(39,6,'D&eacute;passement de limite de cr&eacute;dit');

insert into message_data (id,lang_id,msg) values
(40,6,'Somme insuffisante pour accomplir cette transaction.');

insert into message_data (id,lang_id,msg) values
(41,6,'Voyage pour ....');

insert into message_data (id,lang_id,msg) values
(42,6,'Vous venez d''acheter ');

insert into message_data (id,lang_id,msg) values
(43,6,' billets pour ');

insert into message_data (id,lang_id,msg) values
(44,6,'Passagers');

insert into message_data (id,lang_id,msg) values
(45,6,'Utilisateur');

insert into message_data (id,lang_id,msg) values
(46,6,'Nom');

insert into message_data (id,lang_id,msg) values
(47,6,'Commentaire');

insert into message_data (id,lang_id,msg) values
(48,6,'Aucun');

insert into message_data (id,lang_id,msg) values
(49,6,'Connexion');

insert into message_data (id,lang_id,msg) values
(50,6,'Cr&eacute;er');

insert into message_data (id,lang_id,msg) values
(51,6,'Syst&egrave;me de fichiers');

insert into message_data (id,lang_id,msg) values
(52,6,'Effacer');

insert into message_data (id,lang_id,msg) values
(53,6,'Mettre a jour');

insert into message_data (id,lang_id,msg) values
(54,6,'Oracle Travel');

insert into message_data (id,lang_id,msg) values
(55,6,'Une vue de la ville');

insert into message_data (id,lang_id,msg) values
(56,6,'Base de donn&eacute;es');

insert into message_data (id,lang_id,msg) values
(57,6,'<IMG SRC="/tr-img/fpgeprin.gif" ALT="[Pge princ.]">');

insert into message_data (id,lang_id,msg) values
(58,6,'<IMG SRC="/tr-img/fprefs.gif" ALT="[Pr&eacute;fs]">');

insert into message_data (id,lang_id,msg) values
(59,6,'<IMG SRC="/tr-img/fdestin.gif" ALT="[Destinations]">');

insert into message_data (id,lang_id,msg) values
(60,6,'<IMG SRC="/tr-img/frelancr.gif" ALT="[Relancer]">');

rem
rem These messages must be aligned!
rem

insert into message_data (id,lang_id,msg) values
(61,6,'        Nom ');

insert into message_data (id,lang_id,msg) values
(62,6,'    Adresse ');

insert into message_data (id,lang_id,msg) values
(63,6,'      Ville ');

insert into message_data (id,lang_id,msg) values
(64,6,'Code Postal ');

insert into message_data (id,lang_id,msg) values
(65,6,'D&eacute;partement ');

insert into message_data (id,lang_id,msg) values
(66,6,'       Pays ');

insert into message_data (id,lang_id,msg) values
(67,6,'      Email ');

insert into message_data (id,lang_id,msg) values
(68,6,'    Solde $ ');

insert into message_data (id,lang_id,msg) values
(69,6,'     Langue ');

insert into message_data (id,lang_id,msg) values
(70,6,'     Images ');

rem
rem End of Aligned fields
rem

insert into message_data (id,lang_id,msg) values
(71,6,'Coordonn&eacute;es');

rem
rem These messages must be aligned
rem

insert into message_data (id,lang_id,msg) values
(72,6,' Utilisateur : ');

insert into message_data (id,lang_id,msg) values
(73,6,'Mot de passe : ');

insert into message_data (id,lang_id,msg) values
(74,6,'      Action : ');

rem
rem End of aligned messages
rem

insert into message_data (id,lang_id,msg) values
(75,6,'error.fr.gif');

insert into message_data (id,lang_id,msg) values
(76,6,'Lost control in module ');

insert into message_data (id,lang_id,msg) values
(77,6,'. Processing halted.');

insert into message_data (id,lang_id,msg) values
(78,6,'Restart Demo');

insert into message_data (id,lang_id,msg) values
(79,6,'success.fr.gif');

insert into message_data (id,lang_id,msg) values
(80,6,'Unhandled Exception in tru.title_gif');

insert into message_data (id,lang_id,msg) values
(81,6,'save_state (called from ');

insert into message_data (id,lang_id,msg) values
(82,6,'Vous avez consult&eacute; cette page lors de :');

insert into message_data (id,lang_id,msg) values
(83,6,'Timestamp');

insert into message_data (id,lang_id,msg) values
(84,6,'Client');

insert into message_data (id,lang_id,msg) values
(85,6,'Logiciel Client');

insert into message_data (id,lang_id,msg) values
(86,6,'Serveur');

insert into message_data (id,lang_id,msg) values
(87,6,'Logiciel Serveur');

insert into message_data (id,lang_id,msg) values
(88,6,'Vous consultez cette page pour la premi&egrave;re fois.');

insert into message_data (id,lang_id,msg) values
(89,6,'Vous avez consult&eacute; cette page ');

insert into message_data (id,lang_id,msg) values
(90,6,' fois. Le contenu peut diff&eacute;rer chaque fois.');

insert into message_data (id,lang_id,msg) values
(91,6,' secondes');

insert into message_data (id,lang_id,msg) values
(92,6,' minutes');

insert into message_data (id,lang_id,msg) values
(93,6,' heures');

insert into message_data (id,lang_id,msg) values
(94,6,' jours');

insert into message_data (id,lang_id,msg) values
(95,6,'Vous &eacute;tiez ici le ');

insert into message_data (id,lang_id,msg) values
(96,6,', il y a ');

insert into message_data (id,lang_id,msg) values
(97,6,' exactement.');

insert into message_data (id,lang_id,msg) values
(98,6,'tr.tx_save (called from ');

insert into message_data (id,lang_id,msg) values
(99,6,'Invalid TX code: ');

insert into message_data (id,lang_id,msg) values
(100,6,'t_splash.fr.gif');

insert into message_data (id,lang_id,msg) values
(101,6,'t_security.fr.gif');

insert into message_data (id,lang_id,msg) values
(102,6,'t_home.fr.gif');

insert into message_data (id,lang_id,msg) values
(103,6,'t_dests.fr.gif');

insert into message_data (id,lang_id,msg) values
(104,6,'t_ticket.fr.gif');

insert into message_data (id,lang_id,msg) values
(105,6,'Non fumeur, c&ocirc;t&eacute; couloir');

insert into message_data (id,lang_id,msg) values
(106,6,'Non fumeur, c&ocirc;t&eacute; fen&ecirc;tre');

insert into message_data (id,lang_id,msg) values
(107,6,'Fumeur, c&ocirc;t&eacute; couloir');

insert into message_data (id,lang_id,msg) values
(108,6,'Fumeur, c&ocirc;t&eacute; fen&ecirc;tre');

insert into message_data (id,lang_id,msg) values
(109,6,' tickets have been purchased for the departure on');

insert into message_data (id,lang_id,msg) values
(110,6,'Il reste ');

insert into message_data (id,lang_id,msg) values
(111,6,' places dans ce train, distribu&eacute;s de la fa&ccedil;on suivante : ');

insert into message_data (id,lang_id,msg) values
(112,6,' places non fumeur, c&ocirc;t&eacute; couloir');

insert into message_data (id,lang_id,msg) values
(113,6,' places non fumeur, c&ocirc;t&eacute; fen&ecirc;tre');

insert into message_data (id,lang_id,msg) values
(114,6,' places fumeur, c&ocirc;t&eacute; couloir');

insert into message_data (id,lang_id,msg) values
(115,6,' places fumeur, c&ocirc;t&eacute; fen&ecirc;tre');

insert into message_data (id,lang_id,msg) values
(116,6,'t_purchase.fr.gif');

insert into message_data (id,lang_id,msg) values
(117,6,'t_passengers.fr.gif');

insert into message_data (id,lang_id,msg) values
(118,6,'t_prefs.fr.gif');

insert into message_data (id,lang_id,msg) values
(119,6,'Historique');

insert into message_data (id,lang_id,msg) values
(120,6,' Oui');

insert into message_data (id,lang_id,msg) values
(121,6,' Non');

insert into message_data (id,lang_id,msg) values
(122,6,'Vous avez consult&eacute; cette page lors de :');

insert into message_data (id,lang_id,msg) values
(123,6,'Ce nom utilisateur existe d&eacute;j&agrave;. Choisissez-en un autre.');

insert into message_data (id,lang_id,msg) values
(124,6,'Billets achet&eacute;s');

insert into message_data (id,lang_id,msg) values
(125,6,'Etat');

insert into message_data (id,lang_id,msg) values
(126,6,'Destination');

insert into message_data (id,lang_id,msg) values
(127,6,'Date de d&eacute;part');

insert into message_data (id,lang_id,msg) values
(128,6,'Date de retour');

insert into message_data (id,lang_id,msg) values
(129,6,'Nbre places');

insert into message_data (id,lang_id,msg) values
(130,6,'Prix');

insert into message_data (id,lang_id,msg) values
(131,6,'Date d''achat');

insert into message_data (id,lang_id,msg) values
(132,6,'En cours');

insert into message_data (id,lang_id,msg) values
(133,6,'D&eacute;j&agrave; all&eacute;');

insert into message_data (id,lang_id,msg) values
(134,6,' jours reste');

insert into message_data (id,lang_id,msg) values
(135,6,'. Toutefois, il s''agit du prix de catalogue. C''est avec plaisir que ' ||
       'nous vous pr&eacute;sentons les promotions suivants :');

insert into message_data (id,lang_id,msg) values
(136,6,'Prix');

insert into message_data (id,lang_id,msg) values
(137,6,'Solde courant (en $) :');

insert into message_data (id,lang_id,msg) values
(138,6,', Nouveau solde (en $) : ');

Commit;
