resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.custom-test.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_service_account" "default" {
  account_id   = "white-byway-349416"
  display_name = "Service Account"
}

resource "google_compute_instance" "instance-apigee-network" {
  name                      = "instance-apigee-network"
  machine_type              = "e2-medium"
  zone                      = "europe-west2-a"
  allow_stopping_for_update = true
  desired_status            = "RUNNING"

  tags = ["tuvieja", "entanga"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
  }
}

#------------------------------------------------------------------------------------------------

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-090fa75af13c156b4" # us-west-2
  instance_type = "t2.micro"
  
  tags = {
    Name = "HelloWorld"
  }

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
