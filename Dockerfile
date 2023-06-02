FROM node:18-alpine as base

ENV NODE_ENV production
ENV HOST 0.0.0.0
ENV PORT 1337
ENV APP_KEYS Okj6q16mo/5VNmUB/Jrx2A==,0dXmJAL909TLNfSTFHAbPw==,gfPbvD8yvQofpfnuBGHFdw==,9rOTre7YTUiagU5lrW/Hnw==
ENV API_TOKEN_SALT g8Rp/a4VmM6atepSOChsVw==
ENV ADMIN_JWT_SECRET dPlggnrCcijdYRCfo5G8jQ==
ENV TRANSFER_TOKEN_SALT sf2xTev7kS3KCSYxf281Qw==
ENV JWT_SECRET MnDgbnv775UhyGBJiXVxMA==

FROM base as dev_deps

RUN apk update
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev

WORKDIR app

COPY package*.json ./

RUN npm install

FROM base as prod_deps

RUN apk add --no-cache vips-dev

WORKDIR app

COPY package*.json ./

RUN npm install --omit=dev

FROM base as builder

WORKDIR app

COPY package*.json ./

COPY --from=dev_deps /app/node_modules ./node_modules

COPY . .

RUN npm run build

FROM base as production

WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 strapi

EXPOSE $PORT

COPY --from=prod_deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/.cache ./.cache
COPY ./public ./public
COPY ./database ./database

COPY package.json .

USER strapi

ENTRYPOINT ["npm", "run", "start"]
