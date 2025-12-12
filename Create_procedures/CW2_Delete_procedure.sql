CREATE PROCEDURE CW2.deleteUser 
    @user_id INT
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM CW2.User_data WHERE user_id = @user_id)
            BEGIN
                --Delete child records
                DELETE FROM CW2.User_Activities WHERE user_id = @user_id;
                DELETE FROM CW2.Profile_info WHERE user_id = @user_id;
                DELETE FROM CW2.Contact_info WHERE user_id = @user_id;
                
                --delete parent
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
