-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Dim 24 Avril 2011 à 02:44
-- Version du serveur: 5.1.36
-- Version de PHP: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

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
  `score` int(11) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=11 ;

--
-- Contenu de la table `kubes`
--

INSERT INTO `kubes` (`id`, `name`, `uid`, `date`, `score`) VALUES
(1, 'kube kikoo', 89, '2011-04-24 04:07:21', 48),
(2, 'kube Warp', 89, '2011-04-24 04:07:21', 0),
(3, 'kube hotel', 89, '2011-04-24 04:07:21', 34),
(4, 'kube test', 89, '2011-04-24 04:07:21', 74),
(5, 'kube ike', 89, '2011-04-24 04:07:21', 59),
(6, 'BarbeKube', 671, '2011-04-24 04:07:21', 46),
(7, 'Kube PollyPocket', 671, '2011-04-24 04:07:21', 48),
(8, 'Kube Hors-Charte', 671, '2011-04-24 04:07:21', 89),
(9, 'Kube Kamikaze', 671, '2011-04-17 04:07:15', 46),
(10, 'Kube Kryogenique', 671, '2011-04-24 04:07:21', 38);

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
(671, 'Slimfr01', 'slimfr01', 9),
(89, 'durss', 'durss', 9);