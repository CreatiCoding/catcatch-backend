import { Controller, Get, Req, Res } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/')
  home(@Res() res): string {
    return res.redirect('/token');
  }
  @Get('token')
  token(@Res() res, @Req() req): string {
    const { type } = req.query;
    switch (type) {
      default:
      case 'google': {
        return res.redirect('/google/token');
      }
    }
  }
  @Get('redirect')
  redirect(@Res() res, @Req() req): string {
    const { type } = req.query;
    switch (type) {
      case 'google':
      default: {
        const params = Object.entries(req.query).map(
          ([key, value]) => `${key}=${value}`,
        );
        return res.redirect(`/google/redirect?${params.join('&')}`);
      }
    }
  }
}
