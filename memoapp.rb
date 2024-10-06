# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

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
  memo_title = params['memo_title']
  memo_text = params['memo_text']
  Memo.create(memo_title, memo_text)

  redirect '/memos', 303
end

patch '/memos/:id' do
  memo_title = params['memo_title']
  memo_text = params['memo_text']
  memo_id = params['id']
  Memo.update(memo_title, memo_text, memo_id)

  redirect "/memos/#{memo_id}", 303
end

delete '/memos/:id' do
  memo_id = params['id']
  Memo.destroy(memo_id)

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

class Memo
  @connection ||= PG.connect(dbname: 'sinatra_memo')

  class << self
    def fetch
      memos = @connection.exec('SELECT * FROM memo_app')
      memos.sort_by { |memo| memo['memo_id'].to_i }
    end

    def find(id)
      memo = @connection.exec_params('SELECT * FROM memo_app WHERE memo_id = $1', [id])
      memo.first
    end

    def create(title, text)
      @connection.exec_params('INSERT INTO memo_app (memo_title, memo_text) VALUES ($1, $2)', [title, text])
    end

    def update(title, text, id)
      @connection.exec_params('UPDATE memo_app SET memo_title = $1, memo_text = $2 WHERE memo_id = $3', [title, text, id])
    end

    def destroy(id)
      @connection.exec_params('DELETE FROM memo_app WHERE memo_id = $1', [id])
    end
  end
end
