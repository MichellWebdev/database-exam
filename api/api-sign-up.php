<?php 

// VALIDATION
// Name 
if(!isset($_POST['name'])){
  sendError(400, 'missing name', __LINE__);
}
if(strlen($_POST['name']) < 2){
  sendError(400, 'name must contain at least 2 characters', __LINE__);
}
if(strlen($_POST['name']) > 30){
  sendError(400, 'name cannot contain more than 30 characters', __LINE__);
}

// Last name
if(!isset($_POST['lastName'])){
  sendError(400, 'missing last name', __LINE__);
}
if(strlen($_POST['lastName']) < 2){
  sendError(400, 'last name must be at least 2 characters', __LINE__);
}
if(strlen($_POST['lastName']) > 30){
  sendError(400, 'last name cannot contain more than 30 characters', __LINE__);
}

// User name 
if(!isset($_POST['profileName'])){
  sendError(400, 'missing profile name', __LINE__);
}
if(strlen($_POST['profileName']) < 2){
  sendError(400, 'profile name must be at least 2 characters', __LINE__);
}
if(strlen($_POST['profileName']) > 50){
  sendError(400, 'profile name cannot contain more than 50 characters', __LINE__);
}

// Email 
if(!isset($_POST['email'])){
  sendError(400, 'missing email', __LINE__);
}
if(!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)){
  sendError(400, 'email is not valid', __LINE__);
}

// Password
if(!isset($_POST['password'])){
  sendError(400, 'missing password', __LINE__);
}
if(strlen($_POST['password']) < 6){
  sendError(400, 'password must be at least 6 characters', __LINE__);
}
if(strlen($_POST['password']) > 100){
  sendError(400, 'password cannot contain more than 100 characters', __LINE__);
}

// Hash password
$_POST['password'] = password_hash($_POST['password'], PASSWORD_DEFAULT);

// TODO: Insert default image if no image is chosen
// so if not isset then insert the default image path


// Connect to database
require_once(__DIR__.'/../protected/db.php');

// try catch 
try{
  $query = $db->prepare('INSERT INTO users VALUES (NULL, :user_name, :user_last_name, :user_profile_name, :user_email, :user_password, :user_image_path, 
  CURRENT_TIMESTAMP, :user_active, :user_verification_code, "0", "0")');

  $query->bindValue(':user_name', $_POST['name']);
  $query->bindValue(':user_last_name', $_POST['lastName']);
  $query->bindValue(':user_profile_name', $_POST['profileName']);
  $query->bindValue(':user_email', $_POST['email']);
  $query->bindValue(':user_password', $_POST['password']);
  $query->bindValue(':user_image_path', 'default-image.png');
  $query->bindValue(':user_active', 1); // TODO: Make active once user has clicked on the varification code send to that persons email
  $query->bindValue(':user_verification_code', getUuid()); // TODO: send in an email 

  $query->execute();
  $id = $db->lastInsertId();

  http_response_code(200); // this line is default
  header('Content-Type: application/json');
  echo '{"id":'.$id.'}';
  header('Location: ../index.php');
  exit();

  // Session start and set session with id



}catch(Exception $ex){
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


// NEEDS TO BE SEND VIA EMAIL 
// ###############################################################
// ###############################################################
// ###############################################################
  function getUuid(){
    return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff), mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
  }