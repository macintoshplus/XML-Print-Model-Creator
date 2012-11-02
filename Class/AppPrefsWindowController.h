//
//  AppPrefsWindowController.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//



#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"


@interface AppPrefsWindowController : DBPrefsWindowController {
	IBOutlet NSView *generalPreferenceView;
	IBOutlet NSView *updatesPreferenceView;
	IBOutlet NSView *advancedPreferenceView;
}


@end
