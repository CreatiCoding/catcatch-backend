import { Injectable } from '@nestjs/common';
import { google } from 'googleapis';
import { getCredential } from 'src/credentials/google';
import axios from 'axios';

@Injectable()
export class GoogleService {
  getHello(): string {
    return "Hello World! It's google!";
  }
  getRedirectUrl(): string {
    const oauth2Client = new google.auth.OAuth2(getCredential('google'));
    const url = oauth2Client.generateAuthUrl({
      scope: [process.env.GOOGLE_OAUTH_DEFAULT_SCOPE],
    });
    return url;
  }
  async getAaccessToken({ code }: { code: string }): Promise<any> {
    const credential = getCredential('google');
    const { data } = await axios.post('https://oauth2.googleapis.com/token', {
      code,
      client_id: credential.clientId,
      client_secret: credential.clientSecret,
      redirect_uri: credential.redirectUri,
      grant_type: 'authorization_code',
    });
    console.log('getAaccessToken', { data });
    return data;
  }
  async getUserInfo({ accessToken }: { accessToken: string }): Promise<any> {
    const { data } = await axios.get(
      'https://www.googleapis.com/oauth2/v1/userinfo?alt=json',
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      },
    );
    return data;
  }
}
