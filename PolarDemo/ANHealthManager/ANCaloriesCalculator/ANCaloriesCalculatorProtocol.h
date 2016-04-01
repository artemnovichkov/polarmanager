//
//  ANCaloriesCalculatorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANInputProtocol;
@protocol ANCaloriesCalculatorProtocol <NSObject>

@property (nonatomic) id<ANInputProtocol> input;

//duration time in hours
- (CGFloat)burntCaloriesForAvgHR:(CGFloat)avgHR exerciseDuration:(CGFloat)duration;

@end
