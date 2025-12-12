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
