<?php require_once 'inc/config.php'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Library</title>
  <?php require_once 'inc/header.php'; ?></head>
<body>

<div class="container mt-4">
  <h2>List of Books</h2>
  <table class="table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
      <?php
      $sql = "SELECT id, title, author FROM books";
      $result = $conn->query($sql);

      if ($result->num_rows > 0) {
          // Output data of each row
          while($row = $result->fetch_assoc()) {
              echo "<tr>
                      <td>{$row['id']}</td>
                      <td>{$row['title']}</td>
                      <td>{$row['author']}</td>
                      <td><a href=\"detail.php?id={$row['id']}\">View Details</a></td>
                    </tr>";
          }
      } else {
          echo "<tr><td colspan='4'>No books found</td></tr>";
      }

      $conn->close();
      ?>
    </tbody>
  </table>
</div>
<!-- MBPTL-1{bf094c0b92d13d593cbff56b3c57ad4d} -->
 
<?php require_once 'inc/footer.php'; ?>

</body>
</html>
