// Important to use Variables for precalculating values and setting defaults. Also note the use of the fail() function.

var mergedVmConfigs = [for config in vmConfigs: {
  // Core properties - inherit from base config if not specified in individual config
  name: config.name

  rgName: vmBase.deploymentFlags.addSubDigits ? '${vmBase.prefix}-${config.name}-${last4subid}-${vmBase.suffix}-rg' : '${vmBase.prefix}-${config.name}-${vmBase.suffix}-rg'
  location: config.?location ?? vmBase.?location ?? fail('No location was provided for ${config.name}')
  adminUsername: config.?adminUsername ?? vmBase.?adminUsername ?? fail('No localadmin username was provided for ${config.name} set it in "vmBase.adminUsername" or "vmConfigs.adminUsername" ')
  adminPassword: config.?adminPassword ?? vmBase.?adminPassword ?? fail('No localadmin password was provided for ${config.name} set it in "vmBase.adminPassword" or "vmConfigs.adminPassword" ')
  network: config.?network ?? vmBase.?network ?? fail('No network configuration was provided for ${config.name} set it in "vmBase.network" or "vmConfigs.network" ')
  tags: union(vmBase.?tags ?? {}, config.?tags ?? {})
  subscriptionId: config.?subscriptionId ?? vmBase.?subscriptionId ?? subscription().subscriptionId
  backup: vmBase.deploymentFlags.backup ? config.?backup ?? fail('No backup configuration was provided for ${config.name} set it in "vmConfigs.backup"') : config.?backup ?? null
  
}]
