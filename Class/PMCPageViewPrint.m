//
//  PMCPageViewPrint.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 07/03/10.
//  Copyright 2010 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPageViewPrint.h"


@implementation PMCPageViewPrint

- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		_defaultSize = frameRect.size;
		_pages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addPageWithImage:(NSImage*)img{
	[_pages addObject:img];
	//[[img TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Desktop/img%d.tiff",[_pages count]] stringByExpandingTildeInPath] atomically:NO];
	NSRect myRect=NSMakeRect(0, 0, [self frame].size.width, _defaultSize.height*[_pages count]);
	[self setFrame:myRect];
	//NSLog(@"Changement RECT : %@",NSStringFromRect(myRect));
	
	//[[self dataWithPDFInsideRect:myRect] writeToFile:[[NSString stringWithFormat:@"~/Desktop/img_final_%d.pdf",[_pages count]] stringByExpandingTildeInPath] atomically:FALSE];
}

- (BOOL)knowsPageRange:(NSRange*)rptr{
	rptr->location=1;
	rptr->length=3;
	return YES;
}

- (NSRect)rectForPage:(int)i{
	NSRect page;
	page.size=_defaultSize;
	page.origin.x=0;
	page.origin.y=_defaultSize.height*(i-1);
	
	//NSLog(@"rectForPage %d : %@", i, NSStringFromRect(page));
	return page;
}

#pragma mark -
#pragma mark Drawing

/*
 Draw content
 */
- (BOOL)isFlipped{
	return FALSE;
}


- (void)drawRect:(NSRect)rect
{
	[NSGraphicsContext saveGraphicsState];
	NSRect pageRect;
	
	NSImage * img;
	int max = [_pages count];
	for(int i=0;i<max;i++){
		
		img = [_pages objectAtIndex:i];
		
		pageRect = NSMakeRect(0, i*_defaultSize.height, _defaultSize.width, _defaultSize.height);
		
		//NSLog(@"RECT for page %d : %@", i, NSStringFromRect(pageRect));
		//Redimmensionne l'image
		
		/*NSImage *resizedImage = [[NSImage alloc] initWithSize:_defaultSize];
		if([img size].width>_defaultSize.width){
			
			[resizedImage lockFocus];
			[img drawInRect: NSMakeRect(0, 0, _defaultSize.width, _defaultSize.height) fromRect: NSMakeRect(0, 0, img.size.width, img.size.height) operation: NSCompositeSourceOver fraction: 1.0];
			[resizedImage unlockFocus];
		}*/
		//NSCompositeCopy
		[img drawInRect:pageRect fromRect:NSMakeRect(0, 0, [img size].width, [img size].height) operation:NSCompositeSourceOver fraction:1.0];

	}
	
	[NSGraphicsContext restoreGraphicsState];
	
}

@end
