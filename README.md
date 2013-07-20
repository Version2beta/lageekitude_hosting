# La Geekitude Empowered Hosting

Scripts and configs for La Geekitude Empowered Hosting

## What is La Geekitude Empowered Hosting?

La Geekitude Empowered hosting is a project in process started and facilitated by Barbara Handley, a/k/a @senvara and sometimes known as @lageekitude. She was inspired to create a collaborative support community, workshop environment, and business incubator for women and by women on the web. A safe place for women to learn and ask questions and be protected from trolls or snarky know-it-all geeks. Most of all, free from shame or embarrassment.

This repository provides a handful of scripts and tools useful for creating and maintaining hosting environments. They are currently geared toward Ubuntu 12.04 LTS. Details and instructions are below.

## Provisioning a new server

To be determined. Right now, the emphasis is on Digital Ocean, 512MB / $5 per month virtual private servers. The basic steps are:

1. Order the server (Ubuntu 12.04LTS)
1. Copy keys over
1. Log in
1. Run updates `apt-get update && apt-get upgrade`
1. Create SSH keys `ssh-keygen`
1. Create a basic build environment `apt-get install build-essential git-core`
1. Install chruby from https://github.com/postmodern/chruby and run setup `. ./scripts/setup.sh`
1. Install chef `curl -L https://www.opscode.com/chef/install.sh | sudo bash`
1. Clone this repository
1. Create lageekitude-base.json
1. Run chef-solo against lageekitude-base `chef-solo /root/sysadmin/lageekitude_hosting/solo.rb -j lageekitude-base.json`
1. Create domain.json files
1. Run chef-solo with new json files

Of course all of this will get easier. The steps will be more automated and more friendly, and the documentation will be better.

