//
//  Parameter.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Parameter: Equatable, Codable {

    public var name      : String
    public var content   : [ DocCArchive.DocCSchema_0_1.Content ]
  }
}
