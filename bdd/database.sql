-- phpMyAdmin SQL Dump
-- version OVH
-- http://www.phpmyadmin.net
--
-- Serveur: mysql5-21.bdb
-- Généré le : Jeu 02 Juin 2011 à 22:25
-- Version du serveur: 5.0.90
-- Version de PHP: 5.3.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `fevermapmysql`
--

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_evaluation`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_evaluation` (
  `kid` int(11) unsigned NOT NULL,
  `uid` int(11) unsigned NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `note` smallint(6) NOT NULL,
  KEY `kid` (`kid`,`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_kubes`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_kubes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(25) collate utf8_unicode_ci NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `file` varchar(32) collate utf8_unicode_ci NOT NULL,
  `score` int(11) unsigned NOT NULL,
  `locked` tinyint(1) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=125 ;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_reports`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_reports` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `kid` int(11) unsigned NOT NULL,
  `uid` int(11) unsigned NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_users`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_users` (
  `key` varchar(32) NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `name` varchar(12) NOT NULL,
  `name_low` varchar(12) NOT NULL,
  `level` tinyint(3) unsigned NOT NULL default '1',
  `points` smallint(6) unsigned NOT NULL,
  `zones` mediumint(9) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='users list.';
