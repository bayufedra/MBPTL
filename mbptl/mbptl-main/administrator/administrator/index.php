<?php

session_start();
require_once 'inc/config.php';

if (!empty($_POST)) {

	$username = mysqli_real_escape_string($conn, $_POST['username']);
	$password = md5(mysqli_real_escape_string($conn, $_POST['password']));
	$query = "SELECT * FROM users WHERE username = '{$username}' AND password = '{$password}'";
	$login = mysqli_query($conn, $query);

	if (mysqli_num_rows($login) == 0) {
		header("Location: index.php");
		exit();
	} else {
		$_SESSION['admin'] = 1;
		header("Location: admin.php");
	}
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <!-- Add Bootstrap CSS link here -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .login-container {
            max-width: 400px;
            margin: auto;
            margin-top: 100px;
        }

        .login-form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .login-form h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .btn-login {
            width: 100%;
        }
    </style>
</head>
<body>

<div class="container login-container">
    <div class="login-form">
        <h2><b>Login</b></h2>
        <form action="" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-login">Login</button>
        </form>
    </div>
</div>

<div class="container">
    <center>
        <p>MBPTL-4{eb75482e45154917d44882e0c4a8e68f}</p>
    </center>
</div>

<!-- Add Bootstrap JS and Popper.js scripts here -->
<script src="../js/jquery-3.3.1.slim.min.js"></script>
<script src="../js/popper.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

</body>
</html>
