//
//  PMCPageViewPrint.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 07/03/10.
//  Copyright 2010 In Extenso. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PMCPageViewPrint : NSView {
	
	NSMutableArray * _pages;
	NSSize _defaultSize;
}

- (void)addPageWithImage:(NSImage*)img;


@end
