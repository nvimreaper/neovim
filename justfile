# Displays this help message
help:
  @echo "Available commands:"
  @just --list

build:
  docker build -t neovim:stable .

run:
  docker run -it -v ./:/workspace neovim:stable
