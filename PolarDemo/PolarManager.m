//
//  PolarManager.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "PolarManager.h"
#import "CBUUID+Additions.h"

static NSString *const kDeviceInformationUUID = @"180A";
static NSString *const kHeartRateServiceUUID = @"180D";

static NSString *const kMeasurementCharacteristicUUID = @"2A37";
static NSString *const kBodyLocationCharacteristicUUID = @"2A38";
static NSString *const kManufacturerNameCharacteristicUUID = @"2A29";

@interface PolarManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *centralManager;
@property (nonatomic) CBPeripheral *connectedPeripheral;

@property (nonatomic) NSMutableArray<NSNumber *> *storedBpms;
@property (nonatomic) CGFloat averageBpm;
@property (nonatomic) CGFloat maxBpm;
@property (nonatomic) CGFloat avgIntensity;

@end

@implementation PolarManager

- (void)start {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.storedBpms = [NSMutableArray array];
}

- (void)stop {
    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey];
    if (localName.length > 0) {
        NSLog(@"Found the heart rate monitor: %@", localName);
        [self.centralManager stopScan];
        self.connectedPeripheral = peripheral;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if ([service.UUID isEqualToUUIDWithString:kHeartRateServiceUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqualToUUIDWithString:kMeasurementCharacteristicUUID]) {
                [self.connectedPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"Found heart rate measurement characteristic");
            } else if ([characteristic.UUID isEqualToUUIDWithString:kBodyLocationCharacteristicUUID]) {
                [self.connectedPeripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    } else if ([service.UUID isEqualToUUIDWithString:kDeviceInformationUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqualToUUIDWithString:kManufacturerNameCharacteristicUUID]) {
                [self.connectedPeripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if ([characteristic.UUID isEqualToUUIDWithString:kMeasurementCharacteristicUUID]) {
        [self getHeartBPMData:characteristic error:error];
    } else if ([characteristic.UUID isEqualToUUIDWithString:kManufacturerNameCharacteristicUUID]) {
        [self getManufacturerName:characteristic];
    } else if ([characteristic.UUID isEqualToUUIDWithString:kBodyLocationCharacteristicUUID]) {
        [self getBodyLocation:characteristic];
    }
}

#pragma mark - CBCharacteristic Helpers

- (void) getHeartBPMData:(nonnull CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *sensorData = characteristic.value;
    const uint8_t *reportData = sensorData.bytes;
    
    NSUInteger offset = 1;
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {
        bpm = reportData[1];
        offset = offset + 1;
    } else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
        offset =  offset + 2; // Plus 2 bytes //
    }
    NSLog(@"bpm: %i", bpm);
    [self.storedBpms addObject:@(bpm)];
    self.averageBpm = [[self.storedBpms valueForKeyPath:@"@avg.self"] floatValue];
    self.maxBpm = [[self.storedBpms valueForKeyPath:@"@max.self"] floatValue];
    self.avgIntensity = self.averageBpm / self.maxBpm;
    NSLog(@"avgIntensity %.1f", self.avgIntensity * 100);
    
    if ((reportData[0] & 0x03) == 1) {
        offset =  offset + 2;
    }
    
    NSMutableArray<NSNumber *> *rrValues = [NSMutableArray array];
    if ((reportData[0] & 0x04) == 0) {
        NSLog(@"%@", @"Data are not present");
    } else {
        NSUInteger count = (sensorData.length - offset) / 2;
        for (int i = 0; i < count; i++) {
            uint16_t rrValue = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[offset]));
            rrValue = (rrValue / 1024.0 ) * 1000.0;
            [rrValues addObject:@(rrValue)];
            offset = offset + 2;
        }
    }
    if (sensorData || !error) {
        HeartRateData *heartRateData = [[HeartRateData alloc] init];
        heartRateData.bpm = bpm;
        heartRateData.rrValues = rrValues;
        [self.delegate polarManager:self didReceivedData:heartRateData];
    }
}

- (void)getManufacturerName:(nonnull CBCharacteristic *)characteristic {
    NSString *manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"%@", manufacturer);
}

- (void)getBodyLocation:(nonnull CBCharacteristic *)characteristic {
    NSData *sensorData = characteristic.value;
    const uint8_t *bodyData = sensorData.bytes;
    NSString *bodyDataString;
    if (bodyData) {
        uint8_t bodyLocation = bodyData[0];
        bodyDataString = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"];
    } else {
        bodyDataString = @"Body Location: N/A";
    }
    NSLog(@"%@", bodyDataString);
}

@end
