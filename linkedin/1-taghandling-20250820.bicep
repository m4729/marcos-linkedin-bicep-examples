//  It is Important in Bicep, that we always work with Objects for Tags Setting, so additional tags can be set in the future, but how can we handle setting different tags on different resources and still only use one parameter? 



param tags object = {}

// Inherit Tags if not defined
var inheritTags = union(
  {
    CostCenter:   resourceGroup().tags.?CostCenter ?? ''
    Creator:      resourceGroup().tags.?Creator ?? ''
    CreationDate: resourceGroup().tags.?CreationDate ?? ''
    Description:  resourceGroup().tags.?Description ?? ''
  },
  tags
)

// Definition of Tags to be filtered from certain resources like Datadisk, NIC and OS Disk
var excludedTags = [
  'BackupRetention'
  'OperatingLevel'
  'UpdateManagement'
]

// Loop filters and applies new tags
var varFilteredTags = reduce(
  items(inheritTags), // tags to key pairs
  {}, // starting with a empty object                                           
  (result, current) => 
    contains(excludedTags, current.key) 
      ? result 
      : union(result, { '${current.key}': current.value }) // Otherwise, add the tag to the result
)
