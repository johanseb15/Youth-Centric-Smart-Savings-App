import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from '../entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private usersRepository: Repository<UserEntity>,
  ) {}

  async findByEmail(email: string): Promise<UserEntity | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async findById(id: string): Promise<UserEntity | null> {
    return this.usersRepository.findOne({ where: { id } });
  }

  async create(email: string, username: string, passwordHash: string): Promise<UserEntity> {
    const user = this.usersRepository.create({ email, username, passwordHash });
    return this.usersRepository.save(user);
  }

  async increment

StreakCount(userId: string): Promise<void> {
    await this.usersRepository.increment({ id: userId }, 'streakCount', 1);
  }

  async addSavings(userId: string, amount: number): Promise<void> {
    const user = await this.findById(userId);
    if (user) {
      await this.usersRepository.update(
        { id: userId },
        { totalSaved: (Number(user.totalSaved) + amount).toString() },
      );
    }
  }
}
