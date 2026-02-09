import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { GoalsModule } from '../goals/goals.module';
import { SavingsModule } from '../savings/savings.module';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity]), GoalsModule, SavingsModule],
  providers: [UsersService],
  controllers: [UsersController],
  exports: [UsersService],
})
export class UsersModule {}
