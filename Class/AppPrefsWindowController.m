//
//  AppPrefsWindowController.m
//


#import "AppPrefsWindowController.h"


@implementation AppPrefsWindowController




- (void)setupToolbar
{
	[self addView:generalPreferenceView label:@"General" image:[NSImage imageNamed:@"NSPreferencesGeneral"]];
	[self addView:updatesPreferenceView label:@"Updates"];
	[self addView:advancedPreferenceView label:@"Advanced" image:[NSImage imageNamed:@"NSAdvanced"]];
	
		// Optional configuration settings.
	[self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
	[self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}




@end
