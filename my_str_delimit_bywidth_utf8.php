<?php

/**
 * 文字列一定幅(全角半角を考慮)ごとに文字列を挟む関数
 * 
 * @param $str            入力文字列
 * @param $charwidth      目的の文字幅
 * @param $delimiterstr   挿入する文字列(ex.改行文字)
 * @return string         処理後文字列
 */
function my_str_delimit_bywidth_utf8($str, $charwidth, $delimiterstr)
{
  $maxwidth = (int)$charwidth; //目的の文字幅
  $curwidth = 0; //現在の(開始or分割後の)文字幅
  $len = mb_strlen($str, 'UTF-8'); //引数$strのUTF-8での文字数
  $waterline = 0; //分割した点の$strの頭からの文字数マーク
  $curnum = 0; //現在の$strの頭からの文字数
  $strarray = array(); //分割した文字列を格納する配列
  while ($curnum < $len)
  {
    $onechar = mb_substr($str, $curnum, 1, 'UTF-8');
    if(( ' ' <= $onechar && $onechar <= '~' ) || //SJISでの半角記号英数字部
        ( '｡'<= $onechar && $onechar <= 'ｿ' ) || //SJISでの半角ｶﾅその1
        ( 'ﾀ' <= $onechar && $onechar <= 'ﾟ' ) || //SJISでの半角ｶﾅその2
        ( $onechar === '\\' ) || //バックスラッシュ
        ( $onechar === '‾' )) //半角アッパーライン
    {
      if($curwidth===$maxwidth){
        //文字が半角の場合、目的の文字幅で分割
        $strarray[] = mb_substr($str, $waterline, $curnum - $waterline, 'UTF-8');
        $waterline = $curnum;
        $curwidth = 1;
      }else{
        $curwidth += 1;
      }
    }
    else
    {
      if($curwidth>=$maxwidth - 1){
        //文字が全角の場合、目的の(文字幅-1)以上で分割
        $strarray[] = mb_substr($str, $waterline, $curnum - $waterline, 'UTF-8');
        $waterline = $curnum;
        $curwidth = 2;
      }else{
        $curwidth += 2;
      }
    }
    $curnum++; //文字を1進める
  }
  if($let = mb_substr($str, $waterline, $len - $waterline, 'UTF-8')){$strarray[] = $let;} //残りの文字列
  $retstr = implode($delimiterstr,$strarray); //implode()で分割した文字列の配列を文字列に
  return $retstr;
}

