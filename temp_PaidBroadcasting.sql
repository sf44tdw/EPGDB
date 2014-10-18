/*有料チャンネル判別テーブルへのデータ入力用テーブル。ここから判別テーブルに転記する。
channel_no  :物理チャンネル番号(例:東京タワーからのnhk総合なら27)
 */
CREATE TABLE `temp_PaidBroadcasting` (
`channel_no` int NOT NULL,
PRIMARY KEY (`channel_no`)
) ENGINE=InnoDB; 

/*
有料チャンネル判別テーブルへのデータ入力用テーブルに内容を追加する。
 */
DELIMITER//
CREATE PROCEDURE INSERT_temp_PaidBroadcasting(IN `_channel_no` int)
BEGIN
INSERT INTO `temp_PaidBroadcasting` (`channel_no`) VALUES (`_channel_no`);
END//
DELIMITER ;