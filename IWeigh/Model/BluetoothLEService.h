//
//  BluetoothLEService.h
//  SensorApp
//
//  Created by Scott Gruby on 12/13/12.
//  Copyright (c) 2012 Scott Gruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define     TI_KEYFOB_ACCEL_SERVICE_UUID        0xFFA0
#define     TI_KEYFOB_ACCEL_ENABLER_UUID        0xFFA1
#define     TI_KEYFOB_ACCEL_RANGE_UUID          0xFFA2
#define     TI_KEYFOB_ACCEL_READ_LEN            1

@class BluetoothLEService;

@protocol BluetoothLEServiceProtocol <NSObject>
@required
- (void) didDiscoverCharacterisics:(BluetoothLEService *) service;
- (void) didUpdateValue:(BluetoothLEService *) service forServiceUUID:(CBUUID *) serviceUUID withCharacteristicUUID:(CBUUID *) characteristicUUID withData:(NSData *) data;
@end

@interface BluetoothLEService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral withServiceUUIDs:(NSArray *) serviceUUIDs delegate:(id<BluetoothLEServiceProtocol>) delegate;
- (void) discoverServices;
- (void) startNotifyingForServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID;
- (void) stopNotifyingForServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID;
- (void) setValue:(NSData *)data forServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID resp:(bool)bResp;
- (void) readValueForServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID;
@end
