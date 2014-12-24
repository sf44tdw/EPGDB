/*
視聴可能チャンネル一覧ビュー。チャンネル番号と放送局名を表示する。視聴不可能と設定されたチャンネルは表示しない
 */
CREATE SQL SECURITY INVOKER VIEW useablechannels AS SELECT * FROM channel WHERE not exists (select * from paidBroadcasting where paidBroadcasting.channel_id=channel.channel_id);
