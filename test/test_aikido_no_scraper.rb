# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/test_helper.rb'

class TestCalScraper < Test::Unit::TestCase


  def setup
    @scraper = SentrumAikido::AikidoNoScraper.new
  end

  def test_get_calendar_json()
    testcal = @scraper.get_calendar_json("http://aikido.no/api/v1/event/?username=thomas.kjeldahl.nilsson&api_key=e6416d24107a8fdb010d4d43b226f5d4bb69a410")
    assert testcal =~ /objects/, "Expected naf cal page to include objects"
    assert testcal =~ /arranger/, "Expected naf cal page to include arrangers"
  end

  def test_create_table_row
    activity = {:time => "12:00", :place => "Teststed", :activity => "Testaktivitet",
      :arranger => "Testarrangoer", :contact => "Testkontakt", :moreinfo => "Testinfo"}
    activities = [activity]
    row = @scraper.create_table_rows(activities)
    assert row =~ /Teststed|Testaktivitet|Testkontakt/
    expected_row_content = "<tr class=\"list-line-odd\"><td>12:00</td><td>Teststed</td><td>Testaktivitet... </td><td>Testkontakt</td></tr>\n"
    assert_equal expected_row_content, row
  end

  def test_format_error
    error = "test error msg"
    returned = @scraper.format_error(error)
    assert returned =~ /#{error}/, "Expected error message"
  end

  def test_scrape_calendar
    scraped = @scraper.scrape_calendar()

    #assert scraped =~ /table/, "Expected table in scraped calendar"
    #assert scraped =~ /Tidspunkt/, "Expected 'tidspunkt' string in scraped calendar"
    #assert scraped =~ /uttrekk/, "Expected 'uttrekk' string in scraped calendar"
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


  ### TESTDATA ####

  def test_calendar_json
    return <<JSON
{
   "meta":{
      "limit":20,
      "next":"/api/v1/event/?username=thomas.kjeldahl.nilsson&api_key=e6416d24107a8fdb010d4d43b226f5d4bb69a410&limit=20&offset=20",
      "offset":0,
      "previous":null,
      "total_count":38
   },
   "objects":[
      {
         "arranger":{
            "city":"Heggedal",
            "email":"",
            "name":"Sunyata Aikido Dojo Heggedal",
            "phone":"",
            "position":"59.7852933,10.434072",
            "resource_uri":"/api/v1/club/1/"
         },
         "contact":"mouliko@online.no",
         "end":"2013-06-09",
         "location":null,
         "resource_uri":"/api/v1/event/1/",
         "start":"2013-06-06",
         "title":"Aikido Summer Camp with Mouliko HalÃ©n, Jorma Lyly and Mats Ahlin"
      },
      {
         "arranger":{
            "city":"Bergen",
            "email":"post@bergen-aikidoklubb.com",
            "name":"Bergen Aikidoklubb",
            "phone":"95014938",
            "position":"60.3912628,5.3220544",
            "resource_uri":"/api/v1/club/2/"
         },
         "contact":"steffenwikan@gmail.com",
         "end":"2013-06-23",
         "location":null,
         "resource_uri":"/api/v1/event/2/",
         "start":"2013-06-21",
         "title":"Seminar med Dimitris Farmakidis 3. Dan Aikikai."
      },
      {
         "arranger":{
            "city":"Brandbu",
            "email":null,
            "name":"Norges Aikido Forbund",
            "phone":null,
            "position":"60.4186361,10.4996659",
            "resource_uri":"/api/v1/club/3/"
         },
         "contact":"kjetil.hatlebrekke@hotmail.com",
         "end":"2013-07-11",
         "location":null,
         "resource_uri":"/api/v1/event/3/",
         "start":"2013-07-06",
         "title":"NAF Sommerleir med Takemura Sensei (6.) og BjÃ¸rn Eirik Olsen Shihan (6.)"
      },
      {
         "arranger":{
            "city":"Heggedal",
            "email":"",
            "name":"Sunyata Aikido Dojo Heggedal",
            "phone":"",
            "position":"59.7852933,10.434072",
            "resource_uri":"/api/v1/club/1/"
         },
         "contact":"mouliko@online.no",
         "end":"2013-07-18",
         "location":null,
         "resource_uri":"/api/v1/event/4/",
         "start":"2013-07-11",
         "title":"Superweek with Mouliko HalÃ©n (6. dan)"
      },
      {
         "arranger":{
            "city":"Trondheim",
            "email":"aikido@stud.ntnu.no",
            "name":"NTNUI Aikido",
            "phone":"",
            "position":"63.4067583495,10.4749048318",
            "resource_uri":"/api/v1/club/8/"
         },
         "contact":"mwarholm_at_gmail.com",
         "end":"2013-10-27",
         "location":"Trondheim, Dragvoll Idrettssenter",
         "resource_uri":"/api/v1/event/8/",
         "start":"2013-10-25",
         "title":"Seminar med Jiri Novotny, 4. dan Aikikai"
      },
      {
         "arranger":{
            "city":"Trondheim",
            "email":"aikido@stud.ntnu.no",
            "name":"NTNUI Aikido",
            "phone":"",
            "position":"63.4067583495,10.4749048318",
            "resource_uri":"/api/v1/club/8/"
         },
         "contact":"mwarholm_at_gmail.com",
         "end":"2013-11-24",
         "location":null,
         "resource_uri":"/api/v1/event/11/",
         "start":"2013-11-22",
         "title":"Seminar med Jan Nevelius Shihan (6. dan Aikikai)"
      },
      {
         "arranger":{
            "city":"Oslo",
            "email":"",
            "name":"Aikikan Oslo",
            "phone":"91644855",
            "position":"59.9297591,10.7790288",
            "resource_uri":"/api/v1/club/26/"
         },
         "contact":"post@aikikanoslo.no",
         "end":"2013-09-08",
         "location":"Konghellegata 3, Oslo",
         "resource_uri":"/api/v1/event/17/",
         "start":"2013-09-07",
         "title":"VÃ¥penleir (jo og bokken) med Odd Ringstad (4. dan Aikikai). Pensum blir tilpasset de som kommer"
      },
      {
         "arranger":{
            "city":"Oslo",
            "email":"info@osloaikido.no",
            "name":"Oslo Aikido Klubb",
            "phone":"99273276",
            "position":"59.9245509,10.6758222",
            "resource_uri":"/api/v1/club/13/"
         },
         "contact":"info@osloaikido.no",
         "end":"2013-12-15",
         "location":"Tvetenveien 32B, Oslo",
         "resource_uri":"/api/v1/event/12/",
         "start":"2013-12-13",
         "title":"Seminar med Matti Joensuu (6. dan Aikikai, Endo-student)"
      },
      {
         "arranger":{
            "city":"Stavanger",
            "email":"stavangeraikido@gmail.com",
            "name":"Stavanger JÅ«ShinKan Aikido",
            "phone":"98250628",
            "position":"58.9570615,5.7398973",
            "resource_uri":"/api/v1/club/18/"
         },
         "contact":"stavangeraikido@gmail.com",
         "end":"2014-08-31",
         "location":"Stavanger (hall annonseres senere)",
         "resource_uri":"/api/v1/event/28/",
         "start":"2014-08-28",
         "title":"Fjords'n'Aikido Seminar med Marc Bachraty (5. dan Aikikai, Tissier-student)"
      },
      {
         "arranger":{
            "city":"Oslo",
            "email":"post@tenshinkan.no",
            "name":"Tenshinkan Aikidoklubb (Oslo)",
            "phone":"92290101",
            "position":"59.9138688,10.7522454",
            "resource_uri":"/api/v1/club/14/"
         },
         "contact":"post_at_tenshinkan.no ",
         "end":"2014-01-05",
         "location":"Tenshinkan Aikidoklubb, Bentsebrugt. 13 H, Oslo  ",
         "resource_uri":"/api/v1/event/24/",
         "start":"2014-01-03",
         "title":"NyttÃ¥rsseminar med BjÃ¸rn Eirik Olsen Shihan (6. dan Aikikai) "
      },
      {
         "arranger":{
            "city":"Trondheim",
            "email":"aikido@stud.ntnu.no",
            "name":"NTNUI Aikido",
            "phone":"",
            "position":"63.4067583495,10.4749048318",
            "resource_uri":"/api/v1/club/8/"
         },
         "contact":"mwarholm_at_gmail.com",
         "end":"2014-05-11",
         "location":"Trondheim, Dragvoll Idrettssenter",
         "resource_uri":"/api/v1/event/15/",
         "start":"2014-05-09",
         "title":"Seminar med Jorma Lyly (5. dan Aikikai)"
      },
      {
         "arranger":{
            "city":"Stavanger",
            "email":"stavangeraikido@gmail.com",
            "name":"Stavanger JÅ«ShinKan Aikido",
            "phone":"98250628",
            "position":"58.9570615,5.7398973",
            "resource_uri":"/api/v1/club/18/"
         },
         "contact":"stavangeraikido@gmail.com",
         "end":"2013-09-08",
         "location":"JuShinKan dojo eller HundvÃ¥ghallen",
         "resource_uri":"/api/v1/event/16/",
         "start":"2013-09-06",
         "title":"Seminar med Marc Bachraty (5. dan Aikikai, Tissier-student)"
      },
      {
         "arranger":{
            "city":"Sandnes",
            "email":"sunyatasandnes@gmail.com",
            "name":"Sunyata Sandnes Aikido Dojo ",
            "phone":"95271653",
            "position":"58.836994,5.7306828",
            "resource_uri":"/api/v1/club/31/"
         },
         "contact":"sunyatasandnes@gmail.com",
         "end":"2013-10-06",
         "location":"Hovebakken 7, 4306 Sandnes",
         "resource_uri":"/api/v1/event/23/",
         "start":"2013-10-04",
         "title":"Seminar med Mouliko HalÃ©n (6. dan Aikikai)"
      },
      {
         "arranger":{
            "city":"Hamar",
            "email":"eivind@hamaraikido.no",
            "name":"Hamar Aikido Klubb",
            "phone":"6250 9802 / 900 33 645",
            "position":"60.8647726,11.2218735",
            "resource_uri":"/api/v1/club/22/"
         },
         "contact":"Eivind@hamaraikido.no",
         "end":"2013-09-22",
         "location":"",
         "resource_uri":"/api/v1/event/5/",
         "start":"2013-09-19",
         "title":"Seminar med Juhani Laisi Shihan (6. dan, student av Endo sensei) - med torsdagstrening hos Oslo aikidoklubb"
      },
      {
         "arranger":{
            "city":"Hamar",
            "email":"eivind@hamaraikido.no",
            "name":"Hamar Aikido Klubb",
            "phone":"6250 9802 / 900 33 645",
            "position":"60.8647726,11.2218735",
            "resource_uri":"/api/v1/club/22/"
         },
         "contact":"eivind@hamaraikido.no",
         "end":"2014-09-21",
         "location":"Sho Gaku dojo, Hamar (fre-lÃ¸r-sÃ¸n) & Oslo Aikido klubb (tor)",
         "resource_uri":"/api/v1/event/30/",
         "start":"2014-09-18",
         "title":"Seminar med Juhani Laisi (6. dan Aikikai, Endo student) - Trippeljubileum! - (NB: torsdagskveld, trening med Juhani Laisi pÃ¥ Oslo Aikidoklubb!)"
      },
      {
         "arranger":{
            "city":"Heggedal",
            "email":"",
            "name":"Sunyata Aikido Dojo Heggedal",
            "phone":"",
            "position":"59.7852933,10.434072",
            "resource_uri":"/api/v1/club/1/"
         },
         "contact":"mouliko@online.no",
         "end":"2013-11-03",
         "location":" Heggedal fabrikker, Ã…motveien 2 (nye hallene, bygg 11)",
         "resource_uri":"/api/v1/event/21/",
         "start":"2013-11-01",
         "title":"Seminar med Jorma Lyly (5. dan Aikikai)"
      },
      {
         "arranger":{
            "city":"Bergen",
            "email":"post@bergen-aikidoklubb.com",
            "name":"Bergen Aikidoklubb",
            "phone":"95014938",
            "position":"60.3912628,5.3220544",
            "resource_uri":"/api/v1/club/2/"
         },
         "contact":"oystein@alsaker.org",
         "end":"2013-10-06",
         "location":"Bredalsmarken 17, Bergen.",
         "resource_uri":"/api/v1/event/6/",
         "start":"2013-10-05",
         "title":"Seminar med BjÃ¸rn Eirik Olsen Shihan (6.dan)"
      },
      {
         "arranger":{
            "city":"Ã…lesund",
            "email":"kontakt@kiaikido.no",
            "name":"Aikido Yuishinkai Ã…lesund",
            "phone":"98830700",
            "position":"62.4722284,6.149482",
            "resource_uri":"/api/v1/club/24/"
         },
         "contact":"espen.bratseth@mimer.no",
         "end":"2013-08-22",
         "location":"SjÃ¸mannsveien 27, 6003 Ã…lesund",
         "resource_uri":"/api/v1/event/20/",
         "start":"2013-09-20",
         "title":"Aikido Seminar med William Reed (7. dan Yuishinkai)"
      },
      {
         "arranger":{
            "city":"Haugesund",
            "email":"styrethak@googlegroups.com",
            "name":"Haugesund Aikidoklubb",
            "phone":"92402027",
            "position":"59.413581,5.2679869",
            "resource_uri":"/api/v1/club/17/"
         },
         "contact":"styrethak@googlegroups.com",
         "end":"2013-09-15",
         "location":"Klubbens dojo, i bomberommet ved Lotheparkveien 14, Haugesund.",
         "resource_uri":"/api/v1/event/27/",
         "start":"2013-09-13",
         "title":"Seminar med Kim A. Tinderholt (2.dan Aikikai) - Teknisk ansvarlig for Bergen & Haugesund Aikidoklubb"
      },
      {
         "arranger":{
            "city":"Heggedal",
            "email":"",
            "name":"Sunyata Aikido Dojo Heggedal",
            "phone":"",
            "position":"59.7852933,10.434072",
            "resource_uri":"/api/v1/club/1/"
         },
         "contact":"mouliko@online.no",
         "end":"2013-09-01",
         "location":" Heggedal fabrikker, Ã…motveien 2 (nye hallene, bygg 11)",
         "resource_uri":"/api/v1/event/22/",
         "start":"2013-08-30",
         "title":"Sunyata Aikido feirer Mouliko HalÃ¨ns 40 Ã¥rs fartstid innen Aikido! Det blir treningsseminar  holdt av jubilanten selv, pluss andre inviterte instruktÃ¸rer."
      }
   ]
}

JSON
  end

end
