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
#import "HealthManagerProtocol.h"

@protocol HealthManagerDelegate;
@interface HealthManager : NSObject <HealthManagerProtocol>

@property (nonatomic, weak) id<HealthManagerDelegate> delegate;

@end

@protocol HealthManagerDelegate <NSObject>

@optional
- (void)healthManager:(HealthManager *)healthManager didUpdateState:(CBCentralManagerState)state;
- (void)healthManager:(HealthManager *)healthManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData;
- (void)healthManager:(HealthManager *)healthManager didReceiveMetric:(id<MetricProtocol>)metric;

@end
