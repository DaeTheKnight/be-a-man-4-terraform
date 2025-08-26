# GCP Multi‑Region VPC, Subnets, VM Instances, and Firewall (Terraform)

![Screenshot](Fantasy-Crystal-Castle-resized.png)

This Terraform configuration stands up a **custom VPC** with **three regional subnets** (Johannesburg, São Paulo, and Iowa), creates **virtual machines** attached to those subnets, and provisions **firewall rules** that allow HTTP (tcp/80) traffic between specific instance groups (by network tag). It also enables the required Google Cloud APIs for the project.

> This README is generated from the uploaded Terraform files (`main.tf`, `variables.tf`, `vpc.tf`, `subnets.tf`, `instances.tf`, `firewall.tf`, `terraform.tfvars`) as of 2025-08-26 12:19 UTC and is intended to describe *what the code is doing*, how to run it, and what to customize.

---

## High‑Level Architecture

```
               GCP Project: var.project

                 +---------------------------+
                 |        Custom VPC         |  name = var.vpc
                 |  (auto_create_subnetworks = false)
                 +---------------------------+
                     |           |           |
                     |           |           |
             +-------+--+   +----+------+   +----+------+
             | Subnet 1 |   | Subnet 2  |   | Subnet 3  |
             | africa-   |   | southamerica-| | us-central1 |
             | south1    |   | east1       | | (Iowa)      |
             | 10.214.10.0/24 | 10.214.15.0/24 | 10.214.20.0/24
             +-------+--+   +----+------+   +----+------+
                     |           |               |
               VM in ZA     VM in BR        VM in US
             (tags likely   (tags likely    (tags likely
             http/windows)  http/windows)   http/windows)

Firewall rules allow tcp/80 from “windows-server-*” tagged VMs to “http-server-*” tagged VMs, per region.
```

---

## What the Terraform Code Creates

### 1) Provider & API Enablement (`main.tf`)
- **Google provider** configured with `var.project`.
- **Project Services** are enabled (kept on destroy):
  - `compute.googleapis.com`
  - `logging.googleapis.com`
  - `monitoring.googleapis.com`
  - `storage.googleapis.com`

### 2) Inputs (`variables.tf` / `terraform.tfvars`)
- `project` *(string)*: GCP Project ID (e.g., `dae-waf`).
- `vpc` *(string)*: VPC network name (e.g., `n-ark-survivors`).

> Initial values are supplied in `terraform.tfvars`.

### 3) VPC (`vpc.tf`)
- **Custom VPC** resource with `auto_create_subnetworks = false`.
- Ensures a controlled, **manually subnetted** network layout.

### 4) Subnets (`subnets.tf`)
Creates **three regional subnets**, all attached to the custom VPC:
- **Johannesburg** (`africa-south1`) — `10.214.10.0/24`
- **São Paulo** (`southamerica-east1`) — `10.214.15.0/24`
- **Iowa** (`us-central1`) — `10.214.20.0/24`

Each subnetwork `depends_on` the VPC to guarantee proper creation order.

### 5) Compute Instances (`instances.tf`)
- Data sources fetch available zones for each region.
- **One VM per region** (by resource name):
  - `instance-1-johannesburg` → `africa-south1`
  - `instance-2-sao-paulo` → `southamerica-east1`
  - `instance-3-iowa` → `us-central1`
- All instances:
  - Use machine type **`e2-medium`** (per file names).
  - Attach a **`network_interface`** to the corresponding regional subnetwork.
  - Allocate an **external IP** via an `access_config` block.
  - Use the **default service account** with **`cloud-platform`** scope.
- **Tags** (implied by the firewall rules) are used to separate:
  - **HTTP servers**: likely tagged `http-server-1`, `http-server-2`, `http-server-3` (region‑specific).
  - **Windows clients**: likely tagged `windows-server-1`, `windows-server-2`, `windows-server-3`.
  
> Note: The uploaded `instances.tf` uses ellipses in places, so some fields (e.g., image, boot disk, exact `tags`) are **not fully visible**. The firewall file strongly suggests the tags above.

