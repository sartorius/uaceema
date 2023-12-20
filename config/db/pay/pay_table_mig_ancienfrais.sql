
DROP TABLE IF EXISTS uac_frais_exclusion;
CREATE TABLE IF NOT EXISTS uac_frais_exclusion (
  `id` INT UNSIGNED NOT NULL,
  `exclusion_id` INT NOT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`, `exclusion_id`));

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(17, 'DRTINSA', 'Droit inscription ancien', 'Droit inscription ancien', 2, 100000, 'A', '2023-12-19', 'U');

UPDATE uac_ref_frais_scolarite SET title = 'Droit inscription nouveau', description = 'Droit inscription nouveau'  WHERE id = 2;

INSERT INTO uac_frais_exclusion (`id`, `exclusion_id`) VALUES (1, 17);
INSERT INTO uac_frais_exclusion (`id`, `exclusion_id`) VALUES (2, 17);
INSERT INTO uac_frais_exclusion (`id`, `exclusion_id`) VALUES (17, 1);
INSERT INTO uac_frais_exclusion (`id`, `exclusion_id`) VALUES (17, 2);
