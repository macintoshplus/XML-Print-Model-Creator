//
//  PMCTableau.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 24/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCTableau.h"
#import <AppKit/NSStringDrawing.h>

@implementation PMCTableauRow

@synthesize undoManager;

@synthesize name;
@synthesize genre;
@synthesize hauteurLigne;
@synthesize colorBG;
@synthesize backgroundVisible;
@synthesize fontIndex;
@synthesize fontSize;
@synthesize fontColor;
@synthesize fontBold;
@synthesize fontItalic;
@synthesize fontUnderline;

@synthesize borderTopVisible;
@synthesize borderTopWidth;
@synthesize borderTopColor;

@synthesize borderBottomVisible;
@synthesize borderBottomWidth;
@synthesize borderBottomColor;

- (id)copyWithZone:(NSZone*)zone{
	NSLog(@"PMCTableauRow:copyWithZone:%@",self);
	id obj = [[PMCTableauRow alloc] init];
    NSString *sn=[name copy];
	[(PMCTableauRow*)obj setName:sn];
    [sn release];
    NSString * s = [genre copy];
	[obj setGenre:s];
    [s release];
	[obj setHauteurLigne:hauteurLigne];
    NSColor * bgC=[colorBG copy];
	[obj setColorBG:bgC];
    [bgC release];
	[obj setBackgroundVisible:backgroundVisible];
	[obj setFontIndex:fontIndex];
	[obj setFontSize:fontSize];
    NSColor* c=[fontColor copy];
	[obj setFontColor:c];
    [c release];
	[obj setFontBold:fontBold];
	[obj setFontItalic:fontItalic];
	[obj setFontUnderline:fontUnderline];
	
	[obj setBorderTopVisible:borderTopVisible];
	[obj setBorderTopWidth:borderTopWidth];
    NSColor*c2=[borderTopColor copy];
	[obj setBorderTopColor:c2];
    [c2 release];
	
	[obj setBorderBottomVisible:borderBottomVisible];
	[obj setBorderBottomWidth:borderBottomWidth];
    NSColor* c3=[borderBottomColor copy];
	[obj setBorderBottomColor:c3];
	[c3 release];
	return obj;
}

- (id)init{
	self = [super init];
	if(self){
		name= @"Row";
		genre=@"N";
		hauteurLigne=17;
		colorBG = [NSColor whiteColor];
		backgroundVisible=FALSE;
		fontIndex=1;
		fontSize=12;
		fontColor = [NSColor blackColor];
		fontBold=FALSE;
		fontItalic=FALSE;
		fontUnderline=FALSE;
		
		borderTopVisible=TRUE;
		borderTopWidth=1;
		borderTopColor = [NSColor darkGrayColor];
		
		borderBottomVisible=TRUE;
		borderBottomWidth=1;
		borderBottomColor = [NSColor darkGrayColor];
	}
	return self;
}

- (id)initWithData:(NSDictionary*)dico{
	self = [super init];
	backgroundVisible = [[dico objectForKey:@"RowBackgroundVisible"] boolValue];
	borderTopVisible = [[dico objectForKey:@"RowBorderTopVisible"] boolValue];
	borderBottomVisible = [[dico objectForKey:@"RowBorderBottomVisible"] boolValue];
	hauteurLigne = [[dico objectForKey:@"RowHauteurLigne"] intValue];
	fontIndex = [[dico objectForKey:@"RowFontIndex"] intValue];
	fontSize = [[dico objectForKey:@"RowFontSize"] intValue];
	borderTopWidth = [[dico objectForKey:@"RowBorderTopWidth"] intValue];
	borderBottomWidth = [[dico objectForKey:@"RowBorderBottomWidth"] intValue];
	name = [[dico objectForKey:@"RowName"] copy];
	genre = [[dico objectForKey:@"RowGenre"] copy];
	colorBG = [[dico objectForKey:@"RowBackgroundColor"] copy];
	fontColor = [[dico objectForKey:@"RowFontColor"] copy];
	borderTopColor = [[dico objectForKey:@"RowBorderTopColor"] copy];
	borderBottomColor = [[dico objectForKey:@"RowBorderBottomColor"] copy];
	
	if([dico objectForKey:@"RowFontBold"]==nil) fontBold=FALSE;
	else fontBold= [[dico objectForKey:@"RowFontBold"] boolValue];
	
	if([dico objectForKey:@"RowFontItalic"]==nil) fontItalic=FALSE;
	else fontItalic= [[dico objectForKey:@"RowFontItalic"] boolValue];
	
	if([dico objectForKey:@"RowFontUnderline"]==nil) fontUnderline=FALSE;
	else fontUnderline= [[dico objectForKey:@"RowFontUnderline"] boolValue];
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 */
	
	return self;
}

