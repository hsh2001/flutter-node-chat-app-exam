import { config as configDotEnv } from 'dotenv';
import * as typeorm from 'typeorm';

import Chat from './entity/Chat';
import Room from './entity/Room';

export default async function createConnection() {
  configDotEnv();
  return await typeorm.createConnection({
    type: 'mysql',
    host: process.env.DB_HOST,
    username: process.env.DB_USER,
    port: +(process.env.DB_PORT || 3306),
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    synchronize: true,
    entities: [Chat, Room],
  });
}
