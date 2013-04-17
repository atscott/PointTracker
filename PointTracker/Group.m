//
//  Group.m
//  tableViewLearning
//
//  Created by Andrew Moore on 4/15/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import "Group.h"
#import "Person.h"

@implementation Group

+ (Group *)defaultGroup
{
    static Group *defaultGroup = nil;
    if(!defaultGroup)
    {
        defaultGroup = [[super allocWithZone:nil] init];
    }
    
    return defaultGroup;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultGroup];
}

-(id) init
{
    self = [super init];
    if(self)
    {
        group = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) removePerson:(Person *)personToRemove
{
    [group removeObjectIdenticalTo:personToRemove];
}

-(void) movePersonAtIndex:(int)from
                  toIndex:(int)to
{
    if(from != to)
    {
        Person *temp = [group objectAtIndex:from];
        [group removeObjectAtIndex:from];
        [group insertObject:temp atIndex:to];
    }
}

-(bool) addPerson:(Person *)personToAdd
{
    [group addObject:personToAdd];
    return YES;
}

-(NSArray *) getGroup
{
    return group;
}



@end
