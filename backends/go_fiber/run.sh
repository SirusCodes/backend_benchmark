#!/bin/sh

echo 'Getting dependencies...'
go get

echo 'Building server...'
go build

echo 'Running server...'
./backend_benchmark
