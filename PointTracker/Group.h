//
//  Group.h
//  tableViewLearning
//
//  Created by Andrew Moore on 4/15/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface Group : NSObject
{
    NSMutableArray *group;
}

+(Group *)defaultGroup;
-(NSArray *) getGroup;
//- (Person *)createRandomStranger;
-(void)removePerson: (Person *) personToRemove;
-(bool) addPerson: (Person *) personToAdd;
-(void) movePersonAtIndex: (int)from
                  toIndex: (int)to;

@end
