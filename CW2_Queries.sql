-- CREATE SCHEMA CW2;

DROP TRIGGER IF EXISTS CW2.newUserLog;

DROP PROCEDURE IF EXISTS CW2.deleteUser;
DROP PROCEDURE IF EXISTS CW2.updateUser;
DROP PROCEDURE IF EXISTS CW2.findUser;
DROP PROCEDURE IF EXISTS CW2.addUser;

DROP VIEW IF EXISTS CW2.[view_profile];

DROP TABLE IF EXISTS CW2.Alerts_table;
DROP TABLE IF EXISTS CW2.User_activities
DROP TABLE IF EXISTS CW2.Activities;
DROP TABLE IF EXISTS CW2.Profile_info;
DROP TABLE IF EXISTS CW2.Contact_info;
DROP TABLE IF EXISTS CW2.User_data;

 /* --------------- DESCRIPTION OF CHANGES MADE FROM FEEDBACK -----------------------------

 format check for emails
 
 activities lookup table added
 user activitied link table added

 inner join changed within the view
 removed username from the view

 CRUD Procedures now check for duplicates on creation AND remove child records on deletion

*/ ----------------------------------------------------------------------------------


-- table creation
CREATE TABLE CW2.User_data(
    user_id INT IDENTITY(1,1) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    user_role VARCHAR(10) DEFAULT 'User' NOT NULL, 
    --constraints
    CONSTRAINT PK_User_data PRIMARY KEY (user_id),
    CONSTRAINT CHK_User_Role CHECK (user_role IN ('Admin', 'User')) 
);

CREATE TABLE CW2.Contact_info(
    contact_id INT IDENTITY(1,1) NOT NULL,
    user_id INT UNIQUE NOT NULL, 
    phone_number VARCHAR(20), 
    email NVARCHAR(100) NOT NULL UNIQUE, 
    marketing_language NVARCHAR(20) DEFAULT 'English' NOT NULL,
    --constraints
    CONSTRAINT PK_Contact_info PRIMARY KEY (contact_id),
    CONSTRAINT FK_Contact_info FOREIGN KEY (user_id) REFERENCES CW2.User_data(user_id),
    --email format check 
    CONSTRAINT CHK_Email_Format CHECK (email LIKE '%_@__%.__%')
);

CREATE TABLE CW2.Profile_info (
    profile_id INT IDENTITY(1,1) NOT NULL,
    user_id INT UNIQUE NOT NULL,
    username NVARCHAR(25) NOT NULL,
    profile_picture NVARCHAR(255),
    about NVARCHAR(500),
    [location] NVARCHAR(50),
    --constraints
    CONSTRAINT PK_Profile PRIMARY KEY (profile_id),
    CONSTRAINT FK_profile FOREIGN KEY (user_id) REFERENCES CW2.User_data(user_id)
);

CREATE TABLE CW2.Activities (
    activity_id INT IDENTITY(1,1) NOT NULL,
    activity_name NVARCHAR(50) NOT NULL UNIQUE,
    --constraint
    CONSTRAINT PK_Activities PRIMARY KEY (activity_id)
);

--link table (from feedback)
CREATE TABLE CW2.User_activities ( 
    user_id INT NOT NULL,
    activity_id INT NOT NULL,
    --constraints
    CONSTRAINT PK_User_Activities PRIMARY KEY (user_id, activity_id),
    CONSTRAINT FK_UA_User FOREIGN KEY (user_id) REFERENCES CW2.User_data(user_id),
    CONSTRAINT FK_UA_Activity FOREIGN KEY (activity_id) REFERENCES CW2.activities(activity_id)
);

--trigger table
CREATE TABLE CW2.Alerts_table(
    alert_id INT IDENTITY(1,1) NOT NULL,
    alert_msg VARCHAR(50),
    user_id INT, 
    alert_time DATETIME DEFAULT GETDATE()
    --constraint
    CONSTRAINT PK_Alerts PRIMARY KEY (alert_id)
);

--data in the tables
INSERT INTO CW2.activities (activity_name) VALUES ('Hiking'), ('Cycling'), ('Mountain Biking'), ('Walking');

INSERT INTO CW2.User_data (first_name, last_name, date_of_birth, user_role)
VALUES ('Joe', 'Smith', '2001-11-06', 'User'),
       ('Maria', 'Jones', '1999-01-23', 'User'),
       ('Daniel', 'Roberts', '2002-05-21', 'User');

INSERT INTO CW2.Contact_info (user_id, phone_number, email, marketing_language)
VALUES (1, '07343438982', 'Jsmith38@mail.com', 'English'),
       (2, NULL, 'MariaJones239@mail.com', 'English'),
       (3, NULL, 'D4NNYRoberts@mail.com', 'English');

