export type AmplifyDependentResourcesAttributes = {
  "analytics": {
    "skiblazer": {
      "Id": "string",
      "Region": "string",
      "appName": "string"
    }
  },
  "api": {
    "skiblazer": {
      "GraphQLAPIEndpointOutput": "string",
      "GraphQLAPIIdOutput": "string",
      "GraphQLAPIKeyOutput": "string"
    }
  },
  "auth": {
    "skiblazer8f0dae09": {
      "AppClientID": "string",
      "AppClientIDWeb": "string",
      "CreatedSNSRole": "string",
      "IdentityPoolId": "string",
      "IdentityPoolName": "string",
      "UserPoolArn": "string",
      "UserPoolId": "string",
      "UserPoolName": "string"
    },
    "userPoolGroups": {
      "skiblazerpoolGroupRole": "string"
    }
  },
  "function": {
    "skiblazer8f0dae09PostConfirmation": {
      "Arn": "string",
      "LambdaExecutionRole": "string",
      "LambdaExecutionRoleArn": "string",
      "Name": "string",
      "Region": "string"
    }
  },
  "storage": {
    "skiblazerstorage": {
      "BucketName": "string",
      "Region": "string"
    }
  }
}