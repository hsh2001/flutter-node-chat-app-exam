import createConnection from './db/createConnection';
import startExpressServer from './express';

function onReadyServerHasError(error: Error) {
  console.log('-----------------');
  console.error(error);
  process.exit();
}

createConnection().then((db) => {
  console.clear();
  console.log('db connect success!');

  startExpressServer(db)
    .then(() => {
      console.log('express server start!');
    })
    .catch(onReadyServerHasError);
});
