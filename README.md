<p align="center" style="font-size: 60px;">
    neat_cli 🧼
</p>

<p align="center">

![coverage][coverage_badge]
[![License: MIT][license_badge]][license_link]
![version](https://img.shields.io/badge/version-0.0.1-blue)
[![Twitter Follow](https://img.shields.io/twitter/follow/MerseniBilel.svg?style=social)](https://twitter.com/MerseniBilel) 

![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![VS Code Insiders](https://img.shields.io/badge/VS%20Code%20Insiders-35b393.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
</p>

<p align="center">A sample cli to create clean architecture flutter projects</p>

---

## Getting Started 🚀
### Install ⬇️ 
Activate globally via:

```sh
dart pub global activate neat_cli
```

If you want to use the model,entity generator using api resources or json schema you need to install quicktype

```sh
npm install -g quicktype
```

## Usage

```sh
# Show usage help
$ neat_cli --help

# create a new flutter project
$ neat_cli create my_app

# show CLI version
$ neat_cli --version

# shwo command usage help
$ neat_cli help create
# or
$ neat_cli create -h

# create new feature "post"
$ neat_cli feature post

# create new feature and generate model and entity using from api/json
$ neat_cli feature -e entity.json -m https://jsonplaceholder.typicode.com/posts

# generate files from abstract repository
$ neat_cli settle -f post -r post_repository

```

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
