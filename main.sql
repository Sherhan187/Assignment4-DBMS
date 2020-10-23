CREATE TABLE Artist (
       artID serial NOT NULL,
       artName VARCHAR(255) NOT NULL,
       CONSTRAINT pk_artist PRIMARY KEY (artID),
       CONSTRAINT ck_artist UNIQUE (artName)	
);
	
CREATE TABLE CD (
       cdID serial NOT NULL,
       artID INT NOT NULL,
       cdTitle VARCHAR(255) NOT NULL,
       cdPrice REAL NOT NULL,
       cdGenre VARCHAR(255) NULL,
	   cdNumTracks INT NULL,
       CONSTRAINT pk_cd PRIMARY KEY (cdID),
       CONSTRAINT fk_cd_art FOREIGN KEY (artID) REFERENCES Artist (artID)
       ON DELETE CASCADE ON UPDATE CASCADE
);

--- Artist


INSERT INTO Artist (artID, artName) Values 
(6,'Animal Collective'), 
(3, 'Deadmau5'),
(7, 'Kings of Leon'), 
(4, 'Mark Ronson'),
(5, 'Mark Ronson & The Business Intl'),
(8, 'Maroon 5'), 
(2, 'Mr. Scruff'), 
(1, 'Muse');

--- CD

INSERT INTO CD (artID, cdTitle, cdPrice, cdGenre)
VALUES (1, 'Black Holes and Revelations', 9.99, 'Rock'),
(1, 'The Resistance ', 11.99, 'Rock'),
(2, 'Ninja Tuna ', 9.99, 'Electronica'),
(3, 'For Lack of a Better Name ', 9.99, 'Electro House'),
(4, 'Record Collection ', 11.99, 'Alternative Rock'),
(5, 'Version', 12.99, 'Pop'),
(6, 'Merriweather Post Pavilion', 12.99, 'Electronica'),
(7, 'Only By The Night', 9.99, 'Rock'),
(7, 'Come Around Sundown', 12.99, 'Rock'),
(8, 'Hands All Over', 11.99, 'Pop');


SELECT * FROM Artist;

SELECT * FROM CD;

---OUTPUT 1

SELECT cdTitle,cdPrice FROM CD WHERE cdTitle like '% %';

--- Output 2
SELECT cdTitle,artName FROM CD,Artist WHERE cdTitle like '%the%';

--- Output 3
SELECT * FROM CD WHERE cdGenre like '%ro%';

--- Output 4
SELECT cdTitle FROM CD WHERE cdGenre =
	(SELECT cdGenre FROM CD WHERE cdTitle = 'The Resistance ');
	
--- Ouput 5
SELECT DISTINCT cdTitle FROM CD WHERE cdPrice IN
(SELECT cdPrice FROM CD,Artist WHERE Artist.artID = CD.artID
AND cdGenre = 'Pop');

---Ouput 6 Use ANY to find the titles of CDs that cost more than at least one other CD 

SELECT DISTINCT cdTitle FROM CD
WHERE cdPrice > ANY (SELECT MIN(cdPrice) FROM CD);

--- Output 7 Use ALL to find a list of CD titles that cost more or the same as all other CDs 

SELECT cdTitle FROM CD WHERE cdPrice >= ALL (SELECT cdPrice FROM CD);

--- Ouptut 8 Use EXISTS to find a list of Artists who produced an “Electronica” CD

SELECT artName FROM Artist WHERE EXISTS 
	(SELECT cdTitle FROM CD WHERE artID = Artist.artID AND cdGenre = 'Electronica');
	
--- Output 9 Find the names of Artists who have albums cheaper than 10 pounds. Provide at least two
-- different queries producing the same solution.

SELECT DISTINCT artName FROM Artist WHERE EXISTS 
	(SELECT cdTitle FROM CD WHERE Artist.artID = CD.artID AND cdPrice < 10.00);
	
SELECT DISTINCT artName FROM Artist WHERE EXISTS 
	(SELECT cdTitle FROM CD WHERE artID = Artist.artID AND cdPrice < 10.00);
	
-- Output 10 ind names of CDs produced by those Artists who have a single word as their name.

SELECT cdTitle FROM CD WHERE artID IN  (SELECT artID FROM Artist WHERE artName NOT LIKE '% %'); 

-- Ouput 11 Find all information about ‘Rock’ and ‘Pop’ CDs which are cheaper than others.

SELECT * FROM CD WHERE (cdGenre = 'Rock' AND cdGenre = 'Pop') 
	AND cdPrice < (SELECT cdPrice FROM CD WHERE cdGenre <> 'Rock' AND cdGenre <> 'Pop');
	
-- Output 12 Find the Artist names and their ID (in this order) for albums which cost £12.99. Provide three
--	different queries producing the same solution .

SELECT artName, artID FROM Artist,CD  WHERE EXISTS 
	(SELECT cdTitle FROM CD WHERE Artist.artID = CD.artID AND cdPrice =  12.99);
	
SELECT artName, CD.artID FROM Artist,CD  WHERE cdPrice = 12.99 and Artist.artID = CD.artID;

SELECT artName, CD.artID FROM Artist INNER JOIN CD ON 
	cdPRice = 12.99 AND Artist.artID = CD.artID;
	
