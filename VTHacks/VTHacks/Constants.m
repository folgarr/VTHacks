#import "Constants.h"

@implementation Constants


+(UIAlertView *)confirmationAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Confirmation Required" message:CONFIRM_SUBSCRIPTION_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+(UIAlertView *)queueAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Message Queue" message:QUEUE_NOTICE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+(UIAlertView *)smsSubscriptionAlert
{
    return [[UIAlertView alloc] initWithTitle:@"SMS Validation" message:SMS_SUBSCRIPTION_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+(UIAlertView *)credentialsAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Missing Credentials" message:CREDENTIALS_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+(UIAlertView *)platformApplicationARNAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Missing PlatformApplicationARN" message:PLATFORM_APPLICATION_ARN_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message {
    
    return [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
