//
//  ANViewController.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ANViewController.h"
#import "ANHealthManager.h"
#import "ANInput.h"

#import "NSString+Additions.h"

@interface ANViewController () <ANHealthManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bluetoothStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@property (nonatomic, retain) NSTimer *pulseTimer;
@property (assign) CGFloat heartRate;

@property (nonatomic) ANHealthManager *healthManager;
@property (nonatomic) NSTimer *workoutTimer;
@property (nonatomic) CGFloat workoutTime;

@end

@implementation ANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthManager = [[ANHealthManager alloc] init];
    self.healthManager.delegate = self;
    
    ANInput *input = [[ANInput alloc] init];
    input.weight = 175.f;
    input.age = 26;
    input.genderType = GenderTypeMale;
    
    self.healthManager.input = input;
}

- (void)updateTime {
    self.workoutTime += 1.f;
    self.infoLabel.text = [NSString formattedStringFromSeconds:self.workoutTime];
}

- (void) doHeartBeat {
    CALayer *layer = self.heartImageView.layer;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1f];
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    
    pulseAnimation.duration = 60.f / self.heartRate / 2.f;
    pulseAnimation.repeatCount = 1;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:pulseAnimation forKey:@"scale"];
    
    self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60.f / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
}

#pragma mark - Actions

- (IBAction)testWorkoutButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setTitle:@"Stop Test Workout" forState:UIControlStateNormal];
        self.infoLabel.text = [NSString formattedStringFromSeconds:self.workoutTime];
        [self.healthManager startCollectHealthData];
        self.workoutTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.workoutTimer forMode:NSRunLoopCommonModes];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        sender.tag = 0;
        [sender setTitle:@"Start Test Workout" forState:UIControlStateNormal];
        self.workoutTime = 0.f;
        [self.workoutTimer invalidate];
        self.workoutTimer = nil;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self.healthManager stopCollectHealthData];
    }
}

#pragma mark - ANHealthManagerDelegate

- (void)healthManager:(ANHealthManager *)healthManager didUpdateState:(CBCentralManagerState)state {
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

- (void)healthManager:(ANHealthManager *)healthManager didReceiveData:(id<ANHeartRateDataProtocol>)heartRateData {
    self.heartRate = heartRateData.bpm;
    self.heartRateLabel.text = [NSString stringWithFormat:@"%.0f bpm", heartRateData.bpm];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self doHeartBeat];
    });
}

- (void)healthManager:(ANHealthManager *)healthManager didReceiveMetric:(id<ANMetricProtocol>)metric {
    self.infoLabel.text = [NSString infoStringForMetric:metric];
}

@end
