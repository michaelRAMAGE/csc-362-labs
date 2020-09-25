<!DOCTYPE html>
<html>
<head>
<title>Table Details View</title>
</head>
<body>
    <?php
        include 'connect.php'; // inherits variable scope of connect.php
        include 'helpers.php'; // bring in some helper functions 
        
        // Show ALL PHP's errors.
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
        error_reporting(E_ALL);

        if (isset($_POST["populate"])) { // intercept request to repopulate with sample data
            echo "Last action: Repopulating rows";
            $array_of_types = diff_rows($conn);
            $len = count($array_of_types);
            $fstring_of_types = ""; 
            if ($len > 0) {
                $format = "('%s'),";
                for ($i=0; $i<$len; $i++) {
                    if ($i != $len-1) {
                        $fstring_of_types = $fstring_of_types.sprintf($format, $array_of_types[$i]);
                    }
                    else {
                        $format = "('%s')";
                        $fstring_of_types = $fstring_of_types.sprintf($format, $array_of_types[$i]);
                    }
                }
                unset($array_of_types); 
                $dbquery = "INSERT INTO Instruments.instruments(InstType) 
                                VALUES $fstring_of_types";
                if (!$conn->query($dbquery)) {
                    echo 'Unsuccessful query!';
                    echo $conn->error; 
                }       
            }
            else {
                echo "No need to repopulate. All sample data here!";
            }
            $_POST["populate"] = array();
        }   

        if (isset($_POST['data'])) { // intercept post request to delete data
            echo "Last action: Deleting rows";
            $del_stmt = $conn->prepare("DELETE FROM Instruments.instruments WHERE InstID = ?");
            foreach($_POST['data'] as $val) {
                foreach ($val as $id) {
                    $del_stmt->bind_param('i', $id); 
                    if (!$del_stmt->execute()) {
                        echo 'Unsuccessful query!';
                        echo $conn->error; 
                    }
                }
            }
            $_POST["data"] = array();
        }

        // get data from db
        $sql = "SELECT InstID, InstType FROM Instruments.instruments";
        if(!$conn->query($sql)){
            echo "Query failed!";
            exit;
        }
        $result = $conn->query($sql);
        result_to_table($result); // generate table from db query res

        $conn->close(); // clean up
        
    ?>

    <br>
    <form action="manageInstruments.php" method="post">
        Repopulate table <input type="submit" name="populate">
    </form>


</body>
</html>