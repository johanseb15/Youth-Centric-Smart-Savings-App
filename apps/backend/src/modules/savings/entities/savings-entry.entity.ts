import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'savings_entries' })
export class SavingsEntryEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'uuid' })
  userId!: string;

  @Column({ type: 'uuid', nullable: true })
  goalId!: string | null;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  amount!: string;

  @Column({ type: 'date' })
  entryDate!: string;

  @Column({ type: 'varchar', length: 300, nullable: true })
  note!: string | null;
}
