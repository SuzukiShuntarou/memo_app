# memo_app
メモアプリをローカル環境で立ち上げる為の手順です。

## How to Use
1. 右上の`Fork`ボタンを押してください。
2. `{自分アカウント名}/memo_app`が作成されます。
3. 作業PCの任意のディレクトリにて`git clone`してください。
```
$ git clone https://github.com/自分のアカウント名/memo_app.git
```

4. 以下の手順を実行してmemo_appに必要なgemをインストールします。
    1. `$ cd memo_app`でディレクトリを移動
    2. `$ git switch memo`でmemoブランチに移動
    3. `$ bundle install` を実行
    4. `$ bundle exec rubocop memoapp.rb` と `$ bundle exec erblint --lint-all` を実行して警告が出ないことを確認

5. 以下の手順を実行してローカル環境でmemo_appを立ち上げます。
    1. `$ bundle exec ruby memoapp.rb` を実行
    2. ブラウザで`http://127.0.0.1:4567/memos`にアクセスし、表示を確認
