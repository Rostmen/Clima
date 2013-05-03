//
//  CLWeather.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLWeather.h"

@implementation CLWeather

- (NSString *)description {
    return [NSString stringWithFormat:@"Time: %@\nCity: %@, \nTemperature: %@", [NSDate dateWithTimeIntervalSince1970:[_date doubleValue]], _city, _temp];
}

@end
