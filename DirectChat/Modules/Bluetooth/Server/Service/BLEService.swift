//
//  Service.swift
//
//  Created by Alban on 29/01/2018
//

import Foundation
import CoreBluetooth

public class BLEService {
    
    var cbService:CBService? = nil
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let characteristics = "characteristics"
        static let uuid = "uuid"
    }
    
    // MARK: Properties
    public var name: String?
    public var characteristics: [BLECharacteristic]?
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
        name = json[SerializationKeys.name].string
        if let items = json[SerializationKeys.characteristics].array { characteristics = items.map {BLECharacteristic(json: $0) } }
        uuid = json[SerializationKeys.uuid].string?.uppercased()
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = characteristics { dictionary[SerializationKeys.characteristics] = value.map { $0.dictionaryRepresentation() } }
        if let value = uuid { dictionary[SerializationKeys.uuid] = value }
        return dictionary
    }
    
}
