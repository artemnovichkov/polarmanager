//
//  ANHealthManager.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "ANHeartRateDataProtocol.h"
#import "ANMetricProtocol.h"
#import "ANHealthManagerProtocol.h"

@protocol HealthManagerDelegate;
@interface ANHealthManager : NSObject <ANHealthManagerProtocol>

@property (nonatomic, weak) id<HealthManagerDelegate> delegate;

@end

@protocol HealthManagerDelegate <NSObject>

@optional
- (void)healthManager:(ANHealthManager *)healthManager didUpdateState:(CBCentralManagerState)state;
- (void)healthManager:(ANHealthManager *)healthManager didReceiveData:(id<ANHeartRateDataProtocol>)heartRateData;
- (void)healthManager:(ANHealthManager *)healthManager didReceiveMetric:(id<ANMetricProtocol>)metric;

@end