- (NSString*)description{
	NSString * txt = [[[NSString alloc] initWithFormat:@"\n%@ 0x%x {\n\tName\t\t\t\t\t\t: %@\n\tType\t\t\t\t\t\t: %@\n\tRow Height\t\t\t\t\t: %i\n\tBG Color\t\t\t\t\t: %@\n\tBG Visible\t\t\t\t\t: %@\n\tFont Index\t\t\t\t\t: %i\n\tFont size\t\t\t\t\t: %i\n\tFont color\t\t\t\t\t: %@\n\tBorder Top Visible\t\t: %@\n\tBorder Top Width\t\t\t: %i\n\tBorder Top Color\t\t\t: %@\n\tBorder Bottom Visible\t: %@\n\tBorder Bottom Width\t\t: %i\n\tBorder Bottom Color\t\t: %@\n}",
					  [self className], self, name, genre, hauteurLigne, colorBG, ((backgroundVisible)? @"True":@"False"), fontIndex, fontSize, fontColor, ((borderTopVisible)? @"True":@"False"), borderTopWidth, borderTopColor, ((borderBottomVisible)? @"True":@"False"), borderBottomWidth, borderBottomColor] autorelease];
	
	return txt;
}


- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor{
	if(![[oldColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]){
		
		//NSLog(@"Nouvelle couleur : %@",oldColor);
		return [oldColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		
	}
	return oldColor;
}


#pragma mark -
#pragma mark Setter

/*
 [[undoManager prepareWithInvocationTarget:self] setColor:_color];
 if(![undoManager isUndoing]){
 [undoManager setActionName:NSLocalizedStringFromTable(@"UMTraitColor",@"Localizable",@"Undo Manager Action")];
 }
 
 @property (retain) NSString * name;
 @property (retain) NSString * genre;
 @property (assign) int hauteurLigne;
 @property (retain) NSColor * colorBG;
 @property (assign) BOOL backgroundVisible;
 @property (assign) int fontIndex;
 @property (assign) int fontSize;
 @property (retain) NSColor * fontColor;
 
 @property (assign) BOOL borderTopVisible;
 @property (assign) int borderTopWidth;
 @property (retain) NSColor * borderTopColor;
 
 @property (assign) BOOL borderBottomVisible;
 @property (assign) int borderBottomWidth;
 @property (retain) NSColor * borderBottomColor;
 
 */

- (void)setName:(NSString *)newVal
{
	[(PMCTableauRow*)[undoManager prepareWithInvocationTarget:self] setName:name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowName",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[name release];
	name=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setGenre:(NSString *)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setGenre:genre];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowGenre",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[genre release];
	genre=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setHauteurLigne:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setHauteurLigne:hauteurLigne];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowHauteurLigne",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	hauteurLigne=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setColorBG:(NSColor *)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setColorBG:colorBG];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBGColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[colorBG release];
	colorBG=[[self changeColorSpaceNameToRVB:newVal] retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBackgroundVisible:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBackgroundVisible:backgroundVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBGVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	backgroundVisible=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setFontIndex:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontIndex:fontIndex];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowFont",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	fontIndex=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setFontSize:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontSize:fontSize];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowTextSize",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	fontSize=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setFontColor:(NSColor *)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontColor:fontColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowTextColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[fontColor release];
	fontColor=[[self changeColorSpaceNameToRVB:newVal] retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setFontBold:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontBold:fontBold];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowTextBold",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	fontBold=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setFontItalic:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontItalic:fontItalic];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowTextItalic",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	fontItalic=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}


- (void)setFontUnderline:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setFontUnderline:fontUnderline];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowTextUnderline",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	fontUnderline=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderTopVisible:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderTopVisible:borderTopVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderTopVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderTopVisible=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderTopWidth:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderTopWidth:borderTopWidth];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderTopWidth",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderTopWidth=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderTopColor:(NSColor *)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderTopColor:borderTopColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderTopColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[borderTopColor release];
	borderTopColor=[[self changeColorSpaceNameToRVB:newVal] retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderBottomVisible:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderBottomVisible:borderBottomVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderBottomVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderBottomVisible=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderBottomWidth:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderBottomWidth:borderBottomWidth];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderBottomWidth",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderBottomWidth=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderBottomColor:(NSColor *)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderBottomColor:borderBottomColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRowBorderBottomColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[borderBottomColor release];
	borderBottomColor=[[self changeColorSpaceNameToRVB:newVal] retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

#pragma mark -
#pragma mark Export

- (NSXMLElement*)exportToModel:(int)idx{
	NSXMLElement * myNode = [NSXMLNode elementWithName:[NSString stringWithFormat:@"ligne%i",idx]];//= [super exportToModel];
	//redéfini l'atribut type
	[myNode addAttribute:[NSXMLNode attributeWithName:@"ObjType" stringValue:@"Ligne"]];
	
	
	//NSLog(@"Avant export colorBG=%@",colorBG);
	/*
	if(![[colorBG colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]){
		NSColor * newVal = colorBG;
		[colorBG release];
		colorBG = [[newVal colorUsingColorSpaceName:NSCalibratedRGBColorSpace] retain];
		
	}*/
	//colorBG = [self changeColorSpaceNameToRVB:colorBG];
	if(![[colorBG colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) colorBG = [colorBG colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"CouleurFond" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [colorBG redComponent], [colorBG greenComponent], [colorBG blueComponent]]]];
	
	//NSLog(@"Apres export colorBG=%@",colorBG);
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"FondVisible" stringValue:((backgroundVisible)? @"true":@"false")]];
	
	if(![[borderBottomColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) borderBottomColor = [borderBottomColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"CouleurBordBas" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [borderBottomColor redComponent], [borderBottomColor greenComponent], [borderBottomColor blueComponent]]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"AfficherBordBas" stringValue:((borderBottomVisible)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"EpaisseurBordBas" stringValue:[NSString stringWithFormat:@"%i",borderBottomWidth]]];
	
	
	if(![[borderTopColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) borderTopColor = [borderTopColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"CouleurBordHaut" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [borderTopColor redComponent], [borderTopColor greenComponent], [borderTopColor blueComponent]]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"AfficherBordHaut" stringValue:((borderTopVisible)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"EpaisseurBordHaut" stringValue:[NSString stringWithFormat:@"%i",borderTopWidth]]];
	
	
	if(![[fontColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) fontColor = [fontColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"CouleurPolice" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [fontColor redComponent], [fontColor greenComponent], [fontColor blueComponent]]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Bold" stringValue:((fontBold)? @"true":@"false")]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Italic" stringValue:((fontItalic)? @"true":@"false")]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Underline" stringValue:((fontUnderline)? @"true":@"false")]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Hauteur" stringValue:[NSString stringWithFormat:@"%i",hauteurLigne]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"TaillePolice" stringValue:[NSString stringWithFormat:@"%i",fontSize]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Ordre" stringValue:[NSString stringWithFormat:@"%i",idx]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"NomLigne" stringValue:name]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"TypeLigne" stringValue:genre]];
	
	NSArray * _fontList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"NomPolice" stringValue:[_fontList objectAtIndex:fontIndex]]];
	[_fontList release];
	return myNode;
}


- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [[[NSMutableDictionary alloc] init] autorelease];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithBool:backgroundVisible] forKey:@"RowBackgroundVisible"];
	[dico setObject:[NSNumber numberWithBool:borderTopVisible] forKey:@"RowBorderTopVisible"];
	[dico setObject:[NSNumber numberWithBool:borderBottomVisible] forKey:@"RowBorderBottomVisible"];
	[dico setObject:[NSNumber numberWithInt:hauteurLigne] forKey:@"RowHauteurLigne"];
	[dico setObject:[NSNumber numberWithInt:fontIndex] forKey:@"RowFontIndex"];
	[dico setObject:[NSNumber numberWithInt:fontSize] forKey:@"RowFontSize"];
	[dico setObject:[NSNumber numberWithBool:fontBold] forKey:@"RowFontBold"];
	[dico setObject:[NSNumber numberWithBool:fontItalic] forKey:@"RowFontItalic"];
	[dico setObject:[NSNumber numberWithBool:fontUnderline] forKey:@"RowFontUnderline"];
	[dico setObject:[NSNumber numberWithInt:borderTopWidth] forKey:@"RowBorderTopWidth"];
	[dico setObject:[NSNumber numberWithInt:borderBottomWidth] forKey:@"RowBorderBottomWidth"];
	[dico setObject:name forKey:@"RowName"];
	[dico setObject:genre forKey:@"RowGenre"];
	[dico setObject:colorBG forKey:@"RowBackgroundColor"];
	[dico setObject:fontColor forKey:@"RowFontColor"];
	[dico setObject:borderTopColor forKey:@"RowBorderTopColor"];
	[dico setObject:borderBottomColor forKey:@"RowBorderBottomColor"];
	
	return dico;
}

