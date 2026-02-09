import { Body, Controller, Get, NotFoundException, Patch, Request, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { UpdateUserDto, UserResponseDto } from './dtos/user.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { GoalsService } from '../goals/goals.service';
import { SavingsService } from '../savings/savings.service';

@Controller('users')
export class UsersController {
  constructor(
    private usersService: UsersService,
    private goalsService: GoalsService,
    private savingsService: SavingsService,
  ) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getProfile(@Request() req: any): Promise<UserResponseDto> {
    const user = await this.usersService.findById(req.user.sub);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return {
      id: user.id,
      email: user.email,
      username: user.username,
      streakCount: user.streakCount,
      totalSaved: user.totalSaved,
      profileImageUrl: user.profileImageUrl,
      createdAt: user.createdAt,
    };
  }

  @Patch('me')
  @UseGuards(JwtAuthGuard)
  async updateProfile(@Request() req: any, @Body() dto: UpdateUserDto): Promise<UserResponseDto> {
    const user = await this.usersService.updateProfile(req.user.sub, dto);
    return {
      id: user.id,
      email: user.email,
      username: user.username,
      streakCount: user.streakCount,
      totalSaved: user.totalSaved,
      profileImageUrl: user.profileImageUrl,
      createdAt: user.createdAt,
    };
  }

  @Get('me/summary')
  @UseGuards(JwtAuthGuard)
  async getSummary(@Request() req: any): Promise<{
    totalSaved: number;
    totalTarget: number;
    progressRatio: number;
    activeGoals: number;
    completedGoals: number;
    nextDeadline: string | null;
    streakCount: number;
    weeklyTotals: { date: string; amount: number }[];
  }> {
    const user = await this.usersService.findById(req.user.sub);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    const goals = await this.goalsService.findAll(req.user.sub);
    const totals = goals.reduce(
      (acc, goal) => {
        const target = Number(goal.targetAmount) || 0;
        const current = Number(goal.currentAmount) || 0;
        acc.totalTarget += target;
        acc.totalSaved += current;
        if (current >= target && target > 0) {
          acc.completed += 1;
        }
        if (goal.deadline) {
          const date = new Date(goal.deadline);
          if (!isNaN(date.getTime())) {
            if (!acc.nextDeadline || date < acc.nextDeadline) {
              acc.nextDeadline = date;
            }
          }
        }
        return acc;
      },
      { totalTarget: 0, totalSaved: 0, completed: 0, nextDeadline: null as Date | null },
    );

    const today = new Date();
    const days = Array.from({ length: 7 }, (_, i) => {
      const date = new Date(today);
      date.setDate(today.getDate() - (6 - i));
      return date;
    });
    const from = days[0].toISOString().split('T')[0];
    const to = days[6].toISOString().split('T')[0];
    const entries = await this.savingsService.findBetween(req.user.sub, from, to);
    const totalsByDate = new Map<string, number>();
    for (const entry of entries) {
      const date = entry.entryDate;
      const amount = Number(entry.amount) || 0;
      totalsByDate.set(date, (totalsByDate.get(date) || 0) + amount);
    }
    const weeklyTotals = days.map((date) => {
      const key = date.toISOString().split('T')[0];
      return { date: key, amount: totalsByDate.get(key) || 0 };
    });

    const progressRatio = totals.totalTarget
      ? totals.totalSaved / totals.totalTarget
      : 0;

    return {
      totalSaved: totals.totalSaved,
      totalTarget: totals.totalTarget,
      progressRatio,
      activeGoals: goals.length,
      completedGoals: totals.completed,
      nextDeadline: totals.nextDeadline ? totals.nextDeadline.toISOString().split('T')[0] : null,
      streakCount: user.streakCount,
      weeklyTotals,
    };
  }
}
