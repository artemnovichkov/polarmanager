//
//  ANMetricCalculator.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ANMetricCalculator.h"
#import "ANMetric.h"

static NSInteger kMaxHRCoefficient = 220;

@implementation ANMetricCalculator

#pragma mark - ANMetricCalculatorProtocol

- (id<ANMetricProtocol>)calculateMetricForHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                                  age:(NSInteger)age
                                         fitnessLevel:(FitnessLevel)fitnessLevel
                                             duration:(CGFloat)duration {
    ANMetric *metric = [[ANMetric alloc] init];
    metric.maxHR = kMaxHRCoefficient - age;
    metric.avgHR = [[heartRateData valueForKeyPath:@"@avg.self"] floatValue];
    metric.maxWorkoutHR = [[heartRateData valueForKeyPath:@"@max.self"] floatValue];
    metric.avgIntensity = metric.avgHR / metric.maxHR;
    metric.targetHR = metric.maxHR * [self coefficientForFitnessLevel:fitnessLevel];
    metric.procentIntensity = [self procentIntensityForHeartRateData:heartRateData targetHR:metric.targetHR];
    return metric;
}

#pragma mark - Helpers

- (CGFloat)coefficientForFitnessLevel:(FitnessLevel)fitnessLevel {
    switch (fitnessLevel) {
        case FitnessLevelBeginner       : return .75f;
        case FitnessLevelIntermediate   : return .8f;
        case FitnessLevelAdvanced       : return .85f;
    }
}

- (CGFloat)procentIntensityForHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                   targetHR:(CGFloat)targetHR {
    NSInteger count = 0;
    for (NSNumber *heartRateValue in heartRateData) {
        if (heartRateValue.floatValue > targetHR) {
            count++;
        }
    }
    return count / heartRateData.count;
}

@end
