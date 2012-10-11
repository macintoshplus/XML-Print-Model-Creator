//
//  PMCPageContainer.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 05/03/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPageContainer.h"


@implementation PMCPageContainer

@synthesize contentView;
@synthesize margin;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		margin=40;
    }
    return self;
}

- (BOOL)isFlipped{
	return TRUE;
}
- (void)setZoom:(float)newZoom{
	[contentView setZoom:newZoom];
	[self apply];
}

- (void)apply{
	/**/
	
	NSRect svf = [[self superview] frame];
	NSRect cvf = [contentView frame];
	NSRect sf = [self frame];
	//NSLog(@"application : %@ \nx=%f y=%f w=%f h=%f", contentView, cvf.origin.x, cvf.origin.y, cvf.size.width, cvf.size.height);
	
	//détermine si la largeur et la hauteur la plus grande
	sf.size.width = MAX(cvf.size.width+margin,svf.size.width);
	sf.size.height = MAX(cvf.size.height+margin,svf.size.height);
	[self setFrame:sf];
	//NSRect r;
	cvf.origin.x = (sf.size.width/2)-(cvf.size.width/2);
	cvf.origin.y = (sf.size.height/2)-(cvf.size.height/2);
	[contentView setFrame:cvf];
	[self setNeedsDisplay:YES];
}

- (void)changeContent{
	
	if([[self subviews] count]==0) [self addSubview:contentView];
	else [self replaceSubview:[[self subviews] lastObject] with:contentView];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	/**/
	[NSGraphicsContext saveGraphicsState];
	
	//NSRect myBounds = [self bounds];
	//NSDrawLightBezel(myBounds,myBounds);
	
	NSShadow * s = [[[NSShadow alloc] init] autorelease];
	[s setShadowColor:[NSColor blackColor]];
	[s setShadowBlurRadius:5.0];
	[s setShadowOffset:NSMakeSize(0.0, 0.0)];
	[s set];
	
	NSRect r = [contentView frame];
	r.origin.x = ([self frame].size.width/2)-(r.size.width/2);
	r.origin.y = ([self frame].size.height/2)-(r.size.height/2);
	//[contentView setFrame:r];
	NSBezierPath * bp = [NSBezierPath bezierPathWithRect:r];
	[[NSColor whiteColor] set];
	[bp fill];
	[NSGraphicsContext restoreGraphicsState];
	[super drawRect:rect];
	
}

@end
