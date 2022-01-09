//
//  Fixtures.swift
//  DocCArchiveTests
//
//  Created by Helge Heß.
//  Copyright © 2021-2022 ZeeZide GmbH. All rights reserved.
//

import Foundation

enum Fixtures {
  
  static let baseURL = URL(fileURLWithPath: #filePath)
                         .deletingLastPathComponent()
                         .appendingPathComponent("Fixtures/", isDirectory: true)
  
  /// Where docc archives for bigger tests are being stored, currently
  /// in `~/Downloads`.
  static let testArchivesDir = FileManager.default.homeDirectoryForCurrentUser
                                 .appendingPathComponent("Downloads")
  
  static let slothCreatorArchive =
    testArchivesDir.appendingPathComponent("SlothCreator.doccarchive")

  static let issue7Archive =
    testArchivesDir.appendingPathComponent("LLabsWishlist.doccarchive")
}
