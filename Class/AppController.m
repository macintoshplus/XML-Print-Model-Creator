#import "AppController.h"
#import "AppPrefsWindowController.h"


@implementation AppController

+ (void)initialize
{
	// This is just for the demo. It's not needed by DBPrefsWindowController.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"YES", @"fade",
								 @"YES", @"shiftSlowsAnimation",
								 nil];
	
    [defaults registerDefaults:appDefaults];
}


- (void)awakeFromNib
// This is just for the demo. It's not needed by DBPrefsWindowController.
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self
			   forKeyPath:@"fade" 
				  options:NSKeyValueObservingOptionOld
				  context:NULL];
    [defaults addObserver:self
			   forKeyPath:@"shiftSlowsAnimation" 
				  options:NSKeyValueObservingOptionOld
				  context:NULL];
}




- (void)dealloc
// This is just for the demo. It's not needed by DBPrefsWindowController.
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObserver:self
				  forKeyPath:@"fade"];
    [defaults removeObserver:self
				  forKeyPath:@"shiftSlowsAnimation"];
	[super dealloc];
}

- (IBAction)openPreference:(id)sender {
    
	[[AppPrefsWindowController sharedPrefsWindowController] showWindow:nil];
}
@end
