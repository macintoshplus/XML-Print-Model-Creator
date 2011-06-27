//
//  Rectangle.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCRectangle.h"


@implementation PMCRectangle

@synthesize  bgroundColor=_backgroundColor;
@synthesize backgroundVisibility=_backgroundVisible;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
		_backgroundColor = [NSColor whiteColor];
		_backgroundVisible = TRUE;
		_borderProperty.borderSize=2;
		_vectorPath = [[NSMutableArray alloc] init];
		//[_vectorPath autorelease];
		[self setBorderColor:[NSColor darkGrayColor]];
		[self setBorderVisibility:TRUE];		
		
    }
    return self;
}


- (id)initWithData:(NSDictionary*)dico{
	//NSLog(@"Dico %@ = %@", [self className],dico);
	self = [super initWithData:dico];
	_backgroundVisible= [[dico objectForKey:@"BackgroundVisible"] boolValue];
	_backgroundColor= [[dico objectForKey:@"BackgroundColor"] copy];
	_borderProperty.topVisible= [[dico objectForKey:@"BorderTopVisible"] boolValue];
	_borderProperty.topColor= [[dico objectForKey:@"BorderTopColor"] copy];
	_borderProperty.rightVisible= [[dico objectForKey:@"BorderRightVisible"] boolValue];
	_borderProperty.rightColor= [[dico objectForKey:@"BorderRightColor"] copy];
	_borderProperty.bottomVisible= [[dico objectForKey:@"BorderBottomVisible"] boolValue];
	_borderProperty.bottomColor= [[dico objectForKey:@"BorderBottomColor"] copy];
	_borderProperty.leftVisible= [[dico objectForKey:@"BorderLeftVisible"] boolValue];
	_borderProperty.leftColor= [[dico objectForKey:@"BorderLeftColor"] retain];
	_borderProperty.borderSize= [[dico objectForKey:@"BorderWidth"] intValue];
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	
	return self;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"\n_backgroundVisible=%@\n_backgroundColor=%@\n_borderProperty.topVisible=%@\n_borderProperty.topColor=%@\n_borderProperty.rightVisible=%@\n_borderProperty.rightColor=%@\n_borderProperty.bottomVisible=%@\n_borderProperty.bottomColor=%@\n_borderProperty.leftVisible=%@\n_borderProperty.leftColor=%@\n_borderProperty.borderSize=%i",
			((_backgroundVisible)? @"True":@"False"),
			_backgroundColor,
			((_borderProperty.topVisible)? @"True":@"False"),
			_borderProperty.topColor,
			((_borderProperty.rightVisible)? @"True":@"False"),
			_borderProperty.rightColor,
			((_borderProperty.bottomVisible)? @"True":@"False"),
			_borderProperty.bottomColor,
			((_borderProperty.leftVisible)? @"True":@"False"),
			_borderProperty.leftColor,
			_borderProperty.borderSize];
}

