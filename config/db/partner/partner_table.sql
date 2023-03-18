DROP TABLE IF EXISTS uac_ref_partner;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_partner` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(250) NOT NULL,
  `description` VARCHAR(250) NULL,
  `img_path` VARCHAR(250) NULL,
  `website` VARCHAR(500) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Alliance Française de Madagascar', NULL, 'alliancefrancaise.png', 'http://www.alliancefr.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('BGFI Banque', NULL, 'bgfibank.png', 'https://madagascar.groupebgfibank.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Groupe Sipromad', NULL, 'groupesipromad.png', 'https://www.sipromad.com/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Masoala Laboratoire', NULL, 'masoalalaboratoire.png', 'https://masoala-laboratoire.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Université du Québec en Abitibi-Témiscamingue', NULL, 'uqat.png', 'https://www.uqat.ca/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ambatovy', NULL, 'ambatovy.png', 'https://ambatovy.com/en/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('British Embassy', NULL, 'britishembassy.png', 'https://www.gov.uk/world/organisations/british-embassy-antananarivo');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Guanomad', NULL, 'guanomad.png', 'https://www.guanomad.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ("Ministère de l\'Enseignement Supérieur et de la Recherche Scientifique", NULL, 'mesupres.png', 'http://www.mesupres.gov.mg/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Vaniala', NULL, 'vaniala.png', 'https://vaniala-naturalspa.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Agence Universitère de la Francophonie', NULL, 'auf.png', 'https://www.auf.org/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ethiopian Airlines', NULL, 'ethiopianairlines.png', 'https://www.ethiopianairlines.com/fr/fr');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Homeopharma', NULL, 'homeopharma.png', 'https://www.homeopharma.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Société Générale Madagasikara', NULL, 'societegeneralemadagasikara.png', 'https://societegenerale.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Bank of Africa', NULL, 'bankofafrica.png', 'https://boamadagascar.com/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Groupe Éducatif ACEEM', NULL, 'groupeaceem.png', 'https://aceemgroupe.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Madajeune', NULL, 'madajeune.png', 'https://www.facebook.com/profile.php?id=100072319024922');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Telma', NULL, 'telma.png', 'https://www.telma.mg/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ambassade de France à Madagascar', NULL, 'ambassadefrancemadagascar.png', 'https://mg.ambafrance.org/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('SBM Banque à Madagascar', NULL, 'sbmbank.png', 'https://globalpresence.sbmgroup.mu/fr/madagascar/');
