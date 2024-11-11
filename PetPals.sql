--CREATE DATABASE 

CREATE DATABASE PetPals

--CREATE TABLE SHELTER

CREATE TABLE Shelters (
    ShelterID INT IDENTITY PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);

--CRETAE TABLE PETS

CREATE TABLE Pets (
    PetID INT IDENTITY PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Age INT NOT NULL,
    Breed VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    AvailableForAdoption BIT NOT NULL DEFAULT 1,
    ShelterID INT,
    FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID)
);

--CREATE TABLE DONATIONS

CREATE TABLE Donations(
DonationId INT IDENTITY PRIMARY KEY ,
DonationNAme VARCHAR(255) NOT NULL,
DonationType VARCHAR (255) NOT NULL,
DonationAmount DECIMAL (10,2),
DonationItem VARCHAR(255),
DonationDate DATETIME NOT NULL ,
ShelterId INT,
FOREIGN KEY (ShelterId) REFERENCES Shelters(ShelterId)
)

--CREATE TABLE ADOPTIONEVENTS

CREATE TABLE AdoptionEvents(
EventId INT IDENTITY PRIMARY KEY,
EventName VARCHAR (255) NOT NULL,
EventDate DATETIME NOT NULL,
Location VARCHAR (255) NOT NULL
)

--CREATE TABLE PARTICIPANTS
CREATE TABLE Participants(
ParticipantId INT IDENTITY PRIMARY KEY,
ParticipantName VARCHAR(255) NOT NULL,
ParticipantType VARCHAR (255)NOT NULL,
)

--insert values

-- Insert values into Shelters table
INSERT INTO Shelters 
VALUES 
('Animal Friends Shelter', '123 Main St, New York'),
('Pawsome Pals Shelter', '456 Elm St, Los Angeles'),
('Furry Friends Shelter', '789 Oak St, Chicago');

-- Insert values into Pets table
INSERT INTO Pets
VALUES 
('Whiskers', 3, 'Siamese', 'Cat', 1, 1),
('Max', 1, 'Labrador Retriever', 'Dog', 1, 2),
('Luna', 4, 'Persian', 'Cat', 2, 3)

-- Insert values into Donations table
INSERT INTO Donations 
VALUES 
('John Doe', 'Cash', 100.00, 'Dress', '2022-01-01', 1),
('Jane Smith', 'Item', 750, 'Food and toys', '2022-02-01', 2),
('Bob Johnson', 'Cash', 500.00, NULL, '2022-03-01', 3);

-- Insert values into AdoptionEvents table
INSERT INTO AdoptionEvents
VALUES 
('Adopt-a-Pet Day', '2022-04-01', 'Central Park'),
('Pet Fair', '2022-05-01', 'Local Mall'),
('Furry Friends Festival', '2022-06-01', 'City Park');


-- insert value in participant table
ALTER TABLE Participants
ADD EventId INT 

ALTER TABLE Participants
ADD CONSTRAINT FK_Participants_AdoptionEvents
FOREIGN KEY (EventID)
REFERENCES AdoptionEvents(EventID);

INSERT INTO Participants 
VALUES
('John Doe', 'Adopter', 1),
('Jane Smith', 'Adopter', 2),
('Animal Friends Shelter', 'Shelter', 1)

--INSERT INTO EVENTS

INSERT INTO AdoptionEvents 
VALUES
('Adopt-a-Pet', '2022-04-01', 'Central Park'),
('Pet Fair', '2022-05-01', 'Local Mall'),
('Furry Friends Festival', '2022-06-01', 'City Park');

--INSERT INTO PARTICIANTS

INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID)
VALUES
(1, 'John Doe', 'Adopter', 1),
(2, 'Jane Smith', 'Adopter', 2),
(3, 'Animal Friends Shelter', 'Shelter', 1)

--4 Ensure the script handles potential errors, such as if the database or tables already exist

--CREATE TABLE USER
CREATE TABLE Users (
  UserID INT IDENTITY PRIMARY KEY,
  Name VARCHAR(255),
  Email VARCHAR(255) UNIQUE,
  Phone VARCHAR(20),
  Address VARCHAR(255)
);

--INSERT INTO USERS
INSERT INTO Users
VALUES
('John Doe', 'johndoe@example.com', '123-456-7890', '123 Main St'),
('Jane Smith', 'janesmith@example.com', '987-654-3210', '456 Elm St'),
('Bob Johnson', 'bobjohnson@example.com', '555-123-4567', '789 Oak St');


