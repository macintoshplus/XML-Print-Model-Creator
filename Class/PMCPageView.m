//
//  PMCPageView.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 05/03/10.
//  Copyright 2010 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPageView.h"
#import "PMCFigure.h"
#import "PMCBook.h"
#import "PMCPageContainer.h"

static NSString *PropertyObservationContext;
static NSString *GraphicsObservationContext;
static NSString *SelectionIndexesObservationContext;
static NSString *SizeObservationContext;

NSString *FIGURES_BINDING_NAME = @"_listObject";
NSString *FORMAT_BINDING_NAME = @"pageFormat";
NSString *ORIENTATION_BINDING_NAME = @"pageOrientation";
NSString *SELECTIONINDEXES_BINDING_NAME = @"selectionIndexes";
NSString *PAGINATION_BINDING_NAME = @"enabledPagination";

NSString *FORMAT_PAGINATION_BINDING_NAME = @"formatPagination";
NSString *POSITION_X_PAGINATION_BINDING_NAME = @"paginationPositionX";
NSString *POSITION_Y_PAGINATION_BINDING_NAME = @"paginationPositionY";
NSString *COLOR_PAGINATION_BINDING_NAME = @"textColor";
NSString *SIZE_PAGINATION_BINDING_NAME = @"textSize";
NSString *ALIGN_PAGINATION_BINDING_NAME = @"textAlign";
NSString *FONT_PAGINATION_BINDING_NAME = @"textFontIndex";
NSString *BOLD_PAGINATION_BINDING_NAME = @"textBold";
NSString *ITALIC_PAGINATION_BINDING_NAME = @"textItalic";
NSString *UNDERLINE_PAGINATION_BINDING_NAME = @"textUnderline";

@implementation PMCPageView

@synthesize zoom=_zoom;
@synthesize oldFigures;
@synthesize book;

/*
 Since the view is not put on an IB palette, it's not really necessary to expose the bindings
 */
+ (void)initialize
{
	[self exposeBinding:FORMAT_BINDING_NAME];
	[self exposeBinding:ORIENTATION_BINDING_NAME];
	[self exposeBinding:FIGURES_BINDING_NAME];
	[self exposeBinding:SELECTIONINDEXES_BINDING_NAME];
	[self exposeBinding:PAGINATION_BINDING_NAME];
	[self exposeBinding:FORMAT_PAGINATION_BINDING_NAME];
	[self exposeBinding:POSITION_X_PAGINATION_BINDING_NAME];
	[self exposeBinding:POSITION_Y_PAGINATION_BINDING_NAME];
	[self exposeBinding:COLOR_PAGINATION_BINDING_NAME];
	[self exposeBinding:SIZE_PAGINATION_BINDING_NAME];
	[self exposeBinding:ALIGN_PAGINATION_BINDING_NAME];
	[self exposeBinding:FONT_PAGINATION_BINDING_NAME];
	[self exposeBinding:BOLD_PAGINATION_BINDING_NAME];
	[self exposeBinding:ITALIC_PAGINATION_BINDING_NAME];
	[self exposeBinding:UNDERLINE_PAGINATION_BINDING_NAME];
}


/*
 designated initializer; set up bindingInfo dictionary
 */
- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		_zoom=1.0;
		originalFrame = frameRect;
		originalBounds = [self bounds];
		bindingInfo = [[NSMutableDictionary alloc] init];
	}
	return self;
}

/*
 For every binding except "graphics" and "selectionIndexes" just use NSObject's default implementation. It will start observing the bound-to property. When a KVO notification is sent for the bound-to property, this object will be sent a [self setValue:theNewValue forKey:theBindingName] message, so this class just has to be KVC-compliant for a key that is the same as the binding name.  Also, NSView supports a few simple bindings of its own, and there's no reason to get in the way of those.
 */
