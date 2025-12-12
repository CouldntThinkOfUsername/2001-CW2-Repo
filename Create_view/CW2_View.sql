CREATE VIEW CW2.[view_profile] AS 
SELECT 
    u.first_name, 
    u.last_name, 
    p.profile_picture, 
    p.about, 
    p.[location]
FROM CW2.User_data u
LEFT JOIN CW2.Profile_info p ON u.user_id = p.user_id;

SELECT * FROM CW2.[view_profile];
