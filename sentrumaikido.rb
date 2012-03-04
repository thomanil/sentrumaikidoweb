# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'

get '/' do
  erb :index
end

get '/beginners' do
  erb :beginners
end

get '/calendar' do
  erb :calendar
end

get '/show_calendar/index' do
  erb :calendar, :layout => false
end

get '/startsider/provetime' do
  erb :provetime
end

get '/home/:page' do
  erb params[:page].to_sym
end

get '/rss/everything' do
  # TODO
end

