<?php
// session_start();
// if(!isset($_SESSION['user_id'])) {
//   sendError(400, 'not logged in', __LINE__);
// }

if(!isset($_POST['tweet_message'])){
  sendError(400, 'missing tweet message', __LINE__);
}

if(strlen($_POST['tweet_message']) < 1){
  sendError(400, 'tweet must be at least on ehcaracter', __LINE__);
}

if(strlen($_POST['tweet_message']) > 140){
  sendError(400, 'tweet cannot be more than 140 characters', __LINE__);
}

if(!isset($_POST['tweet_id'])) {
  sendError(400, 'missing tweet id', __LINE__);
}

require_once(__DIR__.'/../protected/db.php');

try {
  //somehow make sure that only the user that tweet belongs to can update the tweet
  $query = $db->prepare('UPDATE tweets SET tweet_message = :tweet_message WHERE tweet_id = :tweet_id');

  $query->bindValue(':tweet_message', $_POST['tweet_message']);
  $query->bindValue(':tweet_id', $_POST['tweet_id']); 

  $query->execute();
  $tweet_id = $db->lastInsertId();

  // if 0 rows are affected then show error message (should happen with no match in either tweet id and/or user id)
  if($query->rowCount() == 0 ){
    sendError(500, 'tweet could not be updated', __LINE__);
  }

  header('Content-Type: application/json');
  echo '{"message":"tweet message was updated with: '.$tweet_id.'"}';

} catch(Exception $ex){
  echo $ex;
  // sendError(500, 'system is under maintenance', __LINE__);
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