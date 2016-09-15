DROP TABLE IF EXISTS postal_code; 

-- Create syntax for TABLE 'postal_code'
CREATE TABLE `postal_code` (
  `id` integer(11) NOT NULL AUTO_INCREMENT,
  `city` varchar(180) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `state_full` varchar(100) DEFAULT NULL,
  `county_full` varchar(100) DEFAULT NULL,
  `county_fips_code` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `accuracy` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `zip` (`zip`),
  KEY `city` (`city`),
  KEY `state` (`zip`),
  KEY `latitude` (`latitude`),
  KEY `longitude` (`longitude`),
  KEY `basic_search` (`city`, `state`),
  KEY `geo_search` (`latitude`, `longitude`, `accuracy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;
