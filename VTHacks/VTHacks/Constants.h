
#define ACCESS_KEY_ID                @""
#define SECRET_KEY                   @""
#define CONFIRM_SUBSCRIPTION_MESSAGE    @"A confirmation must be accepted before messages are received."
#define QUEUE_NOTICE                    @"It may take a few minutes before the queue starts receiving messages."
#define SMS_SUBSCRIPTION_MESSAGE        @"SMS Subscritions must include country codes.  1 for US phones."
#define CREDENTIALS_MESSAGE             @"AWS Credentials not configured correctly.  Please review the README file."
#define PLATFORM_APPLICATION_ARN_MESSAGE @"Platform Application ARN is not configured correctly. please review the README file."

#define TOPIC_NAME                      @"VTHacks"
#define QUEUE_NAME                      @"vthacks-queue"

#define PLATFORM_APPLICATION_ARN        @""

@interface Constants:NSObject {}

+(UIAlertView *)confirmationAlert;
+(UIAlertView *)queueAlert;
+(UIAlertView *)smsSubscriptionAlert;
+(UIAlertView *)credentialsAlert;
+(UIAlertView *)platformApplicationARNAlert;
+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message;
@end
