import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto, UserResponseDto } from './dtos/user.dto';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  async getProfile(@Request() req: any): Promise<UserResponseDto> {
    const user = await this.usersService.findById(req.user.id);
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
}
