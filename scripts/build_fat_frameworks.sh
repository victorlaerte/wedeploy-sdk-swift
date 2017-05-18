exec > /tmp/${PROJECT_NAME}_archive.log 2>&1

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

if [ "true" == ${ALREADYINVOKED:-false} ]; then
	echo "RECURSION: Detected, stopping"
	exit 0
fi

export ALREADYINVOKED="true"

FRAMEWORK_BUILD_DIR="${PROJECT_DIR}/$PLATFORM"

if [ "$PLATFORM" = Mac ]; then
	mkdir -p "${FRAMEWORK_BUILD_DIR}"
	yes | cp -Rf "${ARCHIVE_PRODUCTS_PATH}${INSTALL_PATH}/${FULL_PRODUCT_NAME}" "${FRAMEWORK_BUILD_DIR}"
	exit $?
fi

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

echo "Building for iPhoneSimulator"
if [ "$PLATFORM" = iOS ]; then
	xcodebuild -workspace "${WORKSPACE_PATH}" -scheme "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6' ONLY_ACTIVE_ARCH=NO ARCHS='i386 x86_64' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" ENABLE_BITCODE=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode clean build
else
	xcodebuild -workspace "${WORKSPACE_PATH}" -scheme "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk appletvsimulator -destination 'platform=tvOS Simulator,name=Apple TV 1080p' ONLY_ACTIVE_ARCH=NO ARCHS='x86_64' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" ENABLE_BITCODE=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode clean build
fi

# Step 1. Copy the framework structure (from iphoneos build) to the universal folder
echo "Copying to output folder"
cp -R "${ARCHIVE_PRODUCTS_PATH}${INSTALL_PATH}/${FULL_PRODUCT_NAME}" "${UNIVERSAL_OUTPUTFOLDER}/"

if [ "$PLATFORM" = iOS ]; then
	SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/Modules/${PRODUCT_NAME}.swiftmodule/."
else
	SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-appletvsimulator/${PRODUCT_NAME}.framework/Modules/${PRODUCT_NAME}.swiftmodule/."
fi

echo "$SIMULATOR_SWIFT_MODULES_DIR"
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
	cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/Modules/${PRODUCT_NAME}.swiftmodule"
fi

# Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "Combining executables"
if [ "$PLATFORM" = iOS ]; then
	lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${EXECUTABLE_PATH}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${EXECUTABLE_PATH}" "${ARCHIVE_PRODUCTS_PATH}${INSTALL_PATH}/${EXECUTABLE_PATH}"
else
	lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${EXECUTABLE_PATH}" "${BUILD_DIR}/${CONFIGURATION}-appletvsimulator/${EXECUTABLE_PATH}" "${ARCHIVE_PRODUCTS_PATH}${INSTALL_PATH}/${EXECUTABLE_PATH}"
fi

# Step 5. Convenience step to copy the framework to the project's directory
echo "Copying to project dir"
mkdir -p "${FRAMEWORK_BUILD_DIR}"
yes | cp -Rf "${UNIVERSAL_OUTPUTFOLDER}/${FULL_PRODUCT_NAME}" "${FRAMEWORK_BUILD_DIR}"