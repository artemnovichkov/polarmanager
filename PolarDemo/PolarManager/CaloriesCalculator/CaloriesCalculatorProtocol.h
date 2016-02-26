//
//  CaloriesCalculatorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeMale,
    GenderTypeFemale
};

@protocol CaloriesCalculatorProtocol <NSObject>

@property (nonatomic) CGFloat weight;
@property (nonatomic) NSInteger age;
@property (nonatomic) GenderType genderType;

//duration time in hours
- (CGFloat)burntCaloriesForAvgHR:(CGFloat)avgHR exerciseDuration:(CGFloat)duration;

@end
