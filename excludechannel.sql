/*除外チャンネル判別テーブル。未加入の有料チャンネル等、検索から除外したいチャンネルを記録。
*channel_id_         :EPGに書かれていたチャンネルID
 */
CREATE TABLE `excludechannel` (
`channel_id` VARCHAR(20) NOT NULL,
PRIMARY KEY (`channel_id`),
FOREIGN KEY (`channel_id`) REFERENCES `channel` (`channel_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


/*テーブルに値を入力*/
INSERT INTO `paidBroadcasting`(`channel_id`,`isPaidBroadcasting`)VALUES(ChannelID);
