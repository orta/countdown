require 'rubygems'
require 'sinatra'
require "sinatra/reloader"

# couchDB
require 'rest_client'
require 'json'

require 'sass'
require 'haml'

DB = 'http://orta.couchone.com/countdown'
set :haml, :format => :html5 

get '/stylesheet.css' do
  content_type 'text/css'
  scss :stylesheet
end

get '/' do
  data = RestClient.get "#{DB}/_all_docs"
  @all_pages = JSON.parse(data)
  puts @all_pages
  haml :index
end

get '/:permalink' do
  data = RestClient.get "#{DB}/#{params[:permalink]}"
  @result = JSON.parse(data)
  haml :post
end
