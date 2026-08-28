create database MUSIC_STORE;
use MUSIC_STORE;
select * from album;
show tables;

alter table genre
modify column genre_id int not null auto_increment, add primary key(genre_id);

alter table media_type
modify column media_type_id int not null auto_increment,add primary key(media_type_id);

alter table artist
modify column artist_id int not null auto_increment,add primary key(artist_id);

alter table playlist
modify column playlist_id int not null auto_increment,add primary key(playlist_id);

alter table employee
modify column employee_id int not null auto_increment,add primary key(employee_id);

alter table employee
add foreign key(reports_to) references employee(employee_id);

alter table customer
modify column customer_id int not null auto_increment,add primary key(customer_id);

alter table customer
add foreign key(support_rep_id) references employee(employee_id);

alter table album
modify column album_id int not null auto_increment,add primary key(album_id);

alter table album
add foreign key(artist_id) references artist(artist_id);

alter table track 
modify column track_id int not null,add primary key(track_id);

alter table track
add foreign key(album_id) references album(album_id);

alter table track
add foreign key(media_type_id) references media_type(media_type_id);

alter table track
add foreign key(genre_id) references genre(genre_id);

alter table invoice
modify column invoice_id int not null auto_increment,add primary key(invoice_id);

alter table invoice 
add foreign key(invoice_id) references invoice_line(invoice_id);

alter table invoice
add foreign key(customer_id) references customer(customer_id);

alter table invoice_line 
add foreign key(track_id) references track(track_id);

ALTER TABLE employee
MODIFY COLUMN reports_to INT NULL;

ALTER TABLE employee
ADD FOREIGN KEY (reports_to) REFERENCES employee(employee_id) ON DELETE SET NULL;
SELECT employee_id, first_name, last_name, reports_to FROM employee;
UPDATE employee SET reports_to = NULL WHERE reports_to = 0;
SELECT employee_id, first_name, last_name, reports_to FROM employee;
UPDATE employee SET reports_to = NULL WHERE employee_id = 1;
SELECT COUNT(*) FROM track;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE track;
SET FOREIGN_KEY_CHECKS = 1;
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'secure_file_priv';
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE track;
SET FOREIGN_KEY_CHECKS = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);
SELECT COUNT(*) FROM track;
SELECT COUNT(*) FROM playlist_track;
SELECT COUNT(*) FROM invoice_line WHERE track_id NOT IN (SELECT track_id FROM track);
select * from invoice_line;
SHOW CREATE TABLE track;

alter table track 
modify column track_id int not null ,add primary key(track_id);
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT track_id) AS unique_ids
FROM track;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE track;
SET FOREIGN_KEY_CHECKS = 1;
SELECT COUNT(*) FROM track;
TRUNCATE TABLE track;
SELECT COUNT(*) FROM track;
ALTER TABLE track
ADD PRIMARY KEY (track_id);

ALTER TABLE invoice_line
ADD FOREIGN KEY (track_id) REFERENCES track(track_id) ON DELETE RESTRICT;

ALTER TABLE playlist_track
ADD FOREIGN KEY (track_id) REFERENCES track(track_id) ON DELETE CASCADE;

###############	   1. Who is the senior most employee based on job title     ###############
SELECT employee_id, first_name, last_name, title, levels FROM employee;
select first_name,last_name,title,levels from employee order by levels Desc;

###############   2. Which countries have the most Invoices    ###############
SELECT billing_country, COUNT(invoice_id) AS Invoice_Count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

###############   3. What are the top 3 values of total invoice?   ###############
SELECT total, invoice_id
FROM invoice
ORDER BY total DESC
LIMIT 3;

###############  4. Which city has the best customers?    ###############
SELECT BILLING_CITY, SUM(TOTAL) AS Invoice_Total
FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY Invoice_Total DESC
LIMIT 1;

###############    5. Who is the best customer?      ###############
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, SUM(I.TOTAL) AS TOTAL_AMOUNT FROM CUSTOMER AS C
JOIN INVOICE AS I ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;

###############    6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A      ###############
SELECT DISTINCT CUS.EMAIL, CUS.FIRST_NAME, CUS.LAST_NAME
FROM CUSTOMER AS CUS
JOIN INVOICE AS INV ON CUS.CUSTOMER_ID = INV.CUSTOMER_ID
JOIN INVOICE_LINE AS INVL ON INV.INVOICE_ID = INVL.INVOICE_ID
WHERE INVL.TRACK_ID IN(
 SELECT T.TRACK_ID
 FROM TRACK AS T
 JOIN GENRE AS G ON T.GENRE_ID = G.GENRE_ID
 WHERE G.NAME LIKE 'Rock'
)
ORDER BY CUS.EMAIL;


