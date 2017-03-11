/*
視聴可能チャンネル一覧ビュー。チャンネルID、物理チャンネル番号、放送局名を表示する。除外設定されたチャンネルは表示しない。
 */
CREATE SQL SECURITY INVOKER VIEW useablechannel AS select* from channel 
WHERE not exists (select * from excludechannel where excludechannel.channel_id=channel.channel_id);
