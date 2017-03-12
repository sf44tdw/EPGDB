/*除外チャンネル判別テーブル。未加入の有料チャンネル等、検索から除外したいチャンネルを記録。
*CHANNEL_ID_         :EPGに書かれていたチャンネルID
*チャンネルテーブル更新の影響を受けさせないため、参照制約は設けない。
*トリガを使用する。
*/
CREATE TABLE `EXCLUDECHANNEL` (
`CHANNEL_ID` VARCHAR(20) NOT NULL,
PRIMARY KEY (`CHANNEL_ID`)
) ENGINE=INNODB  DEFAULT CHARSET=UTF8;



/*
チャンネルテーブルにないチャンネルIDの追加、更新をさせないためのトリガ。
このテーブルへの登録後に、チャンネルテーブルからチャンネルIDが削除されるケースは関知しない。
レコードの追加、更新の際に、チャンネルテーブルにないチャンネルIDが送られてきたら、
追加、更新しようとしているレコードのNULLにしてはいけないフィールド(CHANNEL_ID)にNULLを設定し、ERROR 1048 (23000): COLUMN 'CHANNEL_ID' CANNOT BE NULLを発生させる。
SIGNALは、MYSQL5.1では使えない。
*/
DELIMITER $$

CREATE TRIGGER UPDATE_EXCLUDECHANNEL BEFORE UPDATE ON `EXCLUDECHANNEL` FOR EACH ROW
BEGIN
IF NOT EXISTS (SELECT `CHANNEL_ID` FROM `CHANNEL` AS `X` WHERE `X`.`CHANNEL_ID` = NEW.`CHANNEL_ID`) THEN
SET NEW.`CHANNEL_ID` = NULL;
END IF;
END;$$



CREATE TRIGGER INSERT_EXCLUDECHANNEL BEFORE INSERT ON `EXCLUDECHANNEL` FOR EACH ROW
BEGIN
IF NOT EXISTS (SELECT `CHANNEL_ID` FROM `CHANNEL` AS `X` WHERE `X`.`CHANNEL_ID` = NEW.`CHANNEL_ID`) THEN
SET NEW.`CHANNEL_ID` = NULL;
END IF;
END;$$

DELIMITER ;

/*

SELECT * FROM CHANNEL;
SELECT * FROM EXCLUDECHANNEL;
INSERT INTO `EXCLUDECHANNEL`(`CHANNEL_ID`)VALUES("ID22");
SELECT * FROM EXCLUDECHANNEL;
INSERT INTO `EXCLUDECHANNEL`(`CHANNEL_ID`)VALUES("ID1");
SELECT * FROM EXCLUDECHANNEL;

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

mysql> SELECT * FROM EXCLUDECHANNEL;
Empty set (0.00 sec)

mysql> INSERT INTO `EXCLUDECHANNEL`(`CHANNEL_ID`)VALUES("ID22");
ERROR 1048 (23000): Column 'CHANNEL_ID' cannot be null
mysql> SELECT * FROM EXCLUDECHANNEL;
Empty set (0.00 sec)

mysql> INSERT INTO `EXCLUDECHANNEL`(`CHANNEL_ID`)VALUES("ID1");
SELECT * FROM EXCLUDECHANNEL;Query OK, 1 row affected (0.03 sec)

mysql> SELECT * FROM EXCLUDECHANNEL;
+------------+
| CHANNEL_ID |
+------------+
| ID1        |
+------------+
1 row in set (0.00 sec)

mysql>
*/


/*テーブルに値を入力*/
INSERT INTO `EXCLUDECHANNEL`(`CHANNEL_ID`,`ISPAIDBROADCASTING`)VALUES(CHANNELID);
