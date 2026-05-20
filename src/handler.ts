import { APIGatewayProxyEvent, APIGatewayProxyResult, Context } from "aws-lambda";

/**
 * Simple Hello World Lambda handler.
 *
 * New Relic instrumentation is injected at the Docker image level via the
 * `newrelic-lambda-wrapper` entrypoint, so no additional code changes are
 * needed here.
 */
export const handler = async (
  event: APIGatewayProxyEvent,
  context: Context
): Promise<APIGatewayProxyResult> => {
  console.log("Hello World from Containerized Lambda!", {
    requestId: context.awsRequestId,
    functionName: context.functionName,
    stage: process.env.STAGE ?? "unknown",
  });

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: "Hello World!",
      timestamp: new Date().toISOString(),
    }),
  };
};
