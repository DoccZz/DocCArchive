//
//  Identifier.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension DocCArchive.DocCSchema_0_1 {

  /**
   * A full URL based identifier, with an optional language.
   *
   * In most places DocC just seems to use plain string identifiers.
   */
  public struct Identifier: Hashable, Codable, CustomStringConvertible {
    
    public var url               : URL
    public var interfaceLanguage : InterfaceLanguage?
    
    @inlinable
    public init(url: URL, interfaceLanguage: InterfaceLanguage? = nil) {
      self.url               = url
      self.interfaceLanguage = interfaceLanguage
    }
    
    @inlinable
    public var stringValue : String { return url.absoluteString } // Hm.
    
    public var description: String {
      var ms = "ID[\(url.absoluteString)"
      if let s = interfaceLanguage { ms += ", lang=\(s)" }
      ms += "]"
      return ms
    }

    // MARK: - Codable

    private enum CodingKeys: String, CodingKey {
      case url, interfaceLanguage
    }

    public init(from decoder: Decoder) throws {
      do {
        let container = try decoder.singleValueContainer()
        self.init(url: try container.decode(URL.self))
      }
      catch {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
          self.init(
            url: try container.decode(URL.self, forKey: .url),
            interfaceLanguage:
              try container.decode(InterfaceLanguage?.self,
                                   forKey: .interfaceLanguage)
          )
        }
        catch {
          print("ERROR:", error)
          throw error
        }
      }
    }
    public func encode(to encoder: Encoder) throws {
      if let interfaceLanguage = interfaceLanguage {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url               , forKey: .url)
        try container.encode(interfaceLanguage , forKey: .interfaceLanguage)
      }
      else {
        var container = encoder.singleValueContainer()
        try container.encode(url)
      }
    }
  }
}
