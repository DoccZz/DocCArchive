//
//  DocumentDecodingTests.swift
//  DocCArchiveTests
//
//  Created by Helge Heß.
//  Copyright © 2021-2022 ZeeZide GmbH. All rights reserved.
//

import XCTest
@testable import DocCArchive

final class DocumentDecodingTests: XCTestCase {

  static var allTests = [
    ( "testSimpleTutorial"               , testSimpleTutorial               ),
    ( "testIssue7Fail"                   , testIssue7Fail                   ),
    ( "testIssue9FailAttributeFragment"  , testIssue9FailAttributeFragment  ),
    ( "testIssue10FailTypeMethodRoleHeading",
      testIssue10FailTypeMethodRoleHeading ),
    ( "testIssue11FailUnorderedList"     , testIssue11FailUnorderedList     ),
    ( "testAllDataJSONInSlothCreator"    , testAllDataJSONInSlothCreator    ),
    ( "testIssue12FailAsideWarningStyle" , testIssue12FailAsideWarningStyle ),
    ( "testTableIssue6"                  , testTableIssue6 )
  ]
  
  func testTableIssue6() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("TableIssue6.json")
    let data = try Data(contentsOf: url)

    let document : DocCArchive.Document

    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
      
      let section = try XCTUnwrap(
        document.primaryContentSections?.dropFirst().first,
        "did not find section with table"
      )

