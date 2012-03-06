# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/test_helper.rb'

class TestCalScraper < Test::Unit::TestCase

  def setup
    @scraper = SentrumAikido::AikidoNoScraper.new
  end
  
  def test_get_calendar_src
    testcal = @scraper.get_calendar_src
    assert testcal =~ /table/, "Expected naf cal page to include table tag"
    assert testcal =~ /body/, "Expected naf cal page to include body tag"
    assert testcal =~ /html/, "Expected naf cal page to include html tag"
    assert testcal =~ /month/, "Expected naf cal page to include at least one tag with 'month' class"
    assert testcal =~ /activity/, "Expected naf cal page to include at least one tag with 'activity' class"
  end
  
  def test_create_table_row
    activity = {:time => "12:00", :place => "Teststed", :activity => "Testaktivitet", 
      :arranger => "Testarrangoer", :contact => "Testkontakt", :moreinfo => "Testinfo"}
    activities = [activity]
    row = @scraper.create_table_rows(activities)
    assert row =~ /Teststed|Testaktivitet|Testkontakt/
    assert_equal "<tr class=\"list-line-odd\"><td>12:00</td><td>Teststed</td><td>Testaktivitet</td><td>Testkontakt</td><td></td></tr>\n", row
  end
  
  def test_get_month_chunks
    months = @scraper.get_month_chunks(test_calendar_src)
    assert_equal 11, months.length, "Expected 11 month chunks, march-january"
  end
  
  def test_process_activity
    a =  @scraper.process_activity(test_activity_chunk, "april")
    assert a[:time] =~ /11-12. april/, "time value wrong"
    assert a[:place] =~/Aikidojo, Hoffsveien 9/, "place value wrong"
    assert a[:activity] =~ /Seminar med Birger/, "activity value wrong"
    assert a[:contact] =~ /info@aikidojo.no/, "contact value wrong"
    assert a[:moreinfo] =~ /www.aikidojo.no/, "info value wrong"
  end
  
  def test_process_month
    m = @scraper.process_month(test_month_chunk)
    assert_equal 4, m.length, "Expected result of month chunk processing to be 4 activity hashmaps"
    m.each { |a| assert(a[:time] =~ /april/, "Expected all activites to have april suffix in time field")  }
  end
  
  def test_process_calendar
    activites = @scraper.process_calendar(test_calendar_src)
  end
  
  def test_format_error
    error = "test error msg"
    returned = @scraper.format_error(error)
    assert returned =~ /#{error}/, "Expected error message"
  end

  def test_scrape_calendar
    scraped = @scraper.scrape_calendar()
    
    assert scraped =~ /table/, "Expected table in scraped calendar"
    assert scraped =~ /Tidspunkt/, "Expected 'tidspunkt' string in scraped calendar"
    assert scraped =~ /uttrekk/, "Expected 'uttrekk' string in scraped calendar"
  end

  def test_shorten_url
    expected = "xyz <a class=\"info\" href=\"http://www.kashima.no\">les mer</a>"
    actual = @scraper.shorten_url("xyz <a class=\"info\" href=\"http://www.kashima.no\">http://www.kashima.no</a>")
    assert_equal expected, actual, "Expected result to contain shortened url"

    expected = ""
    actual = @scraper.shorten_url("<a class=\"info\" href=\"http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86\">http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86</a>")
    assert_equal expected, actual
  end
  

  def test_shorten_mail_adr
    expected = "xyz <a href=\"mailto:thomas@ninjastic.net\">email</a>"
    actual = @scraper.shorten_mail_adr("xyz thomas@ninjastic.net")
    assert_equal expected, actual, "Expected result to contain mailto element"

    expected =  "xyz <a href=\"mailto:thomas ved ninjastic.net\">email</a>"
    actual = @scraper.shorten_mail_adr("xyz thomas ved ninjastic.net")
    assert_equal expected, actual, "Expected result to contain mailto element"
  end



  def test_activity_chunk
    return <<ACTIVITY
  <td class="activity">			 
<table border="0">

