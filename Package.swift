// swift-tools-version:4.0
//
//  Package.swift
//  Share
//

import PackageDescription

let package = Package(
	name: "Share",
	products: [
		.library(
			name: "ShareLib",
			type: .static,
			targets: ["ShareLib"]),
		.library(
			name: "ShareLib",
			type: .dynamic,
			targets: ["ShareLib"])
	],
	dependencies: [
		.package(url: "https://github.com/DavidSkrundz/Collections.git",
				 .upToNextMinor(from: "1.0.0")),
		.package(url: "https://github.com/DavidSkrundz/CommandLine.git",
				 .upToNextMinor(from: "1.3.0")),
		.package(url: "https://github.com/DavidSkrundz/LibC.git",
				 .upToNextMinor(from: "1.1.0")),
		.package(url: "https://github.com/DavidSkrundz/Math.git",
				 .upToNextMinor(from: "1.0.0"))
	],
	targets: [
		.target(
			name: "Share",
			dependencies: ["ShareLib", "CommandLine", "Generator"]),
		.target(
			name: "ShareLib",
			dependencies: ["LibC", "Math"]),
		.testTarget(
			name: "ShareLibTests",
			dependencies: ["ShareLib"])
	]
)