@end


#pragma mark -
@implementation PMCTableauCol

@synthesize undoManager;

@synthesize name;
@synthesize data;
@synthesize colWidth;
@synthesize dataAlign;

@synthesize headerData;
@synthesize headerAlign;

@synthesize borderRightVisible;
@synthesize borderRightWidth;
@synthesize borderRightColor;


- (id)copyWithZone:(NSZone*)zone{
	NSLog(@"PMCTableauCol:copyWithZone:%@",self);
	id obj = [[[PMCTableauCol alloc] init] autorelease];
    NSString * s = [name copy];
	[(PMCTableauCol*)obj setName:s];
    [s release];
    
    NSData *d=[data copy];
	[obj setData:d];
    [d release];
	
    [obj setColWidth:colWidth];
	[obj setDataAlign:dataAlign];
    
    s=[headerData copy];
	[obj setHeaderData:s];
    [s release];
	
    [obj setHeaderAlign:headerAlign];
	[obj setBorderRightVisible:borderRightVisible];
	[obj setBorderRightWidth:borderRightWidth];
    
    NSColor *c=[borderRightColor copy];
	[obj setBorderRightColor:c];
    [c release];
	
	return [obj retain];
}

- (id)init{
	self = [super init];
	if(self){
		
		name=@"Col";
		data=@"Data";
		colWidth=100;
		dataAlign=0;
		
		headerData=@"Header";
		headerAlign=0;
		
		borderRightVisible=TRUE;
		borderRightWidth=1;
		borderRightColor=[NSColor darkGrayColor];
		
	}
	return self;
}

- (id)initWithData:(NSDictionary*)dico{
	self = [super init];
	
	borderRightVisible= [[dico objectForKey:@"ColBorderRightVisible"] boolValue];
	colWidth= [[dico objectForKey:@"ColWidth"] intValue];
	dataAlign= [[dico objectForKey:@"ColDataAlign"] intValue];
	headerAlign= [[dico objectForKey:@"ColHeaderAlign"] intValue];
	borderRightWidth= [[dico objectForKey:@"ColBorderRightWidth"] intValue];
	name= [[dico objectForKey:@"ColName"] copy];
	data= [[dico objectForKey:@"ColData"] copy];
	headerData= [[dico objectForKey:@"ColHeaderData"] copy];
	borderRightColor= [[dico objectForKey:@"ColBorderRightColor"] copy];
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	return self;
}

- (NSString*)description{
	NSString * txt = [[[NSString alloc] initWithFormat:@"\n%@ 0x%x {\n\tName\t\t\t\t: %@\n\tData\t\t\t\t: %@\n\tColumn Width\t\t: %i\n\tColumn Align\t\t: %i\n\tHeader Data\t\t: %@\n\tHeader Align\t\t: %i\n\tBorder Visible\t: %@\n\tBorder Width\t\t: %i\n\tBorder Color\t\t: %@\n}",
			[self className], self, name, data, colWidth, dataAlign, headerData, headerAlign, ((borderRightVisible)? @"True":@"False"), borderRightWidth, borderRightColor] autorelease];
	
	return txt;
}

- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor{
	if(![[oldColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]){
		return [oldColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		
	}
	return oldColor;
}


#pragma mark -
#pragma mark Setter

/*
 [[undoManager prepareWithInvocationTarget:self] setColor:_color];
 if(![undoManager isUndoing]){
 [undoManager setActionName:NSLocalizedStringFromTable(@"UMTraitColor",@"Localizable",@"Undo Manager Action")];
 }
 
 
 */

- (void)setName:(NSString*)newVal
{
	[(PMCTableauCol*)[undoManager prepareWithInvocationTarget:self] setName:name];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColName",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[name release];
	name=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setData:(NSString*)newVal
{
	[(PMCTableauCol*)[undoManager prepareWithInvocationTarget:self] setData:data];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColData",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[data release];
	data=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setColWidth:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setColWidth:colWidth];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColWidth",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	colWidth=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setDataAlign:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setDataAlign:dataAlign];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColDataAlign",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	dataAlign=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setHeaderData:(NSString*)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setHeaderData:headerData];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColHeaderData",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[headerData release];
	headerData=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setHeaderAlign:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setHeaderAlign:headerAlign];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColHeaderAlign",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	headerAlign=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderRightVisible:(BOOL)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderRightVisible:borderRightVisible];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColRightBorderVisibility",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderRightVisible=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderRightWidth:(int)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderRightWidth:borderRightWidth];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColRightBorderWidth",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	borderRightWidth=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setBorderRightColor:(NSColor*)newVal
{
	[[undoManager prepareWithInvocationTarget:self] setBorderRightColor:borderRightColor];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMColRightBorderColor",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[borderRightColor release];
	borderRightColor=[[self changeColorSpaceNameToRVB:newVal] retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}





#pragma mark -
#pragma mark Export

- (NSXMLElement*)exportToModel:(int)idx{
	NSXMLElement * myNode = [NSXMLNode elementWithName:[NSString stringWithFormat:@"colonne%i",idx]];//= [super exportToModel];
	//redéfini l'atribut type
	[myNode addAttribute:[NSXMLNode attributeWithName:@"ObjType" stringValue:@"Colonne"]];
	
	if(![[borderRightColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) borderRightColor = [borderRightColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"CouleurBord" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [borderRightColor redComponent], [borderRightColor greenComponent], [borderRightColor blueComponent]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"TailleBordure" stringValue:[NSString stringWithFormat:@"%i",borderRightWidth]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"BordDroit" stringValue:((borderRightVisible)? @"true":@"false")]];
	
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Donnee" stringValue:data]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"EnteteDonnee" stringValue:headerData]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Largeur" stringValue:[NSString stringWithFormat:@"%i",colWidth]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"EnteteAlignement" stringValue:[NSString stringWithFormat:@"%i",headerAlign]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"AlignementTexte" stringValue:[NSString stringWithFormat:@"%i",dataAlign]]];
	
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"NomDeColonne" stringValue:name]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Ordre" stringValue:[NSString stringWithFormat:@"%i",idx]]];
		
	return myNode;
}



- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [[[NSMutableDictionary alloc] init] autorelease];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithBool:borderRightVisible] forKey:@"ColBorderRightVisible"];
	[dico setObject:[NSNumber numberWithInt:colWidth] forKey:@"ColWidth"];
	[dico setObject:[NSNumber numberWithInt:dataAlign] forKey:@"ColDataAlign"];
	[dico setObject:[NSNumber numberWithInt:headerAlign] forKey:@"ColHeaderAlign"];
	[dico setObject:[NSNumber numberWithInt:borderRightWidth] forKey:@"ColBorderRightWidth"];
	[dico setObject:name forKey:@"ColName"];
	[dico setObject:data forKey:@"ColData"];
	[dico setObject:headerData forKey:@"ColHeaderData"];
	[dico setObject:borderRightColor forKey:@"ColBorderRightColor"];
	
	
	return dico;
}

@end


#pragma mark -
@implementation PMCTableau

@synthesize columnDef;
@synthesize rowDef;

@synthesize showHeader;
@synthesize repeatHeader;

@synthesize repeatArrayToOtherPage;
@synthesize topOnOtherPage;
@synthesize heightOnOtherPage;

@synthesize dataSource;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
		columnDef = [[NSMutableArray alloc] init];
		rowDef = [[NSMutableArray alloc] init];
		dataSource = @"";
		showHeader=TRUE;
		repeatHeader=FALSE;
		repeatArrayToOtherPage=FALSE;
		topOnOtherPage=20;
		heightOnOtherPage=200;
    }
    return self;
}


- (id)initWithData:(NSDictionary*)dico{
	self = [super initWithData:dico];
	
	showHeader= [[dico objectForKey:@"ArrayShowHeader"] boolValue];
	repeatHeader= [[dico objectForKey:@"ArrayRepeatHeader"] boolValue];
	repeatArrayToOtherPage= [[dico objectForKey:@"ArrayRepeatOnOtherPage"] boolValue];
	topOnOtherPage= [[dico objectForKey:@"ArrayTopOnOtherPage"] intValue];
	heightOnOtherPage= [[dico objectForKey:@"ArrayHeightOnOtherPage"] intValue];
	dataSource= [[dico objectForKey:@"ArrayDataSource"] copy];
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	
	NSArray * arCol = [dico objectForKey:@"ArrayColumnDef"];
	int i=0;
	for(i=0;i<[arCol count];i++){
		PMCTableauCol * col = [[PMCTableauCol alloc] initWithData:[arCol objectAtIndex:i]];
		[col setUndoManager:undoManager];
		[columnDef addObject:col];
        [col release];
	}
	
	NSArray * arRow = [dico objectForKey:@"ArrayRowDef"];;
	
	for(i=0;i<[arRow count];i++){
		PMCTableauRow * row = [[PMCTableauRow alloc] initWithData:[arRow objectAtIndex:i]];
		[row setUndoManager:undoManager];
		[rowDef addObject:row];
        [row release];
	}
	
	return self;
}

