rem Copyright (c) 1995, 1996 Oracle Corporation. All rights reserved.
rem 
rem Created
rem 08/18/95	mlonnrot
rem
rem Translations
rem 	Dutch		Sergio Leunissen
rem	French		Mirella Gazzoni
rem 	German		Robert Gasch
rem 	Spanish		Juan Soriano
rem	Swedish		Magnus Lonnroth
rem
rem Modified
rem
rem Description
rem	Create test data for Travel Demo.

rem
rem Languages
rem

insert into language_data
(id,name)
values
(1,'English');

insert into language_data
(id,name)
values
(2,'Svenska');

insert into language_data
(id,name)
values
(3,'Espa&ntilde;ol');

insert into language_data
(id,name)
values
(4,'Deutsch');

insert into language_data
(id,name)
values
(5,'Nederlands');

insert into language_data
(id,name)
values
(6,'Francais');

rem
rem Destinations
rem

declare
	d1 destination_data%rowtype;
	d2 description_data%rowtype;
begin
	d2.lang_id := 1;
	d2.hype := 'San Francisco is the fourth largest city in the United States. ' ||
'Situated on the Pacific Coast, it is by a long way the most popular city with ' ||
'americans as well as tourists. It is built on more than forty hills covering ' ||
'the 7.5 mile (12 km) wide northern tip of the peninsula separating the Pacific ' ||
'Ocean from the San Francisco Bay. The temperature varies between 50F (10C) and ' ||
'77F (25C) all year due to the moderating effect of the surrounding waters, making ' ||
'San Francisico a cool escape when the temperature soars further inland. A cold ' ||
'marine current off the coast is responsible for the frequent fog, caused by cold ' ||
'sea air being kept down by warm mainland air.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'San Francisco &auml;r F&ouml;renta Staternas fj&auml;rde ' ||
'st&ouml;rsta stad. Bel&auml;gen p&aring; Stilla Havs kusten, och helt klart ' ||
'den popul&auml;raste staden b&aring;de f&ouml;r amerikaner och turister. Staden ' ||
'&auml;r byggd p&aring; &ouml;ver 40 kullar och t&auml;cker den 12 km breda ' ||
'halv&ouml;ns nordliga del, innesluten mellan Stilla Havet och San Francisco Bay. ' ||
'Temperaturen varierar mellan 10 och 25 grader under hela &aring;ret p.g.a det ' ||
'omkringliggande vattnets kylande effekt, vilket g&ouml;r San Francisco till en ' ||
'sval undanflykt n&auml;r inlandets drabbas av olidlig sommarhetta. En kall ' ||
'havsstr&ouml;m strax utanf&ouml;r kusten orsakar den ofta f&ouml;rekommande ' ||
'dimman, som orsakas av att den kalla havsluften trycks ner av den varma ' ||
'inlandsluften.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'San Francisco es la cuarta ciudad m&aacute;s grande en Estados Unidos. ' ||
'Est&aacute; situada en la costa del Pac&iacute;fico y es sin duda, la ' ||
'ciudad m&aacute;s popular tanto para americanos, como para turistas. ' ||
'Esta construida sobre mas de cuarenta monta&ntilde;as que cubren la ' ||
'punta norte de 12 km de ancho, de la pen&iacute;nsula que separa el ' ||
'Oc&eacute;ano Pac&iacute;fico, de la Bah&iacute;a de San Francisco. ' ||
'Su temperatura fluct&uacute;a entre los 10 y 25 C durante todo el ' ||
'a&ntilde;o debido al efecto amortiguador de la gran cantidad de agua ' ||
'en los alrededores, haciendo que San Francisco sea considerado como un ' ||
'sitio ideal hacia donde escapar, cuando la temperatura de las regiones ' ||
'mas alejadas de la costa suben a niveles exteremos.  La fr&iacute;a ' ||
'corriente marina de la costa es responsable por la frecuente niebla, ' ||
'causada por el fr&iacute;o aire marino que se mantiene a baja altura ' ||
'por el aire tibio de tierra firme.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'San Francisco ist die viert-gr&ouml;&szlig;te Stadt in den Vereinigten Staaten. '||
'An der pazifischen K&uuml;ste liegend, ist es mit Abstand, bei sowohl '||
'Amerikanern als auch Touristen, die popul&auml;rste Stadt. San Francisco '||
'ist auf mehr als 40 H&uuml;geln auf der n&ouml;rdlichen Spitze der Halbinsel, '||
'die den stillen Ozean vom San Francisco Bay trennt, gebaut. Die '||
'Temperatur betr&auml;gt w&auml;hrend des ganze Jahres zwischen 50F (10C) und '||
'77F (25C) da das Meer einen modrierenden Effekt auf das Klima hat. Eine '||
'kalte Str&ouml;mung vor der K&uuml;ste ist die Ursache f&uuml;r den st&auml;ndigen Nebel, '||
'der durch kalte Meeresluft unter einer Schicht von warmer kontinentaler '||
'Luft, verursacht wird.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype :='San Francisco is de op drie na grootste stad in de Verenigde Staten.  Deze ' ||
'stad aan de Westkust is verreweg de meest populaire stad zowel onder ' ||
'Amerikanen als onder touristen.  De stad is gebouwd op meer dan veertig ' ||
'heuvels, uitgestrekt over de 12km brede noordelijke punt van het schiereiland ' ||
'tussen de Stille Oceaan en de Baai van San Francisco.  Door de invloed van de ' ||
'omliggende wateren, varieert de temparatuur gedurende het hele jaar tussen de ' ||
'10C en de 25C.  Dit maakt San Francisco een koel toevluchtsoord wanneer de ' ||
'temparaturen stijgen in het binnenland.  Een koele luchtstroom uit zee is ' ||
'verantwoordelijk voor regelmatige mist, veroorzaakt door de koude zeelucht die ' ||
'wordt vastgehouden door de warme lucht van het vasteland.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'San Francisco est la quatri&egrave;me plus grande ' ||
'ville des Etats-Unis. Situ&eacute;e sur la c&ocirc;te Ouest, elle est ' ||
'de loin la ville pr&eacute;f&eacute;r&eacute;e des Am&eacute;ricains ' ||
'et des touristes. Construite sur une quarantaine de collines, elle ' ||
'couvre les 12 km tout au nord de la p&eacute;ninsule qui s&eacute;pare ' ||
'l''oc&eacute;an Pacifique de la Baie de San Francisco. La ' ||
'temp&eacute;rature y varie entre 10 et 25 C toute l''ann&eacute;e, ' ||
'faisant ainsi de San Francisco un h&acirc;vre de fra&icirc;cheur fort ' ||
'appr&eacute;ci&eacute; lorsque la canicule s&eacute;vit dans ' ||
'l''arri&egrave;re-pays. Un courant marin froid en provenance du large ' ||
'est la cause des fr&eacute;quents brouillards, r&eacute;sultat d''un ' ||
'air frais marin maintenu pr&egrave;s du sol par un vent chaud ' ||
'provenant du continent';
	description.put(d2);

	d1.name := 'San Francisco';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 500;
	d1.duration := 10;
	d1.filename := 'sanfrancisco.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'Chicago, also known as "Windy City", extends for more than ' ||
