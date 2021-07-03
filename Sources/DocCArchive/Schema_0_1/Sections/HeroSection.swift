//
//  HeroSection.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Hero: Equatable, Codable {
    
    public struct Action: Equatable, Codable {
      
      public enum ActionType: String, Codable {
        case reference
      }
      
      public var isActive                     : Bool
      public var type                         : ActionType
      public var identifier                   : String // Identifier or not?
      public var overridingTitle              : String
      public var overridingTitleInlineContent
                 : [ DocCArchive.DocCSchema_0_1.InlineContent ]
    }
    
    public var image                  : String // type that out?
    public var backgroundImage        : String
    public var content                : [ DocCArchive.DocCSchema_0_1.Content ]
    public var action                 : Action?
    
    public var estimatedTimeInMinutes : Int?
    public var chapter                : String?
  }
}
