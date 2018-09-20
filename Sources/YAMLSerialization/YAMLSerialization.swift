import Foundation
import yaml

enum YamlParseError: Error {
    case parserInit;
    case invalidInput;
}

typealias YamlParserT = UnsafeMutablePointer<yaml_parser_t>
typealias YamlTokenT = UnsafeMutablePointer<yaml_token_t>

public class YAMLSerialization {

    private init() {}

    // TODO: support multiple yaml documents in a single string
    public class func yamlObject(with string: String, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let pSize = MemoryLayout<yaml_parser_t>.size
        let parser = YamlParserT.allocate(capacity: pSize)
        guard yaml_parser_initialize(parser) == 1 else {
            throw YamlParseError.parserInit
        }

        guard let jsonString = try? YAMLSerialization.buildJSONString(string, withParser: parser) else {
            throw YamlParseError.invalidInput
        }

        let jsonData = jsonString.data(using: .utf8)!
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: opt) else {
            throw YamlParseError.invalidInput
        }

        yaml_parser_delete(parser) // must manually free memory associated with unsafe pointer
        return json
    }

    public class func yamlObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        guard let str = String(data: data, encoding: .utf8) else {
            throw YamlParseError.invalidInput
        }
        do {
            return try YAMLSerialization.yamlObject(with: str, options: opt)
        } catch {
            throw error
        }
    }

    private static func buildJSONString(_ str: String, withParser parser: YamlParserT?) throws -> String {
        // Create token pointer and set input string
        let pSize = MemoryLayout<yaml_token_t>.size
        let token: YamlTokenT = YamlTokenT.allocate(capacity: pSize)
        yaml_parser_set_input_string(parser, str, str.utf8.count)

        var jsonString = "";
        var blockOpenings = [String]() // used for matching '{' and '['
        var isKeyToken = false

        // Begin parsing by token and build JSON string
        repeat {
            yaml_parser_scan(parser, token)

            /* Stream start/end */
            switch(token.pointee.type) {
                // Handle parse error
                case YAML_NO_TOKEN:
                    throw YamlParseError.invalidInput

                // Token types (read before actual token)
                case YAML_KEY_TOKEN:
                    jsonString += "\""
                    isKeyToken = true
                    break;
                case YAML_VALUE_TOKEN:
                    jsonString += "\":"
                    isKeyToken = false
                    break;
                
                // Block delimeters
                case YAML_BLOCK_SEQUENCE_START_TOKEN:
                    jsonString += "["
                    blockOpenings.append("[")
                    break
                case YAML_BLOCK_ENTRY_TOKEN:
                    break
                case YAML_BLOCK_END_TOKEN:
                    let lastBlock = blockOpenings.last
                    if (lastBlock == "{") {
                        jsonString.removeLast() // remove trailing comma
                        jsonString += "},"
                        blockOpenings.removeLast()
                    } else if (lastBlock == "[") {
                        jsonString.removeLast() // remove trailing comma
                        jsonString += "],"
                        blockOpenings.removeLast()
                    }
                    break
                case YAML_BLOCK_MAPPING_START_TOKEN: 
                    jsonString += "{"
                    blockOpenings.append("{")
                    break

                // Data
                case YAML_SCALAR_TOKEN:
                    let strValue = String(cString: token.pointee.data.scalar.value!)
                    
                    if isKeyToken {
                        jsonString += "\(strValue)"
                        isKeyToken = false
                    } else  {
                        if let v = Bool(strValue) {
                            jsonString += "\(v),"
                        } else if let v = Int(strValue) {
                            jsonString += "\(v),"
                        } else if let v = Double(strValue) {
                            jsonString += "\(v),"
                        } else { // String
                            jsonString += "\"\(strValue)\","
                        }
                    }
                    break
                default:
                    //print("raw value: \(token.pointee.type)")
                    break
            }

            if (token.pointee.type != YAML_STREAM_END_TOKEN) {
                yaml_token_delete(token)
            }

        } while (token.pointee.type != YAML_STREAM_END_TOKEN)
        yaml_token_delete(token)
        jsonString.removeLast() // remove trailing comma
        return jsonString
    }
}