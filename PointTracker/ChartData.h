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
/** return last 10 entries for points */
+(WSData *)historyForCurrentUser;
/** total points from wednesday to tuesday */
+(WSData *)totalPointsLast5Weeks;
/** point listing of boys vs grils */
+(WSData *)boysVsGirls;

@end
