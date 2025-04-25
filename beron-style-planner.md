===========================================
  GCP Lab Planner: Adding the appropriate tagging policies
===========================================

LINKS:

https://cloud.google.com/compute/docs/machine-resource

https://cloud.google.com/about/locations#europe

https://cloud.google.com/compute/docs/general-purpose-machines#e2_machine_types_table

https://github.com/DaeTheKnight/startup-script-template

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

https://cloud.google.com/compute/docs/general-purpose-machines#e2_machine_types_table

===========================================

STUDENT NAME: DaeTheKnight

DATE: 4/24/2025

======================
 1. Project Information
======================

GCP Project ID: dae-waf

===========================
 2. Subnet & Network Design
===========================

VPC Network Name: n-ark-survivors

Subnet Name: subnet-1-johannesburg

CIDR Range 10.214.10.0/24

Subnet Region: africa-south1

VMs: linux
___
Subnet Name: subnet-2-sao-paulo

CIDR Range 10.214.15.0/24

Subnet Region: southamerica-east1

VMs: linux & windows
___
Subnet Name: subnet-3-iowa

CIDR Range 10.214.20.0/24

Subnet Region: us-central1

VMs: linux & windows

=================================
 3. Instances
=================================

Instance 1 name: instance-1-johannesburg

Network tag: http-server-1

firewall: allow http traffic from the other two regions in this configuration

external ipv4: true #required for webpage to download required packages
______________________________________________________________________

Instance 2 name: instance-2-sao-paulo-1

Network tag: http-server-2

firewall: allow http traffic from the other sao paulo instance in this configuration only

external ipv4: true
______________________________________________________________________

Instance 2 name: instance-2-sao-paulo-2

Network tag: windows-server-2

firewall 1: allow rdp traffic from the anywhere
firewall 2: allow http traffic to the other sao paulo instance as well as the johannesburg instance

external ipv4: true
______________________________________________________________________

Instance 2 name: instance-3-iowa-1

Network tag: http-server-3

firewall: allow http traffic from the other iowa instance in this configuration only

external ipv4: true
______________________________________________________________________

Instance 2 name: instance-3-iowa-2

Network tag: windows-server-3

firewall 1: allow rdp traffic from the anywhere
firewall 2: allow http traffic to the other iowa instance as well as the johannesburg instance

external ipv4: true

=================================
 4. tagging policies
=================================

all tags: 
http-server-1
http-server-2
http-server-3
windows-server-2
windows-server-3

map:
from (0.0.0.0/0) to (windows-server-2 & windows-server-3)
from (windows-server-2 & windows-server-3) to (http-server-1)
from (windows-server-2) to (http-server-2)
from (windows-server-3) to (http-server-3)


==========================
 5. Firewall Rules Planning
==========================

▶ Firewall Rule to Allow port 80 to load balancer
---------------------------------

Name: allow-80-from-windows-to-johannesburg

Direction: INGRESS

Protocols/Ports: tcp/80

source_tags = ["windows-server-2", "windows-server-3"]
Target Tags: http-server-1

---------------------------------
Firewall Rule to Allow port 3389 to windows servers
---------------------------------

Name: allow-3389-from-anywhere-to-windows

Direction: INGRESS

Protocols/Ports: tcp/3389

source_ranges = ["0.0.0.0/0"]
target_tags   = ["windows-server-2", "windows-server-3"]

---------------------------------
Firewall Rule to Allow port 3389 to windows servers
---------------------------------

Name: allow-80-from-windows-to-sao-paulo

Direction: INGRESS

Protocols/Ports: tcp/3389

source_tags = ["windows-server-2"]
target_tags   = ["http-server-2"]

---------------------------------
Firewall Rule to Allow port 3389 to windows servers
---------------------------------

Name: allow-80-from-windows-to-iowa

Direction: INGRESS

Protocols/Ports: tcp/3389

source_tags = ["windows-server-3"]
target_tags   = ["http-server-3"]

==============================
 6. Expected Behavior Checklist
==============================

[ ] Can visit rdp servers from local machine?
[ ] Linux VM 1 is only accessible in Iowa?
[ ] Linux VM 2 is only accessible in Sao Paulo?
[ ] Third Linux VM, accessible in both Iowa and Sao Paulo?


======================
 7. Notes & Observations
======================
______________________________________________________
______________________________________________________
______________________________________________________
saopaulo
!s5&)J2{ssw+Mzu

iowa
3lK;l%2nld]ZK.O
