
FROM node:17.0.1-alpine3.13 as base
WORKDIR /app
COPY package*.json ./
RUN npm install -g npm@8.1.3
RUN npm install
COPY . .

FROM base AS build
ENV NODE_ENV = production
WORKDIR /build
COPY --from=base /app ./
RUN npm run build

FROM node:17.0.1-alpine3.13 as production
ENV NODE_ENV = production
WORKDIR /app
COPY --from=build /build/package*.json ./
COPY --from=build /build/.next ./.next
COPY --from=build /build/public ./public
RUN npm install next

EXPOSE 3000
CMD ["npm", "run", "start"]