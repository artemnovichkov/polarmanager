//
//  PolarManager.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "HeartRateDataProtocol.h"
#import "MetricProtocol.h"

@protocol PolarManagerDelegate;
@interface PolarManager : NSObject

@property (nonatomic, weak) id<PolarManagerDelegate> delegate;

- (void)startCollectHealthData;
- (void)stopCollectHealthData;

@end

@protocol PolarManagerDelegate <NSObject>

@optional
- (void)polarManager:(PolarManager *)polarManager didUpdateState:(CBCentralManagerState)state;
- (void)polarManager:(PolarManager *)polarManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData;
- (void)polarManager:(PolarManager *)polarManager didReceiveMetric:(id<MetricProtocol>)metric;

@end
