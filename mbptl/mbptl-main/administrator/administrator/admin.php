<?php
session_start();
require_once 'inc/config.php';

if (!$_SESSION['admin']) {
    header("Location: index.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $title = $_POST["title"];
    $author = $_POST["author"];
    $description = $_POST["description"];

    $targetDirectory = "uploads/";
    $imageName = basename($_FILES["image"]["name"]);
    $imageExtension = end(explode('.', $imageName));
    $targetFile = $targetDirectory . md5(time() . rand() . $imageName) . '.' . $imageExtension;

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
        $imageLink = 'http://' . $_SERVER['HTTP_HOST'] . '/administrator/' . $targetFile;

        $sql = "INSERT INTO bookstore.books (title, author, image, description) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssss", $title, $author, $imageLink, $description);

        if ($stmt->execute()) {
            echo "<script>alert('Book inserted successfully!');</script>";
        } else {
            echo "<script>alert('Error: " . $stmt->error ."');</script>";
        }

        $stmt->close();
    } else {
        echo "<script>alert('Sorry, there was an error uploading your file');</script>";
    }

    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Insert Book</title>
    <!-- Add Bootstrap CSS link here -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
</head>
<body>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><b>Admin - Insert Book</b></h2>
        <div>
            <a href="/administrator/main" class="btn btn-primary me-2">Download Binary for MBPTL Internal Service</a>
            <a href="logout.php" class="btn btn-danger">Logout</a>
        </div>
    </div>

    <form action="" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="title">Title:</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="form-group">
            <label for="author">Author:</label>
            <input type="text" class="form-control" id="author" name="author" required>
        </div>
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea class="form-control" id="description" name="description"></textarea>
        </div>
        <div class="form-group">
            <label for="image">Image Upload:</label>
            <input type="file" class="form-control-file" id="image" name="image" accept="image/*">
        </div>

        <button type="submit" class="btn btn-primary">Insert Book</button>
    </form>
    <div class="container">
        <center>
            <p>MBPTL-7{e77ac27271c6e54470db47228b9eca09}</p>
        </center>
    </div>
</div>
<!-- Add Bootstrap JS and Popper.js scripts here -->
<script src="../js/jquery-3.3.1.slim.min.js"></script>
<script src="../js/popper.min.js"></script>
<script src="../js/bootstrap.min.js"></script>

</body>
</html>
