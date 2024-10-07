class Memo
  @connection ||= PG.connect(dbname: 'sinatra_memo')

  class << self
    def fetch
      memos = @connection.exec('SELECT * FROM memo_app')
      memos.sort_by { |memo| memo['memo_id'].to_i }
    end

    def find(id)
      memo = @connection.exec_params('SELECT * FROM memo_app WHERE memo_id = $1 LIMIT 1', [id])
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
