/* チャンネル一覧テーブル。チャンネルの読み替え用。
CHANNEL_ID      :EPGに書かれていたチャンネルID
CHANNEL_NO      :対応する物理チャンネル番号(例:東京タワーからのNHK総合なら27)
DISPLAY_NAME    :EPGに書かれていた局名
チャンネルIDと物理チャンネル番号の両方が等しいレコードが2件以上存在することは禁止する。
 */
CREATE TABLE `CHANNEL` (
  `CHANNEL_ID` VARCHAR(20) NOT NULL,
  `CHANNEL_NO` INT(11) NOT NULL,
  `DISPLAY_NAME` TEXT,
  PRIMARY KEY (`CHANNEL_ID`),
  UNIQUE KEY `CH_ID_NO` (`CHANNEL_ID`,`CHANNEL_NO`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

