//
//  ANMetricCalculatorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;
@protocol ANMetricProtocol;

typedef NS_ENUM(NSUInteger, FitnessLevel) {
    FitnessLevelBeginner,
    FitnessLevelIntermediate,
    FitnessLevelAdvanced
};

@protocol ANMetricCalculatorProtocol <NSObject>

- (id<ANMetricProtocol>)calculateMetricForHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                                            age:(NSInteger)age
                                                   fitnessLevel:(FitnessLevel)fitnessLevel
                                                       duration:(CGFloat)duration;

@end
