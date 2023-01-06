#!/bin/sh

echo 'Getting dependencies...'
pip install -r requirements.txt

echo 'Running server...'
python serve.py