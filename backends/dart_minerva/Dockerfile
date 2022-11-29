# Specify the Dart SDK base image
FROM dart:stable as build

# Create application directory.
WORKDIR /app

# Copy project.
COPY . . 

# Resolve app dependencies.
RUN dart pub get

# Activate Minerva.
RUN dart pub global activate minerva

# Build project.
RUN dart pub get --offline
RUN ${HOME}/.pub-cache/bin/minerva build -m release

# Build minimal serving image from AOT-compiled and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime /

COPY --from=build /app/build/release/bin /app/bin
COPY --from=build /app/build/release/appsetting.json /app

# Start server.
EXPOSE 8080
CMD ["app/bin/main"]
