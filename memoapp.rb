# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/memos' do
  load
  @page_title = 'Top'
  erb :home
end

get '/memos/new' do
  @page_title = 'New memo'
  erb :new
end

get '/memos/:id' do
  load
  @id = params['id']
  if @memo[@id] && !@memo[@id]['deleted_id']
    @page_title = 'Show memo'
    erb :show
  else
    not_found
  end
end

get '/memos/:id/edit' do
  load
  @id = params['id']
  if @memo[@id] && !@memo[@id]['deleted_id']
    @page_title = 'Edit memo'
    erb :edit
  else
    not_found
  end
end

post '/memos' do
  load
  id = (@memo.keys.map(&:to_i).max + 1)
  @memo[id] = { 'memo_title' => params['memo_title'], 'memo_text' => params['memo_text'] }
  save(@memo)

  redirect '/memos', 303
end

patch '/memos/:id' do
  load
  id = params['id']
  @memo[id] = { 'memo_title' => params['memo_title'], 'memo_text' => params['memo_text'] }
  save(@memo)

  redirect "/memos/#{id}", 303
end

delete '/memos/:id' do
  load
  @memo.delete(params['id'])
  save(@memo)

  redirect '/memos', 303
end

not_found do
  erb :error
end

MEMOS_FILE = 'public/memos.json'

def load
  @memo = JSON.parse(File.read(MEMOS_FILE))
end

def save(memo)
  File.open(MEMOS_FILE, 'w+') do |file|
    file.write(memo.to_json)
  end
end
