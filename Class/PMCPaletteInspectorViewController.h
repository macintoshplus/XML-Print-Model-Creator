//
//  PMCPaletteInspectorViewController.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 04/03/10.
//  Copyright 2010 Jean Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMCPropertiesView;

@interface PMCPaletteInspectorViewController : NSViewController {
	BOOL	viewVisible;
}

- (void) insertViewInSuperview:(PMCPropertiesView*)superview;
- (void) removeView;

@property (readonly) BOOL viewVisible;



@end
