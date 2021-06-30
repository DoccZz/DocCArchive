//
//  TypeIdentifier.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension DocCArchive.DocCSchema_0_1 {
  
  // Swift mangled name, e.g. s:12ZlozzZzeatoz7ZabitazZ or
  // `s:10Foundation4DateV`
  // `s` for struct, then the length encoded strings etc.
  public struct TypeIdentifier: Hashable, Codable, CustomStringConvertible {
    
    public var mangledName : String
    
    @inlinable
    public init(mangledName: String) { self.mangledName = mangledName }

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      self.init(mangledName: try container.decode(String.self))
      assert(!mangledName.isEmpty)
    }
    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(mangledName)
    }
    
    @inlinable
    public var symbolKind: SymbolKind? {
      switch mangledName.first {
        case "s": return .struct
        case "c": return .class
        default:
          assertionFailure("unexpected symbol kind \(mangledName)")
          return nil
      }
    }
    
    public var parts : [ String ] {
      guard let idx = mangledName.firstIndex(of: ":") else { return [] }
      return parseRLEParts(in: mangledName[mangledName.index(after: idx)...])
               .parts.map(String.init)
    }

    public var description: String {
      return "TypeID[\(mangledName)]"
    }
  }
}

import Foundation

fileprivate func parseRLEParts(in string: Substring)
                 -> ( parts: [ Substring ], suffix: Substring )
{
  // Oh yes, this is dirty!
  guard !string.isEmpty else { return ( [], string[...] ) }
  var parts = [ Substring ]()
  var start = string.startIndex
  
  while start < string.endIndex {
    let count = Int(atoi(String(string[start...]))) // stops on first letter
    if count < 1 { break }
    
    let countLen = String(count).count // ouch :-)
    start   = string.index(start, offsetBy: countLen)
    let end = string.index(start, offsetBy: count)
    
    parts.append(string[start..<end])
    start = end
  }
  
  return ( parts, string[start...] ) // FIXME
}
