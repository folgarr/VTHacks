

#define CONFIRM_SUBSCRIPTION_MESSAGE    @"A confirmation must be accepted before messages are received."
#define QUEUE_NOTICE                    @"It may take a few minutes before the queue starts receiving messages."
#define SMS_SUBSCRIPTION_MESSAGE        @"SMS Subscritions must include country codes.  1 for US phones."
#define CREDENTIALS_MESSAGE             @"AWS Credentials not configured correctly.  Please review the README file."
#define PLATFORM_APPLICATION_ARN_MESSAGE @"Platform Application ARN is not configured correctly. please review the README file."

#define TOPIC_NAME                      @"VTHacksTopic"
#define QUEUE_NAME                      @"VTHacksQueue"
#define PLATFORM_APPLICATION_ARN        @"arn:aws:sns:us-east-1:860000342007:app/APNS/VTHacksProduction"

#define TOPIC_ARN   @"arn:aws:sns:us-east-1:860000342007:VTHacksTopic"
#define QUEUE_URL   @"https://sqs.us-east-1.amazonaws.com/860000342007/VTHacksQueue"
#define QUEUE_ARN   @"arn:aws:sqs:us-east-1:860000342007:VTHacksQueue"
#define MAPS_URL    @"http://vthacks-env-pmkrjpmqpu.elasticbeanstalk.com/get_map"

@interface Constants:NSObject {}

+(UIAlertView *)confirmationAlert;
+(UIAlertView *)queueAlert;
+(UIAlertView *)smsSubscriptionAlert;
+(UIAlertView *)credentialsAlert;
+(UIAlertView *)platformApplicationARNAlert;
+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message;
@end
