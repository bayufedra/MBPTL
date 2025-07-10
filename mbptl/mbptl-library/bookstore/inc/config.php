<?php
$host = "127.0.0.1";
$user = "root";
$pass = "rootp@ssw0rd123";
$db   = "bookstore";

$conn = mysqli_connect($host, $user, $pass) or die("Error 1");
mysqli_select_db($conn, $db) or die("Error 2");
