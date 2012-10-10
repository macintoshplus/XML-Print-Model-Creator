//
//  PMCBaseObject.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 10/02/09.
//  Copyright 2009 Jean Baptiste Nahan. All rights reserved.
//

#import "PMCFigure.h"


NSString *FigureDrawingBoundsKey = @"drawingBounds";
NSString *FigureDrawingContentsKey = @"drawingContents";

@implementation PMCFigure

@synthesize name=_name;
@synthesize undoManager;
@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize visible=_isVisible;
@synthesize fontList=_fontList;

//@synthesize sizeAndPosition=_sizeAndPosition;

- (id)init{
	self = [super init];
	if(self){
		//init
		_name=@"";
		//_sizeAndPosition = NSMakeRect(0, 0, 100, 100);
		x=0;
		y=0;
		width=100;
		height=100;
		_isVisible = TRUE;
		_vectorPath = [[NSMutableArray alloc] init];
		_fontList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"]];
	}
	return self;
}

- (id)initWithName:(NSString*)name{
	self=[self init];
	[self setName:name];
	
	return self;
}

- (id)initWithName:(NSString*)name andSizeAndPosition:(NSRect)rect{
	self = [self init];
	[self setName:name];
	[self setSizeAndPosition:rect];
	return self;
}

- (id)initWithData:(NSDictionary*)dico{
	self=[self init];
	_isVisible = [[dico objectForKey:@"Visible"] boolValue];
	//_sizeAndPosition = NSMakeRect(, , , );
	x=[[dico objectForKey:@"X"] floatValue];
	y=[[dico objectForKey:@"Y"] floatValue];
	width=[[dico objectForKey:@"Width"] floatValue];
	height=[[dico objectForKey:@"Height"] floatValue];
	
	_name = [[dico objectForKey:@"Name"] copy];
	
	return self;
}

- (void)dealloc{
	[_name release];
	[_vectorPath release];
	[_fontList release];
	[undoManager release];
	[super dealloc];
}


/*
- (void)setName:(NSString*)name{
	_name=name;
}*/
- (NSString*)getName
{
	return _name;
}

- (NSXMLElement*)exportToModel{
	
	//La gestion de la visibilité est géré au niveau de la page.
	
	NSMutableString *cocoaStr;
	CFStringRef corestr;
	
	// lecture
	cocoaStr=[[NSMutableString alloc] initWithString:_name];
	
	// cast du NSString* en CFStringRef (magie du tool-free-bridging)
	corestr=(CFStringRef)cocoaStr;
	
	// converstion de la chaîne de départ  en canonical-unicode
	// (ça permet de séparer les composants diacritiques des caractères de base)
	CFStringNormalize(corestr, kCFStringNormalizationFormD);
	
	// application d'une règle ICU à la chaine canonisée: cette règle enlève les signes diacritiques
	CFStringTransform(corestr, NULL, kCFStringTransformStripCombiningMarks, false);
	
	// maintenant tous les caractères accentués sont devenus non-accentués.
	//NSLog(@"%@", cocoaStr);
	
	NSRange r;
	r.location=0;
	r.length=[cocoaStr length];
	[cocoaStr replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:r];
	
	//NSLog(@"Export de l'objet : %@", _name);
	
	NSXMLElement *myNode = [NSXMLNode elementWithName:cocoaStr];
	[cocoaStr release];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"base"]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"x" stringValue:[NSString stringWithFormat:@"%0.0f",x]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"y" stringValue:[NSString stringWithFormat:@"%0.0f",y]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"largeur" stringValue:[NSString stringWithFormat:@"%0.0f",width]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"hauteur" stringValue:[NSString stringWithFormat:@"%0.0f",height]]];
	return myNode;
}

- (void)setSizeAndPosition:(NSRect)rect
{
	[[undoManager prepareWithInvocationTarget:self] setSizeAndPosition:NSMakeRect(x, y, width, height)];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	//_sizeAndPosition=rect;
	x=rect.origin.x;
	y=rect.origin.y;
	width=rect.size.width;
	height=rect.size.height;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}
