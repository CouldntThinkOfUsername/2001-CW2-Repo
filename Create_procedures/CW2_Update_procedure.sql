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
