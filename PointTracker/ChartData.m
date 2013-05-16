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
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query orderByDescending:@"points"];
    query.limit = 10;
    NSArray *data = [query findObjects];
    
    WSData *result = nil;
    if(data.count > 0){
        float points[data.count];
        NSString* names[data.count];
        for(int i=0; i<data.count; i++)
        {
            points[i] = [[[data objectAtIndex:i] objectForKey:@"points"] floatValue];
            NSString *name = [[data objectAtIndex:i] valueForKey:@"firstName"];
            names[i] = (name == NULL ? @"null" : name);
        }
        return [[WSData dataWithValues:[WSData arrayWithFloat:points
                                                          len:data.count]
                           annotations:[NSArray arrayWithObjects:names
                                                           count:data.count]]
                indexedData];
    }
    
    return result;
}

+(WSData *)historyForCurrentUser{
    
    WSData *result = nil;
    PFQuery *queryForCurrentUser = [PFQuery queryWithClassName:@"People" ];
    [queryForCurrentUser whereKey:@"userLink" equalTo:[PFUser currentUser]];
    PFObject *currentUser = [queryForCurrentUser getFirstObject];
    if(currentUser != nil){
        PFQuery *logQuery = [PFQuery queryWithClassName:@"PointLog"];
        [logQuery whereKey:@"addedToPointer" equalTo:currentUser];
        [logQuery orderByDescending:@"createdAt"];
        logQuery.limit = 10;
        NSArray *data = [logQuery findObjects];
        
        if(data.count > 0){
            int newCount = data.count;
            if(data.count < 3){
                newCount = 3;
            }
            float points[newCount];
            NSString *dates[newCount];
            for(int i=0; i<newCount;i++){
                points[i] = 0;
                dates[i] = @"";
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd/yy"];
            for(int i=data.count - 1; i>=0; i--)
            {
                
                points[i] = [[[data objectAtIndex:i] objectForKey:@"pointsAdded"] floatValue];
                
                dates[i] = [formatter stringFromDate:[[data objectAtIndex:i] createdAt]];
            }
            
            
            result = [[WSData dataWithValues:[WSData arrayWithFloat:points
                                                                len:newCount]
                                 annotations:[NSArray arrayWithObjects:dates
                                                                 count:newCount]]
                      indexedData];
        }
    }
    
    return result;
}

+(WSData *)totalPointsLast5Weeks{
    
    NSDate *startDates[5];
    NSDate *endDates[5];
    NSDate *today = [NSDate date];
    NSDate *lastWednesday = [today dateByAddingTimeInterval:
                             -1*[ChartData daysSinceWednesday]*24*60*60];
    startDates[0]= lastWednesday;
    endDates[0] = today;
    //subtract 1 day from last wednesday to get last tuesday, the end date
    //for the last weekly interval
    NSDate *tuesday = [lastWednesday dateByAddingTimeInterval:-1*24*60*60];
    for(int i=1;i<5;i++)
    {
        //subtract 7 days from the current last wednesday to get the wednesday
        //before that, the start date for the previous interval
        lastWednesday = [lastWednesday dateByAddingTimeInterval:-7*24*60*60];
        startDates[i] = lastWednesday;
        endDates[i] = tuesday;
        tuesday = [tuesday dateByAddingTimeInterval:-7*24*60*60];
    }
    
    //get the entire points log
    PFQuery *query = [PFQuery queryWithClassName:@"PointLog"];
    NSArray *data = [query findObjects];
    float pointsForDateRange[5];
    for(int i=0;i<5;i++){
        pointsForDateRange[i] = 0;
    }
    
    for(PFObject *obj in data)
    {
        Boolean matched = false;
        int index = 0;
        while(!matched && index < 5)
        {
            matched = [ChartData isDate:obj.createdAt
                     greaterThanOrEqual:startDates[index]
                     andLessThanOrEqual:endDates[index]];
            index++;
        }
        
        if(matched)
        {
            index--;
            pointsForDateRange[index] += [[obj objectForKey:@"pointsAdded"] floatValue];
        }
    }
    
    NSString *annotationArray[5];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    for(int i=0; i<5; i++)
    {
        annotationArray[i] = [formatter stringFromDate:startDates[i]];
    }
    
    
    return [[WSData dataWithValues:[WSData arrayWithFloat:pointsForDateRange
                                                      len:5]
                       annotations:[NSArray arrayWithObjects:annotationArray
                                                       count:5]]indexedData];
}


+(Boolean)isDate:(NSDate *)date1 greaterThanOrEqual:(NSDate *)date2 andLessThanOrEqual:(NSDate *) date3
{
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date1 interval:NULL forDate:date1];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date2 interval:NULL forDate:date2];
    
    NSComparisonResult result = [date1 compare:date2];
    Boolean retVal = false;
    if (result == NSOrderedAscending) {
        //date 1 less than date 2
        retVal = false;
    } else if (result == NSOrderedDescending) {
        //date 1 greater than date 2
        retVal = true;
    }  else {
        //date 1 equal to date 2
        retVal = true;
    }
    
    if(retVal == true)
    {
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date1 interval:NULL forDate:date1];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date3 interval:NULL forDate:date3];
        
        NSComparisonResult result = [date1 compare:date3];
        if (result == NSOrderedAscending) {
            retVal = true;
        } else if (result == NSOrderedDescending) {
            retVal = false;
        }  else {
            retVal = true;
        }
    }
    return retVal;
    
}

+(int)daysSinceWednesday
{
    //1=sunday, 7=saturday, 4=wednesday
    int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    weekday-=4;
    if(weekday < 0){
        weekday = 7+weekday;
    }
    return weekday;
}

+(WSData *)boysVsGirls{
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query whereKey:@"isBoy" equalTo:[NSNumber numberWithBool:YES]];
    NSArray *boys = [query findObjects];
    query = [PFQuery queryWithClassName:@"People"];
    [query whereKey:@"isBoy" equalTo:[NSNumber numberWithBool:NO]];
    NSArray *girls = [query findObjects];
    
    float pointsGirls = 0;
    for(int i=0; i<girls.count; i++)
    {
        pointsGirls += [[[girls objectAtIndex:i] objectForKey:@"points"] floatValue];
    }
    
    float pointsBoys = 0;
    for(int i=0; i<boys.count; i++)
    {
        pointsBoys += [[[boys objectAtIndex:i] objectForKey:@"points"] floatValue];
    }
    
    float pointArray[3] = {pointsGirls, pointsBoys, 0};
    NSString *annotationArray[3] = {@"Girls", @"Boys", @""};
    return [[WSData dataWithValues:[WSData arrayWithFloat:pointArray
                                                      len:3]
                       annotations:[NSArray arrayWithObjects:annotationArray
                                                       count:3]]indexedData];
    
    
}

@end
