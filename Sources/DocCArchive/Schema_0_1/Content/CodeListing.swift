//
//  CodeListing.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Content {

  public struct CodeListing: Equatable, CustomStringConvertible, Codable {
    public var syntax : String?
    public var code   : [ String ]
    
    public var description: String {
        guard let syntax = syntax, !syntax.isEmpty else {
            return "<Code #\(code.count)>"
        }
        return "<Code[\(syntax)]: #\(code.count)>"
    }
  }
}
