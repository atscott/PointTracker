//
//  Person.h
//  tableViewLearning
//
//  Created by Andrew Moore on 4/15/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (id)initWithFirstName:(NSString *)firstName
               lastName:(NSString *)lastName
            phoneNumber:(NSString *)phoneNumber;
+ (Person *) createRandomStranger;

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic) int points;


@end
