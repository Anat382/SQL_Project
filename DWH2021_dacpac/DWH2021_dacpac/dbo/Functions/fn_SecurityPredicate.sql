CREATE FUNCTION [dbo].[fn_SecurityPredicate](@UserID AS int)
    RETURNS TABLE
	WITH SCHEMABINDING
AS
    RETURN
		SELECT
			1 AS result 
		WHERE
			user_name() = (SELECT TOP 1 REPLACE(NAME,' ','_') FROM [dbo].[Job] WHERE [ID]=@UserID ) OR
			user_name() = 'dbo'