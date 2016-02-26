//
//  MetricCalculatorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
@protocol MetricCalculatorProtocol;

typedef NS_ENUM(NSUInteger, FitnessLevel) {
    FitnessLevelBeginner,
    FitnessLevelIntermediate,
    FitnessLevelAdvanced
};

@protocol MetricCalculatorProtocol <NSObject>

- (id<MetricCalculatorProtocol>)calculateMetricForHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                                            age:(NSInteger)age
                                                   fitnessLevel:(FitnessLevel)fitnessLevel
                                                       duration:(CGFloat)duration;

@end
