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
