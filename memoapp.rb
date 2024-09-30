# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/memos' do
  @memos = load_memos
  @page_title = 'Top'
  erb :home
end

get '/memos/new' do
  @page_title = 'New memo'
  erb :new
end

get '/memos/:id' do
  memos = load_memos
  @id = params['id']
  @memo = memos[@id]
  if @memo
    @page_title = 'Show memo'
    erb :show
  else
    not_found
  end
end

get '/memos/:id/edit' do
  memos = load_memos
  @id = params['id']
  @memo = memos[@id]
  if @memo
    @page_title = 'Edit memo'
    erb :edit
  else
    not_found
  end
end

post '/memos' do
  @memos = load_memos
  id = (@memos.keys.map(&:to_i).max + 1)
  @memos[id] = { 'memo_title' => params['memo_title'], 'memo_text' => params['memo_text'] }
  save_memos(@memos)

  redirect '/memos', 303
end

patch '/memos/:id' do
  @memos = load_memos
  id = params['id']
  if @memos.key?(id)
    @memos[id] = { 'memo_title' => params['memo_title'], 'memo_text' => params['memo_text'] }
    save_memos(@memos)
  end
  redirect "/memos/#{id}", 303
end

delete '/memos/:id' do
  @memos = load_memos
  @memos.delete(params['id'])
  save_memos(@memos)

  redirect '/memos', 303
end

not_found do
  erb :error
end

MEMOS_FILE = 'public/memos.json'

def load_memos
  JSON.parse(File.read(MEMOS_FILE))
end

def save_memos(memos)
  File.open(MEMOS_FILE, 'w+') do |file|
    file.write(memos.to_json)
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
