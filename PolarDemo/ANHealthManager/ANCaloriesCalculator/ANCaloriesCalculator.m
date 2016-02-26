//
//  ANCaloriesCalculator.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ANCaloriesCalculator.h"

static CGFloat const kMaleFirstKoef = 0.6309;
static CGFloat const kFemaleFirstKoef = 0.4472;

static CGFloat const kMaleSecondKoef = 0.1988;
static CGFloat const kFemaleSecondKoef = 0.1263;

static CGFloat const kMaleThirdKoef = 0.2017;
static CGFloat const kFemaleThirdKoef = 0.074;

static CGFloat const kMaleFourthKoef = 55.0969;
static CGFloat const kFemaleFourthKoef = 20.4022;

@implementation ANCaloriesCalculator

@synthesize weight;
@synthesize age;
@synthesize genderType;

- (instancetype)init {
    self = [super init];
    if (self) {
#warning Some hardcode
        self.weight = 78.f;
        self.age = 22;
        self.genderType = GenderTypeMale;
    }
    return self;
}

#pragma mark - ANCaloriesCalculatorProtocol

- (CGFloat)burntCaloriesForAvgHR:(CGFloat)avgHR exerciseDuration:(CGFloat)duration {
    CGFloat koef1 = self.genderType == GenderTypeMale ? kMaleFirstKoef  : kFemaleFirstKoef;
    CGFloat koef2 = self.genderType == GenderTypeMale ? kMaleSecondKoef : kFemaleSecondKoef;
    CGFloat koef3 = self.genderType == GenderTypeMale ? kMaleThirdKoef  : kFemaleThirdKoef;
    CGFloat koef4 = self.genderType == GenderTypeMale ? kMaleFourthKoef : kFemaleFourthKoef;
    CGFloat calories = (koef1 * avgHR - koef2 * self.weight + koef3 * self.age - koef4) / 4.184 * 60 * duration;
    return calories;
}

@end
