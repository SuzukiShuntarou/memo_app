# memo_app
メモアプリをローカル環境で立ち上げる為の手順です。

## How to Use
1. 右上の`Fork`ボタンを押してください。Copy the main branch only のチェックを外してフォークを作成します。
   -  注意！ フォークを実行する際は「Copy the main branch only」のチェックボックスを必ず外してください。
2. `{自分アカウント名}/memo_app`が作成されます。
3. 作業PCの任意のディレクトリにて`git clone`してください。
```
$ git clone https://github.com/自分のアカウント名/memo_app.git
```

4. 以下の手順を実行してmemo_appに必要なgemをインストールします。
    1. `$ cd memo_app`でディレクトリを移動
    2. `$ git switch memo`でmemoブランチに移動
    3. `$ which pg_config`pg_config のパスを取得
    4. `$ bundle config build.pg --with-pg-config=5.で取得したパスを入力`でpg_configのパスを指定
    5. `$ bundle install` を実行
    6. `$ bundle exec rubocop memoapp.rb` と `$ bundle exec erblint --lint-all` を実行して警告が出ないことを確認

5. 以下の手順を実行してmemo_appに必要なPostgreSQLデータベースとテーブルを作成します。
    1. `$ su - postgres`でPostgreSQLに接続
    2. `$ psql -d postgres`でデフォルトのデータベースに接
    3. `CREATE DATABASE sinatra_memo WITH TEMPLATE template0 ENCODING 'UTF8';`でデータベースを作成
        `CREATE DATABASE` と返されることを確認
    4. `\q`でデフォルトのデータベースから切断
    5. `$ psql -d sinatra_memo`で作成したデータベースに接続
    6. 以下のSQL文を実行して、必要なテーブルを作成
    ```
    CREATE TABLE memo_app(
    memo_id SERIAL PRIMARY KEY,
    memo_title VARCHAR(255) NOT NULL,
    memo_text TEXT NOT NULL);
    ```
    7. `\dt`でmemo_appテーブルが作成されたことを確認

6. 以下の手順を実行してローカル環境でmemo_appを立ち上げます。
    1. `$ bundle exec ruby memoapp.rb` を実行
    2. ブラウザで`http://127.0.0.1:4567/memos`にアクセスし、表示を確認
