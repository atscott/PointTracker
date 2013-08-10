//
//  ChartData.h
//  PointTracker
//
//  Created by Andrew Scott on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSData;
@class WSGraphConnections;

@interface ChartData : NSObject


/** Return the leading 10 people in points */
+ (WSData *)top10;

/** total points from wednesday to tuesday */
+(WSData *)totalPointsLast5Weeks;

/** point listing of boys vs grils */
+(WSData *)boysVsGirls;

@end
