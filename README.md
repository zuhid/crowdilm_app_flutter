# crowdilm-app-flutter
CrowdIlm appliation written in flutter


# Setup Development Environment
- crete a ssh key
- login to github and upload pubic key in "https://github.com/settings/keys"
- `git clone git@github.com:zuhid/crowdilm-app-flutter` to clone the project
- `flutter clean` to build the app
- `flutter create .` to add default files
- `flutter device` to view the available devices
- `flutter run --device-id linux` to run the the app in linux
- `flutter run --device-id chrome` to run the the app chrome browser


# To clean and rebuild all the fiels
```
rm -rf .dart_tool
rm -rf .idea
rm -rf android
rm -rf build
rm -rf ios
rm -rf linux
rm -rf macos
rm -rf web
rm -rf windows
rm -rf analysis_options.yaml
rm -rf crowdilm.iml
rm -rf pubspec.lock
rm -rf .metadata
rm -rf .dart_tool

flutter clean
flutter create .
```
