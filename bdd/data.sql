﻿-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Jeu 02 Juin 2011 à 20:35
-- Version du serveur: 5.1.53
-- Version de PHP: 5.3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `kubebuilder`
--

--
-- Contenu de la table `kubebuilder_evaluation`
--

INSERT INTO `kubebuilder_evaluation` (`kid`, `uid`, `date`, `note`) VALUES
(5, 89, '2011-05-08 22:07:17', 18),
(18, 89, '2011-05-08 22:09:46', 18),
(90, 89, '2011-05-08 23:33:20', 18),
(93, 313, '2011-05-16 20:28:52', 13),
(93, 89, '2011-05-16 21:33:57', 18),
(78, 89, '2011-05-16 21:55:43', 18),
(88, 89, '2011-05-16 21:56:58', 18),
(19, 89, '2011-05-16 21:57:57', 18),
(3, 89, '2011-05-16 21:59:22', 18),
(96, 89, '2011-05-29 16:14:42', 108);

--
-- Contenu de la table `kubebuilder_kubes`
--

INSERT INTO `kubebuilder_kubes` (`id`, `name`, `uid`, `date`, `file`, `score`, `locked`) VALUES
(1, 'Mon BÔ kube :)', 89, '2011-04-25 00:12:46', 'aaca1a8ff0807f55dcad305552f824c1', 0, 0),
(2, 'Truc bizarre', 89, '2011-04-25 00:24:10', '9ea3d1212357c2c398f22b8a7b31c950', 0, 0),
(3, 'Brique', 89, '2011-04-25 00:30:34', 'b7afedfe22e8bd4505510621e9729c34', 18, 0),
(4, 'Bedrock', 89, '2011-04-25 00:31:14', 'd3f8b775bf16fee2a3bfb643ef30d102', 0, 0),
(5, 'Creeper', 89, '2011-04-25 00:33:26', '3839ed6610b4eac38ceb7a22551ee939', 0, 0),
(6, 'Bois', 89, '2011-04-25 00:34:30', 'e5f141e963c8196429aab143656a356c', 0, 0),
(7, 'Grille', 89, '2011-04-25 00:36:38', '02cef46e1408d245e4ceb3d508fffa21', 0, 0),
(8, 'Kube', 89, '2011-04-26 00:19:22', '440745c5721b16c803ce6b0cd810b7f7', 0, 0),
(9, 'MT', 89, '2011-04-26 00:31:42', 'fd7cf8f33485c9a053b8df4e296601d3', 0, 0),
(10, 'Star', 89, '2011-04-26 00:32:51', 'f4cdee5919eb26ed2540eac306524d4d', 0, 0),
(11, 'Société géniale', 89, '2011-04-26 00:35:24', '8bd8d8dff168d244104aaa9b234d295c', 0, 0),
(12, 'Ground', 89, '2011-04-26 00:37:16', '8a571b3ae0d70fe90b95586e89a232d7', 0, 0),
(13, 'Gravier', 89, '2011-04-26 00:38:00', 'e8c60533a36094dbf8fc0cc723eed051', 0, 0),
(14, 'Fleur', 89, '2011-04-26 00:39:41', '658a8a33fb2622c64acec45d1534eed0', 0, 0),
(15, 'Cloture', 89, '2011-04-26 00:41:47', 'da79c0d654afe50371cf6fd381f119c3', 0, 0),
(16, 'Brique2', 89, '2011-04-26 00:44:19', '6a5e1c392fcb3ef923337fc073177601', 0, 0),
(17, 'Mur', 89, '2011-04-26 00:45:19', 'b2555bdcb5b53cffd98a7de8e524aacc', 0, 0),
(18, 'Mur de pierre', 89, '2011-04-26 00:46:20', 'e828e8885edbe7baf1c3c6ff79b6bb86', 18, 0),
(19, 'WoOt', 89, '2011-04-26 00:53:46', 'a8fc9c39d11e1d62c311f6e81eaf6cfa', 18, 0),
(20, 'Terre rouge', 89, '2011-04-26 00:54:40', '463c6d0e12e0f834d343bef95a011cc5', 0, 0),
(21, 'Roseau', 89, '2011-04-26 00:55:40', 'd6d5cf228d6d82750725f5df3ea0b545', 0, 0),
(22, 'Poulet', 671, '2011-04-26 02:18:38', '0a1bc8f6dbf6af5cabdd0d326d37c081', 0, 0),
(23, 'Poulet Fermier', 671, '2011-04-26 02:28:15', '9abc99be5166ebbb90af501f15adb8fe', 0, 0),
(24, 'Mario', 89, '2011-04-27 01:02:29', '72d9904b807d2e7f73574adc6840a417', 0, 0),
(35, 'Poussiere', 89, '2011-05-01 16:18:53', '5938decd0bbdaac00e4f01f407809090', 0, 0),
(34, 'Gradient', 89, '2011-05-01 16:18:22', 'e8e57c64ba4207a8f1ea6e6625b11653', 0, 0),
(33, 'Galaxie', 89, '2011-05-01 16:17:29', '2c2ebef630c3f21c38b73469eccdd87c', 0, 0),
(32, 'Terre', 89, '2011-05-01 16:16:41', 'c78ce18a8e9a28f58740dad482a34aa2', 0, 0),
(31, 'Soleil', 89, '2011-05-01 16:15:01', '28574be42958ae15b4b4946078a677d7', 0, 0),
(36, 'Carré', 89, '2011-05-01 16:20:25', '1fe3147223b8b4ce6defc6dca62da2c4', 0, 0),
(37, 'Kromignooon', 89, '2011-05-01 16:21:00', 'e4c08f31b5ad09e7fce05f5d5dd9c430', 0, 0),
(38, 'Psychokouak', 89, '2011-05-01 16:22:00', '56ba4d13f5044faafe648f209e3f9f16', 0, 0),
(39, 'Boîte à jouets', 408, '2011-05-01 16:22:10', '12404bcfab711b4122eec42f6368e580', 0, 0),
(40, 'Rubix', 89, '2011-05-01 16:22:53', '1c9010c02c57b54f29581f75d77a50bc', 0, 0),
(41, 'Arc-en-ciel', 112, '2011-05-01 16:22:56', '4fd7e553e46c32ee10ea2669d97cbf79', 0, 0),
(42, 'Atlanteparty', 519, '2011-05-01 16:24:26', '8b88bd00182c71f5ae5b62950dfe11b2', 0, 0),
(43, 'Spirale', 112, '2011-05-01 16:25:33', 'b72ba47fb8e1456c38824d44fb064da7', 0, 0),
(44, 'Orange', 89, '2011-05-01 16:26:12', '97aa7bbea4a9f3156303961ecaa25f6c', 0, 0),
(45, 'Truc', 89, '2011-05-01 16:29:39', '82038a3020d39a1369f60962a06288c9', 0, 0),
(46, 'Caca', 57, '2011-05-01 16:31:45', '298b6d07bfef7d528ca0bd5840b46e35', 0, 0),
(47, 'Bobo', 89, '2011-05-01 16:32:06', '6d142fc3bc9e4cb94ac3bdd0b0d0e317', 0, 0),
(48, 'Machin bleu', 89, '2011-05-01 16:32:27', '8444c10ff724ae1ad0d3d5e15d7853ff', 0, 0),
(49, 'Disquette', 89, '2011-05-01 16:33:00', '798381b2d8748ce229b36a2541a2e983', 0, 0),
(50, 'Poil!', 519, '2011-05-01 16:33:18', '99eec4bb0eea1cb62a5140f8981522ff', 0, 0),
(51, 'Truc', 89, '2011-05-01 16:33:45', '011614ab10929887defef577ad7eaa36', 0, 0),
(52, 'Noeud', 89, '2011-05-01 16:34:18', 'e6ede60ea681b8a04fd80cc9ac5cc8e3', 0, 0),
(53, 'Coeur', 89, '2011-05-01 16:34:43', '3a9e7d3f63063dc152bec8c0cfdd770f', 0, 0),
(54, 'Rose', 57, '2011-05-01 16:35:30', 'db434a28d6351407181c068f39fe9108', 0, 0),
(55, 'Chrome', 89, '2011-05-01 16:36:18', '18140e31043844be24b80fc85e378c23', 0, 0),
(56, 'Marbre moche', 519, '2011-05-01 16:37:08', '845ada436095986dd1dfb842d70bbc1d', 0, 0),
(57, 'Trombonne', 89, '2011-05-01 16:37:09', '8d6fe18f4bc3b4a7e4a57d27c66f3e18', 0, 0),
(58, 'laule', 89, '2011-05-01 16:37:40', '57ed1da4e52847e54f7929c8c50746e4', 0, 0),
(59, 'Happy', 89, '2011-05-01 16:38:40', '8f91d10f3524abd708d9fb7d8d2fd366', 0, 0),
(60, 'Bébé', 89, '2011-05-01 16:40:21', 'c566bc5c3198287bd1147e389be98ced', 0, 0),
(61, 'Graphique', 89, '2011-05-01 16:41:00', '51f73154adef44003207ca90925a1a99', 0, 0),
(62, 'Réveil', 89, '2011-05-01 16:41:27', '0f9ec1b8f5755e02b9a68bfbfd609506', 0, 0),
(63, 'Skull', 89, '2011-05-01 16:42:00', '198d8a794fd388946c6dc8e616e49627', 0, 0),
(64, 'Kwaiiiii', 89, '2011-05-01 16:42:25', '74023b93af9a0d77e7e5b7105e9a23ed', 0, 0),
(65, 'Caddie', 89, '2011-05-01 16:42:55', '7f2d2fcb4b0c9303a21783765dd0c9f7', 0, 0),
(66, 'Donut', 89, '2011-05-01 16:43:31', '03bd2fd879a7f0c2a87a45e4f34234a9', 0, 0),
(67, 'Facebook', 89, '2011-05-01 16:44:09', '9662a9d50c5a49ab3aa4f20a5f154d16', 0, 0),
(68, 'Home', 89, '2011-05-01 16:44:40', 'c0be0c10e5c8d5f24983a542333cf002', 0, 0),
(69, 'Fraise', 89, '2011-05-01 16:44:59', 'efa18e71093c757911d0b427b80b37c5', 0, 0),
(70, 'Coeur', 89, '2011-05-01 16:45:30', '74e5092c2598605591c140e332916246', 0, 0),
(71, 'Wink', 89, '2011-05-01 16:45:53', 'd36e427ee9e5395c4e5187d2087cf093', 0, 0),
(72, 'Shai-Hul''Kube', 543, '2011-05-01 17:07:30', '2a5e4a98fed469fb74c91d2804a7ba7e', 0, 0),
(73, 'Captain'' Obvious', 543, '2011-05-01 17:21:29', 'f715100d405fbc4446d06866943b6b30', 0, 0),
(74, 'Statue Coffre ?', 543, '2011-05-01 17:30:58', '82f1c823e0c86c4d229e36048fae54cc', 0, 0),
(75, 'Present', 89, '2011-05-01 18:16:35', 'a256bdde5532a1a4a4fcc8b7fd73f4e9', 0, 0),
(76, 'Danger', 89, '2011-05-01 18:16:55', '3babd6f078997cfdbf363737e61bad88', 0, 0),
(77, 'Twitter', 89, '2011-05-01 18:17:13', 'a0ead56bb124b7c53dbbf506df35dda5', 0, 0),
(78, 'N', 89, '2011-05-01 18:17:43', 'e24d5455eb4d1802a42331181a614c53', 18, 0),
(79, 'Télévision', 89, '2011-05-01 18:18:03', '4b3e70f92519462b7343157e44cb67e5', 0, 0),
(80, 'Boite', 89, '2011-05-01 18:18:23', 'a8375d3cae139b08c9ce456dc15c0e48', 0, 0),
(81, '+', 89, '2011-05-01 18:18:39', 'd1eb10f4bda52469835cc3fa9a3015b8', 0, 0),
(82, 'PB', 89, '2011-05-01 18:18:55', '4607c2524a74e19f505537612232f740', 0, 0),
(83, 'Orange weird', 89, '2011-05-01 18:19:13', '93349b490938604f9d8023f8f7981a6e', 0, 0),
(84, 'Zelda bird', 89, '2011-05-01 18:19:33', 'f484b79af968a06fa335bda531511d72', 0, 0),
(85, 'Link', 89, '2011-05-01 18:19:50', 'fd1d2840c3a921d511d4eea5d5062fbd', 0, 0),
(86, 'Triforce', 89, '2011-05-01 18:20:23', 'f4f8be47a0b6058b132d8403cdda2568', 0, 0),
(87, 'Rainbooooow', 89, '2011-05-01 18:21:50', '52f535d8ad2b5b1798fe6a3529eea6f8', 0, 0),
(88, 'Question bloc', 89, '2011-05-01 18:22:16', 'fbd67364063be95c3ed90882483de004', 18, 0),
(89, 'MC gold', 89, '2011-05-01 18:22:30', '4f1a544e4ccbec8a6532df8136b3033c', 0, 0),
(90, 'Rubix exploded', 89, '2011-05-01 18:22:53', '25ffc711ff3e69a272bcc04751871afb', 18, 0),
(91, 'Papillon', 89, '2011-05-01 18:23:19', '5ac74822053434637601e406782512e3', 0, 0),
(92, 'Bois', 89, '2011-05-01 18:23:41', '96957bba833b547662bd892679f2e486', 0, 0),
(93, 'Eau', 89, '2011-05-01 18:26:13', '965dfdac8b7c045188d424fa5a2eb5a5', 31, 0),
(94, 'Laine', 89, '2011-05-01 18:26:29', '1de5ad0065d2ef79242dc2cb29a7eb6c', 0, 0),
(95, 'Sable', 89, '2011-05-01 18:27:00', '6756d14a42a4a99648792295a471d99d', 0, 0),
(96, 'Terre', 89, '2011-05-01 18:27:23', '57662d92d9010c2db9b2cbb7c5c8d430', 108, 0),
(97, 'Mousse', 89, '2011-05-01 18:27:38', 'c1a0a870800b3d68020e1728efe395f9', 0, 0),
(98, 'Neige', 89, '2011-05-01 18:27:56', 'f0602b393f5483527eb51d9413e50df2', 0, 0),
(99, '+1', 89, '2011-05-07 18:36:33', '2c3f43b916e9c23536a1fe9337c95b61', 0, 0),
(100, '-1', 89, '2011-05-07 18:42:42', '986eb435784d5ea6b90acd1345d0cf71', 0, 0),
(101, 'Warning', 89, '2011-05-08 15:45:14', '6834f750b96a1e110dbe3ef7d51e7155', 0, 0),
(102, 'Warning2', 89, '2011-05-08 16:07:06', 'e76891abe8996e67045e12614e6c64ba', 0, 0),
(103, 'Close', 89, '2011-05-29 16:32:04', '89_1306679524', 0, 0),
(104, 'TP', 89, '2011-05-31 23:08:14', '89_1306876094', 0, 0),
(106, 'Tete de con', 89, '2011-06-02 20:16:29', '89_1307038588', 0, 0),
(105, 'Merde', 89, '2011-06-02 20:15:10', '89_1307038510', 0, 0),
(107, 'Tete de con', 89, '2011-06-02 20:16:49', '89_1307038609', 0, 0),
(108, 'Poil', 89, '2011-06-02 20:21:43', '89_1307038903', 0, 0),
(109, 'dsqdq', 89, '2011-06-02 20:22:32', '89_1307038952', 0, 0),
(110, 'bleu', 89, '2011-06-02 20:24:21', '89_1307039061', 0, 0),
(111, 'dfgdf', 89, '2011-06-02 20:25:01', '89_1307039101', 0, 0),
(112, 'gfdgfd', 89, '2011-06-02 20:25:21', '89_1307039121', 0, 0),
(113, 'dfds', 89, '2011-06-02 20:26:05', '89_1307039165', 0, 0),
(114, 'vc', 89, '2011-06-02 20:26:30', '89_1307039190', 0, 0),
(115, 'dfd', 89, '2011-06-02 20:27:00', '89_1307039220', 0, 0),
(116, 'gfgf', 89, '2011-06-02 20:28:08', '89_1307039288', 0, 0),
(117, 'fds', 89, '2011-06-02 20:28:45', '89_1307039325', 0, 0),
(118, 'dsqdsq', 89, '2011-06-02 20:29:01', '89_1307039341', 0, 0),
(119, 'dsqdsqdsq', 89, '2011-06-02 20:29:13', '89_1307039353', 0, 0),
(120, 'fdfd', 89, '2011-06-02 20:30:04', '89_1307039404', 0, 0),
(121, 'dsqdsqdsq', 89, '2011-06-02 20:31:10', '89_1307039470', 0, 0);