- (void)bind:(NSString *)bindingName
	toObject:(id)observableObject
 withKeyPath:(NSString *)observableKeyPath
	 options:(NSDictionary *)options
{
	
    if ([bindingName isEqualToString:FIGURES_BINDING_NAME])
	{
		if ([bindingInfo objectForKey:FIGURES_BINDING_NAME] != nil)
		{
			[self unbind:FIGURES_BINDING_NAME];	
		}
		/*
		 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
		 */
		
		NSDictionary *bindingsData = [[NSDictionary dictionaryWithObjectsAndKeys:
									  observableObject, NSObservedObjectKey,
									  [observableKeyPath copy], NSObservedKeyPathKey,
									  [options copy], NSOptionsKey, nil] retain];
		[bindingInfo setObject:bindingsData forKey:FIGURES_BINDING_NAME];
        //[bindingsData release];
        
		[observableObject addObserver:self
						   forKeyPath:observableKeyPath
							  options:(NSKeyValueObservingOptionNew |
									   NSKeyValueObservingOptionOld)
							  context:&GraphicsObservationContext];
		[self startObservingFigures:[observableObject valueForKeyPath:observableKeyPath]];
		
    }
	else
		if ([bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME])
		{
			if ([bindingInfo objectForKey:SELECTIONINDEXES_BINDING_NAME] != nil)
			{
				[self unbind:SELECTIONINDEXES_BINDING_NAME];	
			}
			/*
			 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
			 */
			
			NSDictionary *bindingsData = [[NSDictionary dictionaryWithObjectsAndKeys:
										  observableObject, NSObservedObjectKey,
										  [observableKeyPath copy], NSObservedKeyPathKey,
										  [options copy], NSOptionsKey, nil] retain];
			[bindingInfo setObject:bindingsData forKey:SELECTIONINDEXES_BINDING_NAME];
			//[bindingsData release];
			
			[observableObject addObserver:self
							   forKeyPath:observableKeyPath
								  options:NSKeyValueObservingOptionNew
								  context:&SelectionIndexesObservationContext];
		}	
		else
			if ([bindingName isEqualToString:FORMAT_BINDING_NAME])
			{
				if ([bindingInfo objectForKey:FORMAT_BINDING_NAME] != nil)
				{
					[self unbind:FORMAT_BINDING_NAME];	
				}
				/*
				 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
				 */
				
				NSDictionary *bindingsData = [NSDictionary dictionaryWithObjectsAndKeys:
											  observableObject, NSObservedObjectKey,
											  [observableKeyPath copy], NSObservedKeyPathKey,
											  [options copy], NSOptionsKey, nil];
				[bindingInfo setObject:bindingsData forKey:FORMAT_BINDING_NAME];
                //[bindingsData release];
				
				[observableObject addObserver:self
								   forKeyPath:observableKeyPath
									  options:(NSKeyValueObservingOptionNew |
											   NSKeyValueObservingOptionOld)
									  context:&SizeObservationContext];
			}	
			else
				if ([bindingName isEqualToString:ORIENTATION_BINDING_NAME])
				{
					if ([bindingInfo objectForKey:ORIENTATION_BINDING_NAME] != nil)
					{
						[self unbind:ORIENTATION_BINDING_NAME];	
					}
					/*
					 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
					 */
					
					NSDictionary *bindingsData = [NSDictionary dictionaryWithObjectsAndKeys:
												  observableObject, NSObservedObjectKey,
												  [observableKeyPath copy], NSObservedKeyPathKey,
												  [options copy], NSOptionsKey, nil];
					[bindingInfo setObject:bindingsData forKey:ORIENTATION_BINDING_NAME];
                    //[bindingsData release];
					
					[observableObject addObserver:self
									   forKeyPath:observableKeyPath
										  options:(NSKeyValueObservingOptionNew |
												   NSKeyValueObservingOptionOld)
										  context:&SizeObservationContext];
            }
            else
                if ([bindingName isEqualToString:PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:FORMAT_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:POSITION_X_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:POSITION_Y_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:COLOR_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:SIZE_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:ALIGN_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:FONT_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:BOLD_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:ITALIC_PAGINATION_BINDING_NAME] ||
                    [bindingName isEqualToString:UNDERLINE_PAGINATION_BINDING_NAME])
                {
                    
                    /*[self exposeBinding:FORMAT_PAGINATION_BINDING_NAME];
                    [self exposeBinding:POSITION_X_PAGINATION_BINDING_NAME];
                    [self exposeBinding:POSITION_Y_PAGINATION_BINDING_NAME];
                    [self exposeBinding:COLOR_PAGINATION_BINDING_NAME];
                    [self exposeBinding:SIZE_PAGINATION_BINDING_NAME];
                    [self exposeBinding:ALIGN_PAGINATION_BINDING_NAME];
                    [self exposeBinding:FONT_PAGINATION_BINDING_NAME];
                    [self exposeBinding:BOLD_PAGINATION_BINDING_NAME];
                    [self exposeBinding:ITALIC_PAGINATION_BINDING_NAME];
                    [self exposeBinding:UNDERLINE_PAGINATION_BINDING_NAME];*/
                    
                    if ([bindingInfo objectForKey:bindingName] != nil)
                    {
                        [self unbind:bindingName];
                    }
                    /*
                     observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
                     */
                    
                    NSDictionary *bindingsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  observableObject, NSObservedObjectKey,
                                                  [observableKeyPath copy], NSObservedKeyPathKey,
                                                  [options copy], NSOptionsKey, nil];
                    [bindingInfo setObject:bindingsData forKey:bindingName];
                    //[bindingsData release];
                    
                    [observableObject addObserver:self
                                       forKeyPath:observableKeyPath
                                          options:(NSKeyValueObservingOptionNew |
                                                   NSKeyValueObservingOptionOld)
                                          context:&SelectionIndexesObservationContext];
                }
			else 
			{
				[super bind:bindingName toObject:observableObject withKeyPath:observableKeyPath options:options];
			}
    
	
	[self setNeedsDisplay:YES];
}


