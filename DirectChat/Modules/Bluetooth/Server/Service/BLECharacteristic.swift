//
// BLECharacteristic.swift
//
//  Created by Alban on 29/01/2018
//

import Foundation
import CoreBluetooth

public class BLECharacteristic {
    
    var cbCharacteristic:CBCharacteristic? = nil
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let accessType = "accessType"
        static let name = "name"
        static let uuid = "uuid"
    }
    
    // MARK: Properties
    public var accessType: Int?
    public var name: String?
    public var uuid: String?
    
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
        accessType = json[SerializationKeys.accessType].int
        name = json[SerializationKeys.name].string
        uuid = json[SerializationKeys.uuid].string?.uppercased()
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = accessType { dictionary[SerializationKeys.accessType] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = uuid { dictionary[SerializationKeys.uuid] = value }
        return dictionary
    }
    
}
