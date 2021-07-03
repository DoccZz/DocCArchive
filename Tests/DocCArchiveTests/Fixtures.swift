//
//  Fixtures.swift
//  DocCArchiveTests
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation

enum Fixtures {
  
  static let baseURL = URL(fileURLWithPath: #filePath)
                         .deletingLastPathComponent()
                         .appendingPathComponent("Fixtures/", isDirectory: true)

  static let slothCreatorArchive =
    FileManager.default.homeDirectoryForCurrentUser
      .appendingPathComponent("Downloads")
      .appendingPathComponent("SlothCreator.doccarchive")
}
