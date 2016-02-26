//
//  HeartRateDataCollector.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
@protocol MetricProtocol;
#import "HeartRateDataCollectorProtocol.h"

@interface HeartRateDataCollector : NSObject <HeartRateDataCollectorProtocol>

@property (nonatomic, copy) void (^calculatingDidFinishBlock)(id<MetricProtocol>);
@property (nonatomic) BOOL needToCollectData;

- (void)clearCollectedData;

@end
