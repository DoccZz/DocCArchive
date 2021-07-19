//
//  OpenArchiveTests.swift
//  DocCArchiveTests
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import XCTest
@testable import DocCArchive

final class OpenArchiveTests: XCTestCase {

  static var allTests = [
    ( "testLoadMissing" , testLoadMissing )
  ]

  func testLoadMissing() throws {
    XCTAssertThrowsError(
      try DocCArchive(contentsOf: URL(fileURLWithPath: "/tmp/missing.txt"))
    )
  }

  func testSubfoldersInSlothCreator() throws {
    let fm = FileManager.default
    try XCTSkipUnless(fm.fileExists(atPath: Fixtures.slothCreatorArchive.path),
                      "This test needs the SlothCreator.doccarchive in the " +
                      "~/Downloads directory")

    let archive = try DocCArchive(contentsOf: Fixtures.slothCreatorArchive)

    let pathes = archive.fetchDataFolderPathes().sorted()
    XCTAssertEqual(pathes.first, "/documentation")
  }

  func testIssue7() throws {
    let fm = FileManager.default
    try XCTSkipUnless(fm.fileExists(atPath: Fixtures.issue7Archive.path),
                      "This test needs the LLabsWishlist.doccarchive in the " +
                      "~/Downloads directory")

    let archive = try DocCArchive(contentsOf: Fixtures.issue7Archive)

    let pathes = archive.fetchDataFolderPathes().sorted()
    XCTAssertEqual(pathes.first, "/documentation")
  }
}
