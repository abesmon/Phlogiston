if [ $CONFIGURATION == Release ]; then
    echo "Bumping build number..."
    COOL_BUILD_NUMBER=`xcrun git rev-list --all |wc -l`

    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${COOL_BUILD_NUMBER}" "${PRODUCT_SETTINGS_PATH}"
    echo "New build number is ${COOL_BUILD_NUMBER}"
    #echo "Updated ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
else
    echo $CONFIGURATION "build bumper - Not bumping build number."
fi
