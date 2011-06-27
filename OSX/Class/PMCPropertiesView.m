//
//  PMCPropertiesView.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 12/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPropertiesView.h"


@implementation PMCPropertiesView
#pragma mark Initialization
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_actualY=0;
    }
    return self;
}

#pragma mark -
#pragma mark Drawing
- (BOOL)isFlipped{
	return TRUE;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

#pragma mark -
#pragma mark Other

- (void)addView:(NSView*)aView{
	
	[aView setFrame:NSMakeRect([aView frame].origin.x, _actualY, [aView frame].size.width, [aView frame].size.height)];
	_actualY+=[aView frame].size.height;
	if([self frame].size.height<_actualY){
		NSRect acF = [self frame];
		acF.size.height=_actualY;
		[self setFrame:acF];
		int max = [[self subviews] count];
		int i;
		int cumul=0;
		NSRect acf2;
		for(i=0;i<max;i++){
			acf2=[[[self subviews] objectAtIndex:i] frame];
			acf2.origin.y=cumul;
			[[[self subviews] objectAtIndex:i] setFrame:acf2];
			cumul+=acf2.size.height;
		}
	}
	[super addSubview:aView];
	
}


@end