- (NSRect)drawingBounds{
	return NSMakeRect(x, y, width, height);
}

- (NSRect)getSizeAndPosition
{
	return NSMakeRect(x, y, width, height);
}

- (void)setVisible:(BOOL)val
{
	[[undoManager prepareWithInvocationTarget:self] setVisible:_isVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_isVisible=val;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)isVisible{
	return _isVisible;
}


- (void)setX:(float)val
{
	[[undoManager prepareWithInvocationTarget:self] setX:x];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	x=val;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
}

- (void)setY:(float)val
{
	[[undoManager prepareWithInvocationTarget:self] setY:y];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	y=val;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
}

- (void)setOrigine:(NSPoint)point
{
	[[undoManager prepareWithInvocationTarget:self] setOrigine:NSMakePoint(x, y)];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	x=point.x;
	y=point.y;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
}

- (void)setWidth:(float)val
{
	[[undoManager prepareWithInvocationTarget:self] setWidth:width];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	width=val;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
}

- (void)setHeight:(float)val
{
	[[undoManager prepareWithInvocationTarget:self] setHeight:height];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMPosition",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	height=val;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
} 

- (void)setName:(NSString*)newName{
	[[undoManager prepareWithInvocationTarget:self] setName:_name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMName",@"Localizable",@"Undo Manager Action")];
	}
	[_name release];
	_name = [newName retain];
}


- (void)draw {

}


- (BOOL)containsPoint:(NSPoint)point{
	int max = [_vectorPath count];
	int i;
	
	for(i=0;i<max;i++){
		//NSLog(@"Vecteur (%@) %i sur %i", [[_vectorPath objectAtIndex:max-i-1] className], i+1, max);
		if([[[_vectorPath objectAtIndex:max-i-1] className] isEqualToString:@"NSBezierPath"])
		if([[_vectorPath objectAtIndex:max-i-1] containsPoint:point]) return TRUE;
		
	}
	return FALSE;
	
	
}

- (void)updatePositionWithPoint:(NSPoint)point{
	
	//[self willChangeValueForKey:FigureDrawingBoundsKey];
	[self setX:x+point.x];
	[self setY:y+point.y];
	//[self didChangeValueForKey:FigureDrawingBoundsKey];
}

- (void)hotUpdatePositionWithPoint:(NSPoint)point{
	
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	[self willChangeValueForKey:@"x"];
	[self willChangeValueForKey:@"y"];
	x=_savedSizeAndPosition.origin.x+point.x;
	y=_savedSizeAndPosition.origin.y+point.y;
	[self didChangeValueForKey:FigureDrawingBoundsKey];
	[self didChangeValueForKey:@"x"];
	[self didChangeValueForKey:@"y"];
}

- (void)fixDragWithPoint:(NSPoint)point{
	x=_savedSizeAndPosition.origin.x;
	y=_savedSizeAndPosition.origin.y;
	NSPoint newOrigin = NSMakePoint(_savedSizeAndPosition.origin.x+point.x, _savedSizeAndPosition.origin.y+point.y);
	[self setOrigine:newOrigin];
}

- (void)savePosition{
	_savedSizeAndPosition = NSMakeRect(x, y, width, height);
	//_sizeAndPosition;
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *s=[[self className] copy];
	[dico setObject:s forKey:@"ObjectClassName"];
    [s release];
	[dico setObject:[NSNumber numberWithBool:_isVisible] forKey:@"Visible"];
	[dico setObject:[NSNumber numberWithFloat:width] forKey:@"Width"];
	[dico setObject:[NSNumber numberWithFloat:height] forKey:@"Height"];
	[dico setObject:[NSNumber numberWithFloat:x] forKey:@"X"];
	[dico setObject:[NSNumber numberWithFloat:y] forKey:@"Y"];
    NSString* s2=[_name copy];
	[dico setObject:s2 forKey:@"Name"];
    [s2 release];
	//[dico setObject: forKey:@""];
	//[dico setObject: forKey:@""];
	return dico;
}

- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor{
	if(![[oldColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]){
		return [oldColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		
	}
	return oldColor;
}

@end
