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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>

<div class="container mt-4">
    <h2>Admin - Insert Book</h2>
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
</div>

<!-- Add Bootstrap JS and Popper.js scripts here -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</body>
</html>
