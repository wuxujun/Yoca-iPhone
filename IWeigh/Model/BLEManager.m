//
//  BLEManager.m
//  IWeigh
//
//  Created by xujunwu on 15/3/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BLEManager.h"

@implementation BLEManager
{
    CBService*      cbService;
    CBCharacteristic*   cbCharacteristic;
    
    
}
@synthesize deleagte;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(NSString*)UUIDToNString:(CFUUIDRef)UUID
{
    if (!UUID) {
        return @"NULL";
    }
    CFStringRef s=CFUUIDCreateString(NULL, UUID);
    return [NSString stringWithUTF8String:CFStringGetCStringPtr(s, 0)];
}

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}

static BLEManager *sharedManager=nil;
+(BLEManager*)getInstance
{
    if (!sharedManager) {
        sharedManager=[[BLEManager alloc]init];
        
    }
    return sharedManager;
}

-(void)writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    
}

-(void)readValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p
{
    
}

-(void)notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    
}

-(int)controlSetup:(int)s
{
    self.CM=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    return 0;
}


-(int)findBLEPeripherals:(int)timeout
{
    if (self->CM.state!=CBCentralManagerStatePoweredOn) {
        return -1;
    }
    [self.CM scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    return 0;
}

-(void)connectPeripheral:(CBPeripheral *)peripheral
{
    DLog(@"%@",peripheral);
    activePeripheral=peripheral;
    activePeripheral.delegate=self;
    [CM connectPeripheral:activePeripheral options:nil];
}

-(const char*)centralManagerStateToString:(int)state
{
    return "Unknown state";
}

-(void)scanTimer:(NSTimer *)timer
{
    [self.CM stopScan];

}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (!self.peripherals) {
        self.peripherals=[[NSMutableArray alloc]initWithObjects:peripherals, nil];
    }else{
        for (int i=0; i<self.peripherals.count; i++) {
            CBPeripheral *p=[self.peripherals objectAtIndex:i];
            if ([self UUIDSAreEqual:p.UUID u2:peripheral.UUID]) {
                [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                return;
            }
        }
        [self->peripherals addObject:peripheral];
        DLog(@"center RSSI =%d",[RSSI integerValue]);
        
    }
    [self connectPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@"%@   %@",central,peripheral);
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    activePeripheral=peripheral;
    activePeripheral.delegate=self;
    if (activePeripheral.services) {
        [self peripheral:activePeripheral didDiscoverServices:nil];
    }else{
        [activePeripheral discoverServices:nil];
    }
    DLog(@"%@",peripheral);
    [deleagte BLEConnected:[self UUIDToNString:peripheral.UUID]];
    [central stopScan];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        DLog(@"%@",service);
        for (CBCharacteristic* c in service.characteristics) {
            DLog(@"%@",c);
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        DLog(@"%@",peripheral);
        for (CBService* svc in peripheral.services) {
            if (svc.characteristics) {
                
                [self peripheral:self.activePeripheral didDiscoverCharacteristicsForService:svc error:error];
            }else{
                [self.activePeripheral discoverCharacteristics:nil forService:svc];
            }
        }
    }else{
        DLog(@"%@",error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        DLog(@"%@",characteristic);
    }else{
        DLog(@"%@",error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        DLog(@"%@",characteristic);
    }else{
        DLog(@"%@",error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    DLog(@"%@",descriptor);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    DLog(@"%@",characteristic);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    DLog(@"%@",descriptor);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@"%@",peripheral);
}

@end
