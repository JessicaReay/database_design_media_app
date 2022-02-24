-- create database
CREATE DATABASE media_app;

/* Creating tables for media application*/
--video_rating table: static table used to store video ratings based on BBFC recommendations. 
CREATE TABLE video_ratings(
	rating_id int PRIMARY KEY, 
	rating_description TEXT NOT NULL, 
	minimum_age INT NOT NULL
);

--video table: that stores video file path for application to access
-- this table will be regularly update when new content is inserted. 
CREATE TABLE videos(
	video_id SERIAL PRIMARY KEY, 
	rating_id INT NOT NULL, 
	video_link TEXT NOT NULL, 
	genre TEXT, 
	category TEXT, 
	video_length TIME NOT NULL,
	CONSTRAINT fk_video_ratings FOREIGN KEY (rating_id)
		REFERENCES video_ratings (rating_id) ON UPDATE CASCADE
);

--roles table static table that stores roles of users
CREATE TABLE user_role (
	role_id INT PRIMARY KEY, 
	description TEXT NOT NULL
);

-- role to rating mapping table using composite keys- static table that maps the users roles to the appropriate rating categories.
CREATE TABLE role_to_rating(
	role_id INT NOT NULL, 
	rating_id INT NOT NULL, 	
	PRIMARY KEY (role_id, rating_id),
	CONSTRAINT fk_role FOREIGN KEY (role_id)
	REFERENCES user_role (role_id)
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT fk_rating FOREIGN KEY (rating_id)
	REFERENCES video_ratings (rating_id)
	ON UPDATE CASCADE 
	ON DELETE CASCADE	
);

-- this table will be for the account owners password and will be restricted access. 
CREATE TABLE account_credentials(
	account_user_name TEXT PRIMARY KEY,
	account_password TEXT NOT NULL
);

-- This table houses the account owners details
CREATE TABLE account_owner(
	account_id SERIAL PRIMARY KEY,
	account_user_name TEXT NOT NULL,
	first_name TEXT NOT NULL, 
	last_name TEXT NOT NULL, 
	email_address TEXT NOT NULL, 
	monthly_subscription_amount DECIMAL NOT NULL, 
	subscription_start_date TIMESTAMP NOT NULL,
	CONSTRAINT fk_account_credentials FOREIGN KEY (account_user_name)
	REFERENCES account_credentials (account_user_name)
	ON UPDATE CASCADE 
);

