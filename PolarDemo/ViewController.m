//
//  ViewController.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ViewController.h"
#import "HealthManager.h"

#import "NSString+Additions.h"

@interface ViewController () <HealthManagerDelegate>

@property (nonatomic) HealthManager *healthManager;
@property (nonatomic) NSTimer *workoutTimer;
@property (nonatomic) CGFloat workoutTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthManager = [[HealthManager alloc] init];
    self.healthManager.delegate = self;
}

- (void)updateTime {
    self.workoutTime += 0.05f;
    self.infoLabel.text = [NSString formattedStringFromSeconds:self.workoutTime];
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

#pragma mark - Actions

- (IBAction)testWorkoutButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setTitle:@"Stop Test Workout" forState:UIControlStateNormal];
        [self.healthManager startCollectHealthData];
        self.workoutTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
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

#pragma mark - PolarManagerDelegate

- (void)healthManager:(HealthManager *)healthManager didUpdateState:(CBCentralManagerState)state {
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

- (void)healthManager:(HealthManager *)healthManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData{
    self.heartRate = heartRateData.bpm;
    self.heartRateLabel.text = [NSString stringWithFormat:@"%.0f bpm", heartRateData.bpm];
    [self doHeartBeat];
}

- (void)healthManager:(HealthManager *)healthManager didReceiveMetric:(id<MetricProtocol>)metric {
    NSString *infoString = [NSString stringWithFormat:@"User's max HR: %.0f bpm\n"
                            @"User's avg HR DURING workout: %.0f bpm\n"
                            @"User's max HR DURING workout: %.0f bpm\n"
                            @"Avg Intensity: %.2f %%\n"
                            @"Target HR: %.0f bpm\n"
                            @"%%Intensity: %.2f %%\n", metric.maxHR, metric.avgHR, metric.maxWorkoutHR, metric.avgIntensity * 100, metric.targetHR, metric.procentIntensity * 100];
    self.infoLabel.text = infoString;
}

@end
