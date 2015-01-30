#import "ViewController.h"
#import "ViewOptions.h"
#import "GStreamerBackend.h"
#import "Utils.h"
#import "getgateway.h"
#import "route.h"
#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface ViewController () {
    GStreamerBackend *gst_backend;
    Utils *utils;
    int media_width;
    int media_height;
}

@end

unsigned char ip[4];
unsigned int port;
NSString *gw;
unsigned int gwport = 1035;
GCDAsyncUdpSocket *udpSocket ; // create this first part as a global variable
unsigned char packet[9];
NSData *data;

@implementation ViewController

/*
 * Methods from UIViewController
 */

-(void) callEverySecond:(NSTimer*) t
{
    [udpSocket sendData:data toHost:gw port:gwport withTimeout:-1 tag:1];
    //NSLog(@"ping : %@", gw );
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    UIStoryboard *storyboard = self.storyboard;
    ViewOptions *svc = [storyboard instantiateViewControllerWithIdentifier:@"OptionSBID"];
    
    // Configure the new view controller here.
    
    [self presentViewController:svc animated:YES completion:nil];
    
    /*
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    NSLog(@"Click");
    
    [self performSegueWithIdentifier:@"OptionSBID" sender:self];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    play_button.enabled = FALSE;
    pause_button.enabled = FALSE;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    /* Make these constant for now, later tutorials will change them */
    //media_width = 568*2;
    //media_height = 426;

    NSLog(@"Width + Height + Scale: %f %f %f",screenWidth,screenHeight,screenScale);
    media_width = screenWidth*screenScale/2.f;
    media_height = screenHeight*screenScale;
    utils = [[Utils alloc] init];
    NSString *ip_str = [utils getIPAddress:true];
    NSLog(@"IP: %@",ip_str);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    gw = [defaults objectForKey:@"rpiip"];
    
    if (gw==NULL || [gw isEqualToString:@""]) {
        struct in_addr gatewayaddr;
        int r = getdefaultgateway(&(gatewayaddr.s_addr));
        if(r>=0){
            gw = [NSString stringWithFormat: @"%s",inet_ntoa(gatewayaddr)];
            NSLog(@"default gateway : %@", gw );
        } else { NSLog(@"getdefaultgateway() failed"); }
    }
    
    NSLog(@"RPI IP : %@", gw );
    //gw=@"192.168.1.88";
    
    NSArray *fields = [ip_str componentsSeparatedByString:@"."];
    
    ip[0] = [fields[0] intValue];
    ip[1] = [fields[1] intValue];
    ip[2] = [fields[2] intValue];
    ip[3] = [fields[3] intValue];
    port = 8888;
    
    config(ip,port,media_width);
    
    gst_backend = [[GStreamerBackend alloc] init:self videoView:video_view];
    
    
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    packet[0] = 0;
    memcpy(packet+1,ip,4);
    int x = htonl(port);
    memcpy(packet+5,&x,4);
    data = [ NSData dataWithBytes: packet length: 9 ];
    
    [ self callEverySecond: NULL ];
    
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                      selector: @selector(callEverySecond:) userInfo: nil repeats: YES];
    [ gst_backend play ];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    //[singleFingerTap release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Called when the Play button is pressed */
-(IBAction) play:(id)sender
{
    [gst_backend play];
}

/* Called when the Pause button is pressed */
-(IBAction) pause:(id)sender
{
    [gst_backend pause];
}

- (void)viewDidLayoutSubviews
{
    CGFloat view_width = video_container_view.bounds.size.width;
    CGFloat view_height = video_container_view.bounds.size.height;

    CGFloat correct_height = view_width * media_height / media_width;
    CGFloat correct_width = view_height * media_width / media_height;

    if (correct_height < view_height) {
        video_height_constraint.constant = correct_height;
        video_width_constraint.constant = view_width;
    } else {
        video_width_constraint.constant = correct_width;
        video_height_constraint.constant = view_height;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

/*
 * Methods from GstreamerBackendDelegate
 */

-(void) gstreamerInitialized
{
    dispatch_async(dispatch_get_main_queue(), ^{
        play_button.enabled = TRUE;
        pause_button.enabled = TRUE;
        message_label.text = @"Ready";
    });
}

-(void) gstreamerSetState:(NSString *)state
{
    NSLog(@"STATE : %@", state );

}

-(void) gstreamerSetUIMessage:(NSString *)message
{
    NSLog(@"MESSAGE : %@", message );
}

@end
