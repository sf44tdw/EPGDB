/*番組情報用。
*開始時刻が終了時刻より前にあってもDB側では感知しない。
ID              :主キー。自動で生成され、加算される。
EVENT_ID        :番組ID(しょっちゅう再利用されているから主キーにはしない)
CHANNEL         :チャンネルID(チャンネル一覧テーブルから参照させて物理チャンネルを確認する。)
TITLE           :タイトル
START           :開始時刻(インデックスつき)
STOP            :終了時刻
INSERT_DATETIME :この情報の追加日時(自動入力)
番組ID,チャンネルID,開始時刻の全てが同じデータは登録できない。
 */
CREATE TABLE `PROGRAMME` (
  `ID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHANNEL_ID` VARCHAR(20) NOT NULL,
  `EVENT_ID` INT(11) NOT NULL,
  `TITLE` TEXT NOT NULL,
  `START_DATETIME` DATETIME NOT NULL,
  `STOP_DATETIME` DATETIME NOT NULL,
  `INSERT_DATETIME` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CH_ID_NO` (`CHANNEL_ID`,`EVENT_ID`,`START_DATETIME`),
  KEY `CHANNEL_ID` (`CHANNEL_ID`),
  KEY `START_DATETIME_I` (`START_DATETIME`),
  CONSTRAINT `PROGRAMME_IBFK_1` FOREIGN KEY (`CHANNEL_ID`) REFERENCES `CHANNEL` (`CHANNEL_ID`)
) ENGINE=INNODB;

/*
MYSQLではCHECK制約が使えないのでトリガーで代用する。
レコードの追加、更新の際に、放送開始時刻が放送終了時刻以前になっていたら、
追加、更新しようとしているレコードのNULLにしてはいけないフィールド(CHANNEL_ID)にNULLを設定し、ERROR 1048 (23000): COLUMN 'CHANNEL_ID' CANNOT BE NULLを発生させることで、問題のあるレコードが作られないようにする。
タブを入れると"DISPLAY ALL XXX POSSIBILITIES? (Y OR N)"と出てくるのでタブを除去。
SIGNALは、MYSQL5.1では使えない。
 */
DELIMITER $$

CREATE TRIGGER UPDATE_PROGRAMME BEFORE UPDATE ON `PROGRAMME` FOR EACH ROW
BEGIN
IF NEW.`START_DATETIME` >= NEW.`STOP_DATETIME` THEN
SET NEW.`CHANNEL_ID` = NULL;
END IF;
END;$$



CREATE TRIGGER INSERT_PROGRAMME BEFORE INSERT ON `PROGRAMME` FOR EACH ROW
BEGIN
IF NEW.`START_DATETIME` >= NEW.`STOP_DATETIME` THEN
SET NEW.`CHANNEL_ID` = NULL;
END IF;
END;$$

DELIMITER ;

/*
SELECT * FROM PROGRAMME;
INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 10:00:00");
INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 09:00:00");
INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 11:00:00");
SELECT * FROM PROGRAMME;

UPDATE PROGRAMME SET START_DATETIME="2015-08-20 10:00:00" WHERE EVENT_ID=100;
UPDATE PROGRAMME SET START_DATETIME="2015-08-03 10:00:00" WHERE EVENT_ID=100;
SELECT * FROM PROGRAMME;
*/

/*
mysql> SELECT * FROM PROGRAMME;
Empty set (0.00 sec)

mysql> INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 10:00:00");
ERROR 1048 (23000): Column 'CHANNEL_ID' cannot be null
mysql> INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 09:00:00");
ERROR 1048 (23000): Column 'CHANNEL_ID' cannot be null
mysql> INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES ("ID1",100,"DUMMY_TITLE","2015-08-10 10:00:00","2015-08-10 11:00:00");
SELECT * FROM PROGRAMME;
Query OK, 1 row affected (0.02 sec)

mysql> SELECT * FROM PROGRAMME;
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
| ID | CHANNEL_ID | EVENT_ID | TITLE       | START_DATETIME      | STOP_DATETIME       | INSERT_DATETIME     |
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
|  1 | ID1        |      100 | DUMMY_TITLE | 2015-08-10 10:00:00 | 2015-08-10 11:00:00 | 2017-03-12 16:40:47 |
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql>
mysql> UPDATE PROGRAMME SET START_DATETIME="2015-08-20 10:00:00" WHERE EVENT_ID=100;
ERROR 1048 (23000): Column 'CHANNEL_ID' cannot be null
mysql> UPDATE PROGRAMME SET START_DATETIME="2015-08-03 10:00:00" WHERE EVENT_ID=100;
SELECT * FROM PROGRAMME;Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM PROGRAMME;
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
| ID | CHANNEL_ID | EVENT_ID | TITLE       | START_DATETIME      | STOP_DATETIME       | INSERT_DATETIME     |
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
|  1 | ID1        |      100 | DUMMY_TITLE | 2015-08-03 10:00:00 | 2015-08-10 11:00:00 | 2017-03-12 16:40:47 |
+----+------------+----------+-------------+---------------------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql>
*/



/*
番組情報テーブルに内容を追加する。追加日時は自動入力する。
チャンネルテーブルにチャンネルIDが登録されていない場合、参照整合性制約により登録できないことを前提とする。
SQLEXCEPTION E.GETSQLSTATE()でエラー番号はわかるのでそうする。
 */
INSERT INTO `PROGRAMME` (`CHANNEL_ID`,`EVENT_ID`,`TITLE`,`START_DATETIME`,`STOP_DATETIME`) VALUES (`_CHANNEL_ID`,`_EVENT_ID`,`_TITLE`,`_START_DATETIME`,`_STOP_DATETIME`);