      guard case .content(let contents) = section.kind else {
        XCTFail("did not find content section"); return
      }
      guard case .table(let header, let rows) = contents.dropFirst().first else {
        XCTFail("did not find table"); return
      }
      XCTAssertEqual(header, .row, "expected to find row-type header")
      XCTAssert(rows.count == 3) // 1 header row, 2 content rows
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }

  func testIssue12FailAsideWarningStyle() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("Issue12Fail.json")
    let data = try Data(contentsOf: url)

    let document : DocCArchive.Document

    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)

      guard let section = document.primaryContentSections?.first else {
        XCTFail("did not find primary content section"); return
      }
      guard case .content(let contents) = section.kind else {
        XCTFail("did not find content section"); return
      }
      guard case .aside(style: let style, content: let asideContents) = contents.dropFirst().first else {
        XCTFail("did not find aside"); return
      }
      XCTAssertEqual(style, .warning, "expected to find warning")
      XCTAssert(asideContents.count == 1)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }

  func testIssue11FailUnorderedList() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("Issue11Fail.json")
    let data = try Data(contentsOf: url)
    
    let document : DocCArchive.Document
    
    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
      
      guard let section = document.primaryContentSections?.first else {
        XCTFail("did not find primary content section"); return
      }
      guard case .content(let contents) = section.kind else {
        XCTFail("did not find content section"); return
      }
      guard case .unorderedList(let list) = contents.dropFirst().first else {
        XCTFail("did not find list"); return
      }
      XCTAssertEqual(list.count, 2)
      guard case .paragraph(let inlineContent) = list.last?.content.first else {
        XCTFail("did not find paragraph"); return
      }
      XCTAssertEqual(inlineContent.count, 2)
      guard case .reference(let id, let isActive, let ot, let otc) =
                    inlineContent.last else
      {
        XCTFail("did not find reference"); return
      }
      XCTAssertTrue(isActive)
      XCTAssertEqual(id, DocCArchive.DocCSchema_0_1.Identifier(
                           url: URL(string: "https://github.com/3Qax")!))
      XCTAssertEqual(ot         , "@3Qax")
      XCTAssertEqual(otc?.count , 1)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }
  
  func testIssue10FailTypeMethodRoleHeading() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("Issue10Fail.json")
    let data = try Data(contentsOf: url)
    
    let document : DocCArchive.Document
    
    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }

  func testIssue9FailAttributeFragment() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("Issue9Fail.json")
    let data = try Data(contentsOf: url)
    
    let document : DocCArchive.Document
    
    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }

  func testIssue7Fail() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("Issue7Fail.json")
    let data = try Data(contentsOf: url)
    
    let document : DocCArchive.Document
    
    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
  }

  func testSimpleTutorial() throws {
    let url  = Fixtures.baseURL.appendingPathComponent("SimpleTutorial.json")
    let data = try Data(contentsOf: url)
    
    let document : DocCArchive.Document
    
    print("Decoding:", url.path)
    do {
      document = try JSONDecoder().decode(DocCArchive.Document.self, from: data)
    }
    catch {
      print("ERROR:", error)
      XCTFail("failed to decode: \(error)")
      return
    }
    
    let docURL    = "doc://Dummy/tutorials/Dummy/Dummy-Tutorial"
    let parentURL = "doc://Dummy/tutorials/Dummy"

    XCTAssertEqual(document.schemaVersion, .init(major: 0, minor: 1, patch: 0))
    XCTAssertEqual(document.documentVersion, 0)
    XCTAssertEqual(document.identifier, .init(
      url: URL(string: docURL)!, interfaceLanguage: .swift
    ))
    XCTAssertEqual(document.kind, .project)
    
    XCTAssertEqual(document.hierarchy, .init(
      paths: [ [ parentURL, parentURL + "/$volume", docURL ] ],
      reference: parentURL,
      modules: [ .init(reference: .init(url: URL(string: docURL)!,
                                        interfaceLanguage: nil)) ]
    ))
    
    XCTAssertEqual(document.sections.count, 2)
    XCTAssertNil  (document.topicSections)
    XCTAssertNil  (document.primaryContentSections)
    XCTAssertNil  (document.variants)
    XCTAssertNil  (document.abstract)

    if let section = document.sections.first {
      XCTAssertEqual(section.title       , "Dummy")
      XCTAssertEqual(section.identifiers , [])
      if case .hero(let hero) = section.kind {
        XCTAssertEqual(hero.estimatedTimeInMinutes , 42)
        XCTAssertEqual(hero.image                  , "dummy.png")
        XCTAssertEqual(hero.chapter                , "The Chapter")
        XCTAssertEqual(hero.backgroundImage        , "dummy.png")
        XCTAssertEqual(hero.content.count          , 1)
        XCTAssertNil  (hero.action)
      }
      else { XCTFail("Expected hero as the first section") }
    }
    if let section = document.sections.last {
      XCTAssertNil  (section.title)
      XCTAssertEqual(section.identifiers,  [])
      if case .tasks(let tasks) = section.kind {
        XCTAssertEqual(tasks.count, 1)
        
        if let task = tasks.first {
          XCTAssertEqual(task.anchor , "the-id")
          XCTAssertEqual(task.title  , "Creating Something")
          XCTAssertEqual(task.contentSection.count, 1)
          XCTAssertEqual(task.stepsSection  .count, 1)
          
          if case .contentAndMedia(let cm) = task.contentSection.first {
            XCTAssertEqual(cm.layout        , .horizontal)
            XCTAssertEqual(cm.media         , "dummy.png")
            XCTAssertEqual(cm.mediaPosition , .trailing)
            XCTAssertEqual(cm.content.count , 1)
          }
          if case .step(let step) = task.stepsSection.first {
            XCTAssertNil  (step.code)
            XCTAssertNil  (step.runtimePreview)
            XCTAssertEqual(step.content.count, 1)
            XCTAssertTrue (step.caption.isEmpty)
            XCTAssertEqual(step.media, "dummy.png")
          }
        }
      }
      else { XCTFail("Expected tasks as the last section") }
    }
  }

  func testAllDataJSONInSlothCreator() throws {
    let dataDir = Fixtures.slothCreatorArchive.appendingPathComponent("data")
    let fm = FileManager.default
    
    try XCTSkipUnless(fm.fileExists(atPath: dataDir.path),
                      "This test needs the SlothCreator.doccarchive in the " +
                      "~/Downloads directory")
    
    guard let de = fm.enumerator(atPath: dataDir.path) else {
      XCTFail("did not get dir enum"); return
    }
    
    var testCount = 0
    print("Parse files:")
    for p in de {
      guard let path = p as? String else {
        XCTFail("expected path"); return
      }
      guard !path.contains(".git")            else { continue }
      guard path.hasSuffix(".json")           else { continue }

      var url: URL {
        dataDir.appendingPathComponent(path)
      }

      let data = try Data(contentsOf: url)

      print("Parse:", path)
      let document : DocCArchive.Document
      do {
        document =
          try JSONDecoder().decode(DocCArchive.Document.self, from: data)
        testCount += 1
      }
      catch {
        print("ERROR:", error)
        XCTFail("failed to decode: \(error)")
        return
      }

      XCTAssertEqual(document.schemaVersion,
                     .init(major: 0, minor: 1, patch: 0))
      
      // was 0, not set in 13.2.1
      XCTAssert(document.documentVersion == 0 ||
                document.documentVersion == nil)
    }

    print("# passing tests:", testCount)
  }


  func testAllDataJSONInIssue7() throws {
    let dataDir = Fixtures.issue7Archive.appendingPathComponent("data")
    let fm = FileManager.default
    
    try XCTSkipUnless(fm.fileExists(atPath: dataDir.path),
                      "This test needs the LLabsWishlist.doccarchive in the " +
                      "~/Downloads directory")
    
    guard let de = fm.enumerator(atPath: dataDir.path) else {
      XCTFail("did not get dir enum"); return
    }
    
    var testCount = 0
    print("Parse files:")
    for p in de {
      guard let path = p as? String else {
        XCTFail("expected path"); return
      }
      guard !path.contains(".git")            else { continue }
      guard path.hasSuffix(".json")           else { continue }

      var url: URL {
        dataDir.appendingPathComponent(path)
      }

      let data = try Data(contentsOf: url)

      print("Parse:", path)
      let document : DocCArchive.Document
      do {
        document =
          try JSONDecoder().decode(DocCArchive.Document.self, from: data)
        testCount += 1
      }
      catch {
        print("ERROR:", error)
        XCTFail("failed to decode: \(error)")
        return
      }

      XCTAssertEqual(document.schemaVersion,
                     .init(major: 0, minor: 1, patch: 0))
      XCTAssertNil  (document.documentVersion)
    }

    print("# passing tests:", testCount)
  }
}