--this table house the users from the account owner table
CREATE TABLE account_users(
	user_id SERIAL PRIMARY KEY, 
	account_id INT NOT NULL, 
	role_id INT NOT NULL, 
	user_name TEXT NOT NULL, 
	date_of_birth DATE NOT NULL,
	CONSTRAINT fk_account_user FOREIGN KEY (account_id)
		REFERENCES account_owner (account_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT fk_role_user FOREIGN KEY (role_id)
		REFERENCES user_role (role_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--this table houses the account card details - will have active and non active cards- this table will be locked down and only read/ write for very few authorised 
CREATE TABLE payment_details(
	card_id SERIAL PRIMARY KEY, 
	account_id INT NOT NULL, 
	card_account_number INT NOT NULL, 
	sort_code TEXT NOT NULL, 
	CVV INT NOT NULL, 
	active_card BOOLEAN NOT NULL,
	CONSTRAINT fk_account_payment_detail FOREIGN KEY (account_id)
		REFERENCES account_owner (account_id) 
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--this table will log all the payment transactions for each account. 
CREATE TABLE account_transactions (
	transaction_id SERIAL PRIMARY KEY,  
	card_id INT NOT NULL, 
	date_of_transaction TIMESTAMP NOT NULL, 
	amount_paid DECIMAL NOT NULL,
	CONSTRAINT fk_card FOREIGN KEY (card_id)
		REFERENCES payment_details (card_id) 
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

/*insert data into tables*/
--- insert static tables 
--- insert video_ratings into table based on BBFC
INSERT INTO video_ratings (rating_id, rating_description , minimum_age) VALUES ('1', 'U- Universal Suitable for all', 4);
INSERT INTO video_ratings (rating_id, rating_description , minimum_age) VALUES ('2', 'PG- Parental Guidance', 8);
INSERT INTO video_ratings (rating_id, rating_description , minimum_age) VALUES ('3', '12- Suitable for 12 years and over ', 12);
INSERT INTO video_ratings (rating_id, rating_description , minimum_age) VALUES ('4', '15- Suitable only for 15 years and over', 15);
INSERT INTO video_ratings (rating_id, rating_description , minimum_age) VALUES ('5', '18- Suitable only for adults', 18);

--- insert videos into video table
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '4', 'C:\Users\jessi\Documents\Videos\Crashlandingonyou', 'K-drama', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '5', 'C:\Users\jessi\Documents\Videos\murdermysterymakeup', 'True Crime', 'TV-series', '01:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '1', 'C:\Users\jessi\Documents\Videos\encanto', 'Musical', 'Movie', '02:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '5', 'C:\Users\jessi\Documents\Videos\moneyheist', 'Action', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '1', 'C:\Users\jessi\Documents\Videos\pepperpig', 'Kids', 'TV-series', '00:40');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '2', 'C:\Users\jessi\Documents\Videos\jumangi', 'Family', 'Movie', '02:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '3', 'C:\Users\jessi\Documents\Videos\ghostbusters', 'Action', 'Movie', '02:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '4', 'C:\Users\jessi\Documents\Videos\hotfuzz', 'comdty', 'Movie', '02:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '2', 'C:\Users\jessi\Documents\Videos\themask', 'comdty', 'Movie', '02:00');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '3', 'C:\Users\jessi\Documents\Videos\queeneye', 'lifestyle', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '1', 'C:\Users\jessi\Documents\Videos\ourplanet', 'Science', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '5', 'C:\Users\jessi\Documents\Videos\southpark', 'Sitcom', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '2', 'C:\Users\jessi\Documents\Videos\godzilla', 'Action', 'Movie', '02:16');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '3', 'C:\Users\jessi\Documents\Videos\itsokaytonotbeokay', 'K-drama', 'TV-series', '01:30');
INSERT INTO videos (video_id, rating_id, video_link, genre, category , video_length) VALUES (DEFAULT, '4', 'C:\Users\jessi\Documents\Videos\squidgames', 'K-drama', 'TV-series', '01:30');

--- insert user roles into static table
INSERT INTO user_role (role_id, description) VALUES (1, 'adults ');
INSERT INTO user_role (role_id, description) VALUES (2, 'young adult');
INSERT INTO user_role (role_id, description) VALUES (3, 'teen');
INSERT INTO user_role (role_id, description) VALUES (4, 'young child');
INSERT INTO user_role (role_id, description) VALUES (5, 'child');

--- insert into mapping the roles and ratings
INSERT INTO role_to_rating (role_id, rating_id) VALUES (1, 1);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (1, 2);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (1, 3);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (1, 4);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (1, 5);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (2, 1);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (2, 2);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (2, 3);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (2, 4);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (3, 1);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (3, 2);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (3, 3);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (4, 1);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (4, 2);
INSERT INTO role_to_rating (role_id, rating_id) VALUES (5, 1);

---check inserts
select * from video_ratings;
select * from videos;
select * from user_role;
select * from role_to_rating;

--- create postgresql extension to hash passwords
CREATE EXTENSION pgcrypto;

-- create store procedure to insert into credentials securely 
CREATE PROCEDURE credentials_insert(account_user_name text, account_password text)
LANGUAGE SQL
AS $$
INSERT INTO account_credentials VALUES (account_user_name, crypt(account_password, gen_salt('bf', 8)));
$$;

--- insert all credentials using the store procedure
CALL credentials_insert('jessreay', 'matilda');
CALL credentials_insert('juilaguard', 'australia');
CALL credentials_insert('milliebrigth', 'defender');
CALL credentials_insert('ellenwhite', 'offside');
CALL credentials_insert('godwinpeterson', 'maniecoonuncle');
CALL credentials_insert('kirkroberts', 'gymliftweights');
CALL credentials_insert('judysheindlen', 'justice123');
CALL credentials_insert('stevenbradbury', 'slowandsteady');
CALL credentials_insert('soyoungji', 'cheese');
CALL credentials_insert('henrycavill', 'super');

---check table
SELECT * FROM account_credentials;
 
---check the hash has worked.
 SELECT * FROM account_credentials 
 WHERE account_user_name = 'jessreay' AND account_password = crypt('matilda', account_password); 

--- insert to account owner table
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'soyoungji', 'So-young', 'Ji', 'soyoungji@hotmail.com', 4.99, '2018-10-10');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'godwinpeterson', 'Godwin', 'Peterson', 'godwin.peterson@gmail.com', 5.99, '2019-01-02');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'milliebrigth', 'Millie', 'Bright ', 'millie.bright@hotmail.com', 5.99, '2019-08-08');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'stevenbradbury', 'Steven', 'Bradbury', 'steven.bradbury@hotmail.com', 5.99, '2019-11-10');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'juilaguard', 'Julia', 'Gillard', 'julia.gillard@gmail.com', 5.99, '2020-04-09');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'kirkroberts', 'Kirk', 'Roberts', 'kirk.roberts@gmail.com', 5.99, '2020-05-10');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'judysheindlen', 'Judy', 'Sheindlen', 'judy.sheindlen@gmail.com', 5.99, '2020-06-18');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'jessreay', 'Jess', 'Reay', 'jessicaareay@hotmail.com', 5.99, '2020-10-01');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'ellenwhite', 'Ellen', 'White', 'ellen.white@hotmail.com', 5.99, '2021-12-24');
INSERT INTO account_owner(account_id, account_user_name,first_name, last_name, email_address, monthly_subscription_amount,subscription_start_date) VALUES (DEFAULT, 'henrycavill', 'Henry ', 'Cavill', 'henry.cavill@gmail.com', 6.99, '2022-02-02');

--- check insert was successful 
SELECT * FROM account_owner;

