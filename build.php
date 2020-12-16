<?php
// ini_set('display_errors', 0);
// CSS
$sCss = '';
$i = 0;
foreach(glob('./css/*') as $filename){
  // echo '<div>'.$filename.'</div>';
  // creates a file called app.css
  if( strpos($filename, 'app.css') ){ echo 'skip'.$filename; continue; }
  // echo '<div>'.$filename.'</div>';
  $sCss = $sCss . trim(file_get_contents($filename));
  // echo '<div>'.$sCss .'</div>';
  $i++;
  echo $i;
}
// echo $sData;
// file_put_contents(__DIR__.'/css/app.css', '');
file_put_contents(__DIR__.'/css/app.css', $sCss);


// JS
$sJs = '';
foreach(glob('./js/*') as $filename){
  // echo $filename;
  if( strpos($filename, 'app.js') ){ continue; }
  $sJs .= trim(file_get_contents($filename));
}

// echo $sJs;
file_put_contents(__DIR__.'/js/app.js', $sJs);