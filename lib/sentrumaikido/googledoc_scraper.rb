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

<!--

  <tr class="list-line-odd">
    <td>24-26 april</td>
    <td>Fellestur til leir med Frank Ostoff i Trondheim</td>
    
    <td>
    
    </td>
    
  </tr>

  <tr class="list-line-even">
    <td>2-3 mai</td>
    <td>Hyttetur</td>
    
    <td>
    
    </td>
    
  </tr>

  <tr class="list-line-odd">
    <td>13-15 mar</td>
    <td>TK leir/gradering</td>
    
    <td>
    
    </td>
    
  </tr>

  <tr class="list-line-even">
    <td>5-7 juni</td>
    <td>Birgerleir (ikke verifisert)</td>
    
    <td>
    
    </td>
    
  </tr> -->


</table></p>
HTMLSRC
    end

    
  end
end
