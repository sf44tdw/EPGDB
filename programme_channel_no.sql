/*
物理チャンネル読み替え用ビュー。
 */
CREATE SQL SECURITY INVOKER VIEW programme_channel_no AS 
SELECT channel.channel_id,
channel.channel_no,
programme.event_id,
programme.title,
programme.start_datetime,
programme.stop_datetime FROM channel,programme
WHERE channel.channel_id=programme.channel_id;

/*
物理チャンネル読み替え用ビューから指定されたチャンネルの、指定時刻から1分以内に始まる番組の番組名を取得する。
*_channel_no         :物理チャンネル番号
*_start_datetime     :番組の開始時刻
 */
SELECT `title` FROM `programme_channel_no` WHERE channel_no = _channel_no and start_datetime BETWEEN _start_datetime AND DATE_ADD(_start_datetime, INTERVAL 1 


