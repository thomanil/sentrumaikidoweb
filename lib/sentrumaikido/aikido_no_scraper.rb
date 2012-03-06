# -*- coding: utf-8 -*-
module SentrumAikido
  class AikidoNoScraper
    
    CALENDAR_URL = "http://www.aikido.no/index.php?option=com_oskalendar&Itemid=54"

    # Retrieves and returns the source of the NAF calendar page using http get
    def get_calendar_src
      require 'open-uri' 
      require 'iconv'

      open( CALENDAR_URL ) do |page|
        
        calendarSrc = page.read
        calendarSrc = Iconv.conv('utf-8', 'iso-8859-1', calendarSrc)
        
        return calendarSrc.strip

      end
    end

    HEADER = "<em>Dette er et automatisk uttrekk fra NAF-kalenderen, se <a href=\"#{CALENDAR_URL}\">aikido.no</a> for mer info</em>"

    # Transform given raw NAF calendar html source into simplified html table we can embed on our site
    def process_calendar(calendar_src)
      month_chunks = get_month_chunks(calendar_src)
      all_activities = []
      month_chunks.each { |chunk| all_activities += process_month(chunk) }
      result = <<PAGESRC
  <p>
  #{HEADER} 
  </p>
  
  <table border="0" id="scraped-calendar">
  	<tr><th>Tidspunkt</th><th>Sted</th><th>Aktivitet</th><th>Kontakt</th></tr>
  	#{create_table_rows(all_activities)} 
  </table>
PAGESRC
    end

    # Takes full html src of the calendar.
    # Extract each month from calendar src, returns array of strings each of which is a month "chunk" of markup
    def get_month_chunks(calendar_src)
      months = []
      pattern = /<td class="month">(.*?)(?=<td class="month">)/m
      calendar_src =~ pattern
      
      while($1 != nil) do
        month = $1
        # Put month td elements back, they are consumed by pattern match otherwise
        months.push("<td class=\"month\">"+month+"<td class=\"month\">")
        $' =~ pattern
      end
      
      return months
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

    # Takes month string description and an activity chunk of markup,
    # Each activity element (when, where, who etc) is a table row in this format: 
    #   <tr><td class="activitylegend">Hva:</td><td class="activity"><b>Seminar med Birger Sørensen 5.dan</b></td></tr>
    # Extract each of its rows from markup chunk and store in hash keys: [what, when, place, contact, moreinfo]
    # Order of activity fields is significant, we rely on them being consistently ordered in the NAF calendar
    # Returns hashmap of the activites elements
    def process_activity(activity_chunk, month)
      fields = []
      
      pattern = /<tr><td class="activitylegend">.*?<\/td><td class="activity">(.*?)<\/td><\/tr>/m
      activity_chunk =~ pattern

      while($1 != nil) do
        field = $1.strip
        fields.push(field)
        $' =~ pattern
      end
      
      activity = {:time => (fields[1]+" "+month.downcase()), :place => fields[2], :activity => fields[0], 
        :contact => fields[4], :moreinfo => fields[5]}
      
      return activity            
    end

    # Takes a chunk of markup starting with <td class="month"> element, extracts month name and cuts it up into activity chunks.
    # Each activity "chunk"  starts and ends with markup: "<tr><td class="activity">"
    # returns array of activity hashmaps
    def process_month(month_chunk)
      pattern =  /<td class="month"><b>(.*?)<\/b><\/td>/
      month_chunk =~ pattern
      month = $1.downcase
      month = month.gsub(/<b>/, "")
      month = month.gsub(/<\/b>/, "")

      activityChunks = []

      pattern =  /<tr><td class="activity">(.*?)<tr><td class="activity">/m
      month_chunk =~ pattern
      while($1 != nil) do
        activity = $1
        activityChunks.push(activity)
        $' =~ pattern
      end

      collected = []
      counter = 0
      activityChunks.each { |chunk| collected.push(process_activity(chunk, month))}
      
      return collected
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
        return process_calendar(get_calendar_src)
      rescue Exception => e
        return format_error(e)
      end
    end

  end
end
