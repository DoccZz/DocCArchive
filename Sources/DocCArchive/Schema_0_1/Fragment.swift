//
//  Fragment.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {
  
  /// An array of fragments (runs)
  public typealias Block = [ Fragment ]

  /**
   * A single run of a Block.
   *
   * Still a little unsure what that is. It is used in sections, but also
   * in declarations.
   */
  public enum Fragment: Equatable, Codable, CustomStringConvertible {
    // TBD: InlineContent vs Fragment?
    // Fragments have a 'kind', InlineContent has a 'type'
    
    case text            (String)
    case keyword         (String)
    case identifier      (String)
    case externalParam   (String)
    case internalParam   (String)
    
    // A generic parameter is the `T` in `Array<T>` (string w/o the `<>`)
    case genericParameter(String)
    
    /// An attribute, like `@IBInspectable`
    case attribute(String)
    
    // Those carry identifier/preciseIdentifier within declarations, but not in
    // fragments (e.g. as part of references).
    case typeIdentifier  (text: String, identifier: Identifier?,
                          preciseIdentifier: TypeIdentifier?)

    @inlinable
    public var stringValue: String {
      switch self {
        case .keyword          (let s)       : return s
        case .text             (let s)       : return s
        case .identifier       (let s)       : return s
        case .externalParam    (let s)       : return s
        case .internalParam    (let s)       : return s
        case .genericParameter (let s)       : return s
        case .attribute        (let s)       : return s
        case .typeIdentifier   (let s, _, _) : return s
      }
    }

    public var description: String {
      switch self {
        case .keyword          (let s): return "`\(s)`"
        case .text             (let s): return "“\(s)”"
        case .identifier       (let s): return s
        case .externalParam    (let s): return "<ExtPara: \(s)>"
        case .internalParam    (let s): return "<IntPara: \(s)>"
        case .genericParameter (let s): return "<GPara: \(s)>"
        case .attribute        (let s): return "<Attr: \(s)>"

        case .typeIdentifier   (let text, .some(let id), .some(let tid)):
          return "<TypeIdentifier[\(id)]: “\(text)” \(tid)>"
        case .typeIdentifier   (let text, .some(let id), .none):
          return "<TypeIdentifier[\(id)]: “\(text)”>"
        case .typeIdentifier   (let text, .none, .some(let tid)):
          return "<TypeIdentifier: “\(text)” \(tid)>"
        case .typeIdentifier   (let text, .none, .none):
          return "<TypeIdentifier: “\(text)”>"
      }
    }
    
    // MARK: - Codable
    
    private enum FragmentCodingKeys: String, CodingKey {
      case kind, text, preciseIdentifier, identifier
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: FragmentCodingKeys.self)
      
      let kind = try container.decode(String.self, forKey: .kind)
      func text() throws -> String {
        try container.decode(String.self, forKey: .text)
      }
      
      switch kind {
        case "keyword"          : self = .keyword         (try text())
        case "text"             : self = .text            (try text())
        case "identifier"       : self = .identifier      (try text())
        case "externalParam"    : self = .externalParam   (try text())
        case "internalParam"    : self = .internalParam   (try text())
        case "genericParameter" : self = .genericParameter(try text())
        case "attribute"        : self = .attribute       (try text())

        case "typeIdentifier":
          let id  = try container.decodeIfPresent(
                          Identifier.self, forKey: .identifier)
          let tid = try container.decodeIfPresent(
                          TypeIdentifier.self, forKey: .preciseIdentifier)
          self = .typeIdentifier(text: try text(), identifier: id,
                                 preciseIdentifier: tid)
        default:
          throw DocCArchiveLoadingError.unsupportedFragmentKind(kind)
      }
    }
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: FragmentCodingKeys.self)
      
      try container.encode(kindString, forKey: .kind)
      
      switch self {
        case .keyword(let v), .text(let v), .identifier(let v),
             .externalParam(let v), .internalParam(let v),
             .genericParameter(let v), .attribute(let v):
          try container.encode(v, forKey: .text)
          
        case .typeIdentifier(let text, let id, let tid):
          try container.encode(text, forKey: .text)
          if let v = id  { try container.encode(v, forKey: .identifier)        }
          if let v = tid { try container.encode(v, forKey: .preciseIdentifier) }
      }
    }
    
    private var kindString: String {
      switch self {
        case .keyword          : return "keyword"
        case .text             : return "text"
        case .identifier       : return "identifier"
        case .externalParam    : return "externalParam"
        case .internalParam    : return "internalParam"
        case .genericParameter : return "genericParameter"
        case .typeIdentifier   : return "typeIdentifier"
        case .attribute        : return "attribute"
      }
    }
  }
}
