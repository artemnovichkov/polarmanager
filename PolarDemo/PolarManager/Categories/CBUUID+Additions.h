//
//  CBUUID+Additions.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBUUID (Additions)

- (BOOL)isEqualToUUIDWithString:(NSString *)UUID;

@end
