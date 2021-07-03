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
}
