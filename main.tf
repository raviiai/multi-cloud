##########################################################################
## AWS Cloud
##########################################################################

resource "aws_instance" "this" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = "t2.micro"
}

############################################################################
## Microsoft Azure
############################################################################

resource "azurerm_resource_group" "this" {
  name     = "my-rg"
  location = "westindia"
}

########## Azure Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
########## Azure Subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

####Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

######## Azure Virtaul Machine 

resource "azurerm_virtual_machine" "vm" {
    name = "azure-vm"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  vm_size = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.main.id]

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}
############################################################################
## Google Cloud
############################################################################

resource "google_compute_instance" "name" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}
