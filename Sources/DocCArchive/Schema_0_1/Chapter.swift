//
//  Chapter.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  /**
   * Chapter in a `volume` ``Section``.
   */
  public struct Chapter: Equatable, CustomStringConvertible, Codable {
    
    public var name      : String
    public var image     : String?
    public var content   : [ Content    ]
    public var tutorials : [ Identifier ]

    public var description: String {
      var ms = "<Chapter:"
      if !name.isEmpty      { ms += " “\(name)”"    }
      if let s = image      { ms += " image=\(s)"   }
      if !content .isEmpty  { ms += " \(content)"   }
      if !tutorials.isEmpty { ms += " \(tutorials)" }
      ms += ">"
      return ms
    }
  }
}
