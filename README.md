# Process completion notification bot (Slack)

```bash
git clone
```

## Create New App

1. [Slack](https://slack.com/intl/ja-jp/signin#/signin) にログインし, Workspace を作成する.

2. [Slack API](https://api.slack.com/apps?new_app=1) にアクセスして, `Create New App` > `From a manifest` を選択する.

3. Workspace を選択する.
   
4. `manifest.yaml` を貼り付ける. この際, `api name` は適宜変更すること.

5. `Create` を選択する.

## Configuration settings

1. `api.py` を任意のディレクトリに配置する.

2. `.env` を作成する. `.env.sample` を使用する場合は, 適宜値を変更し, ファイル名を `.env` とすること.

3. `api.py` の10行目 `load_dotenv("/path/to/.env")` を正しいパスに変更する. また, 必要に応じて通知の送信先を変更する.

>[!NOTE]
>チャンネルに通知を送信する場合は, チャンネルにアプリを招待 (`/invite`) すること.

4. 依存関係をインストールする.

```bash
pip install -r requirements.txt
```

## Create a symbolic link

1. `~/.local/bin` を作成する.

```bash
[ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin
```

2. PATH に `~/.local/bin` を追加する.

>[!NOTE]
>使用している Shell に合わせて適宜変更すること.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

1. `.bashrc` を再読み込みする.

```bash
source ~/.bashrc
```

4. `api.py` に実行権限を付与する.

```bash
chmod +x /path/to/api.py
```

5. シンボリックリンクを作成する.

```bash
ln -s /path/to/api.py ~/.local/bin/symlink_name
```

## Usage

`symlink_name` を `python3` の代わりに使用する.

```bash
symlink_name train.py yolo11s.pt yolo11s-train-01
```

## Constraints

- `python3 hoge.py <args...>` の形式での使用のみを想定

## ToDo

- Python以外の言語や様々なコマンドの形式に対応させる
- Slack側のUIを見やすいように整形する
- エラー処理を追加する
