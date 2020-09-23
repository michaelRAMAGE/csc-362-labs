<?php

    // error outputting
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    // credentials for db connection object
    $dbhost = 'localhost';
    $dbuser = 'ming';
    $dbpass = 'password'; 


    // create db connection object 
    $conn = new mysqli($dbhost, $dbuser, $dbpass); 
    
    // error handling for db connection 
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

    // check if post is non-null (set)
    if (isset($_POST['name'])) {     // post has been set 
        echo $_POST['name']."'s tables are listed below<br>";
        $req_dbname = $_POST['name']; // get post val from _POST superglob assoc array
        $dblist = "SHOW TABLES FROM ".$req_dbname.";"; // construct query to be requested        
        if (!$conn->query($dblist)) { // query generated error, handle
            printf("Error message: %s\n", $conn->error);
        }
        else {
            $result = $conn->query($dblist); // request query 
            while ($row = $result->fetch_array()) { // fetch_array returns row array,                                           
                echo $row[0] . "<br>"; // table[idx] is first element of row array
            } 
        }
    } 
    else { // post has not yet been set
        echo "Type in a database to list its tables<br>";
    }
    $conn->close(); 
?> 

<!-- FORM FOR SUBMITTING DATABASE NAME, WHERE TABLES 
    WILL BE LISTED -->
<html>
    <body>
        <form action="connect.php" method="post">
            Database Name: <input type="text" name="name"><br>
            <input type="submit">
        </form>
    </body>
</html>

