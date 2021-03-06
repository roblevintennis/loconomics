/****** Object:  StoredProcedure [dbo].[TestAlertAvailability]    Script Date: 07/01/2013 14:24:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Iago Lorenzo Salgueiro
-- Create date: 2012-06-01
-- Description:	Test if the conditions for the
-- alert type 'availability' are satisfied, 
-- updating user alert and enabling or 
-- disabling it profile.
-- =============================================
ALTER PROCEDURE [dbo].[TestAlertAvailability]
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AlertID int
	SET @AlertID = 2
    
    -- First ever check if this type of alert affects this type of user
    IF dbo.fxCheckAlertAffectsUser(@UserID, @AlertID) = 0 OR
		EXISTS (SELECT UserID FROM [CalendarProviderAttributes]
		WHERE UserID = @UserID)
		-- Special events (EventType=2) describe provider work-hours
		-- (free time available for booking).
		-- Provider must have almost one record of that type (describing
		-- its work hours) to pass the alert.
		AND EXISTS (SELECT UserID FROM [CalendarEvents]
		WHERE UserID = @UserID AND EventType = 2)
	BEGIN
		-- PASSED: disable alert
		EXEC dbo.SetUserAlert @UserID, 0, @AlertID, 0
	END ELSE BEGIN
		-- NOT PASSED: active alert
		EXEC dbo.SetUserAlert @UserID, 0, @AlertID, 1
	END
	
	-- Test if user profile must be actived or not
	EXEC dbo.TestProfileActivation @UserID, 0
END