- (NSXMLElement*)exportToModel{
	NSXMLElement * myNode = [super exportToModel];
	//redéfini l'atribut type
	[myNode removeAttributeForName:@"type"];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"Rectangle"]];
	
	if(_backgroundVisible){
		if(![[_backgroundColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _backgroundColor = [_backgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurfond" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_backgroundColor redComponent], [_backgroundColor greenComponent], [_backgroundColor blueComponent]]]];
	}else{
		[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurfond" stringValue:@"-1"]];
	}
	
	//Ancien attibut de la version 1.0
	//if(![[_borderProperty.leftColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.leftColor = [_borderProperty.leftColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontour" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.leftColor redComponent], [_borderProperty.leftColor greenComponent], [_borderProperty.leftColor blueComponent]]]];
	
	//if(![[_borderProperty.rightColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.rightColor = [_borderProperty.rightColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontour1" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.rightColor redComponent], [_borderProperty.rightColor greenComponent], [_borderProperty.rightColor blueComponent]]]];
	
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"epaisseurcontour" stringValue:[NSString stringWithFormat:@"%i",_borderProperty.borderSize]]];
	
	//Attibuts ajouté avec la version 1.1 du format :
	
	//[myNode removeAttributeForName:@"couleurcontour"];
	//[myNode removeAttributeForName:@"couleurcontour1"];
	
	if(![[_borderProperty.topColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.topColor = [_borderProperty.topColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontourhaut" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.topColor redComponent], [_borderProperty.topColor greenComponent], [_borderProperty.topColor blueComponent]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"contourhautvisible" stringValue:((_borderProperty.topVisible)? @"true":@"false")]];
	
	if(![[_borderProperty.rightColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.rightColor = [_borderProperty.rightColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontourdroite" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.rightColor redComponent], [_borderProperty.rightColor greenComponent], [_borderProperty.rightColor blueComponent]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"contourdroitevisible" stringValue:((_borderProperty.rightVisible)? @"true":@"false")]];
	
	if(![[_borderProperty.bottomColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.bottomColor = [_borderProperty.bottomColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontourbas" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.bottomColor redComponent], [_borderProperty.bottomColor greenComponent], [_borderProperty.bottomColor blueComponent]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"contourbasvisible" stringValue:((_borderProperty.bottomVisible)? @"true":@"false")]];
	
	if(![[_borderProperty.leftColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.leftColor = [_borderProperty.leftColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurcontourgauche" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.leftColor redComponent], [_borderProperty.leftColor greenComponent], [_borderProperty.leftColor blueComponent]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"contourgauchevisible" stringValue:((_borderProperty.leftVisible)? @"true":@"false")]];
	
	//Fin Nouveau attibut
	
	
	return myNode;
}


- (void)draw {
	//NSLog(@"%@ draw : %@", [self className], self);
	if(_vectorPath) [_vectorPath release];
	_vectorPath = [[NSMutableArray alloc] init];
    // Drawing code here.
	NSBezierPath * bp1 = [NSBezierPath bezierPathWithRect:NSMakeRect(x, y, width, height)];
	if(_backgroundVisible){
		//NSLog(@"Objet '%@' : BG Color : %@ (%@)",_name,_backgroundColor, self);
		[_backgroundColor set];
		[bp1 fill];
	}
	[_vectorPath addObject:[[bp1 retain] autorelease]];
	
	/*NSBezierPath * bp = [NSBezierPath bezierPath];
	[bp setLineWidth:(float)_borderProperty.borderSize];
	*/
	if(_borderProperty.topVisible){ //Haut
		NSBezierPath * bp = [NSBezierPath bezierPath];
		[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp setLineCapStyle:NSSquareLineCapStyle];
		[_borderProperty.topColor setStroke];
		//[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp moveToPoint:NSMakePoint(x, y)];
		[bp lineToPoint:NSMakePoint(width+x, y)];
		[bp stroke];
		[_vectorPath addObject:[[bp retain] autorelease]];
	}
	
	if(_borderProperty.rightVisible){ //Droite
		NSBezierPath * bp = [NSBezierPath bezierPath];
		[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp setLineCapStyle:NSSquareLineCapStyle];
		[_borderProperty.rightColor setStroke];
		//[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp moveToPoint:NSMakePoint(width+x, y)];
		[bp lineToPoint:NSMakePoint(width+x, height+y)];
		[bp stroke];
		[_vectorPath addObject:[[bp retain] autorelease]];
	}
	
	if(_borderProperty.bottomVisible){ //Bas
		NSBezierPath * bp = [NSBezierPath bezierPath];
		[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp setLineCapStyle:NSSquareLineCapStyle];
		[_borderProperty.bottomColor setStroke];
		//[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp moveToPoint:NSMakePoint(x, height+y)];
		[bp lineToPoint:NSMakePoint(width+x, height+y)];
		[bp stroke];
		[_vectorPath addObject:[[bp retain] autorelease]];
	}
	
	if(_borderProperty.leftVisible){ //Gauche
		NSBezierPath * bp = [NSBezierPath bezierPath];
		[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp setLineCapStyle:NSSquareLineCapStyle];
		[_borderProperty.leftColor setStroke];
		//[bp setLineWidth:(float)_borderProperty.borderSize];
		[bp moveToPoint:NSMakePoint(x, y)];
		[bp lineToPoint:NSMakePoint(x, height+y)];
		[bp stroke];
		[_vectorPath addObject:[[bp retain] autorelease]];
	}
	
	//[_vectorPath addObject:[[bp retain] autorelease]];
	
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [super getDataForSave];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithBool:_backgroundVisible] forKey:@"BackgroundVisible"];
	[dico setObject:_backgroundColor forKey:@"BackgroundColor"];
	[dico setObject:[NSNumber numberWithBool:_borderProperty.topVisible] forKey:@"BorderTopVisible"];
	[dico setObject:_borderProperty.topColor forKey:@"BorderTopColor"];
	[dico setObject:[NSNumber numberWithBool:_borderProperty.rightVisible] forKey:@"BorderRightVisible"];
	[dico setObject:_borderProperty.rightColor forKey:@"BorderRightColor"];
	[dico setObject:[NSNumber numberWithBool:_borderProperty.bottomVisible] forKey:@"BorderBottomVisible"];
	[dico setObject:_borderProperty.bottomColor forKey:@"BorderBottomColor"];
	[dico setObject:[NSNumber numberWithBool:_borderProperty.leftVisible] forKey:@"BorderLeftVisible"];
	[dico setObject:_borderProperty.leftColor forKey:@"BorderLeftColor"];
	[dico setObject:[NSNumber numberWithInt:_borderProperty.borderSize] forKey:@"BorderWidth"];
	//[dico setObject: forKey:@""];
	
	
	return dico;
}



- (void)setBgroundColor:(NSColor*)newBGColor
{
	[self willChangeValueForKey:FigureDrawingContentsKey];
	//NSLog(@"New color : %@",newBGColor);
	[_backgroundColor release];
	_backgroundColor=[[self changeColorSpaceNameToRVB:newBGColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}
- (NSColor*)bgroundColor
{
	return _backgroundColor;
}


- (void)setBackgroundVisibility:(BOOL)isVisibleBG
{
	[[undoManager prepareWithInvocationTarget:self] setBackgroundVisibility:_backgroundVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBgVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_backgroundVisible=isVisibleBG;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)backgroundVisibility
{
	return _backgroundVisible;
}



- (void)setBorderProperty:(PMCBorderSetting)newBS
{
	/*[[undoManager prepareWithInvocationTarget:self] setName:_name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMName",@"Localizable",@"Undo Manager Action")];
	}*/
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty=newBS;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (PMCBorderSetting)getBorderProperty
{
	return _borderProperty;
}

- (void)setBorderSize:(int)newBorderWidth
{
	[[undoManager prepareWithInvocationTarget:self] setBorderSize:_borderProperty.borderSize];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderSize",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.borderSize=newBorderWidth;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (int)borderSize
{
	return _borderProperty.borderSize;
}



- (void)setBorderColor:(NSColor*)newColor
{
	/*[[undoManager prepareWithInvocationTarget:self] setBorderColor:_name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMName",@"Localizable",@"Undo Manager Action")];
	}*/
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_borderProperty.topColor release];
	[_borderProperty.rightColor release];
	[_borderProperty.bottomColor release];
	[_borderProperty.leftColor release];
	
	_borderProperty.topColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	_borderProperty.rightColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	_borderProperty.bottomColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	_borderProperty.leftColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setBorderTopColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setBorderTopColor:_borderProperty.topColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderTopColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_borderProperty.topColor release];
	_borderProperty.topColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (NSColor*)borderTopColor
{
	return _borderProperty.topColor;
}


- (void)setBorderRightColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setBorderRightColor:_borderProperty.rightColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderRightColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_borderProperty.rightColor release];
	_borderProperty.rightColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (NSColor*)borderRightColor
{
	return _borderProperty.rightColor;
}


- (void)setBorderBottomColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setBorderBottomColor:_borderProperty.bottomColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderBottomColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_borderProperty.bottomColor release];
	_borderProperty.bottomColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (NSColor*)borderBottomColor
{
	return _borderProperty.bottomColor;
}


- (void)setBorderLeftColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setBorderLeftColor:_borderProperty.leftColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderLeftColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_borderProperty.leftColor release];
	_borderProperty.leftColor=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (NSColor*)borderLeftColor
{
	return _borderProperty.leftColor;
}



- (void)setBorderVisibility:(BOOL)isVisible
{
	/*[[undoManager prepareWithInvocationTarget:self] setName:_name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMName",@"Localizable",@"Undo Manager Action")];
	}*/
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.topVisible=isVisible;
	_borderProperty.rightVisible=isVisible;
	_borderProperty.bottomVisible=isVisible;
	_borderProperty.leftVisible=isVisible;
	[self didChangeValueForKey:FigureDrawingContentsKey];
	
}


- (void)setBorderTopVisibility:(BOOL)isVisible
{
	[[undoManager prepareWithInvocationTarget:self] setBorderTopVisibility:_borderProperty.topVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderTopVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.topVisible=isVisible;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)borderTopVisibility
{
	return _borderProperty.topVisible;
}


- (void)setBorderRightVisibility:(BOOL)isVisible
{
	[[undoManager prepareWithInvocationTarget:self] setBorderRightVisibility:_borderProperty.rightVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderRightVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.rightVisible=isVisible;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)borderRightVisibility
{
	return _borderProperty.rightVisible;
}


- (void)setBorderBottomVisibility:(BOOL)isVisible
{
	[[undoManager prepareWithInvocationTarget:self] setBorderBottomVisibility:_borderProperty.bottomVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderBottomVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.bottomVisible=isVisible;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)borderBottomVisibility
{
	return _borderProperty.bottomVisible;
}


- (void)setBorderLeftVisibility:(BOOL)isVisible
{
	[[undoManager prepareWithInvocationTarget:self] setBorderLeftVisibility:_borderProperty.leftVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBorderLeftVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_borderProperty.leftVisible=isVisible;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (BOOL)borderLeftVisibility
{
	return _borderProperty.leftVisible;
}


@end
