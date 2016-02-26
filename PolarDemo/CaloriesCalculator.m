//
//  CaloriesCalculator.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "CaloriesCalculator.h"

static CGFloat const kMaleFirstKoef = 55.0969;
static CGFloat const kFemaleFirstKoef = 20.4022;

static CGFloat const kMaleSecondKoef = 0.6309;
static CGFloat const kFemaleSecondKoef = 0.4472;

static CGFloat const kMaleThirdKoef = 0.1988;
static CGFloat const kFemaleThirdKoef = 0.1263;

static CGFloat const kMaleFourthKoef = 0.2017;
static CGFloat const kFemaleFourthKoef = 0.074;

@implementation CaloriesCalculator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.weight = 82.f;
        self.age = 22;
        self.genderType = GenderTypeMale;
    }
    return self;
}

- (CGFloat)burntCaloriesForAvgHR:(CGFloat)avgHR exerciseDuration:(CGFloat)duration {
    CGFloat koef1 = self.genderType == GenderTypeMale ? kMaleFirstKoef  : kFemaleFirstKoef;
    CGFloat koef2 = self.genderType == GenderTypeMale ? kMaleSecondKoef : kFemaleSecondKoef;
    CGFloat koef3 = self.genderType == GenderTypeMale ? kMaleThirdKoef  : kFemaleThirdKoef;
    CGFloat koef4 = self.genderType == GenderTypeMale ? kMaleFourthKoef : kFemaleFourthKoef;
    CGFloat calories = (-koef1 + koef2 * avgHR + koef3 * self.weight + koef4 * self.age) / 4.184 * 60 * duration;
    return calories;
}

@end
