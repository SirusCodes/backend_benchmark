#!/bin/sh

echo 'Getting dependencies...'
dart pub get

echo 'Activating dart_frog_cli'
dart pub global activate dart_frog_cli

echo 'Build server'
dart_frog build

echo 'Run server'
dart build/bin/server.dart