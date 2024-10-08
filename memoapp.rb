# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require './memo'

get '/memos' do
  @memos = Memo.fetch
  @page_title = 'Top'
  erb :home
end

get '/memos/new' do
  @page_title = 'New memo'
  erb :new
end

get '/memos/:id' do
  memo_id = params['id']
  @memo = Memo.find(memo_id)
  if @memo
    @page_title = 'Show memo'
    erb :show
  else
    not_found
  end
end

get '/memos/:id/edit' do
  memo_id = params['id']
  @memo = Memo.find(memo_id)
  if @memo
    @page_title = 'Edit memo'
    erb :edit
  else
    not_found
  end
end

post '/memos' do
  Memo.create(params['memo_title'], params['memo_text'])

  redirect '/memos', 303
end

patch '/memos/:id' do
  memo_id = params['id']
  Memo.update(params['memo_title'], params['memo_text'], memo_id)

  redirect "/memos/#{memo_id}", 303
end

delete '/memos/:id' do
  Memo.destroy(params['id'])

  redirect '/memos', 303
end

not_found do
  erb :error
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
