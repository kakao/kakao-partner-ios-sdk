// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// sdk-version:2.24.3

import PackageDescription

let package = Package(
    name: "KakaoPartnerSDK",
    platforms: [
        .iOS(.v13)
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
        .package(name: "KakaoOpenSDK",
                 url: "https://github.com/kakao/kakao-ios-sdk.git",
                 .exact("2.24.3")
                )
    ],
    targets: [
        .target(
            name: "KakaoPartnerSDKCommon",
            dependencies: [
                .product(name: "KakaoSDKCommon", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKAuth",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKAuth", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKUser",
            dependencies: [
                .target(name: "KakaoPartnerSDKAuth"),
                .product(name: "KakaoSDKUser", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKTalk",
            dependencies: [
                .target(name: "KakaoPartnerSDKUser"),
                .product(name: "KakaoSDKTalk", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKFriend",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKFriend", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKShare",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKShare", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "KakaoPartnerSDKFriendDelegate",
            dependencies: [
                .product(name: "KakaoSDKFriendCore", package: "KakaoOpenSDK")
            ],
            exclude: ["Info.plist", "README.md"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
