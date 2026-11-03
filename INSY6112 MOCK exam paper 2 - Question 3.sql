
-- Q.3.1

-- I create the schema for this exam
CREATE SCHEMA IF NOT EXISTS surfspots_ST10471627;

-- I work inside the new schema
USE surfspots_ST10471627;


-- I create the Surfer table
CREATE TABLE Surfer (
    SurferID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    BoardType VARCHAR(100) NOT NULL
);


-- I create the Beach table
CREATE TABLE Beach (
    BeachID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(1000) NULL
);


-- I create the Session bridging table
CREATE TABLE `Session` (
    SessionID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    SurferID INT NOT NULL,
    BeachID INT NOT NULL,
    `Date` DATE NOT NULL,
    WaveRating INT NULL,

    -- I link each session to a surfer
    FOREIGN KEY (SurferID) REFERENCES Surfer(SurferID),

    -- I link each session to a beach
    FOREIGN KEY (BeachID) REFERENCES Beach(BeachID)
);


-- Q.3.2

-- I insert the surfers
INSERT INTO Surfer (SurferID, Name, BoardType)
VALUES
(1, 'Kai', 'Longboard and shortboard'),
(2, 'Zinhle', 'Shortboard'),
(3, 'Liam', 'Bodyboard');


-- I insert the beaches
INSERT INTO Beach (BeachID, Name, Description)
VALUES
(1, 'New Pier', 'Consistent beach break on the Durban beachfront. Lifeguards on duty.'),
(2, 'Cave Rock', 'Fast, hollow reef break on the Bluff. Experienced surfers only');


-- I insert the surf sessions
INSERT INTO `Session` (SessionID, SurferID, BeachID, `Date`, WaveRating)
VALUES
(1, 1, 1, '2024-07-06', 8),
(2, 2, 2, '2024-07-06', 9),
(3, 1, 2, '2024-07-13', 6),
(4, 3, 1, '2025-01-04', 7);


-- Q.3.3

-- I query all beaches in reverse alphabetical order
SELECT *
FROM Beach
ORDER BY Name DESC;


-- Q.3.4

-- I query surfers who have shortboard in their board type
SELECT Name, BoardType
FROM Surfer
WHERE BoardType LIKE '%shortboard%';


-- Q.3.5

-- I count the number of sessions each surfer has had
SELECT Surfer.SurferID, COUNT(`Session`.SessionID) AS NumberOfSessions
FROM Surfer
LEFT JOIN `Session`
ON Surfer.SurferID = `Session`.SurferID
GROUP BY Surfer.SurferID;


-- Q.3.6

-- I query the surfer name, beach name, date and wave rating for each session
SELECT
    Surfer.Name,
    Beach.Name,
    `Session`.`Date`,
    `Session`.WaveRating
FROM `Session`
INNER JOIN Surfer
ON `Session`.SurferID = Surfer.SurferID
INNER JOIN Beach
ON `Session`.BeachID = Beach.BeachID;


-- Q.3.7

-- I create a view for sessions between the specified dates
CREATE VIEW sessions_2024 AS
SELECT
    Beach.Name AS BeachName,
    Surfer.Name AS SurferName,
    `Session`.`Date`
FROM `Session`
INNER JOIN Beach
ON `Session`.BeachID = Beach.BeachID
INNER JOIN Surfer
ON `Session`.SurferID = Surfer.SurferID
WHERE `Session`.`Date` BETWEEN '2024-06-01' AND '2024-12-31';


-- I display the sessions from the newly created view
SELECT *
FROM sessions_2024;


-- Q.3.8

-- I create a stored procedure to find the highest wave rating
DELIMITER //

CREATE PROCEDURE best_wave_rating(IN inputBeachID INT)
BEGIN
    SELECT MAX(WaveRating) AS HighestWaveRating
    FROM `Session`
    WHERE BeachID = inputBeachID;
END //

DELIMITER ;


-- I call the stored procedure for Cave Rock
CALL best_wave_rating(2);
