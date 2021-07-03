// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name     : "DocCArchive",
  products : [ .library(name: "DocCArchive", targets: [ "DocCArchive" ]) ],
  targets  : [
    .target    (name: "DocCArchive"),
    .testTarget(name: "DocCArchiveTests", dependencies: [ "DocCArchive" ])
  ]
)
