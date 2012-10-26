# -*- coding: utf-8 -*-
module SentrumAikido
  class CMS

    def internal_calendar
      raw_html = <<HTMLSRC
<p><table id="event-list">
  <tr>
    <th>Tidspunkt</th>
    <th>Aktivitet</th>
    <th>Mer info</th>
  </tr>



  <tr class="list-line-odd">
    <td>18-20 januar 2012</td>
    <td>Leir med Marc Bachraty</td>
    <td>
      <a href="/home/marcseminar">Mer info</a>
    </td>

  </tr>


</table></p>
HTMLSRC
    end


    TRENINGSTIDER_SIDE_URL = "https://docs.google.com/document/pub?id=1PaPu_Ctadia-s2v806dG9JSbA6dt1jYP20FVnZiN3NM&embedded=true"

    def get_treningstider()
      get_text_from_url(TRENINGSTIDER_SIDE_URL)
    end

    def get_text_from_url(url)
      require 'open-uri'
      require 'iconv'

      open( url ) do |page|
        page_markup = page.read
        page_markup = Iconv.conv('utf-8', 'iso-8859-1', page_markup)
        page_markup.strip
      end
    end


  end
end
