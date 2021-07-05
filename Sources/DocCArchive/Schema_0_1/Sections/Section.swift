//
//  SeeAlsoSection.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  public enum RelationshipType: String, Equatable, Codable {
    case conformsTo
  }
  
  public struct Section: Equatable, CustomStringConvertible, Codable {

    public enum Kind: Equatable, CustomStringConvertible {
      case generic
      case relationships(RelationshipType)
      case declarations ([ Declaration ])
      case content      ([ Content ])
      case hero         (Hero)
      case volume       (Volume)
      case parameters   ([ Parameter ])
      case tasks        ([ Task      ])

      public var description: String {
        switch self {
          case .generic: return "generic"
          case .relationships(let type)    : return "relship=\(type)"
          case .declarations (let decls)   : return "\(decls)"
          case .content      (let content) : return "\(content)"
          case .hero         (let hero)    : return "\(hero)"
          case .volume       (let volume)  : return "\(volume)"
          case .parameters   (let params)  : return "\(params)"
          case .tasks        (let tasks)   : return "\(tasks)"
        }
      }
    }
    
    public var kind        : Kind
    
    // FIXME: Those are really kind specific
    public var title       : String?
    public var identifiers : [ Identifier ]
    public var generated   = true
    

    public var description: String {
      var ms = identifiers.isEmpty ? "<Section:" : "<Section[\(identifiers)]:"
      if let s = title { ms += " “\(s)”" }
      
      switch kind {
        case .generic: break
        case .relationships, .declarations, .content, .hero, .volume,
             .parameters, .tasks:
          ms += " \(kind)"
      }

      if generated { ms += " generated" }
      ms += ">"
      return ms
    }

    // - MARK: Codable

    private enum CodingKeys: String, CodingKey {
      case title, identifiers, generated, kind
      case type         // relationships
      case declarations // same kind
      case content      // same kind
      case parameters   // same kind
      case tasks        // same kind
    }
    
    public init(from decoder: Decoder) throws {
      do { // DEBUG
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      title       = try container.decodeIfPresent(String.self, forKey:  .title)
      identifiers = try container.decodeIfPresent([ Identifier ].self,
                                                  forKey: .identifiers)
                 ?? []
      generated   = try container.decodeIfPresent(Bool.self, forKey: .generated)
                 ?? false
      
      if let kind = try container.decodeIfPresent(String.self, forKey: .kind) {
        switch kind {
          case "relationships":
            let type = try container.decode(RelationshipType.self,
                                            forKey: .type)
            self.kind = .relationships(type)
          case "declarations":
            let declarations = try container.decode([ Declaration ].self,
                                                    forKey: .declarations)
            self.kind = .declarations(declarations)
          case "parameters":
            let parameters = try container.decode([ Parameter ].self,
                                                  forKey: .parameters)
            self.kind = .parameters(parameters)
          case "tasks":
            let tasks = try container.decode([ Task ].self, forKey: .tasks)
            self.kind = .tasks(tasks)
          case "content":
            let content = try container.decode([ Content ].self,
                                               forKey: .content)
            self.kind = .content(content)
          case "hero":
            let content = try Hero(from: decoder)
            self.kind = .hero(content)
          case "volume":
            let content = try Volume(from: decoder)
            self.kind = .volume(content)

          default:
            throw DocCArchiveLoadingError.unsupportedSectionKind(kind)
        }
      }
      else {
        kind = .generic
      }
      }
      catch {
        print("ERROR:", error)
        throw error
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      try container.encode(title       , forKey: .title)
      try container.encode(identifiers , forKey: .identifiers)
      if generated { try container.encode(generated, forKey: .generated) }
      
      switch kind {
        case .generic:
          break
        case .relationships(let type):
          try container.encode("relationships" , forKey: .kind)
          try container.encode(type            , forKey: .type)
        case .declarations(let declarations):
          try container.encode("declarations"  , forKey: .kind)
          try container.encode(declarations    , forKey: .declarations)
        case .parameters(let parameters):
          try container.encode("parameters"    , forKey: .kind)
          try container.encode(parameters      , forKey: .parameters)
        case .tasks(let tasks):
          try container.encode("tasks"         , forKey: .kind)
          try container.encode(tasks           , forKey: .tasks)
        case .content(let content):
          try container.encode("content"       , forKey: .kind)
          try container.encode(content         , forKey: .content)
        case .hero(let content):
          try container.encode("hero"          , forKey: .kind)
          try content.encode(to: encoder)
        case .volume(let content):
          try container.encode("chapter"       , forKey: .kind)
          try content.encode(to: encoder)
      }
    }
  }
}
