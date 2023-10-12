FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Compile Typescript
COPY tsconfig.json ./
COPY src ./src
RUN npm run build
RUN npm ci --omit=dev

FROM node:18-slim
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./

CMD ["node", "index.js"]
