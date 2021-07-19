<h2>DocCArchive
  <img src="http://zeezide.com/img/docz/DocCArchive100.png"
           align="right" width="100" height="100" />
</h2>

Swift package to read and process "DocC" archives, 
a format to document Swift frameworks and packages:
[Documenting a Swift Framework or Package](https://developer.apple.com/documentation/Xcode/documenting-a-swift-framework-or-package).

Blog entry on the topic: [DocC 📚 Archived and Analyzed](https://www.alwaysrightinstitute.com/docz/).

### Status

The module can import all documents created in the
[SlothCreator](https://developer.apple.com/documentation/xcode/slothcreator_building_docc_documentation_in_xcode)
example.

It should be pretty complete.

If you find an issue (usually signalled by an assertion or fatalError),
please [*let us know*](https://github.com/DoccZz/DocCArchive/issues),
we'll fix missing cases ASAP (PRs are welcome too).

TODO:
- [ ] Add DocC documentation! 🤦‍♀️
- [x] Add a testsuite (existing one not added for sizing concerns).


### Usage in a Swift Package

Example Package.swift:

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name         : "hackdocc",
  products     : [ .executable(name: "hackdocc", targets: [ "hackdocc" ]) ],
  dependencies : [
    .package(url: "https://github.com/DoccZz/DocCArchive.git", from: "0.1.1")
  ],
  targets: [ .target(name: "hackdocc", dependencies: [ "DocCArchive" ]) ]
)
```

### Using the Code

DocCArchive has three main types:
- [`DocCArchive`](https://github.com/DoccZz/DocCArchive/blob/014e60a0bc63ce91586168adbc417462411c2c19/Sources/DocCArchive/DocCArchive.swift#L37),
  represents the whole archive structure
- [`DocumentFolder `](https://github.com/DoccZz/DocCArchive/blob/014e60a0bc63ce91586168adbc417462411c2c19/Sources/DocCArchive/DocCArchive.swift#L127),
  represents a documentation folder within that structure
- [`Document`](https://github.com/DoccZz/DocCArchive/blob/014e60a0bc63ce91586168adbc417462411c2c19/Sources/DocCArchive/Schema_0_1/Document.swift#L13),
  represents a a documentation page (topics, types, tutorials, etc, 
  the "JSON files")

Open the archive, access the documentation folder (tutorials is the other one),
then
[`Document`](https://github.com/DoccZz/DocCArchive/blob/014e60a0bc63ce91586168adbc417462411c2c19/Sources/DocCArchive/Schema_0_1/Document.swift#L13)'s
can be opened in the folder.

```swift
let url     = URL(fileURLWithPath: "~/Downloads/SlothCreator.doccarchive")
let archive = try DocCArchive(contentsOf: url)

if let docs = archive.documentationFolder() {
  ... work it ...
}
```


### Who

**servedocc** is brought to you by
the
[Always Right Institute](http://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
