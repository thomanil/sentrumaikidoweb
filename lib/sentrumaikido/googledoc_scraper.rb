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
    <td>13-14 april</td>
    <td>TK leir</td>
    
    <td>
    <a href="http://wiki.rollespill.no/notater/moin.cgi/Aikido/TKLeir?action=print">Mer info</a>
    </td>
    
  </tr>

 
</table></p>
HTMLSRC
    end

    
  end
end