INSERT INTO CW2.Profile_info (user_id, username, about, [location])
VALUES (1, 'JoeLovesTrails', 'I love walking on trails at the weekend!', 'Plymouth'),
       (2, 'MariaTheHiker', 'Hiking is my passion!', 'St Ives'),
       (3, 'DanTheBikeMan', 'Cycling and Mountain Biking are what I do best!', 'Exeter');

INSERT INTO CW2.User_activities (user_id, activity_id) VALUES (1, 4); 
INSERT INTO CW2.User_activities (user_id, activity_id) VALUES (2, 1); 
INSERT INTO CW2.User_activities (user_id, activity_id) VALUES (3, 2), (3, 3); 

--view (profile removed as feedback stated)
/* commented out for now to stop errors while writing

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

*/


--CRUD procedures - feedback used to refine each one and better practices used

--create with duplicate checks from feedback
/* commented out to stop errors again

CREATE PROCEDURE CW2.addUser
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @date_of_birth DATE,
    @email NVARCHAR(100),
    @user_role VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM CW2.Contact_info WHERE email = @email)
        BEGIN
            THROW 51000, 'User with this email already exists.', 1;
        END

        BEGIN TRANSACTION
            INSERT INTO CW2.User_data (first_name, last_name, date_of_birth, user_role)
            VALUES (@first_name, @last_name, @date_of_birth, @user_role);
            
            DECLARE @new_id INT = SCOPE_IDENTITY();

            INSERT INTO CW2.Contact_info (user_id, email)
            VALUES (@new_id, @email);
        COMMIT TRANSACTION;
        PRINT 'User added successfully with ID: ' + CAST(@new_id AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS errorMessage;
    END CATCH
END;

*/

-- pre existing users from brief added using the procedures
EXEC CW2.addUser 
    @first_name = 'Grace', 
    @last_name = 'Hopper', 
    @date_of_birth = '1960-12-09', 
    @email = 'grace@plymouth.ac.uk', 
    @user_role = 'User';

EXEC CW2.addUser 
    @first_name = 'Tim', 
    @last_name = 'Berners-Lee', 
    @date_of_birth = '1955-06-08', 
    @email = 'tim@plymouth.ac.uk', 
    @user_role = 'User';

EXEC CW2.addUser 
    @first_name = 'Ada', 
    @last_name = 'Lovelace', 
    @date_of_birth = '1959-12-10', 
    @email = 'ada@plymouth.ac.uk', 
    @user_role = 'User';

SELECT * FROM CW2.User_data;
SELECT * FROM CW2.Alerts_table;

--Read procedure and doesnt use "select *" as specified in the feedback 
/*

CREATE PROCEDURE CW2.findUser 
    @search_username NVARCHAR(25)
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            u.first_name, 
            u.last_name, 
            p.profile_picture,
            p.about, 
            p.[location]
        FROM CW2.Profile_info p
        JOIN CW2.User_data u ON p.user_id = u.user_id
        WHERE p.username = @search_username;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS errorMessage;
    END CATCH
END;

*/

--update procedure
/*

CREATE PROCEDURE CW2.updateUser 
    @user_id INT, 
    @first_name NVARCHAR(50), 
    @last_name NVARCHAR(50), 
    @date_of_birth DATE
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM CW2.User_data WHERE user_id = @user_id)
            BEGIN
                UPDATE CW2.User_data
                SET first_name = @first_name,
                    last_name = @last_name,
                    date_of_birth = @date_of_birth
                WHERE user_id = @user_id;

                COMMIT TRANSACTION;
                PRINT 'User updated.';
            END
            ELSE 
            BEGIN
                ROLLBACK TRANSACTION;
                PRINT 'User ID not found.';
            END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS errorMessage;
    END CATCH
END;

*/

--Delete procedure that also ensures no orphaned records
/*

CREATE PROCEDURE CW2.deleteUser 
    @user_id INT
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM CW2.User_data WHERE user_id = @user_id)
            BEGIN
                -- Delete Child Records First
                DELETE FROM CW2.User_Activities WHERE user_id = @user_id;
                DELETE FROM CW2.Profile_info WHERE user_id = @user_id;
                DELETE FROM CW2.Contact_info WHERE user_id = @user_id;
                
                -- Delete Parent Record
                DELETE FROM CW2.User_data WHERE user_id = @user_id;

                COMMIT TRANSACTION;
                PRINT 'User and all associated data deleted.';
            END
            ELSE
            BEGIN
                ROLLBACK TRANSACTION;
                PRINT 'User ID not found.';
            END    
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS errorMessage;
    END CATCH
END;

*/

EXEC CW2.deleteUser
    @user_id = 4;

EXEC CW2.deleteUser
    @user_id = 5;
    
EXEC CW2.deleteUser
    @user_id = 6;


--trigger
/*

CREATE TRIGGER CW2.newUserLog
ON CW2.User_data
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;
    INSERT INTO CW2.Alerts_table(alert_msg, user_id)
    SELECT 
        'New User Created: ' + first_name + ' ' + last_name,
        user_id
    FROM INSERTED;
END;

*/