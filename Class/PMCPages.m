//
//  PMCPages.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPages.h"


@implementation PMCPages

#pragma mark INIT
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_zoom=1.0;
		originalFrame = frame;
		originalBounds = [self bounds];
		
		_objSelected=-1;
		
		_listObject = [[NSMutableArray alloc] init];
		
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
	//NSLog(@"drawRect : %@", NSStringFromRect(rect));
	[NSGraphicsContext saveGraphicsState];
	/*
	NSShadow * s = [[NSShadow alloc] init];
	[s setShadowColor:[NSColor blackColor]];
	[s setShadowBlurRadius:5.0];
	[s setShadowOffset:NSMakeSize(0.0, 0.0)];
	[s set];
	*/
	NSAffineTransform* xform = [NSAffineTransform transform];
	[xform scaleXBy:_zoom yBy:_zoom];	
	// Apply the changes
	[xform concat];
	
	int max=[_listObject count]-1;
	//NSLog(@"obj count : %i", max);
	int i;
	for(i=0;i<=max;i++){
		//NSLog(@"APPEL draw obj numero : %i (%@) (max=%i)", max-i, [[_listObject objectAtIndex:i] getName], max);
		if([[_listObject objectAtIndex:max-i] isVisible]) [[_listObject objectAtIndex:max-i] draw];
	
	}
	
	[NSGraphicsContext restoreGraphicsState];
	/*
	NSRect tect1 = NSMakeRect(1, 1, [self frame].size.width-2, [self frame].size.height-2);
	NSBezierPath * bp3 = [NSBezierPath bezierPathWithRect:tect1];
	
	[[NSColor redColor] set];
	[bp3 stroke];
	*/
	//[self testSizeAndCenter];
	
	//[self setNeedsDisplay:YES];
}
/*
- (void)setFrame:(NSRect)frameRect{
	[super setFrame:frameRect];
	//[self testSizeAndCenter];
}
*/
/*- (void)testSizeAndCenter{
	
	NSRect resizeRect = [[self superview] frame];
	if(resizeRect.size.width>[self frame].size.width && resizeRect.size.height>[self frame].size.height){
		NSClipView * contentView=(NSClipView*)[self superview]; 
		NSRect contentViewBounds=[contentView bounds];
		NSLog(@"%@",NSStringFromRect(contentViewBounds));
		NSRect myViewFrame=[self frame];
		NSLog(@"%@",NSStringFromRect(myViewFrame));
		
		NSPoint contentCenter=NSMakePoint(NSMidX(contentViewBounds),NSMidY(contentViewBounds));
		NSPoint myViewCenter=NSMakePoint(NSMidX(myViewFrame),NSMidY(myViewFrame));	
		
		NSPoint point=NSZeroPoint;
		point.x=myViewCenter.x-contentCenter.x;
		point.y=myViewCenter.y-contentCenter.y;
		[contentView scrollToPoint:point];
	}
}*/


- (void)reDraw{
	//[self drawRect:[self frame]];
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Zoom
- (float)actualZoom{
	return _zoom;
}
- (void)setZoom:(float)newZoom{
	_zoom = newZoom;
	
	/*NSLog(@"Super View : %@",[self superview]);
	NSLog(@"Frame Super View : x=%f y=%f w=%f h=%f",[[self superview] frame].origin.x, [[self superview] frame].origin.y, [[self superview] frame].size.width, [[self superview] frame].size.height);
	
	NSRect resizeRect = [[self superview] frame];*/
	//NSMakeRect(originalBounds.origin.x, originalBounds.origin.y, originalBounds.size.width*_zoom, originalBounds.size.height*_zoom);
	//[self setBounds:resizeRect];
	/*float originX;
	float originY;
	float originY2;
	if(resizeRect.size.width>(originalFrame.size.width*_zoom)) originX = 0;//(resizeRect.size.width/2)-((originalFrame.size.width*_zoom)/2);
	else originX=0;
	
	NSLog(@"superview H = %f   dessin H = %f",resizeRect.size.height,(originalFrame.size.height*_zoom));
	
	if(resizeRect.size.height>(originalFrame.size.height*_zoom)){
		originY = (originalFrame.size.height*_zoom) - resizeRect.size.height;
		NSLog(@"SuperView H > Dessin H --- oY=%f",originY);
	}else originY=0;//(originalFrame.size.height*_zoom) - resizeRect.size.height;
	
	if(resizeRect.size.height<(originalFrame.size.height*_zoom)){
		originY2 = resizeRect.size.height - (originalFrame.size.height*_zoom);
		NSLog(@"SuperView H < Dessin H");
	}else originY2=0;//(originalFrame.size.height*_zoom) - resizeRect.size.height;
	*/
	
	NSRect resizeRectF = NSMakeRect(0, 0, originalFrame.size.width*_zoom, originalFrame.size.height*_zoom);
	NSLog(@"Frame resizeRectF : x=%f y=%f w=%f h=%f",resizeRectF.origin.x, resizeRectF.origin.y, resizeRectF.size.width, resizeRectF.size.height);
	//[[self superview] setFrame:NSMakeRect(1, originY, resizeRect.size.width, resizeRect.size.height)];
	//[self setBoundsOrigin:NSMakePoint(0, resizeRect.size.height)];
	[self setFrame:resizeRectF];
	[self drawRect:[self frame]];
	
	
	//[self testSizeAndCenter];
	
}

#pragma mark -
#pragma mark Delegate

- (void)setDelegate:(id)obj{
	_delegate=obj;
}

- (id)getDelegate{
	return _delegate;
}

#pragma mark -
#pragma mark Gestion des Objets

- (int)objCount
{
	return [_listObject count];
}

- (id)getObjectAtIndex:(int)index
{
	return [_listObject objectAtIndex:index];
}

- (void)deleteObjectAtIndex:(int)index
{
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] addObject:[_listObject objectAtIndex:index] atPlan:index];
	if(![undo isUndoing]){
		[undo setActionName:@"delete object"];
	}
	[_listObject removeObjectAtIndex:index];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PMCObjectPageDidChange object:self];
	[self reDraw];
}

