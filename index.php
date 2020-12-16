<?php 
session_start();
if(!isset($_SESSION['user_id']) && !isset($_SESSION['user_name'])){
  header('Location: components/login.php');
  exit();
}

?>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="css/app.css">
  <title>Twitter : : Clone</title>
</head>
<body>
  <div id="page">
    <?php require_once(__DIR__.'/protected/db.php') ?>
    <?php require_once(__DIR__.'/components/left/left.php') ?>
    <?php require_once(__DIR__.'/components/middle/middle.php') ?>
    <?php require_once(__DIR__.'/components/right/right.php') ?>
  </div>

  <script src="js/app.js"></script>
</body>
</html>