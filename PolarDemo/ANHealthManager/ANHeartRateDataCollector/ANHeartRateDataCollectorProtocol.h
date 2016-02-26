//
//  ANHeartRateDataCollectorProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBCharacteristic;
@protocol ANHeartRateDataProtocol;

typedef NS_ENUM(NSUInteger, BodyLocation) {
    BodyLocationChest,
    BodyLocationUndefined,
    BodyLocationNA,
};

@protocol ANHeartRateDataCollectorProtocol <NSObject>

- (nullable id<ANHeartRateDataProtocol>)heartBPMDataForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error;
- (nullable NSString *)manufacturerNameForCharacteristic:(nonnull CBCharacteristic *)characteristic;
- (BodyLocation)bodyLocationForCharacteristic:(nonnull CBCharacteristic *)characteristic;

@end
