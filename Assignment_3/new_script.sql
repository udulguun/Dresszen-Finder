CREATE DATABASE dresszenfinder;
USE dresszenfinder;

-- relationship should map A USER to A COMMENT, comments on a clothing item
CREATE TABLE Users(
    id INT NOT NULL AUTO_INCREMENT, -- Auto-incrementing primary key
    Username VARCHAR(50) NOT NULL,
    Size VARCHAR(30) NOT NULL,
    Birthday DATE NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Gender ENUM ('Male', 'Female'),
    Age INT,
    PRIMARY KEY (id) -- set id as the primary key
);

DELIMITER $$

CREATE TRIGGER before_insert_age
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.Birthday, CURDATE());
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_update_age
BEFORE UPDATE ON Users
FOR EACH ROW
BEGIN
    SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.Birthday, CURDATE());
END$$

DELIMITER ;

INSERT INTO Users(Username, Size, Birthday, Email, Gender)
VALUES ("Isabel Green", "M", '1990-02-21', "isabelg@gmail.com", 'Female'),
       ("Dave Adams", "XXL", '1993-05-03', "daveadams@gmail.com", 'Male'),
       ("Angela Burns", "L", '2001-09-14', "angelabu@gmail.com", 'Female'),
       ("Lucy Warren", "S", '1998-03-05', "lucywarren@gmail.com", 'Female'),
       ("Miles Gibson", "XL", '2003-08-12', "miles128@gmail.com",'Male'),
       ("Sabrina Ellis", "M", '2004-11-26', "sabrina.ellis@gmail.com", 'Female'),
       ("Melody Fisher", "XS", '1998-02-01', "melodyf12@gmail.com", 'Female'),
       ("Ethan Reynolds", "XXL", '2005-12-15', "ethanrey@gmail.com", 'Male'),
       ("Christina Jordan", "L", '2003-07-27', "christina0727@gmail.com", 'Female'),
       ("Zaara Valladares", "S", '2005-12-01', "zaaravallad@gmail.com", 'Female'),
	   ("Nafiba Biru", "XS", '2004-07-19', "nafiba.b@gmail.com", 'Female'),
       ("Lewis Long", "XXXL", '1997-09-08', "lewilong@gmail.com", 'Male'),
       ("Fidan Yagubzade", "S", '2005-10-10', "fidany@gmail.com", 'Female'),
       ("Dulguun Ulziibayar", "M", '2005-03-28', "dulguunu@gmail.com", 'Female'),
       ("Harvey Russell", "XL", '1999-04-13', "h.russell@gmail.com", 'Male');
	
SELECT * FROM Users;  

-- User can be interested in OUTFIT. We need to model the interest.
CREATE TABLE Outfit (
    outfit_id INT NOT NULL AUTO_INCREMENT,
    Occasion ENUM('Casual', 'Formal', 'Sport', 'Business', 'Party') NOT NULL,
    PRIMARY KEY (outfit_id)
);

INSERT INTO Outfit(outfit_id, Occasion)
VALUES(1, 'Casual'),
	  (2,'Formal'),
      (3, 'Sport'),
	  (4, 'Business'),
	  (5, 'Party');
 
