import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'goals' })
export class GoalEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 150 })
  title!: string;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  targetAmount!: string;

  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
  currentAmount!: string;

  @Column({ type: 'date' })
  deadline!: string;

  @Column({ type: 'varchar', length: 500 })
  imageUrl!: string;
}
