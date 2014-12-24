/*
物理チャンネル読み替え用ビュー。情報の確認だけならこれだけで用が足りるはず。有料放送をはじめとして、視聴不可能と設定されたチャンネルは表示しない
 */
CREATE SQL SECURITY INVOKER VIEW programme_channel_no AS 
SELECT channel.channel_id,
channel.channel_no,
programme.event_id,
programme.title,
programme.start_datetime,
programme.stop_datetime FROM channel,programme
WHERE channel.channel_id=programme.channel_id and not exists (select * from paidBroadcasting where paidBroadcasting.channel_id=channel.channel_id);

/*
物理チャンネル読み替え用ビューから指定されたチャンネルの、指定時刻から1分以内に始まる番組の番組名を取得する。
*_channel_no         :物理チャンネル番号
*_start_datetime     :番組の開始時刻
 */
DELIMITER //
CREATE PROCEDURE GET_TITLE(IN `_channel_no` int,IN `_start_datetime` DATETIME)
BEGIN
SELECT `title` FROM `programme_channel_no` WHERE channel_no = _channel_no and start_datetime BETWEEN _start_datetime AND DATE_ADD(_start_datetime, INTERVAL 1 MINUTE);
END//
DELIMITER ;

/*
物理チャンネル読み替え用ビューから指定されたチャンネルの、指定時刻から180分以内に始まる番組情報を取得する。
*_channel_no         :物理チャンネル番号
*_start_datetime     :放送開始時刻の検索範囲の始点となる時刻
 */
DELIMITER //
CREATE PROCEDURE GET_PROGRAMMES_AFTER_3_HOUR(IN `_channel_no` int,IN `_start_datetime` DATETIME)
BEGIN
SELECT * FROM `programme_channel_no` WHERE channel_no = _channel_no and start_datetime BETWEEN  _start_datetime AND DATE_ADD(_start_datetime, INTERVAL 3 HOUR);
END//
DELIMITER ;