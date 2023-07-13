FROM cirrusci/flutter:2.5.3

WORKDIR /usr/src/app

COPY . .

RUN flutter clean \
    && flutter pub get \
    && flutter build apk --release

RUN mkdir -p /usr/apk/

CMD ["cp", "/usr/src/app/build/app/outputs/flutter-apk/app-release.apk", "/usr/apk/cash-manager.apk"]