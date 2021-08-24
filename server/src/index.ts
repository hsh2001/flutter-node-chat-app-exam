import createConnection from './db/createConnection';
import startExpressServer from './express';
import startWebSocketServer from './ws';

createConnection().then(async (db) => {
  console.clear();
  console.log('db connect success!');

  try {
    const server = await startExpressServer(db);
    console.log('express server start!');
    await startWebSocketServer({ db, server });
    console.log('ws server start!');
  } catch (error) {
    console.log('-----------------');
    console.error(error);
    process.exit();
  }
});
