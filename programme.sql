/*番組情報用。
*開始時刻が終了時刻より前にあってもDB側では感知しない。
ID              :主キー。自動で生成され、加算される。
EVENT_ID        :番組ID(しょっちゅう再利用されているから主キーにはしない)
CHANNEL         :チャンネルID(チャンネル一覧テーブルから参照させて物理チャンネルを確認する。)
TITLE           :タイトル
START_DATETIME           :開始時刻(インデックスつき)
STOP_DATETIME            :終了時刻(インデックスつき)
番組ID,チャンネルIDが同じデータは登録できない。
 */
CREATE TABLE `PROGRAMME` (
  `ID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHANNEL_ID` VARCHAR(20) NOT NULL,
  `EVENT_ID` INT(11) NOT NULL,
  `TITLE` TEXT NOT NULL,
  `START_DATETIME` DATETIME NOT NULL,
  `STOP_DATETIME` DATETIME NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CH_ID_NO` (`CHANNEL_ID`,`EVENT_ID`),
  KEY `CHANNEL_ID` (`CHANNEL_ID`),
  KEY `START_DATETIME_I` (`START_DATETIME`),
  KEY `STOP_DATETIME_I` (`STOP_DATETIME`),
  CONSTRAINT `PROGRAMME_IBFK_1` FOREIGN KEY (`CHANNEL_ID`) REFERENCES `CHANNEL` (`CHANNEL_ID`)
) ENGINE=INNODB;