<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Birger Sørensen 5.dan</b></td></tr>
<tr><td class="activitylegend">Når:</td><td class="activity">
11-12.	</td></tr>
<tr><td class="activitylegend">Sted:</td><td class="activity">Aikidojo, Hoffsveien 9 (3.etg) 0275 Oslo. (over flisekompaniet)</td></tr>
<tr><td class="activitylegend">Arrangør:</td><td class="activity">Aikidojo</td></tr>

<tr><td class="activitylegend">Kontakt:</td><td class="activity">info@aikidojo.no</td></tr>
<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.aikidojo.no/Flyers/birger.pdf">http://www.aikidojo.no/Flyers/birger.pdf</a></td></tr>
</table>
</td></tr>						
  	  			<tr><td class="activity">
ACTIVITY
    
  end




  def test_month_chunk
    return <<MONTH
  <td class="month"><b>April</b></td></tr>

			<tr><td class="activity">			 
<table border="0">
<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Aikidoseminar med Erik Vanem.</b></td></tr>
<tr><td class="activitylegend">Når:</td><td class="activity">
04-06.	</td></tr>
<tr><td class="activitylegend">Sted:</td><td class="activity">Trondheim, Dragvoll Idrettssenter</td></tr>

<tr><td class="activitylegend">Arrangør:</td><td class="activity">Trondheim Aikidoklubb</td></tr>
<tr><td class="activitylegend">Kontakt:</td><td class="activity">sverre.johnsen@trondheimaikido.no</td></tr>
<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.trondheimaikido.no/vanem08.pdf">http://www.trondheimaikido.no/vanem08.pdf</a></td></tr>
</table>
</td></tr>						
  	  			<tr><td class="activity">&nbsp;</td></tr>

			<tr><td class="activity">			 
<table border="0">

<tr><td class="activitylegend">Hva:</td><td class="activity"><b>BUDOSEMINAR med Bjørn Eirik Olsen 6.dan.  
Velkommen til en aikidoleir med fokus på sverd, mental utvikling mykhet og styrking av hara. Ta med bokken.  
Ingen påmelding nødvendig.   

</b></td></tr>
<tr><td class="activitylegend">Når:</td><td class="activity">
05-06.	</td></tr>
<tr><td class="activitylegend">Sted:</td><td class="activity">hos Oslo Karateklubb, Brinken 20, 0654 Oslo</td></tr>
<tr><td class="activitylegend">Arrangør:</td><td class="activity">Tenshinkan Aikidoklubb</td></tr>

<tr><td class="activitylegend">Kontakt:</td><td class="activity">post ved tenshinkan.aikido.no</td></tr>
<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86">http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86</a></td></tr>
</table>
</td></tr>						
  	  			<tr><td class="activity">&nbsp;</td></tr>

			<tr><td class="activity">			 
<table border="0">

<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Birger Sørensen 5.dan</b></td></tr>
<tr><td class="activitylegend">Når:</td><td class="activity">
11-12.	</td></tr>
<tr><td class="activitylegend">Sted:</td><td class="activity">Aikidojo, Hoffsveien 9 (3.etg) 0275 Oslo. (over flisekompaniet)</td></tr>
<tr><td class="activitylegend">Arrangør:</td><td class="activity">Aikidojo</td></tr>

<tr><td class="activitylegend">Kontakt:</td><td class="activity">info@aikidojo.no</td></tr>
<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.aikidojo.no/Flyers/birger.pdf">http://www.aikidojo.no/Flyers/birger.pdf</a></td></tr>
</table>
</td></tr>						
  	  			<tr><td class="activity">&nbsp;</td></tr>

			<tr><td class="activity">			 
<table border="0">
<tr><td class="activitylegend">Hva:</td><td class="activity"><b>BARNEAIKIDO: seminar i hvordan legge tilrette for barnetrening innen aikido.

Teori og praktiske øvelser basert på mangeårig erfaring med \"budo og barn\" innen Kampsportforbundet, og den erfaring som våre pioner-klubber sitter med.

(Foreløpig dato, og detaljert program kommer senere)</b></td></tr>

<tr><td class="activitylegend">Når:</td><td class="activity">
19-20.	</td></tr>
<tr><td class="activitylegend">Sted:</td><td class="activity">Oslo</td></tr>
<tr><td class="activitylegend">Arrangør:</td><td class="activity">Norges Aikidoforbund og Norges Kampsportforbund</td></tr>
<tr><td class="activitylegend">Kontakt:</td><td class="activity">naf-styret@aikido.no</td></tr>

