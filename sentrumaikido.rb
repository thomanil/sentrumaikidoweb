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
      :beginners => ["/beginners", "Nybegynnerkurs"],
      :intro => ["/", "Introduksjon"],
      :about_aikido => ["/about_aikido", "Om Aikido"],
      :about_dojo => ["/about_dojo", "Om klubben"]
    },

    {:section => "Ny her?",
      :beginners => ["/beginners", "Nybegynnerkurs"],
      :intro => ["/", "Introduksjon"],
      :about_aikido => ["/home/about_aikido", "Om Aikido"],
      :about_dojo => ["/home/about_dojo", "Om klubben"],
    },

    {:section => "Aktiviteter",
      :classes => ["/home/classes", "Treningstider"],
      :calendar => ["/calendar", "Kalender"],
    },

    {:section => "Praktisk",
      :rates => ["/home/rates", "Priser"],
      :contact => ["/home/contact", "Kontaktinfo"],
      :instructors => ["/home/instructors", "Instruktører"],
      :board => ["/home/board", "Styret"],
      :social => ["/home/social", "Sosialt"],
    },

    {:section => "Lær mer",
      :faq => ["/home/faq", "FAQ"],
      :advice => ["/home/advice", "Gode råd"],
      :personligheter => ["/home/personalities", "Personer"],
      :etiquette => ["/home/etiquette", "Etikette"],
      :curriculum => ["/home/curriculum", "Pensum"],
      :terms => ["/home/terms", "Ordliste"],
      :links => ["/home/links", "Lenker"],
      :english => ["/home/english", "In English"],
      :rss => ["/rss/everything?format=rss", "RSS"],
    }
  ]
end

def nav_mobile_content
  "WATWAT"
end

def nav_desktop_content
  <<NAV

	  <h2 class="menyheader">Ny her?</h2>
	  <ul class="menypunkter">
	    <li><a href="/beginners">Nybegynnerkurs</a></li>
	    <li><a href="/">Introduksjon</a></li>
 	    <li><a href="/home/about_aikido">Om Aikido</a></li>
	    <li><a href="/home/about_dojo">Om klubben</a></li>
	  </ul>

	  <h2 class="menyheader">Aktiviteter</h2>
	  <ul class="menypunkter">
	    <li><a href="/home/classes">Treningstider</a></li>
	    <li><a href="/calendar">Kalender</a></li>
	  </ul>

	  <h2 class="menyheader">Praktisk</h2>
	  <ul class="menypunkter">
	    <li><a href="/home/rates">Priser</a></li>
	    <li><a href="/home/contact">Kontaktinfo</a></li>
	    <li><a href="/home/instructors">Instruktører</a></li>
	    <li><a href="/home/board">Styret</a></li>
	    <li><a href="/home/social">Sosialt</a></li>
	  </ul>

	  <h2 class="menyheader">Lær mer</h2>
	  <ul class="menypunkter">
	    <li><a href="/home/faq">FAQ</a></li>
	    <li><a href="/home/advice">Gode råd</a></li>
	    <li><a href="/home/personalities">Personer</a></li>
	    <li><a href="/home/etiquette">Etikette</a></li>
	    <li><a href="/home/curriculum">Pensum</a></li>
	    <li><a href="/home/terms">Ordliste</a></li>
	    <li><a href="/home/links">Lenker</a></li>
	  </ul>

	  <br/>

	  <ul>
	    <li> <a href="/home/english">In English</a> </li>
	    <li> <a href="/rss/everything?format=rss">RSS</a> </li>
	  </ul>

NAV
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
