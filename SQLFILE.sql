-- EVERYONE's QUERIES: 
CREATE DATABASE dresszenfinder;
USE dresszenfinder;
-- relationship should map A USER to A COMMENT, comments on a clothing item
CREATE TABLE Users(
    id INT NOT NULL AUTO_INCREMENT,
    -- Auto-incrementing primary key
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
CREATE TABLE Outfit(
    outfit_id INT NOT NULL AUTO_INCREMENT,
    Occasion VARCHAR(50),
    PRIMARY KEY (outfit_id)
);

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

-- Track user interests in outfits
CREATE TABLE Interested_In(
    user_id INT,
    outfit_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES Outfit(outfit_id) ON DELETE CASCADE
);

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

CREATE TABLE User_Rating(
    user_id INT,
    cloth_id INT,
    rating TINYINT CHECK (
        rating >= 1
        AND rating <= 5
    ),
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
CREATE TABLE Tops(
    cloth_id INT,
    ttype ENUM (
        'Crop Top',
        'Shirts',
        'T-Shirts',
        'Long-Sleeved',
        'Sleeveless',
        'Dresses',
        'Turtle-Neck',
        'Sweaters'
    ),
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

INSERT INTO Tops(cloth_id, ttype)
VALUES (1, 'Crop Top'),
       (2, 'Shirts'),
       (3, 'T-Shirts'),
       (4, 'Long-Sleeved'),
       (5, 'Sleeveless'),
       (6, 'Dresses'),
       (7, 'Turtle-Neck'),
       (8, 'Sweaters');

CREATE TABLE Bottoms(
    cloth_id INT PRIMARY KEY,
    bottom_type ENUM ('Jeans', 'Shorts', 'Trousers', 'Skirts', 'Joggers', 'Palazzo'),
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

INSERT INTO Bottoms(cloth_id, bottom_type)
VALUES (20, Jeans),
       (21, 'Shorts'),
       (23, 'Trousers'),
       (24, 'Skirts'),
       (25, 'Joggers'),
       (26, 'Palazzo');

CREATE TABLE Accessories(
    cloth_id INT PRIMARY KEY,
    atype ENUM ('Jewelry', 'Hats', 'Scarves', 'Handbags', 'Sunglasses'),
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

INSERT INTO Accessories (cloth_id, atype)
VALUES (41, 'Jewelry'),
       (42, 'Hats'),
       (43, 'Scarves'),
       (44, 'Handbags'),
       (45, 'Sunglasses');

CREATE TABLE Shoes(
    cloth_id INT PRIMARY KEY,
    stype ENUM ('Sneakers', 'Heels', 'Boots', 'Flats'),
    FOREIGN KEY (cloth_id) REFERENCES Clothing_Item(cloth_id) ON DELETE CASCADE
);

-- clothing item belongs to a brand
CREATE TABLE brands (
    brand_id INT NOT NULL AUTO_INCREMENT,
    brand_name VARCHAR(50),
    brand_website TEXT,
    type ENUM ('Luxury', 'Sportswear', 'Fast Fashion') NOT NULL,
    PRIMARY KEY (brand_id)
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
      (6, 'H&M', 'https://www2.hm.com/de_de/index.html', 'Fast Fashion');
      
INSERT INTO Clothing_Item (size, color, cloth_description, brand_id, type)
VALUES ('Small', 'Pink', 'Pink cotton t-shirt', 1, 'Top'),
	   ('Extra Small', 'Black', 'Black jeans', 3, 'Bottom');