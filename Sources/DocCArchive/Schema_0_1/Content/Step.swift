//
//  Step.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Content {

  public struct Step: Equatable, CustomStringConvertible, Codable {
    
    // type: "step", assuming there is no other
    
    // often empty
    public var caption        : [ DocCArchive.DocCSchema_0_1.Content ]
    public var content        : [ DocCArchive.DocCSchema_0_1.Content ]
    
    /// The identifier of the code (covered in the references of the
    /// document).
    public var code           : String?
    
    /// The identifier of an image (part of the document references).
    public var media          : String?
    
    /// The identifier of an image showing how the thing would look
    /// at runtime (part of the document references).
    public var runtimePreview : String?

    public var description: String {
      var ms = "<Step:"
      if caption.count == 1    { ms += " caption=\(caption[0])"     }
      else if !caption.isEmpty { ms += " #caption=\(caption.count)" }
      if content.count == 1    { ms += " \(content[0])"     }
      else if !content.isEmpty { ms += " #\(content.count)" }
      
      if let s = code           { ms += " code=\(s)"    }
      if let s = media          { ms += " media=\(s)"   }
      if let s = runtimePreview { ms += " preview=\(s)" }
      ms += ">"
      return ms
    }
  }
}
