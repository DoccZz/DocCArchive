//
//  MetaData.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {
  
  // TBD: Probably needs a Raw decoding helper?
  
  public enum Role: Equatable, Codable, CustomStringConvertible {
    // There is also a Role in Reference, but w/o symbolKind?
    case symbol(SymbolKind?)
    case pseudoSymbol
    case overview
    case collection
    case collectionGroup
    case article
    case project
    
    public var description: String {
      switch self {
        case .symbol(.some(let v)) : return "symbol(\(v))"
        case .symbol(.none)        : return "symbol"
        case .pseudoSymbol         : return "pseudoSymbol"
        case .overview             : return "overview"
        case .collection           : return "collection"
        case .collectionGroup      : return "collectionGroup"
        case .article              : return "article"
        case .project              : return "project"
      }
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let key = try container.decode(String.self)
      switch key {
        case "symbol"          : self = .symbol(nil)
        case "pseudoSymbol"    : self = .pseudoSymbol
        case "overview"        : self = .overview
        case "collection"      : self = .collection
        case "collectionGroup" : self = .collectionGroup
        case "article"         : self = .article
        case "project"         : self = .project
        default:
          throw DocCArchiveLoadingError.unsupportedRole(key)
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
        case .symbol          : try container.encode("symbol")
        case .pseudoSymbol    : try container.encode("pseudoSymbol")
        case .overview        : try container.encode("overview")
        case .collection      : try container.encode("collection")
        case .collectionGroup : try container.encode("collectionGroup")
        case .article         : try container.encode("article")
        case .project         : try container.encode("project")
      }
    }
  }
  
  public enum SymbolKind: String, Codable, CustomStringConvertible {
    case `struct`, `module`, method, `init`, property, `enum`, `case`, op
    case `protocol`, `class`
    
    public var description: String { return rawValue }
  }
  
  public enum RoleHeading: String, Codable, CustomStringConvertible {
    // or just a plain string?
    case structure        = "Structure"
    case framework        = "Framework"
    case instanceMethod   = "Instance Method"
    case initializer      = "Initializer"
    case instanceProperty = "Instance Property"
    case enumeration      = "Enumeration"
    case `case`           = "Case"
    case `operator`       = "Operator"
    case article          = "Article"
    case `protocol`       = "Protocol"
    case typeProperty     = "Type Property"
    case alias            = "Alias"
    case `class`          = "Class"

    public var description: String { return "<RoleHeading: \(rawValue)>" }
  }

  public struct Module: Equatable, Codable, CustomStringConvertible {
    public var name : String

    public var description: String { return "<Module: \(name)>" }
  }

  public struct MetaData: Equatable, Codable, CustomStringConvertible {
    
    public var role                  : Role
    public var roleHeading           : RoleHeading? // not in tutorial
    public var title                 : String
    public var externalID            : String?
    public var navigatorTitle        : Block?
    public var fragments             : Block
    public var modules               : [ Module   ]
    public var estimatedTime         : String?
    public var category              : String?
    public var categoryPathComponent : String?

    public var description: String {
      var ms = "<Meta:"
      ms += " \(role)"
      if let s = roleHeading    { ms += "(“\(s.rawValue)”)"          }
      if !title.isEmpty         { ms += " “\(title)”"                }
      if let s = externalID     { ms += " extid=\(s)"                }
      if !fragments.isEmpty     { ms += " #frags=\(fragments.count)" }
      if !modules  .isEmpty     { ms += " #modules=\(modules.count)" }
      if let s = category       { ms += " category=“\(s)”"           }
      if let s = categoryPathComponent { ms += "(\(s))"              }
      if let s = estimatedTime  { ms += " time=“\(s)”"               }
      if let _ = navigatorTitle { ms += " has-title"                 }
      ms += ">"
      return ms
    }

    // - MARK: Codable

    private enum MetaDataCodingKeys: String, CodingKey {
      case fragments, title, roleHeading, role, symbolKind, externalID, modules
      case navigatorTitle
      // overview
      case estimatedTime, category, categoryPathComponent
    }
    
    public init(from decoder: Decoder) throws {
      do {
      let container = try decoder.container(keyedBy: MetaDataCodingKeys.self)
      
      title       = try container.decode(String.self, forKey: .title)
      externalID  = try container.decodeIfPresent(String.self,
                                                  forKey: .externalID)
      roleHeading =
        try container.decodeIfPresent(RoleHeading.self, forKey:  .roleHeading)
      
      navigatorTitle = try container.decodeIfPresent(Block.self,
                                                     forKey: .navigatorTitle)

      estimatedTime =
        try container.decodeIfPresent(String.self, forKey: .estimatedTime)
      category      =
        try container.decodeIfPresent(String.self, forKey: .category)
      categoryPathComponent =
        try container.decodeIfPresent(String.self,
                                      forKey: .categoryPathComponent)

      let role = try container.decode(String.self, forKey: .role)
      switch role {
        case "symbol":
          let kind = try container.decode(SymbolKind.self, forKey: .symbolKind)
          self.role = .symbol(kind)
        case "overview"        : self.role = .overview
        case "collection"      : self.role = .collection
        case "collectionGroup" : self.role = .collectionGroup
        case "article"         : self.role = .article
        case "project"         : self.role = .project
        default:
          throw DocCArchiveLoadingError.unsupportedMetaDataRole(role)
      }
      
      fragments = try container.decodeIfPresent(Block.self, forKey: .fragments)
               ?? []
      modules   = try container.decodeIfPresent([Module].self, forKey: .modules)
               ?? []
      }
      catch {
        print("ERROR:", error)
        throw error
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: MetaDataCodingKeys.self)
      
      try container.encode(title          , forKey: .title)
      try container.encode(roleHeading    , forKey: .roleHeading)
      try container.encode(externalID     , forKey: .externalID)
      try container.encode(navigatorTitle , forKey: .navigatorTitle)
      try container.encode(estimatedTime  , forKey: .estimatedTime)
      try container.encode(category       , forKey: .category)
      try container.encode(categoryPathComponent,
                           forKey: .categoryPathComponent)

      switch role { // TODO: move to Role type (singlevaluecontainer)
        case .symbol(let kind):
          try container.encode("symbol" , forKey: .role)
          try container.encode(kind     , forKey: .symbolKind)
        case .pseudoSymbol : try container.encode("pseudoSymbol", forKey: .role)
        case .overview     : try container.encode("overview"    , forKey: .role)
        case .article      : try container.encode("article"     , forKey: .role)
        case .project      : try container.encode("project"     , forKey: .role)
        case .collection   : try container.encode("collection"  , forKey: .role)
        case .collectionGroup:
          try container.encode("collectionGroup", forKey: .role)
      }
      
      if !fragments.isEmpty {
        try container.encode(fragments, forKey: .fragments)
      }
      if !modules.isEmpty {
        try container.encode(modules, forKey: .modules)
      }
    }
  }
}
