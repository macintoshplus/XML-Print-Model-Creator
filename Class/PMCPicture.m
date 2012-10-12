//
//  PMCPicture.m
//  XML Print Model Creator 10.8
//
//  Created by Jean-Baptiste Nahan on 12/10/12.
//  Copyright (c) 2012 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPicture.h"

@implementation PMCPicture

@synthesize image = _image;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setBgroundColor:[NSColor orangeColor]];
		_borderProperty.borderSize=1;
        _image=nil;
		[self setBorderColor:[NSColor blackColor]];
		
    }
    return self;
}


- (id)initWithData:(NSDictionary*)dico{
	//NSLog(@"Dico %@ = %@", [self className],dico);
	self = [super initWithData:dico];
	_image= [[NSImage alloc] initWithData:[[dico objectForKey:@"Img"] data]];
	/*_backgroundColor= [[dico objectForKey:@"BackgroundColor"] copy];
	_borderProperty.topVisible= [[dico objectForKey:@"BorderTopVisible"] boolValue];
	_borderProperty.topColor= [[dico objectForKey:@"BorderTopColor"] copy];
	_borderProperty.rightVisible= [[dico objectForKey:@"BorderRightVisible"] boolValue];
	_borderProperty.rightColor= [[dico objectForKey:@"BorderRightColor"] copy];
	_borderProperty.bottomVisible= [[dico objectForKey:@"BorderBottomVisible"] boolValue];
	_borderProperty.bottomColor= [[dico objectForKey:@"BorderBottomColor"] copy];
	_borderProperty.leftVisible= [[dico objectForKey:@"BorderLeftVisible"] boolValue];
	_borderProperty.leftColor= [[dico objectForKey:@"BorderLeftColor"] retain];
	_borderProperty.borderSize= [[dico objectForKey:@"BorderWidth"] intValue];
	
	
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	
	return self;
}

- (void)draw {
    //Dessinner le rectangle
    [super draw];
    
    //Dessinner une croix signifiant la présence de l'image.
    NSBezierPath * bp = [[NSBezierPath alloc] init];
    [bp setLineWidth:1];
    [bp setLineCapStyle:NSSquareLineCapStyle];
    [[NSColor redColor] setStroke];
    //[bp setLineWidth:(float)_borderProperty.borderSize];
    [bp moveToPoint:NSMakePoint(x, y)];
    [bp lineToPoint:NSMakePoint(width+x, height+y)];
    [bp stroke];
	[bp release];
	
    bp = [[NSBezierPath alloc] init];//[NSBezierPath bezierPath];
    [bp setLineWidth:1];
    [bp setLineCapStyle:NSSquareLineCapStyle];
    [[NSColor redColor] setStroke];
    //[bp setLineWidth:(float)_borderProperty.borderSize];
    [bp moveToPoint:NSMakePoint(width+x, y)];
    [bp lineToPoint:NSMakePoint(x, height+y)];
    [bp stroke];
	[bp release];
	
    
    
    
}

- (NSXMLElement*)exportToModel{
	NSXMLElement * myNode = [super exportToModel];
	//redéfini l'atribut type
	[myNode removeAttributeForName:@"type"];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"Picture"]];
	
	/*if(_backgroundVisible){
		if(![[_backgroundColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _backgroundColor = [_backgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurfond" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_backgroundColor redComponent], [_backgroundColor greenComponent], [_backgroundColor blueComponent]]]];
	}else{
		[myNode addAttribute:[NSXMLNode attributeWithName:@"couleurfond" stringValue:@"-1"]];
	}
	
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"epaisseurcontour" stringValue:[NSString stringWithFormat:@"%i",_borderProperty.borderSize]]];
	
	
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
	[myNode addAttribute:[NSXMLNode attributeWithName:@"contourgauchevisible" stringValue:((_borderProperty.leftVisible)? @"true":@"false")]];*/
	
	//Fin Nouveau attibut
	
	
	return myNode;
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [super getDataForSave];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[_image TIFFRepresentation] forKey:@"Img"];
	
	
	return dico;
}

- (void)setImage:(NSImage *)image
{
	
     [[undoManager prepareWithInvocationTarget:self] setImage:_image];
     if(![undoManager isUndoing]){
     [undoManager setActionName:NSLocalizedStringFromTable(@"UMImageSet",@"Localizable",@"Undo Manager Action")];
     }
     
    [self willChangeValueForKey:FigureDrawingContentsKey];
	//NSLog(@"New color : %@",newBGColor);
	if(_image!=nil)[_image release];
	_image=[image copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

@end
