//
//  HeartRateDataCollector.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import CoreBluetooth;
#import "HeartRateDataCollector.h"
#import "HeartRateData.h"
#import "MetricCalculator.h"
#import "CaloriesCalculator.h"

@interface HeartRateDataCollector ()

@property (nonatomic) NSMutableArray<NSNumber *> *storedBpms;
@property (nonatomic) NSDate *collectingStartDate;

@end

@implementation HeartRateDataCollector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storedBpms = [NSMutableArray array];
    }
    return self;
}

- (void)calculateMetrics {
    CGFloat duration = ([NSDate date].timeIntervalSince1970 - self.collectingStartDate.timeIntervalSince1970);
    duration /= 60.f * 60.f;
    MetricCalculator *metricCalculator = [[MetricCalculator alloc] init];
    CaloriesCalculator *calc = [[CaloriesCalculator alloc] init];
    id<MetricProtocol> metric = [metricCalculator calculateMetricForHeartRateData:self.storedBpms age:calc.age fitnessLevel:FitnessLevelBeginner duration:duration];
    if (self.finishBlock) {
        self.finishBlock(metric);
    }
    CGFloat calories = [calc burntCaloriesForAvgHR:metric.avgHR exerciseDuration:duration];
    NSLog(@"Burnt %f", calories);
}

- (void)clearCollectedData {
    self.storedBpms = [NSMutableArray array];
}

#pragma mark - HeartRateDataCollectorProtocol

- (nullable id<HeartRateDataProtocol>)heartBPMDataForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSData *sensorData = characteristic.value;
    const uint8_t *reportData = sensorData.bytes;
    
    NSUInteger offset = 1;
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {
        bpm = reportData[1];
        offset = offset + 1;
    } else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
        offset =  offset + 2;
    }
    NSLog(@"bpm: %i", bpm);
    if (self.needToCollectData) {
        [self.storedBpms addObject:@(bpm)];
    }
    
    if ((reportData[0] & 0x03) == 1) {
        offset =  offset + 2;
    }
    
    NSMutableArray<NSNumber *> *rrValues = [NSMutableArray array];
    if ((reportData[0] & 0x04) == 0) {
        NSLog(@"%@", @"Data are not present");
    } else {
        NSUInteger count = (sensorData.length - offset) / 2;
        for (int i = 0; i < count; i++) {
            uint16_t rrValue = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[offset]));
            rrValue = (rrValue / 1024.0 ) * 1000.0;
            [rrValues addObject:@(rrValue)];
            offset = offset + 2;
        }
    }
    if (sensorData || !error) {
        HeartRateData *heartRateData = [[HeartRateData alloc] init];
        heartRateData.bpm = bpm;
        heartRateData.rrValues = rrValues;
        return heartRateData;
    }
    return nil;
}

- (nullable NSString *)manufacturerNameForCharacteristic:(nonnull CBCharacteristic *)characteristic {
    return [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

- (nonnull NSString *)bodyLocationForCharacteristic:(nonnull CBCharacteristic *)characteristic {
    NSData *sensorData = characteristic.value;
    const uint8_t *bodyData = sensorData.bytes;
    NSString *bodyDataString;
    if (bodyData) {
        uint8_t bodyLocation = bodyData[0];
        bodyDataString = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"];
    } else {
        bodyDataString = @"Body Location: N/A";
    }
    return bodyDataString;
}

#pragma mark - Setters

- (void)setNeedToCollectData:(BOOL)needToCollectData {
    _needToCollectData = needToCollectData;
    if (needToCollectData) {
        self.collectingStartDate = [NSDate date];
    } else {
        [self calculateMetrics];
    }
}

@end
