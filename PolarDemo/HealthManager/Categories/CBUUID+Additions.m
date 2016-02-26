//
//  CBUUID+Additions.m
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "CBUUID+Additions.h"

@implementation CBUUID (Additions)

- (BOOL)isEqualToUUIDWithString:(NSString *)UUIDString {
    return [self isEqual:[CBUUID UUIDWithString:UUIDString]];
}

@end
