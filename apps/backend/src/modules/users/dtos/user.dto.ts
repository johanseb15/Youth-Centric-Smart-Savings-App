import { IsEmail, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(2)
  @MaxLength(150)
  username!: string;

  @IsString()
  @MinLength(8)
  password!: string;
}

export class LoginUserDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(8)
  password!: string;
}

export class UserResponseDto {
  id!: string;
  email!: string;
  username!: string;
  streakCount!: number;
  totalSaved!: string;
  profileImageUrl!: string | null;
  createdAt!: Date;
}

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(150)
  username?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  profileImageUrl?: string;
}
