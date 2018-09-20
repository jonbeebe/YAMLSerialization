// import XCTest

// import YAMLSerializationTests

// var tests = [XCTestCaseEntry]()
// tests += YAMLSerializationTests.allTests()
// XCTMain(tests)

import YAMLSerialization

let yamlStr = """
    ---
    bool_val: true
    double_val: 10.4
    int_val: 3
    string_val: That's cool
    fruits_array:
        - Apple
        - Banana
        - Strawberry
        - Mango
    is_good: true
    ages:
        jane: 18
        josh: 16
        echo: 100
    """

do {
    let obj = try YAMLSerialization.yamlObject(with: yamlStr) as! [String: Any]

    let value = obj["ages"] as! [String: Int]
    dump(value)
} catch {
    print(error)
}
