// swift-tools-version:4.1
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
			targets: ["ShareLib"]),
		.library(
			name: "sShareLib",
			type: .static,
			targets: ["ShareLib"]),
		.library(
			name: "dShareLib",
			type: .dynamic,
			targets: ["ShareLib"])
	],
	dependencies: [
		.package(url: "https://github.com/DavidSkrundz/Collections.git",
				 .upToNextMinor(from: "1.1.0")),
		.package(url: "https://github.com/DavidSkrundz/CommandLine.git",
				 .upToNextMinor(from: "1.4.0")),
		.package(url: "https://github.com/DavidSkrundz/LibC.git",
				 .upToNextMinor(from: "1.2.1")),
		.package(url: "https://github.com/DavidSkrundz/Math.git",
				 .upToNextMinor(from: "1.1.0"))
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
