//
//  Text.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCText.h"
#import <AppKit/NSStringDrawing.h>

@implementation PMCText

@synthesize content=_content;
@synthesize textColor=_textColor;
@synthesize textSize=_textSize;
@synthesize textAlign=_textAlign;
@synthesize textFontIndex=_fontIndex;


@synthesize textBold=_bold;
@synthesize textItalic=_italic;
@synthesize textUnderline=_underline;
- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
		_content=@"Text...";
		_textColor=[NSColor blackColor];
		_textSize=12;
		_fontIndex=1;
		//_textFont=[NSFont fontWithName:[_fontList objectAtIndex:_fontIndex] size:(float)_textSize];
		_textEncoding=NSUTF8StringEncoding;
		_bold=FALSE;
		_italic=FALSE;
		_underline=FALSE;
		_backgroundVisible=FALSE;
		
    }
    return self;
}


- (id)initWithData:(NSDictionary*)dico{
	self = [super initWithData:dico];
	
	_textAlign= [[dico objectForKey:@"TextAlign"] intValue];
	_fontIndex= [[dico objectForKey:@"TextFontIndex"] intValue];
	_textSize= [[dico objectForKey:@"TextFontSize"] intValue];
	_bold= [[dico objectForKey:@"TextBold"] boolValue];
	_italic= [[dico objectForKey:@"TextItalic"] boolValue];
	_underline= [[dico objectForKey:@"TextUnderline"] boolValue];
	_textColor= [[dico objectForKey:@"TextFontColor"] copy];
	_content= [[dico objectForKey:@"TextContent"] copy];
	
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
	
	//NSLog(@"Export objet Type : texte");
	//NSLog(@"Bold ? %@",((_bold)? @"true":@"false"));
	
	//redéfini l'atribut type
	[myNode removeAttributeForName:@"type"];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"texte"]];
	
	if(![[_textColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _textColor = [_textColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"couleur" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_textColor redComponent], [_textColor greenComponent], [_textColor blueComponent]]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"valeur" stringValue:_content]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"taille" stringValue:[NSString stringWithFormat:@"%i",_textSize]]];
	
	//[[_fontList objectAtIndex:_fontIndex] objectForKey:@"name"]
	[myNode addAttribute:[NSXMLNode attributeWithName:@"police" stringValue:[_fontList objectAtIndex:_fontIndex]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"align" stringValue:[NSString stringWithFormat:@"%i",_textAlign]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"bold" stringValue:((_bold)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"italic" stringValue:((_italic)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"underline" stringValue:((_underline)? @"true":@"false")]];
	
	
	
	return myNode;
}


- (void)setContent:(NSString*)newText
{
	[[undoManager prepareWithInvocationTarget:self] setContent:_content];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMText",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_content release];
	_content = [newText copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setTextColor:(NSColor*)newColor
{
	[[undoManager prepareWithInvocationTarget:self] setTextColor:_textColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTextColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[_textColor release];
	_textColor = [[self changeColorSpaceNameToRVB:newColor] copy];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setTextSize:(int)newSize
{
	[[undoManager prepareWithInvocationTarget:self] setTextSize:_textSize];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTextSize",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_textSize = newSize;
	[self didChangeValueForKey:FigureDrawingContentsKey];
	//if(_textFont) _textFont = [NSFont fontWithName:[_fontList objectAtIndex:_fontIndex] size:(float)_textSize];
}


- (void)setTextAlign:(int)newSize
{
	[[undoManager prepareWithInvocationTarget:self] setTextAlign:_textAlign];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTextAlign",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_textAlign = newSize;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setTextFontIndex:(int)newFont
{
	[[undoManager prepareWithInvocationTarget:self] setTextFontIndex:_fontIndex];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMFont",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_fontIndex = newFont;
	[self didChangeValueForKey:FigureDrawingContentsKey];
	//[NSFont fontWithName:[_fontList objectAtIndex:_fontIndex] size:(float)_textSize];
}

- (void)setTextEncoding:(TextEncoding)newTE
{
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_textEncoding=newTE;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (TextEncoding)getTextEncoding
{
	return _textEncoding;
}


- (void)setTextBold:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setTextBold:_bold];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMBold",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_bold=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setTextItalic:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setTextItalic:_italic];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMItalic",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_italic=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setTextUnderline:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setTextUnderline:_underline];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMUnderline",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	_underline=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}



- (void)draw
{
	[super draw];
	//NSString * s = [[NSString alloc] initWithString:_content];
	NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:_content];
	NSRange r = NSMakeRange(0, [_content length]);
	NSFont * tF = [NSFont fontWithName:[_fontList objectAtIndex:_fontIndex] size:(float)_textSize];
	[as addAttribute:NSFontAttributeName value:tF range:r];
	
	[as addAttribute:NSForegroundColorAttributeName value:_textColor range:r];
	
	[as addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:_underline] range:r];
	if(_bold) [as addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-2.0] range:r];
	else [as addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:0.0] range:r];
	if(_italic) [as addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:0.2] range:r];
	else  [as addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:0.0] range:r];
	//[as addAttribute:NSItalicFontMask value:[NSNumber numberWithBool:_italic] range:r];
	
	//NSLog(@"haut: %f ; bas : %f ; diff : %f",[_textFont ascender], [_textFont descender], [_textFont ascender]-[_textFont descender]);
	
	NSSize s = [as size];
	NSRect finalRect;
	
	if(_textAlign==0) //alignement à gauche
		finalRect = NSMakeRect(x, y+((height/2)-[tF ascender]), width, height);
	else if(_textAlign==1) //alignement à centre
		finalRect = NSMakeRect(x+((width/2)-(s.width/2)), y+((height/2)-[tF ascender]), s.width+10, height);
	else// if(_textAlign==2) //alignement à droite
		finalRect = NSMakeRect((x+width)-s.width, y+((height/2)-[tF ascender]), s.width, height);
	
	
	[as drawInRect:finalRect];
    [as release];
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [super getDataForSave];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithInt:_textAlign] forKey:@"TextAlign"];
	[dico setObject:[NSNumber numberWithInt:_fontIndex] forKey:@"TextFontIndex"];
	[dico setObject:[NSNumber numberWithInt:_textSize] forKey:@"TextFontSize"];
	
	[dico setObject:[NSNumber numberWithBool:_bold] forKey:@"TextBold"];
	[dico setObject:[NSNumber numberWithBool:_italic] forKey:@"TextItalic"];
	[dico setObject:[NSNumber numberWithBool:_underline] forKey:@"TextUnderline"];
	[dico setObject:_textColor forKey:@"TextFontColor"];
	[dico setObject:_content forKey:@"TextContent"];
	//[dico setObject: forKey:@""];
	
	return dico;
}

@end
