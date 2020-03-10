#!groovy
import com.sunrun.util.ConfigurationDetails

sunrunGcpCfCd {
  requiredSystemTests = []
  integrationTestDir = '.'
  excludedEnvironments = ['devlocal','training','relcert','prd']
  serviceAccountOverride = true
  family = 'gs'
  projectId = 'gs-platform'
  environmentMap = 'gsPlatformMap.json'
  enableEnvMapFeature = true
  certificationEnvironment = 'majstg'
  yarnBuild = true
  buildNodeType = 'gcp-alpha'
  skipKibana = true
  appName = 'gs-cloudrun-cf'
  appDescription = 'Grid Service Cloud Run Cloud Functions'
  appTimeout = 3600
  appEntryPoint = 'main'
  cloudRunBuild = true
  enableYarnConfigOverride = true
  configurationDetails = [:]
  configurationDetails[ConfigurationDetails.SERVICE_OWNER] = ConfigurationDetails.ServiceOwners.DATAPLATFORM
}
