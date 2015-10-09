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

@interface CLWeatherCenter () 

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *apiKey;
//@property (nonatomic, strong) id<GAITracker> tracker;

@end

@implementation CLWeatherCenter 

static CLWeatherCenter *sharedService = nil;

+ (CLWeatherCenter *)sharedService {
    return sharedService;
}

+ (void)setSharedService:(CLWeatherCenter *)service {
    sharedService = service;
}

+ (CLWeatherCenter *)serviceWithApiKey:(NSString *)apiKey {
    CLWeatherCenter *service = [[CLWeatherCenter alloc] initWithApiKey:apiKey];
    if (!sharedService) {
        sharedService = service;
    }
    return service;
}

- (NSDictionary *)accessParameters {
    return @{@"APPID": self.apiKey};
}

- (id)initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
        [self configurateRestKit];
        //_tracker = [[GAI sharedInstance] defaultTracker];
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
        @"id":              @"city_id",
        @"coord.lat":       @"lat",
        @"coord.lon":       @"lon"
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

#pragma mark - Update weather;

- (void)updateByLocation:(CLLocationCoordinate2D)location
                  finish:(CLWeatherFinish)finish {
    

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
    
    
    NSMutableDictionary *params = [self.accessParameters mutableCopy];
    [params addEntriesFromDictionary:@{@"lat": @(location.latitude),
                                       @"lon": @(location.longitude),
                                       @"lang": @"en"}];
    
    [[RKObjectManager sharedManager] getObject:nil path:@"weather" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){

        _lastWeather = [mappingResult firstObject];
        NSLog(@"%@", _lastWeather);
        if (finish) finish(nil, _lastWeather);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WeatherDidChangeNotification
                                                            object:_lastWeather
                                                          userInfo:nil];
        
        
//        [_tracker sendEventWithCategory:@"Weather API"
//                             withAction:@"Checked weather"
//                              withLabel:nil
//                              withValue:nil];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Weather is not received!");
        //[_tracker sendException:NO withNSError:error];
        if (finish) finish (error, nil);
    }];
}

- (void)searchWeather:(NSString *)query
              success:(CLWeatherCenterSuccess)success {
    
    NSMutableDictionary *params = [self.accessParameters mutableCopy];
    [params addEntriesFromDictionary:@{
                             @"q": query,
                             @"lang": @"en"
                            }];
    
    [[RKObjectManager sharedManager] getObject:nil path:@"weather" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        CLWeather *weather = [mappingResult firstObject];
        
        if (success) success(weather);
        
//        [_tracker sendEventWithCategory:@"Weather API"
//                             withAction:@"Find weather"
//                              withLabel:nil
//                              withValue:nil];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Weather is not received!");
//        [_tracker sendException:NO withNSError:error];
    }];
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
