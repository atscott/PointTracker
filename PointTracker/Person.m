//
//  Person.m
//  tableViewLearning
//
//  Created by Andrew Moore on 4/15/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@implementation Person : NSObject
@synthesize firstName, lastName, phoneNumber;

-(id) initWithFirstName:(NSString *)theFirstName
               lastName:(NSString *)theLastName
            phoneNumber:(NSString *)thePhoneNumber
{
    self = [super init];
    if(self)
    {
        [self setFirstName:theFirstName];
        [self setLastName:theLastName];
        [self setPhoneNumber:thePhoneNumber];
    }
    return self;
}

-(NSString *) description
{
    NSString *description = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    return description;
}

+(Person *) createRandomStranger
{
    NSArray *randomNameList = [NSArray arrayWithObjects:
                               @"Andrew",
                               @"Ben",
                               @"Abby",
                               @"Freddy", nil];
    NSInteger firstNameRandIndex = rand() % [randomNameList count];
    
    NSArray *randomLastNameList = [NSArray arrayWithObjects:
                                   @"Moore",
                                   @"Edington",
                                   @"Holsbo",
                                   @"Smith", nil];
    NSInteger lastNameRandIndex = rand() % [randomLastNameList count];
    
    NSString *randomFirstName = [NSString stringWithFormat:@"%@",
                                 [randomNameList objectAtIndex:firstNameRandIndex]];
    NSString *randomLastName = [NSString stringWithFormat:@"%@",
                                [randomLastNameList objectAtIndex:lastNameRandIndex]];
    
    Person *p = [[self alloc]initWithFirstName:randomFirstName lastName:randomLastName phoneNumber:@"123456789"];
    
    return p;
}




@end