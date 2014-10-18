/*
物理チャンネル読み替え用ビュー。情報の確認だけならこれだけで用が足りるはず。有料放送をはじめとして、視聴不可能と設定されたチャンネルは表示しない
 */
CREATE SQL SECURITY INVOKER VIEW programme_channel_no AS 
SELECT channel.channel_id,
channel.channel_no,
programme.title,
programme.start_datetime,
programme.stop_datetime FROM channel,programme
WHERE channel.channel_id=programme.channel_id and not exists (select * from paidBroadcasting where paidBroadcasting.channel_id=channel.channel_id);