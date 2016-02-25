//
//  ViewController.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ViewController.h"

static NSString *const kDeviceInformationUUID = @"180A";
static NSString *const kHeartRateServiceUUID = @"180D";

static NSString *const kMeasurementCharacteristicUUID = @"2A37";
static NSString *const kBodyLocationCharacteristicUUID = @"2A38";
static NSString *const kManufacturerNameCharacteristicUUID = @"2A29";

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *centralManager;
@property (nonatomic) CBPeripheral *polarPeripheral;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
//            NSArray<CBUUID *> *services = @[[CBUUID UUIDWithString:kHeartRateServiceUUID], [CBUUID UUIDWithString:kDeviceInformationUUID]];
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
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
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

#pragma mark - CBCharacteristic Helpers

- (void)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)getManufacturerName:(CBCharacteristic *)characteristic {
    
}

- (void)getBodyLocation:(CBCharacteristic *)characteristic {
    
}

@end
