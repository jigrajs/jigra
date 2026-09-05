set -e

# Verify pods are good
if command -v pod >/dev/null 2>&1; then
  cd ios
  pod lib lint --allow-warnings Jigra.podspec
  pod lib lint --allow-warnings JigraCordova.podspec
  cd ..
else
  echo "Skipping pod linting (pod not found)"
fi

# Do the gradle
if [ -f "android/gradlew" ]; then
  cd android
  ./gradlew clean build -b jigra/build.gradle -Pandroid.useAndroidX=true -Pandroid.enableJetifier=true
  cd ..
else
  echo "Skipping Android build (gradlew not found)"
fi
