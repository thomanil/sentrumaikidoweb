# -*- coding: utf-8 -*-
module SentrumAikido
  class AikidoNoScraper

    CALENDAR_URL = "http://aikido.no/kalender"

    # Retrieves and returns the source of the NAF calendar page using http get
    def get_calendar_src
      require 'open-uri'
      require 'iconv'

      open( CALENDAR_URL ) do |page|
        calendarSrc = page.read
        calendarSrc = Iconv.conv('utf-8', 'iso-8859-1', calendarSrc)
        calendarSrc.strip
      end
    end

    # Transform given raw NAF calendar html source into simplified html table we can embed on our site
    def process_calendar(all_activities)
      result = <<PAGESRC
  <p>
  <em>Dette er et automatisk uttrekk fra NAF-kalenderen, se <a href=\"#{CALENDAR_URL}\">aikido.no</a> for mer info</em>
  </p>

  <table border="0" id="scraped-calendar">
  	<tr><th>Tidspunkt</th><th>Sted</th><th>Aktivitet</th><th>Kontakt</th></tr>
  	#{create_table_rows(all_activities)}
  </table>
PAGESRC
    end


    # Takes array of activity hashmaps
    # Returns one html table row per activity, one column per key-value pair of activity (when, where, etc)
    def create_table_rows(activities)
      rows = ""

      activities.each do |a|
        moreinfo_field = shorten_url(a[:moreinfo])
        contact_field = shorten_mail_adr(a[:contact])

        tableClass = cycle('list-line-odd', 'list-line-even')
        rows += "<tr class=\"#{tableClass}\"><td>#{a[:time]}</td><td>#{a[:place]}</td><td>#{a[:activity].slice(0,50)}... #{moreinfo_field}</td><td>#{contact_field}</td></tr>\n"
      end

      return rows
    end

    @@switch = 0
    def cycle(strA, strB)
      if(@@switch == 0)
        @@switch = -1
      end
      if(@@switch == -1)
        @@switch = 1
        return strA
      end
      if(@@switch == 1)
        @@switch = -1
        return strB
      end
    end

    # For any <a href= tag in given url text, substitute link visible text with "Mer info"
    def shorten_url(url)
      pattern = /<a.*>(\S*)<\/a>/um
      url =~ pattern
      (url = url.sub(/>.*#{$1}.*</um, ">les mer<")) unless $1 == nil

      # Some line-broken or complex urls don't work. For now we just null them to "" and
      # hope people check the NAF calendar.
      if(url =~ /les mer/)
        return url
      else
        return ""
      end
    end

    # Substitute mail adress(es) in given string with corresponding clickable a href mailto: link
    def shorten_mail_adr(adr)
      pattern = /\S*(@|\sved\s)\S*/
      adr =~ pattern
      (adr = adr.sub(/#{$&}/, "<a href=\"mailto:#{$&}\">email</a>")) unless $& == nil
      return adr
    end




    ERRORPREFIX = "<em>Det oppstod en uventet feil under uttrekk av NAF-kalender. Si gjerne ifra til Thomas! :)!</em>"

    # Returns human readable error message
    def format_error(error)
      msgstr = <<END_OF_MESSAGE
<p><b>#{ERRORPREFIX}</b></p>
<p><i>#{error}</i></p>
END_OF_MESSAGE
    end

    # Returns scraped NAF calendar page as html table
    # If any exceptions are raised during execution a human readable error message is returned instead.
    def scrape_calendar
      begin

        src = get_calendar_src
        activities = [{:time => "12.januar", :place => "Oslo", :activity => "Leir med Hodor",
        :contact => "Mr T", :moreinfo => "call us"}]

        return process_calendar(activities)
      rescue Exception => e
        return format_error(e)
      end
    end

  end
end
