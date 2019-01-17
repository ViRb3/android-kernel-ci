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

## Building
### Test (snapshot) build
* Run a new pipeline without any variables
* Will be tagged with short git commit hash
### Stable (versioned) build
* Run a new pipeline with a variable `TAG` set to the git tag to build from, e.g. `v3.0`. Tag must exist in the kernel repo!
* Will be tagged with the supplied version

## Configuring
Check `config.sh` and `prepare.sh`
