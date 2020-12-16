<?php

try{
  $dbUserName = 'root';
  $dbPassword = 'root'; // root | admin
  
  $dbConnection = 'mysql:host=localhost; dbname=twitter3; charset=utf8mb4'; 
  
  $options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, 
    // PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    // PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_NUM
  ];

  $db = new PDO(  $dbConnection, 
                  $dbUserName, 
                  $dbPassword , 
                  $options      );
  
}catch(PDOException $ex){
  http_response_code(500); // internal server error
  header('Content-Type: application/json');
  echo '{"message": "Contact the system admin about error: '.__LINE__.'"}';
  exit();
}