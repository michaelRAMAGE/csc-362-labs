DROP DATABASE IF EXISTS daycare;
CREATE DATABASE daycare;
USE daycare;

/* Create a table for 'Trainers' */
CREATE TABLE Trainers (
    PRIMARY KEY(trainer_id),
    trainer_id INT AUTO_INCREMENT /* change from auto to something else */,
    trainer_name VARCHAR(30)
);

/* Create a table for 'Pokemon' */
CREATE TABLE Pokemon (
    PRIMARY KEY(pokemon_id),
    pokemon_id INT AUTO_INCREMENT,
    pokemon_name VARCHAR(20),
    trainer_id INT NOT NULL,
    CONSTRAINT `trainer_fk` 
        FOREIGN KEY (trainer_id) 
        REFERENCES Trainers(trainer_id)
);

/** Filling tables with play values **/ 
INSERT INTO Trainers(trainer_name) 
VALUES
    ('jeff'), ('james'), ('august'),('brandon'); 
INSERT INTO Pokemon(pokemon_name, trainer_id) 
VALUES
    ('a',1),('b',2),('c',3),('d',4); 

/** GET Trainer corresponding to a given pokemon **/ 
DELIMITER //
CREATE FUNCTION get_trainer(_pokemon_id INT) 
  RETURNS INT 
  BEGIN
    RETURN (SELECT trainer_id 
            FROM Pokemon WHERE pokemon_id = _pokemon_id);
  END //
DELIMITER ;

/* Swap the trainers for two pokemon */
DELIMITER //
CREATE PROCEDURE
    `SWAP_POKEMON`(
        IN _pokemon_idA INT,
        IN _pokemon_idB INT
    )
    BEGIN
        /** TrainerA gets PokemonB,
            TrainerB gets PokemonA. **/

        /* get_trainer gets trainer of provided pokemon */
        SET @_trainer_idA = get_trainer(_pokemon_idA);
        SET @_trainer_idB = get_trainer(_pokemon_idB);

        SELECT * FROM Pokemon; /* SELECT BEFORE */

        START TRANSACTION; /* All or nothing */

            /* UPDATE trainer_id ON EACH Pokemon for swap */
            UPDATE Pokemon SET trainer_id = @_trainer_idB 
                WHERE pokemon_id = _pokemon_idA;
            UPDATE Pokemon SET trainer_id = @_trainer_idA
                WHERE pokemon_id = _pokemon_idB; 

        COMMIT; 

        SELECT * FROM Pokemon; /* SELECT BEFORE */
    END; //
DELIMITER ;

