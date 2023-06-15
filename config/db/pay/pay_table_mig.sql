DROP TABLE IF EXISTS uac_load_eco_mig;
CREATE TABLE IF NOT EXISTS uac_load_eco_mig (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `load_line` VARCHAR(10),
  `load_matricule` VARCHAR(25),
  `load_name` VARCHAR(350),
  `load_t1` VARCHAR(25),
  `load_t2` VARCHAR(25),
  `load_t3` VARCHAR(25),
  `load_c4` VARCHAR(25),
  -- Core working here
  `temp_matricule_nbr` VARCHAR(25),
  `temp_matricule_mention` VARCHAR(10),
  `temp_name_a` VARCHAR(25),
  `temp_name_b` VARCHAR(25),
  `core_user_id` BIGINT UNSIGNED,
  `core_t1` INT,
  `core_t2` INT,
  `core_t3` INT,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`);

INSERT INTO uac_load_eco_mig (load_line, load_matricule, load_name, load_t1, load_t2, load_t3, load_c4) VALUES ();
