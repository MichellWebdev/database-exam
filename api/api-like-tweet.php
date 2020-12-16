<?php 
session_start();
if(!isset($_SESSION['user_id'])) {
  sendError(400, 'not logged in', __LINE__);
}

require_once(__DIR__.'/../protected/db.php');

try {
  $query = $db->prepare('UPDATE tweets SET tweets.tweet_total_likes = tweets.tweet_total_likes + 1 WHERE tweets.tweet_id = :tweet_id');
  $query->bindValue(':tweet_id', $_POST['tweet_id']);
  $query->execute();

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
