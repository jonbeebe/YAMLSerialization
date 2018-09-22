// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS)
	let yamlPkg = "yaml-0.1" // this is what homebrew installs package as
#else
	let yamlPkg = "yaml"
#endif

let package = Package(
    name: "YAMLSerialization",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "YAMLSerialization",
            targets: ["YAMLSerialization"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .systemLibrary(
            name: "yaml",
            pkgConfig: yamlPkg,
            providers: [
                .brew(["libyaml"]),
                .apt(["libyaml-dev"])
            ]),
        .target(
            name: "YAMLSerialization",
            dependencies: ["yaml"]),
        .testTarget(
            name: "YAMLSerializationTests",
            dependencies: ["YAMLSerialization"]),
    ]
)
