#!bin/sh

echo 'Getting dependencies...'
dart pub get

echo 'Activating Minerva...'
dart pub global activate minerva