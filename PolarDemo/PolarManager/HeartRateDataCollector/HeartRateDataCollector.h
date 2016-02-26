//
//  HeartRateDataCollector.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
#import "HeartRateDataCollectorProtocol.h"

@interface HeartRateDataCollector : NSObject <HeartRateDataCollectorProtocol>

@property (nonatomic) BOOL needToCollectData;

@property (nonatomic) CGFloat averageBpm;
@property (nonatomic) CGFloat maxBpm;
@property (nonatomic) CGFloat avgIntensity;

@end