'60 miles (100 km) along the south-western shores of Lake Michigan. The city is ' ||
'extremely hot in the summer, extremely cold in the winter, and windy all ' ||
'year. It is nonetheless the most importantant financial and cultural center ' ||
'in the US after New York, and has the world''s busiest airport and largest' ||
'inland port, and is one of the most important road and railway hubs in the ' ||
'United States. With numerous recently built skyskrapers (among them two of ' ||
'the world''s tallest buildings), Chicago has a strikingly impressive skyline' ||
'on the Lakefront.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'Chicago, &auml;ven kallad "Windy City", str&auml;cker sig ' ||
'&ouml;ver 100 km l&auml;ngs med Lake Michigan sj&ouml;ns sydv&auml;stliga kust. ' ||
'Staden &auml;r extremt varm om sommaren, och extremt kall om vintern, och det ' ||
'bl&aring;ser n&auml;stan alltid. Trots detta, &auml;r Chicago USAs viktigaste ' ||
'ekonomiska och kulturella centrum efter New York, och har v&auml;rldens mest ' ||
'trafikerade flyglats och st&ouml;rsta "inlandshamn", och &auml;r ett av landets ' ||
'viktigaste v&auml;g och j&auml;rnv&auml;gsannex. Med ett stort antal nybyggda ' ||
'skyskrapare (bl.a. tv&aring; av v&auml;rldens h&ouml;gsta), har Chicago en ' ||
'sl&aring;ende och imponerande "skyline" mot vattnet.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Chicago, conocida tambien como "La ciudad de los ' ||
'fuertes vientos", se extiende a lo largo de m&aacute;s de 100 km de ' ||
'playas localizadas al suroeste del Lago Michigan.  La ciudad es ' ||
'extremadamente calurosa durante el verano, extremadamente fr&iacute;a ' ||
'en el invierno y con mucho viento durante todo el a&ntilde;o.  Sin ' ||
'embargo, es el centro financiero y cultural m&aacute;s importante en ' ||
'Estados Unidos despu&eacute;s de Nueva York, tiene el aeropuerto ' ||
'm&aacute;s activo del mundo, el puerto en tierra firme m&aacute;select ' ||
'grande del mundo, y es uno de los m&aacute;s importantes centros donde ' ||
'convergen carreteras y ferrocarriles de Estados Unidos.  Con numerosos ' ||
'rascacielos recientemente construidos (dos de ellos se encuentran ' ||
'entre los m&aacute;s altos del mundo), Chicago ofrece una espectacular ' ||
'vista a lo largo del Lago.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'Chicago, auch bekannt als die "Windy City" (Stadt der Winde), liegt ' ||
'auf einer L&auml;nge von mehr als 60 Meilen (100 km) an den s&uuml;d-westlichen ' ||
'Ufern des Sees Lake Michigan. Die Stadt ist im Sommer extrem warm, im ' ||
'Winter extrem kalt und der Wind weht das ganze Jahr &uuml;ber. Es ist aber ' ||
'das wichtigste finanzielle und kulturelle Zentrum in den USA nach ' ||
'New York, hat den gr&ouml;&szlig;ten Flughafen der Welt, den gr&ouml;&szlig;ten Binnenhafen ' ||
'und ist eine der wichtigsten Verkehrsknotenpunkten der Vereinigten ' ||
'Staaten. Mit vielen w&auml;hrend der letzten Jahre gebauten Wolkenkratzern (von ' ||
'welchen zwei die h&ouml;chsten Geb&auml;ude der Welt sind), hat Chicago eine ' ||
'beeindruckende Skyline am Ufer des Sees.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'Chicago, ook wel bekend als de "winderige stad", strekt zich uit over meer dan ' ||
'100 km langs de Zuidwest kust van Lake Michigan.  In de zomer is het er ' ||
'extreem warm, in de winter is het er extreem koud en het waait er het hele ' ||
'jaar.  Desalniettemin is deze stad het meest belangrijke financi&euml;le en ' ||
'culturele centrum in de Verenigde Staten na New York.  Bovendien heeft Chicago ' ||
'het meest drukke vliegveld in de wereld, de grootste binnenlandse haven en ' ||
'dient het als het meest belangrijke centrum voor weg- en treinverkeer in de ' ||
'Verenigde Staten.  Met haar vele recent gebouwde wolkenkrabbers (waaronder ' ||
'twee van de hoogste gebouwen in de wereld), heeft Chicago een bijzonder ' ||
'indrukwekkende skyline aan het meer.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'Egalement connue sous le nom de "Ville des vents" ' ||
'(Windy city), Chicago s''&eacute;tend sur plus de 100 km le long du Lac ' ||
'Michigan. S''il y fait extr&egrave;mement chaud en &eacute;t&eacute;, ' ||
'extr&egrave;mement froid en hiver et du vent toute l''ann&eacute;e, ' ||
'Chicago n''en demeure pas moins le plus grand centre financier et ' ||
'culturel des Etats-Unis apr&egrave;s New-York. Son r&eacute;seau ' ||
'routier et ferrovi&egrave;re est &eacute;galement l''un des plus ' ||
'importants du pays, et si son port est le plus grand du monde, son ' ||
'a&eacute;roport est le plus fr&eacute;quent&eacute; qui soit. Ses ' ||
'nombreux gratte-ciels construits ces derni&egrave;res ann&eacute;es, ' ||
'(deux d''entre eux sont les plus hauts du monde) font de Chicago une ' ||
'ville &agrave; l''architecture moderne magnifique et impressionante.';
	description.put(d2);

	d1.name := 'Chicago';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 250;
	d1.duration := 9;
	d1.filename := 'chicago.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'Cincinnati is known as the "Pearl of the West" and the ' ||
