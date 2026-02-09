import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'users' })
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 150, unique: true })
  email!: string;

  @Column({ length: 150 })
  username!: string;

  @Column()
  passwordHash!: string;

  @Column({ type: 'int', default: 0 })
  streakCount!: number;

  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
  totalSaved!: string;

  @Column({ type: 'varchar', nullable: true })
  profileImageUrl!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
