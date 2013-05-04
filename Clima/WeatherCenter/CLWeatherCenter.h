//
//  CLWeatherCenter.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLWeather.h"

extern NSString *const WeatherDidChangeNotification;

typedef void (^CLWeatherCenterSuccess)(CLWeather *weather);

@interface CLWeatherCenter : NSObject

+ (CLWeatherCenter *)service;

@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLWeather *lastWeather;

- (void)update;
- (void)searchWeather:(NSString *)query
              success:(CLWeatherCenterSuccess)success;
+ (void)playSound: (NSString *)name;

@end
