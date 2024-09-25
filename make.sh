#!/bin/bash

set -e

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