'"Queen City" due to its beautiful settings on the north bank of the Ohio ' ||
'River. Since the first white settlers established themselves here in 1788, ' ||
'Cincinnati has grown into a busy industrial city with a wide range of cultural ' ||
'and recreational facilities. The Cincinnati Zoo is famous for its white Bangal ' ||
'tigers and boasts one of the largest insectariums in the world. There are superb ' ||
'views of the city and surrounding valley from the roof of the Carew Tower. The ' ||
'Tylor Davidson Fountain on Fountain Square is the focal point of the city centre.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'Cincinnati &auml;r k&auml;nd som "Pearl of the West" och ' ||
'"Queen City" p.g.a. dess underbara placering p&aring; Ohio flodens norra strand. ' ||
'De f&ouml;rsta vita nybyggarna etablerade sig h&auml;r 1788, och sedan dess har ' ||
'staden utvecklats till en stor industristad med ett stort utbud av kulturella ' ||
'och fritids aktiviteter. Cincinnati Zoo &auml;r ber&ouml;md f&ouml;r sina vita ' ||
'Bengal tigrar och har en av v&auml;rldens st&ouml;rsta insektsamlingar. Fr&aring;n ' ||
'Carew Tower har man en magnifik utsikt &ouml;ver staden och den omkringligande ' ||
'dalen. Tylor Davidson font&auml;nen p&aring; Fountain Square markerar innerstadens ' ||
'mittpunkt.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Cincinnati es conocida como "La Perla del Oeste" y ' ||
'tambi&eacute;n como "La Ciudad Reina" debido a su hermosa ' ||
'ubicaci&oacute;n en la orilla norte del R&iacute;o Ohio.  Desde que ' ||
'los primeros pobladores se establecieron ah&iacute; en 1788, ' ||
'Cincinnati se ha convertido en una importante ciudad industrial con ' ||
'una gran variedad de instalaciones recreativas y culturales.  El ' ||
'Zool&oacute;gico de Cincinnati es famoso por sus tigres de Bengala ' ||
'blancos y por contar con uno de los m&aacute;s grandes insectarios del ' ||
'mundo.  Desde la cima de la Torre Carew, se pueden admirar ' ||
'magn&iacute;ficas vistas de la ciudad y del valle que la rodea.  La ' ||
'Fuente Tylor Davidson en Fountain Square es el punto focal del centro ' ||
'de la ciudad.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'Cincinnati ist wegen seiner sch&ouml;nen Lage am Nordufer des Ohio River ' ||
'als die "Perle des Westens" und die "K&ouml;nigsstadt" bekannt. Seit die ' ||
'ersten Europ&auml;ischen Kolonisten sich hier 1788 niederlie&szlig;en, hat sich ' ||
'Cincinnati zu einer industriellen Stadt mit vielen Freizeit- und  ' ||
'kulturellen M&ouml;glichkeiten entwickelt. Der Cincinnati Zoo ist ber&uuml;hmt f&uuml;r ' ||
'seine wei&szlig;en Bengal Tiger und hat eine der gr&ouml;&szlig;ten Insektariums der Welt. ' ||
'Vom  Carew Tower kann man tolle Aussichten auf die Stadt und das umliegende ' ||
'Tal genie&szlig;en. Der Tylor Davidson Springbrunnen am Fountain Square ist der ' ||
'zentraler Punkt der Stadt.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'Cincinnati staat bekend als de "parel van het Westen" en de "Queen City" door ' ||
'haar schitterende ligging aan de Noord-oever van de Ohio rivier.  Sinds de ' ||
'eerste bewoners zich er vestigden in 1788, is Cincinnati uitgegroeid tot een ' ||
'drukke industri&euml;le stad met vele culturele en recreatieve faciliteiten. ' ||
'De dierentuin van Cincinnati is beroemd voor zijn Bengaalse tijgers en heeft ' ||
'&eacute;&eacute;n van ''s werelds grootste insectaria.  Het dak van de Carew ' ||
'Toren biedt fantastische uitzichten.  De Tyler Davidson fontein en Fountain ' ||
'Square zijn de belangrijkste attracties in het centrum van de stad.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'De par sa situation privil&eacute;gi&eacute;e sur ' ||
'la rive nord de la rivi&egrave;re Ohio, Cincinnati est connue sous les ' ||
'noms de "Perle de l''Ouest" et de "Ville reine" (Queen City). Depuis ' ||
'l''arriv&eacute;e des premiers colons blancs en 1788, Cincinnati s''est ' ||
'd&eacute;velopp&eacute;e en une ville industrielle prosp&egrave;re aux ' ||
'nombreuses facilit&eacute;s culturelles et de loisir. Son zoo est ' ||
'c&eacute;l&egrave;bre pour ses tigres du Bengale et poss&egrave;de ' ||
'l''un des plus grands insectarium du monde. Depuis la Tour Carew, on a ' ||
'une superbe vue de la ville et de la vall&eacute;e environnante. Au ' ||
'centre ville, on se retrouvera autour de la fontaine Tylor Davidson, ' ||
'place Fountain.';
	description.put(d2);

	d1.name := 'Cincinnati';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 199;
	d1.duration := 10;
	d1.filename := 'cincinnati.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'Miami is located on the south-east side of the Florida ' ||