/*
 Unbind: remove self as observer of bound-to object
 */
- (void)unbind:(NSString *)bindingName
{
	
    
    if ([bindingName isEqualToString:FIGURES_BINDING_NAME] ||
        [bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME] ||
        [bindingName isEqualToString:FORMAT_BINDING_NAME] ||
        [bindingName isEqualToString:ORIENTATION_BINDING_NAME] ||
        [bindingName isEqualToString:PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:FORMAT_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:POSITION_X_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:POSITION_Y_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:COLOR_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:SIZE_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:ALIGN_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:FONT_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:BOLD_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:ITALIC_PAGINATION_BINDING_NAME] ||
        [bindingName isEqualToString:UNDERLINE_PAGINATION_BINDING_NAME])
    {
        NSDictionary * dico= [self infoForBinding:bindingName];
        id paginationContainer = [dico objectForKey:NSObservedObjectKey];
        NSString *paginationKeyPath = [dico objectForKey:NSObservedKeyPathKey];
        
        [paginationContainer removeObserver:self forKeyPath:paginationKeyPath];
        [bindingInfo removeObjectForKey:bindingName];
        
        if ([bindingName isEqualToString:FIGURES_BINDING_NAME]) [self setOldFigures:nil];
    }
    else
    {
        [super unbind:bindingName];
    }
    [self setNeedsDisplay:YES];
}


/*
 Respond to KVO change notifications
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	
    if (context == &GraphicsObservationContext)
	{
		/*
		 Should be able to use
		 NSArray *oldFigures = [change objectForKey:NSKeyValueChangeOldKey];
		 etc. but the dictionary doesn't contain old and new arrays.
		 */
		NSArray *newGraphics = [object valueForKeyPath:[self figuresKeyPath]];
		
		NSMutableArray *onlyNew = [newGraphics mutableCopy];
		[onlyNew removeObjectsInArray:oldFigures];
		[self startObservingFigures:onlyNew];
		[onlyNew release];
        
		NSMutableArray *removed = [oldFigures mutableCopy];
		[removed removeObjectsInArray:newGraphics];
		[self stopObservingFigures:removed];
		[removed release];
        
		[self setOldFigures:newGraphics];
		
		// could check drawingBounds of old and new, but...
		[self setNeedsDisplay:YES];
		return;
    }
	
	if (context == &PropertyObservationContext)
	{
		/*
		 An observed object's property has changed:
		 - If it's the drawing bounds, mark the union of its old and new bounds as dirty;
		 - If it's another property, mark its drawing bounds as dirty
		 */
		NSRect updateRect;
		
		if ([keyPath isEqualToString:@"drawingBounds"])
		{
			NSRect newBounds = [[change objectForKey:NSKeyValueChangeNewKey] rectValue];
			NSRect oldBounds = [[change objectForKey:NSKeyValueChangeOldKey] rectValue];
			updateRect = NSUnionRect(newBounds,oldBounds);
		}
		else
		{
			updateRect = [(NSObject <PMCFigure> *)object drawingBounds];
		}
		updateRect = NSMakeRect(updateRect.origin.x-5.0,
								updateRect.origin.y-5.0,
								updateRect.size.width+10.0,
								updateRect.size.height+10.0);
		
		[self setNeedsDisplayInRect:updateRect];
		return;
	}
	
	if (context == &SelectionIndexesObservationContext)
	{
		[self setNeedsDisplay:YES];
		return;
	}
	
	
	if (context == &SizeObservationContext)
	{
		NSRect nRect  = [(PMCBook*)object frameWidthFormatAndOrientation];
		//NSLog(@"réception du chagement de taille : %@ \nx=%f y=%f w=%f h=%f", self, nRect.origin.x, nRect.origin.y, nRect.size.width, nRect.size.height);
		originalFrame = nRect;
		[self setFrame:nRect];
		[(PMCPageContainer*)[self superview] apply];
		[self setNeedsDisplay:YES];
		return;
	}
	
}



