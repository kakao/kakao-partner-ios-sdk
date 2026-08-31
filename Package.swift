// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

// sdk-version:2.29.0

import PackageDescription

let openSdkPackageName = "kakao-ios-sdk"

let package = Package(
    name: "KakaoPartnerSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "KakaoPartnerSDK",
            targets: ["KakaoPartnerSDKCommon", "KakaoPartnerSDKAuth", "KakaoPartnerSDKUser", "KakaoPartnerSDKTalk", "KakaoPartnerSDKFriend", "KakaoPartnerSDKShare"]),
        .library(
            name: "KakaoPartnerSDKCommon",
            targets: ["KakaoPartnerSDKCommon"]),
        .library(
            name: "KakaoPartnerSDKAuth",
            targets: ["KakaoPartnerSDKAuth"]),
        .library(
            name: "KakaoPartnerSDKUser",
            targets: ["KakaoPartnerSDKUser"]),
        .library(
            name: "KakaoPartnerSDKTalk",
            targets: ["KakaoPartnerSDKTalk"]),
        .library(
            name: "KakaoPartnerSDKFriend",
            targets: ["KakaoPartnerSDKFriend"]),
        .library(
            name: "KakaoPartnerSDKShare",
            targets: ["KakaoPartnerSDKShare"]),
        .library(
            name: "KakaoPartnerSDKFriendDelegate",
            targets: ["KakaoPartnerSDKFriendDelegate"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git",
                 exact: "2.29.0")
    ],
    targets: [
        .target(
            name: "KakaoPartnerSDKCommon",
            dependencies: [
                .product(name: "KakaoSDKCommon", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKAuth",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKAuth", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKUser",
            dependencies: [
                .target(name: "KakaoPartnerSDKAuth"),
                .product(name: "KakaoSDKUser", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKTalk",
            dependencies: [
                .target(name: "KakaoPartnerSDKUser"),
                .product(name: "KakaoSDKTalk", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKFriend",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKFriend", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKShare",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKShare", package: openSdkPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKFriendDelegate",
            dependencies: [
                .product(name: "KakaoSDKFriendCore", package: openSdkPackageName)
            ],
            exclude: ["Info.plist", "README.md"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
