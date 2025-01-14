FROM node:14-alpine
WORKDIR /app


COPY .yarn .yarn
COPY src src
COPY .pnp.cjs .pnp.cjs
COPY .yarnrc.yml .yarnrc.yml
COPY nest-cli.json nest-cli.json
COPY package.json package.json
COPY tsconfig.build.json tsconfig.build.json
COPY tsconfig.json tsconfig.json
COPY yarn.lock yarn.lock

ARG GOOGLE_OAUTH_CLIENT_ID
ENV GOOGLE_OAUTH_CLIENT_ID=$GOOGLE_OAUTH_CLIENT_ID

ARG GOOGLE_OAUTH_CLIENT_SECRET
ENV GOOGLE_OAUTH_CLIENT_SECRET=$GOOGLE_OAUTH_CLIENT_SECRET

ARG GOOGLE_OAUTH_REDIRECT_URI
ENV GOOGLE_OAUTH_REDIRECT_URI=$GOOGLE_OAUTH_REDIRECT_URI

ARG GOOGLE_OAUTH_DEFAULT_SCOPE
ENV GOOGLE_OAUTH_DEFAULT_SCOPE=$GOOGLE_OAUTH_DEFAULT_SCOPE

RUN yarn install
RUN yarn build
CMD ["yarn", "start:prod"]

# docker build -t catcatch/backend --build-arg GOOGLE_OAUTH_CLIENT_ID=$GOOGLE_OAUTH_CLIENT_ID   --build-arg GOOGLE_OAUTH_CLIENT_SECRET=$GOOGLE_OAUTH_CLIENT_SECRET   --build-arg GOOGLE_OAUTH_REDIRECT_URI=$GOOGLE_OAUTH_REDIRECT_URI   --build-arg GOOGLE_OAUTH_DEFAULT_SCOPE=$GOOGLE_OAUTH_DEFAULT_SCOPE .
# docker run -p 3000:3000 -it catcatch/backend:latest