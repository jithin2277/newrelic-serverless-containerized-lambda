# newrelic-serverless-containerized-lambda

Containerized AWS Lambda (Node.js / TypeScript) with **New Relic** instrumentation, deployed via **Serverless Framework v4** and **GitHub Actions**.

## Project Structure

```
├── src/
│   └── handler.ts          # Lambda handler — logs "Hello World"
├── Dockerfile               # Multi-stage build with New Relic layer
├── serverless.yml           # Serverless Framework v4 configuration
├── tsconfig.json            # TypeScript compiler options
├── package.json             # Dependencies & scripts
└── .github/
    └── workflows/
        └── deploy.yml       # CI/CD pipeline (GitHub Actions → AWS)
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
| Serverless Framework | ~4 |
| AWS CLI | v2 |

## Local Development

```bash
# Install dependencies
npm install

# Compile TypeScript
npm run build

# Deploy to dev
export SERVERLESS_LICENSE_KEY=<your-key>
npx serverless deploy --stage dev
```

## GitHub Actions Deployment

The workflow at `.github/workflows/deploy.yml`:

- **Auto-deploys** to `dev` on every push to `main`.
- **Manual dispatch** allows deploying to `dev`, `staging`, or `prod`.

### Required Secrets & Variables

| Name | Type | Description |
|---|---|---|
| `SERVERLESS_LICENSE_KEY` | Secret | Serverless Framework v4 license key |
| `AWS_DEPLOY_ROLE` | Variable | IAM role ARN for OIDC-based AWS authentication |

### Optional Environment Variables

| Name | Default | Description |
|---|---|---|
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