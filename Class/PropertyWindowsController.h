//
//  PropertyWindowsController.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 11/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PropertyWindowsController : NSWindowController {
	NSMutableArray *toolbarIdentifiers;
	NSMutableDictionary *toolbarViews;
	NSMutableDictionary *toolbarItems;
	
	IBOutlet NSView * docProperty;
	IBOutlet NSView * sizeProperty;
	//IBOutlet NSView * docProperty;
	//IBOutlet NSView * docProperty;
	
	
	BOOL _crossFade;
	BOOL _shiftSlowsAnimation;
	
	NSView *contentSubview;
	NSViewAnimation *viewAnimation;
}


+ (PropertyWindowsController *)sharedController;
+ (NSString *)nibName;

- (void)setupToolbar;
- (void)addView:(NSView *)view label:(NSString *)label;
- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image;

- (BOOL)crossFade;
- (void)setCrossFade:(BOOL)fade;
- (BOOL)shiftSlowsAnimation;
- (void)setShiftSlowsAnimation:(BOOL)slows;

- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate;
- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView;
- (NSRect)frameForView:(NSView *)view;


@end