- (void)updateObject:(id)obj atPlan:(int)plan
{
	[self deleteObjectAtIndex:plan];
	[self addObject:obj atPlan:plan];
}

- (void)addObject:(id)obj atPlan:(int)plan
{
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] deleteObjectAtIndex:plan];
	if(![undo isUndoing]){
		[undo setActionName:@"add object"];
	}
	[_listObject insertObject:[obj retain] atIndex:plan];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PMCObjectPageDidChange object:self];
	[self reDraw];
	//NSLog(@"Ajout Objet ! (%i)",[_listObject count]);
}

- (void)placeObjectAtPlan:(int)fromPlan toPlan:(int)toPlan
{
	
	id obj = [[_listObject objectAtIndex:fromPlan] retain];
	[_listObject removeObjectAtIndex:fromPlan];
	
	[_listObject insertObject:obj atIndex:toPlan];
	[obj release];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:toPlan];
	}
	
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] placeObjectAtPlan:toPlan toPlan:fromPlan];
	if(![undo isUndoing]){
		[undo setActionName:@"change plan"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PMCObjectPageDidChange object:self];
	[self reDraw];
}

- (void)searchObjectAtPoint:(NSPoint)point{
	//NSLog(@"Point : %@",NSStringFromPoint(point));
	NSPoint point2 = NSMakePoint(point.x/_zoom, point.y/_zoom);
	//NSLog(@"Point2 : %@",NSStringFromPoint(point2));
	int i;
	int max = [_listObject count];
	_objSelected=-1;
	for(i=0;i<max;i++){
		//NSLog(@"Objet: %i sur %i",i+1,max);
		if([[_listObject objectAtIndex:i] containsPoint:point2]){
			//NSLog(@"C'est cet objet !");
			_objSelected=i;
			if(_delegate){
				[_delegate setSelectedObjectAtIndex:_objSelected];
				[_delegate setInspectorForObject:[[_listObject objectAtIndex:i] className]];
			}
			return;
		}
	}
	if(_delegate){ [_delegate setSelectedObjectAtIndex:_objSelected];
		[_delegate setInspectorForObject:@"doc"];
	}
	//NSLog(@"Pas trouver (%i) %@  !",_objSelected,NSStringFromPoint(point));
}


- (void)setSelectedObject:(int)index
{
	if(index>-1 && index<[_listObject count]) _objSelected=index;
	else _objSelected=-1;
	
	if(_delegate){
		if(_objSelected>-1)	[_delegate setInspectorForObject:[[_listObject objectAtIndex:_objSelected] className]];
		else [_delegate setInspectorForObject:@"doc"];
	}
	
	
}

- (void)clearSelectedObject
{
	_objSelected=-1;
}

- (int)getSelectedObjectIndex
{
	return _objSelected;
}

#pragma mark -
#pragma mark Other
- (NSMutableArray*)getDataForSave{
	NSMutableArray * ar = [[NSMutableArray alloc] init];
	int max=[_listObject count];
	int i;
	for(i=0;i<max;i++){
		[ar insertObject:[[_listObject objectAtIndex:i] getDataForSave] atIndex:0];
	}
	return ar;//[NSArchiver archivedDataWithRootObject:ar];
}

- (void)setPageWithContent:(NSArray*)ar{
	
}

