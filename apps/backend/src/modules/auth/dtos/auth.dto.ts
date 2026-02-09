export class RegisterDto {
  email!: string;
  username!: string;
  password!: string;
}

export class LoginDto {
  email!: string;
  password!: string;
}

export class AuthResponseDto {
  access_token!: string;
  expires_in!: number;
  user!: {
    id: string;
    email: string;
    username: string;
  };
}
