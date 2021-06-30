//
//  Task.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  public struct Task: Equatable, Codable {

    public var title     : String
    public var anchor    : String
    
    // TODO:
    // - contentSection
    // - stepsSection
  }
}