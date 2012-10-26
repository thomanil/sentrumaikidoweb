# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

class TestCMS < Test::Unit::TestCase

  def setup
    @cms = SentrumAikido::CMS.new
  end

  def test_fetch_googledoc_text
    assert_match(/Klokkeslett/, @cms.get_treningstider())
  end



end
