<?php require_once 'inc/config.php'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Book Detail</title>
  <?php require_once 'inc/header.php'; ?>
</head>
<body>

<div class="container mt-4">
  <h2>Book Detail</h2>
  <div class="row">
    <div class="col-md-4">
      <?php
        $sql = "SELECT * FROM books WHERE id = {$_GET['id']} LIMIT 1";
        $result = $conn->query($sql);

        if ($result === false) {
            echo "Error: " . $conn->error;
        } else {
            $row = $result->fetch_assoc();

            if ($row) {
                if (strpos($row["image"], "http://") !== false) {
                    echo '<img src="'. $row["image"] .'" alt="'. $row["title"] .'" class="img-fluid">';
                } else {
                    echo '<img src="img/'. $row["image"] .'" alt="'. $row["title"] .'" class="img-fluid">';
                }
            } else {
                echo "Book not found.";
            }
        }

      ?>
    </div>
    <div class="col-md-8">
      <?php
        if ($result === false) {
            echo "Error: " . $conn->error;
            echo "<p>MBPTL-5{4bcce60b74914398c04eb5b546995408}</p>";
        } else {
            if ($row) {
                echo "<h3>Title: " . $row["title"] . "</h3>";
                echo "<p>Author: " . $row["author"] . "</p>";
                echo "<p>Description: " . $row["description"] . "</p>";
                echo "<p>ID: " . $row["id"] . "</p>";
            } else {
                echo "Book not found.";
            }

            $result->free();
        }

        $conn->close();

      ?>
    </div>
  </div>
</div>

<div class="container mt-4">
    <a href="index.php" class="btn btn-primary">Back to Home</a>
</div>

<?php require_once 'inc/footer.php'; ?>

</body>
</html>