'Peninsula between the Biscayne Bay lagoon and Miami Beach with its huge ' ||
'hotels. Due to its mild winter climate, Miami attracts more than 8 million ' ||
'visitors a year making it a very popular holiday resort.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'Miami ligger p&aring; Florida halv&ouml;ns syd&ouml;stra kust ' ||
'mellan Biscayne Bay och Miami Beach med sina enorma hotel. P.g.a av det mycket ' ||
'milda vinterklimatet lockas &aring;rligen &ouml;ver 8 millioner bes&ouml;kare om ' ||
'&aring;ret, vilket g&ouml;r Miami till en mycket popul&auml;r turistort.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Miami est&aacute; localizada al sureste de la ' ||
'Pen&iacute;nsula de Florida entre la laguna de Bah&iacute;a Biscayne y ' ||
'la Playa de Miami con sus enormes hoteles.  Debido a tener un clima ' ||
'muy agradable durante el invierno, Miami atrae a m&aacute;s de 8 ' ||
'millones de turistas al a&ntilde;o, haci&eacute;ndola un sitio muy ' ||
'popular para vacacionar.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'Miami befindet sich auf der s&uuml;d-&uuml;stlichen Seite der Halbinsel von Florida ' ||
'zwischen der Biscayne Bay Lagune und Miami Beach mit seinen riesigen ' ||
'Hotels. Wegen seines milden Winterklimas zieht Miami j&auml;hrlich &uuml;ber ' ||
'8 millionen besucher.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'Miami, met haar enorme hotels, bevindt zich aan de Zuid-oost kant van het ' ||
'schiereiland Florida, tussen de Biscayne Bay Lagune en Miami Beach.  Door het ' ||
'milde winterklimaat trekt deze populaire vakantiebestemming jaarlijks meer dan ' ||
'8 miljoen bezoekers.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'Situ&eacute;e au sud-est de la p&eacute;ninsule de ' ||
'la Floride entre le lagon de la Baie de Biscane et Miami Beach, Miami ' ||
'attire chaque ann&eacute;e plus de 8 millions de visiteurs, faisant de ' ||
'cette ville au climat hivernal doux un centre de vill&eacute;giature ' ||
'tr&egrave;s pris&eacute;.';
	description.put(d2);

	d1.name := 'Miami';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 599;
	d1.duration := 11;
	d1.filename := 'miami.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'New Orleans is the largest city in the state of Louisiana with ' ||
