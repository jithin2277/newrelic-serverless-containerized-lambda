# ── Stage 1: New Relic Lambda Layer ──────────────────────────────────────────
FROM public.ecr.aws/newrelic-lambda-layers-for-docker/newrelic-lambda-layers-nodejs:22 AS layer

# ── Stage 2: Build TypeScript ────────────────────────────────────────────────
FROM public.ecr.aws/lambda/nodejs:22 AS build

WORKDIR /build

COPY package.json package-lock.json* ./
RUN npm ci --ignore-scripts

COPY tsconfig.json ./
COPY src/ ./src/
RUN npx tsc

# ── Stage 3: Production image ───────────────────────────────────────────────
FROM public.ecr.aws/lambda/nodejs:22

# Copy New Relic Layer code
COPY --from=layer /opt/ /opt/

# Copy compiled JS and production dependencies
COPY --from=build /build/dist/ ${LAMBDA_TASK_ROOT}/dist/
COPY --from=build /build/node_modules/ ${LAMBDA_TASK_ROOT}/node_modules/
COPY --from=build /build/package.json ${LAMBDA_TASK_ROOT}/

# CMD override to New Relic's handler wrapper
CMD [ "newrelic-lambda-wrapper.handler" ]
