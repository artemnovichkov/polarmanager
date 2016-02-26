//
//  HeartRateDataCollectorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBCharacteristic;
@protocol HeartRateDataProtocol;

@protocol HeartRateDataCollectorProtocol <NSObject>

+ (nullable id<HeartRateDataProtocol>)heartBPMDataForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error;
+ (nullable NSString *)manufacturerNameForCharacteristic:(nonnull CBCharacteristic *)characteristic;
+ (nonnull NSString *)bodyLocationForCharacteristic:(nonnull CBCharacteristic *)characteristic;

@end
