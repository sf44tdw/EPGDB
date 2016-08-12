/* チャンネル一覧テーブル。チャンネルの読み替え用。
channel_id         :チャンネルID
channel_no         :対応する物理チャンネル番号(例:東京タワーからのnhk総合なら27)
display_name       :EPGに書かれていた局名
transport_stream_id:トランスポートストリーム識別
original_network_id:オリジナルネットワーク識別
service_id         :サービス識別
insert_datetime    :この情報の追加日時
物理チャンネル、トランスポートストリーム識別、サービス識別の全てが等しいレコードが2件以上存在することは禁止する。
 */
CREATE TABLE `channel` (
  `channel_id` varchar(20) NOT NULL,
  `channel_no` int(11) NOT NULL,
  `display_name` text,
  `transport_stream_id` int NOT NULL,
  `original_network_id` int NOT NULL,
  `service_id` int NOT NULL,
  `insert_datetime` datetime NOT NULL,
  PRIMARY KEY (`channel_no`,`transport_stream_id`,`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* チャンネル一覧テーブルに内容を追加する。追加日時は自動入力する。
 */
DELIMITER //
CREATE PROCEDURE INSERT_CHANNEL(IN `_channel_id` VARCHAR(20),IN `_channel_no` int,IN `_display_name` text,IN `_transport_stream_id` int, IN `_original_network_id` int,IN `_service_id` int)
SQL SECURITY INVOKER
BEGIN
INSERT INTO `channel` (`channel_id`,`channel_no`,`display_name`,`transport_stream_id`,`original_network_id`,`service_id`,`insert_datetime`) VALUES (`_channel_id`,`_channel_no`,`_display_name`,`_transport_stream_id`,`_original_network_id`,`_service_id`,(SELECT NOW()));
END//
DELIMITER ;