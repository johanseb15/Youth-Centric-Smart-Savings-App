import { Controller, Get, NotFoundException, Request, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { UserResponseDto } from './dtos/user.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

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
}