- (NSString*)description{
	NSString * txt = [[[NSString alloc] initWithFormat:@"\n%@ 0x%x {\n\tRow\t\t\t\t\t\t: %@\n\tColumn\t\t\t\t\t: %@\n\tHeader\t\t\t\t\t: %@\n\tRepeat Header\t\t\t: %@\n\tRepeat Array\t\t\t: %@\n\tTop For Repeat\t\t: %i\n\tHeight For Repeat\t\t: %i\n}",
					  [self className], self, rowDef, columnDef, ((showHeader)? @"True":@"False"), ((repeatHeader)? @"True":@"False"), ((repeatArrayToOtherPage)? @"True":@"False"), topOnOtherPage, heightOnOtherPage] autorelease];
	
	return txt;
}

#pragma mark -
#pragma mark Setter

/*
[[undoManager prepareWithInvocationTarget:self] setColor:_color];
if(![undoManager isUndoing]){
	[undoManager setActionName:NSLocalizedStringFromTable(@"UMTraitColor",@"Localizable",@"Undo Manager Action")];
}

 */

- (void)setShowHeader:(BOOL)newVal{
	[[undoManager prepareWithInvocationTarget:self] setShowHeader:showHeader];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMShowHeader",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	showHeader=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setRepeatHeader:(BOOL)newVal{
	[[undoManager prepareWithInvocationTarget:self] setRepeatHeader:repeatHeader];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRepeatHeader",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	repeatHeader=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setRepeatArrayToOtherPage:(BOOL)newVal{
	[[undoManager prepareWithInvocationTarget:self] setRepeatArrayToOtherPage:repeatArrayToOtherPage];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMRepeatArrayToOtherPage",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	repeatArrayToOtherPage=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setTopOnOtherPage:(int)newVal{
	[[undoManager prepareWithInvocationTarget:self] setTopOnOtherPage:topOnOtherPage];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMTopOnOtherPage",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	topOnOtherPage=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setHeightOnOtherPage:(int)newVal{
	[[undoManager prepareWithInvocationTarget:self] setHeightOnOtherPage:heightOnOtherPage];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMHeightOnOtherPage",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	heightOnOtherPage=newVal;
	[self didChangeValueForKey:FigureDrawingContentsKey];
}

- (void)setDataSource:(NSString*)newVal{
	[(PMCTableau*)[undoManager prepareWithInvocationTarget:self] setDataSource:dataSource];
	if(![undoManager isUndoing]){
		[undoManager setActionName:NSLocalizedStringFromTable(@"UMDataSource",@"Localizable",@"Undo Manager Action")];
	}
	[self willChangeValueForKey:FigureDrawingContentsKey];
	[dataSource release];
	dataSource=[newVal retain];
	[self didChangeValueForKey:FigureDrawingContentsKey];
}



#pragma mark -
#pragma mark Export

