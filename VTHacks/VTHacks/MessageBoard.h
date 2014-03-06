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

@interface MessageBoard:NSObject
{
    AmazonSNSClient *snsClient;
    AmazonSQSClient *sqsClient;
    NSString        *topicARN;
    NSString        *queueUrl;
    
    NSString        *endpointARN;
}

+(MessageBoard *)instance;

-(id)init;
-(NSString *)createTopic;
-(bool)createApplicationEndpoint;
-(void)deleteTopic;
-(NSString *)findTopicArn;
-(NSString *)findEndpointARN;
-(bool)subscribeDevice;
-(void)subscribeEmail:(NSString *)emailAddress;
-(void)subscribeSms:(NSString *)smsNumber;
-(void)post:(NSString *)theMessage;
-(bool)pushToMobile:(NSString*)theMessage;
-(NSMutableArray *)listSubscribers;
-(NSMutableArray *)listEndpoints;
-(void)updateEndpointAttributesWithendPointARN:(NSString *)endpointArn Attributes:(NSMutableDictionary *)attributeDic;
-(void)removeSubscriber:(NSString *)subscriptionArn;
-(void)removeEndpoint:(NSString *)endpointArn;
-(NSString *)findQueueUrl;
-(NSMutableArray *)getMessagesFromQueue;
-(void)subscribeQueue;
-(NSString *)createQueue;
-(void)deleteQueue;
-(NSString *)getQueueArn:(NSString *)queueUrl;
-(void)addPolicyToQueueForTopic:(NSString *)queueUrl queueArn:(NSString *)queueArn;
-(NSString *)generateSqsPolicyForTopic:(NSString *)queueArn;
-(void)deleteMessageFromQueue:(SQSMessage *)message;

-(void)changeVisibilityTimeoutForQueue:(NSString*)theQueueUrl toSeconds:(int)seconds;
@end
