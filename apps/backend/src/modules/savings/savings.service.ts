import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, Repository } from 'typeorm';
import { CreateSavingsEntryDto } from './dtos/savings.dto';
import { SavingsEntryEntity } from './entities/savings-entry.entity';

@Injectable()
export class SavingsService {
  constructor(
    @InjectRepository(SavingsEntryEntity)
    private savingsRepository: Repository<SavingsEntryEntity>,
  ) {}

  async create(userId: string, dto: CreateSavingsEntryDto): Promise<SavingsEntryEntity> {
    const entry = this.savingsRepository.create({
      userId,
      amount: dto.amount.toFixed(2),
      entryDate: dto.entryDate,
      note: dto.note ?? null,
    });
    return this.savingsRepository.save(entry);
  }

  async findBetween(userId: string, from: string, to: string): Promise<SavingsEntryEntity[]> {
    return this.savingsRepository.find({
      where: { userId, entryDate: Between(from, to) },
      order: { entryDate: 'ASC' },
    });
  }
}
