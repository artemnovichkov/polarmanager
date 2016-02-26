//
//  PolarManager.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "HeartRateDataProtocol.h"

@protocol PolarManagerDelegate;
@interface PolarManager : NSObject

@property (nonatomic, weak) id<PolarManagerDelegate> delegate;

- (void)stop;

@end

@protocol PolarManagerDelegate <NSObject>

@optional
- (void)polarManager:(PolarManager *)polarManager didUpdateState:(CBCentralManagerState)state;
- (void)polarManager:(PolarManager *)polarManager didReceiveData:(id<HeartRateDataProtocol>)heartRateData;

@end
