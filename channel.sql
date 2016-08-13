/* チャンネル一覧テーブル。チャンネルの読み替え用。
id                 :主キー。自動で生成され、加算される。
channel_id         :チャンネルID
channel_no         :対応する物理チャンネル番号(例:東京タワーからのnhk総合なら27)
display_name       :局名
transport_stream_id:トランスポートストリーム識別
original_network_id:オリジナルネットワーク識別
service_id         :サービス識別
insert_datetime    :この情報の追加日時(追加プロシージャで現在の時刻を自動入力する。)

オリジナルネットワーク識別、トランスポートストリーム識別、サービス識別の全てが等しいレコードが2件以上存在することは禁止する。
上記3つの項目には複合インデックスを張る。
(物理チャンネルだけ違う場合については、地域の違いでそうなる場合もあるので許容する。ただしその場合に番組がまともに検索できるかどうかは知らない。)
 */
CREATE TABLE `channel` (
  `id`                     bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id`             varchar(20)         NOT NULL,
  `channel_no`             int                 NOT NULL,
  `display_name` 　　　　　　　　　　text　　　　　　　　　　　　　　　　　　　　　　　　,
  `transport_stream_id`    int                 NOT NULL,
  `original_network_id`    int                 NOT NULL,
  `service_id`             int                 NOT NULL,
  `insert_datetime`        datetime            NOT NULL,
  PRIMARY KEY                                   (`id`),
  UNIQUE KEY               `channel_unique_key` (`transport_stream_id`,`original_network_id`,`service_id`),
  INDEX                    `channel_index`      (`transport_stream_id`,`original_network_id`,`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* チャンネル一覧テーブルに内容を追加する。idと追加日時は自動入力する。
 */
DELIMITER //
CREATE PROCEDURE INSERT_CHANNEL(IN `_channel_id` VARCHAR(20),IN `_channel_no` int,IN `_display_name` text,IN `_transport_stream_id` int, IN `_original_network_id` int,IN `_service_id` int)
SQL SECURITY INVOKER
BEGIN
INSERT INTO `channel` (`channel_id`,`channel_no`,`display_name`,`transport_stream_id`,`original_network_id`,`service_id`,`insert_datetime`) VALUES (`_channel_id`,`_channel_no`,`_display_name`,`_transport_stream_id`,`_original_network_id`,`_service_id`,(SELECT NOW()));
END//
DELIMITER ;

/*テスト用 上の4つは追加できて、最後の1個だけ失敗する*/
call INSERT_CHANNEL("cid1",10,"disp1",100,100,20);
call INSERT_CHANNEL("cid1",10,"disp2",100,100,21);
call INSERT_CHANNEL("cid1",10,"disp3",101,100,20);
call INSERT_CHANNEL("cid1",10,"disp4",100,101,20);
/*オリジナルネットワーク識別、トランスポートストリーム識別、サービス識別の全てが1個めとダブっているのでエラーになる*/
call INSERT_CHANNEL("cid2",10,"disp2",100,100,20);