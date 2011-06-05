-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Sam 04 Juin 2011 à 16:46
-- Version du serveur: 5.1.53
-- Version de PHP: 5.3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `kubebuilder`
--

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_evaluation`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_evaluation` (
  `kid` int(11) unsigned NOT NULL,
  `uid` int(11) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note` smallint(6) NOT NULL,
  KEY `kid` (`kid`,`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_kubes`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_kubes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `score` int(11) unsigned NOT NULL,
  `locked` tinyint(1) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=138 ;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_reports`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_reports` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `kid` int(11) unsigned NOT NULL,
  `uid` int(11) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_users`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_users` (
  `key` varchar(32) NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `name` varchar(12) NOT NULL,
  `name_low` varchar(12) NOT NULL,
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `points` smallint(6) unsigned NOT NULL,
  `zones` mediumint(9) unsigned NOT NULL,
  `infoRead` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='users list.';


CREATE TABLE IF NOT EXISTS `kubebuilder`.`kubebuilder_lists` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
`uid` MEDIUMINT UNSIGNED NOT NULL ,
`name` VARCHAR( 25 ) NOT NULL ,
`kubes` TEXT NOT NULL ,
PRIMARY KEY ( `id` )
) ENGINE = MYISAM ;