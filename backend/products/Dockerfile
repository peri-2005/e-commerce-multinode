# --- Build Stage ---
FROM node:20-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
# If TypeScript or build step is required: RUN npm run build

# --- Production Stage ---
FROM node:20-alpine AS runner
WORKDIR /usr/src/app
ENV NODE_ENV=production

# Copy only production dependencies and built artifacts
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /usr/src/app ./

USER node
EXPOSE 3000
CMD ["node", "server.js"]
