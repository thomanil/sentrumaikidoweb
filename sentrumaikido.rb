# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'sinatra'
require './sentrumaikido.rb'
require './lib/aikido_no_scraper.rb'
require './lib/cms.rb'

def nav_items
  [
    {:section => "Ny her?",
      :links => {
        :beginners => ["/beginners", "Nybegynnerkurs"],
        :intro => ["/", "Introduksjon"],
        :about_aikido => ["/home/about_aikido", "Om Aikido"],
        :about_dojo => ["/home/about_dojo", "Om klubben"],
      }
    },

    {:section => "Aktiviteter",
      :links => {
        :classes => ["/home/classes", "Treningstider"],
        :calendar => ["/calendar", "Kalender"]
      }
    },

    {:section => "Praktisk",
      :links => {
        :rates => ["/home/rates", "Priser"],
        :contact => ["/home/contact", "Kontaktinfo"],
        :instructors => ["/home/instructors", "Instruktører"],
        :board => ["/home/board", "Styret"],
        :social => ["/home/social", "Sosialt"]
      }
    },

    {:section => "Lær mer",
      :links => {
        :faq => ["/home/faq", "FAQ"],
        :advice => ["/home/advice", "Gode råd"],
        :personligheter => ["/home/personalities", "Personer"],
        :etiquette => ["/home/etiquette", "Etikette"],
        :curriculum => ["/home/curriculum", "Pensum"],
        :terms => ["/home/terms", "Ordliste"],
        :links => ["/home/links", "Lenker"],
        :english => ["/home/english", "In English"],
        :rss => ["/rss/everything?format=rss", "RSS"]
      }
    }
  ]
end

def nav_mobile_content
  mobile_links = [:beginners,
    :about_aikido,
    :about_dojo,
    :classes,
    :rates,
    :contact,
    :english]

  all_links = []
  nav_items.each do |section|
    section[:links].each_pair do |key,value|
      all_links << [key, value]
    end
  end

  # only include the mobile_links
  all_links = all_links.select {|tuple| mobile_links.include?(tuple[0])}

  nav_content = ""
  nav_content += "<ul class='menypunkter'>"
  all_links.each do |link|
    nav_content += "  <li><a href='#{link[1][0]}'>#{link[1][1]}</a></li>"
  end
  nav_content += "</ul>"
end

def nav_desktop_content
  nav_content = ""

  nav_items.each do |section|
    nav_content += "<h2 class='menyheader'>#{section[:section]}</h2>"
    nav_content += "  <ul class='menypunkter'>"
    section[:links].each do |key, value|
      nav_content += "<li><a href='#{value[0]}'>#{value[1]}</a></li>"
    end
    nav_content += "  </ul>"
  end

  return nav_content
end


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
  redirect "https://goo.gl/1vRcu8"
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
