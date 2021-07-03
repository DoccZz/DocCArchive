import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [ XCTestCaseEntry ] {
  return [
    testCase(OpenArchiveTests     .allTests),
    testCase(DocumentDecodingTests.allTests)
  ]
}
#endif
