//
//  HeartRateDataProtocol.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;

@protocol HeartRateDataProtocol <NSObject>

@property (nonatomic) CGFloat bpm;
@property (nonatomic) NSArray<NSNumber *> *rrIntervals;

@end
