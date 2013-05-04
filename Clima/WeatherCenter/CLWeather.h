//
//  CLWeather.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 ; company. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

 Weather From
 http://bugs.openweathermap.org/projects/api/wiki/Weather_Data
 
*/
@interface CLWeather : NSObject

// Time of data receiving in unixtime GMT
@property (nonatomic, strong) NSNumber *date;

// City identificator
@property (nonatomic, strong) NSNumber *city_id;
//City name
@property (nonatomic, strong) NSString *city;

//Country
@property (nonatomic, strong) NSString *country;

// Humidity in %
@property (nonatomic, strong) NSNumber *humidity;

// Temperature in Kelvin. Subtracted 273.15 from this figure to convert to Celsius.
@property (nonatomic, strong) NSNumber *temp;

// Minimum and maximum temperature
@property (nonatomic, strong) NSNumber *temp_min;
@property (nonatomic, strong) NSNumber *temp_max;

// Atmospheric pressure in hPa
@property (nonatomic, strong) NSNumber *pressure;

// Wind speed in mps
@property (nonatomic, strong) NSNumber *wind_speed;

// Wind direction in degrees (meteorological)
@property (nonatomic, strong) NSNumber *wind_deg;

// Cloudiness in %
@property (nonatomic, strong) NSNumber *cloudiness;

// Rain Precipitation volume mm per 3 hours
@property (nonatomic, strong) NSNumber *rain;

// Snow Precipitation volume mm per 3 hours
@property (nonatomic, strong) NSNumber *snow;

// City location
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSNumber *lat;

@end
