//
//  GATTModel.swift
//
//  Created by Alban on 29/01/2018
//

import Foundation
import CoreBluetooth

public class GATTModel {
    
    var cbPeripheral:CBPeripheral? = nil
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let services = "services"
    }
    
    // MARK: Properties
    public var services: [BLEService]?
    
    public convenience init(bundleFileName: String) {
        if let filepath = Bundle.main.path(forResource: bundleFileName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                self.init(json: JSON(parseJSON: contents))
            } catch {
                // contents could not be loaded
                fatalError("Gatt JSON file cannot be loaded...")
            }
        } else {
            // example.txt not found!
            fatalError("Gatt JSON file not found...")
        }
        
    }
    
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        if let items = json[SerializationKeys.services].array { services = items.map { BLEService(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = services { dictionary[SerializationKeys.services] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}
