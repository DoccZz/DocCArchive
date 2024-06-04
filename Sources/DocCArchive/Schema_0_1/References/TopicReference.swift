//
//  TopicReference.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension DocCArchive.DocCSchema_0_1 {
  
  public struct TopicReference: Equatable, CustomStringConvertible, Codable {
    
    // Looks like Kind & Role are the same? - I think they scope differently
    public enum Kind: String, Codable {
      case symbol, article, overview, project, section
    }
    
    // Samples:
    // `doc://TARGET/documentation/TARGET/TYPE`
    // `myproject-intro.png`
    public var identifier     : String
    
    public var kind           : Kind?
    public var role           : Role?
    public var title          : String
    public var fragments      : Block?
    public var abstract       : [ InlineContent ]
    public var navigatorTitle : Block?
    public var estimatedTime  : String?
    public var url            : URL?  // `/documentation/TARGET/TYPE`
    public var deprecated     : Bool?

    public var description: String {
      var ms = "<TopicRef[\(identifier)]: "
      if !title.isEmpty           { ms += " “\(title)”"                  }
      if let v = role             { ms += " role=\(v)"                   }
      if let v = kind             { ms += " kind=\(v.rawValue)"          }
      if let v = url              { ms += " \(v.absoluteString)"         }
      if let v = estimatedTime    { ms += " time=\(v)"                   }
      
      if      abstract.isEmpty    { ms += " no-abstract" }
      else if abstract.count == 1 { ms += " \(abstract[0])" }
      else                        { ms += " #abstract=\(abstract.count)" }
      
      if let v = navigatorTitle   { ms += " #nav-title=\(v.count)"       }
      if let v = fragments        { ms += " #fragments=\(v.count)"       }
      if let v = deprecated, v    { ms += " deprecated"                  }

      ms += ">"
      return ms
    }
  }
}