<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href=""></a></td></tr>
</table>
</td></tr>						
  	  			<tr><td class="activity">&nbsp;</td></tr>
<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
	<tr><td class="month">
MONTH

  end










  def test_calendar_src
    return <<PAGESRC
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;>charset=iso-8859-1" />
<title>www.aikido.no</title>
<meta name="description" content="Mambo - the dynamic portal engine and content management system" />
<meta name="keywords" content="mambo, Mambo" />
<meta name="Generator" content="Joomla! - Copyright (C) 2005 - 2007 Open Source Matters. All rights reserved." />
<meta name="robots" content="index, follow" />
	<link rel="shortcut icon" href="http://www.aikido.no/images/favicon.ico" />
	<link rel="stylesheet" href="http://www.aikido.no/templates/aikido/css/template_css.css" type="text/css"/><link rel="shortcut icon" href="http://www.aikido.no/images/favicon.ico" /><style type="text/css">
<!--
.style1 {font-size: 36px}
.style3 {font-size: 14px}
.style4 {
	font-size: 24px;
	font-weight: bold;
}
.style6 {font-size: 36px; font-family: Castellar; }
-->
</style>

	<link href="http://www.aikido.no/modules/mod_lxmenu/css_lxmenu.css" rel="stylesheet" type="text/css"/> </head>


<body>
<table class="outer" width="100%"  border="0">
  <tr>
    <td>
	  <table width="100%" border="0" background="templates/aikido/images/header_bg.jpg">
      <tr>
        <td width="21%"><p>&nbsp;</p>
          <p>&nbsp;</p></td>
		  
        <td width="79%"><div align="center"><span class="style1"></span></div></td>

      </tr>
	  <tr>
	  <td><div align="center">
	    <p>&nbsp;</p>
	    <p>&nbsp;</p><p>
	  </div></td>
	  <td></td>
	  </tr>
      </table>

	 </td>
  </tr>
</table>
<table class="outer" width="100%"  border="0">
  <tr>
    <td><table class="outer" border="0" width="100%">
      <tr>
        <td width="200" height="2000" bgcolor="#cecece"  valign="top">
					<table cellpadding="0" cellspacing="0" class="moduletable">
				<tr>

			<td>
				
