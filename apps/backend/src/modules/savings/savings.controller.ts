import { Body, Controller, Get, Query, Request, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CreateSavingsEntryDto, SavingsEntryResponseDto } from './dtos/savings.dto';
import { SavingsService } from './savings.service';

@Controller('savings')
@UseGuards(JwtAuthGuard)
export class SavingsController {
  constructor(private savingsService: SavingsService) {}

  @Post()
  async create(
    @Request() req: any,
    @Body() dto: CreateSavingsEntryDto,
  ): Promise<SavingsEntryResponseDto> {
    const entry = await this.savingsService.create(req.user.sub, dto);
    return {
      id: entry.id,
      amount: entry.amount,
      entryDate: entry.entryDate,
      note: entry.note,
    };
  }

  @Get()
  async findBetween(
    @Request() req: any,
    @Query('from') from?: string,
    @Query('to') to?: string,
  ): Promise<SavingsEntryResponseDto[]> {
    if (!from || !to) {
      return [];
    }
    const entries = await this.savingsService.findBetween(req.user.sub, from, to);
    return entries.map((entry) => ({
      id: entry.id,
      amount: entry.amount,
      entryDate: entry.entryDate,
      note: entry.note,
    }));
  }
}