#pragma mark -
#pragma mark Gestion Souris
- (void)mouseDown:(NSEvent *)theEvent{
	//NSLog(@"Event : %@",theEvent);
	_startDrag = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de début %@  !",NSStringFromPoint(_startDrag));
	[self searchObjectAtPoint:_startDrag];
	if(_objSelected>-1){
		[[_listObject objectAtIndex:_objSelected] savePosition];
		
	}
}

- (void)mouseDragged:(NSEvent *)theEvent{
	NSPoint endPoint;
	endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de drag %@  !",NSStringFromPoint(endPoint));
	if(_objSelected>-1){
		NSPoint diff = NSMakePoint((endPoint.x-_startDrag.x)/_zoom, (endPoint.y-_startDrag.y)/_zoom);
		//NSLog(@"Drag Difference %@  !",NSStringFromPoint(diff));
		[[_listObject objectAtIndex:_objSelected] hotUpdatePositionWithPoint:diff];
		if(_delegate) [_delegate setPropertiesForSize];
		[self setNeedsDisplay:TRUE];
	}
}

- (void)mouseUp:(NSEvent *)theEvent{
	//[self searchObjectAtPoint:NSMakePoint((float)[theEvent absoluteX], (float)[theEvent absoluteY])];
	NSPoint endPoint;
	endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de fin %@  !",NSStringFromPoint(endPoint));
	if(_objSelected>-1){
		//NSPoint diff = NSMakePoint(endPoint.x-_startDrag.x, endPoint.y-_startDrag.y);
		//NSLog(@"Difference fin %@  !",NSStringFromPoint(diff));
		//[[_listObject objectAtIndex:_objSelected] updatePositionWithPoint:diff];
		[self setNeedsDisplay:TRUE];
	}
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent{
	NSLog(@"Event : %@",theEvent);
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de début %@  !",NSStringFromPoint(_startDrag));
	[self searchObjectAtPoint:p];
	if([theEvent type]==NSRightMouseDown && _objSelected>-1){
		NSMenu * m = [[NSMenu alloc] init];
		[m setAutoenablesItems:FALSE];
		NSMenuItem * i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"deleteTool",@"Localizable",@"Tools") action:@selector(deleteSelectedObject:) keyEquivalent:@"e"];
		[i1 setTarget:self];
		[m addItem:i1];
		[m addItem:[NSMenuItem separatorItem]];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDoubleUpTool",@"Localizable",@"Tools") action:@selector(orderDoubleUpSelectedObject:) keyEquivalent:@"f"];
		[i1 setTarget:self];
		[i1 setEnabled:(_objSelected>0)];
		[m addItem:i1];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDoubleDownTool",@"Localizable",@"Tools") action:@selector(orderDoubleDownSelectedObject:) keyEquivalent:@"b"];
		[i1 setTarget:self];
		[i1 setEnabled:(_objSelected>-1 && _objSelected<[_listObject count]-1)];
		[m addItem:i1];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderUpTool",@"Localizable",@"Tools") action:@selector(orderUpSelectedObject:) keyEquivalent:@"F"];
		[i1 setTarget:self];
		[i1 setEnabled:(_objSelected>0)];
		[m addItem:i1];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDownTool",@"Localizable",@"Tools") action:@selector(orderDownSelectedObject:) keyEquivalent:@"B"];
		[i1 setTarget:self];
		[i1 setEnabled:(_objSelected>-1 && _objSelected<[_listObject count]-1)];
		[m addItem:i1];
		
		[m addItem:[NSMenuItem separatorItem]];
		
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cut",@"Localizable",@"CM") action:@selector(cut:) keyEquivalent:@"x"];
		[i1 setTarget:nil];
		[i1 setEnabled:(_objSelected>-1)];
		[m addItem:i1];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Copy",@"Localizable",@"CM") action:@selector(copy:) keyEquivalent:@"c"];
		[i1 setTarget:nil];
		[i1 setEnabled:(_objSelected>-1)];
		[m addItem:i1];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Paste",@"Localizable",@"CM") action:@selector(paste:) keyEquivalent:@"v"];
		[i1 setTarget:nil];
		[i1 setEnabled:(_objSelected>-1)];
		[m addItem:i1];
		
		return m;
	}
	return nil;
}


- (void)moveDown:(id)sender{
	if(_objSelected>-1){
		NSPoint diff = NSMakePoint(0, 1);
		NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		[[_listObject objectAtIndex:_objSelected] updatePositionWithPoint:diff];
		[self setNeedsDisplay:TRUE];
	}
}


