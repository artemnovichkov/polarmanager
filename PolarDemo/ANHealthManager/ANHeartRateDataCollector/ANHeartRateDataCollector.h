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
#import "ANInputProtocol.h"

@interface ANHeartRateDataCollector : NSObject <ANHeartRateDataCollectorProtocol>

@property (nonatomic, copy) id<ANInputProtocol>(^calculatingWillStartBlock)();
@property (nonatomic, copy) void (^calculatingDidFinishBlock)(id<ANMetricProtocol>);
@property (nonatomic) BOOL needToCollectData;

- (void)clearCollectedData;

@end
