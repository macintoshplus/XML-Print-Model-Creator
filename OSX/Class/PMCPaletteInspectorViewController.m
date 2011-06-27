//
//  PMCPaletteInspectorViewController.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 04/03/10.
//  Copyright 2010 Jean Baptiste Nahan. All rights reserved.
//

#import "PMCPaletteInspectorViewController.h"
#import "PMCPropertiesView.h"

@implementation PMCPaletteInspectorViewController

@synthesize viewVisible;

- (void) insertViewInSuperview:(PMCPropertiesView*)superview
{
	[superview addView:[self view]];
	viewVisible = YES;
}

- (void) removeView
{
	[[self view] removeFromSuperview];	
	viewVisible = NO;
}


@end
