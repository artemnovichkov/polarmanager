//
//  HealthManager.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "HealthManager.h"
#import "HeartRateDataCollector.h"

#import "CBUUID+Additions.h"

static NSString *const kDeviceInformationUUID = @"180A";
static NSString *const kHeartRateServiceUUID = @"180D";

static NSString *const kMeasurementCharacteristicUUID = @"2A37";
static NSString *const kBodyLocationCharacteristicUUID = @"2A38";
static NSString *const kManufacturerNameCharacteristicUUID = @"2A29";

@interface HealthManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *centralManager;
@property (nonatomic) CBPeripheral *connectedPeripheral;
@property (nonatomic) HeartRateDataCollector *heartRateDataCollector;

@end

@implementation HealthManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.heartRateDataCollector = [[HeartRateDataCollector alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.heartRateDataCollector setCalculatingDidFinishBlock:^(id<MetricProtocol> metric) {
            if ([weakSelf.delegate respondsToSelector:@selector(healthManager:didReceiveMetric:)]) {
                [weakSelf.delegate healthManager:weakSelf didReceiveMetric:metric];
            }
        }];
    }
    return self;
}

#pragma mark - Heart Data Collecting

- (void)startCollectHealthData {
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        self.heartRateDataCollector.needToCollectData = YES;
    } else {
        //Error
    }
}

- (void)stopCollectHealthData {
    self.heartRateDataCollector.needToCollectData = NO;
    [self clearCollectedHealthData];
}

- (void)clearCollectedHealthData {
    [self.heartRateDataCollector clearCollectedData];
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
    if ([self.delegate respondsToSelector:@selector(healthManager:didUpdateState:)]) {
        [self.delegate healthManager:self didUpdateState:central.state];
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:nil];
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
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"Found heart rate measurement characteristic");
            } else if ([characteristic.UUID isEqualToUUIDWithString:kBodyLocationCharacteristicUUID]) {
                [peripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    } else if ([service.UUID isEqualToUUIDWithString:kDeviceInformationUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqualToUUIDWithString:kManufacturerNameCharacteristicUUID]) {
                [peripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if ([characteristic.UUID isEqualToUUIDWithString:kMeasurementCharacteristicUUID]) {
        id<HeartRateDataProtocol> healthRateData = [self.heartRateDataCollector heartBPMDataForCharacteristic:characteristic error:error];
        if ([self.delegate respondsToSelector:@selector(healthManager:didReceiveData:)]) {
            [self.delegate healthManager:self didReceiveData:healthRateData];
        }
    } else if ([characteristic.UUID isEqualToUUIDWithString:kManufacturerNameCharacteristicUUID]) {
        NSLog(@"%@", [self.heartRateDataCollector manufacturerNameForCharacteristic:characteristic]);
    } else if ([characteristic.UUID isEqualToUUIDWithString:kBodyLocationCharacteristicUUID]) {
        NSLog(@"Body Location: %lu", (unsigned long)[self.heartRateDataCollector bodyLocationForCharacteristic:characteristic]);
    }
}

@end
