// swift-tools-version: 6.2
//
//  Package.swift
//
//  Copyright (c) 2026 Altboard
//
//  This file is part of Altboard and is licensed under the Altboard License
//  (the "License"); you may not use this file except in compliance with the
//  License. The full text of the License is in the LICENSE file at the root of
//  the Altboard repository, https://github.com/Altboard/Altboard.
//
//  As far as the law allows, Altboard comes as is, without any warranty or
//  condition, and the licensor will not be liable to you for any damages
//  arising out of the License or the use or nature of Altboard, under any kind
//  of legal claim.
//
//  In short, the License lets you change and build Altboard, and make new works
//  based on it, only for your own personal purposes, without any anticipated
//  commercial application. It also lets you propose changes for inclusion in
//  Altboard, in a fork of the Altboard repository or by sending them to the
//  licensor. Apart from those proposals, you may not distribute Altboard's
//  code, and you may not distribute any build of Altboard, changed or not. The
//  License does not limit any fair use rights you have under the law.
//
//  YOU MAY NOT USE ALTBOARD'S CODE, IN WHOLE OR IN PART, TO CREATE ANY APP OR
//  OTHER PRODUCT THAT YOU PUBLISH, DISTRIBUTE, OR SELL, INCLUDING THROUGH ANY
//  APP STORE, OR THAT YOU USE, OR PLAN TO USE, FOR ANY COMMERCIAL PURPOSE.
//

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.65.1")
    ]
)
