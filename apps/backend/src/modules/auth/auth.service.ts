import { ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import jwt, { Secret, SignOptions } from 'jsonwebtoken';
import type { StringValue } from 'ms';
import { UsersService } from '../users/users.service';
import { LoginDto, RegisterDto, AuthResponseDto } from './dtos/auth.dto';

@Injectable()
export class AuthService {
  constructor(private usersService: UsersService) {}

  async register(registerDto: RegisterDto): Promise<AuthResponseDto> {
    const existingUser = await this.usersService.findByEmail(registerDto.email);
    if (existingUser) {
      throw new ConflictException('User already exists');
    }

    const passwordHash = await bcrypt.hash(registerDto.password, 10);
    const user = await this.usersService.create(
      registerDto.email,
      registerDto.username,
      passwordHash,
    );

    const token = this.generateToken(user.id, user.email);

    return {
      access_token: token,
      expires_in: 24 * 60 * 60,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    };
  }

  async login(loginDto: LoginDto): Promise<AuthResponseDto> {
    const user = await this.usersService.findByEmail(loginDto.email);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const token = this.generateToken(user.id, user.email);

    return {
      access_token: token,
      expires_in: 24 * 60 * 60,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    };
  }

  private generateToken(userId: string, email: string): string {
    const secret: Secret = process.env.JWT_SECRET || 'your_secret_key';
    const expiresInEnv = process.env.JWT_EXPIRES_IN;
    const expiresIn =
      expiresInEnv && /^\d+$/.test(expiresInEnv)
        ? Number(expiresInEnv)
        : ((expiresInEnv || '24h') as StringValue);
    const options: SignOptions = { expiresIn };
    return jwt.sign({ sub: userId, email }, secret, options);
  }

  verifyToken(token: string): any {
    const secret: Secret = process.env.JWT_SECRET || 'your_secret_key';
    return jwt.verify(token, secret);
  }
}
