<?php 

require_once(__DIR__.'/../protected/db.php');

$iLatestTweetId = $_GET['iLatestTweetId'] ?? 0;

try{
  $q = $db->prepare('SELECT * FROM tweets 
  WHERE tweet_id > :iLatestTweetId LIMIT 5');
  $q->bindValue(':iLatestTweetId', $iLatestTweetId);
  $q->execute();
  $aRows = $q->fetchAll();
  // print_r($aRows);

} catch(Exception $ex){
  sendError(500, 'system is under maintenance', __LINE__);
}

// ###############################################################
// ###############################################################
// ###############################################################
function sendError ($iResponseCode, $sMessage, $iLine){
  http_response_code($iResponseCode);
  header('Content-Type: application/json');
  echo '{"message":"'.$sMessage.'", "error":"'.$iLine.'"}';
  exit();
}