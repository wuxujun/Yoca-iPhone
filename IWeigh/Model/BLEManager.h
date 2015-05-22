//
//  BLEManager.h
//  IWeigh
//
//  Created by xujunwu on 15/3/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import <CoreBluetooth/CBCentralManager.h>


@protocol BLEManagerDelegate
@optional
-(void)BLEConnected:(NSString*)uuid;
-(void)BLERSSIUpdated:(int)rssi;
-(void)BLEValueUpdated:(char)value;

@required
-(void)BLEDisConnected;
@end

@interface BLEManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{

}

@property(nonatomic,assign)id<BLEManagerDelegate> deleagte;
@property(nonatomic,strong)NSMutableArray* peripherals;
@property(nonatomic,strong)CBCentralManager*    CM;
@property(nonatomic,strong)CBPeripheral*        activePeripheral;


+(BLEManager*)getInstance;

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p;
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;

-(int)controlSetup:(int)s;
-(int)findBLEPeripherals:(int)timeout;
-(const char*)centralManagerStateToString:(int)state;
-(void)scanTimer:(NSTimer*)timer;
-(void)connectPeripheral:(CBPeripheral*)peripheral;


@end
