//
//  DocCArchive.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation

/**
 * Represents an on-disk DocC archive.
 *
 * ### Filesystem Structure:
 *
 * - data/
 *   - documentation/
 *     - slotcreator.json
 *     - slotcreator/
 *       - activity.json
 *       - activity/
 *         - `perform(with:).json` (yes, w/ :)
 *   - tutorials/
 * - css/
 *   - document-topic.HASH.css
 *   - documentation-topic~topic~tutorials-overview.HASH.css
 *   - index.HASH.css
 *   - topic.HASH.css
 *   - tutorial-overview.HASH.css
 *
 * ### Hashes
 *
 * Presumably the hashes are included for forcing cache updates, not sure
 * how they are calculated.
 * They are rather short `a4cce634` (4 bytes), i.e. not MD5 or SHA.
 */
public struct DocCArchive {
  // TBD: Maybe this should be a class, or at least a CoW, to avoid the copying
  //      for the subfolders.

  public typealias Document       = DocCSchema_0_1.Document
  public typealias InlineContent  = DocCSchema_0_1.InlineContent
  public typealias Fragment       = DocCSchema_0_1.Fragment
  public typealias Content        = DocCSchema_0_1.Content
  public typealias Section        = DocCSchema_0_1.Section
  public typealias Reference      = DocCSchema_0_1.Reference
  public typealias TopicReference = DocCSchema_0_1.TopicReference
  public typealias ImageReference = DocCSchema_0_1.ImageReference

  public let url              : URL
  public let dataURL          : URL
  public let documentationURL : URL?
  public let tutorialsURL     : URL?

  private var fm : FileManager { .default }

  /**
   * Note: This does synchronous file access.
   */
  public init(contentsOf url: URL) throws {
    self.url     = url
    self.dataURL = url.appendingPathComponent("data")
    
    let fm = FileManager.default
    
    var isDir : ObjCBool = false
    guard fm.fileExists(atPath: url.path, isDirectory: &isDir) else {
      throw DocCArchiveLoadingError.didNotFindArchive(url)
    }
    guard isDir.boolValue else {
      throw DocCArchiveLoadingError.archiveIsNotADirectory(url)
    }

    let documentationURL = dataURL.appendingPathComponent("documentation")
    if fm.fileExists(atPath: documentationURL.path, isDirectory: &isDir),
       isDir.boolValue
    {
      self.documentationURL = documentationURL
    }
    else {
      self.documentationURL = nil
    }

    let tutorialsURL = dataURL.appendingPathComponent("tutorials")
    if fm.fileExists(atPath: tutorialsURL.path, isDirectory: &isDir),
       isDir.boolValue
    {
      self.tutorialsURL = tutorialsURL
    }
    else {
      self.tutorialsURL = nil
    }
    
    guard self.documentationURL != nil || self.tutorialsURL != nil else {
      throw DocCArchiveLoadingError.archiveContainsNoContent(url)
    }
  }
  
  
  // MARK: - Lookup Static Resources
  
  public func stylesheetURLs() -> [ URL ] {
    return fm.contentsOfDirectory(at: url.appendingPathComponent("css"))
  }
  public func userImageURLs() -> [ URL ] {
    return fm.contentsOfDirectory(at: url.appendingPathComponent("images"))
  }
  public func systemImageURLs() -> [ URL ] {
    return fm.contentsOfDirectory(at: url.appendingPathComponent("img"))
  }
  public func userVideoURLs() -> [ URL ] {
    return fm.contentsOfDirectory(at: url.appendingPathComponent("videos"))
  }
  public func userDownloadURLs() -> [ URL ] {
    return fm.contentsOfDirectory(at: url.appendingPathComponent("downloads"))
  }

  public func favIcons() -> [ URL ] {
    return fm.contentsOfDirectory(at: url).filter {
      $0.lastPathComponent.hasPrefix("favicon.")
    }
  }
  
  
  // MARK: - Package Contents
  
  public struct DocumentFolder {
    
    public  let url     : URL
    public  let path    : [ String ]
    public  let archive : DocCArchive
    public  var level   : Int { return path.count }

    private var fm      : FileManager { .default }
    
    public func pageURLs() -> [ URL ] {
      do {
        return try fm.contentsOfDirectory(
          at: url, includingPropertiesForKeys: [.isDirectoryKey],
          options: .skipsHiddenFiles
        )
        .filter { $0.pathExtension == "json" }
        .filter {
          !(try $0.resourceValues(forKeys: [ .isDirectoryKey ]).isDirectory
            ?? false)
        }
        .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })

      }
      catch {
        print("ERROR: failed to access directory:", url.path)
        return []
      }
    }
    
    public func subfolders() -> [ DocumentFolder ] {
      do {
        return try fm.contentsOfDirectory(
          at: url, includingPropertiesForKeys: [.isDirectoryKey],
          options: .skipsHiddenFiles
        )
        .filter {
          try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
        }
        .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
        .map {
          DocumentFolder(url: $0, path: path + [ $0.lastPathComponent ],
                         archive: archive)
        }
      }
      catch {
        print("ERROR: failed to access directory:", url.path)
        return []
      }
    }

    public func document(at url: URL) throws -> Document {
      return try archive.document(at: url)
    }
  }
  
  public func documentationFolder() -> DocumentFolder? {
    guard let url = documentationURL else { return nil }
    return DocumentFolder(url: url, path: [ url.lastPathComponent ],
                          archive: self)
  }
  public func tutorialsFolder() -> DocumentFolder? {
    guard let url = tutorialsURL else { return nil }
    return DocumentFolder(url: url, path: [ url.lastPathComponent ],
                          archive: self)
  }
  
  public func document(at url: URL) throws -> Document {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(DocCArchive.Document.self, from: data)
  }
}

public extension DocCArchive {
  
  typealias DocCSchema = DocCSchema_0_1
  enum DocCSchema_0_1 {}
  
}

public enum DocCArchiveLoadingError: Swift.Error {

  case didNotFindArchive           (URL)
  case archiveIsNotADirectory      (URL)
  case archiveContainsNoContent    (URL)
  
  case unsupportedInlineContentType(String)
  case unsupportedContentType      (String)
  case unsupportedSectionKind      (String)
  case unsupportedFragmentKind     (String)
  case unsupportedMetaDataRole     (String)
  case unsupportedRole             (String)
  case unsupportedTaskContent      (String)
  case expectedStep                (String)
}
