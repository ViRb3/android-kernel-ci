# Android Kernel CI Releases
A generic auto-build repo for Android kernels using GitLab's CI

## Features
* OnePlus 5T ARM64 preset
* RedFlare kernel by Tresk
* Automatic versioning

## Downloads
* Latest build: `/-/jobs/artifacts/master/download?job=build`
* Browse all builds: `/pipelines`

Do not flash the artifacts, extract them and flash the zip inside!

## Usage
Run a new pipeline, optionally defining variables
### Variables
* `AKCI_TAG` - git tag or branch to build from
* `AKCI_LABEL` - label to use for kernel. If not defined, kernel will be labeled with short git commit hash
* `AKCI_CCACHE` - whether to use ccache. Either `1` or `0`, default: `1`
### Examples
* *no variables* 
    * builds from latest `HEAD` commit `320408e0`
    * produces `Redflare-Kernel-TEST-320408e0.zip`
* TAG="alpha"
    * builds from latest tag or branch `alpha` commit `73a05b11`
    * produces `Redflare-Kernel-TEST-73a05b11.zip`
* LABEL="1.0"
    * builds from latest `HEAD` commit `320408e0`
    * produces `Redflare-Kernel-RELEASE-1.0.zip`
* TAG="alpha" LABEL="1.0"
    * builds from latest tag or branch `alpha` commit `73a05b11`
    * produces `Redflare-Kernel-RELEASE-1.0.zip`
## Configuring
Check `config.sh` and `prepare.sh`