/*
 Register to observe each of the new graphics, and each of their observable properties -- we need old and new values for drawingBounds to figure out what our dirty rect
 */	
- (void)startObservingFigures:(NSArray *)figures
{
	if ([figures isEqual:[NSNull null]])
	{
		return;
	}
	
	/*
	 Declare newGraphic as NSObject * to get key value observing methods
	 Add Graphic protocol for drawing
	 */
    for (NSObject <PMCFigure> *newFigures in figures)
	{
		[newFigures addObserver:self
					 forKeyPath:FigureDrawingBoundsKey
						options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
						context:&PropertyObservationContext];
		
		[newFigures addObserver:self
					 forKeyPath:FigureDrawingContentsKey
						options:0
						context:&PropertyObservationContext];
	}
}


- (void)stopObservingFigures:(NSArray *)figures
{
	if ([figures isEqual:[NSNull null]])
	{
		return;
	}
	
    for (id oldFigure in figures)
	{
		[oldFigure removeObserver:self forKeyPath:FigureDrawingBoundsKey];
		[oldFigure removeObserver:self forKeyPath:FigureDrawingContentsKey];
	}
}


#pragma mark -
#pragma mark Drawing

/*
 Draw content
 */
- (BOOL)isFlipped{
	return TRUE;
}


- (void)drawRect:(NSRect)rect
{
	//if(![[NSGraphicsContext currentContext] isDrawingToScreen]) NSLog(@"Impression sur l'imprimante !");
	[NSGraphicsContext saveGraphicsState];
	
	NSAffineTransform* xform = [NSAffineTransform transform];
	[xform scaleXBy:_zoom yBy:_zoom];	
	// Apply the changes
	[xform concat];
	
	//NSRect myBounds = [self bounds];
	//NSDrawLightBezel(myBounds,myBounds);
	
	//NSInsetRect(myBounds,2.0,2.0)
	/*NSBezierPath *clipRect = [NSBezierPath bezierPathWithRect:NSInsetRect(myBounds,2.0,2.0)];
	[[NSColor yellowColor] set];
	[clipRect fill];
	*/
	/*
	 Draw graphics
	 */
	NSArray *figuresArray = self.figures;
	NSObject <PMCFigure> *figure;
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	
	int max = [figuresArray count]-1;
	
    for (int i=0; i<=max; i++)
	{
		figure = [figuresArray objectAtIndex:max-i];
        /**/
		NSRect graphicDrawingBounds = [figure drawingBounds];
        if (NSIntersectsRect(rect, graphicDrawingBounds))
		{
			if([[NSGraphicsContext currentContext] isDrawingToScreen]) if(currentSelectionIndexes != nil && [currentSelectionIndexes containsIndex:[figuresArray indexOfObject:figure]]){
				[NSGraphicsContext saveGraphicsState];
				NSShadow * s = [[NSShadow alloc] init];
				[s setShadowColor:[NSColor shadowColor]];
				[s setShadowBlurRadius:5.0];
				[s setShadowOffset:NSMakeSize(0.0, 0.0)];
				[s set];
                [s release];
				/*if([[figure className] isEqualToString:@"PMCTrait"]){
					if(graphicDrawingBounds.size.height<graphicDrawingBounds.size.width) graphicDrawingBounds.origin.y=graphicDrawingBounds.origin.y-(graphicDrawingBounds.size.height/2);
					else graphicDrawingBounds.origin.x=graphicDrawingBounds.origin.x-(graphicDrawingBounds.size.width/2);
				}*/
				NSBezierPath * fond = [NSBezierPath bezierPathWithRect:graphicDrawingBounds];
				[[NSColor whiteColor] set];
				[fond fill];
				[NSGraphicsContext restoreGraphicsState];
			}
			if([figure isVisible]) [figure draw];
			
        }
    }
    /*
     Gestion de la pagination
     */
    if([[self book] enabledPagination]){
        PMCText * pagination = [[PMCText alloc] init];
        [pagination setContent:[[self book] formatPagination]];
        [pagination setSizeAndPosition:NSMakeRect([[self book] paginationPositionX], [[self book] paginationPositionY], [self frame].size.width-[[self book] paginationPositionX]-1, 20.)];
        [pagination setTextAlign:[[self book] textAlign]];
        [pagination setTextBold:[[self book] textBold]];
        [pagination setTextItalic:[[self book] textItalic]];
        [pagination setTextUnderline:[[self book] textUnderline]];
        [pagination setTextSize:[[self book] textSize]];
        [pagination setTextFontIndex:[[self book] textFontIndex]];
        [pagination setTextColor:[[self book] textColor]];
        [pagination setBorderBottomVisibility:NO];
        [pagination setBorderLeftVisibility:NO];
        [pagination setBorderRightVisibility:NO];
        [pagination setBorderTopVisibility:NO];
        [pagination draw];
    }
	/*
	 Draw a red box around items in the current selection.
	 Selection should be handled by the graphic, but this is a shortcut simply for display.
	 */
	if([[NSGraphicsContext currentContext] isDrawingToScreen]){
		if (currentSelectionIndexes != nil)
		{
			
			
			NSBezierPath *path = [NSBezierPath bezierPath];
			unsigned int index = [currentSelectionIndexes firstIndex];
			while (index != NSNotFound)
			{
                if([figuresArray count]<index) break;
				figure = [figuresArray objectAtIndex:index];
				NSRect graphicDrawingBounds = [figure drawingBounds];
				if (NSIntersectsRect(rect, graphicDrawingBounds))
				{
					/*if([[figure className] isEqualToString:@"PMCTrait"]){
					 if(graphicDrawingBounds.size.height<graphicDrawingBounds.size.width) graphicDrawingBounds.origin.y=graphicDrawingBounds.origin.y-(graphicDrawingBounds.size.height/2);
					 else graphicDrawingBounds.origin.x=graphicDrawingBounds.origin.x-(graphicDrawingBounds.size.width/2);
					 }*/
					[path appendBezierPathWithRect:graphicDrawingBounds];
				}
				index = [currentSelectionIndexes indexGreaterThanIndex:index];
			}
			[[NSColor keyboardFocusIndicatorColor] set];
			[path setLineWidth:1.0];
			[path stroke];
		}
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

#pragma mark -
#pragma mark Gestion du Zoom

- (void)setZoom:(float)newZoom{
	_zoom = newZoom;
	
	NSRect resizeRectF = NSMakeRect(0, 0, originalFrame.size.width*_zoom, originalFrame.size.height*_zoom);
	NSLog(@"Frame resizeRectF : x=%f y=%f w=%f h=%f",resizeRectF.origin.x, resizeRectF.origin.y, resizeRectF.size.width, resizeRectF.size.height);
	
	[self setFrame:resizeRectF];
	[self setNeedsDisplay:YES];
	//[self drawRect:[self frame]];
	
}


#pragma mark -
#pragma mark Gestion Souris


- (void)mouseDragged:(NSEvent *)theEvent{
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	NSPoint endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if(currentSelectionIndexes!=nil){
		NSPoint diff = NSMakePoint((endPoint.x-_startDrag.x)/_zoom, (endPoint.y-_startDrag.y)/_zoom);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
            if([[self figures] count]<=index) break;
			[[[self figures] objectAtIndex:index] hotUpdatePositionWithPoint:diff];//
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
	
}

- (void)mouseUp:(NSEvent *)theEvent{
	//[self searchObjectAtPoint:NSMakePoint((float)[theEvent absoluteX], (float)[theEvent absoluteY])];
	/*NSPoint endPoint;
	endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de fin %@  !",NSStringFromPoint(endPoint));
	if(_objSelected>-1){
		//NSPoint diff = NSMakePoint(endPoint.x-_startDrag.x, endPoint.y-_startDrag.y);
		//NSLog(@"Difference fin %@  !",NSStringFromPoint(diff));
		//[[_listObject objectAtIndex:_objSelected] updatePositionWithPoint:diff];
		[self setNeedsDisplay:TRUE];
	}*/
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	NSPoint endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if(currentSelectionIndexes!=nil){
		NSPoint diff = NSMakePoint((endPoint.x-_startDrag.x)/_zoom, (endPoint.y-_startDrag.y)/_zoom);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
            if([[self figures] count]<=index) break;
			[[[self figures] objectAtIndex:index] fixDragWithPoint:diff];
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
	/*
	[self setNeedsDisplay:TRUE];*/
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent{
	//NSLog(@"Event : %@",theEvent);
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//NSLog(@"Point de début %@  !",NSStringFromPoint(_startDrag));
	
	if([theEvent type]==NSRightMouseDown){
		NSWindow* mainWindow = [NSApp mainWindow];
		NSDocument* doc = [[mainWindow windowController] document];
		
		NSEnumerator *gEnum = [[self figures] reverseObjectEnumerator];
		id aGraphic;
		for (aGraphic in gEnum)
		{
			if ([aGraphic containsPoint:p])
			{
				break;
			}
		}
		//NSLog(@"Object : %@",[aGraphic className]);
		/*
		 if no graphic hit, then if extending selection do nothing else set selection to nil
		 */
		int graphicIndex=-1;
		int count = [[self figures] count];
		if (aGraphic == nil)
		{
			
			[[self selectionIndexesContainer] setValue:nil forKeyPath:[self selectionIndexesKeyPath]];
			
			//return nil;
		}else{
			// changement de la sélection
			graphicIndex = [[self figures] indexOfObject:aGraphic];
			NSIndexSet *selection = [NSIndexSet indexSetWithIndex:graphicIndex];
			[[self selectionIndexesContainer] setValue:selection forKeyPath:[self selectionIndexesKeyPath]];
		}
		
		NSMenu * m = [[[NSMenu alloc] init] autorelease];
		[m setAutoenablesItems:FALSE];
		NSMenuItem * i1;
        //PMCTableau
        if([[aGraphic className] isEqualToString:@"PMCTableau"]){
            
            i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"editRow",@"Localizable",@"Tools") action:@selector(sendNotificationOpenRowSheet:) keyEquivalent:@""];
            [i1 setTarget:self];
            [i1 setEnabled:(graphicIndex>=0)];
            [m addItem:i1];
            [i1 release];
            
            i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"editCol",@"Localizable",@"Tools") action:@selector(sendNotificationOpenColSheet:) keyEquivalent:@""];
            [i1 setTarget:self];
            [i1 setEnabled:(graphicIndex>=0)];
            [m addItem:i1];
            [i1 release];
            
            [m addItem:[NSMenuItem separatorItem]];
        }
        i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"deleteTool",@"Localizable",@"Tools") action:@selector(tool_deleteSelectedObject:) keyEquivalent:@"e"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>=0)];
		[m addItem:i1];
		[i1 release];
		[m addItem:[NSMenuItem separatorItem]];
		
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDoubleUpTool",@"Localizable",@"Tools") action:@selector(tool_orderDoubleUpSelectedObject:) keyEquivalent:@"f"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>0)];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDoubleDownTool",@"Localizable",@"Tools") action:@selector(tool_orderDoubleDownSelectedObject:) keyEquivalent:@"b"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>=0 && graphicIndex<count-1)];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderUpTool",@"Localizable",@"Tools") action:@selector(tool_orderUpSelectedObject:) keyEquivalent:@"F"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>0)];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"orderDownTool",@"Localizable",@"Tools") action:@selector(tool_orderDownSelectedObject:) keyEquivalent:@"B"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>=0 && graphicIndex<count-1)];
		[m addItem:i1];
		[i1 release];
		
		[m addItem:[NSMenuItem separatorItem]];
		
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cut",@"Localizable",@"CM") action:@selector(cut:) keyEquivalent:@"x"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>=0)];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Copy",@"Localizable",@"CM") action:@selector(copy:) keyEquivalent:@"c"];
		[i1 setTarget:doc];
		[i1 setEnabled:(graphicIndex>=0)];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Paste",@"Localizable",@"CM") action:@selector(paste:) keyEquivalent:@"v"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		
		[m addItem:[NSMenuItem separatorItem]];
		
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NLine",@"Localizable",@"CM") action:@selector(tool_NewLine:) keyEquivalent:@"l"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NRect",@"Localizable",@"CM") action:@selector(tool_NewRect:) keyEquivalent:@"r"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NText",@"Localizable",@"CM") action:@selector(tool_NewText:) keyEquivalent:@"u"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NArray",@"Localizable",@"CM") action:@selector(tool_NewArray:) keyEquivalent:@"y"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		i1=[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NPicture",@"Localizable",@"CM") action:@selector(tool_NewPicture:) keyEquivalent:@"i"];
		[i1 setTarget:doc];
		[i1 setEnabled:TRUE];
		[m addItem:i1];
		[i1 release];
		
		
		return m;
		
	}
	return nil;
}

