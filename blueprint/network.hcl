// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "100.0.10.0/24"
}