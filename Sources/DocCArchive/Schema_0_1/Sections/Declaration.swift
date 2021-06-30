//
//  Declaration.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Declaration: Equatable, Codable, CustomStringConvertible {
    
    // TBD: really fragments?
    public var tokens    : DocCArchive.DocCSchema_0_1.Block
    
    public var languages : [ DocCArchive.DocCSchema_0_1.InterfaceLanguage ]
    public var platforms : [ DocCArchive.DocCSchema_0_1.Platform          ]
    
    public var description: String {
      var ms = "<Decl #tokens=\(tokens.count)"
      if !languages.isEmpty {
        ms += " languages="
        ms += languages.map({ $0.rawValue }).joined(separator: ",")
      }
      if !platforms.isEmpty {
        ms += " platforms="
        ms += platforms.map({ $0.rawValue }).joined(separator: ",")
      }
      ms += ">"
      return ms
    }
  }
}
