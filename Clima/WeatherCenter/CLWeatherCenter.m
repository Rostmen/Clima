//
//  CLWeatherCenter.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLWeatherCenter.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *const WeatherApiPoint = @"http://api.openweathermap.org/data/2.5/";
NSTimeInterval const WeatherApiTimeout = 10;

NSString *const WeatherDidChangeNotification = @"WeatherDidChangeNotification";

@interface CLWeatherCenter () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CLWeatherCenter 

+ (CLWeatherCenter *)service {
    static CLWeatherCenter *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[CLWeatherCenter alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        if ([self initLocationManager]) {
            [self configurateRestKit];
        }
    }
    return self;
}

#pragma mark - RestKit Stack

- (void)configurateRestKit {
    NSURL *weatherApiURL = [NSURL URLWithString:WeatherApiPoint];
    [RKObjectManager managerWithBaseURL:weatherApiURL];
    
    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:@"text/json"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/json"];
    
    RKObjectMapping *weatherMapping = [RKObjectMapping mappingForClass:[CLWeather class]];
    [weatherMapping addAttributeMappingsFromDictionary:
     @{
        @"name":            @"city",
        @"sys.country":     @"country",
        @"main.temp":       @"temp",
        @"main.humidity":   @"humidity",
        @"main.temp_min":   @"temp_min",
        @"main.temp_max":   @"temp_max",
        @"main.pressure":   @"pressure",
        @"wind.speed":      @"wind_speed",
        @"wind.deg":        @"wind_deg",
        @"clouds.all":      @"cloudiness",
        @"rain.3h":         @"rain",
        @"snow.3h":         @"snow",
        @"dt":              @"date",
        @"id":              @"city_id"
     }
    ];
    
    
    NSIndexSet *successfulCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *weatherResponse =
        [RKResponseDescriptor responseDescriptorWithMapping:weatherMapping
                                                pathPattern:@"weather"
                                                    keyPath:nil
                                                statusCodes:successfulCodes];
    [[RKObjectManager sharedManager] addResponseDescriptor:weatherResponse];
}

#pragma mark - Location Stack

- (BOOL)initLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1500.0f;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
        return YES;
    } else {
        NSLog(@"Location services is not enabled");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                                                            message:NSLocalizedString(@"Location services is not enabled", @"Location services is not enabled")
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    NSLog(@"Updated: latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    _lastLocation = location;
    [self updateByLocation:_lastLocation.coordinate];
}

#pragma mark - Update weather;

- (void)updateByLocation: (CLLocationCoordinate2D) location {
    

    if (_lastWeather) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if ([_lastWeather.date doubleValue] + WeatherApiTimeout > now) {
            NSLog(@"Too often times shooting at weather api!");
            return;
        }
    } else {
        _lastWeather = [CLWeather new];
        _lastWeather.date = @([[NSDate date] timeIntervalSince1970]);
    }
    
    
    NSDictionary *params = @{
                             @"lat": @(location.latitude),
                             @"lon": @(location.longitude),
                             @"lang": @"en"
                            };
    
    [[RKObjectManager sharedManager] getObject:nil path:@"weather" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){

        _lastWeather = [mappingResult firstObject];
        NSLog(@"%@", _lastWeather);
        [[NSNotificationCenter defaultCenter] postNotificationName:WeatherDidChangeNotification object:_lastWeather userInfo:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Weather is not received!");
    }];
}

- (void)update {
    [self updateByLocation:_lastLocation.coordinate];
}

#pragma mark - Sound

+ (void)playSound: (NSString *)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@",
                      [[NSBundle mainBundle] resourcePath], name];
    
    
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}



@end
