//
//  ANHeartRateDataCollector.m
//  PolarDemo
//
//  Created by Artem on 26/02/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

@import CoreBluetooth;
#import "ANHeartRateDataCollector.h"
#import "ANHeartRateData.h"
#import "ANMetricCalculator.h"
#import "ANCaloriesCalculator.h"

@interface ANHeartRateDataCollector ()

@property (nonatomic) NSMutableArray<NSNumber *> *storedHeartRate;
@property (nonatomic) NSDate *collectingStartDate;

@end

@implementation ANHeartRateDataCollector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storedHeartRate = [NSMutableArray array];
    }
    return self;
}

- (void)calculateMetricsForStartDate:(NSDate *)startDate {
    CGFloat duration = ([NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970);
    duration /= 60.f * 60.f;
    ANMetricCalculator *metricCalculator = [[ANMetricCalculator alloc] init];
    ANCaloriesCalculator *caloriesCalculator = [[ANCaloriesCalculator alloc] init];
    caloriesCalculator.input = self.calculatingWillStartBlock();
#warning Some hardcode
    id<ANMetricProtocol> metric = [metricCalculator calculateMetricForHeartRateData:self.storedHeartRate age:caloriesCalculator.input.age fitnessLevel:FitnessLevelBeginner duration:duration];
    metric.burnedCalories = [caloriesCalculator burntCaloriesForAvgHR:metric.avgHR exerciseDuration:duration];
    if (self.calculatingDidFinishBlock) {
        self.calculatingDidFinishBlock(metric);
    }
}

- (void)clearCollectedData {
    [self.storedHeartRate removeAllObjects];
}

#pragma mark - ANHeartRateDataCollectorProtocol

- (nullable id<ANHeartRateDataProtocol>)heartBPMDataForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
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
        [self.storedHeartRate addObject:@(bpm)];
    }
    
    if ((reportData[0] & 0x03) == 1) {
        offset =  offset + 2;
    }
    
    NSMutableArray<NSNumber *> *rrIntervals = [NSMutableArray array];
    if ((reportData[0] & 0x04) == 0) {
        NSLog(@"%@", @"Data are not present");
    } else {
        NSUInteger count = (sensorData.length - offset) / 2;
        for (int i = 0; i < count; i++) {
            uint16_t rrValue = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[offset]));
            rrValue = (rrValue / 1024.0 ) * 1000.0;
            [rrIntervals addObject:@(rrValue)];
            offset = offset + 2;
        }
    }
    if (sensorData || !error) {
        ANHeartRateData *heartRateData = [[ANHeartRateData alloc] init];
        heartRateData.bpm = bpm;
        heartRateData.rrIntervals = rrIntervals;
        return heartRateData;
    } else {
        //Error
        return nil;
    }
}

- (nullable NSString *)manufacturerNameForCharacteristic:(nonnull CBCharacteristic *)characteristic {
    return [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

- (BodyLocation)bodyLocationForCharacteristic:(nonnull CBCharacteristic *)characteristic {
    NSData *sensorData = characteristic.value;
    const uint8_t *bodyData = sensorData.bytes;
    if (bodyData) {
        uint8_t bodyLocation = bodyData[0];
        return bodyLocation == 1 ? BodyLocationChest : BodyLocationUndefined;
    } else {
        return BodyLocationNA;
    }
}

#pragma mark - Setters

- (void)setNeedToCollectData:(BOOL)needToCollectData {
    _needToCollectData = needToCollectData;
    if (needToCollectData) {
        self.collectingStartDate = [NSDate date];
    } else {
        [self calculateMetricsForStartDate:self.collectingStartDate];
    }
}

@end
