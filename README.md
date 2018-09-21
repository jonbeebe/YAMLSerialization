# YAMLSerialization

by [Jonathan Beebe](https://jonbeebe.net)

An SPM package that converts between YAML and the equivalent Foundation objects. YAMLSerialization depends on the [LibYAML](https://github.com/yaml/libyaml) C library and [JSONSerialization](https://developer.apple.com/documentation/foundation/jsonserialization) to do the heavy lifting. The API was made to be similiar to JSONSerialization for familiarity.

Requires a mininum version of **Swift 4.2**.

[API Documentation](./Documentation.md)

## Prerequisites

YAMLSerialization depends on the external [LibYAML](https://github.com/yaml/libyaml) system library and pkg-config. Installation instructions for macOS, Ubuntu, and Fedora are below.

### macOS

```
$ brew install libyaml
$ brew install pkg-config
```

### Ubuntu

```
# apt-get update
# apt-get install libyaml-dev
# apt-get install pkg-config
```

### Fedora

```
# dnf install libyaml-devel
# dnf install pkg-config
```

## Example

```
import YAMLSerialization

let yamlStr = """
    ---
    bool_val: true
    double_val: 10.4
    int_val: 3
    string_val: Hello, World
    fruits_array:
        - Apple
        - Banana
        - Strawberry
        - Mango
    ages:
        jane: 18
        josh: 16
        echo: 100
    """

let yaml = try! YAMLSerialization.yamlObject(with: yamlStr) as! [String: Any]

// Extract individual values from YAML object
let bool = yaml["bool_val"] as! Bool     // true
let double yaml["double_val"] as! Double // 10.4
let int = yaml["int_val"] as! Int        // 3
let str = yaml["string_val"] as! String  // Hello, World

// Arrays and Dictionaries
let fruits = yaml["fruits_array"] as! [String]
print(fruits[2]) // Strawberry
let ages = yaml["ages"] as! [String: Int]
print(ages["josh"]) // 14

dump(yaml)
```

Alternatively, you can also pass a Data object as the first argument:

```
let yamlData = yamlStr.data(using: .utf8)
let yaml = try! YAMLSerialization.yamlObject(with: yamlData) as! [String: Any]
```


## Status

- [ ] Parse multiple YAML documents from a single Data or String object and return a `[[String: Any]]` array.
- [ ] Implement `isValidYAMLObject(_:)`
- [ ] Creating YAML data via `data(withYAMLObject:options:)`
- [ ] Proper tests
- [x] Example
- [x] Reading YAML objects from Data
- [x] Reading YAML objects from String

## LICENSE

[ISC License](./LICENSE)