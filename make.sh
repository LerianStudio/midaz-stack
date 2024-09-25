#!/bin/bash

set -e

git submodule update --init --recursive --checkout

cd midaz/components/auth
mv .env.example .env

cd ../ledger
mv .env.example .env

cd ../transaction
mv .env.exemple .env

cd ../../
make ledgers COMMAND="up"
make transaction COMMAND="up"

cd ../midaz-console
npm run dev

docker-compose up -d

storybook dev -p 6006