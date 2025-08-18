# X

## 1. Godotプロジェクトの準備

まず、Godot エディターで新しいプロジェクトを作成します：

Godot を起動
「新規プロジェクト」を作成
プロジェクト名と保存場所を設定

## 2. VSCode の設定

GDScript 拡張機能をインストール

VSCode を開く
拡張機能タブ（Ctrl+Shift+X）を開く
"godot-tools" を検索してインストール

Godot エディターで：
Godot can be used with an external text editor, such as Sublime Text or Visual Studio Code. Browse to the relevant editor settings: Editor > Editor Settings > Text Editor > External

There are two text fields: the executable path and command-line flags. The flags allow you to integrate the editor with Godot, passing it the file path to open and other relevant arguments. Godot will replace the following placeholders in the flags string:

高度な設定

https://docs.godotengine.org/en/stable/tutorials/editor/external_editor.html

Visual Studio Code
{project} --goto {file}:{line}:{col}

VSCodeの場合の設定手順：

Godotエディターを開く
エディター → エディター設定 をクリック
ネットワーク → エディター の項目を探す
外部エディター の設定で：

実行可能パス: VSCodeのインストールパス

Windows: C:\Users\[ユーザー名]\AppData\Local\Programs\Microsoft VS Code\Code.exe
Mac: /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code

実行フラグ: {project} --goto {file}:{line}:{col}
設定を保存

これで、Godotでスクリプトをダブルクリックすると、自動的にVSCodeが開いて該当ファイルの正確な行・列位置にカーソルが移動するようになります。
要するに「Godotからワンクリックで外部エディター（VSCode）を開けるようにする設定」ということですね！


## 3. スクリプトの作成と実行

ノードにスクリプトを追加

Godot エディターでシーンを作成（例：Node2D）
ノードを右クリック → スクリプトを追加
スクリプトパスを確認して 作成

VSCode でスクリプトを編集

VSCode でプロジェクトフォルダを開く
作成された .gd ファイルを開く
以下のコードを入力：