# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMOS_FILE = 'public/memos.json'

before do
  @memo = JSON.parse(File.read(MEMOS_FILE))
end

get '/memos' do
  @page_title = 'Top'
  erb :home, layout: :layout
end

get '/memos/new' do
  @page_title = 'New memo'
  erb :new, layout: :layout
end

get '/memos/:id' do
  @id = params['id']
  if @memo[@id] && !@memo[@id]['deleted_id']
    @page_title = 'Show memo'
    erb :show, layout: :layout
  else
    not_found
  end
end

get '/memos/:id/edit' do
  @id = params['id']
  if @memo[@id] && !@memo[@id]['deleted_id']
    @page_title = 'Edit memo'
    erb :edit, layout: :layout
  else
    not_found
  end
end

post '/memos' do
  id = @memo.size
  @memo[id] = memo_params
  save(@memo)

  redirect '/memos', 303
end

patch '/memos/:id' do
  id = params['id']
  @memo[id] = memo_params
  save(@memo)

  redirect "/memos/#{id}", 303
end

delete '/memos/:id' do
  id = params['id']
  @memo[id] = memo_params(id)
  save(@memo)

  redirect '/memos', 303
end

not_found do
  erb :error, layout: :layout
end

def memo_params(id = nil)
  if id
    memo_title = @memo[id]['memo_title']
    memo_text = @memo[id]['memo_text']
  else
    memo_title = params['memo_title']
    memo_text = params['memo_text']
  end
  return { 'memo_title' => memo_title, 'memo_text' => memo_text, 'deleted_id' => 1 } if id

  { 'memo_title' => escape(memo_title), 'memo_text' => escape(memo_text), 'deleted_id' => nil }
end

helpers do
  def escape(input)
    escape_html(input)
  end
end

def save(memo)
  memo_json = JSON.pretty_generate(memo)
  File.open(MEMOS_FILE, 'w+') do |file|
    file.write(memo_json)
  end
end
