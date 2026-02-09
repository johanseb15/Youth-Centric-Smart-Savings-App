import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { UserEntity } from './modules/users/entities/user.entity';
import { GoalEntity } from './modules/goals/entities/goal.entity';
import { GoalsModule } from './modules/goals/goals.module';
import { HealthModule } from './modules/health/health.module';
import { SavingsEntryEntity } from './modules/savings/entities/savings-entry.entity';
import { SavingsModule } from './modules/savings/savings.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: '.env' }),
    TypeOrmModule.forRootAsync({
      useFactory: (): TypeOrmModuleOptions => {
        const dbType = process.env.DB_TYPE?.toLowerCase();
        if (dbType === 'postgres') {
          return {
            type: 'postgres',
            host: process.env.DB_HOST,
            port: Number(process.env.DB_PORT) || 5432,
            username: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            entities: [UserEntity, GoalEntity, SavingsEntryEntity],
            synchronize: true,
            logging: false,
          };
        }

        return {
          type: 'sqlite',
          database: process.env.DB_SQLITE_PATH || process.env.DB_NAME || 'namaa_dev.db',
          entities: [UserEntity, GoalEntity, SavingsEntryEntity],
          synchronize: true,
          logging: false,
        };
      },
    }),
    AuthModule,
    UsersModule,
    GoalsModule,
    SavingsModule,
    HealthModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
