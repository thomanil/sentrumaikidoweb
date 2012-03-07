# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

class GoogledocScraper < Test::Unit::TestCase

  def setup
    @scraper = SentrumAikido::GoogledocScraper.new
  end

  
  def test_dummy
    assert_equal "dummy", @scraper.dummy
  end


end