'a population of 553,000. It lies on the Mississippi, and is world-famous for its ' ||
'Creole and Cajun culture, expressed not only in its marvelous cuisine and ' ||
'festivals, but in many aspects of its way of life. This is also the birthplace ' ||
'of jazz.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'New Orleans &auml;r staten Louisianas st&ouml;rsta stad med ' ||
'553.000 inv&aring;nare. Staden ligger p&aring; Mississippi floden och &auml;r ' ||
'v&auml;rldsber&ouml;md f&ouml;r sin Kreol och Cajun kultur; inte bara den ' ||
'underbara maten och festivalerna, utan &auml;ven som livsstil. H&auml;r ' ||
'f&ouml;ddes jazzen.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Nueva Orleans es la ciudad m&aacute;s grande del ' ||
'Estado de Louisiana con una poblaci&oacute;n de 553,000 habitantes. ' ||
'Esta situada sobre el Mississippi y es conocida mundialmente por su ' ||
'cultura criolla y Cajun que se expresa no solamente en su maravillosa ' ||
'cocina y festivales, sino en muchos aspectos de su estilo de vida. ' ||
'Este es tambi&eacute;n el lugar de nacimiento del jazz.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'New Orleans ist die gr&ouml;&szlig;te Stadt im Staat Louisiana mit 553000 Einwohnern. ' ||
'New Orleans liegt am Mississippi und ist weltbekannt f&uuml;r seine Creole ' ||
'und Cajun Kultur, deren Einflu&szlig; nicht nur in seiner exzellenten K&uuml;che ' ||
'und den Festivals, sonder auch in vielen anderen Aspekten des Lebens zu ' ||
'sehen ist. New Orleans ist der Geburtsplatz des Jazz.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'New Orleans is de grootste stad in de staat Louisiana met 553.000 inwoners. ' ||
'Deze stad gelegen aan de Mississippi is wereldberoemd voor haar Creoolse en ' ||
'Cajun Cultuur die niet alleen te vinden is in de geweldige cuisine en ' ||
'festivals, maar ook in vele andere aspecten van het dagelijkse leven.  New ' ||
'Orleans is tevens de geboorteplaats van de Jazz.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'Avec ses 553 000 habitants, la Nouvelle ' ||
'Orl&eacute;ans est la plus grande ville de l''&eacute;tat de la ' ||
'Louisiane. S''&eacute;tirant sur les rives du Mississipi, la Nouvelle ' ||
'Orl&eacute;ans est connue dans le monde entier pour sa culture cajun ' ||
'et cr&eacute;ole, qui s''exprime non seulement dans sa merveilleuse ' ||
'cuisine mais dans tous les aspects de la vie quotidienne. C''est ici ' ||
'que le jazz a pris naissance.';
	description.put(d2);

	d1.name := 'New Orleans';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 450;
	d1.duration := 10;
	d1.filename := 'neworleans.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'New York City is the largest city in the United States. It is ' ||
