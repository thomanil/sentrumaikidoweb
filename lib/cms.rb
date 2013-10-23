# -*- coding: utf-8 -*-
module SentrumAikido
  class CMS

    TRENINGSTIDER_SIDE_URL = "https://docs.google.com/document/pub?id=1PaPu_Ctadia-s2v806dG9JSbA6dt1jYP20FVnZiN3NM&embedded=true"
    INTERNKALENDER_SIDE_URL = "https://docs.google.com/document/pub?id=1tVUrGLd3F6oRz5D6RgWLcIXwkP5cpsaauktefg8ehyw"

    def get_treningstider()
      extract_body_contents(get_text_from_url(TRENINGSTIDER_SIDE_URL))
    end

    def get_kalender()
      extract_body_contents(get_text_from_url(INTERNKALENDER_SIDE_URL))
    end

    def get_text_from_url(url)
      require 'open-uri'
      require 'iconv'

      open(url) do |page|
        page_markup = page.read
        page_markup = Iconv.conv('utf-8', 'iso-8859-1', page_markup)
      end
    end

    def extract_body_contents(html_markup)
      require 'nokogiri'
      doc = Nokogiri::HTML(html_markup)
      doc.css("#header").remove
      doc.css("#footer").remove
      doc.css("style").remove
      body = doc.css("body").to_xhtml
    end

  end
end
