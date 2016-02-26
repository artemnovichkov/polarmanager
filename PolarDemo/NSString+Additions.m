//
//  NSString+Additions.m
//  Phyzseek
//
//  Created by Artem on 10/9/15.
//  Copyright © 2015 rosberry. All rights reserved.
//

#import "NSString+Additions.h"

static CGFloat const kTimeDividerValue = 60.f;

@implementation NSString (Additions)

+ (NSString *)formattedStringFromSeconds:(CGFloat)totalSeconds {
    CGFloat seconds = fmodf(totalSeconds, kTimeDividerValue);
    CGFloat minutes = fmodf(totalSeconds / kTimeDividerValue, kTimeDividerValue);
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)minutes, (int)seconds];
}

+ (NSString *)infoStringForMetric:(id<ANMetricProtocol>)metric {
    return [NSString stringWithFormat:@"User's max HR: %.0f bpm\n"
            @"User's avg HR DURING workout: %.0f bpm\n"
            @"User's max HR DURING workout: %.0f bpm\n"
            @"Avg Intensity: %.2f %%\n"
            @"Target HR: %.0f bpm\n"
            @"%%Intensity: %.2f %%\n"
            @"Calories: %.0f cal",
            metric.maxHR, metric.avgHR,
            metric.maxWorkoutHR,
            metric.avgIntensity * 100,
            metric.targetHR,
            metric.procentIntensity * 100,
            metric.burnedCalories];
}

@end
