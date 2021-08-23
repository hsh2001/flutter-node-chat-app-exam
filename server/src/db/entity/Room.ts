import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export default class Room {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  name!: string;
}
