CREATE TABLE IF NOT EXISTS `whitelist`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `status` boolean,
  `firstconnection` boolean DEFAULT TRUE,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `identifier`(`identifier`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `group` varchar(50) DEFAULT 'user',
  `warnings` int(11) DEFAULT 0,
  `banned` boolean,
  `banneduntil` int(10) DEFAULT 0,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- Dumping structure for table vorpv2.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `charidentifier` int(11) NOT NULL AUTO_INCREMENT,
  `group` varchar(10) COLLATE utf8mb4_bin DEFAULT 'user',
  `money` double(11,2) DEFAULT 0.00,
  `gold` double(11,2) DEFAULT 0.00,
  `rol` double(11,2) NOT NULL DEFAULT 0.00,
  `xp` int(11) DEFAULT 0,
  `healthouter` int(4) DEFAULT 500,
  `healthinner` int(4) DEFAULT 100,
  `staminaouter` int(4) DEFAULT 100,
  `staminainner` int(4) DEFAULT 100,
  `hours` float NOT NULL DEFAULT 0
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `status` varchar(140) COLLATE utf8mb4_bin DEFAULT '{}',
  `meta` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `skinPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `compPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `jobgrade` int(11) DEFAULT 0,
  `coords` varchar(75) COLLATE utf8mb4_bin DEFAULT '{}',
  `isdead` tinyint(1) DEFAULT 0,
  `clanid` int(11) DEFAULT 0,
  `trust` int(11) DEFAULT 0,
  `supporter` int(11) DEFAULT 0,
  `walk` varchar(50) COLLATE utf8mb4_bin DEFAULT 'noanim',
  `crafting` longtext COLLATE utf8mb4_bin DEFAULT '{"medical":0,"blacksmith":0,"basic":0,"survival":0,"brewing":0,"food":0}',
  `info` longtext COLLATE utf8mb4_bin DEFAULT '{}',
  `gunsmith` double(11,2) DEFAULT 0.00,
  `ammo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4 DEFAULT '{}',
  UNIQUE KEY `identifier_charidentifier` (`identifier`,`charidentifier`) USING BTREE,
  KEY `charidentifier` (`charidentifier`) USING BTREE,
  INDEX `ammo` (`ammo`) USING BTREE,
  KEY `clanid` (`clanid`),
  KEY `crafting` (`crafting`(768)),
  KEY `compPlayer` (`compPlayer`(768)),
  KEY `info` (`info`(768)),
  KEY `inventory` (`inventory`(768)),
  KEY `coords` (`coords`),
  KEY `money` (`money`),
  KEY `meta` (`meta`),
  KEY `steamname` (`steamname`),
  CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;


-- ANY NEW UPDATES TO THE TABLES ABOVE NEED TO HAVE TABLE ALTERS ALSO ADDED BELOW FOR THOSE WHO ALREADY HAVE SERVERS RUNNING.
-- The following updates tables that were not included in the original table (Support for those who already have the tables above)
ALTER TABLE `users` ALTER COLUMN  `banned` boolean;
ALTER TABLE `users` ADD `banneduntil` int(10) DEFAULT 0;
ALTER TABLE `whitelist` ADD `status` boolean;
ALTER TABLE `whitelist` ADD `firstconnection` boolean;
ALTER TABLE `characters` ADD `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '';
ALTER TABLE `users` ADD `char` varchar(50) NOT NULL DEFAULT 'false';
ALTER TABLE `characters` ADD COLUMN `ammo` longtext DEFAULT '{}';
ALTER TABLE `characters` ADD INDEX `ammo` (`ammo`);
ALTER TABLE `characters` ADD COLUMN `healthouter` int(4) DEFAULT 500 AFTER `xp`;
ALTER TABLE `characters` ADD COLUMN `healthinner` int(4) DEFAULT 100 AFTER `healthouter`;
ALTER TABLE `characters` ADD COLUMN `staminaouter` int(4) DEFAULT 100 AFTER `healthinner`;
ALTER TABLE `characters` ADD COLUMN `staminainner` int(4) DEFAULT 100 AFTER `staminaouter`;
