//
//  HeartRateDataCollector.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
#import "HeartRateDataCollectorProtocol.h"
#import "MetricProtocol.h"

@interface HeartRateDataCollector : NSObject <HeartRateDataCollectorProtocol>

@property (nonatomic, copy) void (^finishBlock)(id<MetricProtocol>);
@property (nonatomic) BOOL needToCollectData;

@end
