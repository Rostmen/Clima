//
//  CLMyLocation.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLMyLocation : NSObject<MKAnnotation>

- (id)initWithName:(NSString*)name
       temperature:(NSString*)temperature
        coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
