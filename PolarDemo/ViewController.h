//
//  ViewController.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@property (nonatomic, copy) NSString *connected;
@property (nonatomic, copy) NSString *bodyData;
@property (nonatomic, copy) NSString *manufacturer;
@property (nonatomic, copy) NSString *polarDeviceData;
@property (assign) uint16_t heartRate;

@property (nonatomic, retain) NSTimer    *pulseTimer;

- (void)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)getManufacturerName:(CBCharacteristic *)characteristic;
- (void)getBodyLocation:(CBCharacteristic *)characteristic;

@end

