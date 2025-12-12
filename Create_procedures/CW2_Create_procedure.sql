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
