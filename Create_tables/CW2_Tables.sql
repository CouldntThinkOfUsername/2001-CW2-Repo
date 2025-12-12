CREATE TABLE CW2.User_data(
    user_id INT IDENTITY(1,1) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    user_role VARCHAR(10) DEFAULT 'User' NOT NULL, 
    --constraints
    CONSTRAINT PK_User_data PRIMARY KEY (user_id),
    --user role check
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

CREATE TABLE CW2.User_activities ( 
    user_id INT NOT NULL,
    activity_id INT NOT NULL,
    --constraints
    CONSTRAINT PK_User_Activities PRIMARY KEY (user_id, activity_id),
    CONSTRAINT FK_UA_User FOREIGN KEY (user_id) REFERENCES CW2.User_data(user_id),
    CONSTRAINT FK_UA_Activity FOREIGN KEY (activity_id) REFERENCES CW2.activities(activity_id)
);

CREATE TABLE CW2.Alerts_table(
    alert_id INT IDENTITY(1,1) NOT NULL,
    alert_msg VARCHAR(50),
    user_id INT, 
    alert_time DATETIME DEFAULT GETDATE()
    --constraint
    CONSTRAINT PK_Alerts PRIMARY KEY (alert_id)
);

