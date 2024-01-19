-- Support for any purpose

DROP TABLE IF EXISTS uac_support;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_support` (
  `sup_int` INT NULL,
  `sup_val` VARCHAR(150) NULL,
  `status` CHAR(3) NULL,
  `cmt` VARCHAR(150) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP);
