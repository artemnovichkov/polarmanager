//
//  NSString+Additions.h
//  Phyzseek
//
//  Created by Artem on 10/9/15.
//  Copyright © 2015 rosberry. All rights reserved.
//

@import UIKit;
#import "ANMetricProtocol.h"

@interface NSString (Additions)

+ (NSString *)formattedStringFromSeconds:(CGFloat)totalSeconds;
+ (NSString *)infoStringForMetric:(id<ANMetricProtocol>)metric;

@end
