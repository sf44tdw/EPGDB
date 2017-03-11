/* チャンネル一覧テーブル。チャンネルの読み替え用。
channel_id      :EPGに書かれていたチャンネルID
channel_no      :対応する物理チャンネル番号(例:東京タワーからのnhk総合なら27)
display_name    :EPGに書かれていた局名
insert_datetime :この情報の追加日時(自動入力)
チャンネルIDと物理チャンネル番号の両方が等しいレコードが2件以上存在することは禁止する。
 */
CREATE TABLE `channel` (
  `channel_id` varchar(20) NOT NULL,
  `channel_no` int(11) NOT NULL,
  `display_name` text,
  `insert_datetime` timestamp default current_timestamp(),
  PRIMARY KEY (`channel_id`),
  UNIQUE KEY `ch_id_no` (`channel_id`,`channel_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* チャンネル一覧テーブルに内容を追加する。追加日時は自動入力する。
 */
INSERT INTO `channel` (`channel_id`,`channel_no`,`display_name`) VALUES (`_channel_id`,`_channel_no`,`_display_name`);
