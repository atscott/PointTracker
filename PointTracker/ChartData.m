//
//  ChartData.m
//  PointTracker
//
//  Created by wxynot on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "ChartData.h"
#import "PowerPlot.h"
#import <Parse/Parse.h>


@implementation ChartData
+ (WSData *)top10 {
    
    PFQuery *query = [PFQuery queryWithClassName:@"People2"];
    [query orderByDescending:@"points"];
    query.limit = 10;
    NSArray *data = [query findObjects];
    
    float points[data.count];
    NSString* names[data.count];
    for(int i=0; i<data.count; i++)
    {
        points[i] = [[[data objectAtIndex:i] objectForKey:@"points"] floatValue];
        names[i] = [[data objectAtIndex:i] objectForKey:@"firstName"];
        
    }
    
    return [WSData dataWithValues:[WSData arrayWithFloat:points
                                                     len:data.count]
                      annotations:[NSArray arrayWithObjects:names
                                                      count:data.count]];
}

+(WSData *)historyForUser:(NSString *) userID fromLog: (NSString *) logName{
    PFQuery *test = [PFQuery queryWithClassName:@"People"];
    PFObject *andrew = [test getObjectWithId:@"bMWZwS6ALN"];
    PFRelation *relation = [andrew relationforKey:@"log"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    NSArray *data = [query findObjects];
    float points[data.count];
    NSString *dates[data.count];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    for(int i=0; i<data.count; i++)
    {

        points[i] = [[[data objectAtIndex:i] objectForKey:@"currentPoints"] floatValue];

        dates[i] = [formatter stringFromDate:[[data objectAtIndex:i] createdAt]];
    }
    
    WSData *result = [WSData dataWithValues:[WSData arrayWithFloat:points
                                                               len:data.count]
                                annotations:[NSArray arrayWithObjects:dates
                                                                count:data.count]];
    
    return [result indexedData];
}

@end
