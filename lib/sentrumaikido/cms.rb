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




  end
end
