//
//  InlineContent.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {
  
  public enum InlineContent: Equatable, CustomStringConvertible, Codable {
    // TBD: Fragment vs InlineContent
    // Fragments have a 'kind', InlineContent has a 'type'

    case text     (String)
    case reference(identifier: Identifier, isActive: Bool)
    case image    (identifier: String)
    case emphasis ([ InlineContent ])
    case codeVoice(code: String)
    
    public var description: String {
      switch self {
        case .text     (let s)       :  return "“\(s)”"
        case .reference(let id, let isActive):
          return "\(id)\(isActive ? "" : "-inactive")"
        case .image    (let id)      : return "<img \(id)>"
        case .emphasis (let content) : return "*\(content)*"
        case .codeVoice(let code)    : return "`\(code)`"
      }
    }

    // - MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
      case type, text, identifier, isActive, inlineContent, code
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let kind = try container.decode(String.self, forKey: .type)
      
      switch kind {
        case "text":
          self = .text(try container.decode(String.self, forKey: .text))
        case "codeVoice":
          self = .codeVoice(code:
                    try container.decode(String.self, forKey: .code))
        case "image":
          self = .image(identifier:
                        try container.decode(String.self, forKey: .identifier))
        case "emphasis":
          self = .emphasis(try container.decode([ InlineContent ].self,
                                                forKey: .inlineContent))
        case "reference":
          self = .reference(
            identifier:
              try container.decode(Identifier.self, forKey: .identifier),
            isActive:
              try container.decodeIfPresent(Bool.self, forKey: .isActive)
              ?? true
          )
        default:
          throw DocCArchiveLoadingError.unsupportedInlineContentType(kind)
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      switch self {
        case .text(let text):
          try container.encode("text"      , forKey: .type)
          try container.encode(text        , forKey: .text)
        case .codeVoice(let code):
          try container.encode("codeVoice" , forKey: .type)
          try container.encode(code        , forKey: .code)
        case .image(let identifier):
          try container.encode("image"     , forKey: .type)
          try container.encode(identifier  , forKey: .identifier)
        case .emphasis(let content):
          try container.encode("emphasis"  , forKey: .type)
          try container.encode(content     , forKey: .inlineContent)
        case .reference(let identifier, let isActive):
          try container.encode("reference" , forKey: .type)
          try container.encode(identifier  , forKey: .identifier)
          try container.encode(isActive    , forKey: .isActive)
      }
    }
  }
}
