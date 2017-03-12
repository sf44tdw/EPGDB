/* チャンネル一覧テーブル。チャンネルの読み替え用。
CHANNEL_ID      :EPGに書かれていたチャンネルID
CHANNEL_NO      :対応する物理チャンネル番号(例:東京タワーからのNHK総合なら27)
DISPLAY_NAME    :EPGに書かれていた局名
INSERT_DATETIME :この情報の追加日時(自動入力)
チャンネルIDと物理チャンネル番号の両方が等しいレコードが2件以上存在することは禁止する。
 */
CREATE TABLE `CHANNEL` (
  `CHANNEL_ID` VARCHAR(20) NOT NULL,
  `CHANNEL_NO` INT(11) NOT NULL,
  `DISPLAY_NAME` TEXT,
  `INSERT_DATETIME` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`CHANNEL_ID`),
  UNIQUE KEY `CH_ID_NO` (`CHANNEL_ID`,`CHANNEL_NO`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

/* チャンネル一覧テーブルに内容を追加する。追加日時は自動入力する。
 */
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES (`_CHANNEL_ID`,`_CHANNEL_NO`,`_DISPLAY_NAME`);


/*
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID1",0,"TV1");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID2",1,"TV2");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID3",2,"TV3");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-1",3,"TV4-1");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-2",3,"TV4-2");
SELECT * FROM CHANNEL;



mysql> INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID1",0,"TV1");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID2",1,"TV2");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID3",2,"TV3");
Query OK, 1 row affected (0.04 sec)

mysql> INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID2",1,"TV2");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-1",3,"TV4-1");
INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-2",3,"TV4-2");
Query OK, 1 row affected (0.02 sec)

mysql> INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID3",2,"TV3");
SELECT * FROM CHANNEL;Query OK, 1 row affected (0.03 sec)

mysql> INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-1",3,"TV4-1");
Query OK, 1 row affected (0.02 sec)

mysql> INSERT INTO `CHANNEL` (`CHANNEL_ID`,`CHANNEL_NO`,`DISPLAY_NAME`) VALUES ("ID4-2",3,"TV4-2");
Query OK, 1 row affected (0.04 sec)

mysql> SELECT * FROM CHANNEL;
+------------+------------+--------------+---------------------+
| CHANNEL_ID | CHANNEL_NO | DISPLAY_NAME | INSERT_DATETIME     |
+------------+------------+--------------+---------------------+
| ID1        |          0 | TV1          | 2017-03-12 16:39:07 |
| ID2        |          1 | TV2          | 2017-03-12 16:39:07 |
| ID3        |          2 | TV3          | 2017-03-12 16:39:07 |
| ID4-1      |          3 | TV4-1        | 2017-03-12 16:39:07 |
| ID4-2      |          3 | TV4-2        | 2017-03-12 16:39:07 |
+------------+------------+--------------+---------------------+
5 rows in set (0.00 sec)

mysql>
*/
