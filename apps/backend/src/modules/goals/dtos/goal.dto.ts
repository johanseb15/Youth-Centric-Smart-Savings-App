import { IsDateString, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class CreateGoalDto {
  @IsString()
  @MaxLength(150)
  title!: string;

  @IsNumber()
  @Min(0)
  targetAmount!: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  currentAmount?: number;

  @IsDateString()
  deadline!: string;

  @IsString()
  @MaxLength(500)
  imageUrl!: string;
}

export class UpdateGoalDto {
  @IsOptional()
  @IsString()
  @MaxLength(150)
  title?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  targetAmount?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  currentAmount?: number;

  @IsOptional()
  @IsDateString()
  deadline?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  imageUrl?: string;
}

export class GoalResponseDto {
  id!: string;
  title!: string;
  targetAmount!: string;
  currentAmount!: string;
  deadline!: string;
  imageUrl!: string;
}