'located on the East Coast at the point where the Hudson River and East River ' ||
'flow into Long Island Bay. New York is the world centre of finance and capital, ' ||
'the seat of the United Nations, a cultural Mecca without equal, a mosaic of ' ||
'nations, and a city of extreme social contrasts.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'New York City &auml;r F&ouml;renta Staternas st&ouml;rsta stad. ' ||
'Den ligger p&auml; &Ouml;stkusten d&auml;r Hudson River och East River rinner ut ' ||
'i Long Island Bay. New York &auml;r v&auml;rldscentrum f&ouml;r finans och ' ||
'kapital, F&ouml;renta Nationernas huvuds&auml;te, ett kulturellt Mecca utan like, ' ||
'en mosaic av nationer, och en stad med extrema sociala mots&auml;ttningar.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Nueva York es la ciudad m&aacute;s grande de ' ||
'Estados Unidos.  Est&aacute; localizada en la costa este, en el punto ' ||
'donde le R&iacute;o Hudson y el R&iacute;o East convergen para ' ||
'desembocar en la Bah&iacute;a de Long Island.  Nueva York es el centro ' ||
'financiero mundial y sede de las Naciones Unidas, una meca cultural ' ||
'sin par y una ciudad de contrastes sociales extremos.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'New York City ist die gr&ouml;&szlig;te Stadt in den Vereinigten Staaten und liegt ' ||
'an dem Punkt der Ostk&uuml;ste wo der Hudson River und East River in den ' ||
'Long Island Bay m&uuml;nden. New York ist das finanzielle Zentrum der Welt, ' ||
'der Sitz der Vereinten Nationen, ein  kulturelles Mekka ohne gleichen, ein ' ||
'Mosaik von nationen und eine Stadt von grassen sozialen Kontrasten.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'New York City is de grootste stad in de Verenigde Staten.  De stad ligt aan de ' ||
'Oostkust, op het punt waar de Hudson rivier en de East rivier samenstromen in ' || 
'de Baai van Long Island.  New York is het financi&euml;le centrum van de ' ||
'wereld, de zetel van de Verenigde Naties, een cultureel Mecca dat geen gelijke ' ||
'kent, een mosaiek van naties en een stad van extreme sociale contrasten.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'Situ&eacute;e sur la c&ocirc;te Est &agrave; ' ||
'l''endroit o&ugrave; les rivi&egrave;res Hudson et East se jettent dans ' ||
'la baie de Long Island, New-York est la plus grande ville des ' ||
'Etats-Unis. Centre mondial de la finance, si&egrave;ge des ' ||
'Nations-Unis, New-York est la Mecque culturelle, une mosa&iuml;que de ' ||
'nations, ainsi qu''une ville aux multiples contrastes.';
	description.put(d2);

	d1.name := 'New York City';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 199;
	d1.duration := 8;
	d1.filename := 'newyork.jpg';
	destination.new(d1);
