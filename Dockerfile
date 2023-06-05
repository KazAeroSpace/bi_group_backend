FROM node:18-alpine as base

ENV NODE_ENV production
ENV HOST 0.0.0.0
ENV PORT 1337
ENV APP_KEYS Okj6q16mo/5VNmUB/Jrx2A==,0dXmJAL909TLNfSTFHAbPw==,gfPbvD8yvQofpfnuBGHFdw==,9rOTre7YTUiagU5lrW/Hnw==
ENV API_TOKEN_SALT g8Rp/a4VmM6atepSOChsVw==
ENV ADMIN_JWT_SECRET dPlggnrCcijdYRCfo5G8jQ==
ENV TRANSFER_TOKEN_SALT sf2xTev7kS3KCSYxf281Qw==
ENV JWT_SECRET MnDgbnv775UhyGBJiXVxMA==

FROM base as builder

RUN apk update
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev

WORKDIR /opt
COPY package*.json ./
RUN npm install
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN npm run build

FROM base as production

RUN apk add --no-cache vips-dev
RUN npm install pm2 -g
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 strapi

USER strapi

WORKDIR /app

EXPOSE $PORT

COPY --chown=strapi:strapi --from=builder /opt/app ./

RUN npm install --omit=dev

ENTRYPOINT ["pm2-runtime", "start", "npm", "--name", "app", "--", "run", "start"]
