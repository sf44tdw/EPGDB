/*番組情報用。
*開始時刻が終了時刻より前にあってもDB側では感知しない。
id              :主キー。自動で生成され、加算される。
event_id        :番組ID(しょっちゅう再利用されているから主キーにはしない)
channel         :チャンネルID(チャンネル一覧テーブルから参照させて物理チャンネルを確認する。)
title           :タイトル
start           :開始時刻(インデックスつき)
stop            :終了時刻
insert_datetime :この情報の追加日時
番組ID,チャンネルID,開始時刻の全てが同じデータは登録できない。(衛星放送の場合、全ての局が全ての局のEPGを放映しているらしいため)
 */
CREATE TABLE `programme` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` char(7) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `title` text NOT NULL,
  `start_datetime` datetime NOT NULL,
  `stop_datetime` datetime NOT NULL,
  `insert_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ch_id_no` (`channel_id`,`event_id`,`start_datetime`),
  KEY `channel_id` (`channel_id`),
  KEY `start_datetime_i` (`start_datetime`),
  CONSTRAINT `programme_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`channel_id`)
) ENGINE=InnoDB;


/*
番組情報テーブルに内容を追加する。追加日時は自動入力する。
チャンネルテーブルにチャンネルIDが登録されていない場合、参照整合性制約により登録できないことを前提とする。
SQLException e.getSQLState()でエラー番号はわかるのでそうする。
 */
DELIMITER //
CREATE PROCEDURE INSERT_PROGRAMME(IN `_channel_id` char(7),IN `_event_id` int,IN `_title` text,IN `_start_datetime` DATETIME,IN `_stop_datetime` DATETIME)
BEGIN
INSERT INTO `programme` (`channel_id`,`event_id`,`title`,`start_datetime`,`stop_datetime`,`insert_datetime`) VALUES (`_channel_id`,`_event_id`,`_title`,`_start_datetime`,`_stop_datetime`,(SELECT NOW()));
END//
DELIMITER ;