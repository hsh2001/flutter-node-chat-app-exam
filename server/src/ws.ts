import type { Server } from 'http';

import { Connection, MoreThan } from 'typeorm';
import WebSocket from 'ws';

import Chat from './db/entity/Chat';

interface WebSocketData {
  chatRoomId: number;
  lastChatId: number;
}

type WebSocketWithData = WebSocket & { data: WebSocketData };

export default async function startWebSocketServer({
  db,
  server,
}: {
  db: Connection;
  server: Server;
}): Promise<void> {
  const webSocketServer = new WebSocket.Server({ server });

  async function forEachClient(
    callback: (client: WebSocketWithData) => void | Promise<void>
  ) {
    await Promise.all(
      ([...webSocketServer.clients] as WebSocketWithData[]).map(callback)
    );
  }

  async function getLatestMessages({
    roomId,
    lastChatId,
  }: {
    roomId: number;
    lastChatId: number;
  }) {
    return await db.getRepository(Chat).find({
      where: {
        id: MoreThan(lastChatId),
        room: { id: roomId },
      },
      order: { id: 'DESC' },
      take: 10,
    });
  }

  webSocketServer.on('connection', (webSocket: WebSocketWithData) => {
    webSocket.data = {
      chatRoomId: 0,
      lastChatId: 0,
    };

    const interval = setInterval(async () => {
      const {
        readyState,
        OPEN,
        data: { chatRoomId, lastChatId },
      } = webSocket;

      if (readyState != OPEN || !chatRoomId) return;

      const chatLogs = await getLatestMessages({
        lastChatId,
        roomId: chatRoomId,
      });

      if (!chatLogs.length) return;

      const responseData = JSON.stringify({
        chatLogs,
        type: 'refresh-message',
      });

      webSocket.data.lastChatId = chatLogs[0].id;

      webSocket.send(responseData);
    }, 1000);

    webSocket.on('message', async (message) => {
      const { roomId, lastChatId } = JSON.parse(String(message));
      webSocket.data.chatRoomId = +roomId || 0;
      webSocket.data.lastChatId = lastChatId || 0;

      if (!webSocket.data.chatRoomId) return;

      const responseData = JSON.stringify({
        type: 'new-message',
        chatLogs: await getLatestMessages({ roomId, lastChatId }),
      });

      forEachClient((client) => {
        if (
          webSocket == client ||
          webSocket.data.chatRoomId != client.data.chatRoomId ||
          client.readyState != client.OPEN
        ) {
          return;
        }

        client.send(responseData);
      });
    });

    webSocket.on('close', () => {
      clearInterval(interval);
    });
  });
}