<script type="text/javascript" src="modules/mod_lxmenu/functions.js"></script>
<script type="text/javascript" src="modules/mod_lxmenu/menu.js"></script>
<script type="text/javascript" src="modules/mod_lxmenu/pos_lxmenu.js"></script>
<script type="text/javascript">
var mainmenu_MENU_ITEMS = [

['Forside aikido.no','http://www.aikido.no/index.php?option=com_frontpage&amp;Itemid=1',{'tw':'0','sb':'Forside aikido.no'}],
['Hva er Aikido?','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=17&amp;Itemid=31',{'tw':'0','sb':'Hva er Aikido?'}],
['Arkiv','http://www.aikido.no/index.php?option=com_content&amp;task=section&amp;id=6&amp;Itemid=53',{'tw':'0','sb':'Arkiv'}],
['Galleri','http://www.aikido.no/index.php?option=com_mambospgm&amp;Itemid=39',{'tw':'0','sb':'Galleri'}],
['Lenker','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=24&amp;Itemid=44',{'tw':'0','sb':'Lenker'}],
['Søk','http://www.aikido.no/index.php?option=com_search&amp;Itemid=5',{'tw':'0','sb':'Søk'}],
['Om aikido.no','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=28&amp;Itemid=48',{'tw':'0','sb':'Om aikido.no'}],
['Kalender','http://www.aikido.no/index.php?option=com_oskalendar&amp;Itemid=54',{'tw':'0','sb':'Kalender'}],
['Norges Aikido Forbund','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=12&amp;Itemid=26',{'tw':'0','sb':'Norges Aikido Forbund'},

['NAF Styret','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=13&amp;Itemid=27',{'tw':'0','sb':'NAF Styret'}],
['NAF Teknisk komite','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=14&amp;Itemid=28',{'tw':'0','sb':'NAF Teknisk komite'}],
['NAF Klubber','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=18&amp;Itemid=32',{'tw':'0','sb':'NAF Klubber'}],
['NAF Gradering','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=25&amp;Itemid=45',{'tw':'0','sb':'NAF Gradering'}],
['NAF Skjemaer og dokumenter','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=15&amp;Itemid=29',{'tw':'0','sb':'NAF Skjemaer og dokumenter'}],
['NAF Økonomi','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=19&amp;Itemid=36',{'tw':'0','sb':'NAF Økonomi'}],
['NAF Statutter','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=20&amp;Itemid=37',{'tw':'0','sb':'NAF Statutter'}],
['NAF Referater','http://www.aikido.no/index.php?option=com_content&amp;task=category&amp;sectionid=4&amp;id=17&amp;Itemid=40',{'tw':'0','sb':'NAF Referater'}],
['NAF Til Japan','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=27&amp;Itemid=46',{'tw':'0','sb':'NAF Til Japan'}],
['Dokumenter','http://www.aikido.no/index.php?option=com_docman&amp;Itemid=58',{'tw':'0','sb':'Dokumenter'}],],
['Aikikan Norge','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=16&amp;Itemid=30',{'tw':'0','sb':'Aikikan Norge'},

['Aikikan Lenker','http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=29&amp;Itemid=49',{'tw':'0','sb':'Aikikan Lenker'}],],
];
</script>
<div id="mainmenu_menu" style="position:relative; top:0px; width:200px; left:0px; height:200px;">
<script type="text/javascript">
new menu (mainmenu_MENU_ITEMS, mainmenu_MENU_POS);
</script>
</div>
<noscript>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_frontpage&amp;Itemid=1" class="mainlevel" >Forside aikido.no</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=17&amp;Itemid=31" class="mainlevel" >Hva er Aikido?</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=section&amp;id=6&amp;Itemid=53" class="mainlevel" >Arkiv</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_mambospgm&amp;Itemid=39" class="mainlevel" >Galleri</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=24&amp;Itemid=44" class="mainlevel" >Lenker</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_search&amp;Itemid=5" class="mainlevel" >Søk</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=28&amp;Itemid=48" class="mainlevel" >Om aikido.no</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_oskalendar&amp;Itemid=54" class="mainlevel" id="active_menu">Kalender</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=12&amp;Itemid=26" class="mainlevel" >Norges Aikido Forbund</a></td></tr>
<tr align="left"><td><a href="http://www.aikido.no/index.php?option=com_content&amp;task=view&amp;id=16&amp;Itemid=30" class="mainlevel" >Aikikan Norge</a></td></tr>
</table>
</noscript>			</td>

		</tr>
		</table>
					<table cellpadding="0" cellspacing="0" class="moduletable">
				<tr>
			<td>
				<p>&nbsp;</p><p>&nbsp;</p><table border="0" width="185" height="179"><tbody><tr><td style="border: 1px solid #000000"><strong>Du kan bidra p&aring; aikido.no</strong><br /><br />Alle som brenner for aikido kan v&aelig;re med &aring; bidra p&aring; denne siden.<br />Har du v&aelig;rt p&aring; leir? <br />Har du noe p&aring; hjertet?<br />Vi tar gjerne imot tekst<br />og bilder fra deg.<br /><br />Send en e-post til: <br />

 <script language='JavaScript' type='text/javascript'>
 <!--
 var prefix = '&#109;a' + 'i&#108;' + '&#116;o';
 var path = 'hr' + 'ef' + '=';
 var addy97308 = 'r&#101;d&#97;ksj&#111;n' + '&#64;';
 addy97308 = addy97308 + '&#97;&#105;k&#105;d&#111;' + '&#46;' + 'n&#111;';
 document.write( '<a ' + path + '\'' + prefix + ':' + addy97308 + '\'>' );
 document.write( addy97308 );
 document.write( '<\/a>' );
 //-->\n </script><script language='JavaScript' type='text/javascript'>
 <!--
 document.write( '<span style=\'display: none;\'>' );
 //-->
 </script>Denne e-postadressen er beskyttet mot programmer som samler e-postadresser, du må slå på Javascript for å kunne se den.
 <script language='JavaScript' type='text/javascript'>
 <!--
 document.write( '</' );
 document.write( 'span>' );
 //-->
 </script></td></tr></tbody></table><p><strong><br /></strong></p>			</td>
		</tr>
		</table>
				<table cellpadding="0" cellspacing="0" class="moduletable">
				<tr>
			<td>

					<form action="http://www.aikido.no/index.php" method="post" name="login" >
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<label for="mod_login_username">
				Brukernavn			</label>
			<br />
			<input name="username" id="mod_login_username" type="text" class="inputbox" alt="username" size="10" />

			<br />
			<label for="mod_login_password">
				Passord			</label>
			<br />
			<input type="password" id="mod_login_password" name="passwd" class="inputbox" size="10" alt="password" />
			<br />
			<input type="checkbox" name="remember" id="mod_login_remember" class="inputbox" value="yes" alt="Remember Me" />
			<label for="mod_login_remember">

				Husk meg			</label>
			<br />
			<input type="submit" name="Submit" class="button" value="Logg inn" />
		</td>
	</tr>
	<tr>
		<td>
			<a href="http://www.aikido.no/index.php?option=com_registration&amp;task=lostPassword">

				Glemt passordet?</a>
		</td>
	</tr>
		</table>
	
	<input type="hidden" name="option" value="login" />
	<input type="hidden" name="op2" value="login" />
	<input type="hidden" name="lang" value="norwegian" />
	<input type="hidden" name="return" value="http://www.aikido.no/index.php?option=com_oskalendar&amp;Itemid=54" />

	<input type="hidden" name="message" value="0" />
	<input type="hidden" name="force_session" value="1" />
	<input type="hidden" name="j4aed35fec3f13932989a126633fe22a9" value="1" />
	</form>
				</td>
		</tr>
		</table>
		         </td>
        <td width="764" valign="top">	
	<table border="0" width="100%">

	<tr>
	<td class="title"><b>Aktiviteter de neste 12 måneder</b></td>
	<td class="activity"><a href="index.php?option=com_oskalendar&new=true">[Meld inn aktivitet]</a></td>
	</tr>
	
				<tr><td class="month"><b>Mars</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Jorma Lyly, 5. Dan.</b></td></tr>

	<tr><td class="activitylegend">Når:</td><td class="activity">
