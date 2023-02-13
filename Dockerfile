FROM buildpack-deps:focal

RUN apt update && apt install -y apt-transport-https

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg

RUN echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list

RUN apt update && apt install -y dart

RUN export PATH="$PATH":"$HOME/.pub-cache/bin";