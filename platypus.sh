#!/bin/bash

PLAY_ARGS='-Dsbt.log.noformat=true'
OUTPUT_TYPE='Text Window'
ICON_FILENAME='icon.icns'

set -e
set -u

command -v platypus >/dev/null 2>&1 || { echo "Platypus is required but not installed." >&2; exit 1; }

APP_NAME=$1
VERSION=$2
DMG_NAME="$APP_NAME-$VERSION"

cd ./target/universal/

# Remove previous DMG image if it exists.
rm -f "$DMG_NAME.dmg"
rm -rf "$DMG_NAME"

# Create app bundle.
tar -zxvf "$DMG_NAME.tgz"
cd "$DMG_NAME"
printf "%s\n%s%s\n" '#!/bin/sh' './bin/' "$APP_NAME $PLAY_ARGS" > run.sh

if [ -f ../../../$ICON_FILENAME ]; then
  cp ../../../$ICON_FILENAME .
  ICON_ARG="-i $ICON_FILENAME"
else
  ICON_ARG=""
fi

mkdir "$APP_NAME"
ln -s /Applications "$APP_NAME/Applications"
platypus -V "$VERSION" -a "$APP_NAME" -o "$OUTPUT_TYPE" $ICON_ARG -f bin -f conf -f lib run.sh "$APP_NAME/$APP_NAME.app"

# Create DMG image.
hdiutil create -srcfolder "$APP_NAME" "../$DMG_NAME.dmg"

# Clean up.
rm -rf "../$DMG_NAME"
