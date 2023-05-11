CREATE DATABASE IF NOT EXISTS `vorpv2`
USE `vorpv2`;

CREATE TABLE IF NOT EXISTS `whitelist` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`status` TINYINT(1) NULL DEFAULT '1',
	`firstconnection` TINYINT(1) NULL DEFAULT '1',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `identifier` (`identifier`) USING BTREE,
	CONSTRAINT `FK_characters_whitelist` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=4
;

CREATE TABLE IF NOT EXISTS `users` (
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`group` VARCHAR(50) NULL DEFAULT 'user' COLLATE 'utf8mb4_general_ci',
	`warnings` INT(11) NULL DEFAULT '0',
	`banned` TINYINT(1) NULL DEFAULT NULL,
	`banneduntil` INT(10) NULL DEFAULT '0',
	`char` VARCHAR(50) NOT NULL DEFAULT 'false' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE,
	UNIQUE INDEX `identifier` (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `characters` (
	`identifier` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`steamname` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`charidentifier` INT(11) NOT NULL AUTO_INCREMENT,
	`group` VARCHAR(10) NULL DEFAULT 'user' COLLATE 'utf8mb4_bin',
	`money` DOUBLE(11,2) NULL DEFAULT '0.00',
	`gold` DOUBLE(11,2) NULL DEFAULT '0.00',
	`rol` DOUBLE(11,2) NOT NULL DEFAULT '0.00',
	`xp` INT(11) NULL DEFAULT '0',
	`healthouter` INT(4) NULL DEFAULT '500',
	`healthinner` INT(4) NULL DEFAULT '100',
	`staminaouter` INT(4) NULL DEFAULT '100',
	`staminainner` INT(4) NULL DEFAULT '100',
	`hours` FLOAT NOT NULL DEFAULT '0',
	`LastLogin` DATE NULL DEFAULT NULL,
	`inventory` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`job` VARCHAR(50) NULL DEFAULT 'unemployed' COLLATE 'utf8mb4_bin',
	`status` VARCHAR(140) NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`meta` VARCHAR(255) NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`firstname` VARCHAR(50) NULL DEFAULT ' ' COLLATE 'utf8mb4_bin',
	`lastname` VARCHAR(50) NULL DEFAULT ' ' COLLATE 'utf8mb4_bin',
	`skinPlayer` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`compPlayer` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`jobgrade` INT(11) NULL DEFAULT '0',
	`coords` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`isdead` TINYINT(1) NULL DEFAULT '0',
	`clanid` INT(11) NULL DEFAULT '0',
	`trust` INT(11) NULL DEFAULT '0',
	`supporter` INT(11) NULL DEFAULT '0',
	`walk` VARCHAR(50) NULL DEFAULT 'noanim' COLLATE 'utf8mb4_bin',
	`crafting` LONGTEXT NULL DEFAULT '{"medical":0,"blacksmith":0,"basic":0,"survival":0,"brewing":0,"food":0}' COLLATE 'utf8mb4_bin',
	`info` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`gunsmith` DOUBLE(11,2) NULL DEFAULT '0.00',
	`ammo` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`clan` INT(11) NULL DEFAULT '0',
	`discordid` VARCHAR(255) NULL DEFAULT '0' COLLATE 'utf8mb4_bin',
	`lastjoined` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_bin',
	`motel` VARCHAR(255) NULL DEFAULT '0' COLLATE 'utf8mb4_bin',
	`moonshineenty` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	UNIQUE INDEX `identifier_charidentifier` (`identifier`, `charidentifier`) USING BTREE,
	INDEX `charidentifier` (`charidentifier`) USING BTREE,
	INDEX `clanid` (`clanid`) USING BTREE,
	INDEX `crafting` (`crafting`(768)) USING BTREE,
	INDEX `compPlayer` (`compPlayer`(768)) USING BTREE,
	INDEX `info` (`info`(768)) USING BTREE,
	INDEX `inventory` (`inventory`(768)) USING BTREE,
	INDEX `coords` (`coords`(768)) USING BTREE,
	INDEX `money` (`money`) USING BTREE,
	INDEX `meta` (`meta`) USING BTREE,
	INDEX `steamname` (`steamname`) USING BTREE,
	CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=4
;
