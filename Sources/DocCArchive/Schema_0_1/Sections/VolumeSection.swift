//
//  VolumeSection.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Volume: Equatable, CustomStringConvertible, Codable {
    
    public var name     : String?
    public var image    : String?
    public var content  : [ DocCArchive.DocCSchema_0_1.Content ]
    public var chapters : [ DocCArchive.DocCSchema_0_1.Chapter ]
    
    public var description: String {
      var ms = "<Volume:"
      if let s = name      { ms += " “\(s)”"      }
      if let s = image     { ms += " image=\(s)"  }
      if !content .isEmpty { ms += " \(content)"  }
      if !chapters.isEmpty { ms += " \(chapters)" }
      ms += ">"
      return ms
    }
  }
}
