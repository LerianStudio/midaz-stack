# midaz-stack

Midaz All-in-One Suite
This project combines Midaz Ledger and Midaz Console into a unified all-in-one solution. It integrates the capabilities of both projects, providing a seamless experience for managing and interacting with your ledger in a single platform.

This version adds clarity and introduces both projects by name, which can help readers understand the purpose and benefit of the combination.

## Prerequisites
* [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker](https://docs.docker.com/get-started/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/t)
* [Node.Js and npm](https://nodejs.org/en/download/package-manager) >= v18.x.x
* Makefile:

#### Linux:
```bash
sudo apt install make
```

#### Windows:
```bash
choco install make
```

#### Mac:
```bash
brew install make
```

## Cloning MIDAZ-STACK
```bash
  git clone --recurse-submodules git@github.com:LerianStudio/midaz-stack.git
  cd midaz-stack
```

## Run MIDAZ all-in-one
```bash
  make up
```

## Stop MIDAZ all-in-one
```bash
  make stop
```

## remove MIDAZ all-in-one
```bash
  make remove
```

## Licença
Midaz is released under the terms of the Apache License 2.0. See COPYING for more information or see https://opensource.org/license/apache-2-0.
