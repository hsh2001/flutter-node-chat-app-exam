import createConnection from './db/createConnection';
import startExpressServer from './express';

createConnection().then(async (db) => {
  await Promise.all([
    startExpressServer(db).then(() => {
      console.log('express server start!');
    }),
  ]);
});
