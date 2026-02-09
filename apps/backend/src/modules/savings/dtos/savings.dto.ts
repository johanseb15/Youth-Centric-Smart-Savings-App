import { IsDateString, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class CreateSavingsEntryDto {
  @IsNumber()
  @Min(0.01)
  amount!: number;

  @IsDateString()
  entryDate!: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  note?: string;
}

export class SavingsEntryResponseDto {
  id!: string;
  amount!: string;
  entryDate!: string;
  note!: string | null;
}
