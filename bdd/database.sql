-- phpMyAdmin SQL Dump
-- version OVH
-- http://www.phpmyadmin.net
--
-- Serveur: mysql5-21.bdb
-- Généré le : Jeu 30 Juin 2011 à 19:25
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
-- Structure de la table `kubebuilder_hof`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_hof` (
  `id` int(11) NOT NULL auto_increment,
  `date` date NOT NULL,
  `p1` int(11) NOT NULL,
  `p2` int(11) NOT NULL,
  `p3` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
  `hof` tinyint(1) NOT NULL,
  `reportable` tinyint(1) NOT NULL default '1',
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4201 ;

-- --------------------------------------------------------

--
-- Structure de la table `kubebuilder_lists`
--

CREATE TABLE IF NOT EXISTS `kubebuilder_lists` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL,
  `name` varchar(25) NOT NULL,
  `kubes` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1289 ;

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=528 ;

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
  `infoRead` tinyint(1) NOT NULL default '0',
  `warnings` tinyint(4) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='users list.';
