DROP TABLE IF EXISTS uac_ref_concours_result;
CREATE TABLE IF NOT EXISTS uac_ref_concours_result (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mention_txt` VARCHAR(20) NULL,
  `raw_nb` INT NULL,
  `convocation_nb` VARCHAR(100) NULL,
  `fullname` VARCHAR(300) NULL,
  `resultat` VARCHAR(100) NULL DEFAULT 'ADMIS',
  `wave` TINYINT NULL,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES (

INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 1, '002/ConcGE/IèA23-24', 'LAHAKASY De La Joie Mickael', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 2, '004/ConcGE/IèA23-24', 'RASOAMANARIVO Henintsoa Glorya', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 3, '005/ConcGE/IèA23-24', 'SOLONIAINA Jeannoela Perlina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 4, '007/ConcGE/IèA23-24', 'FLORIEN Alan Stiven', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 5, '008/ConcGE/IèA23-24', 'TOLOJANAHARY Francky Eric', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 6, '009/ConcGE/IèA23-24', 'RASOARIMALALA Volanirina Sabatinie Prislà', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 7, '010/ConcGE/IèA23-24', 'RAHARIMALALA Marie Eléonore', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 8, '011/ConcGE/IèA23-24', 'JAOSANTA Ewaldo Gabrielli', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 9, '012/ConcGE/IèA23-24', 'FENOZARA CHAN Logan', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 10, '013/ConcGE/IèA23-24', 'RANAIVOZANDRINY Andrianjaka Manoatiana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 11, '014/ConcGE/IèA23-24', 'RAMBOANIAINA Irintsoa Andrinarilala', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 12, '016/ConcGE/IèA23-24', 'RAZAFIMAHATRATRA Nambinina Felix', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 13, '017/ConcGE/IèA23-24', 'CHAN HING ARIANE', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 14, '018/ConcGE/IèA23-24', 'RAKOTOARIMINO Harenasoa Fitia Vololona', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 15, '023/ConcGE/IèA23-24', 'SANTATRINIAINA Honorine Prisca', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 16, '024/ConcGE/IèA23-24', 'RAVELOMANANTSOA Aina Nasandratra', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 17, '025/ConcGE/IèA23-24', 'RAHERIMANANTSOA Faliniaina Prince Michael', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 18, '026/ConcGE/IèA23-24', 'RABENATONDRALAZA Christiana Vetso Diary', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 19, '028/ConcGE/IèA23-24', 'KANA Sukarno Derys', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 20, '031/ConcGE/IèA23-24', 'RAKOTOARINDRIAKA Christiano Jean', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 21, '032/ConcGE/IèA23-24', 'MALIN ANDRIAFARAMANANA Jessy Mickaël', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 22, '033/ConcGE/IèA23-24', 'RATSIMBAZAFY Ali Faniry', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 23, '035/ConcGE/IèA23-24', 'JOSE MIRIANA', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 24, '036/ConcGE/IèA23-24', 'ROTET Aillah Soamina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 25, '037/ConcGE/IèA23-24', 'JAOHASSANY Armano', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 26, '038/ConcGE/IèA23-24', 'TSARAFARA Tsarafara Be Justin', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 27, '040/ConcGE/IèA23-24', 'ZAKARIASY Juvan Kerry', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 28, '042/ConcGE/IèA23-24', 'MBOAHANGIARINOSY Anjara Fandresena Hernah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 29, '043/ConcGE/IèA23-24', 'ANDRIAMAMONJY Jisia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 30, '044/ConcGE/IèA23-24', 'RASOLONAIVO Herimampionona Tiavina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 31, '045/ConcGE/IèA23-24', 'IONIARISOA Lalatiana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 32, '046/ConcGE/IèA23-24', 'NJOARILAHATRA Noromanatsoa Mikajy Haritsiresy', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 33, '047/ConcGE/IèA23-24', 'RANDRIANAJA Jean Patrick', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 34, '048/ConcGE/IèA23-24', 'ANDRIAMIHAJA Anaïs', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 35, '049/ConcGE/IèA23-24', 'RAZANAMALALA Mélodie Tsilavina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 36, '051/ConcGE/IèA23-24', 'NOMENJANAHARY Warene Rayane', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 37, '052/ConcGE/IèA23-24', 'HOLINIAINA Mamitiana Luciannie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 38, '055/ConcGE/IèA23-24', 'RAMBELOARISON Tahina Mickaël', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 39, '056/ConcGE/IèA23-24', 'VAHINY Gael Ulrick', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 40, '057/ConcGE/IèA23-24', 'TAM Delano Grégory', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 41, '058/ConcGE/IèA23-24', 'RALAIHARY Annah Vaillante', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 42, '059/ConcGE/IèA23-24', 'ANDRIAMANANTENA Minofitia Tania', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 43, '060/ConcGE/IèA23-24', 'MAHALEOMANJAKA Elydo Emmanuel', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 44, '061/ConcGE/IèA23-24', 'ROZINA Celine Leticia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 45, '064/ConcGE/IèA23-24', 'TOKINIAINA Mandamaminirina Mighel Rossinie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 46, '066/ConcGE/IèA23-24', 'RAZANAKOTO Fanahy Naharitra', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 47, '067/ConcGE/IèA23-24', 'FAMINDRA jesline Marie Achita', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 48, '068/ConcGE/IèA23-24', 'RAMANANKAVANA Elodie Mariana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 49, '069/ConcGE/IèA23-24', 'VONIMAMINIRINA Yannick Philberthéa Fifaliana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 50, '070/ConcGE/IèA23-24', 'JONATHAN Caleb Josua', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 51, '071/ConcGE/IèA23-24', 'ANDRIAMBOLOLONJAKA Tovontsoa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 52, '072/ConcGE/IèA23-24', 'RABEARIMANANA Anjatratiana Mandresy', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 53, '073/ConcGE/IèA23-24', 'RAKOTOBE ANDRIANINTSOA Volamalanirina Mirandie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 54, '076/ConcGE/IèA23-24', 'FALIMANANA Tafitasoa Anjara Armelio', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 55, '077/ConcGE/IèA23-24', 'ANDRIAMASY Tolojanahary Ryan', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 56, '081/ConcGE/IèA23-24', 'RAZANAKINIAINA Fifaliana Fahasoavana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 57, '082/ConcGE/IèA23-24', 'HARISOA Bienvenue Fandresena', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 58, '083/ConcGE/Iè23-24', 'RAKOTONIAINA Miandritiana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 59, '084ConcGE/IèA23-25', 'RAKOTONDRABE Sébastien Yannick', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 60, '085/ConcGE/IèA23-25', 'RAKOTOARIMANANA N. Hajatiana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 61, '086/ConcGE/Iè23-25', 'CYRILLE Yoann Francklin', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 62, '088/ConcGE/IèA23-26', 'VELONABY ANDRIANARIVELO Mickael E', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('GESTION', 63, '089/ConcGE/Iè23-26', 'HAINGONIRINA Fanomezantsaoa Jessica', 1);

INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 1, '001/ConcCOM/IèA23-24', 'RABETOKOTANY Tsikinomena Niriantsoa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 2, '003/ConcCOM/IèA23-24', 'RANDRIANASOLO Keziah Anaël', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 3, '004/ConcCOM/IèA23-24', 'ZILOFF Bryan Jésie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 4, '005/ConcCOM/IèA23-24', 'RAOBELINA Riantsoa Gabrielle', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 5, '006/ConcCOM/IèA23-24', 'RASOAMIADANA Lauriana', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 6, '007/ConcCOM/IèA23-24', 'SORONA Chloë Cathrinah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 7, '008/ConcCOM/IèA23-24', 'RATODISON RAZAFINDRAHOARO Herisoa Neïssa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 8, '009/ConcCOM/IèA23-24', 'RAFANOMEZANTSOA Angelo Andonirina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 9, '010/ConcCOM/IèA23-24', 'FANOMEZANTSOA Andoniaina Larissa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 10, '012/ConcCOM/IèA23-24', 'RAZAFINDRAMANANA Eméric Princia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 11, '013/ConcCOM/IèA23-24', 'RAKOTOARIMASY Rina Henintsoa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 12, '014/ConcCOM/IèA23-24', 'MAMY HANITRINIALA Sariaka Tatianah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 13, '015/ConcCOM/IèA23-24', 'ANDRIANIRINA Dimbitiana Lalaina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 14, '016/ConcCOM/IèA23-24', 'RAKOTONDRAMANANA Dinasoa Valerie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 15, '017/ConcCOM/IèA23-24', 'RAKOTOMALALA Andrianomentsoa Harena Alexandre', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 16, '018/ConcCOM/IèA23-24', 'RANAIVOSON Diary Nosoavina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 17, '020/ConcCOM/IèA23-24', 'RAZAFINTSEHENO Yvanah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 18, '021/ConcCOM/IèA23-24', 'RAKOTOARISOA Tahina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 19, '022/ConcCOM/IèA23-24', 'VELO Relie Marie Alexia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 20, '023/ConcCOM/IèA23-24', 'RABERANTO Elisah Nadirah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 21, '024/ConcCOM/IèA23-24', 'RAFANIRIANTSOA Vahatriniaina Mendrika Andréa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 22, '025/ConcCOM/IèA23-24', 'NY MINO Sitraka Miangola', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 23, '027/ConcCOM/IèA23-24', 'FARATIANA Jonnis Florida', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 24, '028/ConcCOM/IèA23-24', 'NASANDRATRIN Lavo Davidette', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 25, '029/ConcCOM/IèA23-24', 'ANDRIANARITEFY Ravaka', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('COMMUNICATION', 26, '030/ConcCOM/IèA23-24', 'FITAHIANJANAHARY  V Midera', 1);

INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 1, '001/ConcDT/IèA23-24', 'ANDRIAMAMY Emilio Andreisse', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 2, '007/ConcDT/IèA23-24', 'RAZAKAHARISON Nambinin Ny Avo Amboara Fandresena Oliva', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 3, '009/ConcDT/IèA23-24', 'RAFANOMEZANJANAHARY Lahiniriko Jean Pasco', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 4, '010/ConcDT/IèA23-24', 'ANDRIAMASINORO Georgina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 5, '011/ConcDT/IèA23-24', 'RAMANANDRAIHASINIAINA Michelinah Marcia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 6, '013/ConcDT/IèA23-24', 'ANDRIATSARA Mickaël Souleman', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 7, '015/ConcDT/IèA23-24', 'TOUZE Charmyka Nirina Ginda', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 8, '017/ConcDT/IèA23-24', 'ANDRIHAJAINA Dinalalaina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 9, '018/ConcDT/IèA23-24', 'LAHAJANAHARY Avila Daria', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 10, '021/ConcDT/IèA23-24', 'RAHARIMANANA Noro Laingo Tina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 11, '026/ConcDT/IèA23-24', 'HERIMALANDY Miangaly Patricia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 12, '027/ConcDT/IèA23-24', 'RAMAHANDRY Sarobidy Tiaviniaina Riantsoa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 13, '028/ConcDT/IèA23-24', 'RAJAONARISON Romina Diane', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 14, '030/ConcDT/IèA23-24', 'VONINOLIVA Mercia ALphonsine', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 15, '031/ConcDT/IèA23-24', 'RABENARIVO Sanepatricia Naïça', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 16, '032/ConcDT/IèA23-24', 'SOANANTENAINA Yakina Welssame', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 17, '035/ConcDT/IèA23-24', 'RAKOTOZAFY Nomena Fitia Edinna', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 18, '036/ConcDT/IèA23-24', 'ANDRIAMBOLOLONA Kalo Ny Antsiva Tsantaniala', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 19, '037/ConcDT/IèA23-24', 'RANDRIAMBELO Deo Fy Miavaka', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 20, '039/ConcDT/IèA23-24', 'RAZANAKOTO Mitia Harinaivo Nantenaina', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 21, '040/ConcDT/IèA23-24', 'RABENANDRASANA Ny Ony Franck', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 22, '041/ConcDT/IèA23-24', 'TIANDRAINY Erika Gerard', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 23, '043/ConcDT/IèA23-24', 'HARENA VATOSOA Maeva Loickah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 24, '044/ConcDT/IèA23-24', 'RAZANADRAMAROLAHY Marcelo', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 25, '045/ConcDT/IèA23-24', 'NOMENJANAHARY Rianala Elodie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 26, '046/ConcDT/IèA23-24', 'RASOARIMALALA Liantsoa Gabriellah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 27, '047/ConcDT/IèA23-24', 'RAMANAMBAHY Alphoncia Carmelle', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 28, '048/ConcDT/IèA23-24', 'HANITRINIAINA Olivia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 29, '051/ConcDT/IèA23-24', 'RAHERINANTENAINA Anjarasoa Mirindra Fanyah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 30, '052/ConcDT/IèA23-24', 'RAKOTONIRINA Nomena Ny Avo', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 31, '055/ConcDT/IèA23-24', 'FANOMEZANTSOA Dahy Florinah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 32, '057/ConcDT/IèA23-24', 'ANDRIATSIMISATA Manovisoa Célyah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 33, '059/ConcDT/IèA23-24', 'BOTRA Suzzanna', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 34, '060/ConcDT/IèA23-24', 'RANDRIAMAMONJISOA Marionnette Naziah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 35, '063/ConcDT/IèA23-24', 'RAJARY Augustin', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 36, '064/ConcDT/IèA23-24', 'NASOLONJANAHARY Sarah', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 37, '065/ConcDT/IèA23-24', 'ANDRIAMORAMANANA faniriantsoa Noemie', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 38, '066/ConcDT/IèA23-24', 'Vitasoa Patricia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 39, '067/ConcDT/IèA23-24', 'RARIVOSON Harentsoa Nomenjanahary', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 40, '068/ConcDT/IèA23-24', 'RAHARINIRINA Sendramamy', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 41, '069/ConcDT/IèA23-24', 'MANDANIAINA Valinjaka Narindra', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 42, '071/ConcDT/IèA23-24', 'ANDRIAMANANKASINA Prince Tafita Idéal', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 43, '075/ConcDT/IèA23-24', 'TAHINJANAHARY Mbolatiana Minosoa', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('DROIT', 44, '076/ConcDT/IèA23-24', 'TOMBOLAZA Ellimi Jonathan', 1);


INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 1, '001/ConcECO/IèA23-24', 'ANDRIANJAKA FY HASINA', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 2, '002/ConcECO/IèA23-24', 'RABEMANANTSOA Narindra Christiane', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 3, '006/ConcECO/IèA23-24', 'RAROJOSON Mandresy El Jonathan', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 4, '008/ConcECO/IèA23-24', 'RADAFISON Randy Mitia', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 5, '009/ConcECO/IèA23-24', 'TSOERA Joff Rotman', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 6, '010/ConcECO/IèA23-24', 'RABEZARISAONANIRIANA Enintsoa Mahery Harizo', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 7, '013/ConcECO/IèA23-24', 'RAHERINIAINA Mialisoa Jessica', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, wave) VALUES ('ECONOMIE', 8, '014/ConcECO/IèA23-24', 'RAJAOFENOHASINIAINA Miantsa ', 1);

INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 1, '001/ConcIE/IèA23-24', 'ANDRIAMAMY Welino Andrewise', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 2, '002/ConcIE/IèA23-24', 'RAJARISON Nomeniavo Mosesy Ezekiela Fandresena', 'Admis après délibération ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 3, '003/ConcIE/IèA23-24', 'RATEFINJANAHARY Finaritra Ny Avo', 'Admis après délibération ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 4, '004/ConcIE/IèA23-24', 'RANDRIAMBOLOLONA Jean Pierre', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 5, '005/ConcIE/IèA23-24', 'RATOVOMELANIAIANA Edrice', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 6, '006/ConcIE/IèA23-24', 'RAMAMONJISOA Malalatiana', 'Admise', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 7, '007/ConcIE/IèA23-24', 'RAKOTOMALALA Feno Mampianina', 'Admis après délibération ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 8, '008/ConcIE/IèA23-24', 'ANDRIAMAMY Andoniaina Zo Harinala', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 9, '009/ConcIE/IèA23-24', 'RAKOTOARIJAONA Rolphe Jean Chrysostome', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 10, '011/ConcIE/IèA23-24', 'KALO Jean Claudio', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 11, '012/ConcIE/IèA23-24', 'My Andrianantenaina Safidy Njava', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 12, '013/ConcIE/IèA23-24', 'NISI NIAFIANA Natolotra Chrétien', 'Admis ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 13, '014/ConcIE/IèA23-24', 'RAHARIMALALA Ezra', 'Admise après délibération ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 14, '015/ConcIE/IèA23-24', 'MIHARISOA Nelly Irinah', 'Admise après délibération ', 1);
INSERT INTO uac_ref_concours_result (mention_txt, raw_nb, convocation_nb, fullname, resultat, wave) VALUES ('INFO', 15, '016/ConcIE/IèA23-24', 'HARINIAINA DIGIO Emmanuel Emidio', 'Admise après délibération ', 1);
