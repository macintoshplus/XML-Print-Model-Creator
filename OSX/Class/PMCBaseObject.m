//
//  PMCBaseObject.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 10/02/09.
//  Copyright 2009 Jean Baptiste Nahan. All rights reserved.
//

#import "PMCBaseObject.h"


@implementation PMCBaseObject

@synthesize name=_name;

- (id)init{
	self = [super init];
	if(self){
		//init
		_name=@"";
		_sizeAndPosition = NSMakeRect(0, 0, 100, 100);
		_isVisible = TRUE;
		_vectorPath = [[NSMutableArray alloc] init];
		_fontList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"]];
	}
	return self;
}

- (id)initWithName:(NSString*)name{
	[self init];
	[self setName:name];
	
	return self;
}

- (id)initWithName:(NSString*)name andSizeAndPosition:(NSRect)rect{
	[self init];
	[self setName:name];
	[self setSizeAndPosition:rect];
	return self;
}

- (id)initWithData:(NSDictionary*)dico{
	[self init];
	_isVisible = [[dico objectForKey:@"Visible"] boolValue];
	_sizeAndPosition = NSMakeRect([[dico objectForKey:@"X"] floatValue], [[dico objectForKey:@"Y"] floatValue], [[dico objectForKey:@"Width"] floatValue], [[dico objectForKey:@"Height"] floatValue]);
	_name = [[dico objectForKey:@"Name"] copy];
	
	return self;
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
	
	
	NSXMLElement *myNode = [NSXMLNode elementWithName:cocoaStr];
	[cocoaStr release];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"base"]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"x" stringValue:[NSString stringWithFormat:@"%0.0f",_sizeAndPosition.origin.x]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"y" stringValue:[NSString stringWithFormat:@"%0.0f",_sizeAndPosition.origin.y]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"largeur" stringValue:[NSString stringWithFormat:@"%0.0f",_sizeAndPosition.size.width]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"hauteur" stringValue:[NSString stringWithFormat:@"%0.0f",_sizeAndPosition.size.height]]];
	return myNode;
}

- (void)setSizeAndPosition:(NSRect)rect
{
	_sizeAndPosition=rect;
}

- (NSRect)getSizeAndPosition
{
	return _sizeAndPosition;
}

- (void)setVisible:(BOOL)visible
{
	_isVisible=visible;
}

- (BOOL)isVisible
{
	return _isVisible;
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

	_sizeAndPosition.origin.x+=point.x;
	_sizeAndPosition.origin.y+=point.y;
}

- (void)hotUpdatePositionWithPoint:(NSPoint)point{
	
	_sizeAndPosition.origin.x=_savedSizeAndPosition.origin.x+point.x;
	_sizeAndPosition.origin.y=_savedSizeAndPosition.origin.y+point.y;
}

- (void)savePosition{
	_savedSizeAndPosition = _sizeAndPosition;
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [[NSMutableDictionary alloc] init];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithBool:_isVisible] forKey:@"Visible"];
	[dico setObject:[NSNumber numberWithFloat:_sizeAndPosition.size.width] forKey:@"Width"];
	[dico setObject:[NSNumber numberWithFloat:_sizeAndPosition.size.height] forKey:@"Height"];
	[dico setObject:[NSNumber numberWithFloat:_sizeAndPosition.origin.x] forKey:@"X"];
	[dico setObject:[NSNumber numberWithFloat:_sizeAndPosition.origin.y] forKey:@"Y"];
	[dico setObject:_name forKey:@"Name"];
	//[dico setObject: forKey:@""];
	//[dico setObject: forKey:@""];
	return dico;
}

@end
