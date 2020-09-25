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
    }
?> 
