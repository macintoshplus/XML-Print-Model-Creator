//
//  PMCPageContainer.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 05/03/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCPageView.h"

@interface PMCPageContainer : NSView {
	PMCPageView * contentView;
	int margin;
}


@property (retain) PMCPageView * contentView;
@property (assign) int margin;
- (void)apply;
- (void)setZoom:(float)newZoom;
- (void)changeContent;

@end
