//
//  Reference.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension DocCArchive.DocCSchema_0_1 {

  /**
   * A reference record is kept in the documents "references" section. It
   * contains all the necessary meta data for references the document links to.
   * Can be files, images, topics, sections, etc.
   */
  public enum Reference: Equatable, Codable, CustomStringConvertible {

    case topic       (TopicReference)
    case image       (ImageReference)
    case file        (FileReference)
    case section     (SectionReference)
    case link        (LinkReference)
    case unresolvable(identifier: String, title: String)
    
    @inlinable
    public var identifier : String {
      switch self {
        case .topic       (let v)     : return v.identifier
        case .image       (let v)     : return v.identifier
        case .file        (let v)     : return v.identifier
        case .section     (let v)     : return v.identifier
        case .link        (let v)     : return v.identifier
        case .unresolvable(let id, _) : return id
      }
    }
    
    @inlinable
    public var identifierURL  : URL? { return URL(string: identifier) }

    @inlinable
    public var description: String {
      switch self {
        case .topic  (let v) : return v.description
        case .image  (let v) : return v.description
        case .file   (let v) : return v.description
        case .section(let v) : return v.description
        case .link   (let v) : return v.description
        case .unresolvable(let identifier, let title):
          return "<DeadRef[\(identifier)]: “\(title)”>"
      }
    }

    // - MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
      case type, identifier, title
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let kind      = try container.decode(String.self, forKey: .type)
      
      switch kind {
        case "image"   : self = .image  (try ImageReference  (from: decoder))
        case "topic"   : self = .topic  (try TopicReference  (from: decoder))
        case "file"    : self = .file   (try FileReference   (from: decoder))
        case "section" : self = .section(try SectionReference(from: decoder))
        case "link"    : self = .link   (try LinkReference   (from: decoder))
        case "unresolvable":
          let id = try container.decode(String.self, forKey: .identifier)
          self = .unresolvable(identifier: id, title:
                    try container.decode(String.self, forKey: .title))
        default:
          throw DocCArchiveLoadingError.unsupportedInlineContentType(kind)
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      switch self {
        case .image(let value):
          try container.encode("image"        , forKey: .type)
          try value.encode(to: encoder)
        case .topic(let value):
          try container.encode("topic"        , forKey: .type)
          try value.encode(to: encoder)
        case .file(let value):
          try container.encode("file"         , forKey: .type)
          try value.encode(to: encoder)
        case .section(let value):
          try container.encode("section"      , forKey: .type)
          try value.encode(to: encoder)
        case .link(let value):
          try container.encode("link"         , forKey: .type)
          try value.encode(to: encoder)
        case .unresolvable(let id, let value):
          try container.encode(id             , forKey: .identifier)
          try container.encode("unresolvable" , forKey: .type)
          try container.encode(value          , forKey: .title)
      }
    }
  }
}
