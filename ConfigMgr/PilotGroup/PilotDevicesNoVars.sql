DECLARE @DevicesPerModel int;   
SET @DevicesPerModel = 1;   
DECLARE @MinDeviceModelCount int;   
SET @MinDeviceModelCount = 1; 


DECLARE @DevicesPerApp int;   
SET @DevicesPerApp = 1; 
DECLARE @MinInstallCount int;   
SET @MinInstallCount = 1;  
 
/* Devices in this collection are marked as already part of the pilot. */
DECLARE @InsiderCollection varchar(10);   
SET @InsiderCollection = ''; 

/* Devices in this collection are part of the evaluation. */
DECLARE @InScopeCollection varchar(10);   
SET @InScopeCollection = 'SMS00001'; 

/* Publishers to Exclude. */
declare @ExcludedPublishers table(PublisherName VARCHAR(60));
insert into @ExcludedPublishers (PublisherName) values ('Microsoft Corporation');



WITH InScope AS
(
	SELECT 
		DISTINCT [ResourceID]
	FROM 
		[v_ClientCollectionMembers] 
	WHERE 
		CollectionID = @InScopeCollection
)
,InsiderDevices AS 
(
	SELECT 
		DISTINCT [ResourceID]
	FROM 
		[v_ClientCollectionMembers] 
	WHERE 
		CollectionID = @InsiderCollection
)
,models AS
( 
	SELECT * FROM 
		(SELECT ResourceID, cs.Manufacturer0, cs.Model0,g.ModelCount,
			ROW_NUMBER() OVER (PARTITION BY cs.Model0,cs.Manufacturer0 ORDER BY cs.ResourceID DESC) AS rn
		FROM [v_GS_COMPUTER_SYSTEM] AS cs
			INNER JOIN (SELECT Model0,Manufacturer0, Count(*) AS ModelCount FROM [v_GS_COMPUTER_SYSTEM] GROUP BY Model0,Manufacturer0) AS g 
				ON g.Manufacturer0 = cs.Manufacturer0 AND g.Model0 = cs.Model0
		WHERE cs.ResourceID IN(SELECT ResourceID FROM InScope)
			) As m
	WHERE 
		rn <= @DevicesPerModel
		AND 
		m.ModelCount >= @MinDeviceModelCount
)
,AdrEnriched AS
(
	Select 
		t.ResourceID, 
		DisplayName0, 
		Publisher0, 
		Version0, 
		CASE WHEN Model0 is not NULL OR InsiderDevices.ResourceID is not NULL THEN 1 ELSE 0 END AS AlreadyPilot 
	FROM 
		v_GS_ADD_REMOVE_PROGRAMS AS t 
		LEFT OUTER JOIN 
			models 
			ON t.ResourceID = models.ResourceID
		LEFT OUTER JOIN 
			InsiderDevices 
			ON t.RevisionID = InsiderDevices.ResourceID
	WHERE
		Publisher0 NOT IN(Select PublisherName FROM @ExcludedPublishers) 
		AND 
		t.ResourceID IN(SELECT ResourceID FROM InScope)
	UNION

	Select 
		t.ResourceID, 
		DisplayName0, 
		Publisher0, 
		Version0, 
		CASE WHEN Model0 is not NULL OR InsiderDevices.ResourceID is not NULL THEN 1 ELSE 0 END AS AlreadyPilot 
	FROM 
		v_GS_ADD_REMOVE_PROGRAMS_64 AS t 
		LEFT OUTER JOIN 
			models 
			ON t.ResourceID = models.ResourceID
		LEFT OUTER JOIN 
			InsiderDevices 
			ON t.RevisionID = InsiderDevices.ResourceID
	WHERE
		Publisher0 NOT IN(Select PublisherName FROM @ExcludedPublishers) 
		AND 
		t.ResourceID IN(SELECT ResourceID FROM InScope)
)
,AdrEnriched2 AS
( 
	Select 
	DisplayName0,Publisher0,Version0, COUNT(ResourceID) as OverallInstallCount, SUM(AlreadyPilot) AS OverallAlreadyPilot 
	FROM 
		AdrEnriched 
	GROUP BY 
		DisplayName0,Publisher0,Version0
	HAVING 
		COUNT(ResourceID) >= @MinInstallCount
		AND
		SUM(AlreadyPilot) < @DevicesPerApp
)
,SelectedAppTestDevices AS 
(
	SELECT * 
	FROM (
		SELECT 
			a.*,
			a2.OverallAlreadyPilot,
			ROW_NUMBER() OVER (PARTITION BY a.DisplayName0,a.Publisher0,a.Version0 ORDER BY ResourceID DESC) AS rn
		FROM
			AdrEnriched AS a
			INNER JOIN 
				AdrEnriched2 AS a2
				ON a.DisplayName0 =a2.DisplayName0 AND
				a.Publisher0 = a2.Publisher0 AND
				a.Version0 = a2.Version0
		WHERE 
			a.AlreadyPilot = 0
		) AS t
	WHERE rn <= @DevicesPerApp - t.OverallAlreadyPilot
)
,PilotDevices AS
(
	SELECT
		DISTINCT ResourceID
	FROM 
		(Select ResourceID FROM SelectedAppTestDevices 
		UNION 
		SELECT ResourceID FROM models) AS t
)


SELECT * FROM PilotDevices