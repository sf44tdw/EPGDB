/*除外チャンネル判別テーブル。未加入の有料チャンネル等、検索から除外したいチャンネルを記録。
*CHANNEL_ID_         :EPGに書かれていたチャンネルID
*チャンネルテーブル更新の影響を受けさせないため、参照制約は設けない。
*トリガを使用する。
*/
CREATE TABLE `EXCLUDECHANNEL` (
`CHANNEL_ID` VARCHAR(20) NOT NULL,
PRIMARY KEY (`CHANNEL_ID`)
) ENGINE=INNODB  DEFAULT CHARSET=UTF8;