--
-- Contenu de la table `kubebuilder_reports`
--


--
-- Contenu de la table `kubebuilder_users`
--

INSERT INTO `kubebuilder_users` (`key`, `id`, `name`, `name_low`, `level`, `points`, `zones`) VALUES
('0c66b1438ef5bd89ed4baf59455d9e6b', 89, 'Durss', 'durss', 1, 476, 26778),
('', 671, 'Slimfr01', 'slimfr01', 1, 0, 0),
('', 703, 'Bugzilla', 'bugzilla', 1, 0, 0),
('', 465930, 'Eole', 'eole', 1, 0, 0),
('', 112, 'Xuisis', 'xuisis', 1, 0, 0),
('', 519, 'Lugiarachi', 'lugiarachi', 1, 0, 0),
('', 408, 'Arma', 'arma', 1, 0, 0),
('', 57, 'Braxer', 'braxer', 1, 0, 0),
('', 543, 'moulins', 'moulins', 1, 0, 0),
('', 162777, 'Chihiro', 'chihiro', 1, 0, 0),
('', 665, 'Brisespoir', 'brisespoir', 1, 0, 0),
('', 12832, 'Colapsydo', 'colapsydo', 1, 0, 0),
('cefabd4db5e3e37f5fd83680b18d8be6', 313, 'elguigo', 'elguigo', 1, 263, 27366);