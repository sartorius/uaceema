DROP TABLE IF EXISTS uac_ref_just_category;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_just_category` (
  `id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(7) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `description` VARCHAR(250) NULL,
  `board` CHAR(1) NOT NULL DEFAULT 'N',
  `mandatory_comment` CHAR(1) NULL DEFAULT 'Y',
  `warn_limit` INT NULL DEFAULT 1000000,
  `exp_order` SMALLINT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_just_category (`id`, `code`, `title`, `description`, `board`, `mandatory_comment`, `exp_order`, `warn_limit`)
VALUES (1, 'DIVERSX', 'Divers', 'Dépense frais d`exploitation diverses : fourniture, carburant, administratif etc.', 'N', 'Y', 1, 10000);

INSERT INTO uac_ref_just_category (`id`, `code`, `title`, `description`, `board`, `mandatory_comment`, `exp_order`, `warn_limit`)
VALUES (2, 'SORTIEP', 'Sortie promotion', 'Dépense sortie de promotion', 'N', 'Y', 2, 100000);

INSERT INTO uac_ref_just_category (`id`, `code`, `title`, `description`, `board`, `mandatory_comment`, `exp_order`, `warn_limit`)
VALUES (3, 'DIRECTI', 'Direction', 'Dépense de la direction diverses', 'Y', 'Y', 3, 10000);

INSERT INTO uac_ref_just_category (`id`, `code`, `title`, `description`, `board`, `mandatory_comment`, `exp_order`, `warn_limit`)
VALUES (4, 'EXCEPTI', 'Exceptionnelle', 'Dépense exceptionnelle', 'Y', 'Y', 4, 100000);

DROP TABLE IF EXISTS uac_just;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_just` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cat_id` INT NOT NULL COMMENT 'Category of justification',
  `status` CHAR(1) NOT NULL DEFAULT 'P' COMMENT 'P is for Payed or C for Cancelled - only today justif can be cancelled',
  `pay_date` DATETIME NOT NULL,
  `just_ref` CHAR(10) NOT NULL COMMENT 'Reference generated for Justification',
  `input_amount` INT NOT NULL COMMENT 'Can be zero then it is engagement letter or free input then it is full manual',
  `type_of_payment` CHAR(1) NULL DEFAULT 'C' COMMENT 'C is for Cash, H for Check',
  `agent_id` BIGINT UNSIGNED NULL,
  `mark` CHAR(1) NULL DEFAULT 'N',
  `comment` VARCHAR(150) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`));



DROP VIEW IF EXISTS v_all_just;
CREATE VIEW v_all_just AS
SELECT
  uj.id AS UJ_ID,
  uj.cat_id AS UJ_CAT_ID,
  uj.status AS UJ_STATUS,
  uj.pay_date AS UJ_PAY_DATE,
  uj.just_ref AS UJ_JUST_REF,
  uj.input_amount AS UJ_AMT,
  uj.type_of_payment AS UJ_TYPE,
  uj.agent_id AS UJ_AGENT_ID,
  uj.comment AS UJ_COMMENT,
  mu.username AS MU_AGENT_USERNAME,
  urj.code AS URJ_CODE,
  urj.title AS URJ_TITLE,
  urj.board AS URJ_BOARD,
  urj.mandatory_comment AS URJ_COMMENT_MAND,
  urj.warn_limit AS URJ_WR_LIMIT,
  urj.exp_order AS URJ_ORDER,
  CONCAT(
    UPPER(IFNULL(uj.just_ref, '')),
    UPPER(IFNULL(mu.username, '')),
    UPPER(IFNULL(uj.comment, '')),
    UPPER(IFNULL(urj.code, '')),
    UPPER(IFNULL(urj.title, ''))
  ) AS raw_data
FROM uac_just uj JOIN uac_ref_just_category urj ON uj.cat_id = urj.id
                  JOIN mdl_user mu ON mu.id = uj.agent_id;
