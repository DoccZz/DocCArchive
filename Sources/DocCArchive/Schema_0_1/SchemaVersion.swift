//
//  SchemaVersion.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  public struct SchemaVersion: Equatable, Codable, CustomStringConvertible {
    
    var major : Int // 0
    var minor : Int // 1
    var patch : Int // 0
    
    public static let current = SchemaVersion(major: 0, minor: 1, patch: 0)
    
    public var description: String {
      return "v\(major).\(minor).\(patch)"
    }
  }
}
