// 📁 utils/websocket.js
import { Client } from '@stomp/stompjs';

let stompClient = null;

export const connectWebSocket = (onConnectCallback) => {
  const token = localStorage.getItem('token');
  if (!token) return null;

  stompClient = new Client({
    brokerURL: `ws://localhost:8080/ws?token=${token}`,
    reconnectDelay: 5000,
    debug: (str) => console.log('[STOMP DEBUG]:', str),
    onStompError: (frame) => console.error('❌ STOMP 오류:', frame),
    onWebSocketError: (e) => console.error('❌ WebSocket 오류:', e),
    onConnect: () => {
      console.log('✅ WebSocket 연결 완료');
      if (onConnectCallback) onConnectCallback(stompClient);
    }
  });

  stompClient.activate();
  return stompClient;
};

export const disconnectWebSocket = () => {
  if (stompClient) {
    stompClient.deactivate();
    stompClient = null;
    console.log('✅ WebSocket 연결 해제 완료');
  }
};


// const token = localStorage.getItem('token');



// const stompClient = new Client({
//   brokerURL: `ws://localhost:8080/ws?token=${token}`, // ✅ 진짜 WebSocket 사용
//   reconnectDelay: 5000,
//   debug: (str) => console.log('[STOMP DEBUG]:', str),
//   onStompError: (frame) => console.error('❌ STOMP 오류 발생:', frame),
//   onWebSocketError: (e) => console.error('❌ WebSocket 오류 발생: ', e),
// });

// export default stompClient;