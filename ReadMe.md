# Local Dev Box Setup with Multipass 

[![Travis CI](https://img.shields.io/travis/rajasoun/multipass-dev-box/master.svg?label=TravisCI&style=flat-square)](https://travis-ci.org/rajasoun/multipass-dev-box) 
[![GitHub Actions Status](https://img.shields.io/github/workflow/status/rajasoun/multipass-dev-box/CI?label=GithubActions&style=flat-square)](https://github.com/rajasoun/multipass-dev-box/actions)

Eases Dev Box Setup with Multipass, Docker & Ansible compatible with Windows, MacOS and Linux.
Main purpose is to have a **common way** of configuring a development environment that is simple, fast and automated,
with minimal dependencies 

| Tools           | MacOS      | Windows   | Linux   |
|:----------------|:-----------|:----------|:--------|
| Package Manager | [homebrew] | [scoop]   | [snap]  |
| Shell           | Default    | [GitBash] | Default |
| Terminal        | [iTerm2]   | [cmder]   | Default |

Common Tools:
1. Code Editors (IDE) - [Jetbrains Tools], [Visual Studio Code]
2. Virtualization Orchestrator - [Multipass]
3. Containerization - [Docker Desktop]

FYI: Links provided only for packages that are not installed by Default

Limitations: Multipass will not work on Mac when connected to Cisco Any Connect. 

[Introductions & Installation Instruction For Prerequisite](docs/installation_instruction.md)

### Getting Started 

#### Validate Prerequisite Installations or PreConditions 

In Terminal 

```SHELL
$ git submodule update --init --recursive --remote
$ ci/check_bats.bash -f .precondition
```

All 7 Tests should pass - if you have issues, double check the [Installation Instruction](docs/installation_instruction.md)

```SHELL
$ ./sandbox.bash
Usage: ./sandbox.bash  {up|down|status|logs}

   up               Provision, Configure, Validate Application Stack
   down             Application Stack
   status           Displays Status of Application Stack
   logs             Application Stack Log Dashboard
```

Application deployment:

```SHELL
$ scripts/update_config.sh {salesinsights|leads|rmt}|{clean} <AWS Profile Name>"
$ scripts/provision.sh

For IP address:

$ multipass info microcloud
```

#### Dev Tools

[Dev Tools](dev-tools/ReadMe.md)  cookie-cutter solution for cross cutting concerns like (Logging, Monitoring, Authentication etc)


#### Learn Mode 

[Learn Mode](docs/3_learn_mode.md) for step by step self learning


### VM Configuration & Overriding Options

In order to override the default configuration file instance.env (optional)
``` SHELL
$ cp instance.env dev.instance.env
```

Modify dev.instance.env to suit your needs. multipass.bash will pick up dev.instance.env if it is present else
will default to instance.env.
Note: dev.instance.env is excluded from check-in in .gitignore


### What does the Script Do
Automates - Automates - Automates !!!

1. Provides Workaround of [Issue](https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901) 
through cloud-init configuration by editing the /etc/netplan/50-cloud-init.yaml through script.
    * Refer [cloud-init](config/templates/cloud-init-template.yaml) Template file
2. Configuration driven - from provisioning to destroy of VM along with SSH Configuration
3. Ability to connect and configure VM via Bastion Host - Making the experience seamless between Windows & Mac 
4. Test Driven Development for entire suite
5. Modularization of Code for Easy Refactoring
6. Workaround to invoke docker in a common way through wrapper both for windows and mac


*Features*

     1. Adoption of Git Flow  ✅
     2. Add Automated Verification - CI 
            a. Travis (Linux Only) ✅
            b. GitHub Actions (Linux,Mac & Windows) ✅
     3. Configure VM through Ansible ✅
     4. Infrastrcuture Test Automation using py.test & TestInfra  ✅
     5. Centralized Logging ✅
     6. Log Shipper and Aggregation ✅
     7. HTTPS Support ✅
     8. CLI Builder ✅
     9. WebTail  ✅
     10. Edge Routing or Reverse Proxy Support  ✅
     11. Edge Routing or Reverse Proxy Support  ✅
     12. Dev Tools Container Mgmt  ✅
     13. OAuth2 + SSO -> Authentication Support  ✅
     14. System Monitoring
     15. Support for ADR
     16. Explore workarounds for  Multipass + Anyconnect Issue
     17. Authorization or Policy Mgmt
     18. Key or Secrets Management
     19. Status Aggregator
     20. AWS Support
     21. vSphere Support



### Flows

[SSH & Ansible Flow](docs/ssh_ansible_flows.md)

References:
---
    1. https://github.com/canonical/multipass/issues/961
    2. https://multipass.run/docs/troubleshooting-networking-on-macos
    3. https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
    

[Homebrew]: https://brew.sh/
[Scoop]: https://scoop.sh/
[snap]: https://codeburst.io/how-to-install-and-use-snap-on-ubuntu-18-04-9fcb6e3b34f9
[GitBash]: https://git-scm.com/
[iTerm2]: https://iterm2.com/
[cmder]: https://cmder.net/
[Jetbrains Tools]: https://www.jetbrains.com/
[Visual Studio Code]: https://code.visualstudio.com/
[Multipass]: https://multipass.run/
[Docker Desktop]: https://www.docker.com/products/docker-desktop