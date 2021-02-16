import Foundation
import CoreBluetooth

class CustomPeriph:NSObject {
    
    var advertizedName = ""
    var peripheral:CBPeripheralManager? = nil
    var cbServices = [CBMutableService]()
    var cbCharacteristics = [CBMutableCharacteristic]()
    var gatt:GATTModel = GATTModel(json: JSON(parseJSON: gattJSON))
    
    var availableDatas:Data = Data()
    var centralDidWriteDataCallBack:((Data)->())? = nil
    var centralDidReadDataCallBack:((Data)->())? = nil
    
    
    func stopAdvertising() {
        peripheral?.stopAdvertising()
        peripheral?.removeAllServices()
        cbServices.removeAll()
    }
    
    func startAdvertising() {
        stopAdvertising()
        peripheral = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func buildPeripheralWithGatt(_ gatt:GATTModel) {
        if let services = gatt.services {
            for service in services {
                if let uuid = service.uuid {
                    let cbService = CBMutableService(type: CBUUID(string: uuid), primary: true)
                    var chars = [CBCharacteristic]()
                    if let characteristics = service.characteristics {
                        for characteristic in characteristics {
                            if let charUUID = characteristic.uuid,
                                let access = characteristic.accessType,
                                let accessEnum = CharAccessibility(rawValue: access){
                                
                                var data:Data? = nil
                                
                                let cbChar:CBMutableCharacteristic
                                
                                switch accessEnum {
                                case .read:
                                    cbChar = CBMutableCharacteristic(type: CBUUID(string: charUUID), properties:[.read] , value: nil, permissions: [.readable])
                                case .write:
                                    cbChar = CBMutableCharacteristic(type: CBUUID(string: charUUID), properties:[.write,.notify] , value: nil, permissions: [.writeable])
                                case .notify:
                                    cbChar = CBMutableCharacteristic(type: CBUUID(string: charUUID), properties:[.read,.notify] , value: nil, permissions: [.readable])
                                case .readWrite:
                                    cbChar = CBMutableCharacteristic(type: CBUUID(string: charUUID), properties:[.read,.write] , value: nil, permissions: [.readable,.writeable])
                                }
                                
                                cbCharacteristics.append(cbChar)
                                chars.append(cbChar)
                            }
                        }
                    }
                    cbService.characteristics = chars
                    cbServices.append(cbService)
                }
            }
            
            peripheral?.startAdvertising([CBAdvertisementDataLocalNameKey : advertizedName])
            
            for s in cbServices {
                self.peripheral?.add(s)
            }
            
        }
        
        
    }
}

extension CustomPeriph:CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        peripheral.stopAdvertising()
        peripheral.removeAllServices()
        
        switch peripheral.state {
        case .poweredOff:
            print("**** Turn BLE ON ****")
        case .poweredOn:
            self.peripheral?.removeAllServices()
            buildPeripheralWithGatt(self.gatt)
        case .unknown: break
        case .resetting: break
        case .unsupported: break
        case .unauthorized: break
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Did start advertising")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("Service added \(gatt.nameForUUId(service.uuid.uuidString ?? "") ?? "")")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            let serv = cbServices.filter{ $0.uuid == request.characteristic.service.uuid }
            
            if serv.count == 1 {
                if let chars = serv.first!.characteristics {
                    if let expectedChar = (chars.filter{ $0.uuid == request.characteristic.uuid }).first,
                        let data = request.value{
                        print("Central did write \([UInt8](data))")
                        
                        peripheral.respond(to: request, withResult: CBATTError.Code.success)
                        self.centralDidWriteDataCallBack?(data)
                        
                    }else{
                        peripheral.respond(to: request, withResult: CBATTError.Code.unlikelyError)
                    }
                }
            }else{
                peripheral.respond(to: request, withResult: CBATTError.Code.unlikelyError)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
        print("didSubscribeTo characteristic")
        
        let serv = cbServices.filter{ $0.uuid == characteristic.service.uuid }
        
        if serv.count == 1 {
            if let chars = serv.first!.characteristics {
                if let expectedChar = (chars.filter{ $0.uuid == characteristic.uuid }).first {
                    
                    let customData = Data([0x01,0x02])
                    do{
                        
                        self.peripheral?.updateValue(customData, for: expectedChar as! CBMutableCharacteristic, onSubscribedCentrals: nil)
                        
                    }catch let err {
                        
                    }
                }
            }
        }
        
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("did receive read")
        let serv = cbServices.filter{ $0.uuid == request.characteristic.service.uuid }
        
        if serv.count == 1 {
            if let chars = serv.first!.characteristics {
                    if request.characteristic.uuid == CBUUID(string: "F1D117A8-6CC5-43A6-B469-9DDC38A26256"){
                        print("Central will read \(self.availableDatas)")
                        request.value = self.availableDatas
                        peripheral.respond(to: request, withResult: CBATTError.Code.success)
                        centralDidReadDataCallBack?(self.availableDatas)
                        return
                    }else if request.characteristic.uuid == CBUUID(string: "CREER UN CUSTOM UUID"){
                        let d = Data([0x01,0x02])
                        request.value = d
                        peripheral.respond(to: request, withResult: CBATTError.Code.success)
                        centralDidReadDataCallBack?(d)
                    }
                }
            
        }
        
        peripheral.respond(to: request, withResult: CBATTError.Code.invalidOffset)
    }
    
}
