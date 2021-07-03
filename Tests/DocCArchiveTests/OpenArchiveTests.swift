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
  
  func testLoadMissing() throws {
    XCTAssertThrowsError(
      try DocCArchive(contentsOf: URL(fileURLWithPath: "/tmp/missing.txt"))
    )
  }
}
