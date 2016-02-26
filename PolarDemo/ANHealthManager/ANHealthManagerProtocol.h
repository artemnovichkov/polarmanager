//
//  ANHealthManagerProtocol.h
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANHealthManagerProtocol <NSObject>

- (void)startCollectHealthData;
- (void)stopCollectHealthData;
- (void)clearCollectedHealthData;

@end
