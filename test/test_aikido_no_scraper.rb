# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/test_helper.rb'

class TestCalScraper < Test::Unit::TestCase

  def setup
    @scraper = SentrumAikido::AikidoNoScraper.new
  end

  def test_get_calendar_src
    testcal = @scraper.get_calendar_src
    assert testcal =~ /body/, "Expected naf cal page to include body tag"
    assert testcal =~ /html/, "Expected naf cal page to include html tag"
    assert testcal =~ /month/, "Expected naf cal page to include at least one tag with 'month' class"
  end

  def test_transform_calendar_src_into_activity_hash
    activities = @scraper.src_to_activities(test_calendar_src)
    assert_equal 5, activities.count
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


  ### TESTDATA ####

  def test_calendar_src
    return <<PAGESRC

<!DOCTYPE html>


<html>

    <head>

        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <title>Kalender | Aikido.no</title>
        <meta name="keywords" content="" />
        <meta name="description" content="En flott ting med aikido er at vi ofte får besøk av flinke instruktører både fra innland og utland som vil vise oss litt av hvordan de trener aikido. Her er hva som skjer fremover." />
        <meta name="viewport" content="width=device-width"/>


            <link rel="alternate" type="application/rss+xml" title="RSS" href="/artikler/feeds/rss/" />
            <link rel="alternate" type="application/atom+xml" title="Atom" href="/artikler/feeds/atom/" />



        <link rel="stylesheet" href="/static/CACHE/css/b097296d894a.css" type="text/css" />


        <link rel="stylesheet" href="/static/CACHE/css/e1d1995e432b.css" type="text/css" /><link rel="stylesheet" href="/static/CACHE/css/1def7b9964e9.css" type="text/css" media="screen" />


        <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/smoothness/jquery-ui.css" />
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/i18n/jquery-ui-i18n.min.js"></script>


        <link href="//fonts.googleapis.com/css?family=Cardo:400,700,400italic|Source+Sans+Pro:400,300,600&subset=latin,latin-ext" rel="stylesheet" type="text/css" />




            <script type="text/javascript" src="/jsi18n/"></script>
            <script type="text/javascript" src="/static/CACHE/js/b84caccae2f6.js"></script>


        <!--[if lt IE 9]>
            <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

    </head>

    <body>

        <div id="body">

            <div id="leftmenu">

                <a id="skip-to-content" href="#main">Hopp til innhold</a>

                <div id="login">
                    <a id="toggle-navigation" href="javascript:;">Navigasjon</a>

                        <a href="/bruker/logg-inn/">Logg inn</a>
                        <a href="/bruker/ny/">Opprett bruker</a>

                </div>

                <div id="logo">
                    <a href="/"><img src="/static/img/logo.png" /></a>
                </div>

                <form id="search" action="/sok/" method="get">
                    <input name="q" placeholder="søk..."/>
                    <button></button>
                </form>

                <nav>
                    <ul>
                        <li class="nav"><h2>Navigasjon</h2><a href="javascript:;">Lukk</a></li>


<li><a class="" href="/">Forside</a></li><li class=""><a class="" href="/om-aikido/">Om aikido</a></li><li class=""><a class="" href="/organisasjoner/">Organisasjoner</a><ul><li class=""><a class="" href="/organisasjoner/norges-aikidoforbund/">Norges Aikidoforbund</a><ul><li class=""><a class="" href="/organisasjoner/norges-aikidoforbund/statutter/">Statutter for Norges Aikidoforbund</a></li><li class=""><a class="" href="/organisasjoner/norges-aikidoforbund/gradering/">Gradering</a></li><li class=""><a class="" href="/organisasjoner/norges-aikidoforbund/avgifter%C3%B8konomi/">Avgifter/Økonomi</a></li><li class=""><a class="" href="/organisasjoner/norges-aikidoforbund/teknisk-kommite/">Teknisk Komitè</a></li></ul></li><li class=""><a class="" href="/organisasjoner/aikikan/">Aikikan Norge</a></li></ul></li><li class=""><a class="active leaf" href="/kalender/">Kalender</a></li><li class=""><a class="" href="/klubber/">Klubber</a></li><li class=""><a class="" href="/skjema/">Skjemaer</a></li><li class=""><a class="" href="/dokumenter/">Dokumenter</a></li><li class=""><a class="" href="/lenker/">Lenker</a></li><li class=""><a class="" href="/bli-med-og-tren-aikido/">Bli med og tren aikido!</a><ul><li class=""><a class="" href="/bli-med-og-tren-aikido/starte-aikidoklubb/">Om å starte Aikidoklubb</a></li></ul></li><li class=""><a class="" href="/galleri/">Galleri</a></li><li class=""><a class="" href="/om/">Om aikido.no</a></li>



                    </ul>
                </nav>

            </div>

            <div id="main">

                <h1>
