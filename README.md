bake.ps1
========

ローカルに保全していた静的ウェブサイトを GitHub Pages へ展開できるように、HTML を加工する。

- GitHub Pages では http ヘッダの charset で UTF-8 を強制しており、他の文字コードを指定しても文字化けする  
  →(1) 各HTMLの文字コードを UTF-8 変換する
- イメージファイルなどのパスが変わっている可能性がある  
  →(2) 置換する

(1): 文字コード変換: スクリプトとして直接使う
--------------------------------------------

- コピー元ディレクトリ以下の全ての HTML ファイルの文字コードを UTF8 変換し、コピー先ディレクトリ以下へ展開する
- HTML以外は、そのまま加工せず、そのままコピー
- サブディレクトリもたどる
- `.` で始まる名前, `docs` というディレクトリ, 拡張子 `.ps1` のファイルは処理から除外
- 文字コード自動判定のため要nkf32.exe
- コピー元ディレクトリは省略可: デフォルト: `.`
- コピー先ディレクトリは省略可: デフォルト: `docs`

```
curl -O https://github.com/hymkor/bake.ps1/blob/master/bake.ps1
pwsh bake.ps1 "コピー元ディレクトリ" "コピー先ディレクトリ"
```

(1)+(2): リンクも加工: ライブラリとして使う
------------------------------------------

- ./ 以下の全ての HTML ファイルの文字コードに以下の処理をして、docs/ 以下へ展開する
    - UTF-8 変換
    - `http://hp.vector.co.jp/authors/VA009797` というパス参照を `https://hymkor.github.io/hp.vector.co.jp_VA009797` へ置換 (href を対象とするため、`"` を付きのもののみ)
- 要nkf32.exe , perl.exe
- 例では改行コード変換をさせないために STDIN/STDOUT ともにバイナリ指定している

**bake-fiximg.ps1**

```bake-fiximg.ps1
. .\bake.ps1

bake "." ".\docs" {
    param($from,$to)
    nkf32 -w $from | perl -pe 'binmode(STDIN);binmode(STDOUT);s|"http://hp.vector.co.jp/authors/VA009797|"https://hymkor.github.io/hp.vector.co.jp_VA009797|g' > $to
}
```

Download example code:
```
curl -O https://github.com/hymkor/bake.ps1/blob/master/bake-fiximg.ps1
```