--- insert users into account user - 5 is the least authorised role
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 16, 5,'jessreay', '1993-10-23');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 13, 5,'juilaguard', '1961-09-29');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 13, 5,'timbo', '1960-01-10');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 11, 5,'milliebrigth', '1993-08-21');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 11, 5,'joshie', '1992-06-24');
--- check
select * from account_users;

/*create function to update role id based on age- this can be used as a daily 
update so that as the users get older the roles can update automatically*/
CREATE FUNCTION daily_update_roles()
	RETURNS int 
	lANGUAGE plpgsql
AS $$
DECLARE 
	role_id int;
BEGIN
	UPDATE account_users 
 		SET role_id = 	CASE 
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 18 THEN  1
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 15 THEN  2
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 12 THEN 3
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 8 THEN  4
			ELSE  5
		END; 
	RETURN role_id;	
END;
$$;

SELECT daily_update_roles();

-- check it has worked. 
select * from account_users;

--- created a trigger to update for every new user upon insert
CREATE FUNCTION insert_roles_dob()
	RETURNS TRIGGER
	lANGUAGE plpgsql
AS $$
DECLARE 
	role_id int;
BEGIN
	UPDATE account_users 
 		SET role_id = 	CASE 
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 18 THEN  1
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 15 THEN  2
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 12 THEN 3
			WHEN (date_part('year', AGE(date_of_birth))::int) >= 8 THEN  4
			ELSE  5
		END;
	RETURN role_id;	
END;
$$;


CREATE TRIGGER insert_role_id
	AFTER INSERT 
	ON account_users
	FOR EACH ROW
	EXECUTE PROCEDURE insert_roles_dob();


---insert more users
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 17, 5,'ellenwhite', '1989-05-09');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 17, 5,'chriswhitey', '1985-11-10');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 17, 5,'oscarwhite', '2013-10-17');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 10, 5,'godwinpeterson', '1993-04-27');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 10, 5,'izzypeterson', '1995-07-13');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 10, 5,'matleypeterson', '2017-06-23');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 14, 5,'kirkroberts', '2000-05-04');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 15, 5,'judysheidlen', '1942-10-21');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 15, 5,'jerrysheidler', '1933-11-19');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 15, 5,'lucassheidler', '2004-01-01');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 15, 5,'georgesheilder', '2014-08-02');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 12, 5,'stevenbradbury', '1973-10-14');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 12, 5,'amandabradbury', '1975-08-13');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 12, 5,'lakeybradbury', '2010-12-18');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 9, 5,'soyoungji', '1991-02-21');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 9, 5,'bethengland', '1994-06-03');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 18, 5,'henrycavill', '1983-05-05');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 18, 5,'charliecavill', '2007-01-31');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 18, 5,'lilycavill', '2009-04-06');
INSERT INTO account_users (user_id, account_id, role_id,user_name, date_of_birth) VALUES (DEFAULT, 18, 5,'tillycavill', '2013-03-02');
--- check it worked 
select * from account_users;

--- insert into payment details
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 9, 123654789, '10-20-23', 321, '0');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 9, 123654790, '10-20-23', 456, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 10, 987465231, '10-20-33', 639, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 11, 854796321, '30-40-56', 558, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 12, 745896321, '20-89-52', 221, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 13, 654789321, '10-33-50', 897, '0');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 13, 563214785, '30-80-90', 745, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 14, 569856222, '60-85-60', 635, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 15, 125878796, '50-40-21', 155, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 16, 312014784, '65-41-52', 587, '0');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 16, 602015878, '90-80-70', 999, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 17, 963565810, '60-50-40', 365, '1');
INSERT INTO payment_details (card_id, account_id, card_account_number, sort_code, cvv, active_card) VALUES (DEFAULT, 18, 552012698, '30-20-10', 245, '1');

---check 
select * from payment_details;

--- Insert into account transactions
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-01-01', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-02-01', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-03-03', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-04-02', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-05-02', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-06-01', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-07-01', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-07-31', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 1, '2021-08-30', 4.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2021-09-29', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2021-10-29', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2021-11-28', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2021-12-28', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2022-01-27', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 2, '2022-02-26', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 3, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 3, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 4, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 4, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 5, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 5, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 6, '2021-12-27', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 7, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 7, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 8, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 8, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 9, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 9, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 10, '2021-12-27', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 11, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 11, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 12, '2022-01-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 12, '2022-02-01', 5.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 13, '2022-01-01', 6.99);
INSERT INTO account_transactions (transaction_id, card_id, date_of_transaction, amount_paid) VALUES (DEFAULT, 13, '2022-02-01', 6.99);

---check
select * from account_transactions;


--- create view - payment details can be locked down 
--- however unauthorised user can still generate a transaction report for account using view
--- add in active card column in case user changes card and wants to see all transaction log
CREATE VIEW account_transaction_record AS 
	select account_owner.account_id, 
	account_transactions.date_of_transaction, 
	account_transactions.amount_paid,
	payment_details.active_card
	from account_owner 
	JOIN payment_details 
	on account_owner.account_id = payment_details.account_id
	JOIN account_transactions 
	On account_transactions.card_id = payment_details.card_id;
	
---check 
select * from account_transaction_record;
select * from account_transaction_record WHERE account_id = 9;
