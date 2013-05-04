//
//  CLMyLocation.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLMyLocation.h"

@interface CLMyLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation CLMyLocation

- (id)initWithName:(NSString*)name
       temperature:(NSString*)temperature
        coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.temperature = temperature;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _temperature;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;

    return mapItem;
}

@end