###############   7. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands      ###############
SELECT AR.NAME, COUNT(AR.ARTIST_ID) AS NUMBER_OF_SONGS
FROM TRACK AS TR
JOIN ALBUM AS AL ON TR.ALBUM_ID = AL.ALBUM_ID
JOIN ARTIST AS AR ON AL.ARTIST_ID = AR.ARTIST_ID
JOIN GENRE AS GE ON TR.GENRE_ID = GE.GENRE_ID
WHERE GE.NAME LIKE 'Rock'
GROUP BY AR.ARTIST_ID
ORDER BY NUMBER_OF_SONGS DESC LIMIT 10;


###############    8. Return all the track names that have a song length longer than the average song length.- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first      ###############
SELECT NAME, MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
 SELECT AVG(MILLISECONDS) AS AVG_SONG_LENGTH
 FROM TRACK
)
ORDER BY MILLISECONDS DESC;


###############    9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent        ###############
WITH BEST_SELLING_ARTIST AS (
	SELECT ART.ARTIST_ID, ART.NAME, SUM(IVL.UNIT_PRICE * IVL.QUANTITY) AS TOTAL_AMOUNT
	FROM INVOICE_LINE AS IVL
	JOIN TRACK AS TRK ON IVL.TRACK_ID = TRK.TRACK_ID
	JOIN ALBUM AS ALB ON TRK.ALBUM_ID = ALB.ALBUM_ID
	JOIN ARTIST AS ART ON ALB.ARTIST_ID = ART.ARTIST_ID
	GROUP BY ART.ARTIST_ID
	ORDER BY TOTAL_AMOUNT DESC LIMIT 1
)
SELECT CUS.CUSTOMER_ID, CUS.FIRST_NAME, CUS.LAST_NAME, BSA.NAME AS ARTIST_NAME, SUM(IVL.UNIT_PRICE * IVL.QUANTITY) AS AMOUNT_SPENT
FROM INVOICE AS INV
JOIN CUSTOMER AS CUS ON INV.CUSTOMER_ID = CUS.CUSTOMER_ID
JOIN INVOICE_LINE AS IVL ON INV.INVOICE_ID = IVL.INVOICE_ID
JOIN TRACK AS TRK ON IVL.TRACK_ID = TRK.TRACK_ID
JOIN ALBUM AS ALB ON TRK.ALBUM_ID = ALB.ALBUM_ID
JOIN BEST_SELLING_ARTIST AS BSA ON ALB.ARTIST_ID = BSA.ARTIST_ID
GROUP BY CUS.CUSTOMER_ID, BSA.NAME;


###############    10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared, return all Genres        ###############
WITH POPULAR_GENRE AS (
	SELECT CU.COUNTRY, COUNT(IL.QUANTITY) AS TOTAL_PURCHASES, GE.NAME AS TOP_GENRE, GE.GENRE_ID,
		ROW_NUMBER() OVER(
			PARTITION BY CU.COUNTRY ORDER BY COUNT(IL.QUANTITY) DESC
		) AS ROW_NUM
	FROM CUSTOMER AS CU
	JOIN INVOICE AS IV ON CU.CUSTOMER_ID = IV.CUSTOMER_ID
	JOIN INVOICE_LINE AS IL ON IV.INVOICE_ID = IL.INVOICE_ID
	JOIN TRACK AS TR ON IL.TRACK_ID = TR.TRACK_ID
	JOIN GENRE AS GE ON TR.GENRE_ID = GE.GENRE_ID
	GROUP BY CU.COUNTRY, GE.NAME, GE.GENRE_ID
	ORDER BY CU.COUNTRY, TOTAL_PURCHASES DESC
)
SELECT COUNTRY, TOP_GENRE, TOTAL_PURCHASES
FROM POPULAR_GENRE WHERE ROW_NUM = 1;

###############     11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount        ###############
WITH CUSTOMER_WITH_COUNTRY AS (
	SELECT CU.COUNTRY, CU.CUSTOMER_ID, CU.FIRST_NAME, CU.LAST_NAME, SUM(IV.TOTAL) AS AMOUNT_SPENT,
		ROW_NUMBER() OVER(
			PARTITION BY CU.COUNTRY ORDER BY SUM(IV.TOTAL) DESC
		) AS ROW_NUM
	FROM INVOICE AS IV
	JOIN CUSTOMER AS CU ON IV.CUSTOMER_ID = CU.CUSTOMER_ID
	GROUP BY CU.COUNTRY, CU.CUSTOMER_ID, CU.FIRST_NAME, CU.LAST_NAME
	ORDER BY CU.COUNTRY, AMOUNT_SPENT DESC
)
SELECT COUNTRY, CUSTOMER_ID, FIRST_NAME, LAST_NAME, AMOUNT_SPENT
FROM CUSTOMER_WITH_COUNTRY
WHERE ROW_NUM = 1;