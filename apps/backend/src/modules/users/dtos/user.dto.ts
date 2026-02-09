export class CreateUserDto {
  email!: string;
  username!: string;
  password!: string;
}

export class LoginUserDto {
  email!: string;
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
