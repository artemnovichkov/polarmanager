//
//  ANInputProtocol.h
//  PolarDemo
//
//  Created by Dmitry Frishbuter on 01/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeMale,
    GenderTypeFemale
};

@protocol ANInputProtocol <NSObject>

@property (nonatomic) CGFloat weight;
@property (nonatomic) NSUInteger age;
@property (nonatomic) GenderType genderType;

@end
