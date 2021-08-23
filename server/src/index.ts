import express from 'express';

import createConnection from './db/createConnection';
import Room from './db/entity/Room';

const app = express();

createConnection().then(async (db) => {
  const roomRepository = db.getRepository(Room);

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

  app.listen(3000, () => {
    console.clear();
    console.log('chat server started!');
  });
});
