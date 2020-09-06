/*
Michael Ramage
Lab 3
CSC Databases FALL 2020
*/

-- Create the database (dropping the previous version if necessary 
DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

/* START OF STEPS 1-5 */

-- -- Create Movies table 
-- CREATE TABLE Movies (
--     PRIMARY KEY (movie_id),
--     movie_id INT AUTO_INCREMENT,
--     movie_title VARCHAR(65),
--     release_date DATE,
--     genre VARCHAR(100)
-- );

-- -- Create Consumers table 
-- CREATE TABLE Consumers (
--     PRIMARY KEY (consumer_id),
--     consumer_id INT AUTO_INCREMENT,
--     first_name VARCHAR(20),
--     last_name VARCHAR(20),
--     address VARCHAR(46),
--     city VARCHAR(100),
--     state CHAR(2),
--     zip CHAR(5)
-- );

-- --  Create Ratings table 
-- CREATE TABLE Ratings (
--     PRIMARY KEY(rating_id),
--     rating_id INT AUTO_INCREMENT,
--     consumer_id INT,
--     movie_id INT, 
--     when_rated DATETIME, 
--     number_stars INT,
--     CONSTRAINT tb_fk1 FOREIGN KEY(consumer_id) REFERENCES
--         Consumers(consumer_id), 
--     CONSTRAINT tb_fk2 FOREIGN KEY(movie_id) REFERENCES 
--         Movies(movie_id)
-- );

-- /* INSERT values into Movies */
-- INSERT INTO Movies(movie_id, movie_title, release_date, genre)
-- VALUES
--     (1, "The Hunt for Red October", "1990-03-02", "Action, Adventure, Thriller"),
--     (2, "Lady Bird ", "2017-12-01", "Comedy, Drama"),
--     (3, "IncepAon ", "2010-08-16", "Action, Adventure, Sci-Fi");

-- /* INSERT values into Consumers */
-- INSERT INTO Consumers(consumer_id, first_name, last_name, address, city, state, zip) 
-- VALUES
--     (1, "Toru", "Okada", "800 Glenridge Ave", "Hobart", "IN", "46342"),
--     (2, "Kumiko", "Okada", "864 NW Bohemia St", "Vincentown", "NJ", "08088"),
--     (3, "Noboru", "Wataya", "342 Joy Ridge St", "Hermitage", "TN", "37076"),
--     (4, "May", "Kasahara", "5 Kent Rd East", "Haven", "CT", "06512");

-- /* INSERT values into Ratings */
-- INSERT INTO Ratings(movie_id, consumer_id, when_rated, number_stars)
-- VALUES
--     (1, 1, "2010-09-02 10:54:19", 4),
--     (1, 3, "2012-08-05 15:00:01", 3),
--     (1, 4, "2016-10-02 23:58:12", 1),
--     (2, 3, "2017-03-27 00:12:48", 2),
--     (2, 4, "2018-08-02 00:54:42", 4);

/* END OF STEP 1-5 */


-- STEPS 6+ -- 
DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

/* Create Movies table without multivalued genre field */ 
CREATE TABLE Movies (
    PRIMARY KEY (movie_id),
    movie_id INT AUTO_INCREMENT,
    movie_title VARCHAR(65),
    release_date DATE
);

-- Create Consumers table 
CREATE TABLE Consumers (
    PRIMARY KEY (consumer_id),
    consumer_id INT AUTO_INCREMENT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    address VARCHAR(46),
    city VARCHAR(100),
    state CHAR(2),
    zip CHAR(5)
);

--  Create Ratings table 
CREATE TABLE Ratings (
    PRIMARY KEY(rating_id),
    rating_id INT AUTO_INCREMENT,
    consumer_id INT,
    movie_id INT, 
    when_rated DATETIME, 
    number_stars INT,
    CONSTRAINT tb_fk1 FOREIGN KEY(consumer_id) REFERENCES
        Consumers(consumer_id), 
    CONSTRAINT tb_fk2 FOREIGN KEY(movie_id) REFERENCES 
        Movies(movie_id)
);

/* Create data table Genres for holding Genres */ 
CREATE TABLE Genres (
    PRIMARY KEY(genre_id),
    genre_id INT AUTO_INCREMENT,
    genre VARCHAR(15)
);

/* CREATE MovieGenres linking table */
CREATE TABLE MovieGenres (
    PRIMARY KEY(moviegenre_id),
    moviegenre_id INT AUTO_INCREMENT,
    movie_id INT,  
    genre_id INT,
    CONSTRAINT mv_fk FOREIGN KEY(movie_id) REFERENCES Movies(movie_id),
    CONSTRAINT gen_fk FOREIGN KEY(genre_id) REFERENCES Genres(genre_id)
);


/* INSERT values into Genres */
INSERT INTO Genres (genre)
VALUES ("Action"), ("Adventure"), 
       ("Thriller"), ("Drama"), 
       ("Sci-Fi"), ("Drama"), ("Comedy"); 

/* INSERT values into Movies */
INSERT INTO Movies(movie_id, movie_title, release_date)
VALUES
    (1, "The Hunt for Red October", "1990-03-02"),
    (2, "Lady Bird ", "2017-12-01"),
    (3, "IncepAon ", "2010-08-16");

/* INSERT values into Consumers */
INSERT INTO Consumers(consumer_id, first_name, last_name, address, city, state, zip) 
VALUES
    (1, "Toru", "Okada", "800 Glenridge Ave", "Hobart", "IN", "46342"),
    (2, "Kumiko", "Okada", "864 NW Bohemia St", "Vincentown", "NJ", "08088"),
    (3, "Noboru", "Wataya", "342 Joy Ridge St", "Hermitage", "TN", "37076"),
    (4, "May", "Kasahara", "5 Kent Rd East", "Haven", "CT", "06512");

/* INSERT values into Ratings */
INSERT INTO Ratings(movie_id, consumer_id, when_rated, number_stars)
VALUES
    (1, 1, "2010-09-02 10:54:19", 4),
    (1, 3, "2012-08-05 15:00:01", 3),
    (1, 4, "2016-10-02 23:58:12", 1),
    (2, 3, "2017-03-27 00:12:48", 2),
    (2, 4, "2018-08-02 00:54:42", 4);

INSERT INTO MovieGenres(movie_id, genre_id) 
VALUES 
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 7),
    (2, 4),
    (3, 1),
    (3, 2),
    (3, 5);


SELECT first_name, last_name, movie_title, number_stars
FROM Movies
NATURAL JOIN Ratings
NATURAL JOIN Consumers;

-- 