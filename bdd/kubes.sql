-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Dim 24 Avril 2011 à 22:39
-- Version du serveur: 5.1.53
-- Version de PHP: 5.3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `kubebuilder`
--

-- --------------------------------------------------------

--
-- Structure de la table `evaluation`
--

CREATE TABLE IF NOT EXISTS `evaluation` (
  `kid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note` smallint(6) NOT NULL,
  KEY `kid` (`kid`,`uid`),
  KEY `kid_2` (`kid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Contenu de la table `evaluation`
--


-- --------------------------------------------------------

--
-- Structure de la table `kubes`
--

CREATE TABLE IF NOT EXISTS `kubes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `score` int(11) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=8 ;

--
-- Contenu de la table `kubes`
--

INSERT INTO `kubes` (`id`, `name`, `uid`, `date`, `file`, `score`) VALUES
(1, 'Mon BÔ kube :)', 89, '2011-04-25 00:12:46', 'aaca1a8ff0807f55dcad305552f824c1', 0),
(2, 'Truc bizarre', 89, '2011-04-25 00:24:10', '9ea3d1212357c2c398f22b8a7b31c950', 0),
(3, 'Brique', 89, '2011-04-25 00:30:34', 'b7afedfe22e8bd4505510621e9729c34', 0),
(4, 'Bedrock', 89, '2011-04-25 00:31:14', 'd3f8b775bf16fee2a3bfb643ef30d102', 0),
(5, 'Creeper', 89, '2011-04-25 00:33:26', '3839ed6610b4eac38ceb7a22551ee939', 0),
(6, 'Bois', 89, '2011-04-25 00:34:30', 'e5f141e963c8196429aab143656a356c', 0),
(7, 'Grille', 89, '2011-04-25 00:36:38', '02cef46e1408d245e4ceb3d508fffa21', 0);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(12) NOT NULL,
  `name_low` varchar(12) NOT NULL,
  `level` tinyint(3) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='users list.';

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`id`, `name`, `name_low`, `level`) VALUES
(89, 'durss', 'durss', 0);
