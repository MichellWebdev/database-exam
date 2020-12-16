<?php 
session_start();
if(!isset($_SESSION['user_id'])) {
  sendError(400, 'not logged in', __LINE__);
}

// VALIDATE TWEET ID

require_once(__DIR__.'/../protected/db.php');

try {
  $query = $db->prepare('DELETE FROM tweets WHERE tweet_id = :tweet_id AND tweet_user_fk = :user_id');

  $query->bindValue(':tweet_id', $_POST['tweet_id']);
  $query->bindValue(':user_id', $_SESSION['user_id']);

  $query->execute();

  if($query->rowCount() == 0){
    sendError(400, "id is not valid", __LINE__);
  }

  header('Content-Type: application/json');
  echo '{"tweet id":"tweet message was deleted '.$_POST['tweet_id'].'"}';

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

