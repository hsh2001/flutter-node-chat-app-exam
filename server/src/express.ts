import express from 'express';
import { Connection } from 'typeorm';

import Chat from './db/entity/Chat';
import Room from './db/entity/Room';

export default function startExpressServer(db: Connection): Promise<void> {
  const app = express();

  const roomRepository = db.getRepository(Room);
  const chatRepository = db.getRepository(Chat);

  app.get('/room/list', async (_, response) => {
    response.json(await roomRepository.find());
  });

  app.get('/room/:id', async (request, response) => {
    const id = +request.params.id || 0;
    const room = await roomRepository.findOne({ id });
    response.end(room?.name || '');
  });

  app.get('/room/create/:name', async (request, response) => {
    const { name } = request.params;

    const room = await roomRepository.save({
      name: `${name}${Math.random().toFixed(3).split('.')[1]}`,
    });

    response.end(room.name);
  });

  app.get('/message/send', async (request, response) => {
    const { nickname, content, roomId } = request.query as Record<
      string,
      string
    >;

    const room = new Room();
    room.id = +roomId || 0;

    const { id } = await chatRepository.save({
      nickname,
      content,
      room,
    });

    response.json(id);
  });

  app.get('/message/list/:roomId', async (request, response) => {
    const pageLength = 30;
    const roomId = +request.params.roomId || 0;
    const index = +(request.query.index || 0);
    const chatList = await chatRepository.find({
      take: pageLength,
      skip: index * pageLength,
      where: {
        room: { id: roomId },
      },
    });

    response.json(chatList);
  });

  return new Promise((resolve) => {
    app.listen(3000, () => resolve());
  });
}
