CREATE TABLE IF NOT EXISTS SailorGoodyOptions (Type text default null);
INSERT INTO SailorGoodyOptions (Type)
VALUES ('CITYSTATE'), ('FORMATION'), ('POLICY'), ('PRODUCTION'), ('RESOURCE'), ('SIGHT'), ('SPY'), ('UI'), ('UU'), ('WONDER');

/*INSERT INTO Parameters
		(ParameterId,			Name,							Description,							Domain,	DefaultValue, ConfigurationGroup,	ConfigurationId,		GroupId,			SortIndex)
VALUES	('SailorGC_TELEPORT',	'LOC_SAILORGC_TELEPORT_NAME',	'LOC_SAILORGC_TELEPORT_DESCRIPTION',	'bool', 0,			  'Game',				'SAILORGC_TELEPORT',	'AdvancedOptions',	9000);*/
