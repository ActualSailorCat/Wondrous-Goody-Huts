--UPDATE GoodyHuts SET Weight = 0 AND ImprovementType = 'IMPROVEMENT_METEOR_GOODY' WHERE GoodyHutType NOT LIKE '%SAILOR%';
CREATE TABLE IF NOT EXISTS Sailor_WondrousGoodyWeights (SubTypeGoodyHut text default null, Weight integer default 0);
--////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////
--////////// CHANGE REWARD VALUES BELOW
--////////// Weight is a percentage chance out of 100.
INSERT OR REPLACE INTO Sailor_WondrousGoodyWeights
		(SubTypeGoodyHut,						Weight) 
VALUES	('GOODYHUT_SAILOR_RANDOMRESOURCE',		100), -- Random resource granted.
		('GOODYHUT_SAILOR_RANDOMUNIT',			100), -- Random unit granted.
		('GOODYHUT_SAILOR_RANDOMIMPROVEMENT',	100), -- Random improvement granted.
		('GOODYHUT_SAILOR_SIGHTBOMB',			100), -- Increased sight + sight through features.
		('GOODYHUT_SAILOR_RANDOMPOLICY',		100), -- Random policy granted.
		('GOODYHUT_SAILOR_FORMATION',			100), -- Unit formation upgraded.
		('GOODYHUT_SAILOR_WONDER',				100), -- Discover a new natural wonder.
		('GOODYHUT_SAILOR_CITYSTATE',			100), -- Meet unmet city-state.
		('GOODYHUT_SAILOR_SPY',					100), -- Spy + Capacity
		('GOODYHUT_SAILOR_PRODUCTION',			100), -- Production
		('GOODYHUT_SAILOR_TELEPORT',			0); -- Unit is yeeted somewhere random with Settler.
--////////// CHANGE REWARD VALUES ABOVE
--////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////


--////////// Goody Huts
INSERT INTO GoodyHuts (GoodyHutType, ImprovementType, Weight, ShowMoment)
VALUES ('GOODYHUT_SAILOR_WONDROUS', 'IMPROVEMENT_GOODY_HUT', 100, 1);

-- Random Goody Hut Subtypes
-- 1 Resource Subtype
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_RANDOMRESOURCE',	'LOC_WGH_FLOAT_RESOURCE',		Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 1, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_RANDOMRESOURCE';

-- 2 Unit Subtype
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_RANDOMUNIT',		'LOC_WGH_FLOAT_UNIT',			Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_RANDOMUNIT';

-- 3 Improvement Subtype
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_RANDOMIMPROVEMENT', 'LOC_WGH_FLOAT_IMPROVEMENT',	Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 1, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_RANDOMIMPROVEMENT';

-- 4 Sight Bomb Subtype
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_SIGHTBOMB',		'LOC_WGH_FLOAT_SIGHT',			Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_SIGHTBOMB';

-- 5 RandomPolicy Subtype
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_RANDOMPOLICY',		'LOC_WGH_FLOAT_POLICY',			Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 1, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_RANDOMPOLICY';

-- 6 Formation
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_FORMATION',		'LOC_WGH_FLOAT_FORMATION',		Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_FORMATION';

-- 7 Wonder
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_WONDER',			'LOC_WGH_FLOAT_WONDER',			Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_WONDER';

-- 8 City-State
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_CITYSTATE',		'LOC_WGH_FLOAT_CITYSTATE',		Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_CITYSTATE';

-- 9 Spy + Capacity
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_SPY',				'LOC_WGH_FLOAT_SPY',			Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 1, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_SPY';

-- 10 Production
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_PRODUCTION',		'LOC_WGH_FLOAT_PRODUCTION',		Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 1, 0
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_PRODUCTION';

-- X Teleport
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID, UpgradeUnit, Turn, Experience, Heal, Relic, Trader, MinOneCity, RequiresUnit)
SELECT	'GOODYHUT_SAILOR_WONDROUS', 'GOODYHUT_SAILOR_TELEPORT',			'LOC_WGH_FLOAT_TELEPORT',		Weight, 'SAILOR_GOODY_EMPTY', 0, 0, 0, 0, 0, 0, 0, 1
FROM Sailor_WondrousGoodyWeights WHERE SubTypeGoodyHut = 'GOODYHUT_SAILOR_TELEPORT';


