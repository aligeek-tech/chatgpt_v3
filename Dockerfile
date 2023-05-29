# Base node image
FROM node:19-alpine AS base-orginal
WORKDIR /api
COPY /api/package*.json /api/
WORKDIR /client
COPY /client/package*.json /client/
WORKDIR /
COPY /package*.json /
RUN npm ci

# React client build
FROM base-orginal AS react-client-orginal
WORKDIR /client
COPY /client/ /client/
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm run build

# Node API setup
FROM base-orginal AS node-api-orginal
WORKDIR /api
COPY /api/ /api/
COPY --from=react-client-orginal /client/dist /client/dist
EXPOSE 3080
ENV HOST=0.0.0.0
CMD ["npm", "start"]