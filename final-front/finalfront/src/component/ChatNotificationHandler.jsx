import { useEffect } from "react";
//import stompClient from "../utils/websocket"; // stompClient 경로에 맞게 조정
import { connectWebSocket, disconnectWebSocket } from "../utils/websocket";
import { toast } from 'react-toastify';

const ChatNotificationHandler = () => {
  useEffect(() => {
    const client = connectWebSocket();
    if (!client) return;

    // 연결 성공 시 subscribe
    client.onConnect = () => {
      client.subscribe("/topic/notify/chat", (message) => {
        const data = JSON.parse(message.body);
        toast.info(`[채팅 알림] ${data.senderName || "상대방"}: ${data.message}`);
      });
    };

    return () => {
      disconnectWebSocket();
    };
  }, []);

  return null;
};

export default ChatNotificationHandler;