### 6) Firewall Rules (`firewall.tf`)
Creates **INGRESS** rules on the VPC to allow **tcp/80** (**HTTP**) **from VMs tagged `windows-server-*` to VMs tagged `http-server-*`**, per region. Example patterns (names abbreviated here):
- `allow-80-from-windows-to-johannesburg` → sources: `windows-server-2`, `windows-server-3` → targets: `http-server-1`
- `allow-80-from-windows-to-sao-paulo` → sources: `windows-server-1`, `windows-server-3` → targets: `http-server-2`
- `allow-80-from-windows-to-iowa` → sources: `windows-server-3` → targets: `http-server-3`

> All rules: `direction = "INGRESS"`, `priority = 1000`, `protocol = "tcp"`, `ports = ["80"]`.

---

## File Map

| File | Purpose |
|---|---|
| `main.tf` | Google provider config and required API enablement. |
| `variables.tf` | Declares input variables `project` and `vpc`. |
| `terraform.tfvars` | Supplies values for inputs (project & VPC name). |
| `vpc.tf` | Creates the custom VPC network. |
| `subnets.tf` | Defines three regional subnets and attaches them to the VPC. |
| `instances.tf` | Declares one VM per region, attaches them to the matching subnets, grants external IPs, sets SA scopes. |
| `firewall.tf` | Creates ingress rules allowing tcp/80 from “windows-server-*” to “http-server-*” by region. |

---

## Prerequisites

1. **Google Cloud CLI** installed and authenticated:
   ```bash
   gcloud auth application-default login
   ```
2. **Terraform** v1.x recommended.
3. A **GCP project** you can deploy to and **billing** enabled.

---

## How to Deploy

```bash
# 1) Initialize providers & backend
terraform init

# 2) See what will be created
terraform plan -var-file=terraform.tfvars

# 3) Apply the changes
terraform apply -var-file=terraform.tfvars
```

> To target a specific environment or change names/IDs, edit `terraform.tfvars` or pass `-var 'project=...' -var 'vpc=...'` on the CLI.

---

## Verifying the Deployment

- **APIs enabled**: In the GCP Console, under *APIs & Services → Enabled APIs*.
- **Network**: *VPC network → VPC networks* should show your custom VPC.
- **Subnets**: *VPC network → VPC networks → [your VPC] → Subnets* should list the three /24s.
- **VMs**: *Compute Engine → VM instances* should show three instances, one in each region.
- **Firewall**: *VPC network → Firewall* should include the named `allow-80-from-windows-to-*` rules.

You can also test HTTP reachability between appropriately tagged source/target instances using curl, browser, or simple `nc` checks.

---

## Customization

- **Project / VPC name**: Change in `terraform.tfvars`.
- **CIDR ranges / Regions**: Edit `subnets.tf` to adjust `ip_cidr_range` and `region`.
- **Machine type / Images / Tags**: Update the instance blocks in `instances.tf` (e.g., `machine_type`, `tags`, `boot_disk`, `metadata_startup_script`).  
- **Firewall policy**: Add/edit rules in `firewall.tf` to open ports, change sources/targets, or modify priorities.
- **Service account scopes**: Reduce from `cloud-platform` to least privilege as needed.

---

## Destroy

```bash
terraform destroy -var-file=terraform.tfvars
```

> API services enabled by Terraform are configured with `disable_on_destroy = false`, so they **remain enabled** after `destroy`.

---

## Cost Notes

- Three persistent VMs (one per region), external IPs, and egress may incur notable costs.
- Consider **stopping** instances or using **preemptible/spot** instances for savings.
- Remove the external IP (`access_config`) if not strictly necessary.

---

## Troubleshooting & Tips

- If plan/apply errors on **API not enabled**, wait a moment after `apply` starts (services are created on the fly) or pre‑enable them.
- If VMs fail to start due to **image/boot disk** settings, verify `instances.tf` (image family, project) and quota in each region.
- If **firewall** traffic is blocked, double‑check **tags** on both source and target instances match the firewall rule definitions.
- To **pin a specific zone**, set the `zone` in each instance block rather than relying on computed zones.

---

## Security Considerations

- Limit **ingress** to necessary sources and ports (principle of least privilege).
- Prefer **managed instance groups + load balancers** for production web traffic.
- Use **service accounts with minimal scopes** and IAM roles.
- Avoid broad `0.0.0.0/0` rules; use **tags**/**service accounts**/IP ranges to scope access.

---

**Thank You!**
