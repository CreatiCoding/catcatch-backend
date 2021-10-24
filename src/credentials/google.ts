import { OAuth2ClientOptions } from 'google-auth-library';

export const getCredential = (type: string): OAuth2ClientOptions => {
  switch (type) {
    case 'google': {
      const {
        GOOGLE_OAUTH_CLIENT_ID = '',
        GOOGLE_OAUTH_CLIENT_SECRET = '',
        GOOGLE_OAUTH_REDIRECT_URI = '',
      } = process.env;
      if (GOOGLE_OAUTH_CLIENT_ID == null) {
        throw new Error('GOOGLE_OAUTH_CLIENT_ID가 제공되지 않았습니다.');
      }
      if (GOOGLE_OAUTH_CLIENT_SECRET == null) {
        throw new Error('GOOGLE_OAUTH_CLIENT_SECRET가 제공되지 않았습니다.');
      }
      if (GOOGLE_OAUTH_REDIRECT_URI == null) {
        throw new Error('GOOGLE_OAUTH_REDIRECT_URL가 제공되지 않았습니다.');
      }
      return {
        clientId: GOOGLE_OAUTH_CLIENT_ID,
        clientSecret: GOOGLE_OAUTH_CLIENT_SECRET,
        redirectUri: GOOGLE_OAUTH_REDIRECT_URI,
      };
    }
    default: {
      throw new Error(`type is not valid(${type})`);
    }
  }
};