07-09.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Sunyata Aikido Dojo, Oslo</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Sunyata</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">mouliko@start.no eller mobil: 93027309</td></tr>

	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.sunyata-aikido.org/seminars/leir-jorma-mars-2008.html">http://www.sunyata-aikido.org/seminars/leir-jorma-mars-2008.html</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Erik Vanem 3. dan Aikikai</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">

14-16.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Kampsport Instuttet, Stavanger</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Stavanger Aikido</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">araviglione@gmail.com</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://aikidude.files.wordpress.com/2008/02/erik_vanem_200803.pdf">http://aikidude.files.wordpress.com/2008/02/erik_vanem_200803.pdf</a></td></tr>

	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Fudoshinkan Hamar og Hadeland har den glede av å invitetere for 4. gang til seminar med Sensei George Koliopoulos (5. dan Aikikai) på på Vestoppland Folkehøgskole. 
Det blir også Bokken Dori og JoDori trening og det oppfordres derfor til å ta med seg Bokken og Jo. Det vil bli fokus på KI utviklingsøvelser, KI Breathing etc. 
Se hjemmeside Fudoshinkan Hadeland for flere opplysniger.
</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
15-16.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Vestoppland Folkehøgskole, Brandbu</td></tr>

	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Fudoshinkan Hamar og Hadeland</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">jensmartinsen@hotmail.com</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.fudoshinkan.net/hadeland_new/Seminar_George2008.pdf">http://www.fudoshinkan.net/hadeland_new/Seminar_George2008.pdf</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>

				<tr><td class="month"><b>April</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Aikidoseminar med Erik Vanem.</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
04-06.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Trondheim, Dragvoll Idrettssenter</td></tr>

	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Trondheim Aikidoklubb</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">sverre.johnsen@trondheimaikido.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.trondheimaikido.no/vanem08.pdf">http://www.trondheimaikido.no/vanem08.pdf</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">

	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>BUDOSEMINAR med Bjørn Eirik Olsen 6.dan.  
Velkommen til en aikidoleir med fokus på sverd, mental utvikling mykhet og styrking av hara. Ta med bokken.  
Ingen påmelding nødvendig.   

