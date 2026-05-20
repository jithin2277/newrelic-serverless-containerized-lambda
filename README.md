# newrelic-serverless-containerized-lambda

Containerized AWS Lambda (Node.js / TypeScript) with **New Relic** instrumentation, deployed via **Serverless Framework v4**.

## Project Structure

```
├── src/
│   └── handler.ts          # Lambda handler — returns Hello World JSON
├── Dockerfile               # Multi-stage build with New Relic layer
├── serverless.yml           # Serverless Framework v4 configuration
├── tsconfig.json            # TypeScript compiler options
├── .env.sample              # Sample environment variables
└── package.json             # Dependencies & scripts
```

## How It Works

1. **TypeScript** source is compiled to JavaScript during the Docker build.
2. The **New Relic Lambda layer** is copied into the container image from a pre-built ECR public image.
3. The `newrelic-lambda-wrapper.handler` CMD wraps the actual handler (`dist/handler.handler`), providing APM traces & logs automatically.
4. **Serverless Framework v4** builds the Docker image, pushes it to ECR, and provisions the Lambda + HTTP API Gateway endpoint.

## Prerequisites

| Requirement | Version |
|---|---|
| Node.js | ≥ 22 |
| Docker | Latest |
| Serverless Framework | 4.35.1 (needs serverless-license-key to deploy but should work with serverless v3 as well which is free, I kept it v4 since it is what we use in our org) |
| AWS CLI | v2 |
| AWS Account | Having one |

## Deployment

```bash
# AWS Login (use aws sso login or export the AWS access keys)

# Install dependencies
npm install

# Build the repo 
npm run build

# Copy and update the environment variables
cp .env.sample .env.dev

# Deploy to AWS
npm run deploy
```

## Environment Variables

Copy `.env.sample` to `.env.dev` and set the values before deploying.

| Name | Default | Description |
|---|---|---|
| `SERVERLESS_LICENSE_KEY` | — | Serverless Framework v4 license key |
| `NEW_RELIC_ACCOUNT_ID` | `0` | New Relic account ID |
| `NEW_RELIC_LICENSE_KEY` | `placeholder` | New Relic ingest license key |
| `LOG_LEVEL` | `info` | Application log level |

## API

| Method | Path | Description |
|---|---|---|
| `GET` | `/hello` | Returns a Hello World JSON response |

### Example Response

```json
{
  "message": "Hello World!",
  "timestamp": "2026-05-20T01:30:00.000Z"
}
```