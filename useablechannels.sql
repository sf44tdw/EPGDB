/*
�����\�`�����l���ꗗ�r���[�B�`�����l���ԍ��ƕ����ǖ���\������B�����s�\�Ɛݒ肳�ꂽ�`�����l���͕\�����Ȃ�
 */
CREATE SQL SECURITY INVOKER VIEW useablechannels AS SELECT * FROM channel WHERE not exists (select * from paidBroadcasting where paidBroadcasting.channel_id=channel.channel_id);
