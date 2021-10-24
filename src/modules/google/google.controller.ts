import { Controller, Get, Req, Res } from '@nestjs/common';
import { GoogleService } from './google.service';

@Controller('google')
export class GoogleController {
  constructor(private readonly googleService: GoogleService) {}

  @Get('/')
  home(@Res() res): string {
    return res.redirect('/token');
  }

  @Get('token')
  getToken(@Res() res): string {
    return res.redirect(this.googleService.getRedirectUrl());
  }

  @Get('redirect')
  async redirect(@Req() req): Promise<string> {
    const { access_token: accessToken } =
      await this.googleService.getAaccessToken({
        code: req.query?.code,
      });
    const data = await this.googleService.getUserInfo({ accessToken });
    return JSON.stringify({ data, accessToken });
  }
}
