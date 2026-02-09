import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { GoalEntity } from './entities/goal.entity';
import { CreateGoalDto, UpdateGoalDto } from './dtos/goal.dto';

@Injectable()
export class GoalsService {
  constructor(
    @InjectRepository(GoalEntity)
    private goalsRepository: Repository<GoalEntity>,
  ) {}

  async create(userId: string, dto: CreateGoalDto): Promise<GoalEntity> {
    const goal = this.goalsRepository.create({
      userId,
      title: dto.title,
      targetAmount: dto.targetAmount.toFixed(2),
      currentAmount: (dto.currentAmount ?? 0).toFixed(2),
      deadline: dto.deadline,
      imageUrl: dto.imageUrl,
    });
    return this.goalsRepository.save(goal);
  }

  async findAll(userId: string): Promise<GoalEntity[]> {
    return this.goalsRepository.find({
      where: { userId },
      order: { deadline: 'ASC' },
    });
  }

  async findOne(userId: string, id: string): Promise<GoalEntity> {
    const goal = await this.goalsRepository.findOne({ where: { id, userId } });
    if (!goal) {
      throw new NotFoundException('Goal not found');
    }
    return goal;
  }

  async update(userId: string, id: string, dto: UpdateGoalDto): Promise<GoalEntity> {
    const goal = await this.findOne(userId, id);
    const merged = this.goalsRepository.merge(goal, {
      title: dto.title ?? goal.title,
      targetAmount:
        dto.targetAmount !== undefined ? dto.targetAmount.toFixed(2) : goal.targetAmount,
      currentAmount:
        dto.currentAmount !== undefined ? dto.currentAmount.toFixed(2) : goal.currentAmount,
      deadline: dto.deadline ?? goal.deadline,
      imageUrl: dto.imageUrl ?? goal.imageUrl,
    });
    return this.goalsRepository.save(merged);
  }

  async remove(userId: string, id: string): Promise<void> {
    const goal = await this.findOne(userId, id);
    await this.goalsRepository.remove(goal);
  }
}
