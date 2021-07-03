//
//  Task.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1.Section {

  /**
   * A task is one section in a tutorial.
   *
   * E.g. in SlothCreator:
   *
   *   Section 1
   *   Create a new project and add SlothCreator
   *
   */
  public struct Task: Equatable, Codable {

    public var title     : String
    public var anchor    : String
    
    // TODO:
    // - contentSection
    // - stepsSection
  }
}
