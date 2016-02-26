//
//  HealthManager.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "HeartRateDataProtocol.h"
#import "MetricProtocol.h"

@protocol HealthManagerDelegate;
@interface HealthManager : NSObject

@property (nonatomic, weak) id<HealthManagerDelegate> delegate;

- (void)startCollectHealthData;
- (void)stopCollectHealthData;
- (void)clearCollectedHealthData;

@end

@protocol HealthManagerDelegate <NSObject>

@optional
- (void)healthManager:(HealthManager *)healthManager didUpdateState:(CBCentralManagerState)state;
- (void)healthManager:(HealthManager *)healthManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData;
- (void)healthManager:(HealthManager *)healthManager didReceiveMetric:(id<MetricProtocol>)metric;

@end
