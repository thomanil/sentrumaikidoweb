# -*- coding: utf-8 -*-
module SentrumAikido
  class GoogledocScraper

    def dummy
      "dummy"
    end

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
      Mer info kommer
    </td>
    
  </tr>

 
</table></p>
HTMLSRC
    end

    
  end
end
