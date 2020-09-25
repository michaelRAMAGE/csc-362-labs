<?php

    // Diff full sample set of data with existing db data 
    // for repopulating table after deletions. 
    function diff_rows($conn) {
        $default_types = array("Harmonic", "Narmonica", "Guitar", 
            "Broomstick", "Ocarina", "Bouzouki", "Didgeridoo",
            'Trumpet',
            'Flute',
            'Theremin',
            'Violin',
            'Tuba',
            'Melodica',
            'Trombone',
            'Keyboard' 
        );
        $existing_types = array(); 
        $dbquery = "SELECT InstType FROM Instruments.instruments";
        if(!$conn->query($dbquery)){
            echo "Query failed!";
            exit;
        }
        $result = $conn->query($dbquery)->fetch_all();
        foreach ($result as $row) {
            array_push($existing_types,$row[0]); 
        }
        $diff_result = array_diff($default_types, $existing_types);
        unset($existing_types); 
        return array_values($diff_result);
    }
    
    // Translate sql data into HTML markup
    function result_to_table($result) {
        $qryres = $result->fetch_all(); 
        $n_rows = $result->num_rows;
        $n_cols = $result->field_count; 
        
        // Description of table 
        echo "<p>This table has $n_rows and $n_cols columns.</p>\n";
        
        // Begin header 
        echo "<form action='manageInstruments.php' method='post'>";
        echo "<table>\n<thead>\n<tr>";

        $fields = $result->fetch_fields();
        echo "<td><b>Delete? </b></td>";
        for ($i=0; $i<$n_cols; $i++){
            echo "<td><b>" . $fields[$i]->name . "</b></td>";
        }
        echo "</tr>\n</thead>\n";

        // Begin body 
        for ($i=0; $i<$n_rows; $i++){
            $inst_id = $qryres[$i][0];
            $inst_type = $qryres[$i][1];
            echo "<tr>";
            echo "<td>
                    <input type='checkbox' 
                        name=\"data[$i][inst_type]\"
                        value=\"$inst_id\" 
                    />
                </td>";

            for($j=0; $j<$n_cols; $j++){
                echo "<td>" . $qryres[$i][$j] . "</td>";
            }
            echo "</tr>\n";
        }
        echo "</tbody>\n</table>\n";
        echo "<tr> <input type='submit'> </tr>";
        echo "</form>";
        
    }
?> 