/*
 Simple mouseDown: method; the most important aspect is updating the selection indexes
 */
- (void)mouseDown:(NSEvent *)event
{
	//Passe la vue en premier répondeur !
	NSWindow* mainWindow = [NSApp mainWindow];
	if([mainWindow firstResponder]!=self) [mainWindow makeFirstResponder:self];
	
	_startDrag = [self convertPoint:[event locationInWindow] fromView:nil];
	//NSLog(@"Start point : %@", NSStringFromPoint(_startDrag));
	// find out if we hit anything
	//NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
	NSEnumerator *gEnum = [[self figures] reverseObjectEnumerator];
	id aGraphic;
	for (aGraphic in gEnum)
    {
		if ([aGraphic containsPoint:_startDrag])
		{
			break;
		}
	}
	
	/*
	 if no graphic hit, then if extending selection do nothing else set selection to nil
	 */
	if (aGraphic == nil)
	{
		if (!([event modifierFlags] & NSShiftKeyMask))
		{
			[[self selectionIndexesContainer] setValue:nil forKeyPath:[self selectionIndexesKeyPath]];
		}
		return;
	}
	
	/*
	 graphic hit
	 if not extending selection (Shift key down) then set selection to this graphic
	 if extending selection, then:
	 - if graphic in selection remove it
	 - if not in selection add it
	 */
	NSIndexSet *selection = nil;
	unsigned int graphicIndex = [[self figures] indexOfObject:aGraphic];
	
	if (!([event modifierFlags] & NSShiftKeyMask))
	{
		selection = [NSIndexSet indexSetWithIndex:graphicIndex];
	}
	else
	{
		if ([[self selectionIndexes] containsIndex:graphicIndex])
		{
			selection = [[self selectionIndexes] mutableCopy];
			[(NSMutableIndexSet *)selection removeIndex:graphicIndex];
		}
		else
		{
			selection = [[self selectionIndexes] mutableCopy];
			[(NSMutableIndexSet *)selection addIndex:graphicIndex];
		}
	}
	[[self selectionIndexesContainer] setValue:selection forKeyPath:[self selectionIndexesKeyPath]];
	
	unsigned int index = [selection firstIndex];
	while (index != NSNotFound)
	{
        if([[self figures] count]<=index) break;
		[[[self figures] objectAtIndex:index] savePosition];
		index = [selection indexGreaterThanIndex:index];
	}
}