--
	d2.lang_id := 1;
	d2.hype := 'Washington DC is the federal capital of the United States, ' ||
'situated on the East Coast at the junction of the Anacostia and Potomac Rivers. ' ||
'Washington DC is an untypical American city, because it has no skyscrapers (they ' ||
'are prohibited by law). The 20 million annual visitors can see the incarnation ' ||
'of American democracy in stone and the familiar sites, most of which are ' ||
'surprisingly freely accessible. There are many museums, some of which are the ' ||
'most important of their kind in the world.';
	description.new(d2);

	d2.lang_id := 2;
	d2.hype := 'Washington DC &auml;r huvudstaden i USA och ligger p&aring; ' ||
'&Ouml;stkusten d&auml;r Ancostia och Potomac floderna m&ouml;ts. Staden &auml;r ' ||
'otypisk f&ouml;r amerikanska f&ouml;rh&aring;llanden eftersom det inte finns ' ||
'n&aring;gra skyskrapor (de &auml;r f&ouml;rbjudna enligt lag). 20 millioner ' ||
'&aring;rliga bes&ouml;kare kan se inkarnationen av den amerikanska demokratin ' ||
'i sten och de m&aring;nga v&auml;lk&auml;nda byggnaderna, som ofta &auml;r ' ||
'&ouml;ppna f&ouml;r turister. Det finns m&aring;nga museer, varav n&aring;gra ' ||
'&auml;r de viktigaste i v&auml;rlden av sitt slag.';
	description.put(d2);

	d2.lang_id := 3;
	d2.hype := 'Washington DC es la capital federal de Estados ' ||
'Unidos y esta situada en la Costa Este en el punto de uni&oacute;not ' ||
'entre los rios Anacostia y Potomac.  Washington DC es una ciudad ' ||
'americana muy poco com&uacute;n ya que no cuenta con rascacielos ' ||
'(prohibidos por ley).  Los 20 millones de turistas que visitan ' ||
'anualmente esta ciudad, pueden ver la encarnacion de la democracia ' ||
'americana en monumentos de piedra y en otros lugares t&iacute;picos ' ||
'que, sorpresivamente, son f&aacute;cilmente accesibles.  Hay muchos ' ||
'museos, algunos de los cuales son los m&aacute;s importantes en su ' ||
'g&eacute;nero en todo el mundo.';
	description.put(d2);

	d2.lang_id := 4;
	d2.hype := 'Washington DC ist die federale Stadt der Vereinigten Staaten und liegt ' ||
