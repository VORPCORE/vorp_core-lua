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


CREATE TABLE IF NOT EXISTS `characters`  (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `charidentifier` int(11) NOT NULL AUTO_INCREMENT,
  `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'user',
  `money` double(11, 2) NULL DEFAULT 0,
  `gold` double(11, 2) NULL DEFAULT 0,
  `rol` double(11, 2) NOT NULL DEFAULT 0,
  `xp` int(11) NULL DEFAULT 0,
  `inventory` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `job` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'unemployed',
  `status` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '{}',
  `firstname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT ' ',
  `lastname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT ' ',
  `skinPlayer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `compPlayer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `jobgrade` int(11) NULL DEFAULT 0,
  `coords` varchar(75) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '{}',
  `isdead` tinyint(1) NULL DEFAULT 0,
  UNIQUE INDEX `identifier_charidentifier`(`identifier`, `charidentifier`) USING BTREE,
  INDEX `charidentifier`(`charidentifier`) USING BTREE,
  CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;


-------------ANY NEW UPDATES TO THE TABLES ABOVE NEED TO HAVE TABLE ALTERS ALSO ADDED BELOW FOR THOSE WHO ALREADY HAVE SERVERS RUNNING.
-- The following updates tables that were not included in the original table (Support for those who already have the tables above)
ALTER TABLE `users` ALTER COLUMN  `banned` boolean;
ALTER TABLE `users` ADD `banneduntil` int(10) DEFAULT 0;
ALTER TABLE `whitelist` ADD `status` boolean
ALTER TABLE `whitelist` ADD `firstconnection` boolean