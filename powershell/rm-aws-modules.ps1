$awsmodules = @(
  'AWS.Tools.AutoScaling'
  'AWS.Tools.CloudFormation'
  'AWS.Tools.CloudWatchLogs'
  'AWS.Tools.EC2'
  'AWS.Tools.Elasticsearch'
  'AWS.Tools.IdentityManagement'
  'AWS.Tools.Lambda'
  'AWS.Tools.RDS'
  'AWS.Tools.Route53'
  'AWS.Tools.S3'
  'AWS.Tools.SecretsManager'
  'AWS.Tools.SecurityToken'
  'AWSLambdaPSCore'
)

foreach ($mod in $awsmodules) {
  Uninstall-Module -ModuleInfo $mod -Force
 }