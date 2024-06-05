#!/bin/bash

# Array con los nombres de los subdirectorios
directories=("clientGW-ms-example" "orders-ms-example" "payments-ms-example" "products-ms-example")

for dir in "${directories[@]}"; do
  echo "Cleaning and installing dependencies in $dir"
  cd $dir
  npm cache clean --force
  rm -rf node_modules package-lock.json
  npm install
  cd ..
done

echo "Done cleaning and installing dependencies in all subdirectories."
