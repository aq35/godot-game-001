シグナルはGodotに組み込まれた委任メカニズムで、あるゲームオブジェクトが別のゲームオブジェクトの変更に反応する際に、それらを相互参照させることなく反応できるようにするものです。

シグナルを使うと、 結合度 を制限し、コードの柔軟性を保つことができます。

例えば、画面上にプレイヤーの体力を表すライフバーがあるとします。

プレイヤーがダメージを受けたり、回復薬を使ったりした場合には、その変化をバーに反映されるようにしたいとします。これを実現するために、Godotではシグナルを使用します。

Connects this signal to the specified param callable.
Signal Connect は、このシグナルを指定した callable に繋ぐ関数だよ。

Optional param flags can be also added to configure the connection's behavior
オプションで flags を渡すと、接続の挙動を細かく設定できますよ

You can provide additional arguments to the connected param callable by using Callable.bind.
それから、Callable.bind を使えば、呼び出される関数に追加の引数も渡せますよ

A signal can only be connected once to the same Callable.
シグナルは、同じ Callable には1回しか繋げないよ。

If the signal is already connected
もしすでに繋がってるのにもう一度接続しようとすると

returns ERR_INVALID_PARAMETER and pushes an error message,
ERR_INVALID_PARAMETER を返してエラーメッセージを出しますよ

unless the signal is connected with Object.CONNECT_REFERENCE_COUNTED
ただし、Object.CONNECT_REFERENCE_COUNTED で接続している場合は例外だよ。

To prevent this, use is_connected first to check for existing connections.
だから、失敗しないようにしたければ、最初に is_connected を呼んで「もう繋がってるかどうか」を確認してからやるといいよ。
