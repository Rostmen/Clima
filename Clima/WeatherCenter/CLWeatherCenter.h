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
typedef void (^CLWeatherFinish)(NSError *error, CLWeather *weather);

@interface CLWeatherCenter : NSObject

+ (CLWeatherCenter *)sharedService;
+ (void)setSharedService:(CLWeatherCenter *)service;
+ (CLWeatherCenter *)serviceWithApiKey:(NSString *)apiKey;

@property (nonatomic, strong) CLWeather *lastWeather;

- (void)updateByLocation:(CLLocationCoordinate2D)location
                  finish:(CLWeatherFinish)finish;
- (void)searchWeather:(NSString *)query
              success:(CLWeatherCenterSuccess)success;
+ (void)playSound:(NSString *)name;

@end
