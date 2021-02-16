//
//  GATTModelExtensions.swift
//
//  Created by AL on 29/01/2018.
//

import Foundation
import CoreBluetooth

public enum CharAccessibility:Int {
    case read=0,write=1,notify=2,readWrite=3
}

public extension GATTModel {
    
    func allUUIds() -> [String] {
        
        var uuids = [String]()
        if let servs = self.services {
            uuids.append(contentsOf: servs.flatMap{ $0.uuid?.uppercased() })
            for s in servs {
                if let char = s.characteristics{
                    uuids.append(contentsOf: char.flatMap{ $0.uuid?.uppercased() })
                }
            }
        }
        
        return uuids
    }
    
    func allNames() -> [String] {
        
        var names = [String]()
        if let servs = self.services {
            //names.append(contentsOf: servs.flatMap{ $0.name })
            for s in servs {
                if let char = s.characteristics{
                    names.append(contentsOf: char.flatMap{ $0.name })
                }
            }
        }
        
        return names
    }
    
    func characteristicForServiceUUIDString(_ uuid:String) -> [BLECharacteristic]? {
        
        var foundCharacteristics:[BLECharacteristic]? = nil
        
        if let servs = services {
            let service = servs.filter{ $0.uuid ?? "" == uuid }
            guard service.count <= 1 else { print("Service UUID is not Uniq"); return nil }
            
            if let s = service.first {
                foundCharacteristics = s.characteristics
            }
            
        }
        
        return foundCharacteristics
    }
    
    func serviceForUuid(_ uuid:String) -> BLEService? {
        
        if let servs = services {
            let service = servs.filter{ $0.uuid ?? "" == uuid }
            guard service.count <= 1 else { print("Service UUID is not Uniq"); return nil }
            return service.first
        }
        
        return nil
    }
    
    func serviceNamed(_ name:String) -> BLEService? {
        
        if let servs = services {
            let service = servs.filter{ $0.name ?? "" == name }
            guard service.count <= 1 else { print("Service UUID is not Uniq"); return nil }
            return service.first
        }
        
        return nil
    }
    
    func charNamed(_ name:String) ->BLECharacteristic? {
        
        if let servs = services {
            let charsArray = servs.flatMap{ $0.characteristics }
            for chars in charsArray {
                let filteredChars = chars.filter{ ($0.name ?? "") == name }
                if filteredChars.count == 1 {
                    return filteredChars.first
                }
            }
        }
        
        return nil
    }
    
    func charForUuid(_ charUuid:String) ->BLECharacteristic? {
        
        if let servs = services {
            let charsArray = servs.flatMap{ $0.characteristics }
            for chars in charsArray {
                let filteredChars = chars.filter{ ($0.uuid ?? "") == charUuid }
                if filteredChars.count == 1 {
                    return filteredChars.first
                }
            }
        }
        
        return nil
    }
    
    
    func charAccessibility(_ charUUID:String) -> CharAccessibility? {
        
        if let servs = services {
            let charsArray = servs.flatMap{ $0.characteristics }
            for chars in charsArray {
                let filteredChars = chars.filter{ ($0.uuid ?? "") == charUUID }
                if let char = filteredChars.first,
                    let accessType = char.accessType{
                    return CharAccessibility(rawValue: accessType)
                }
            }
        }
        
        return nil
    }
    
    func nameForUUId(_ UUIDString:String) -> String? {
        
        if let servs = services {
            for serv in servs {
                if let uuid = serv.uuid,
                    let name = serv.name{
                    if uuid.uppercased() == UUIDString.uppercased() { return name }
                }
            }
            
            let charsArray = servs.flatMap{ $0.characteristics }
            for chars in charsArray {
                let filteredChars = chars.filter{ ($0.uuid ?? "").uppercased() == UUIDString.uppercased() }
                if filteredChars.count == 1 {
                    if let char = filteredChars.first,
                        let name = char.name{
                        return name
                    }
                }
            }
        }
        
        return nil
    }
    
    func cbCharNamed(_ name:String, accessType:UInt? = nil) -> CBCharacteristic? {
        
        if let periph = cbPeripheral,
            let servs = periph.services,
            let charModel = charNamed(name),
            let uuid = charModel.uuid {
            
            for serv in servs {
                if let chars = serv.characteristics {
                    var index:Int?
                    if let a = accessType {
                        index = chars.index{ $0.uuid.uuidString == uuid && $0.properties.rawValue == a}
                    }else{
                        index = chars.index{ $0.uuid.uuidString == uuid }
                    }
                    if let i = index {
                        return chars[i]
                    }
                }
            }
            
        }
        
        return nil
    }
}