- (NSXMLElement*)exportToModel{
	NSXMLElement * myNode = [super exportToModel];
	//redéfini l'atribut type
	[myNode removeAttributeForName:@"type"];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"Tableau"]];
	
	//Suppression des propriétés 1.0 de contour du rectangle.
	//[myNode removeAttributeForName:@"couleurcontour"];
	//[myNode removeAttributeForName:@"couleurcontour1"];
	
	//[myNode removeAttributeForName:@"epaisseurcontour"];
	
	// suppression des propriétés du rectangle
	/*[myNode removeAttributeForName:@"couleurcontourhaut"];
	[myNode removeAttributeForName:@"contourhautvisible"];
	[myNode removeAttributeForName:@"couleurcontourdroite"];
	[myNode removeAttributeForName:@"contourdroitevisible"];
	[myNode removeAttributeForName:@"couleurcontourbas"];
	[myNode removeAttributeForName:@"contourbasvisible"];
	[myNode removeAttributeForName:@"couleurcontourgauche"];
	[myNode removeAttributeForName:@"contourgauchevisible"];
	 */
	
	/* Modifiation du 2/08/2010 : Utilisation des propriétés du rectangle pour la gestion de la bordure */
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderBottom" stringValue:((_borderProperty.bottomVisible)? @"true":@"false")]];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderTop" stringValue:((_borderProperty.topVisible)? @"true":@"false")]];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderLeft" stringValue:((_borderProperty.leftVisible)? @"true":@"false")]];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderRight" stringValue:((_borderProperty.rightVisible)? @"true":@"false")]];
	
	//if(![[_borderProperty.leftColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _borderProperty.leftColor = [_borderProperty.leftColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderColor" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_borderProperty.leftColor redComponent], [_borderProperty.leftColor greenComponent], [_borderProperty.leftColor blueComponent]]]];
	
	//[myNode addAttribute:[NSXMLNode attributeWithName:@"borderSize" stringValue:[NSString stringWithFormat:@"%i",_borderProperty.borderSize]]];
	/* Fin modification du 2/08/2010 */
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"topOnOtherPage" stringValue:[NSString stringWithFormat:@"%i",topOnOtherPage]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"heightOnOtherPage" stringValue:[NSString stringWithFormat:@"%i",heightOnOtherPage]]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"nbColumn" stringValue:[NSString stringWithFormat:@"%lu",[columnDef count]]]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"nbRows" stringValue:[NSString stringWithFormat:@"%lu",[rowDef count]]]];
	
	
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"multiPage" stringValue:((repeatArrayToOtherPage)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"headerRow" stringValue:((showHeader)? @"true":@"false")]];
	[myNode addAttribute:[NSXMLNode attributeWithName:@"reapeatHeadRows" stringValue:((repeatHeader)? @"true":@"false")]];
	
	[myNode addAttribute:[NSXMLNode attributeWithName:@"Donnee" stringValue:dataSource]];
	
	int i;
	
	for(i=0;i<[columnDef count];i++){
		[myNode addChild:[[columnDef objectAtIndex:i] exportToModel:i+1]];
	}
	
	for(i=0;i<[rowDef count];i++){
		[myNode addChild:[[rowDef objectAtIndex:i] exportToModel:i+1]];
	}
	
	
	return myNode;
}


