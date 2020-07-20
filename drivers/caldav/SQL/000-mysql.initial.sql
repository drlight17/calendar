/**
 * CalDAV Client
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

CREATE TABLE IF NOT EXISTS `caldav_attachments` (
  `attachment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `filename` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `mimetype` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `size` bigint(20) NOT NULL DEFAULT '0',
  `data` longblob COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `oauth2_caldav_attachments_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_calendars` (
  `calendar_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `color` int(10) COLLATE utf8mb4_bin NOT NULL,
  `showalarms` smallint(6) NOT NULL DEFAULT '1',
  `caldav_url` varchar(1000) COLLATE utf8mb4_bin NOT NULL,
  `caldav_tag` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_user` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_pass` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_oauth_provider` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `readonly` bigint(20) NOT NULL DEFAULT '0',
  `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`calendar_id`),
  KEY `caldav_user_name_idx` (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_events` (
  `event_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `calendar_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `recurrence_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `uid` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `instance` varchar(16) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `isexception` smallint(6) NOT NULL DEFAULT '0',
  `created` bigint(20) NOT NULL DEFAULT '1000-01-01 00:00:00',
  `changed` bigint(20) NOT NULL DEFAULT '1000-01-01 00:00:00',
  `sequence` int(1) UNSIGNED NOT NULL DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `recurrence` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT NULL,
  `title` varbinary(128) NOT NULL,
  `description` longblob COLLATE utf8mb4_bin NOT NULL,
  `location` varbinary(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `categories` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `all_day` smallint(6) NOT NULL DEFAULT '0',
  `free_busy` smallint(6) NOT NULL DEFAULT '0',
  `priority` smallint(6) NOT NULL DEFAULT '0',
  `sensitivity` smallint(6) NOT NULL DEFAULT '0',
  `status` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `alarms` varchar(255) COLLATE utf8mb4_bin,
  `attendees` varchar(255) COLLATE utf8mb4_bin,
  `notifyat` bigint(20) DEFAULT NULL,
  `caldav_url` varchar(1000) COLLATE utf8mb4_bin NOT NULL,
  `caldav_tag` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `caldav_uid_idx` (`uid`),
  KEY `caldav_recurrence_idx` (`recurrence_id`),
  KEY `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `caldav_attachments`
  ADD CONSTRAINT `oauth2_caldav_attachments_event_id` FOREIGN KEY (`event_id`) REFERENCES `caldav_events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `caldav_calendars`
  ADD CONSTRAINT `oauth2_caldav_calendars_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `caldav_events`
  ADD CONSTRAINT `oauth2_caldav_events_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `caldav_calendars` (`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-caldav-version', '2020072000');