-- Abilities
INSERT INTO Types (Type, Kind)
VALUES	('ABILITY_SAILOR_GOODY_EMPTY',				'KIND_ABILITY'),
		('ABILITY_SAILOR_GOODY_WILDERNESS',			'KIND_ABILITY'),
		('ABILITY_SAILOR_GOODY_FORMATION_ARMY',		'KIND_ABILITY'),
		('ABILITY_SAILOR_GOODY_FORMATION_CORPS',	'KIND_ABILITY');

INSERT INTO TypeTags (Type, Tag)
VALUES	('ABILITY_SAILOR_GOODY_EMPTY',				'CLASS_ALL_UNITS'),
		('ABILITY_SAILOR_GOODY_WILDERNESS',			'CLASS_ALL_UNITS'),
		('ABILITY_SAILOR_GOODY_FORMATION_ARMY',		'CLASS_ALL_UNITS'),
		('ABILITY_SAILOR_GOODY_FORMATION_CORPS',	'CLASS_ALL_UNITS');

INSERT INTO UnitAbilities (UnitAbilityType,			Name, Description, Inactive, Permanent)
VALUES	('ABILITY_SAILOR_GOODY_EMPTY',				NULL, NULL, 1, 1),
		('ABILITY_SAILOR_GOODY_WILDERNESS',			'LOC_ABILITY_SAILOR_GOODY_WILDERNESS_NAME', 'LOC_ABILITY_SAILOR_GOODY_WILDERNESS_DESCRIPTION', 1, 1),
		('ABILITY_SAILOR_GOODY_FORMATION_ARMY',		NULL, NULL, 1, 1),
		('ABILITY_SAILOR_GOODY_FORMATION_CORPS',	NULL, NULL, 1, 1);

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
VALUES	('ABILITY_SAILOR_GOODY_WILDERNESS',			'SAILOR_GOODY_SIGHTBOMB_MOD1'),
		('ABILITY_SAILOR_GOODY_WILDERNESS',			'SAILOR_GOODY_SIGHTBOMB_MOD2'),
		('ABILITY_SAILOR_GOODY_FORMATION_ARMY',		'SAILOR_GOODY_FORMATION_ARMY'),
		('ABILITY_SAILOR_GOODY_FORMATION_CORPS',	'SAILOR_GOODY_FORMATION_CORPS');

-- Modifiers
INSERT INTO Modifiers (ModifierId, ModifierType)
VALUES	('SAILOR_GOODY_EMPTY',						'MODIFIER_PLAYER_UNIT_GRANT_ABILITY'),
		('SAILOR_GOODY_SIGHTBOMB_MOD1',				'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT'),
		('SAILOR_GOODY_SIGHTBOMB_MOD2',				'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_FEATURES'),
		('SAILOR_GOODY_FORMATION_ARMY',				'MODIFIER_PLAYER_UNIT_ADJUST_MILITARY_FORMATION'),
		('SAILOR_GOODY_FORMATION_CORPS',			'MODIFIER_PLAYER_UNIT_ADJUST_MILITARY_FORMATION'),
		('SAILOR_GOODY_SPY_CAPACITY',				'MODIFIER_PLAYER_GRANT_SPY');

INSERT INTO ModifierArguments (ModifierID, Name, Value)
VALUES	('SAILOR_GOODY_EMPTY',						'AbilityType', 'ABILITY_SAILOR_GOODY_EMPTY'),
		('SAILOR_GOODY_SIGHTBOMB_MOD1',				'Amount', 2),
		('SAILOR_GOODY_SIGHTBOMB_MOD2',				'CanSee', 1),
		('SAILOR_GOODY_FORMATION_ARMY',				'MilitaryFormationType', 'ARMY_MILITARY_FORMATION'),
		('SAILOR_GOODY_FORMATION_CORPS',			'MilitaryFormationType', 'CORPS_MILITARY_FORMATION'),
		('SAILOR_GOODY_SPY_CAPACITY',				'Amount', 1);

DROP TABLE Sailor_WondrousGoodyWeights;