require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

require_relative 'book'
require_relative 'book_serializer'

# DB Setup
Mongoid.load! 'mongoid.config'

# Endpoints
get '/' do
  'Welcome'
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/books' do
    books = Book.all

    %i[title isbn author].each do |filter|
      books = books.send(filter, params[filter]) if params[filter]
    end

    books.map { |book| BookSerializer.new(book) }.to_json
  end

  get '/times' do
    {
      data: {
        time: Time.now
      }
    }.to_json
  end
end
