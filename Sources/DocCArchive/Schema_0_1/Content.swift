//
//  Content.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  /**
   * Content in a ``Section`` or a ``Chapter``.
   */
  public enum Content: Equatable, Codable {
    
    public enum Style: String, Codable {
      case note
    }

    public struct CodeListing: Equatable, Codable {
      public var syntax : String
      public var code   : [ String ]
    }

    case heading    (text: String, anchor: String, level: Int)
    case aside      (style: Style, content: [ Content ])
    case paragraph  (inlineContent: [ InlineContent ])
    case codeListing(CodeListing)

    // - MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
      case content, anchor, level, type, text, style, inlineContent
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let type      = try container.decode(String.self, forKey: .type)
      
      switch type {
        case "heading":
          let text   = try container.decode(String.self, forKey:  .text)
          let anchor = try container.decode(String.self, forKey:  .anchor)
          let level  = try container.decode(Int.self, forKey:  .level)
          self = .heading(text: text, anchor: anchor, level: level)
        case "aside":
          let style   = try container.decode(Style.self     , forKey: .style)
          let content = try container.decode([Content].self , forKey: .content)
          self = .aside(style: style, content: content)
        case "paragraph":
          let content = try container.decode([ InlineContent ].self ,
                                             forKey: .inlineContent)
          self = .paragraph(inlineContent: content)
        case "codeListing":
          let content = try CodeListing(from: decoder)
          self = .codeListing(content)
        default:
          throw DocCArchiveLoadingError.unsupportedContentType(type)
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      switch self {
        case .heading(let text, let anchor, let level):
          try container.encode("heading" , forKey: .type)
          try container.encode(text      , forKey: .text)
          try container.encode(anchor    , forKey: .anchor)
          try container.encode(level     , forKey: .level)
        case .aside(let style, let content):
          try container.encode("aside"       , forKey: .type)
          try container.encode(style         , forKey: .style)
          try container.encode(content       , forKey: .content)
        case .paragraph(let content):
          try container.encode("paragraph"   , forKey: .type)
          try container.encode(content       , forKey: .inlineContent)
        case .codeListing(let content):
          try container.encode("codeListing" , forKey: .type)
          try content.encode(to: encoder)
      }
    }
  }
}