- (void)draw {
	
	//Dessin du fond général
	if(_backgroundVisible){
		PMCBorderSetting sauveBorder = _borderProperty;
		[self setBorderVisibility:FALSE];
		[super draw];
		_borderProperty=sauveBorder;
	}
	NSBezierPath * bp;
	int i = 0;
	int j = 0;
	PMCTableauCol * col;
	PMCTableauRow * row;
	float rightCumul = 0.0;
	float topCumul = 0.0;
	// Parcour des lignes
	for(i=0;i<[rowDef count];i++){
		
		//extraction de la ligne
		row = [rowDef objectAtIndex:i];
		
		//rendu du font de la ligne
		if([row backgroundVisible]){
			NSRect rowRect=NSMakeRect(x, y+topCumul, width, [row hauteurLigne]);
			bp = [NSBezierPath bezierPathWithRect:rowRect];
			[[row colorBG] set];
			[bp fill];
		}
		
		//rendu du texte de la ligne par colonne
		NSFont * f;
		NSRange r;
		NSSize s;
		NSString * texte;
		int align;
		NSRect finalRect;
		NSMutableAttributedString * as;
		
		rightCumul = 0;
		for(j=0;j<[columnDef count];j++){
			col = [columnDef objectAtIndex:j];
			f = [NSFont fontWithName:[_fontList objectAtIndex:[row fontIndex]] size:(float)[row fontSize]];
			if(showHeader && i==0){
				texte = [col headerData];
				align = [col headerAlign];
			}else{
				texte = [col data];
				align = [col dataAlign];
			}
			
			
			//initialisation de l'objet pour l'affichage des chaines
			as = [[NSMutableAttributedString alloc] initWithString:texte];
			//range pour la longeur total du texte
			r = NSMakeRange(0, [texte length]);
			//ajoute la police et taille
			[as addAttribute:NSFontAttributeName value:f range:r];
			//ajoute la couleur du texte
			[as addAttribute:NSForegroundColorAttributeName value:[row fontColor] range:r];
			
			
			
			[as addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:[row fontUnderline]] range:r];
			if([row fontBold]) [as addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-2.0] range:r];
			else [as addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:0.0] range:r];
			if([row fontItalic]) [as addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:0.2] range:r];
			else  [as addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:0.0] range:r];
			
			s = [as size];
			//NSLog(@"Size : w=%f h=%f",s.width, s.height);
			
			//calcul de la largeur de la colonne
			float newLargCol = 0.0;
			if(s.width>(float)[col colWidth]) newLargCol=(float)[col colWidth];
			else newLargCol = s.width;
			
			
			//Calcul du décalage de X pour les éléments centrés et alignés à droite.
			float decalX=0.0;
			if(newLargCol!=(float)[col colWidth] && align>0){
				if(align==1) decalX=(((float)[col colWidth])/2) - (newLargCol/2); //centrer
				if(align==2) decalX=((float)[col colWidth]) - newLargCol - (([col borderRightVisible])? ((float)[col borderRightWidth]+1):1.0); //droite
			}
			
			//Création du rectangle contenant le texte
			finalRect = NSMakeRect(x+rightCumul+decalX, y+topCumul+(((float)[row hauteurLigne]/2) - (s.height/2)), newLargCol, s.height);
			
			//NSLog(@"Final Size : w=%f h=%f",finalRect.size.width,finalRect.size.height);
			[as drawInRect:finalRect];
			[as release];
			rightCumul+=(float)[col colWidth];
		}
		
		//Déssin de la ligne haute
		if([row borderTopVisible]){
			bp = [NSBezierPath bezierPath];
			[[row borderTopColor] set];
			[bp setLineWidth:(float)[row borderTopWidth]];
			[bp moveToPoint:NSMakePoint(x, y+topCumul)];
			[bp lineToPoint:NSMakePoint(x+width, y+topCumul)];
			[bp stroke];
		}
		//Déssin de la ligne basse
		if([row borderBottomVisible]){
			bp = [NSBezierPath bezierPath];
			[[row borderBottomColor] set];
			[bp setLineWidth:(float)[row borderBottomWidth]];
			[bp moveToPoint:NSMakePoint(x, y+topCumul+[row hauteurLigne])];
			[bp lineToPoint:NSMakePoint(x+width, y+topCumul+[row hauteurLigne])];
			[bp stroke];
		}
		
		//dessante de la position
		topCumul+=[row hauteurLigne];
		
		
	}
	
	
	// Déssin des bords de colonne
	rightCumul = 0;
	for(i=0;i<[columnDef count];i++){
		col = [columnDef objectAtIndex:i];
		rightCumul+=[col colWidth];
		if([col borderRightVisible] && i<[columnDef count]-1){
			bp = [NSBezierPath bezierPath];
			[[col borderRightColor] set];
			[bp setLineWidth:(float)[col borderRightWidth]];
			[bp moveToPoint:NSMakePoint(x+rightCumul-1, y)];
			[bp lineToPoint:NSMakePoint(x+rightCumul-1, height+y)];
			[bp stroke];
		}
	}
	//[_vectorPath addObject:[[bp retain] autorelease]];
	
	if(_backgroundVisible){
		_backgroundVisible=FALSE;
		[super draw];
		_backgroundVisible=TRUE;
	}else [super draw];
}

- (NSMutableDictionary*)getDataForSave{
	NSMutableDictionary * dico = [super getDataForSave];
	[dico setObject:[self className] forKey:@"ObjectClassName"];
	[dico setObject:[NSNumber numberWithBool:showHeader] forKey:@"ArrayShowHeader"];
	[dico setObject:[NSNumber numberWithBool:repeatHeader] forKey:@"ArrayRepeatHeader"];
	[dico setObject:[NSNumber numberWithBool:repeatArrayToOtherPage] forKey:@"ArrayRepeatOnOtherPage"];
	[dico setObject:[NSNumber numberWithInt:topOnOtherPage] forKey:@"ArrayTopOnOtherPage"];
	[dico setObject:[NSNumber numberWithInt:heightOnOtherPage] forKey:@"ArrayHeightOnOtherPage"];
	[dico setObject:dataSource forKey:@"ArrayDataSource"];
	NSMutableArray * arCol = [[NSMutableArray alloc] init];
	int i=0;
	for(i=0;i<[columnDef count];i++){
		[arCol addObject:[[columnDef objectAtIndex:i] getDataForSave]];
	}
	[dico setObject:arCol forKey:@"ArrayColumnDef"];
    [arCol release];
    
	NSMutableArray * arRow = [[NSMutableArray alloc] init];

	for(i=0;i<[rowDef count];i++){
		[arRow addObject:[[rowDef objectAtIndex:i] getDataForSave]];
	}
	[dico setObject:arRow forKey:@"ArrayRowDef"];
    [arRow release];
	//[dico setObject: forKey:@""];
	
	return dico;
}

@end
