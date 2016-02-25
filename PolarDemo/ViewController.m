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
    self.infoLabel.text = @"Connecting...";
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) doHeartBeat {
    CALayer *layer = self.heartImageView.layer;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    
    pulseAnimation.duration = 60. / self.heartRate / 2.;
    pulseAnimation.repeatCount = 1;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:pulseAnimation forKey:@"scale"];
    
    self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey];
    if (localName.length > 0) {
        NSLog(@"Found the heart rate monitor: %@", localName);
        [self.centralManager stopScan];
        self.polarPeripheral = peripheral;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
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
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kHeartRateServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kMeasurementCharacteristicUUID]]) {
                [self.polarPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"Found heart rate measurement characteristic");
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBodyLocationCharacteristicUUID]]) {
                [self.polarPeripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    } else if ([service.UUID isEqual:[CBUUID UUIDWithString:kDeviceInformationUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kManufacturerNameCharacteristicUUID]]) {
                [self.polarPeripheral readValueForCharacteristic:characteristic];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kMeasurementCharacteristicUUID]]) {
        [self getHeartBPMData:characteristic error:error];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kManufacturerNameCharacteristicUUID]]) {
        [self getManufacturerName:characteristic];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBodyLocationCharacteristicUUID]]) {
        [self getBodyLocation:characteristic];
    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer];
}

#pragma mark - CBCharacteristic Helpers

- (void)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = characteristic.value;
    const uint8_t *reportData = data.bytes;
    uint16_t bpm = 0;
    
    //log all bytes
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i = 0; i < data.length; i++) {
        uint16_t test = reportData[i];
        [string appendFormat:@"%hu ", test];
    }
    NSLog(@"%@", string);
    //end
    
    if ((reportData[0] & 0x01) == 0) {
        bpm = reportData[1];
    } else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }
    if (characteristic.value || !error) {
        self.heartRate = bpm;
        self.heartRateLabel.text = [NSString stringWithFormat:@"%hu bpm", bpm];
        [self doHeartBeat];
    }
}

- (void)getManufacturerName:(CBCharacteristic *)characteristic {
    self.manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

- (void)getBodyLocation:(CBCharacteristic *)characteristic {
    NSData *sensorData = characteristic.value;
    uint8_t *bodyData = (uint8_t *)sensorData.bytes;
    if (bodyData) {
        uint8_t bodyLocation = bodyData[0];
        self.bodyData = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"];
    } else {
        self.bodyData = @"Body Location: N/A";
    }
}

@end
