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
  `channel_id` VARCHAR(20) NOT NULL,
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
CREATE PROCEDURE INSERT_PROGRAMME(IN `_channel_id` VARCHAR(20),IN `_event_id` int,IN `_title` text,IN `_start_datetime` DATETIME,IN `_stop_datetime` DATETIME)
SQL SECURITY INVOKER
BEGIN
INSERT INTO `programme` (`channel_id`,`event_id`,`title`,`start_datetime`,`stop_datetime`,`insert_datetime`) VALUES (`_channel_id`,`_event_id`,`_title`,`_start_datetime`,`_stop_datetime`,(SELECT NOW()));
END//
DELIMITER ;



/*
MySQLではCHECK制約が使えないのでトリガーで代用する。
レコードの追加、更新の際に、放送開始時刻が放送終了時刻以前になっていたら、
追加、更新しようとしているレコードのnullにしてはいけないフィールド(channel_id)にnullを設定し、ERROR 1048 (23000): Column 'channel_id' cannot be nullを発生させることで、問題のあるレコードが作られないようにする。
タブを入れると"Display all xxx possibilities? (y or n)"と出てくるのでタブを除去。
 */
delimiter $$

CREATE TRIGGER UPDATE_PROGRAMME BEFORE UPDATE ON `programme` FOR EACH ROW
BEGIN
IF NEW.`start_datetime` >= NEW.`stop_datetime` THEN
SET NEW.`channel_id` = NULL;
END IF;
END;$$



CREATE TRIGGER INSERT_PROGRAMME BEFORE INSERT ON `programme` FOR EACH ROW
BEGIN
IF NEW.`start_datetime` >= NEW.`stop_datetime` THEN
SET NEW.`channel_id` = NULL;
END IF;
END;$$

delimiter ;

/*
mysql> call INSERT_PROGRAMME("BS_238","DUMMY_ID","DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 10:00:00");
ERROR 1048 (23000): Column 'channel_id' cannot be null
mysql> call INSERT_PROGRAMME("BS_238","DUMMY_ID","DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 09:00:00");
ERROR 1048 (23000): Column 'channel_id' cannot be null
mysql> call INSERT_PROGRAMME("BS_238","DUMMY_ID","DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 11:00:00");
Query OK, 1 row affected, 1 warning (0.05 sec)

mysql> select * from programme where event_id="DUMMY_ID";
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
| id    | channel_id | event_id | title       | start_datetime      | stop_datetime       | insert_datetime     |
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
| 52137 | BS_238     |        0 | DUMMY_TITLE | 2015-08-10 10:00:00 | 2015-08-10 11:00:00 | 2015-08-08 19:41:48 |
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
1 row in set, 1 warning (0.04 sec)

mysql> update programme set start_datetime="2015-08-20 10:00:00" where id=52137;
ERROR 1048 (23000): Column 'channel_id' cannot be null
mysql> update programme set start_datetime="2015-08-03 10:00:00" where id=52137;
Query OK, 1 row affected (0.03 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from programme where event_id="DUMMY_ID";
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
| id    | channel_id | event_id | title       | start_datetime      | stop_datetime       | insert_datetime     |
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
| 52137 | BS_238     |        0 | DUMMY_TITLE | 2015-08-03 10:00:00 | 2015-08-10 11:00:00 | 2015-08-08 19:41:48 |
+-------+------------+----------+-------------+---------------------+---------------------+---------------------+
1 row in set, 1 warning (0.01 sec)

mysql> select * from programme where event_id="DUMMY_ID";
Empty set, 1 warning (0.06 sec)
mysql> call INSERT_PROGRAMME("BS_238","DUMMY_ID","DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 09:00:00");
ERROR 1048 (23000): Column 'channel_id' cannot be null
mysql> select * from programme where event_id="DUMMY_ID";
Empty set, 1 warning (0.01 sec)
*/
