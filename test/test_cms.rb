# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

class TestCMS < Test::Unit::TestCase

  def setup
    @cms = SentrumAikido::CMS.new
  end

  def test_fetch_googledoc_text
    assert_match(/Klokkeslett/, @cms.get_treningstider())
  end

  def test_only_body_contents
    returned_markup = @cms.get_treningstider()
    assert_no_match(/style/, returned_markup)
    assert_no_match(/max-width/, returned_markup)
    assert_no_match(/<body>/, returned_markup)
  end



end
