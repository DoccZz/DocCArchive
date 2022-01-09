//
//  Content.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021-2022 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  /**
   * Content in a ``Section`` or a ``Chapter``.
   * E.g. headings, paragraphs and lists. Also "steps" for tutorials.
   *
   * Don't confuse this actual ``Content`` with a (`"kind": "content"`)
   * ``Section/Kind-swift.enum/content(_:)``.
   */
  public enum Content: Equatable, CustomStringConvertible, Codable {
    
    public enum Style: String, Codable {
      case note
      case warning
      case important
      case tip
      case experiment
    }
    
    /**
     * An item within a ``unorderedList(_:)`` or ``orderedList(_:)``
     * ``Content`` value.
     * Just a list of more ``Content`` rendered as part of the item.
     */
    public struct Item: Equatable, Codable {
      public var content : [ Content ]
    }
    
    public enum TableHeaderKind: String, Codable, Equatable  {
      /**
       * Presumably there are more styles but `row`. `row` is the result of
       * this Markdown:
       * ```
       * | Column 1 Title | Column 2 Title       |
       * | -------------- | -------------------- |
       * | `case 1`       | Case 1 description.  |
       * | `case 2`       | Case 2 description.  |
       * ```
       */
      
      /// This seems to say that the first row is the header row.
      case row
    }
    
    /**
     * A ``TableCell`` is an array of nested ``Content`` values,
     * similar to ``Item``.
     * It is kept as part of a ``TableRow``.
     */
    public typealias TableCell = [ Content ]
    
    /**
     * A ``TableRow`` is an array of ``TableCell``s,
     * which themselves are just arrays of ``Content`` values.
     */
    public typealias TableRow = [ TableCell ]

    /**
     * A header, like an HTML H1/H2 tag.
     * Must have an anchor ID, a level (1..6 presumably) and a plain text.
     *
     * Looks like this in JSON:
     *
     *     { "anchor": "overview",
     *       "level": 2,
     *       "type": "heading",
     *       "text": "Overview" }
     */
    case heading      (text: String, anchor: String, level: Int)
    
    case aside        (style: Style, content: [ Content ])
    case paragraph    (inlineContent: [ InlineContent ])
    case codeListing  (CodeListing)
    
    /// A step of a tutorial
    case step         (Step)
    
    case orderedList  ([ Item ])
    case unorderedList([ Item ])
    
    /**
     * A table, usually written as Markdown.
     *
     * The headerKind supported so far is ``TableHeaderKind/row``,
     * let us know if others exist.
     *
     * The table is represented by a set of ``TableRow``s,
     * which is just an array of ``TableCell``s,
     * which are just an array of nested ``Content`` values.
     * 
     * Example:
     * ```
     * | Column 1 Title | Column 2 Title       |
     * | -------------- | -------------------- |
     * | `case 1`       | Case 1 description.  |
     * | `case 2`       | Case 2 description.  |
     * ```
     */
    case table(headerKind: TableHeaderKind, rows: [ TableRow ])
    
    
    // MARK: - Description

    public var description: String {
      switch self {
        case .heading    (let text, let anchor, let level):
          var ms = "<h\(level)"
          if !anchor.isEmpty { ms += " #\(anchor)" }
          if !text  .isEmpty { ms += " “\(text)”"  }
          return ms + ">"
        case .aside      (let style, let content):
          return "<aside[\(style)]: \(content)>"
        case .orderedList  (let items)    : return "<ol>\(items)</ol>"
        case .unorderedList(let items)    : return "<ul>\(items)</ul>"
        case .paragraph    (let icontent) : return "<p>\(icontent)</p>"
        case .codeListing  (let code)     : return code.description
        case .step         (let step)     : return step.description
        case .table(let header, let rows) :
          return "<table header=\(header)>\(rows)</table>"
      }
    }

    
    // - MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
      case content, anchor, level, type, text, style, inlineContent, items
      case header, rows
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
        case "orderedList":
          let content = try container.decode([ Item ].self, forKey: .items)
          self = .orderedList(content)
        case "unorderedList":
          let content = try container.decode([ Item ].self, forKey: .items)
          self = .unorderedList(content)
        case "paragraph":
          let content = try container.decode([ InlineContent ].self ,
                                             forKey: .inlineContent)
          self = .paragraph(inlineContent: content)
        case "codeListing":
          let content = try CodeListing(from: decoder)
          self = .codeListing(content)
        case "step":
          let content = try Step(from: decoder)
          self = .step(content)
        case "table":
          let headerKind =
            try container.decode(TableHeaderKind.self, forKey: .header)
          let rows = try container.decode([ TableRow ].self, forKey: .rows)
          self = .table(headerKind: headerKind, rows: rows)
        default:
          throw DocCArchiveLoadingError.unsupportedContentType(type)
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      switch self {
        case .heading(let text, let anchor, let level):
          try container.encode("heading"       , forKey: .type)
          try container.encode(text            , forKey: .text)
          try container.encode(anchor          , forKey: .anchor)
          try container.encode(level           , forKey: .level)
        case .aside(let style, let content):
          try container.encode("aside"         , forKey: .type)
          try container.encode(style           , forKey: .style)
          try container.encode(content         , forKey: .content)
        case .unorderedList(let items):
          try container.encode("unorderedList" , forKey: .type)
          try container.encode(items           , forKey: .items)
        case .orderedList(let items):
          try container.encode("orderedList"   , forKey: .type)
          try container.encode(items           , forKey: .items)
        case .paragraph(let content):
          try container.encode("paragraph"     , forKey: .type)
          try container.encode(content         , forKey: .inlineContent)
        case .codeListing(let content):
          try container.encode("codeListing"   , forKey: .type)
          try content.encode(to: encoder)
        case .step(let content):
          try container.encode("step"          , forKey: .type)
          try content.encode(to: encoder)
        case .table(let headerKind, let rows):
          try container.encode("table"         , forKey: .type)
          try container.encode(headerKind      , forKey: .header)
          try container.encode(rows            , forKey: .rows)
      }
    }
  }
}