Kalender
</h1>









<p>En flott ting med aikido er at vi ofte får besøk av flinke instruktører både fra innland og utland som vil vise oss litt av hvordan de trener aikido. Her er hva som skjer fremover.</p>
<h3>Skal du arrangere eller vet om en (i Norge) som ikke er listet?</h3>
<p>Meld inn en ny aikidobegivenhet under <a href="/kalender/meld-inn/">kalender/meld-inn</a></p>




    <table id="calendar" class="horizontal">



            <tbody><tr span="2"><td><h2 class="event_year">2013</h2></td></tr></tbody>



                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Oktober</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="23">Seminar med Mouliko Halén (6. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">4. oktober 2013</span> &mdash; <span class="nowrap">6. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Hovebakken 7, 4306 Sandnes</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Sandnes Aikido Dojo </td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:sunyatasandnes@gmail.com">sunyatasandnes@gmail.com</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.facebook.com/events/495518883862882/">http://www.facebook.com/events/495518883862882/</a></div>

                                        <div><a href="http://www.sunyatasandnes.no/en/eventes/pdf/international_seminar_with_mouliko_halen_sensei.pdf">http://www.sunyatasandnes.no/en/eventes/pdf/international_seminar_with_mouliko_halen_sensei.pdf</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="6">Seminar med Bjørn Eirik Olsen Shihan (6.dan)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">5. oktober 2013</span> &mdash; <span class="nowrap">6. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Bredalsmarken 17, Bergen.</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Bergen Aikidoklubb</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:oystein@alsaker.org">oystein@alsaker.org</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="https://www.facebook.com/events/628896360462039/">https://www.facebook.com/events/628896360462039/</a></div>

                                        <div><a href="http://www.bergenaikido.no/seminar-med-bjorn-eirik-olsen-shihan-5-6-oktober/">http://www.bergenaikido.no/seminar-med-bjorn-eirik-olsen-shihan-5-6-oktober/</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="31">Dagsseminar med Mouliko Halén (6. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">12. oktober 2013</span> &mdash; <span class="nowrap">12. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Heggedal</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Aikido Dojo Heggedal</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mouliko@online.no">mouliko@online.no</a></td>
                        </tr>


                        <tr>
                            <td colspan="2"><h4 id="7">Seminar med Philippe Orban (6.dan) Halv pris for nybegynnere under 4. kyu</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">18. oktober 2013</span> &mdash; <span class="nowrap">20. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Aikikan Oslo</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:post@aikikanoslo.no">post@aikikanoslo.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.facebook.com/events/368318903270510/">http://www.facebook.com/events/368318903270510/</a></div>

                                        <div><a href="http://www.aikikanoslo.no/leirinfo">http://www.aikikanoslo.no/leirinfo</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="9">Seminar with Thorsten Schoo (5. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">25. oktober 2013</span> &mdash; <span class="nowrap">27. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Tenshinkan Aikidoklubb (Oslo)</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:kontakt@tenshinkan.no">kontakt@tenshinkan.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="https://www.facebook.com/events/196127270562871/">https://www.facebook.com/events/196127270562871/</a></div>

                                        <div><a href="http://tenshinkan.no/wp-content/uploads/2012/11/Invit-Thorsten-Schoo25_271013.pdf">http://tenshinkan.no/wp-content/uploads/2012/11/Invit-Thorsten-Schoo25_271013.pdf</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="8">Seminar med Jiri Novotny, 4. dan Aikikai</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">25. oktober 2013</span> &mdash; <span class="nowrap">27. oktober 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Trondheim, Dragvoll Idrettssenter</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>NTNUI Aikido</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mwarholm_at_gmail.com">mwarholm_at_gmail.com</a></td>
                        </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">November</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="21">Seminar med Jorma Lyly (5. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">1. november 2013</span> &mdash; <span class="nowrap">3. november 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td> Heggedal fabrikker, Åmotveien 2 (nye hallene, bygg 11)</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Aikido Dojo Heggedal</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mouliko@online.no">mouliko@online.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="https://www.facebook.com/events/181879888658217/">https://www.facebook.com/events/181879888658217/</a></div>

                                        <div><a href="http://www.sunyata-aikido.org/heggedal/?page_id=90">http://www.sunyata-aikido.org/heggedal/?page_id=90</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="10">Seminar med Dirk Müller Sensei (6. dan Aikikai) (NB: torsdagskveld, trening med Dirk Müller på Heggedal!)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">7. november 2013</span> &mdash; <span class="nowrap">10. november 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Horten (fre-lør-søn) &amp; Heggedal (tor)</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Renshin Aikido Dojo Horten</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:kontakt-oss@renshin-aikido.no">kontakt-oss@renshin-aikido.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.renshin-aikido.no/pdf/dirk-muller-2013-poster.pdf">http://www.renshin-aikido.no/pdf/dirk-muller-2013-poster.pdf</a></div>

                                        <div><a href="http://www.facebook.com/events/299505773498038/">http://www.facebook.com/events/299505773498038/</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="11">Seminar med Jan Nevelius Shihan (6. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">22. november 2013</span> &mdash; <span class="nowrap">24. november 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>NTNUI Aikido</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mwarholm_at_gmail.com">mwarholm_at_gmail.com</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.ntnui.no/aikido/seminar.php">http://www.ntnui.no/aikido/seminar.php</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="18">Våpenleir (jo og bokken) med Odd Ringstad (4. dan Aikikai). Pensum blir tilpasset de som kommer</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">30. november 2013</span> &mdash; <span class="nowrap">1. desember 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Konghellegata 3, Oslo</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Aikikan Oslo</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:post@aikikanoslo.no">post@aikikanoslo.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.aikikanoslo.no/leirinfo">http://www.aikikanoslo.no/leirinfo</a></div>

                                </td>
                            </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Desember</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="32">Seminar med Mouliko Halén (6. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">13. desember 2013</span> &mdash; <span class="nowrap">15. desember 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Heggedal</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Aikido Dojo Heggedal</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mouliko@online.no">mouliko@online.no</a></td>
                        </tr>


                        <tr>
                            <td colspan="2"><h4 id="12">Seminar med Matti Joensuu (6. dan Aikikai, Endo-student)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">13. desember 2013</span> &mdash; <span class="nowrap">15. desember 2013</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Tvetenveien 32B, Oslo</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Oslo Aikido Klubb</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:info@osloaikido.no">info@osloaikido.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.osloaikido.no/treningsleir-med-matti-joensuu-6-dan/?lang=en">http://www.osloaikido.no/treningsleir-med-matti-joensuu-6-dan/?lang=en</a></div>

                                        <div><a href="https://www.facebook.com/events/429467477157772">https://www.facebook.com/events/429467477157772</a></div>

                                </td>
                            </tr>


                </tbody>


            <tbody><tr span="2"><td><h2 class="event_year">2014</h2></td></tr></tbody>



                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Januar</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="24">Nyttårsseminar med Bjørn Eirik Olsen Shihan (6. dan Aikikai) </h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">3. januar 2014</span> &mdash; <span class="nowrap">5. januar 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Tenshinkan Aikidoklubb, Bentsebrugt. 13 H, Oslo  </td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Tenshinkan Aikidoklubb (Oslo)</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:post_at_tenshinkan.no ">post_at_tenshinkan.no </a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://tenshinkan.no/wp-content/uploads/2013/08/Invit_BEOleir_03_050114.pdf">http://tenshinkan.no/wp-content/uploads/2013/08/Invit_BEOleir_03_050114.pdf</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="19">Våpenleir (jo og bokken) med Odd Ringstad (4. dan Aikikai). Pensum blir tilpasset de som kommer</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">11. januar 2014</span> &mdash; <span class="nowrap">12. januar 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Konghellegata 3, Oslo</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Aikikan Oslo</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:post@aikikanoslo.no">post@aikikanoslo.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.aikikanoslo.no/leirinfo">http://www.aikikanoslo.no/leirinfo</a></div>

                                </td>
                            </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Mai</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="25">Fjords&#39;n&#39;Aikido Seminar med Fabrice Somers (5. dan Aikikai, Endo-student)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">1. mai 2014</span> &mdash; <span class="nowrap">4. mai 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>JuShinKan dojo, Lagårdsveien 91, Stavanger</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Stavanger JūShinKan Aikido</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:stavangeraikido@gmail.com">stavangeraikido@gmail.com</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://stavangeraikido.wordpress.com/">http://stavangeraikido.wordpress.com/</a></div>

                                </td>
                            </tr>


                        <tr>
                            <td colspan="2"><h4 id="15">Seminar med Jorma Lyly (5. dan Aikikai)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">9. mai 2014</span> &mdash; <span class="nowrap">11. mai 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Trondheim, Dragvoll Idrettssenter</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>NTNUI Aikido</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mwarholm_at_gmail.com">mwarholm_at_gmail.com</a></td>
                        </tr>


                        <tr>
                            <td colspan="2"><h4 id="13">Våpenleir (jo og bokken) med Odd Ringstad (4. dan Aikikai). Pensum blir tilpasset de som kommer</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">24. mai 2014</span> &mdash; <span class="nowrap">25. mai 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Konghellegata 3, Oslo</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Aikikan Oslo</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:post@aikikanoslo.no">post@aikikanoslo.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.aikikanoslo.no/leirinfo">http://www.aikikanoslo.no/leirinfo</a></div>

                                </td>
                            </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Juni</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="33">Aikido summer camp in Moelv (Mouliko Halén, Jorma Lyly, Mats Ahlin)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">5. juni 2014</span> &mdash; <span class="nowrap">8. juni 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Moelv</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Aikido Dojo Heggedal</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mouliko@online.no">mouliko@online.no</a></td>
                        </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Juli</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="34">Aikido superweek med Mouliko Halén (6. dan)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">10. juli 2014</span> &mdash; <span class="nowrap">17. juli 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Heggedal</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Sunyata Aikido Dojo Heggedal</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:mouliko@online.no">mouliko@online.no</a></td>
                        </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">August</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="28">Fjords&#39;n&#39;Aikido Seminar med Marc Bachraty (5. dan Aikikai, Tissier-student)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">28. august 2014</span> &mdash; <span class="nowrap">31. august 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Stavanger (hall annonseres senere)</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Stavanger JūShinKan Aikido</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:stavangeraikido@gmail.com">stavangeraikido@gmail.com</a></td>
                        </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">September</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="30">Seminar med Juhani Laisi (6. dan Aikikai, Endo student) - Trippeljubileum! - (NB: torsdagskveld, trening med Juhani Laisi på Oslo Aikidoklubb!)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">18. september 2014</span> &mdash; <span class="nowrap">21. september 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Sho Gaku dojo, Hamar (fre-lør-søn) &amp; Oslo Aikido klubb (tor)</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Hamar Aikido Klubb</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:eivind@hamaraikido.no">eivind@hamaraikido.no</a></td>
                        </tr>

                            <tr>
                                <th>Nettlenke</th>
                                <td>

                                        <div><a href="http://www.hamaraikido.no/index.html">http://www.hamaraikido.no/index.html</a></div>

                                        <div><a href="http://www.facebook.com/events/1406253249603562/">http://www.facebook.com/events/1406253249603562/</a></div>

                                </td>
                            </tr>


                </tbody>

                <tbody>
                    <tr>
                        <td colspan="2"><h3 class="event_month">Oktober</h3></td>
                    </tr>

                        <tr>
                            <td colspan="2"><h4 id="35">Seminar with Takanori Kuribayashi Shihan (7. dan fra Hombu)</h4></td>
                        </tr>
                        <tr>
                            <th>Når</th>
                            <td><span class="nowrap">31. oktober 2014</span> &mdash; <span class="nowrap">2. november 2014</span></td>
                        </tr>
                        <tr>
                            <th>Sted</th>
                            <td>Oslo</td>
                        </tr>
                        <tr>
                            <th>Arrangør</th>
                            <td>Oslo Aikido Klubb</td>
                        </tr>
                        <tr>
                            <th>Kontakt</th>
                            <td><a href="mailto:erik@osloaikido.no">erik@osloaikido.no</a></td>
                        </tr>


                </tbody>


    </table>



            </div>

        </div>

        <br style="clear:both" />

        <script>

    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-42887977-1', 'aikido.no');
    ga('send', 'pageview');

</script>


    </body>

</html>
PAGESRC
end

end
