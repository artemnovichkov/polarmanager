//
//  CaloriesCalculator.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeMale,
    GenderTypeFemale
};

@interface CaloriesCalculator : NSObject

@property (nonatomic) CGFloat weight;
@property (nonatomic) NSInteger age;
@property (nonatomic) GenderType genderType;

- (CGFloat)burntCaloriesForAvgHR:(CGFloat)avgHR exerciseDuration:(CGFloat)duration;

@end
