//
//  Document.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension DocCArchive.DocCSchema_0_1 {

  public struct Document: Equatable, Codable, CustomStringConvertible {
    
    public enum Kind: String, Codable, CustomStringConvertible {
      case overview, symbol, article, project
      
      public var description: String { return rawValue }
    }
    public struct Hierarchy: Equatable, Codable, CustomStringConvertible {
      
      public struct Module: Equatable, Codable {
        public var reference : Identifier
        // public var projects: [ ?? ]
      }
      
      public var paths     : [ [ String ] ]
      public var reference : String?
      public var modules   : [ Module ]?
      
      public var description: String {
        var ms = "<Hierarchy:"
        if paths.isEmpty { ms += " no-paths" }
        else if paths == [ [] ] { ms += " empty-level1" }
        else { ms += " \(paths)" }
        if let s = reference { ms += " ref\(s)" }

        if let modules = modules, !modules.isEmpty {
          ms += " modules=" + modules.map({ $0.reference.url.absoluteString })
                              .joined(separator: ",")
        }
        ms += ">"
        return ms
      }
    }

    public struct Variant: Equatable, Codable, CustomStringConvertible {
      public var paths  : [ String ]
      
      // TODO: type out (Trait enum)
      // e.g. interfaceLanguage: swift
      public var traits : [ [ String : String ] ]

      public var description: String {
        var ms = "<Variant:"
        if paths.isEmpty  { ms += " no-paths" }
        else              { ms += " " + paths.joined(separator: "/") }
        if traits.isEmpty { ms += " no-traits" }
        else              { ms += " \(traits)" }
        ms += ">"
        return ms
      }
    }
    
    public var schemaVersion          : SchemaVersion
    public var identifier             : Identifier
    public var documentVersion        : Int
    public var kind                   : Kind
    public var metadata               : MetaData
    public var hierarchy              : Hierarchy
    public var variants               : [ Variant ]? // not in tutorial

    public var abstract               : [ InlineContent ]? // not in tutorial
    public var sections               : [ Section ]
    public var topicSections          : [ Section ]?
    public var seeAlsoSections        : [ Section ]?
    public var primaryContentSections : [ Section ]?
    public var references             : [ String : Reference ]

    public var description: String {
      var ms = "<Document: "
      ms += " schemaVersion=\(schemaVersion)"
      ms += " identifier=\(identifier)"
      ms += " documentVersion=\(documentVersion)"
      ms += " kind=\(kind)"
      ms += " metadata=\(metadata)"
      ms += " hierarchy=\(hierarchy)"

      if let v = variants        { ms += " #variants=\(v.count)"         }
      if let v = abstract        { ms += " #abstract=\(v.count)"         }
      if let v = topicSections   { ms += " #topicSections=\(v.count)"    }
      if let v = seeAlsoSections { ms += " #seeAlsoSections=\(v.count)"  }

      ms += " #sections=\(sections.count)"
      if let v = primaryContentSections {
        ms += " #primaryContentSections=\(v.count)"
      }

      if references.isEmpty { ms += " no-refs" }
      else { ms += " #refs=\(references.count)" }
      ms += ">"
      return ms
    }
  }
}
