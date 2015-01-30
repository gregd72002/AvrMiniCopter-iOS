#import "ViewOptions.h"
#import "Utils.h"
#import "getgateway.h"
#import "route.h"
#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface ViewOptions () {

}

@end


@implementation ViewOptions
//@synthesize rpiaddress;

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *gw = [defaults objectForKey:@"rpiip"];
    rpiaddress.text = gw;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    
     // Create strings and integer to store the text info
    NSString *rpiip = rpiaddress.text;
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:rpiip forKey:@"rpiip"];
    [defaults synchronize];
    NSLog(@"Data saved: %@",rpiip);
    
    UIStoryboard *storyboard = self.storyboard;
    ViewOptions *svc = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    
    // Configure the new view controller here.
    
    [self presentViewController:svc animated:YES completion:nil];
}
@end