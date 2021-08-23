import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

import Room from './Room';

@Entity()
export default class Chat {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  nickname!: string;

  @ManyToOne(() => Room)
  room!: Room;

  @Column()
  content!: string;
}
