/*有料チャンネル判別テーブル。加入しないと見られないチャンネルなのかどうかを入力する。
*このテーブルに登録されていないか、値がtrue(1)になっているチャンネルは視聴可能なものであるとして扱う
*channel_no_         :EPGに書かれていたチャンネルID
*isPaidBroadcastin g:有料ならtrue 無料か見られるならfalse
 */
CREATE TABLE `paidBroadcasting` (
`channel_id` VARCHAR(20) NOT NULL,
`isPaidBroadcasting` BOOLEAN NOT NULL,
PRIMARY KEY (`channel_id`),
FOREIGN KEY (`channel_id`) REFERENCES `channel` (`channel_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/*
*有料区分自動入力プロシージャ。
*有料放送のチャンネルだけ入力する。事前に一時テーブルにとろくs対チャンネル番号を入力しておく必要がある。
 */
DELIMITER //
CREATE PROCEDURE INSERT_PAIDBROADCASTING()
BEGIN
--変数リストの宣言
DECLARE ChannelID VARCHAR(20);
DECLARE ChannelNo int;

 -- ハンドラで利用する変数 v_done を宣言
DECLARE v_done INT DEFAULT 0;

--カーソルの宣言。一時テーブルから、見られない有料放送のチャンネルIDとチャンネル番号の重複のない一覧を取得。
DECLARE PBCs cursor FOR SELECT DISTINCT `channel_id`,`channel_no` FROM `channel` WHERE `channel_no`= (SELECT DISTINCT `channel_no` FROM `temp_PaidBroadcasting`);
 
 -- SQLステートが02000の場合にv_doneを1にするハンドラを宣言
DECLARE continue handler FOR sqlstate '02000' SET v_done = 1;

--カーソルを開く
OPEN PBCs;

--FETCH（行の取り出し）
FETCH PBCs INTO ChannelID,ChannelNo;

--LOOP
    while v_done != 1 do
    
    --テーブルに値を入力
    INSERT INTO `paidBroadcasting`(`channel_id`,`isPaidBroadcasting`)VALUES(ChannelID,TRUE);
    --FETCH（行の取り出し）
    FETCH PBCs INTO ChannelID,ChannelNo;
    END WHILE;

CLOSE PBCs;

--一時テーブルの内容を消去する。
DELETE FROM `temp_PaidBroadcasting`;

END//
DELIMITER ;
