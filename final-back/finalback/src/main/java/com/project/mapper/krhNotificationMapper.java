package com.project.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.project.model.Notification;

@Mapper
public interface krhNotificationMapper {
	// 알림 추가
    @Insert("INSERT INTO notifications (receiver_email, message, is_read, created_at, boardId) " +
            "VALUES (#{receiverEmail}, #{message}, false, now(), #{boardId})")
    void insertNotification(Notification notification);
}
