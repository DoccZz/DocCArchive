//
//  Utilities.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation

public extension URL {
  
  /**
   * Remove DocC resource hashes from filenames.
   *
   * For example: `index.79cf605e.css` => `index.css`
   */
  func deletingResourceHash() -> URL {
    let pathExtension = self.pathExtension           // the real path extension
    let withoutPE     = self.deletingPathExtension() // `index.79cf605e`
    let hashExtension = withoutPE.pathExtension
    guard hashExtension.count == 8                else { return self }
    guard UInt32(hashExtension, radix: 16) != nil else { return self }
    
    return withoutPE.deletingPathExtension() // strip the hash
                    .appendingPathExtension(pathExtension) // re-add extension
  }
  
  /**
   * Returns the DocC resource hash from a filename.
   *
   * For example: `index.79cf605e.css` => `0x79cf605e`
   */
  var resourceHash: UInt32? {
    let hashExtension = deletingPathExtension().pathExtension
    guard hashExtension.count == 8 else { return nil }
    return UInt32(hashExtension, radix: 16)
  }
}

extension FileManager {

  func contentsOfDirectory(at url: URL) -> [ URL ] {
    do {
      return try self.contentsOfDirectory(atPath: url.path)
                     .map { url.appendingPathComponent($0) }
    }
    catch {
      return []
    }
  }
}

public extension String {
  
  /**
   * This removes the weird data tagging in the stylesheet.
   *
   * I _guess_ those are there to make styles unique in case sheets are
   * overlayed, but who knows :-)
   *
   * Example: `[data-v-4c6eebf4] h6` => ` h6`
   */
  func stringByRemovingDocCDataReferences() -> String {
    components(separatedBy: "[data-v-")
      .map { line -> Substring in
        guard let idx = line.firstIndex(of: "]") else { return line[...] }
        return line[line.index(after: idx)...]
      }
      .joined()
  }
}
