# ame-handtrack

カメラに映った手の形と位置・関節 21 点を JSON の行で流し続ける小さなコマンド(Linux)。

[ame-shell](https://github.com/TatsuyaM2667/ame-shell)(Wayland のデスクトップシェル)の一部を、単独で使えるように切り出したものです。
ame-shell は画面の要らない仕事を、1 つのことをして標準入出力でやりとりする小さなコマンドに分けています。これはその 1 つです。

## 使い方

```text
ame-handtrack: カメラに映った手を追い、形と位置を 1 行 1 つの JSON で流し続ける(止めるまで)。

  ame-handtrack [-d /dev/videoN]

  {"event":"status","status":"downloading|loading|running|no_camera|no_model|failed"}
  {"event":"frame","w":640,"h":480,"hands":[手, …]}     手が映っていなければ "hands":[]
    手 = {"gesture":"none|point|pinch|open|fist|other|number","fingers":本数,
          "cx","cy"(カーソル。画面の 0〜1)・"px","py"(手のひらの中心。カメラの 0〜1)・
          "pinch","pinch_mid","pinch_ring"(親指と人差し指・中指・薬指の近さ ÷ 手の大きさ)・
          "ext"(伸びている指のビット)・"size"(手の大きさ ÷ 画像の幅)・"right"(右手らしさ)・
          "pts"(関節 21 点の [x, y, z]。画像の画素)}
    先頭の手がカーソルを動かす手(先に見つかった方。消えたらもう一方)。2 つまで。

手の認識(推論・追跡・形)は ame-hand(github.com/TatsuyaM2667/ame-hand)。モデル(MediaPipe の
hand_landmarker.task、Apache-2.0)は $XDG_DATA_HOME/ame-shell/models に無ければ ame-yatagarasu で取ってくる(版を決めた URL。SHA-256 を確かめる)。
手を追っている間は 1 秒に 30 コマまで、見つかっていない間は 4 コマまで。SIGTERM / SIGINT でカメラを閉じて終わる。
ame-shell のハンド操作はこれを動かして、出てくる行を操作にしている(カメラ・推論で詰まっても画面は止まらない)。
```

## ビルド

```sh
zig build -Doptimize=ReleaseSafe   # zig-out/bin/ame-handtrack(Zig 0.13、libc。手の認識の ame-hand は初回に取ってくる)
zig build test
```

実行に要るもの: `ame-yatagarasu`

## このリポジトリについて

正本は ame-shell の `src/cmd/ame-handtrack.zig` です。このリポジトリは `scripts/split-repos.sh` が生成して同期しています。
直したいところがあれば ame-shell の方へお願いします。

ライセンス: GPL-3.0(ame-shell と同じ)
