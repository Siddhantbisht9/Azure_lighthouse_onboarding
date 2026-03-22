# Script to onboard customer to Azure Lighthouse
$managingTenantId = "Org root level tenant-ID"
$delegatedTenantId = "customer to onboard tenant-id"
$delegatedSubscriptionId = "customer subscription-id"
$offerName = "MyLighthouseOffer"
$offerDescription = "Lighthouse onboarding for support"
$authorization = @(
    @{
        principalId = "give the object id of the app registration, group or user"
        roleDefinitionId = (Get-AzRoleDefinition "Contributor").Id
        principalIdDisplayName = "MSP Contributor Access"     #can be changed as per the access required
    }
)

# Create Managed Services Definition
$managedServiceDefinition = @{
    Name = $offerName
    Description = $offerDescription
    Authorizations = $authorization
    ManagedByTenantId = $managingTenantId
}

# Create the Lighthouse delegation
New-AzManagedServicesDefinition `
    -Name $offerName `
    -ManagedByTenantId $managedServiceDefinition.ManagedByTenantId `
    -Authorizations $managedServiceDefinition.Authorizations `
    -Description $managedServiceDefinition.Description `
    -Scope "/subscriptions/$delegatedSubscriptionId"

Write-Host "Lighthouse delegation successfully created!"
