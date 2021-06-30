//
//  SectionReference.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {
  
  public struct SectionReference: Equatable, Codable, CustomStringConvertible {
    
    public var identifier : String
    public var title      : String
    public var abstract   : [ InlineContent ]
    public var role       : Role
    public var url        : String // relative URL
    public var kind       : String // also: kind=section? (generic section?)

    public var description: String {
      var ms = "<Section[\(identifier)]: "
      if !title.isEmpty { ms += " “\(title)”" }
      ms += " \(role) \(url) \(kind)"
      ms += ">"
      return ms
    }
  }
}
