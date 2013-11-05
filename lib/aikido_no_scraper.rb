# -*- coding: utf-8 -*-
module SentrumAikido
  class AikidoNoScraper

    EVENTS_JSON_URL = "http://aikido.no/api/v1/event/?username=thomas.kjeldahl.nilsson&api_key=e6416d24107a8fdb010d4d43b226f5d4bb69a410"

    # Retrieves and returns the source of the NAF calendar page using http get
    def get_calendar_json(url)
      require 'open-uri'
      require 'iconv'

      open(url) do |page|
        calendarJson = page.read
      end
    end

    def objects_from_event_api
      require 'json'
      objects = []

      json = get_calendar_json(EVENTS_JSON_URL)
      page_graph = JSON.parse(json)
      objects.concat(page_graph['objects'])
      while !page_graph['meta']['next'].nil? do
        next_page_url = "http://aikido.no/"+page_graph['meta']['next']
        json = get_calendar_json(next_page_url)
        page_graph = JSON.parse(json)
        objects.concat(page_graph['objects'])
      end

      return objects
    end

    def objects_to_activities(objects)
      activities = []
      objects.sort_by! {|o| o['start']}
      objects.each do |object|
        activities << {
          :time => object['start'],
          :place => object['arranger']['name'],
          :activity => object['title'],
          :contact => object['arranger']['email'],
          :moreinfo => "http://aikido.no/kalender/"}
      end
      return activities
    end


    # Transform given raw NAF calendar html source into simplified html table we can embed on our site
    def process_calendar(all_activities)
      result = <<PAGESRC
  <p>
  <em>Dette er et automatisk uttrekk fra NAF-kalenderen, se <a href=\"http://aikido.no/kalender\">aikido.no</a> for mer utfyllende informasjon.</em>
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
        rows += "<tr class=\"#{tableClass}\"><td>#{a[:time]}</td><td>#{a[:place]}</td><td>#{a[:activity].slice(0,100)}... #{moreinfo_field}</td><td>#{contact_field}</td></tr>\n"
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
        objects = objects_from_event_api
        objects.select! {|o| DateTime.strptime(o['start'],'%Y-%m-%d') > DateTime.now }
        activities = objects_to_activities(objects)
        return process_calendar(activities)
      rescue Exception => e
        return format_error(e)
      end
    end

  end
end
