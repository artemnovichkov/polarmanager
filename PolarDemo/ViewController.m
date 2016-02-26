//
//  ViewController.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ViewController.h"
#import "PolarManager.h"

@interface ViewController () <PolarManagerDelegate>

@property (nonatomic) PolarManager *polarManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.polarManager = [[PolarManager alloc] init];
    self.polarManager.delegate = self;
}
- (IBAction)startWorkoutButtonAction:(UIButton *)sender {
    sender.titleLabel.text = @"Started";
    [self.polarManager startCollectHealthData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.titleLabel.text = @"Finished";
        [self.polarManager stopCollectHealthData];
    });
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

#pragma mark - PolarManagerDelegate

- (void)polarManager:(PolarManager *)polarManager didUpdateState:(CBCentralManagerState)state {
    NSString *statusString;
    switch (state) {
        case CBCentralManagerStatePoweredOff:
            statusString = @"CoreBluetooth BLE hardware is powered off";
            break;
        case CBCentralManagerStatePoweredOn:
            statusString = @"CoreBluetooth BLE hardware is powered on and ready";
            break;
        case CBCentralManagerStateUnauthorized:
            statusString = @"CoreBluetooth BLE state is unauthorized";
            break;
        case CBCentralManagerStateUnknown:
            statusString = @"CoreBluetooth BLE state is unknown";
            break;
        case CBCentralManagerStateUnsupported:
            statusString = @"CoreBluetooth BLE hardware is unsupported on this platform";
            break;
        default:
            break;
    }
    self.bluetoothStatusLabel.text = statusString;
}

- (void)polarManager:(PolarManager *)polarManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData {
    self.heartRate = heartRateData.bpm;
    self.heartRateLabel.text = [NSString stringWithFormat:@"%.0f bpm", heartRateData.bpm];
    [self doHeartBeat];
}

- (void)polarManager:(PolarManager *)polarManager didReceiveMetric:(id<MetricProtocol>)metric {
    
}

@end
