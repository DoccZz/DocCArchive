//
//  Platform.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {
  
  public enum Platform: String, Codable {
    // TBD: Add `unknown` case?
    
    case macOS, iOS, tvOS, watchOS, linux
  }
}
