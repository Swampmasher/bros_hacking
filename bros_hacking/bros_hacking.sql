


CREATE TABLE `bros_hacking` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(255) DEFAULT NULL,
	`level` int(11) DEFAULT 0,
  	`currentexp` int(11) DEFAULT 0,
	`banktime` int(11) DEFAULT 0,
	`gpstime` int(11) DEFAULT 0,

	PRIMARY KEY (`id`)
);