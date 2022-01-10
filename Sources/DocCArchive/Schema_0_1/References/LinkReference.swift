//
//  LinkReference.swift
//  DocCArchive
//
//  Copyright © 2021-22 ZeeZide GmbH. All rights reserved.
//

import Foundation

extension DocCArchive.DocCSchema_0_1 {

  public struct LinkReference: Equatable, Codable, CustomStringConvertible {

    public var identifier         : String
    public var title              : String
    public var titleInlineContent : [ InlineContent ]
    public var url                : URL

    public var description: String {
      "<Link[\(identifier)]: \(url)>"
    }
  }
}