'an der Ostk&uuml;ste an der m&uuml;ndung der Fl&uuml;sse Anacostia und Potomac. ' ||
'Da Washington DC keine Wolkenkratzer hat (sie sind gesetzlich verboten), ' ||
'ist es eine untypische Amerikanische Stadt. Die j&auml;hrlich 20 Millionen  ' ||
'Besucher k&ouml;nnen die Inkarnation der Amerikanischen Demokratie und andere ' ||
'bekannte Sehensw&uuml;rdigkeiten, die &uuml;berraschend zug&auml;nglich sind, sehen. Es ' ||
'gibt viele Museen, von welchen manche zu den wichtigsten der Welt auf ihrem ' ||
'Gebiet z&auml;hlen.';
	description.put(d2);

	d2.lang_id := 5;
	d2.hype := 'Washington DC is de federale hoofdstad van de Verenigde Staten, gelegen op het ' ||
'kruispunt van de Anacostia rivier en de Potomac rivier.  Washington DC is een ' ||
'ongewone Amerikaanse stad, omdat er geen wolkenkrabbers te vinden zijn (deze ' ||
'zijn bij de wet verboden).  Jaarlijks telt Washington DC 20 miljoen bezoekers ' ||
'die komen om de geboorte van de Amerikaanse democratie te bezichtigen in de ' ||
'vorm van vele musea en bezienswaardigheden die allemaal verbazingwekkend ' ||
'makkelijk toegangkelijk zijn.  Vele musea zijn de belangrijkste in hun soort ' ||
'in de wereld.';
	description.put(d2);

	d2.lang_id := 6;
	d2.hype := 'Capitale f&eacute;d&eacute;rale des Etats-Unis, ' ||
'Washington est situ&eacute;e sur la c&ocirc;te Est au confluent des ' ||
'rivi&egrave;res Anacostia et Potomac. Ville am&eacute;ricaine assez ' ||
'atypique, elle ne compte aucun gratte-ciel (interdit par la loi). Ses ' ||
'quelque 20 millions de visiteurs annuels se pressent chaque ' ||
'ann&eacute;e pour visiter ses nombreux monuments, symboles de la ' ||
'd&eacute;mocratie am&eacute;ricaine. Washington compte aussi de ' ||
'nombreux mus&eacute;es, dont certains les plus importants du monde.';
	description.put(d2);

	d1.name := 'Washington DC';
	d1.desc_id := d2.id;
	d1.country := 'USA';
	d1.rec_price := 300;
	d1.duration := 10;
	d1.filename := 'washington.jpg';
	destination.new(d1);
end;
/

commit;

rem
rem Scheduled events
rem

declare
	ev event_data%rowtype;
	de destination_data%rowtype;
begin
	for i in 1..30 loop
		for j in 1..7 loop
			de := destination.get(j);
			ev.dest_id := de.id;
			ev.fly_out := trunc(sysdate) + ((i *7) + j );
			ev.persons := 300;
			ev.isle_seat := 100;
			ev.wind_seat := 100;
			ev.sm_isle_seat := 50;
			ev.sm_wind_seat := 50;
			ev.booked := 0;
			ev.price := de.rec_price * (50+random.rndint(50))/100;
			event.new(ev);
		end loop;
	end loop;
end;
/

declare
	di dest_img_data%rowtype;
	de destination_data%rowtype;
	x number(3);
	dummy number;
begin
	de := destination.get('Chicago');
	di.dest_id := de.id;
	for x in 230001..230024 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('Cincinnati');
	di.dest_id := de.id;
	for x in 240001..240007 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('Miami');
	di.dest_id := de.id;
	for x in 520001..520006 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('New Orleans');
	di.dest_id := de.id;
	for x in 590001..590014 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('New York City');
	di.dest_id := de.id;
	for x in 606001..606032 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('San Francisco');
	di.dest_id := de.id;
	for x in 770001..770027 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
--
	de := destination.get('Washington DC');
	di.dest_id := de.id;
	for x in 930001..930009 loop
		di.filename := to_char(x) || '.jpg';
		dummy := dimg.new(di);
	end loop;
end;
/

commit;
