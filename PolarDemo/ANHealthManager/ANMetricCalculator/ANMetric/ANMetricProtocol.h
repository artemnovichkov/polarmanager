//
//  ANMetricProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;

@protocol ANMetricProtocol <NSObject>

@property (nonatomic) CGFloat maxHR;
@property (nonatomic) CGFloat avgHR;
@property (nonatomic) CGFloat maxWorkoutHR;
@property (nonatomic) CGFloat avgIntensity;
@property (nonatomic) CGFloat targetHR;
@property (nonatomic) CGFloat procentIntensity;
@property (nonatomic) CGFloat burnedCalories;

@end
