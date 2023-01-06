#!/bin/sh

echo 'Getting dependencies...'
dart pub get

echo 'Activating conduit'
dart pub global activate conduit

echo 'Running conduit'
conduit serve -a 127.0.0.1 -p 8080