//
//  FileReference.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  public struct FileReference: Equatable, Codable, CustomStringConvertible {
    
    public enum FileType: String, Codable {
      case swift
    }
    public struct Highlight: Equatable, Codable {
      public var line : Int
    }
    
    public var identifier : String
    
    /// The display name of the file
    public var fileName   : String // "CustomizedSlothView.swift"

    public var fileType   : FileType
    public var content    : [ String ]
    public var highlights : [ Highlight ]

    public var description: String {
      var ms = "<File[\(identifier)]: \(fileName) \(fileType)"
      if content.isEmpty     { ms += " EMPTY"                           }
      else                   { ms += " #lines=\(content.count)"         }
      if !highlights.isEmpty { ms += " #highlights=\(highlights.count)" }
      ms += ">"
      return ms
    }
  }
}
