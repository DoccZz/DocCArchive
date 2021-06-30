//
//  VolumeSection.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Volume: Equatable, Codable {
    
    public var name     : String?
    public var image    : String?
    public var content  : [ DocCArchive.DocCSchema_0_1.Content ]
    public var chapters : [ DocCArchive.DocCSchema_0_1.Chapter ]
  }
}
