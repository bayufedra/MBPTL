<?php
$host = "db";
$user = "root";
$pass = "rootp@ssw0rd123";
$db   = "administrator";
$conn = mysqli_connect($host, $user, $pass) or die("Error 1");
mysqli_select_db($conn, $db) or die("Error 2");
