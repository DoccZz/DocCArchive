//
//  DocumentDecodingTests.swift
//  DocCArchiveTests
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import XCTest
@testable import DocCArchive

final class DocumentDecodingTests: XCTestCase {
  
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
      XCTAssert(false, "failed to decode: \(error)")
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
  }

  func testParseAllDataJSON() throws {
    let dataDir = Fixtures.slothCreatorArchive.appendingPathComponent("data")
    let fm = FileManager.default
    
    try XCTSkipUnless(fm.fileExists(atPath: dataDir.path),
                      "This test needs the SlothCreator.doccarchive in the " +
                      "~/Downloads directory")
    
    guard let de = fm.enumerator(atPath: dataDir.path) else {
      XCTAssert(false, "did not get dir enum"); return
    }
    
    var testCount = 0
    print("Parse files:")
    for p in de {
      guard let path = p as? String else {
        XCTAssert(false, "expected path"); return
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
        XCTAssert(false, "failed to decode: \(error)")
        return
      }

      XCTAssertEqual(document.schemaVersion,
                     .init(major: 0, minor: 1, patch: 0))
      XCTAssertEqual(document.documentVersion, 0)
    }

    print("# passing tests:", testCount)
  }
}
