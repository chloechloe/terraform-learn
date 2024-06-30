terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.110.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "ff3de05d-5049-4835-8ade-393c974d9b1c"
  tenant_id = "db12c563-9194-4c3f-af2d-775ecac247d1"
  client_id = "38695bad-c79e-4f01-953c-f80a11faef28"
  client_secret = "PJw8Q~Hhf9j1QYKDornMxNVQPdvM6OIU3nONRbAU"
  features {
    
  }

}