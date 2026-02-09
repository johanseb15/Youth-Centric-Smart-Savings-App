import { Body, Controller, Delete, Get, Param, Patch, Post, Request, UseGuards } from '@nestjs/common';
import { GoalsService } from './goals.service';
import { CreateGoalDto, GoalResponseDto, UpdateGoalDto } from './dtos/goal.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@Controller('goals')
@UseGuards(JwtAuthGuard)
export class GoalsController {
  constructor(private goalsService: GoalsService) {}

  @Post()
  async create(@Request() req: any, @Body() dto: CreateGoalDto): Promise<GoalResponseDto> {
    const goal = await this.goalsService.create(req.user.sub, dto);
    return this.toResponse(goal);
  }

  @Get()
  async findAll(@Request() req: any): Promise<GoalResponseDto[]> {
    const goals = await this.goalsService.findAll(req.user.sub);
    return goals.map((goal) => this.toResponse(goal));
  }

  @Get(':id')
  async findOne(@Request() req: any, @Param('id') id: string): Promise<GoalResponseDto> {
    const goal = await this.goalsService.findOne(req.user.sub, id);
    return this.toResponse(goal);
  }

  @Patch(':id')
  async update(
    @Request() req: any,
    @Param('id') id: string,
    @Body() dto: UpdateGoalDto,
  ): Promise<GoalResponseDto> {
    const goal = await this.goalsService.update(req.user.sub, id, dto);
    return this.toResponse(goal);
  }

  @Delete(':id')
  async remove(@Request() req: any, @Param('id') id: string): Promise<{ success: true }> {
    await this.goalsService.remove(req.user.sub, id);
    return { success: true };
  }

  private toResponse(goal: {
    id: string;
    title: string;
    targetAmount: string;
    currentAmount: string;
    deadline: string;
    imageUrl: string;
  }): GoalResponseDto {
    return {
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      deadline: goal.deadline,
      imageUrl: goal.imageUrl,
    };
  }
}
