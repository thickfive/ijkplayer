# #!/bin/bash

# 定义变量
PROJ_NAME="IJKMediaDemo"
SCHEME=$PROJ_NAME
FRAMEWORK_NAME="IJKMediaFramework"
XCFRAMEWORK_NAME="$FRAMEWORK_NAME.xcframework"
OUTPUT_DIR="./build"
DERIVED_DATA="DerivedData"

# 创建输出目录
mkdir -p $OUTPUT_DIR

# 编译 iOS
xcrun xcodebuild build \
  -project $PROJ_NAME/$PROJ_NAME.xcodeproj \
  -scheme $SCHEME \
  -destination "generic/platform=iOS" \
  -derivedDataPath $OUTPUT_DIR/$DERIVED_DATA

# xcodebuild archive 模拟器架构选择 arch=x86_64 依然输出 arm64
# 改用 xcrun xcodebuild build 代替
# 编译 iOS Simulator
xcrun xcodebuild build \
  -project $PROJ_NAME/$PROJ_NAME.xcodeproj \
  -scheme $SCHEME \
  -destination "platform=iOS Simulator,name=iPhone 16,arch=x86_64" \
  -derivedDataPath $OUTPUT_DIR/$DERIVED_DATA

# 清理旧文件
rm -rf $OUTPUT_DIR/$XCFRAMEWORK_NAME

# 创建 XCFramework
xcodebuild -create-xcframework \
  -framework $OUTPUT_DIR/$DERIVED_DATA/Build/Products/Debug-iphoneos/$FRAMEWORK_NAME.framework \
  -framework $OUTPUT_DIR/$DERIVED_DATA/Build/Products/Debug-iphonesimulator/$FRAMEWORK_NAME.framework \
  -output $OUTPUT_DIR/$XCFRAMEWORK_NAME
  
# 清理编译文件
rm -rf $OUTPUT_DIR/$DERIVED_DATA

echo "========== XCFramework =========="
echo "XCFramework created at $OUTPUT_DIR/$XCFRAMEWORK_NAME"