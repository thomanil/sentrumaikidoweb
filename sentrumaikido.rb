# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'sinatra'
require './sentrumaikido.rb'
require './lib/aikido_no_scraper.rb'
require './lib/cms.rb'


# If we don't do this OSI Aikido can't embed our pages in iframe
set :protection, :except => :frame_options

get '/' do
  erb :index
end

# layoutless calendar used by OSI Aikido in an iframe in their webpage
get '/show_calendar/index' do
  erb :calendar, :layout => false
end

get '/julebord' do
  redirect "https://docs.google.com/spreadsheet/viewform?formkey=dGVtdGZWUGkweFdUSHA4eHZQbmlKRVE6MA"
end

get '/beginners' do
  erb :beginners
end

get '/calendar' do
  erb :calendar
end

get '/startsider/provetime' do
  erb :provetime
end

# TODO remove the  'home' prefix. Note: have to go through all
# internal links in the view templates and remove there too.
get '/home/:page' do
  erb params[:page].to_sym
end
