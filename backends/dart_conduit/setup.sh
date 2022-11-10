#!bin/sh

echo 'Getting dependencies...'
dart pub get

echo 'Activating conduit'
dart pub global activate conduit