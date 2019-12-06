require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

require_relative 'book'

# DB Setup
Mongoid.load! "mongoid.config"

# Endpoints
get '/' do
  'Welcome'
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/books' do
    Book.all.to_json
  end

  get '/times' do
    {
      data: {
        time: Time.now
      }
    }.to_json
  end
end
