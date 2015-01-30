//
//  ViewOptions.h
//  RPiCameraStreamer
//
//  Created by Gregory Dymarek on 27/01/2015.
//
//

#ifndef RPiCameraStreamer_ViewOptions_h
#define RPiCameraStreamer_ViewOptions_h

#import <UIKit/UIKit.h>

@interface ViewOptions : UIViewController {


    __weak IBOutlet UITextField *rpiaddress;

    __weak IBOutlet UIButton *OK;
}
- (IBAction)click:(id)sender;
@end


#endif
