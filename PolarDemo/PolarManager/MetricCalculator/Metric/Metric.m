//
//  Metric.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "Metric.h"

@implementation Metric

@synthesize maxHR;
@synthesize avgHR;
@synthesize maxWorkoutHR;
@synthesize avgIntensity;
@synthesize targetHR;
@synthesize procentIntensity;

#pragma mark - MetricProtocol

- (void)calculateMetricWithHeartRateData:(NSArray<NSNumber *> *)heartRateData
                                     age:(NSInteger)age
                                duration:(CGFloat)duration {
    self.maxHR = 220 - age;
    self.avgHR = [[heartRateData valueForKeyPath:@"@avg.self"] floatValue];
    self.maxWorkoutHR = [[heartRateData valueForKeyPath:@"@max.self"] floatValue];
    self.avgIntensity = self.avgHR / self.maxHR;
}

@end
