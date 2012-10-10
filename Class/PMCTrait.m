//
//  Trait.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCTrait.h"


@implementation PMCTrait

@synthesize color=_color;
@synthesize style=_style;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
		_width=1;
		_style=0;
		width=100;
		
		if(width>height){ //largeur supérieur à la longeur: ligne horizontale
			correctedFrame = NSMakeRect(x, y-(height/2), width, height);
			_width=height;
		}else{ //ligne vertivale
			correctedFrame = NSMakeRect(x-(width/2), y, width, height);
			_width=width;
		}
		
		_color=[NSColor blackColor];
    }
    return self;
}


- (id)initWithData:(NSDictionary*)dico{
	self = [super initWithData:dico];
	
	
	_color= [[dico objectForKey:@"LineColor"] copy];
	_style= [[dico objectForKey:@"LineStyle"] intValue];
	_width= [[dico objectForKey:@"LineWidth"] intValue];
	
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	
	return self;
}

- (NSXMLElement*)exportToModel{
	NSXMLElement * myNode = [super exportToModel];
	//redéfini l'atribut type
	[myNode removeAttributeForName:@"type"];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"trait"]];
	
	[myNode removeAttributeForName:@"x"];
	[myNode removeAttributeForName:@"y"];
	[myNode removeAttributeForName:@"largeur"];
	[myNode removeAttributeForName:@"hauteur"];
	
	float x1=0.0;
	float x2=0.0;
	float y1=0.0;
	float y2=0.0;
	
	
	if(width>height){
		x1=x;
		x2=x+width;
		y1=y;
		y2=y1;
	}else{
		y1=y;
		y2=y+height;
		x1=x;
		x2=x1;
	}
	/*
	if(_sizeAndPosition.size.width>_sizeAndPosition.size.height){
		x1=_sizeAndPosition.origin.x;
		x2=_sizeAndPosition.origin.x+_sizeAndPosition.size.width;
		y1=_sizeAndPosition.origin.y;
		y2=y1;
	}else{
		y1=_sizeAndPosition.origin.y;
		y2=_sizeAndPosition.origin.y+_sizeAndPosition.size.height;
		x1=_sizeAndPosition.origin.x;
		x2=x1;
	}*/
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"x" stringValue:[NSString stringWithFormat:@"%0.0f", x1]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"y" stringValue:[NSString stringWithFormat:@"%0.0f", y1]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"xFin" stringValue:[NSString stringWithFormat:@"%0.0f", x2]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"yFin" stringValue:[NSString stringWithFormat:@"%0.0f", y2]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"epaisseur" stringValue:[NSString stringWithFormat:@"%i",_width]]];
	
	//if(![[_color colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _color = [_color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleur" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_color redComponent], [_color greenComponent], [_color blueComponent]]]];
	
	return myNode;
}

- (NSRect)drawingBounds{
	//return [super drawingBounds];
	return correctedFrame;
}


- (void)draw {
	//NSLog(@"Draw Trait de l'objet : %@",_name);
    // Drawing code here.
	//[_vectorPath release];
	_vectorPath = [[NSMutableArray alloc] init];
	//NSRect sensitiveRect;
	if(width>height){ //largeur supérieur à la longeur: ligne horizontale
		correctedFrame = NSMakeRect(x, y-(float)(height/2.0), width, height);
		_width=height;
	}else{ //ligne vertivale
		correctedFrame = NSMakeRect(x-(float)(width/2.0), y, width, height);
		_width=width;
	}
	//correctedFrame=sensitiveRect;
	/*
	 if(_sizeAndPosition.size.width>_sizeAndPosition.size.height){ //largeur supérieur à la longeur: ligne horizontale
	 sensitiveRect = NSMakeRect(_sizeAndPosition.origin.x, _sizeAndPosition.origin.y-(_sizeAndPosition.size.height/2), _sizeAndPosition.size.width, _sizeAndPosition.size.height);
	 }else{ //ligne vertivale
	 sensitiveRect = NSMakeRect(_sizeAndPosition.origin.x-(_sizeAndPosition.size.width/2), _sizeAndPosition.origin.y, _sizeAndPosition.size.width, _sizeAndPosition.size.height);
	 }
	*/
	NSBezierPath * bp1 = [NSBezierPath bezierPathWithRect:correctedFrame];
	[_vectorPath addObject:[[bp1 retain] autorelease]];
	
	NSBezierPath * bp = [NSBezierPath bezierPath];
	[_color set];
	
	[bp setLineWidth:(float)_width];
	[bp moveToPoint:NSMakePoint(x, y)];
	if(width>height){ //largeur supérieur à la longeur: ligne horizontale
		[bp lineToPoint:NSMakePoint(width+x, y)];
	}else{ //ligne vertivale
		[bp lineToPoint:NSMakePoint(x, height+y)];
	}
	/*
	 if(_sizeAndPosition.size.width>_sizeAndPosition.size.height){ //largeur supérieur à la longeur: ligne horizontale
	 [bp lineToPoint:NSMakePoint(_sizeAndPosition.size.width+_sizeAndPosition.origin.x, _sizeAndPosition.origin.y)];
	 }else{ //ligne vertivale
	 [bp lineToPoint:NSMakePoint(_sizeAndPosition.origin.x, _sizeAndPosition.size.height+_sizeAndPosition.origin.y)];
	 }
	*/
	[bp stroke];
	[_vectorPath addObject:[[bp retain] autorelease]];
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [super getDataForSave];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:_color forKey:@"LineColor"];
	[dico setObject:[NSNumber numberWithInt:_style] forKey:@"LineStyle"];
	[dico setObject:[NSNumber numberWithInt:_width] forKey:@"LineWidth"];
	//[dico setObject: forKey:@""];
	
	return dico;
}

- (void)setColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setColor:_color];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTraitColor",@"Localizable",@"Undo Manager Action")];
	}
	
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_color release];
	_color=[[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
	
}

- (void)setStyle:(int)newStyle
{
	[(PMCTrait*)[undoManager prepareWithInvocationTarget:self] setStyle:_style];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTraitStyle",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_style=newStyle;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

/*
- (void)setWidth:(int)newWidth
{
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_width=newWidth;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (int)getWidth
{
	return _width;
}*/

- (void)setSizeAndPosition:(NSRect)rect{
	[self willChangeValueForKey:FigureDrawingBoundsKey];
	[super setSizeAndPosition:rect];
	if(rect.size.width>rect.size.height){
		_width=rect.size.height;
	}else{
		_width=rect.size.width;
	}
	[self didChangeValueForKey:FigureDrawingBoundsKey];
}




@end
