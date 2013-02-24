//
//  IOSNDKHelper.cpp
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#import "IOSNDKHelper.h"
#import "NDKHelper.h"

#pragma mark -
#pragma mark Private To IOSNDKHelper.mm

static NSObject *helperInstance = nil;

void IOSNDKHelperImpl::SetNDKReciever(void *reciever)
{
    helperInstance = (NSObject*)reciever;
}

NSObject *getHelperInstance()
{
    return helperInstance;
}

#pragma mark -
#pragma mark IOSNDKHelperImpl Methods

void IOSNDKHelperImpl::RecieveCPPMessage(json_t *methodName, json_t *methodParams)
{
    NSObject *reciever = getHelperInstance();
    if (reciever == nil)
    {
        return;
    }
    
    if (methodName == NULL)
        return;
    
    const char* methodCalled = json_string_value(methodName);
    NSString *methodCalledStr = [NSString stringWithFormat:@"%@:", [NSString stringWithUTF8String:methodCalled]];
    
    SEL selectorToBeCalled;
    
    @try
    {
        selectorToBeCalled = NSSelectorFromString(methodCalledStr);
        
        // Return from message if the selector won't respond to our reciever
        if (![reciever respondsToSelector:selectorToBeCalled])
        {
            NSLog(@"Reciever won't respond to selector : %@", methodCalledStr);
            return;
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception trying to find selector to be called : %@", methodCalledStr);
        return;
    }
    
    if (methodParams != NULL)
    {
        // Convert the parameters into NSDictionary
        char* jsonStrLocal = json_dumps(methodParams, JSON_COMPACT | JSON_ENSURE_ASCII);
        NSString *methodParamsJson = [[NSString alloc] initWithUTF8String:jsonStrLocal];
        free(jsonStrLocal);
        
        NSData *jsonData = [methodParamsJson dataUsingEncoding:NSUTF8StringEncoding];
        [methodParamsJson release];
        methodParamsJson = nil;
    
        //parse out the json data
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:jsonData
                              options:kNilOptions
                              error:&error];
        
        // If parameters are available call the respective selector with parameters
        if (error == nil)
        {
            [reciever performSelector:selectorToBeCalled withObject:json];
        }
        else
        {
            return;
        }
    }
    else
    {
        [reciever performSelector:selectorToBeCalled withObject:[NSDictionary dictionary]];
    }
}

#pragma mark -
#pragma mark IOSNDKHelper Implementation

@implementation IOSNDKHelper

+(void)SendMessage:(NSString *)methodName WithParameters:(NSDictionary *)prms
{
    json_t* jsonMethod = json_string([methodName UTF8String]);
    json_t *jsonPrms = NULL;
    
    if (prms != nil)
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:prms
                            options:NSJSONWritingPrettyPrinted
                            error:&error];
        
        if (error != nil)
            return;
        
        NSString *jsonPrmsString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
        
        json_error_t jerror;
        jsonPrms = json_loads([jsonPrmsString UTF8String], 0, &jerror);
        
        if (!jsonPrms)
        {
            fprintf(stderr, "error: on line %d: %s\n", jerror.line, jerror.text);
            return;
        }
        
        [jsonPrmsString release];
        jsonPrmsString = nil;
    }
    
    NDKHelper::HandleMessage(jsonMethod, jsonPrms);
    json_decref(jsonMethod);
    
    if (jsonPrms)
        json_decref(jsonPrms);
}

+ (void) SetNDKReciever:(NSObject*)reciever
{
    IOSNDKHelperImpl::SetNDKReciever((void*)reciever);
}
@end