set -e

# Verify pods are good
cd ios
pod lib lint --allow-warnings Jigra.podspec
pod lib lint --allow-warnings JigraCordova.podspec


# Do the gradle
cd ../android
./gradlew clean build -b jigra/build.gradle -Pandroid.useAndroidX=true -Pandroid.enableJetifier=true
