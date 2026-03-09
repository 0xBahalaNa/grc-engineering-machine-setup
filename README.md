# GRC Engineering Machine Setup

Fedora workstation provisioning script for a GRC Engineering and compliance-as-code development environment. Installs the full toolchain needed to build, test, and ship cloud security and compliance automation.

## Why This Exists

Setting up a compliance engineering workstation from scratch means installing tools across multiple categories — cloud CLIs, infrastructure-as-code, policy-as-code scanners, and security analysis tools. This script automates that setup into a single repeatable run, so a fresh Fedora install goes from bare to fully equipped in minutes.

This toolchain supports a compliance-as-code lifecycle: **audit tools detect** → **config monitors watch** → **remediation tools fix** → **evidence loggers collect** → **OSCAL pipelines format** → **compliance reports visualize**.

## What Gets Installed

### Development Essentials

| Tool | Purpose |
|------|---------|
| curl, wget | HTTP clients for downloads and API calls |
| gcc, gcc-c++, kernel-devel, make | Build toolchain for native extensions |
| git | Version control |
| gnupg2, openssl | Cryptography and signing |
| htop | System monitoring |
| jq, yq | JSON/YAML parsing (essential for processing CloudTrail logs, IAM policies, Config evaluations) |
| python3-devel, python3-pip | Python development (primary scripting language) |
| ShellCheck | Bash linting and static analysis |
| tmux | Terminal session multiplexing |
| tree | Directory visualization |
| unzip, zip | Archive utilities |
| vim | Terminal editor |

### Cloud and Infrastructure-as-Code

| Tool | Purpose |
|------|---------|
| [AWS CLI v2](https://aws.amazon.com/cli/) | AWS account management, resource querying, evidence collection |
| [GitHub CLI (gh)](https://cli.github.com/) | Repository management, PR workflows, issue tracking from the terminal |
| [Terraform](https://www.terraform.io/) | Infrastructure-as-code for AWS security baselines and compliance controls |

### Policy-as-Code and Security Scanning

| Tool | Purpose |
|------|---------|
| [Checkov](https://www.checkov.io/) | Static analysis for IaC — scans Terraform, CloudFormation, Kubernetes for misconfigurations |
| [Conftest](https://www.conftest.dev/) | OPA-based configuration testing (Terraform plans, Kubernetes manifests, Dockerfiles) |
| [OPA](https://www.openpolicyagent.org/) | Open Policy Agent — general-purpose policy engine for Rego policies |
| [tfsec](https://aquasecurity.github.io/tfsec/) | Terraform-specific security scanner |
| [Trivy](https://trivy.dev/) | Vulnerability and misconfiguration scanner for containers, filesystems, and IaC |

### Containers and Virtualization

| Tool | Purpose |
|------|---------|
| open-vm-tools | VMware guest integration (clipboard, display resize, shared folders) |
| [Podman](https://podman.io/) + podman-compose | Daemonless container engine (ships natively on Fedora) |

## Prerequisites

- **Fedora Linux** (tested on Fedora 43, KDE Spin)
- **sudo access** — the script installs system packages and writes to `/usr/local/bin`
- **Internet connection** — downloads binaries and adds third-party repos (HashiCorp, GitHub CLI, Aqua Security)

## Usage

```bash
git clone https://github.com/0xBahalaNa/grc-engineering-machine-setup.git
cd grc-engineering-machine-setup
chmod +x setup.sh
./setup.sh
```

The script ends with a verification check that confirms each tool is installed and on `PATH`.

## Notes

- **Fedora-specific.** Uses `dnf` and Fedora RPM repos. Not directly portable to Ubuntu/Debian without modification.
- **VMware guest tools** are included because this was built for a VMware-based lab environment. Remove the `open-vm-tools` line if running on bare metal or a different hypervisor.
- **Checkov** installs via `pip install --break-system-packages`. On Fedora, this is needed because the system Python is externally managed. Consider using a virtual environment if you want isolation.
- **tfsec** is in maintenance mode — Aqua Security is folding its functionality into Trivy. Included here because some scanning workflows still reference it directly.

## GRC Engineering Context

This toolchain powers a portfolio of compliance automation projects targeting **NIST 800-53 Rev 5**, **FedRAMP High**, and **CJIS Security Policy v6.0** controls. The tools map to specific compliance activities:

- **Evidence collection:** AWS CLI queries for IAM policies, security group rules, CloudTrail logs, and Config evaluations
- **Security baselines:** Terraform provisions hardened AWS environments aligned to FedRAMP High requirements
- **Policy validation:** OPA/Conftest enforce guardrails as code — policies that can be version-controlled, tested, and audited
- **Misconfiguration detection:** Checkov, Trivy, and tfsec catch security issues before deployment, supporting continuous compliance
- **Reproducibility:** The entire toolchain is scripted, so any auditor or team member can stand up an identical environment

## License

MIT