- (void)exportToModel:(NSXMLElement*)node{
	int i;
	
	for (i=0; i<[_listObject count]; i++) {
		if([[_listObject objectAtIndex:i] isVisible]) [node addChild:[[_listObject objectAtIndex:i] exportToModel]];
	}
	
}

- (IBAction)deleteSelectedObject:(id)sender{
	[self deleteObjectAtIndex:_objSelected];
	_objSelected=-1;
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	[self setNeedsDisplay:TRUE];
}

- (IBAction)orderUpSelectedObject:(id)sender{
	if(_objSelected==0) return; //annule l'action si l'objet est le premier
	
	[self placeObjectAtPlan:_objSelected toPlan:_objSelected-1];
	
	[self setNeedsDisplay:TRUE];
	/*return;
	
	NSUndoManager * undo = [_delegate undoManager];
	if([undo groupingLevel]){
		[undo endUndoGrouping];
	}
	[undo beginUndoGrouping];
	
	
	id obj = [[_listObject objectAtIndex:_objSelected] retain];
	[_listObject removeObjectAtIndex:_objSelected];
	_objSelected--;
	[_listObject insertObject:obj atIndex:_objSelected];
	[obj release];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	[[undo prepareWithInvocationTarget:self] setSelectedObject:_objSelected];
	[[undo prepareWithInvocationTarget:self] orderDownSelectedObject:self];
	if(![undo isUndoing]){
		[undo setActionName:@"up plan"];
	}
	[undo endUndoGrouping];
	
	[self setNeedsDisplay:TRUE];*/
}

- (IBAction)orderDoubleUpSelectedObject:(id)sender{
	if(_objSelected==0) return; //annule l'action si l'objet est le premier
	
	[self placeObjectAtPlan:_objSelected toPlan:0];
	
	[self setNeedsDisplay:TRUE];
	
	/*id obj = [[_listObject objectAtIndex:_objSelected] retain];
	[_listObject removeObjectAtIndex:_objSelected];
	_objSelected=0;
	[_listObject insertObject:obj atIndex:_objSelected];
	[obj release];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	[self setNeedsDisplay:TRUE];*/
}

- (IBAction)orderDownSelectedObject:(id)sender{
	if(_objSelected==[_listObject count]-1) return; //annule l'action si l'objet est le dernier
	
	
	[self placeObjectAtPlan:_objSelected toPlan:_objSelected+1];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	[self setNeedsDisplay:TRUE];
	/*return;
	
	NSUndoManager * undo = [_delegate undoManager];
	if([undo groupingLevel]){
		[undo endUndoGrouping];
	}
	[undo beginUndoGrouping];
	
	id obj = [[_listObject objectAtIndex:_objSelected] retain];
	NSLog(@"retain count : %i",[obj retainCount]);
	[_listObject removeObjectAtIndex:_objSelected];
	_objSelected++;
	[_listObject insertObject:obj atIndex:_objSelected];
	[obj release];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	
	[[undo prepareWithInvocationTarget:self] setSelectedObject:_objSelected];
	[[undo prepareWithInvocationTarget:self] orderUpSelectedObject:self];
	if(![undo isUndoing]){
		[undo setActionName:@"down plan"];
	}
	[undo endUndoGrouping];
	
	[self setNeedsDisplay:TRUE];
	 */
}

- (IBAction)orderDoubleDownSelectedObject:(id)sender{
	if(_objSelected==[_listObject count]-1) return; //annule l'action si l'objet est le dernier
	
	[self placeObjectAtPlan:_objSelected toPlan:[_listObject count]-1];
	
	[self setNeedsDisplay:TRUE];
	
	/*
	id obj = [[_listObject objectAtIndex:_objSelected] retain];
	NSLog(@"retain count : %i",[obj retainCount]);
	[_listObject removeObjectAtIndex:_objSelected];
	_objSelected=[_listObject count];
	[_listObject insertObject:obj atIndex:_objSelected];
	[obj release];
	if(_delegate){
		[_delegate setSelectedObjectAtIndex:_objSelected];
	}
	[self setNeedsDisplay:TRUE];
	*/
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	//NSLog(@"validateToolbarItem : %@ - PicSelected : %@",[theItem itemIdentifier],(([[HexPicController sharedInstance] deviceIsSelected])? @"YES":@"NO"));
    
    if ([[theItem itemIdentifier] isEqualToString:@"deleteTool"]) return (_objSelected>-1);
	if ([[theItem itemIdentifier] isEqualToString:@"orderUpTool"]) return (_objSelected>0);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDoubleUpTool"]) return (_objSelected>0);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDownTool"]) return (_objSelected>-1 && _objSelected<[_listObject count]-1);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDoubleDownTool"]) return (_objSelected>-1 && _objSelected<[_listObject count]-1);
	
	return YES;
	
	//return NO;
}

@end
