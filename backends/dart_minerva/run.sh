#!/bin/sh

echo 'Getting dependencies...'
dart pub get

echo 'Activating Minerva...'
dart pub global activate minerva

echo 'Building server...'
minerva build -m release

echo 'Running server...'
./build/release/bin/main