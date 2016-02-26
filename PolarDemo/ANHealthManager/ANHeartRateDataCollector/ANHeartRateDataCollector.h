//
//  ANHeartRateDataCollector.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
#import "ANHeartRateDataCollectorProtocol.h"
#import "ANMetricProtocol.h"

@interface ANHeartRateDataCollector : NSObject <ANHeartRateDataCollectorProtocol>

@property (nonatomic, copy) void (^calculatingDidFinishBlock)(id<ANMetricProtocol>);
@property (nonatomic) BOOL needToCollectData;

- (void)clearCollectedData;

@end
