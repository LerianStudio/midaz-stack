# midaz-full

Midaz All-in-One Suite
This project combines Midaz Ledger and Midaz Console into a unified all-in-one solution. It integrates the capabilities of both projects, providing a seamless experience for managing and interacting with your ledger in a single platform.

This version adds clarity and introduces both projects by name, which can help readers understand the purpose and benefit of the combination. Let me know if you'd like to add further details!

## Cloning MIDAZ-FULL
```bash
  git clone --recurse-submodules git@github.com:LerianStudio/midaz-full.git
```

## Run MIDAZ all-in-one
```bash
  set -e
  
  git submodule update --init --recursive --checkout
  
  cd midaz

  make set-env

  make all-services COMMAND="up"

  cd ..

  cd midaz-console
  
  npm run set-local-env
  
  npm run dev
  
  npm run docker-compose
  
  cd ..
```

## Stop MIDAZ all-in-one
```bash
  set -e
  
  cd midaz

  make all-services COMMAND="stop"
  
  cd ..

  cd midaz-console
  
  docker-compose stop
  
  docker system prune -a -f
  docker volume prune -a -f

  git submodule update --init --recursive --checkout
```

## Licença
Midaz is released under the terms of the Apache License 2.0. See COPYING for more information or see https://opensource.org/license/apache-2-0.
