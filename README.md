<h1 align="center">
    neat_cli 🧼
</h1>

<p align="center">

![version](https://img.shields.io/badge/version-0.0.1-blue)
[![PR's Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](https://github.com/MerseniBilel)
[![Twitter Follow](https://img.shields.io/twitter/follow/MerseniBilel.svg?style=social)](https://twitter.com/MerseniBilel) 

![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![VS Code Insiders](https://img.shields.io/badge/VS%20Code%20Insiders-35b393.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
</p>

<p align="center">A sample cli to create clean architecture flutter projects with bloc</p>

---

## Features
- [x] create new flutter project
- [x] create new feature with model and entity
- [x] generate (usecases, repository, dataresources) from abstract class
- [ ] make bloc
- [ ] make entity, model from resources
- [ ] auto import dependencies




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

# Create a new flutter project
$ neat_cli create my_app

# Show CLI version
$ neat_cli --version

# Shwo command usage help
$ neat_cli help create
# Or
$ neat_cli create -h

# Create new feature "post"
$ neat_cli feature post

# Create new feature "post" and generate model and entity using api/json schema
$ neat_cli feature post -e entity.json -m https://jsonplaceholder.typicode.com/posts

# Generate files from abstract repository
$ neat_cli settle -f post -r post_repository

```

## Soon
```sh
# Make new bloc inside of a feature
$ neat_cli make bloc -f post

# Make entity inside of a feature
$ neat_cli make entity -f post --schema file.json

# Make model inside of feature
$ neat_cli make model -f post --schema https://jsonplaceholder.typicode.com/posts
```