-- allow users to comment on an Outfit
 CREATE TABLE User_Comments(
	comment_id INT NOT NULL AUTO_INCREMENT,
    user_id INT,
    outfit_id INT,
    content TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(comment_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES Outfit(outfit_id) ON DELETE CASCADE
    );

INSERT INTO User_Comments (user_id, outfit_id, content, comment_date)
VALUES(10, 2, 'Killed it:)', '2023-09-03'), 
      (5, 1, 'Where did you get the bag from?', '2023-08-12'), 
      (7, 4, 'Looks fashionable!', '2024-04-08'), 
      (1, 2, 'Wow!!!', '2023-10-04'), 
      (3, 2, 'Shines bright like a diamond <3', '2024-03-02');
      
-- Track user interests in outfits
CREATE TABLE Interested_In(
    user_id INT,
    outfit_id INT,
    PRIMARY KEY (user_id, outfit_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES Outfit(outfit_id) ON DELETE CASCADE
);
 
INSERT INTO Interested_In VALUES
(2, 4),
(7, 1),
(11, 2),
(3, 4),
(6, 3),
(7, 5);

 
 -- User can RATE a particular Clothing Item (relation)
 /*allows users to rate multiple clothing items because the composite primary key (user_id, cloth_id) ensures that 
 each user can rate each clothing item only once. This structure enables a user to rate multiple different clothing items, 
 but not the same item multiple times, which is usually the desired behavior.*/

 
CREATE TABLE Clothing_Item(
	cloth_id INT PRIMARY KEY AUTO_INCREMENT,
    size VARCHAR(20),
    color VARCHAR(255),
    cloth_description TEXT,
    brand_id INT,
    type ENUM ('Top', 'Bottom', 'Accessory', 'Shoe')
);

-- clothing item belongs to a brand
CREATE TABLE brands (
	brand_id INT NOT NULL AUTO_INCREMENT,
    brand_name VARCHAR(50),
    brand_website TEXT,
    type ENUM ('Luxury', 'Sportswear', 'Fast Fashion') NOT NULL,
    PRIMARY KEY (brand_id)
);

INSERT INTO Clothing_Item (size, color, cloth_description, brand_id, type) 
VALUES ('XS', 'Pink', 'Pink cotton t-shirt', 1, 'Top'),
       ('S', 'Black', 'Black jeans', 3, 'Bottom'),
       ('M', 'Blue', 'Blue trousers', 2, 'Bottom'),
       ('L', 'Black', 'black printed Sweatshirt', 15, 'Top'),
       ('S', 'Green', 'Green hoodie with logo', 7, 'Top'),
       ('S', 'Blue', 'Blue ripped skinny jeans', 3, 'Bottom'),
       ('One Size', 'Black', 'Black leather handbag', 5, 'Accessory'),
       ('S', 'Blue', 'Blue floral print crop top', 9, 'Top'),
       ('One Size', 'Pink', 'Pink silk headscarf', 15, 'Accessory'),
	   ('XS', 'Yellow', 'Yellow tank top', 15, 'Top'), 
       ('8', 'Black', 'Black high-heeled boots', 15, 'Shoe'),
       ('XS', 'Black', 'Black mini skirt', 8, 'Bottom'),
       ('One Size', 'Silver', 'Silver hoop earrings', 12, 'Accessory'),
       ('9', 'Beige', 'Adidas Samba classic sneakers', 3, 'Shoe'),
       ('L', 'White', 'White cotton blouse', 6, 'Top'), 
       ('XL', 'Green', 'Green halter neck top', 16, 'Top');

 CREATE TABLE User_Rating(
	user_id INT,
    cloth_id INT,
    rating TINYINT CHECK (rating >= 1 AND rating <= 5),
    PRIMARY KEY (user_id, cloth_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

INSERT INTO User_Rating(user_id, cloth_id, rating)
VALUES (4, 3, 4),
	   (2, 6, 2),
       (6, 11, 5),
       (1, 2, 3),
       (7, 1, 4),
       (3, 4, 1),
       (10, 8, 5),
       (13, 9, 2),
       (8, 7, 5),
       (9, 10, 4),
       (11, 5, 3);
       
SELECT * FROM user_rating;

-- link clothing items to the main outfit (many-to-many relationship)
CREATE TABLE Outfit_Clothing_Item(
    outfit_id INT,
    cloth_id INT,
    PRIMARY KEY (outfit_id, cloth_id),
    FOREIGN KEY (outfit_id) REFERENCES Outfit(outfit_id) ON DELETE CASCADE,
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

CREATE TABLE belongs_to(
	cloth_id INT,
    brand_id INT,
    PRIMARY KEY (cloth_id, brand_id),
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE
);

INSERT INTO brands(brand_id, brand_name, brand_website, type) 
VALUES(1, 'CHANEL', 'https://www.chanel.com/de/', 'Luxury'),
(2, 'DIOR', 'https://www.dior.com/de_de', 'Luxury'),
(3, 'ADIDAS', 'https://www.adidas.de/en', 'Sportswear'),
(4, 'NIKE', 'https://www.nike.de', 'Sportswear'),
(5, 'ZARA', 'https://www.zara.com/de/en/', 'Fast Fashion'), 
(6, 'H&M', 'https://www2.hm.com/de_de/index.html', 'Fast Fashion'),
(7, 'LOUIS VUITTON', 'https://de.louisvuitton.com', 'Luxury'),
(8, 'GUCCI', 'https://www.gucci.com', 'Luxury'),
(9, 'UNIQLO', 'https://www.uniqlo.com', 'Fast Fashion'),
(10, 'PUMA', 'https://eu.puma.com', 'Sportswear'),
(11, 'LULULEMON', 'https://www.lululemon.de', 'Sportswear'),
(12, 'BALENCIAGA', 'https://www.balenciaga', 'Luxury'),
(13, 'RALPH LAUREN', 'https://www.ralphlauren.de', 'Luxury'),
(14, 'MARC JACOBS', 'https://www.marcjacobs.com', 'Luxury'),
(15, 'BERSHKA', 'https://www.bershka.com', 'Fast Fashion'),
(16, 'PULL&BEAR', 'https://www.pullandbear.com', 'Fast Fashion'),
(17, 'STRADIVARIUS', 'https://stradivarius.com', 'Fast Fashion');

-- 1 The oldest user
SELECT U.Username, U.Size, U.Email, U.Gender, U.Age 
FROM Users U
WHERE U.age = (SELECT MAX(U2.age)
			  FROM Users U2);

-- 2 
SELECT type, COUNT(DISTINCT brand_id) AS brand_count
FROM brands
GROUP BY type
HAVING COUNT(*) > 4;

-- 3 GROUP BY the number of outfits for each rating
SELECT C.outfit_id, U.Username, U.Age, C.content, C.comment_date
FROM Users U, User_Comments C
WHERE U.id = C.user_id AND C.outfit_id = 2;


-- number 4
SELECT rating, COUNT(DISTINCT cloth_id) AS outfit_count
FROM User_Rating
GROUP BY rating
ORDER BY rating;

-- number 5
SELECT COUNT(*) AS user_number
FROM Users
WHERE Size = 'XXL';

-- number 6
SELECT ci.cloth_id, ci.size, ci.color, ci.cloth_description, b.brand_name, ci.type
FROM Clothing_Item ci
JOIN brands b ON ci.brand_id = b.brand_id
WHERE ci.type = 'Top' AND b.type = 'Fast Fashion';

-- number 7:
SELECT Gender, COUNT(*) AS num_user 
FROM Users
GROUP BY Gender;

-- number 8
SELECT * FROM Clothing_Item
WHERE brand_id = 15 AND color = 'Black';

-- number 9
SELECT user_id, COUNT(cloth_id) AS NumberOfItemsRated
FROM User_Rating
GROUP BY user_id;

-- number 10
SELECT 
    ci.cloth_id,
    ci.size,
    ci.color,
    ci.cloth_description,
    b.brand_name,
    b.type AS brand_type
FROM 
    Clothing_Item ci
JOIN 
    brands b ON ci.brand_id = b.brand_id;
    
-- number 11
SELECT u.*, ii.outfit_id
FROM Users u, Interested_In ii
WHERE u.id = ii.user_id;

-- number 12
SELECT *
FROM Users u1
WHERE u1.Birthday > '2000-01-01'
AND u1.Size > 'XS';
