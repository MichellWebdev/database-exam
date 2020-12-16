<?php
session_start();
if(!isset($_SESSION['user_id']) && !isset($_SESSION['user_name'])){
  header('Location: components/login.php');
  exit();
}

// Tweet message validation
if(!isset($_POST['tweet_message'])){
  sendError(400, 'missing tweet message', __LINE__);
}
if(strlen($_POST['tweet_message']) < 1) {
  sendError(400, 'tweet must be at least 1 character', __LINE__);
}
if(strlen($_POST['tweet_message']) > 140 ) {
  sendError(400, 'tweet cannot be more than 140 characters', __LINE__);
}

// Connect to database 
require_once(__DIR__.'/../protected/db.php');

try {
// make query prepare
$query = $db->prepare('INSERT INTO tweets VALUES (NULL, :tweet_user_fk, :tweet_message, CURRENT_TIMESTAMP, :tweet_active, :tweet_image_path, :tweet_total_likes, :tweet_total_comments)'); 

$query->bindValue(':tweet_user_fk', $_SESSION['user_id']); 
$query->bindValue(':tweet_message', $_POST['tweet_message']);
$query->bindValue(':tweet_active', 1);
$query->bindValue('tweet_image_path', '');
$query->bindValue('tweet_total_likes', 0);
$query->bindValue('tweet_total_comments', 0);

$query->execute();

if($query->rowCount() == 0){
  sendError(500, 'tweet could not be created', __LINE__);
}

$tweet_id = $db->lastInsertId();
header('Content-Type: application/json');
echo '{"tweet_id":'.$tweet_id.'}';
exit();


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