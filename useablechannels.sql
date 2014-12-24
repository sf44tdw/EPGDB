/*
視聴可能チャンネル一覧ビュー。チャンネル番号と放送局名を表示する。視聴不可能と設定されたチャンネルは表示しない。
また、物理チャンネル番号が同じ局名については、チャンネルIDを昇順ソートしたときに先頭に来るものを優先する。
 */
CREATE SQL SECURITY INVOKER VIEW useablechannels AS select* from channel 
WHERE (channel_id,channel_no) IN(SELECT channel_id,MAX(channel_no) FROM channel GROUP BY channel_no) 
and not exists (select * from paidBroadcasting where paidBroadcasting.channel_id=channel.channel_id);
