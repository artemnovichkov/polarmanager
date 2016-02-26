//
//  MetricProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;

@protocol MetricProtocol <NSObject>

@property (nonatomic) CGFloat maxHR;
@property (nonatomic) CGFloat avgHR;
@property (nonatomic) CGFloat maxWorkoutHR;
@property (nonatomic) CGFloat avgIntensity;
@property (nonatomic) CGFloat targetHR;
@property (nonatomic) CGFloat procentIntensity;

- (void)calculateMetricWithHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                     age:(NSInteger)age
                                duration:(CGFloat)duration;

@end