</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
05-06.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">hos Oslo Karateklubb, Brinken 20, 0654 Oslo</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Tenshinkan Aikidoklubb</td></tr>

	<tr><td class="activitylegend">Kontakt:</td><td class="activity">post ved tenshinkan.aikido.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86">http://www.kashima.no/index.php?option=com_content&view=article&id=61&Itemid=86</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">

	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Birger Sørensen 5.dan</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
11-12.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Aikidojo, Hoffsveien 9 (3.etg) 0275 Oslo. (over flisekompaniet)</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Aikidojo</td></tr>

	<tr><td class="activitylegend">Kontakt:</td><td class="activity">info@aikidojo.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.aikidojo.no/Flyers/birger.pdf">http://www.aikidojo.no/Flyers/birger.pdf</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>BARNEAIKIDO: seminar i hvordan legge tilrette for barnetrening innen aikido.

Teori og praktiske øvelser basert på mangeårig erfaring med \"budo og barn\" innen Kampsportforbundet, og den erfaring som våre pioner-klubber sitter med.

(Foreløpig dato, og detaljert program kommer senere)</b></td></tr>

	<tr><td class="activitylegend">Når:</td><td class="activity">
19-20.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Oslo</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Norges Aikidoforbund og Norges Kampsportforbund</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">naf-styret@aikido.no</td></tr>

	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href=""></a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>Mai</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Leir med Frank Ostoff 5.dan</b></td></tr>

	<tr><td class="activitylegend">Når:</td><td class="activity">
02-04.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Trondheim </td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">NTNUI Aikido Tekisuikan</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">silje.skrede ved gmail.com</td></tr>

	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.tekisuikan.org">http://www.tekisuikan.org</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Philippe Orban 6.dan hos Aikikan Oslo.
Gratis overnatting i dojo.</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">

09-11.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Aikikan Oslo, Konghellegt.3, 0569 Oslo</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Aikikan Oslo</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">kontakt@aikikanoslo.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.aikikanoslo.no">http://www.aikikanoslo.no</a></td></tr>

	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Oslo Aikido Festival 2008</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
30-01.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Oslo</td></tr>

	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Oslo Aikido Klubb</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">erik@osloaikido.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.osloaikido.no">http://www.osloaikido.no</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>

				<tr><td class="month"><b>Juni</b></td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>Juli</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Summercamp 2008 with Suganuma sensei.

Seminar at Brandbu, 70 km north of Oslo. 

 </b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">

12-17.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Brandbu, Vestoppland folkehøgskole</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">The Norwegian Aikido Federation</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity"></td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href=""></a></td></tr>
	</table>

</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>August</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Treningsleir med Inaba Sensei fra Meiji Jingu Shiseikan i Tokyo. Fokus vil bli på sverdtrening (Kashima Shinryu) og essensen av Budo.</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">

02-08.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Brandbu (VOFHS)</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Kashima-utøvere i NAF</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">info@kashima.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.kashima.no">http://www.kashima.no</a></td></tr>

	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>September</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Harstad Aikido klubb inviterer til trenings helg med Jiri Marek (en av Nishio-sensei elever,   4.dan Aikikai, og 3.dan Aikido Toho Iai) og AIKIDO TOHO IAI.

*Aikido Toho Iai er grundlagt af Shoji Nishio for at fremme forståelsen af sammenhængen mellem aikido og brugen af det japanske sværd (katana). Stilen består af iaido-lignende kata, hvoraf de fleste direkte kan relateres til specifikke aikidoteknikker. Der trænes også partnerøvelser af typen ken-tai-ken (sværd mod sværd) og ken-tai-jo (sværd mod stav), hvor sværdet dog er i form af en bokken. Disse øvelser er også en del af aikido-pensum og således er med til at integrere de to discipliner.(Wikipedia.org)</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">

12-14.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Harstad</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Harstad Aikido klubb</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">harstadaikidoklubb@verolak.info</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.harstadaikido.org/nedlasting/HAK-ATI-seminar-no.pdf">http://www.harstadaikido.org/nedlasting/HAK-ATI-seminar-no.pdf</a></td></tr>

	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>JAPAN 2008: 
