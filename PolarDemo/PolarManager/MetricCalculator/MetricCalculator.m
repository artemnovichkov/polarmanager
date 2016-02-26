//
//  MetricCalculator.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "MetricCalculator.h"
#import "Metric.h"

@implementation MetricCalculator

#pragma mark - MetricCalculatorProtocol

- (id<MetricProtocol>)calculateMetricForHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                                            age:(NSInteger)age
                                                   fitnessLevel:(FitnessLevel)fitnessLevel
                                                       duration:(CGFloat)duration {
    Metric *metric = [[Metric alloc] init];
    metric.maxHR = 220 - age;
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
        case FitnessLevelBeginner       : return 0.75f;
        case FitnessLevelIntermediate   : return 0.8f;
        case FitnessLevelAdvanced       : return 0.85f;
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
