//
//  MessageBoard.h
//  VTHacks
//
//  Created by Carlos Second Admin on 3/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSSNS/AWSSNS.h>
#import <AWSSQS/AWSSQS.h>



typedef void (^completionHandler)(NSDictionary *jsonDictionary, NSError *serverError);
typedef void (^jsonListCallback)(NSMutableArray* jsonList, NSError *serverError);

@interface MessageBoard:NSObject<NSURLConnectionDelegate>
{
    
    // Clients and Amazon Resource names
    AmazonSNSClient *snsClient;
    AmazonSQSClient *sqsClient;
    NSString        *topicARN;
    NSString        *queueUrl;
    NSString        *endpointARN;
    
    // Temporary credential info
    AmazonCredentials *credentials;
    NSString *tempACCESS_KEY_ID;
    NSString *tempSECRET_KEY;
    NSString *tempSECURITY_TOKEN;
    NSString *tempExpirationString;
    NSString *platformARN;
    
    // Holds the response data from any server call
    NSMutableData *_responseData;

    // name identifier attached to server calls (randomly generated on first run)
    NSString *nameIdentifier;
    
    // store announcements here
    NSMutableArray* cachedAnnouncements;
    
    // did do the correct aws setup
    BOOL didSetupCorrectly;
}

+(MessageBoard *)instance;
-(void)getDataFromServer:(NSString*) type completionHandler:(completionHandler)handler;
-(void)getAnnouncements:(jsonListCallback)handler usingPullToRefresh:(BOOL)wantCached;

-(id)init;
-(bool)createApplicationEndpoint;
-(NSString *)findEndpointARN;
-(bool)subscribeDevice;
-(NSMutableArray *)getMessagesFromQueueWithError:(NSError*)error;
-(void)subscribeQueue;
-(void)deleteMessageFromQueue:(SQSMessage *)message;
-(void)updateCacheWithAnnouncement:(NSDictionary *)announcement;
+(NSString *)getSimpleTimeFromDateString:(NSString *)dateString;


@end
