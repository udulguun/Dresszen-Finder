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