Vi reiser sammen til Japan for å trene på Hombu Dojo i Tokyo og delta på IAF seminar i Tanabe</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
27-12.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Tokyo</td></tr>

	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Oslo Aikido Klubb</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">erik@osloaikido.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.osloaikido.no">http://www.osloaikido.no</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>

				<tr><td class="month"><b>Oktober</b></td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Donovan Waite, 7.dan shihan Aikikai</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
10-12.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">NJJK (Norsk Judo og Jiu-jitsu klubb) Haugerud Skole, Tvetenveien 183, 0673 Oslo </td></tr>

	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Aikidojo</td></tr>
	<tr><td class="activitylegend">Kontakt:</td><td class="activity">info@aikidojo.no</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.aikidojo.no">http://www.aikidojo.no</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
	 
 						<tr><td class="activity">			 
	<table border="0">

	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Frank Ostoff 5. dan.</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
31-02.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Oslo</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">Sentrum Aikido</td></tr>

	<tr><td class="activitylegend">Kontakt:</td><td class="activity">tor.gaarder@gmail.com   Tlf: 95248050</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.sentrumaikido.org/kalender.php">http://www.sentrumaikido.org/kalender.php</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>November</b></td></tr>

	 
 						<tr><td class="activity">			 
	<table border="0">
	<tr><td class="activitylegend">Hva:</td><td class="activity"><b>Leir med Jan Nevelius 6.dan</b></td></tr>
	<tr><td class="activitylegend">Når:</td><td class="activity">
14-16.	</td></tr>
	<tr><td class="activitylegend">Sted:</td><td class="activity">Trondheim</td></tr>
	<tr><td class="activitylegend">Arrangør:</td><td class="activity">NTNUI Aikido Tekisuikan</td></tr>

	<tr><td class="activitylegend">Kontakt:</td><td class="activity">silje.skrede@gmail.com</td></tr>
	<tr><td class="activitylegend">Mer info:</td><td class="activity"><a class="info" href="http://www.tekisuikan.org">http://www.tekisuikan.org</a></td></tr>
	</table>
</td></tr>						
  		  	  			<tr><td class="activity">&nbsp;</td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>Desember</b></td></tr>

			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>Januar</b></td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
				<tr><td class="month"><b>Februar</b></td></tr>
			<tr><td class="separator" colspan="4" bgcolor="#cecece"></td></tr>
		</table>
	
	<br>

	
	
	<table width="100%">
	<tr><td class="title"><b>Aktiviteter lenger frem i tid</b></td></tr>
		</table>
	</td>
        <td width="200" bgcolor="#cecece" valign="top">
          		<table cellpadding="0" cellspacing="0" class="moduletable">
				<tr>
			<td>

					 	<div align="center">
		 			 	<img src="http://www.aikido.no/images/aikido/random/summer camp 2005  Brandbu   014.jpg" border="0" width="190" height="142" alt="summer camp 2005  Brandbu   014.jpg" /><br />
		 		 	</div>
	  				</td>
		</tr>
		</table>
				<table cellpadding="0" cellspacing="0" class="moduletable">
				<tr>
			<td>

				<table border="0" width="222" height="296"><tbody><tr><td style="border: 1px solid #000000"><strong>SUMMER CAMP 2008 WITH SUGANUMA SENSEI!</strong><br /><br />The Norwegian Aikido Federation<br />is happy to invite you to the<br />Annual Aikido Summercamp at Brandbu from Saturday July 12th - Thursday July 17th 2008. <br />As usual Suganuma Sensei (8th Dan) will visit Norway to conduct the last two days, while NAF&#39;s Technical Director, Bj&oslash;rn Eirik Olsen (6th Dan), will be responsible for the first four days.<br />Visiting senior teachers from Norway and abroad will be invited to teach some classes.<br />All aikido practitioners are welcome.<br /><br /><strong>The Norwegian Aikido Federation</strong></td></tr></tbody></table><strong><br /></strong>			</td>
		</tr>
		</table>

				          </td>
      </tr>
    </table></td>
  </tr>
</table>
<table class="outer" width="100%"  border="0">
  <tr>
    <td><div align="center"></div></td>
  </tr>
</table>

</body>
</html>
<!-- 1204659782 -->
PAGESRC
end

end



