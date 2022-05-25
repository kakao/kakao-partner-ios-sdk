// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// sdk-version:2.10.0

import PackageDescription

let package = Package(
    name: "KakaoPartnerSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "KakaoPartnerSDK",
            targets: ["KakaoPartnerSDKCommon", "KakaoPartnerSDKAuth", "KakaoPartnerSDKUser", "KakaoPartnerSDKTalk", "KakaoPartnerSDKLink"]),
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
            name: "KakaoPartnerSDKLink",
            targets: ["KakaoPartnerSDKLink"])
    ],
    dependencies: [
        .package(name: "KakaoOpenSDK",
                 url: "https://github.com/kakao/kakao-ios-sdk.git",
                 .exact("2.10.0")
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
            name: "KakaoPartnerSDKLink",
            dependencies: [
                .target(name: "KakaoPartnerSDKCommon"),
                .product(name: "KakaoSDKLink", package: "KakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
