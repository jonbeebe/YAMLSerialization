# YAMLSerialization (class)

## Reading YAML Data

### yamlObject(with:options:)

Returns a Foundation object from given YAML data.

#### Declaration

```
class func yamlObject(with string: String,
              options opt: JSONSerialization.ReadingOptions = []) throws -> Any
```

#### Parameters

__`string`__
* Type: [String](https://developer.apple.com/documentation/swift/string)
* A string containing valid YAML content.

__`options`__
* Type: [JSONSerialization.ReadingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/readingoptions)
* Options for reading YAML data and creating Foundation objects.

#### Return Value

A Foundation object from the YAML content in `string`, or `nil` if an error occurs.

-----

### yamlObject(with:options:)

Returns a Foundation object from given YAML data.

#### Declaration

```
class func yamlObject(with data: Data,
              options opt: JSONSerialization.ReadingOptions = []) throws -> Any
```

#### Parameters

__`data`__
* Type: [Data](https://developer.apple.com/documentation/foundation/data)
* A Data object containing YAML data.

__`options`__
* Type: [JSONSerialization.ReadingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/readingoptions)
* Options for reading YAML data and creating Foundation objects.

#### Return Value

A Foundation object from the YAML data in `data`, or `nil` if an error occurs.