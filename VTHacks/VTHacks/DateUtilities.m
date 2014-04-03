//
//  DateUtilities.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "DateUtilities.h"

@implementation DateUtilities

#pragma mark - Utility Functions
//TODO: Put these functions into a Utility class
+ (void)sortArrayBasedOnDay:(NSMutableArray *)arrayToSort ascending:(BOOL)state
{
    NSDictionary *day = @{@"Monday": @1, @"Tuesday": @2, @"Wednesday" : @3, @"Thursday" : @4, @"Friday" : @5, @"Saturday" : @6, @"Sunday" : @7};
    //TODO: Create singleton for NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    if (state)
    {
        [arrayToSort sortUsingComparator:^NSComparisonResult(id string1, id string2) {
            NSNumber *day1 = day[string1];
            NSNumber *day2 = day[string2];
            return [day1 compare:day2];
        }];
    }
    else
    {
        [arrayToSort sortUsingComparator:^NSComparisonResult(id string1, id string2) {
            NSNumber *day1 = day[string1];
            NSNumber *day2 = day[string2];
            return [day2 compare:day1];
        }];

    }
}

+ (NSArray *)sortArrayOfEventDictByTimeStamp:(NSArray *)arrayToSort ascending:(BOOL)state
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    
    
    if (state)
    {
        NSArray *ascending = [arrayToSort sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *event1, NSDictionary *event2) {
            NSDate *date1 = [dateFormatter dateFromString:event1[@"timestamp"]];
            NSDate *date2 = [dateFormatter dateFromString:event2[@"timestamp"]];
            return [date1 compare:date2];
        }];
        return ascending;
    }
    else
    {
        NSArray *descending = [arrayToSort sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *event1, NSDictionary *event2) {
            NSDate *date1 = [dateFormatter dateFromString:event1[@"timestamp"]];
            NSDate *date2 = [dateFormatter dateFromString:event2[@"timestamp"]];
            return [date2 compare:date1];
        }];
        return descending;
    }
}

@end
