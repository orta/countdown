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

get '/create' do
  haml :create
end

post '/create' do
  
  doc_url = "#{DB}/#{params[:permalink]}"
  rev = JSON.parse( RestClient.get( doc_url ) )['_rev'] rescue nil

  new_doc = {
    'date' => params[:date],
    'style' => params[:style],
    'message' => params[:message]
  }
  new_doc['_rev'] = rev if rev

  result = RestClient.put doc_url, new_doc.to_json, :content_type => 'application/json'
  
  # redirect!
  redirect '/' + params[:permalink]
  
  haml :contact
end

get '/:permalink' do
  begin 
    @data = RestClient.get "#{DB}/#{params[:permalink]}"
  rescue 
    haml :fourohfour
  end
  
  if @data
    @result = JSON.parse(@data)
    haml :post
  end
end
