// sakuraphplint.js サクラエディタのphp構文検証用マクロ
//
// 2012/03/25 epi 新規作成
// 
// ※注意：
//   検証するファイルが保存されている状態でないとphpが検証出来ません。
//   なので、ファイルを保存した状態でマクロを実行して下さい。
//   あと、このファイルの記述がUTF-8で行われているために問題が起きるかもしれません。
//   もし問題が起きたら文字コード変換してみてね。
//
// TODO: 出力整形、エラー行へのナビゲート、プロンプトを出さないように(出来るのかな？)

function sakuraphplint()
{
  var filepath = '\"' + GetFileName() + '\"'; // 編集しているファイルのパス 要エスケープ
  var phpcommand = "C:\\php-5.4.0\\php.exe -l "; // phpのパス -l オプションで構文検証を行わせる ※この行は書き換えてね！
  var wshell = new ActiveXObject("WScript.Shell"); // WScriptのオブジェクトを生成

  var objexec = wshell.Exec(phpcommand + filepath); // phpによる構文検証の結果を取得
  var resultstring = objexec.StdOut.ReadAll(); // 標準出力に吐かれた内容を取得

  /* 余裕があれば、ここで出力整形とかエラー行へのナビゲートとか入れたいなー */

  Editor.WarnMsg(resultstring); // 表示 本当ならエラー無しとエラー有りの振り分けをすべきなんですが…
}

sakuraphplint();
