//
//  ANErrorFactoryProtocol.h
//  NiceSocial
//
//  Created by Artem on 29/01/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANErrorFactoryProtocol <NSObject>

+ (nullable NSError *)errorForKey:(nonnull NSString *)errorKey;

@end
