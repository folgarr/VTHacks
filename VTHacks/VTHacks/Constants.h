
#define ACCESS_KEY_ID                @"ASIAIVBCPPY7Z52DZ6AA"
#define SECRET_KEY                   @"IizwIQMI6I3/bt8kPbKecSkbqOOB+GueUi6oxOSM"
#define SECURITY_TOKEN               @"AQoDYXdzEMf//////////wEaoAKf7sgYM5BOTxChLmqMBdJbxnFx6X8TmMx7DtwLhroJuUQcgobB648U+0yNc9lG5u8nG/6UAVOo+WdpR+oRJa5x90aT2NKcIgw3ISKIgRgJJrhwfYzHfTVkG/i5TTPFAquaE+zhkv3Jibj1JNZm4QsS3CioVGNeTT5FOGndBFERFypvMMf6HyC/cY/P1yf400zHKlE0ZEtdTEKJsMCOf0JFD0dlKhvfSS5qcyqITeXgV2SKRiP3XOXjpBTnAjv0rb6463gvy/4SDNvZNDdf3GF4NSceUmu+YW49FeLnHPbcFJUb/lje6lKaeuJL2j/v8ktqKdbtcQPaK5mxftHcyLa3V2fMhsYUaStG9xDoGtYHHxsbdzZmPHh2gtbDGJuvhfAgl6LimQU="
#define CONFIRM_SUBSCRIPTION_MESSAGE    @"A confirmation must be accepted before messages are received."
#define QUEUE_NOTICE                    @"It may take a few minutes before the queue starts receiving messages."
#define SMS_SUBSCRIPTION_MESSAGE        @"SMS Subscritions must include country codes.  1 for US phones."
#define CREDENTIALS_MESSAGE             @"AWS Credentials not configured correctly.  Please review the README file."
#define PLATFORM_APPLICATION_ARN_MESSAGE @"Platform Application ARN is not configured correctly. please review the README file."

#define TOPIC_NAME                      @"VTHacksTopic"
#define QUEUE_NAME                      @"VTHacksQueue"

#define PLATFORM_APPLICATION_ARN        @"arn:aws:sns:us-east-1:860000342007:app/APNS_SANDBOX/VTHacks"

#define ACTUAL_NAME                     @"normaluser"
#define TEST_NAME_1                     @"Billy"
#define TEST_NAME_2                     @"Bobby"
#define TOPIC_ARN   @"arn:aws:sns:us-east-1:860000342007:VTHacksTopic"
#define QUEUE_URL   @"https://sqs.us-east-1.amazonaws.com/860000342007/VTHacksQueue"
#define QUEUE_ARN   @"arn:aws:sqs:us-east-1:860000342007:VTHacksQueue"

@interface Constants:NSObject {}

+(UIAlertView *)confirmationAlert;
+(UIAlertView *)queueAlert;
+(UIAlertView *)smsSubscriptionAlert;
+(UIAlertView *)credentialsAlert;
+(UIAlertView *)platformApplicationARNAlert;
+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message;
@end
