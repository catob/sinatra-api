require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

require_relative 'book'
require_relative 'book_serializer'
require_relative 'helper'

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

  get '/books/:id' do |id|
    book = Book.find(id)
    halt(404, { message: 'Book not found' }.to_json ) unless book
    BookSerializer.new(book).to_json
  end

  post '/books' do
    book = Book.new(json_params)
    if book.save
      response.headers['Location'] = "#{base_url}/api/v1/#{book.id}"
      status 201
    else
      status 422
      body BookSerializer.new(book).to_json
    end
  end

  get '/times' do
    {
      data: {
        time: Time.now
      }
    }.to_json
  end
end
