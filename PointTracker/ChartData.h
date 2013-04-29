//
//  ChartData.h
//  PointTracker
//
//  Created by wxynot on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSData;
@class WSGraphConnections;

@interface ChartData : NSObject


/** Return the leading 10 people in points */
+ (WSData *)top10;
+(WSData *)historyForUser:(NSString *) userID fromLog: (NSString *) logName;

@end
