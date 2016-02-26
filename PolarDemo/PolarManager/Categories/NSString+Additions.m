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

@end
