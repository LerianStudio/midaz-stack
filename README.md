# midaz-full

Midaz All-in-One Suite
This project combines Midaz Ledger and Midaz Console into a unified all-in-one solution. It integrates the capabilities of both projects, providing a seamless experience for managing and interacting with your ledger in a single platform.

This version adds clarity and introduces both projects by name, which can help readers understand the purpose and benefit of the combination. Let me know if you'd like to add further details!

## Run MIDAZ all-in-one
```bash
  chmod +x ./make.sh && ./make.sh
```

```bash
  git submodule update --init --recursive --checkout

  cd midaz

  cd components

  cd ledger
  mv .env.example .env

  cd ..

  cd transaction
  mv .env.exemple .env

  cd ..

  cd ..

  make ledgers COMMAND="up"
  make transaction COMMAND="up"

  cd ..

  cd midaz-console
  npm run dev

  docker-compose up -d

  storybook dev -p 6006
```