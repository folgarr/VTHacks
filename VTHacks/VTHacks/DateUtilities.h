//
//  DateUtilities.h
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtilities : NSObject

+ (void)sortArrayBasedOnDay:(NSMutableArray *)arrayToSort ascending:(BOOL)state;
+ (NSArray *)sortArrayOfEventDictByTimeStamp:(NSArray *)arrayToSort ascending:(BOOL)state;

@end
