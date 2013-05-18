//
//  SampleNDKAppController.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//  
//

#import "RootViewController.h"
#include "IOSNDKHelper.h"

@implementation RootViewController

#pragma mark -
#pragma mark Attaching NDK Reciever

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        
        // Tell NDKHelper that RootViewController will respond to messages
        // Coming from C++
        [IOSNDKHelper SetNDKReciever:self];
        
        // Add a button to screen after a delay
        [self performSelector:@selector(addButton) withObject:nil afterDelay:3.0f];
    }
    return self;
}

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskAllButUpsideDown;
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Sample Selector to call

- (void) SampleSelector:(NSObject *)prms
{
    NSLog(@"purchase something called");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);

    // Fetching the name of the method to be called from Native to C++
    // For a ease of use, i have passed the name of method from C++
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"to_be_called"];
    
    // Show a bogus pop up here
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                                      message:@"This is a sample popup on iOS"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    // Send C++ a message with paramerts
    // C++ will recieve this message, only if the selector list will have a method
    // with the string we are passing
    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled WithParameters:nil];
}

- (void) SampleSelectorWithData:(NSObject *)prms
{
    NSLog(@"purchase something called");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    
    // Fetching the name of the method to be called from Native to C++
    // For a ease of use, i have passed the name of method from C++
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"to_be_called"];
    
    // Show a bogus pop up here
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                                      message:@"This is a sample popup on iOS"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    // Lets create a sample data to be passed to C++, and there we will fetch the data
    NSString *jsonStr = @"{\"sample_dictionary\":{\"sample_array\":[\"1\",\"2\",\"3\",\"4\",\"5\",\"6\",\"7\",\"8\",\"9\",\"10\",\"11\"],\"sample_integer\":1234,\"sample_float\":12.34,\"sample_string\":\"a string\"}}";
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    // Send C++ a message with paramerts
    // C++ will recieve this message, only if the selector list will have a method
    // with the string we are passing
    if (e != nil)
    {
        // If encountered some error, then don't pass the params
        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled WithParameters:nil];
    }
    else
    {
        // Else lets try passing parameters from here
        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled WithParameters:dict];
    }
}

// Adds a button on main screen
- (void) addButton
{
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tapButton setTitle:@"Tap to change text" forState:UIControlStateNormal];
    [tapButton addTarget:self action:@selector(ChangeSomethingInCocos) forControlEvents:UIControlEventTouchUpInside];
    tapButton.frame = CGRectMake(0, 150, 150, 80);
    
    [self.view addSubview:tapButton];
}

- (void) ChangeSomethingInCocos
{
    [IOSNDKHelper SendMessage:@"ChangeLabelSelector" WithParameters:nil];
}

@end
