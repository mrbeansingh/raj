module "rg-name" {
  source   = "../Child_module/azurerm_resource_group"
  name     = "raj-rg"
  location = "eastus"

}

module "virtual_network" {
    depends_on = [ module.rg-name ]
  source              = "../Child_module/azurerm_virtual_network"
  vnet_name           = "rajvnet"
  location            = "eastus"
  resource_group_name = "raj-rg"
  address_space       = ["10.0.0.0/16"]

}

module "sub1" {
    depends_on = [ module.virtual_network ]
  source               = "../Child_module/azurerm_subnet"
  subnet_name          = "subnet-1"
  resource_group_name  = "raj-rg"
  virtual_network_name = "rajvnet"
  address_prefixes     = ["10.0.1.0/24"]

}
module "sub2" {
    depends_on = [ module.virtual_network ]
  source               = "../Child_module/azurerm_subnet"
  subnet_name          = "subnet-2"
  resource_group_name  = "raj-rg"
  virtual_network_name = "rajvnet"
  address_prefixes     = ["10.0.2.0/24"]

}

module "public_ip" {
    depends_on = [ module.rg-name ]
  source              = "../Child_module/azurerm_public_ip"
  pulic_ip_name       = "raj_pip"
  resource_group_name = "raj-rg"
  location            = "eastus"
  allocation_method   = "Static"
}
module "nic1" {
  source = "../Child_module/azurerm_nic"
  nic_name = "vm-nic1"
  location = "eastus"
  resource_group_name = "raj-rg"
  subnet_id = "/subscriptions/ed5642ce-2c53-45a5-8061-5ae9f495d9dc/resourceGroups/raj-rg/providers/Microsoft.Network/virtualNetworks/rajvnet/subnets/subnet-1"
  public_ip_address_id = "/subscriptions/ed5642ce-2c53-45a5-8061-5ae9f495d9dc/resourceGroups/raj-rg/providers/Microsoft.Network/publicIPAddresses/raj_pip"
}

module "vmlinux" {
  source = "../Child_module/azurerm_virtual_machine"
  vm_name = "raj-vm-linux"
  resource_group_name = "raj-rg"
  location = "eastus"
  admin_username = "Nemuadmin"
  admin_password = "Nemuuser@1234"
  network_interface_ids = ["/subscriptions/ed5642ce-2c53-45a5-8061-5ae9f495d9dc/resourceGroups/raj-rg/providers/Microsoft.Network/networkInterfaces/vm-nic1"]
  
}



