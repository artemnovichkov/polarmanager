//
//  PolarManager.h
//  PolarDemo
//
//  Created by Artem on 25/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "HeartRateData.h"

@protocol PolarManagerDelegate;
@interface PolarManager : NSObject

@property (nonatomic, weak) id<PolarManagerDelegate> delegate;

- (void)start;

@end

@protocol PolarManagerDelegate <NSObject>

- (void)polarManager:(PolarManager *)polarManager didReceivedData:(HeartRateData *)heartRateData;

@end
