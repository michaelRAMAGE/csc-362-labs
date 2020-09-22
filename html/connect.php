

<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $dbhost = 'localhost';
    $dbuser = 'ming';
    $dbpass = 'password'; 

    $conn = new mysqli($dbhost, $dbuser, $dbpass); 
    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection,
        here is why: ". "<br>";
        echo "Errno: " . $conn->connect_errno . "\n";
        echo "Error: " . $conn->connect_error . "\n";
        exit; // Quit this PHP script if the connection fails.
    } else {
        echo "Connected Successfully!" . "<br>";
        echo "YAY!" . "<br><br>";
    } 

    if (isset($_POST['name'])) {
        echo $_POST['name']."'s tables are listed below<br>";
        $req_dbname = $_POST['name']; // get post val from _POST superglob assoc array
        $dblist = "SHOW TABLES FROM ".$req_dbname.";"; // construct query to be requested
        if (!$conn->query($dblist)) { // error handling
            printf("Error message: %s\n", $conn->error);
        }
        else {
            $result = $conn->query($dblist); // request query 
            while ($table = $result->fetch_array()) { // fetch_array returns row array,                                           
                echo $table[0] . "<br>";              // table[idx] is first element of row array
            } 
        }
    } 
    else {
        echo "Type in a database to list its tables<br>";
    }

    $conn->close(); 

?> 

<html>
    <body>
        <form action="connect.php" method="post">
            Database Name: <input type="text" name="name"><br>
            <input type="submit">
        </form>
    </body>
</html>