--CREATE TABLE PETADOPTION

CREATE TABLE PetAdoption (
  AdoptionID INT IDENTITY PRIMARY KEY,
  PetID INT,
  AdopterID INT,
  AdoptionDate DATE
);

--INSERT INTO PETADOPTION
INSERT INTO PetAdoption 
VALUES 
(1, 1, '2022-01-01'),
(2, 2, '2022-02-15'),
(3, 3, '2022-03-20');



--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption)from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure thatthe query filters out pets that are not available for adoption


SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;


--6. Write an SQL query that retrieves the names of participants (shelters and adopters) registeredfor a specific adoption event. Use a parameter to specify the event ID. Ensure that the queryjoins the necessary tables to retrieve the participant names and types.


SELECT P.ParticipantName, P.ParticipantType
FROM Participants P
JOIN AdoptionEvents E ON P.EventId= E.EventID
WHERE E.EventID = 1;


--7. Create a stored procedure in SQL that allows a shelter to update its information (name andlocation) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.Ensure that the procedure performs the update and handles potential errors, such as an invalidshelter ID



--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (byshelter name) from the "Donations" table. The result should include the shelter name and thetotal donation amount. Ensure that the query handles cases where a shelter has received nodonations


SELECT S.Name, COALESCE(SUM(D.DonationAmount), 0) AS TotalDonationAmount
FROM Shelters S
LEFT JOIN Donations D ON S.ShelterID = D.ShelterID
GROUP BY S.Name;


--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have anowner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the resultset.

ALTER TABLE Pets
ADD OwnerId INT NULL


SELECT Name, Age, Breed, Type
FROM Pets
WHERE OwnerID IS NULL

--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g.,January 2023) from the "Donations" table. The result should include the month-year and thecorresponding total donation amount. Ensure that the query handles cases where no donationswere made in a specific month-year


SELECT 
    FORMAT(D.DonationDate, 'MMMM yyyy') AS MonthYear,
    COALESCE(SUM(D.DonationAmount), 0) AS TotalDonationAmount
FROM Donations D
GROUP BY FORMAT(D.DonationDate, 'MMMM yyyy');


--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or olderthan 5 years.


SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 3 OR Age > 5;


--12. Retrieve a list of pets and their respective shelters where the pets are currently available foradoption.


SELECT P.Name, P.Age, P.Breed, P.Type, S.Name AS ShelterName
FROM Pets P
JOIN Shelters S ON P.ShelterID = S.ShelterID
WHERE P.AvailableForAdoption = 1;


--13. Find the total number of participants in events organized by shelters located in specific city.Example: City=Chennai



SELECT COUNT(DISTINCT P.ParticipantID) 
FROM Participants P
JOIN AdoptionEvents A ON P.EventID = A.EventID
JOIN Shelters S ON S.ShelterID = S.ShelterID
WHERE S.Location = 'City Park';


--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 year


SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;


--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and'User' tables.


SELECT *
FROM Pets
WHERE AvailableForAdoption = 1;

--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and'User' tables.


SELECT U.Name AS AdopterName ,p.Name
FROM PetAdoption A 
JOIN Users U ON A.AdopterID = U.UserID 
JOIN Pets P ON A.PetID = P.PetID;



--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in eachshelter.


SELECT S.Name, COUNT(P.PetID) AS AvailablePets
FROM Shelters S
JOIN Pets P ON S.ShelterID = P.ShelterID
WHERE P.AvailableForAdoption = 1
GROUP BY S.Name;


--18. Find pairs of pets from the same shelter that have the same breed.


SELECT P1.Name, P2.Name, S.Name AS ShelterName
FROM Pets P1
JOIN Pets P2 ON P1.ShelterID = P2.ShelterID AND P1.Breed = P2.Breed
JOIN Shelters S ON P1.ShelterID = S.ShelterID
WHERE P1.PetID < P2.PetID;

--19. List all possible combinations of shelters and adoption events.


SELECT S.Name AS ShelterName, E.EventName
FROM Shelters S
CROSS JOIN AdoptionEvents E;

--20. Determine the shelter that has the highest number of adopted pets.


SELECT S.ShelterId, COUNT(A.AdoptionID) AS TotalAdoptions
FROM PetAdoption A
JOIN Pets P ON A.PetID = P.PetID
JOIN Shelters S ON P.ShelterID = S.ShelterID
GROUP BY S.ShelterId
ORDER BY TotalAdoptions DESC