- (void)moveDown:(id)sender{
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if(currentSelectionIndexes!=nil){
		NSPoint diff;
		if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
			diff = NSMakePoint(0.0, 10.0);
		else
			diff = NSMakePoint(0.0, 1.0);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
			[[[self figures] objectAtIndex:index] updatePositionWithPoint:diff];
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
}

- (void)moveLeft:(id)sender{
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if(currentSelectionIndexes!=nil){
		NSPoint diff;
		if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
			diff = NSMakePoint(-10.0, 0.0);
		else
			diff = NSMakePoint(-1.0, 0.0);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
			[[[self figures] objectAtIndex:index] updatePositionWithPoint:diff];
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
}

- (void)moveUp:(id)sender{
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if(currentSelectionIndexes!=nil){
		NSPoint diff;
		if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
			diff = NSMakePoint(0.0, -10.0);
		else
			diff = NSMakePoint(0.0, -1.0);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
			[[[self figures] objectAtIndex:index] updatePositionWithPoint:diff];
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
}

- (void)moveRight:(id)sender{
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if(currentSelectionIndexes!=nil){
		NSPoint diff;
		if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
			diff = NSMakePoint(10.0, 0.0);
		else
			diff = NSMakePoint(1.0, 0.0);
		//NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
			[[[self figures] objectAtIndex:index] updatePositionWithPoint:diff];
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[self setNeedsDisplay:TRUE];
	}
}


#pragma mark -

- (void)sendNotificationOpenRowSheet:(id)sender{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSheetNotification:) name:@"openRowSheet" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openRowSheet" object:self];
    //NSLog(@"Emet : openRowSheet");
}

- (void)sendNotificationOpenColSheet:(id)sender{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSheetNotification:) name:@"openColSheet" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openColSheet" object:self];
    //NSLog(@"Emet : openColSheet");
}

/*
 If view is moved to another superview, unbind all bindings
 */
- (void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[super viewWillMoveToSuperview:newSuperview];
	if (newSuperview == nil)
	{
		[self stopObservingFigures:[self figures]];
		[self unbind:ORIENTATION_BINDING_NAME];
		[self unbind:FORMAT_BINDING_NAME];
		[self unbind:FIGURES_BINDING_NAME];
		[self unbind:SELECTIONINDEXES_BINDING_NAME];
		[self unbind:PAGINATION_BINDING_NAME];
		[self unbind:FORMAT_PAGINATION_BINDING_NAME];
		[self unbind:POSITION_X_PAGINATION_BINDING_NAME];
		[self unbind:POSITION_Y_PAGINATION_BINDING_NAME];
		[self unbind:COLOR_PAGINATION_BINDING_NAME];
		[self unbind:SIZE_PAGINATION_BINDING_NAME];
		[self unbind:ALIGN_PAGINATION_BINDING_NAME];
		[self unbind:FONT_PAGINATION_BINDING_NAME];
		[self unbind:BOLD_PAGINATION_BINDING_NAME];
		[self unbind:ITALIC_PAGINATION_BINDING_NAME];
		[self unbind:UNDERLINE_PAGINATION_BINDING_NAME];
	}
}

#pragma mark -
#pragma mark Bindings Methodes
/*
 Convenience methods to retrieve values from the binding info dictionary
 */

- (NSDictionary *)infoForBinding:(NSString *)bindingName
{
	/*
	 Retrieve from the binding info dictionary the value for the given binding name
	 If there's no value for our info dictionary, get it from super.
	 */
	NSDictionary *info = [bindingInfo objectForKey:bindingName];
	if (info == nil)
	{
		info = [super infoForBinding:bindingName];
	}
	return info;
}

- (id)figuresContainer
{
	return [[self infoForBinding:FIGURES_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)figuresKeyPath
{
	return [[self infoForBinding:FIGURES_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}

- (id)selectionIndexesContainer
{
	return [[self infoForBinding:SELECTIONINDEXES_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)selectionIndexesKeyPath
{
	return [[self infoForBinding:SELECTIONINDEXES_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}

- (id)formatContainer
{
	return [[self infoForBinding:FORMAT_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)formatKeyPath
{
	return [[self infoForBinding:FORMAT_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}


- (id)orientationContainer
{
	return [[self infoForBinding:ORIENTATION_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)orientationKeyPath
{
	return [[self infoForBinding:ORIENTATION_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}

- (NSArray *)figures
{	
    return [[self figuresContainer] valueForKeyPath:[self figuresKeyPath]];	
}

- (NSIndexSet *)selectionIndexes
{
	return [[self selectionIndexesContainer] valueForKeyPath:[self selectionIndexesKeyPath]];
}


@end
