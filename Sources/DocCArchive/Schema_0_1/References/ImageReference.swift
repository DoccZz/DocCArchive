//
//  ImageReference.swift
//  DocCArchive
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension DocCArchive.DocCSchema_0_1 {

  public struct Size: Equatable, Codable, CustomStringConvertible {
    
    public var width  : Int
    public var height : Int
    
    public var description: String {
      return "\(width)×\(height)"
    }
  }

  public struct ImageReference: Equatable, Codable, CustomStringConvertible {
    
    public struct Variant: Equatable, Codable, CustomStringConvertible {
      
      public enum Trait: String, Codable {
        case nonRetina = "1x", retina = "2x", light, dark
      }
      
      public var url    : String // it's a path, not a URL
      public var size   : Size
      public var traits : [ Trait ] // TBD: make Set?
      
      func numberOfMatches(against requestedTraits: Set<Trait>) -> Int {
        var matchCount = 0
        for trait in requestedTraits {
          if traits.contains(trait) { matchCount += 1 }
        }
        return matchCount
      }

      public var description: String {
        var ms = "<Variant: \(size) traits="
        ms += traits.map({ $0.rawValue }).joined(separator: ",")
        ms += " " + url
        ms += ">"
        return ms
      }
    }
    
    public var identifier : String
    public var alt        : String
    public var variants   : [ Variant ]

    public func bestVariant(for traits: Set<Variant.Trait>) -> Variant? {
      guard !variants.isEmpty else { return nil }
      if variants.count == 1       { return variants.first }
      
      var lastVariant    : Variant?
      var lastMatchCount = -1
      for variant in variants {
        let matchCount = variant.numberOfMatches(against: traits)
        if matchCount == traits.count { return variant }
        if matchCount > lastMatchCount {
          lastMatchCount = matchCount
          lastVariant = variant
        }
      }
      return lastVariant
    }


    public var description: String {
      var ms = "<ImageRef[\(identifier)]: "
      if !alt.isEmpty { ms += " “\(alt)”" }
      
      if      variants.isEmpty    { ms += " no-variants"                 }
      else if variants.count == 1 { ms += " \(variants[0])"              }
      else                        { ms += " #variants=\(variants.count)" }
      ms += ">"
      return ms
    }
  }
}
