#import <UIKit/UIKit.h>
#import "GStreamerBackendDelegate.h"

@interface ViewController : UIViewController <GStreamerBackendDelegate> {
    IBOutlet UILabel *message_label;
    IBOutlet UIBarButtonItem *play_button;
    IBOutlet UIBarButtonItem *pause_button;
    IBOutlet UIView *video_view;
    IBOutlet UIView *video_container_view;
    IBOutlet NSLayoutConstraint *video_width_constraint;
    IBOutlet NSLayoutConstraint *video_height_constraint;
}

-(IBAction) play:(id)sender;
-(IBAction) pause:(id)sender;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

/* From GStreamerBackendDelegate */
-(void) gstreamerInitialized;
-(void) gstreamerSetUIMessage:(NSString *)message;
-(void) gstreamerSetState:(NSString *)state;

@end
