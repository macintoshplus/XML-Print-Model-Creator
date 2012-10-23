//
//  PMCModelEditor.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCBook.h"
#import "PMCPropertiesView.h"
#import "PMCPageContainer.h"
#import "PMCPageViewPrint.h"

@implementation PMCBook

@synthesize pageFormatList=_pageFormat;
@synthesize fontList=_fontList;

@synthesize pageFormat=_format;
@synthesize pageOrientation=_orientation;

@synthesize title=_title;
@synthesize author=_author;
@synthesize description=_description;

@synthesize firstPage=_firstPage;
@synthesize otherPage=_otherPage;
@synthesize lastPage=_lastPage;

@synthesize formatPagination=_formatPagination;
@synthesize paginationPositionX=_xPagination;
@synthesize paginationPositionY=_yPagination;
@synthesize enabledPagination=_enabledPagination;

@synthesize textColor=_colorFontPagination;
@synthesize textSize=_fontSizePagination;
@synthesize textAlign=_alignPagination;
@synthesize textFontIndex=_fontIndexPagination;
@synthesize textBold=_boldFontPagination;
@synthesize textItalic=_italicFontPagination;
@synthesize textUnderline=_underlineFontPagination;


- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		
		_format=1;
		_orientation=0;
        _title=@"";
        _author=@"";
        _description=@"";
		
		_firstPage=TRUE;
		_otherPage=FALSE;
		_lastPage=FALSE;
		
		_formatPagination=@"Page {PAGENUM} sur {TOTALPAGENUM}";
		_alignPagination=0;
		_xPagination=20;
		_yPagination=700;
		
		_enabledPagination=FALSE;
		_fontIndexPagination=1;
		_fontSizePagination=12;
		_colorFontPagination=[NSColor blackColor];
		_boldFontPagination=FALSE;
		_italicFontPagination=FALSE;
		_underlineFontPagination=FALSE;
		
		_tmpLastIndexObj = -1;
		
		_pageFormat = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PageFormat" ofType:@"plist"]];
		_fontList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"]];

		pages = [[NSMutableArray alloc] init];
		
		
		NSRect rect;
		if(_orientation==0) rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]);
		else rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]);
		
		PMCPage * _page1 = [[PMCPage alloc] initWithFrame:rect];
		[_page1 setDelegate:self];
		[_page1 setTitle:@"Fist Page"];
		PMCPage * _page2 = [[PMCPage alloc] initWithFrame:rect];
		[_page2 setDelegate:self];
		[_page2 setTitle:@"Other Page"];
		PMCPage * _page3 = [[PMCPage alloc] initWithFrame:rect];
		[_page3 setDelegate:self];
		[_page3 setTitle:@"Last Page"];
		//_actualPage=[_page1 retain];
		
		/*
		[pagesArrayController addObject:_page1];
		[pagesArrayController addObject:_page2];
		[pagesArrayController addObject:_page3];
		*/
		
		[pages addObject:_page1];
		[pages addObject:_page2];
		[pages addObject:_page3];
		
		[_page1 release];
		[_page2 release];
		[_page3 release];
		
		//NSLog(@"_pageFormat = %@",_pageFormat);
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Book";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	//Observation du chagement de page
	[pagesArrayController addObserver:self
						   forKeyPath:@"selectionIndex"
							  options:NSKeyValueObservingOptionNew
							  context:nil];
	
	//Selection de la page 1 et actualisation de _actualPage
	[pagesArrayController setSelectionIndex:0];
	_actualPage=[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] retain];
	
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:NO];	
    [toolbar setAutosavesConfiguration:NO];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[toolbar validateVisibleItems];
    [[self windowForSheet] setToolbar:toolbar];
	[toolbar release];
	
	[main_SplitVertical replaceSubview:[[main_SplitVertical subviews] objectAtIndex:0] with:main_ObjectListView];
	//[main_SplitVertical replaceSubview:[[main_SplitVertical subviews] lastObject] with:main_PreView];
	[main_SplitVertical adjustSubviews];
	
	
    
	PMCPageView * pView = [[PMCPageView alloc] initWithFrame:[self frameWidthFormatAndOrientation]];
	[pView bind: @"_listObject" toObject: figuresArrayController withKeyPath:@"arrangedObjects" options:nil];
    
	[pView bind: @"pageFormat" toObject:self withKeyPath:@"pageFormat" options:nil];
    
	[pView bind: @"pageOrientation" toObject:self withKeyPath:@"pageOrientation" options:nil];
    
    [pView bind: @"selectionIndexes" toObject:figuresArrayController withKeyPath:@"selectionIndexes" options:nil];
    
    [pView bind: @"enabledPagination" toObject:self withKeyPath:@"enabledPagination" options:nil];
    
    [pView bind: @"formatPagination" toObject:self withKeyPath:@"formatPagination" options:nil];
    
    [pView bind: @"paginationPositionX" toObject:self withKeyPath:@"paginationPositionX" options:nil];
    
    [pView bind: @"paginationPositionY" toObject:self withKeyPath:@"paginationPositionY" options:nil];
    
    [pView bind: @"textColor" toObject:self withKeyPath:@"textColor" options:nil];
    
    [pView bind: @"textSize" toObject:self withKeyPath:@"textSize" options:nil];
    
    [pView bind: @"textAlign" toObject:self withKeyPath:@"textAlign" options:nil];
    
    [pView bind: @"textFontIndex" toObject:self withKeyPath:@"textFontIndex" options:nil];
    
    [pView bind: @"textBold" toObject:self withKeyPath:@"textBold" options:nil];
    
    [pView bind: @"textItalic" toObject:self withKeyPath:@"textItalic" options:nil];
    
    [pView bind: @"textUnderline" toObject:self withKeyPath:@"textUnderline" options:nil];
    
    [pView setBook:self];
	
	NSRect r = [pView frame];
	NSSize cr = [main_ScroolView contentSize];
	[main_ScroolView setPostsFrameChangedNotifications:TRUE];
	int margin = 40;
	r.size.width=(cr.width>r.size.width+margin)? cr.width:r.size.width+margin;
	r.size.height=(cr.height>r.size.height+margin)? cr.height:r.size.height+margin;
	PMCPageContainer * p = [[PMCPageContainer alloc] initWithFrame:r];
	[p setMargin:margin];
	[p setContentView:pView];
    [pView release];
	[p setNeedsDisplay:TRUE];
	[p apply];
	[p changeContent];
	[main_ScroolView setDocumentView:p];
    [p release];
    /**/
	//[main_ScroolView setDocumentView:_actualPage];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitViewWillResizeSubviews:) name:NSSplitViewWillResizeSubviewsNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitViewDidResizeSubviews:) name:NSSplitViewDidResizeSubviewsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:main_ScroolView];
	
	//[self setInspectorForObject:@"doc"];
	
	//NSLog(@"Main Scrool View (contentView) : %@",[main_ScroolView contentView]);
	
	[ol_ObjectTableView registerForDraggedTypes:[NSArray arrayWithObject:@"PMCObjectType"]];
	[ol_ObjectTableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
	
	
}

-(void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context 
{ 
	if([object isEqualTo:pagesArrayController] && [keyPath isEqual:@"selectionIndex"]){
		NSLog(@"Changement de _actualPage");
		[_actualPage release];
		_actualPage=[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] retain];
	}
	
	if([keyPath isEqual:@"content.page_format"]){ 
		NSLog(@"New value page_format : %i",[ [object valueForKeyPath:@"content.page_format"] intValue]); 
		//NSLog(@"New temperature in Celsius : %f",[[[object content] valueForKey:@"temperature"] floatValue]); 
		
	}
	if([keyPath isEqual:@"content.page_orientation"]){ 
		NSLog(@"New value page_orientation : %i",[ [object valueForKeyPath:@"content.page_orientation"] intValue]); 
		//NSLog(@"New temperature in Celsius : %f",[[[object content] valueForKey:@"temperature"] floatValue]); 
		
	}
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
	
	NSMutableDictionary * dico = [[NSMutableDictionary alloc] init];
	[dico setObject:[NSNumber numberWithInt:_format] forKey:@"DocFormatPage"];
	[dico setObject:[NSNumber numberWithInt:_orientation] forKey:@"DocOrientation"];
	[dico setObject:[NSNumber numberWithInt:_alignPagination] forKey:@"DocAlignPagination"];
	[dico setObject:[NSNumber numberWithInt:_xPagination] forKey:@"DocXPagination"];
	[dico setObject:[NSNumber numberWithInt:_yPagination] forKey:@"DocYPagination"];
	[dico setObject:[NSNumber numberWithInt:_fontIndexPagination] forKey:@"DocFontIndexPagination"];
	[dico setObject:[NSNumber numberWithInt:_fontSizePagination] forKey:@"DocFontSizePagination"];
	[dico setObject:[NSNumber numberWithBool:_firstPage] forKey:@"DocFirstPageActive"];
	[dico setObject:[NSNumber numberWithBool:_otherPage] forKey:@"DocOtherPageActive"];
	[dico setObject:[NSNumber numberWithBool:_lastPage] forKey:@"DocLastPageActive"];
	[dico setObject:[NSNumber numberWithBool:_enabledPagination] forKey:@"DocEnablePagination"];
	[dico setObject:[NSNumber numberWithBool:_boldFontPagination] forKey:@"DocBoldFontPagination"];
	[dico setObject:[NSNumber numberWithBool:_italicFontPagination] forKey:@"DocItalicFontPagination"];
	[dico setObject:[NSNumber numberWithBool:_underlineFontPagination] forKey:@"DocUnderlineFontPagination"];
	[dico setObject:_formatPagination forKey:@"DocFormatPagination"];
	[dico setObject:_title forKey:@"DocTitle"];
	[dico setObject:_author forKey:@"DocAuthor"];
	[dico setObject:_description forKey:@"DocDescription"];
	[dico setObject:_colorFontPagination forKey:@"DocColorFontPagination"];
	
	
	NSMutableDictionary * ar = [[[NSMutableDictionary alloc] init] autorelease];
	
	int i;
	int max=[pages count];
	
	for(i=0;i<max;i++){
		[ar setObject:[[pages objectAtIndex:i] getDataForSave] forKey:[NSString stringWithFormat:@"Page%d",i+1]];
	}
	
	[ar setObject:dico forKey:@"InfosDocs"];
    [dico release];
	
	[[self windowForSheet] setDocumentEdited:FALSE];
	
	return [NSArchiver archivedDataWithRootObject:ar];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
	NSLog(@"Ouverture d'un fichier : %@",typeName);
	
	if(![typeName isEqualToString:@"XML Print Model Source"]) return NO;
	
	NSDictionary * doc = [NSUnarchiver unarchiveObjectWithData:data];
	
	NSDictionary * dico = [doc objectForKey:@"InfosDocs"];
	
	_format= [[dico objectForKey:@"DocFormatPage"] intValue];
	_orientation= [[dico objectForKey:@"DocOrientation"] intValue];
	_alignPagination= [[dico objectForKey:@"DocAlignPagination"] intValue];
	_xPagination= [[dico objectForKey:@"DocXPagination"] intValue];
	_yPagination= [[dico objectForKey:@"DocYPagination"] intValue];
	_fontIndexPagination= [[dico objectForKey:@"DocFontIndexPagination"] intValue];
	_fontSizePagination= [[dico objectForKey:@"DocFontSizePagination"] intValue];
	_firstPage= [[dico objectForKey:@"DocFirstPageActive"] boolValue];
	_otherPage= [[dico objectForKey:@"DocOtherPageActive"] boolValue];
	_lastPage= [[dico objectForKey:@"DocLastPageActive"] boolValue];
	_enabledPagination= [[dico objectForKey:@"DocEnablePagination"] boolValue];
	_boldFontPagination= [[dico objectForKey:@"DocBoldFontPagination"] boolValue];
	_italicFontPagination= [[dico objectForKey:@"DocItalicFontPagination"] boolValue];
	_underlineFontPagination= [[dico objectForKey:@"DocUnderlineFontPagination"] boolValue];
	_formatPagination= [[dico objectForKey:@"DocFormatPagination"] copy];
	if([dico objectForKey:@"DocTitle"]) _title= [[dico objectForKey:@"DocTitle"] copy];
    else _title=@"";
	if([dico objectForKey:@"DocAuthor"]) _author= [[dico objectForKey:@"DocAuthor"] copy];
    else _title=@"";
	if([dico objectForKey:@"DocDescription"]) _description= [[dico objectForKey:@"DocDescription"] copy];
    else _title=@"";
	_colorFontPagination= [[dico objectForKey:@"DocColorFontPagination"] copy];
	
	
	/*
	 = [[dico objectForKey:@""] boolValue];
	 = [[dico objectForKey:@""] intValue];
	 = [[dico objectForKey:@""] floatValue];
	 = [dico objectForKey:@""];
	 */
	
	
	NSArray * ar = [doc objectForKey:@"Page1"];
	int max=[ar count]-1;
	int i;
	id obj;
	
	//Récupère la page 1
	PMCPage * _page1 = [pages objectAtIndex:0];
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		//NSLog(@"Object number : %i : ClassName : %@", i, [obj objectForKey:@"ObjectClassName"]);
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"]){
			PMCTrait * t = [[PMCTrait alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page1 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			[r setUndoManager:[self undoManager]];
			[_page1 addObject:r atPlan:0];
            [r release];
			//NSLog(@"Obj '%@' add in page : '%@'",[r name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"]){
			PMCText * t = [[PMCText alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page1 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"]){
			PMCTableau * t = [[PMCTableau alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page1 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCPicture"]){
			PMCPicture * t = [[PMCPicture alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page1 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		
		/*
		*/
	}
	
	//NSLog(@"count : %i",[_page1 objCount]);
	
	ar = [doc objectForKey:@"Page2"];
	max=[ar count]-1;
	
	//Récupère la page 2
	PMCPage * _page2 = [pages objectAtIndex:1];
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"]){
			PMCTrait * t = [[PMCTrait alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page2 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			[r setUndoManager:[self undoManager]];
			[_page2 addObject:r atPlan:0];
            [r release];
			//NSLog(@"Obj '%@' add in page : '%@'",[r name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"]){
			PMCText * t = [[PMCText alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page2 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"]){
			PMCTableau * t = [[PMCTableau alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page2 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCPicture"]){
			PMCPicture * t = [[PMCPicture alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page2 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
	}
	
	
	ar = [doc objectForKey:@"Page3"];
	max=[ar count]-1;
	
	//Récupère la page 3
	PMCPage * _page3 = [pages objectAtIndex:2];
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"]){
			PMCTrait * t = [[PMCTrait alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page3 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			[r setUndoManager:[self undoManager]];
			[_page3 addObject:r atPlan:0];
            [r release];
			//NSLog(@"Obj '%@' add in page : '%@'",[r name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"]){
			PMCText * t = [[PMCText alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page3 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"]){
			PMCTableau * t = [[PMCTableau alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page3 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCPicture"]){
			PMCPicture * t = [[PMCPicture alloc] initWithData:obj];
			[t setUndoManager:[self undoManager]];
			[_page3 addObject:t atPlan:0];
            [t release];
			//NSLog(@"Obj '%@' add in page : '%@'",[t name],[_page1 title]);
		}
	}
	
	[[self undoManager] removeAllActions];
	//[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(unselectObjet) userInfo:nil repeats:NO];
	//if([[figuresArrayController arrangedObjects] count]>2) [figuresArrayController setSelectionIndex:1];
	//[figuresArrayController removeSelectionIndexes:[figuresArrayController selectionIndexes]];
	
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}
	
- (void)unselectObjet:(NSTimer*)theTimer{
	NSLog(@"unselectObjet:");
	[figuresArrayController removeSelectionIndexes:[figuresArrayController selectionIndexes]];
	
}

#pragma mark -
#pragma mark TOOLBAR
/*************************************/
/*              TOOLBAR              */
/*************************************/

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
	 itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ( [itemIdentifier isEqualToString:@"orderUpTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderUpTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderUp"]];
		[item setTarget:self];
		[item setAction:@selector(tool_orderUpSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDoubleUpTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDoubleUpTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDoubleUp"]];
		[item setTarget:self];
		[item setAction:@selector(tool_orderDoubleUpSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDownTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDownTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDown"]];
		[item setTarget:self];
		[item setAction:@selector(tool_orderDownSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDoubleDownTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDoubleDownTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDoubleDown"]];
		[item setTarget:self];
		[item setAction:@selector(tool_orderDoubleDownSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"arrayTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"arrayTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OutilTableau"]];
		[item setTarget:self];
		[item setAction:@selector(tool_NewArray:)];
    } else if ( [itemIdentifier isEqualToString:@"deleteTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"deleteTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Delete"]];
		[item setTarget:self];
		[item setAction:@selector(tool_deleteSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"textTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"textTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OutilTexte"]];
		[item setTarget:self];
		[item setAction:@selector(tool_NewText:)];
    } else if ( [itemIdentifier isEqualToString:@"rectTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"rectTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OutilRectangle"]];
		[item setTarget:self];
		[item setAction:@selector(tool_NewRect:)];
    } else if ( [itemIdentifier isEqualToString:@"lineTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"lineTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OutilTrait"]];
		[item setTarget:self];
		[item setAction:@selector(tool_NewLine:)];
    } else if ( [itemIdentifier isEqualToString:@"imageTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"imageTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OutilPicture"]];
		[item setTarget:self];
		[item setAction:@selector(tool_NewPicture:)];
    } else if ( [itemIdentifier isEqualToString:@"zoomSelector"] ) {
		NSRect fRect = [tool_ZoomView frame];
		
		[item setLabel:NSLocalizedStringFromTable(@"zoomSelectorTitle",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setView:tool_ZoomView];
		[item setMinSize:fRect.size];
		[item setMaxSize:fRect.size];
    } else if ( [itemIdentifier isEqualToString:@"pagesSelector"] ) {
		NSRect fRect = [tool_PagesView frame];
		
		[item setLabel:NSLocalizedStringFromTable(@"pagesSelectorTitle",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setView:tool_PagesView];
		[item setMinSize:fRect.size];
		[item setMaxSize:fRect.size];
    }/* else if ( [itemIdentifier isEqualToString:@"ProgrammerDeviceItem"] ) {
		NSRect fRect = [tool_ProgrammerView frame];
		
		[item setLabel:NSLocalizedStringFromTable(@"programmerDevice",@"Localizable",@"Tools")];
		[item setPaletteLabel:[item label]];
		[item setView:tool_ProgrammerView];
		[item setMinSize:fRect.size];
		[item setMaxSize:fRect.size];
    }*/
    return [item autorelease];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
			NSToolbarSpaceItemIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier,
			NSToolbarCustomizeToolbarItemIdentifier,
			NSToolbarPrintItemIdentifier,
			@"zoomSelector",@"pagesSelector", @"lineTool", @"rectTool", @"textTool", @"arrayTool", @"imageTool", @"deleteTool", @"orderUpTool", @"orderDoubleUpTool", @"orderDownTool", @"orderDoubleDownTool", nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:@"lineTool", @"rectTool", @"textTool", @"arrayTool", @"imageTool", NSToolbarFlexibleSpaceItemIdentifier,@"pagesSelector", NSToolbarFlexibleSpaceItemIdentifier, @"deleteTool", NSToolbarSeparatorItemIdentifier, @"orderDoubleUpTool", @"orderUpTool", @"orderDownTool", @"orderDoubleDownTool", NSToolbarFlexibleSpaceItemIdentifier,
			@"zoomSelector", nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	//NSLog(@"validateToolbarItem : %@ - PicSelected : %@",[theItem itemIdentifier],(([[HexPicController sharedInstance] deviceIsSelected])? @"YES":@"NO"));
    
    //if ([[theItem itemIdentifier] isEqualToString:@"deleteTool"]) return ([_actualPage getSelectedObjectIndex]>-1);
	
	int nbSelectedObj = [[figuresArrayController selectionIndexes] count];
	int selectedObj = [figuresArrayController selectionIndex];
	int maxObj = [[figuresArrayController arrangedObjects] count];
	
	
	if ([[theItem itemIdentifier] isEqualToString:@"deleteTool"]) return [figuresArrayController canRemove];
	if ([[theItem itemIdentifier] isEqualToString:@"orderUpTool"]) return (nbSelectedObj==1 && selectedObj>0 && selectedObj<maxObj);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDoubleUpTool"]) return (nbSelectedObj==1 && selectedObj>0 && selectedObj<maxObj);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDownTool"]) return (nbSelectedObj==1 && selectedObj>-1 && selectedObj<maxObj-1);
	if ([[theItem itemIdentifier] isEqualToString:@"orderDoubleDownTool"]) return (nbSelectedObj==1 && selectedObj>-1 && selectedObj<maxObj-1);
	
	
	return YES;
	
	//return NO;
}

#pragma mark -
#pragma mark DataSources
/*************************************/
/*            DataSources            */
/*************************************/

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation{
	//NSLog(@"validateDrop:%@ proposedRow:%i proposedDropOperation:%i",info,row,operation);
	if(aTableView==ol_ObjectTableView){
		
		if (operation == NSTableViewDropOn) {
			[aTableView setDropRow:row dropOperation:NSTableViewDropOn];
			
			return NSDragOperationNone;
		}else if (operation == NSTableViewDropAbove) {//NSTableViewDropAbove
			[aTableView setDropRow:row dropOperation:NSTableViewDropAbove];
			return NSDragOperationMove;
		}
	}
    
    return NSDragOperationNone;
}
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation{
	if(aTableView==ol_ObjectTableView){
		int indexObject = [[[info draggingPasteboard] stringForType:@"PMCObjectType"] intValue];
		//NSLog(@"acceptDrop:%i row:%i dropOperation:%i",indexObject ,row,operation);
		if(operation==NSTableViewDropAbove){
			NSLog(@"Move Row : %i to %ld",indexObject , row);
			int finalDest=0;
			if(indexObject==row) return FALSE; //annule le déplacement si la source et la destintation sont égale
			if(indexObject>row || row==0)finalDest=row;
			else finalDest=row-1;
			id obj = [[_actualPage getObjectAtIndex:indexObject] retain];
			NSLog(@"retain count : %lu",[obj retainCount]);
			[_actualPage deleteObjectAtIndex:indexObject];
			[_actualPage addObject:obj atPlan:finalDest];
			[obj release];
			
			return TRUE;
		}
		return FALSE;
	}
	
	return FALSE;
}
- (NSArray *)tableView:(NSTableView *)aTableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet{
	NSLog(@"namesOfPromisedFilesDroppedAtDestination:%@",dropDestination);
	if(aTableView==ol_ObjectTableView){
		return [NSArray arrayWithObject:@"PMCObjectType"];
	}
	
	return nil;
}
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard{
	//NSLog(@"writeRowsWithIndexes:%@",rowIndexes);
	if(aTableView==ol_ObjectTableView){
		[pboard declareTypes:[NSArray arrayWithObjects:@"PMCObjectType",nil] owner:self];
		[pboard setString:[NSString stringWithFormat:@"%lu",[rowIndexes firstIndex]] forType:@"PMCObjectType"];
		return TRUE;
	}
	
	return FALSE;
}

#pragma mark -
#pragma mark Other

- (void)writeSelectedObjectToPasteboard:(NSPasteboard*)pb{
	[pb declareTypes:[NSArray arrayWithObject:@"PMCObject"] owner:self];
	[pb setData:[NSArchiver archivedDataWithRootObject:[[[figuresArrayController arrangedObjects] objectAtIndex:[figuresArrayController selectionIndex]] getDataForSave]] forType:@"PMCObject"];
}

- (BOOL)readObjectFromPasteboard:(NSPasteboard*)pb{
	NSString * type;
	
	type = [pb availableTypeFromArray:[NSArray arrayWithObject:@"PMCObject"]];
	
	if(type){
		id obj = [NSUnarchiver unarchiveObjectWithData:[pb dataForType:@"PMCObject"]];
		
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"]){
			PMCTrait * t = [[PMCTrait alloc] initWithData:obj];
            [[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:t atPlan:0];
            [t release];
        }
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			//NSLog(@"Description : %@",r);
			[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:r atPlan:0];
            [r release];
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"]){
            PMCText * t=[[PMCText alloc] initWithData:obj];
			[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:t atPlan:0];
            [t release];
        }
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"]){
            PMCTableau * t = [[PMCTableau alloc] initWithData:obj];
			[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:t atPlan:0];
            [t release];
        }
		return TRUE;
	}
	
	
	
	return FALSE;
}

#pragma mark -
#pragma mark Notification

- (void)viewFrameChanged:(NSNotification *)aNotification{
	//NSLog(@"viewFrameChanged : %@ !",aNotification);
	PMCPageContainer * p = [main_ScroolView documentView];
	[p apply];
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification{
	//NSLog(@"splitViewDidResizeSubviews:");
	//PMCPageContainer * p = [main_ScroolView documentView];
	//[p setContentView:_actualPage];
	//[p setNeedsDisplay:TRUE];
	//[p apply];
}

- (void)splitViewWillResizeSubviews:(NSNotification *)aNotification{
	//NSLog(@"splitViewWillResizeSubviews:");
	//[main_SplitVertical adjustSubviews];
}

- (CGFloat)splitView:(NSSplitView *)sender constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)offset{
	NSLog(@"---- position : %f ; subview at : %li", proposedPosition, offset);
	/*
	if(sender==main_SplitVertical){
		//NSLog(@"new position : %f ; subview at : %i", proposedPosition, offset);
		if(proposedPosition<217) return 217.0;
		if(proposedPosition>300) return 300.0;
	}
	*/
	return proposedPosition;
}

- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedCoord ofSubviewAt:(NSInteger)offset
{
	NSLog(@"constrainMinCoordinate %li %f", offset, proposedCoord);
    if(sender==main_SplitVertical){
        if (offset == 0){ //premier split
            NSLog(@"217");
            return 217.;
        }
	}
    NSLog(@"proposed");
	return proposedCoord;
}

// ---------------------------------------------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedCoord ofSubviewAt:(NSInteger)offset
{
    NSLog(@"constrainMaxCoordinate %li %f", offset, proposedCoord);

	if(sender==main_SplitVertical){
		if (offset == 0){ //premier split
            NSLog(@"300");
            [sender setNeedsDisplay:true];
			return 300.;
		}
	}
    NSLog(@"proposed");
	return proposedCoord;
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize{
    NSLog(@"resize...");
    
    [main_SplitVertical adjustSubviews];
    return frameSize;
}


#pragma mark -
#pragma mark Setter Getter

- (NSRect)frameWidthFormatAndOrientation{
	NSRect rect;
	if(_orientation==0) rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]);
	else rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]);
	
	return rect;
}

- (void)setTitle:(NSString*)val{
	if(_title==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFormatPagination:_title];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMDocTitle",@"Localizable",@"Undo Manager Action")];
	}
	[_title release];
	_title=[val retain];
	
}


- (void)setAuthor:(NSString *)val{
	if(_author==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFormatPagination:_author];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMDocAuthor",@"Localizable",@"Undo Manager Action")];
	}
	[_author release];
	_author=[val retain];
	
}


- (void)setDescription:(NSString*)val{
	if(_description==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFormatPagination:_description];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMDocDescription",@"Localizable",@"Undo Manager Action")];
	}
	[_description release];
	_description=[val retain];
	
}

- (void)setFirstPage:(BOOL)val{
	if(_firstPage==val) return;
	
	//[self willChangeValueForKey:@"firstPage"];
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFirstPage:_firstPage];
	if(![undo isUndoing]){
		//if [undo setActionName:@"enable first page"];NSLocalizedStringFromTable(@"NArray",@"Localizable",@"Undo Manager Action")
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMEnable":@"UMDisable"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMFistPage",@"Localizable",@"Undo Manager Action")]];
	}
	_firstPage=val;
	
	//[self didChangeValueForKey:@"firstPage"];
	
}


- (void)setOtherPage:(BOOL)val{
	if(_otherPage==val) return;
	
	//[self willChangeValueForKey:@"otherPage"];
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setOtherPage:_otherPage];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMEnable":@"UMDisable"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMOtherPage",@"Localizable",@"Undo Manager Action")]];
	}
	_otherPage=val;
	
	//[self didChangeValueForKey:@"otherPage"];
	
}


- (void)setLastPage:(BOOL)val{
	if(_lastPage==val) return;
	
	//[self willChangeValueForKey:@"lastPage"];
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setLastPage:_lastPage];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMEnable":@"UMDisable"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMLastPage",@"Localizable",@"Undo Manager Action")]];
	}
	_lastPage=val;
	
	//[self didChangeValueForKey:@"lastPage"];
	
}

- (void)setPageFormat:(int)val{
	if(_format==val) return;
	
	//[self willChangeValueForKey:@"pageFormat"];
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPageFormat:_format];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMChangePageFormat",@"Localizable",@"Undo Manager Action")];
	}
	_format=val;
}

- (void)setPageOrientation:(int)val{
	if(_orientation==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPageOrientation:_orientation];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMChangePageOrientation",@"Localizable",@"Undo Manager Action")];
	}
	_orientation=val;
}

- (void)setEnabledPagination:(BOOL)val{
	if(_enabledPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setEnabledPagination:_enabledPagination];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMEnable":@"UMDisable"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMPagination",@"Localizable",@"Undo Manager Action")]];
	}
	_enabledPagination=val;
	//NSLocalizedStringFromTable(@"UM",@"Localizable",@"Undo Manager Action")
	
}

- (void)setFormatPagination:(NSString*)val{
	if(_formatPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFormatPagination:_formatPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationFormat",@"Localizable",@"Undo Manager Action")];
	}
	[_formatPagination release];
	_formatPagination=[val retain];
	
}

- (void)setPaginationPositionX:(int)val{
	if(_xPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationPositionX:_xPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationPosition",@"Localizable",@"Undo Manager Action")];
	}
	_xPagination=val;
}

- (void)setPaginationPositionY:(int)val{
	if(_yPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationPositionY:_yPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationPosition",@"Localizable",@"Undo Manager Action")];
	}
	_yPagination=val;
}

- (void)setTextFontIndex:(int)val{
	if(_fontIndexPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextFontIndex:_fontIndexPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationFont",@"Localizable",@"Undo Manager Action")];
	}
	_fontIndexPagination=val;
}

- (void)setTextSize:(int)val{
	if(_fontSizePagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextSize:_fontSizePagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationSize",@"Localizable",@"Undo Manager Action")];
	}
	_fontSizePagination=val;
}


- (void)setTextColor:(NSColor*)val{
	if([_colorFontPagination isEqual:val]) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextColor:_colorFontPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationColor",@"Localizable",@"Undo Manager Action")];
	}
	_colorFontPagination=val;
}


- (void)setTextBold:(BOOL)val{
	if(_boldFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextBold:_boldFontPagination];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMSet":@"UMUset"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMPaginationBold",@"Localizable",@"Undo Manager Action")]];
	}
	_boldFontPagination=val;
}

- (void)setTextItalic:(BOOL)val{
	if(_italicFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextItalic:_italicFontPagination];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMSet":@"UMUset"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMPaginationItalic",@"Localizable",@"Undo Manager Action")]];
	}
	_italicFontPagination=val;
}

- (void)setTextUnderline:(BOOL)val{
	if(_underlineFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextUnderline:_underlineFontPagination];
	if(![undo isUndoing]){
		[undo setActionName:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(((!_firstPage)? @"UMSet":@"UMUset"),@"Localizable",@"Undo Manager Action"),NSLocalizedStringFromTable(@"UMPaginationUnderline",@"Localizable",@"Undo Manager Action")]];
	}
	_underlineFontPagination=val;
}


- (void)setTextAlign:(int)val{
	if(_alignPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setTextAlign:_alignPagination];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMPaginationAlign",@"Localizable",@"Undo Manager Action")];
	}
	_alignPagination=val;
}
#pragma mark -
#pragma mark Moving
- (void)moveUp:(id)sender{
	NSLog(@"Move Up !!");

}


#pragma mark -
#pragma mark IBAction
/*************************************/
/*              IBACTION             */
/*************************************/
- (IBAction)cut:(id)sender
{
	if([[figuresArrayController selectionIndexes] count]>0){
		[self copy:sender];
		[self tool_deleteSelectedObject:sender];
	}
}

- (IBAction)copy:(id)sender
{
	if([[figuresArrayController selectionIndexes] count]>0){
		NSPasteboard * pb = [NSPasteboard generalPasteboard];
		[self writeSelectedObjectToPasteboard:pb];
	}
}

- (IBAction)paste:(id)sender
{
	NSPasteboard * pb = [NSPasteboard generalPasteboard];
	if(![self readObjectFromPasteboard:pb]) NSBeep();
	else{
	}
}

- (IBAction)delete:(id)sender{
	if([[figuresArrayController selectionIndexes] count]>0){
		//[_actualPage deleteSelectedObject:sender];
	}
}

- (IBAction)tool_ZoomChange:(id)sender
{
	if([sender indexOfSelectedItem]==0){
		[[main_ScroolView documentView] setZoom:0.25];
	}else if([sender indexOfSelectedItem]==1){
		[[main_ScroolView documentView] setZoom:0.5];
	}else if([sender indexOfSelectedItem]==2){
		[[main_ScroolView documentView] setZoom:0.75];
	}else if([sender indexOfSelectedItem]==3){
		[[main_ScroolView documentView] setZoom:1.0];
	}else if([sender indexOfSelectedItem]==4){
		[[main_ScroolView documentView] setZoom:1.5];
	}else if([sender indexOfSelectedItem]==5){
		[[main_ScroolView documentView] setZoom:2.0];
	}else if([sender indexOfSelectedItem]==6){
		[[main_ScroolView documentView] setZoom:2.5];
	}else if([sender indexOfSelectedItem]==7){
		[[main_ScroolView documentView] setZoom:3.0];
	}
	
	
}

- (IBAction)tool_NewLine:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"%@ %@ %i", NSLocalizedStringFromTable(@"OBJNew",@"Localizable",@"Objects"),NSLocalizedStringFromTable(@"PMCTrait",@"Localizable",@"Objects"), [_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	//[NSString stringWithFormat:]
	PMCTrait * nl = [[PMCTrait alloc] initWithName:name];
    [name release];
	[nl setSizeAndPosition:NSMakeRect(100, 100, 150, 10)];
	[nl setUndoManager:[self undoManager]];
	
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:nl atPlan:0];
	[nl release];
	//[_actualPage addObject:nl atPlan:0];
	//[_actualPage reDraw];
	//[ol_ObjectTableView reloadData];
	//[[self windowForSheet] setDocumentEdited:TRUE];
	
}

- (IBAction)tool_NewRect:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"%@ %@ %i", NSLocalizedStringFromTable(@"OBJNew",@"Localizable",@"Objects"),NSLocalizedStringFromTable(@"PMCRectangle",@"Localizable",@"Objects"), [_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCRectangle * nl = [[PMCRectangle alloc] initWithName:name];
    [name release];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 150, 50)];
	[nl setUndoManager:[self undoManager]];
	NSLog(@"New Object [%@] : %@", [nl className], nl);
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:nl atPlan:0];
	[nl release];
    //[_actualPage reDraw];
	//[ol_ObjectTableView reloadData];
	//[[self windowForSheet] setDocumentEdited:TRUE];
}

- (IBAction)tool_NewText:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"%@ %@ %i", NSLocalizedStringFromTable(@"OBJNew",@"Localizable",@"Objects"),NSLocalizedStringFromTable(@"PMCText",@"Localizable",@"Objects"), [_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCText * nl = [[PMCText alloc] initWithName:name];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 150, 50)];
	[nl setContent:name];
    [name release];
	[nl setTextFontIndex:1];
	[nl setTextSize:12];
	[nl setUndoManager:[self undoManager]];
	
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:nl atPlan:0];
	[nl release];
    //[_actualPage reDraw];
	//[ol_ObjectTableView reloadData];
	//[[self windowForSheet] setDocumentEdited:TRUE];
}


- (IBAction)tool_NewArray:(id)sender{
	NSString *name = [[NSString alloc] initWithFormat:@"%@ %@ %i", NSLocalizedStringFromTable(@"OBJNew",@"Localizable",@"Objects"),NSLocalizedStringFromTable(@"PMCTableau",@"Localizable",@"Objects"), [_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCTableau * nl = [[PMCTableau alloc] initWithName:name];
    [name release];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 300, 150)];
	[nl setUndoManager:[self undoManager]];
	
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:nl atPlan:0];
	[nl release];
    //[_actualPage reDraw];
	//[ol_ObjectTableView reloadData];
	//[[self windowForSheet] setDocumentEdited:TRUE];
}

- (IBAction)tool_NewPicture:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"%@ %@ %i", NSLocalizedStringFromTable(@"OBJNew",@"Localizable",@"Objects"),NSLocalizedStringFromTable(@"PMCPicture",@"Localizable",@"Objects"), [_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCPicture * nl = [[PMCPicture alloc] initWithName:name];
    [name release];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 50, 50)];
	[nl setUndoManager:[self undoManager]];
	NSLog(@"New Object [%@] : %@", [nl className], nl);
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] addObject:nl atPlan:0];
	[nl release];
}


- (IBAction)tool_deleteSelectedObject:(id)sender{
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] deleteObjectAtIndex:[figuresArrayController selectionIndex]];
}

- (IBAction)tool_orderUpSelectedObject:(id)sender{
	int oldPlace = [figuresArrayController selectionIndex];
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] placeObjectAtPlan:oldPlace toPlan:oldPlace-1];
}

- (IBAction)tool_orderDoubleUpSelectedObject:(id)sender{
	int oldPlace = [figuresArrayController selectionIndex];
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] placeObjectAtPlan:oldPlace toPlan:0];
}

- (IBAction)tool_orderDownSelectedObject:(id)sender{
	int oldPlace = [figuresArrayController selectionIndex];
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] placeObjectAtPlan:oldPlace toPlan:oldPlace+1];
}

- (IBAction)tool_orderDoubleDownSelectedObject:(id)sender{
	int oldPlace = [figuresArrayController selectionIndex];
	[[[pagesArrayController arrangedObjects] objectAtIndex:[pagesArrayController selectionIndex]] placeObjectAtPlan:oldPlace toPlan:[[figuresArrayController arrangedObjects] count]-1];
}

#pragma mark -
#pragma mark Export

- (IBAction)exportToPicture:(id)sender{
	NSSavePanel * sp = [NSSavePanel savePanel];
	[sp setCanCreateDirectories:YES];
	[sp setCanSelectHiddenExtension:YES];
	[sp setAllowsOtherFileTypes:NO];
	[sp setTitle:NSLocalizedStringFromTable(@"EXPictureTitle",@"Localizable",@"Export")];
	[sp setPrompt:NSLocalizedStringFromTable(@"EXPictureButton",@"Localizable",@"Export")];
	[sp setNameFieldLabel:NSLocalizedStringFromTable(@"EXPictureTo",@"Localizable",@"Export")];
	[sp setAccessoryView:export_exportExtentionSelector];
    [sp setDirectoryURL:[NSURL URLWithString:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]]];
	_exportSavePanel=sp;
	NSArray * a = [[NSArray alloc] initWithObjects:@"pdf", @"jpg", @"png", @"tif", @"gif", @"bmp", nil];
	[sp setAllowedFileTypes:a];
	[export_formatMenu removeAllItems];
	//NSString * obj;
	for(NSString * obj in a) {
		[export_formatMenu addItemWithTitle:[obj uppercaseString]];
        [obj release];
	}
	[a release];
	
	//NSString * proposedName = [[[[[self fileURL] absoluteString] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"pdf"];
	
	
	//Nouvelle méhode ajouté le 30/07/2010
	NSString * nname = [[[self displayName] stringByDeletingPathExtension] stringByAppendingPathExtension:@"pdf"];
	NSMutableString * proposedName;
	CFMutableStringRef corestr;
	
	// lecture
	proposedName=[[NSMutableString alloc] initWithString:nname];
	
	// cast du NSString* en CFStringRef (magie du tool-free-bridging)
	corestr=(CFMutableStringRef)proposedName;
	
	// converstion de la chaîne de départ  en canonical-unicode
	// (ça permet de séparer les composants diacritiques des caractères de base)
	CFStringNormalize(corestr, kCFStringNormalizationFormD);
	
	// application d'une règle ICU à la chaine canonisée: cette règle enlève les signes diacritiques
	CFStringTransform(corestr, NULL, kCFStringTransformStripCombiningMarks, false);
	
	// maintenant tous les caractères accentués sont devenus non-accentués.
	//NSLog(@"%@", cocoaStr);
	
	NSRange r;
	r.location=0;
	r.length=[proposedName length];
	[proposedName replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:r];
	// fin nouvelle methode
	[sp setNameFieldStringValue:proposedName];
	[proposedName release];
    
	if([sp runModal]!=NSOKButton){
        return;
    }
    
	NSString * nameFile = [[[sp URL] absoluteString] lastPathComponent];
	NSString * extFile = [nameFile pathExtension];
	if([export_mode selectedRow]==0){
		
		for(int i=0;i<3;i++){
			nameFile = [[[[[sp URL] absoluteString] stringByDeletingPathExtension] stringByAppendingFormat:@"-%d",i+1] stringByAppendingPathExtension:extFile];
			
			if(!([[figuresArrayController arrangedObjects] count]==0 && [export_noExportEmptyPage state]==NSOnState)){
				
				NSData * imageRep = [self dataImageForPage:i widthFormat:[export_formatMenu indexOfSelectedItem]];
				
				if(imageRep) [imageRep writeToURL:[NSURL URLWithString:nameFile] atomically:NO];
			}
		}
	}
	else{
		NSData * imageRep = [self dataImageForPage:[pagesArrayController selectionIndex] widthFormat:[export_formatMenu indexOfSelectedItem]];
		
		
		if(imageRep) [imageRep writeToURL:[NSURL URLWithString:nameFile] atomically:NO];
	}
	
}

- (NSData*)dataImageForPage:(int)pageIdx widthFormat:(int)intFormat{
	//Sauvegarde de la page en cours
	int selectedPage = [pagesArrayController selectionIndex];
	//Changement de page si la page demandé est différente de la page en cours
	if(pageIdx!=selectedPage) [pagesArrayController setSelectionIndex:pageIdx];
	//retrait de la sélection des objets
	//[figuresArrayController removeSelectionIndexes:[figuresArrayController selectionIndexes]];
	
	PMCPageView * p=[[[main_ScroolView documentView] subviews] objectAtIndex:0];
	NSImage * img = [[NSImage alloc] initWithData:[p dataWithEPSInsideRect:[p bounds]]];
	NSBitmapImageRep * rep1 = [[NSBitmapImageRep alloc] initWithData:[img TIFFRepresentation]];
	//NSBitmapImageRep * rep1 = [[img representations] objectAtIndex:0];
	
	NSData * imageRep;
	/*NSArray *representations;
	representations = [img representations];*/
	[img release];
	
	if(intFormat==0){
		imageRep = [[p dataWithPDFInsideRect:[p bounds]] retain];
	} else if(intFormat==1){
		imageRep = [[rep1 representationUsingType:NSJPEGFileType properties:nil] retain];
		//imageRep = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSJPEGFileType properties:nil];
	} else if(intFormat==2){
		imageRep = [[rep1 representationUsingType:NSPNGFileType properties:nil] retain];
		//imageRep = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSPNGFileType properties:nil];
	}else if(intFormat==3){
		imageRep = [[rep1 representationUsingType:NSTIFFFileType properties:nil] retain];
		//imageRep = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSTIFFFileType properties:nil];
	}else if(intFormat==4){
		imageRep = [[rep1 representationUsingType:NSGIFFileType properties:nil] retain];
		//imageRep = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSGIFFileType properties:nil];
	}else if(intFormat==5){
		imageRep = [[rep1 representationUsingType:NSBMPFileType properties:nil] retain];
		//imageRep = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSBMPFileType properties:nil];
	}else imageRep = [[NSData alloc] init];
	[imageRep autorelease];
    
    [rep1 release];
	//restauration de la page sélectionné !
	if(pageIdx!=selectedPage) [pagesArrayController setSelectionIndex:selectedPage];
	return imageRep;
	
}

- (IBAction)export_extensionsChange:(id)sender{
	//Change l'extension du fichier selon la sélection
	[_exportSavePanel setAllowedFileTypes:[NSArray arrayWithObject:[[sender title] lowercaseString]]];
}

- (IBAction)exportToModel:(id)sender{
	
	NSSavePanel * panel = [NSSavePanel savePanel];
	[panel setCanCreateDirectories:YES];
	[panel setTitle:NSLocalizedStringFromTable(@"EXModelTitle",@"Localizable",@"Export")];
	[panel setPrompt:NSLocalizedStringFromTable(@"EXModelButton",@"Localizable",@"Export")];
	[panel setNameFieldLabel:NSLocalizedStringFromTable(@"EXModelTo",@"Localizable",@"Export")];
	[panel setAllowedFileTypes:[NSArray arrayWithObject:@"xmlpm"]];
	[panel setCanSelectHiddenExtension:YES];
	NSArray * ar = [NSArray arrayWithObjects:@"xmlpm", nil];
	[panel setAllowedFileTypes:ar];
	//[panel setDirectory:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]];
	
	//Ancienne methode pour changer l'extension
	//NSString * proposedName = [[[[[self fileURL] absoluteString] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"xmlpm"];
	
	//Nouvelle méhode ajouté le 29/07/2010
	NSString * nname = [[[self displayName] stringByDeletingPathExtension] stringByAppendingPathExtension:@"xmlpm"];
	NSMutableString * proposedName;
	CFMutableStringRef corestr;
	
	// lecture
	proposedName=[[NSMutableString alloc] initWithString:nname];
	
	// cast du NSString* en CFStringRef (magie du tool-free-bridging)
	corestr=(CFMutableStringRef)proposedName;
	
	// converstion de la chaîne de départ  en canonical-unicode
	// (ça permet de séparer les composants diacritiques des caractères de base)
	CFStringNormalize(corestr, kCFStringNormalizationFormD);
	
	// application d'une règle ICU à la chaine canonisée: cette règle enlève les signes diacritiques
	CFStringTransform(corestr, NULL, kCFStringTransformStripCombiningMarks, false);
	
	// maintenant tous les caractères accentués sont devenus non-accentués.
	//NSLog(@"%@", cocoaStr);
	
	NSRange r;
	r.location=0;
	r.length=[proposedName length];
	[proposedName replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:r];
	
	[panel setNameFieldStringValue:proposedName];
    [panel setDirectoryURL:[NSURL URLWithString:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]]];
	
    [proposedName release];
	//[panel setMessage:@"Please select destination and name for export model :"];
	if([panel runModal]!=NSOKButton){
        return;
    }
    
	NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"xmlpm"];
	[root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.1"]];
    //set up generic XML doc data (<?xml version="1.0" encoding="UTF-8"?>)
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    [xmlDoc setVersion:@"1.0"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
	
	//Ajout des enfants pour le document
	NSXMLElement *marginNode = [NSXMLNode elementWithName:@"margin"];
	[root addChild:marginNode];
	[marginNode addAttribute:[NSXMLNode attributeWithName:@"Top" stringValue:@"20"]];
	[marginNode addAttribute:[NSXMLNode attributeWithName:@"Bottom" stringValue:@"20"]];
	[marginNode addAttribute:[NSXMLNode attributeWithName:@"Right" stringValue:@"20"]];
	[marginNode addAttribute:[NSXMLNode attributeWithName:@"Left" stringValue:@"20"]];
	
	NSXMLElement *orientationNode = [NSXMLNode elementWithName:@"orientation"];
	[root addChild:orientationNode];
	[orientationNode addAttribute:[NSXMLNode attributeWithName:@"mode" stringValue:((_orientation==1)? @"landscape":@"portrait")]];
	
	NSXMLElement *papierNode = [NSXMLNode elementWithName:@"papier"];
	[root addChild:papierNode];
	[papierNode addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:[[_pageFormat objectAtIndex:_format] objectForKey:@"name"]]];
	
	
	NSXMLElement *paginationNode = [NSXMLNode elementWithName:@"pagination"];
	[root addChild:paginationNode];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_enabledPagination)? @"1":@"0")]];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"format" stringValue:_formatPagination]];
	if(_alignPagination==0) [paginationNode addAttribute:[NSXMLNode attributeWithName:@"position" stringValue:@"left"]];
	else if(_alignPagination==1) [paginationNode addAttribute:[NSXMLNode attributeWithName:@"position" stringValue:@"center"]];
	else if(_alignPagination==2) [paginationNode addAttribute:[NSXMLNode attributeWithName:@"position" stringValue:@"right"]];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"x" stringValue:[NSString stringWithFormat:@"%i", _xPagination]]];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"y" stringValue:[NSString stringWithFormat:@"%i", _yPagination]]];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"taille" stringValue:[NSString stringWithFormat:@"%i", _fontSizePagination]]];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"police" stringValue:[_fontList objectAtIndex:_fontIndexPagination]]];
	if(![[_colorFontPagination colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) _colorFontPagination = [_colorFontPagination colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[paginationNode addAttribute:[NSXMLNode attributeWithName:@"couleurPolice" stringValue:[NSString stringWithFormat:@"%0.1f,%0.1f,%0.1f", [_colorFontPagination redComponent], [_colorFontPagination greenComponent], [_colorFontPagination blueComponent]]]];
	
	
	NSXMLElement *pagesNode = [NSXMLNode elementWithName:@"pages"];
	[root addChild:pagesNode];
	
	
	NSXMLElement *premiereNode = [NSXMLNode elementWithName:@"premiere"];
	[pagesNode addChild:premiereNode];
	[premiereNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_firstPage)? @"1":@"0")]];
	[(PMCPage*)[pages objectAtIndex:0] exportToModel:premiereNode];
	
	
	NSXMLElement *autreNode = [NSXMLNode elementWithName:@"autre"];
	[pagesNode addChild:autreNode];
	[autreNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_otherPage)? @"1":@"0")]];
	[(PMCPage*)[pages objectAtIndex:1] exportToModel:autreNode];
	
	
	NSXMLElement *derniereNode = [NSXMLNode elementWithName:@"derniere"];
	[pagesNode addChild:derniereNode];
	[derniereNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_lastPage)? @"1":@"0")]];
	[(PMCPage*)[pages objectAtIndex:2] exportToModel:derniereNode];
	
	
	NSData * data = [xmlDoc XMLDataWithOptions:NSXMLDocumentTidyXML];
    [xmlDoc release];
    
	[data writeToURL:[panel URL] atomically:YES];
	
	
	//NSLog(@"%@", [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
	
}

- (IBAction)exportToSVG:(id)sender{
    NSAlert * a = [NSAlert alertWithMessageText:NSLocalizedStringFromTable(@"EXSVGAlertTitle",@"Localizable",@"Export")  defaultButton:NSLocalizedStringFromTable(@"EXSVGAlertDefault",@"Localizable",@"Export") alternateButton:NSLocalizedStringFromTable(@"EXSVGAlertAlternate",@"Localizable",@"Export") otherButton:@"" informativeTextWithFormat:NSLocalizedStringFromTable(@"EXSVGAlertText",@"Localizable",@"Export")];
    if([a runModal]==NSAlertAlternateReturn){
        return;
    }
    
    NSSavePanel * panel = [NSSavePanel savePanel];
	[panel setCanCreateDirectories:YES];
	[panel setTitle:NSLocalizedStringFromTable(@"EXSVGTitle",@"Localizable",@"Export")];
	[panel setPrompt:NSLocalizedStringFromTable(@"EXSVGButton",@"Localizable",@"Export")];
	[panel setNameFieldLabel:NSLocalizedStringFromTable(@"EXSVGTo",@"Localizable",@"Export")];
	[panel setAllowedFileTypes:[NSArray arrayWithObject:@"svg"]];
	[panel setCanSelectHiddenExtension:YES];
	//[panel setDirectory:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]];
	
	//Ancienne methode pour changer l'extension
	//NSString * proposedName = [[[[[self fileURL] absoluteString] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"xmlpm"];
	
	//Nouvelle méhode ajouté le 29/07/2010
	NSString * nname = [[[self displayName] stringByDeletingPathExtension] stringByAppendingPathExtension:@"svg"];
	
	[panel setNameFieldStringValue:nname];
    [panel setDirectoryURL:[NSURL URLWithString:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]]];
    
	//[panel setMessage:@"Please select destination and name for export model :"];
	if([panel runModal]!=NSOKButton){
        return;
    }
    
	NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"svg"];
	[root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.0"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.w3.org/2000/svg"]];
    
    int width=[[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue];
    int height=[[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue];
	
	if(_orientation!=0){
        int att=width;
        width=height;
        height=att;
    }
    
	[root addAttribute:[NSXMLNode attributeWithName:@"width" stringValue:[NSString stringWithFormat:@"%ipx",width]]];
	[root addAttribute:[NSXMLNode attributeWithName:@"height" stringValue:[NSString stringWithFormat:@"%ipx",height]]];
    
    //set up generic XML doc data (<?xml version="1.0" encoding="UTF-8"?>)
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    [xmlDoc setVersion:@"1.0"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    [xmlDoc setStandalone:NO];
    
    NSXMLDTD *dtd = (NSXMLDTD*)[[NSXMLNode alloc] initWithKind:NSXMLDTDKind];
    [dtd setName:@"svg"];
    [dtd setPublicID:@"-//W3C//DTD SVG 20010904//EN"];
    [dtd setSystemID:@"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"];
    [xmlDoc setDTD:dtd];
    
    if(_description!=nil && ![_description isEqualToString:@""]){
        NSXMLElement *descNode = [NSXMLNode elementWithName:@"desc"];
        [root addChild:descNode];
        [descNode setStringValue:_description];
	}
    if(_title!=nil && ![_title isEqualToString:@""]){
        NSXMLElement *descNode = [NSXMLNode elementWithName:@"title"];
        [root addChild:descNode];
        [descNode setStringValue:_title];
	}
    NSXMLElement *metaNode = [NSXMLNode elementWithName:@"metadata"];
        [root addChild:metaNode];
        NSXMLElement *rdfNode = [NSXMLNode elementWithName:@"rdf:RDF"];
        //[rdfNode setNamespaces:[NSArray arrayWithObjects:@"rdf", nil]];
        [rdfNode addAttribute:[NSXMLNode attributeWithName:@"xmlns:rdf" stringValue:@"http://www.w3.org/1999/02/22-rdf-syntax-ns#"]];
        [rdfNode addAttribute:[NSXMLNode attributeWithName:@"xmlns:rdfs" stringValue:@"http://www.w3.org/2000/01/rdf-schema#"]];
        [rdfNode addAttribute:[NSXMLNode attributeWithName:@"xmlns:dc" stringValue:@"http://purl.org/dc/elements/1.1/"]];
        [metaNode addChild:rdfNode];
        
        
        NSXMLElement *descNode = [NSXMLNode elementWithName:@"rdf:Description"];
        //[descNode setNamespaces:[NSArray arrayWithObjects:@"rdf", nil]];
        [descNode addAttribute:[NSXMLNode attributeWithName:@"about" stringValue:@"http://jbnahan.fr/model"]];
        if(_author!=nil) [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:title" stringValue:_title]];
        if(_description!=nil) [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:description" stringValue:_description]];
        [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:publisher" stringValue:@"XML Print Model Creator"]];
        [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:date" stringValue:[[NSDate date] descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:[NSLocale currentLocale]]]];
        [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:format" stringValue:@"image/svg+xml"]];
        [descNode addAttribute:[NSXMLNode attributeWithName:@"dc:language" stringValue:@"en"]];
        [rdfNode addChild:descNode];
    if(_author!=nil && ![_author isEqualToString:@""]){
        NSXMLElement *dcNode = [NSXMLNode elementWithName:@"dc:creator"];
        [rdfNode addChild:dcNode];
        NSXMLElement *bagNode = [NSXMLNode elementWithName:@"rdf:Bag"];
        [dcNode addChild:bagNode];
        NSXMLElement *authorNode = [NSXMLNode elementWithName:@"rdf:li"];
        [authorNode setStringValue:_author];
        [bagNode addChild:authorNode];
        
	}
	
    
	NSData * data = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    [xmlDoc release];
    
	[data writeToURL:[panel URL] atomically:YES];
    
    
}



#pragma mark -
#pragma mark Import

- (IBAction)importOldXMLSources:(id)sender {
	NSLog(@"emplacement du fichier : %@",[self fileURL]);
	if([self fileURL]!=NULL){
		NSAlert * a = [NSAlert alertWithMessageText:NSLocalizedStringFromTable(@"IMErrorFileTitle",@"Localizable",@"Import") defaultButton:NSLocalizedStringFromTable(@"OK",@"Localizable",@"Other") alternateButton:@"" otherButton:@"" informativeTextWithFormat:NSLocalizedStringFromTable(@"IMErrorFileText",@"Localizable",@"Import")];
		[a beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:nil contextInfo:nil];
		return;
	}
	
	NSOpenPanel * openP = [NSOpenPanel openPanel];
	[openP setCanChooseFiles:YES];
	[openP setCanChooseDirectories:NO];
	[openP setCanCreateDirectories:NO];
	[openP setPrompt:NSLocalizedStringFromTable(@"IMPanelPromptTitle",@"Localizable",@"Import")];
	[openP setTitle:NSLocalizedStringFromTable(@"IMPanelTitle",@"Localizable",@"Import")];
	//[openP setRequiredFileType:@"xmlpms"];
	NSArray * ar = [NSArray arrayWithObjects:@"xmlpms", @"xmlpms1", nil];
	[openP setAllowedFileTypes:ar];
	if([openP runModal]!=NSOKButton) return;
	NSLog(@"Fichier : %@",[openP URL]);
	
	NSError *error = nil;
	
	NSString * contantFile = [[NSString alloc] initWithContentsOfURL:[openP URL] encoding:NSUTF16StringEncoding error:nil];
	
	NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithXMLString:contantFile options:NSXMLNodeOptionsNone error:&error];
    [contantFile release];
	if(!xmlDoc){
		NSLog(@"Erreur : %@", error);
		return;
	}
	NSXMLElement * root = [xmlDoc rootElement];
    [xmlDoc release];
	
	NSXMLElement * infos = [[[root elementsForName:@"infos"] objectEnumerator] nextObject];
	if(!infos){
		NSLog(@"Pas de ligne Info !");
		return;
	}
	
	NSLog(@"Infos : %@\n",[infos attributes]);
	
	
}


#pragma mark -
#pragma mark Print
- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings error:(NSError **)outError{
	
	PMCPageView * p=[[[main_ScroolView documentView] subviews] objectAtIndex:0];
	NSRect printRect = NSMakeRect(0, 0, [p bounds].size.width, [p bounds].size.height);
	PMCPageViewPrint * pagesPrint = [[PMCPageViewPrint alloc] initWithFrame:printRect];
	
	NSImage * imgPage;
	
	for(int i=0;i<3;i++){
		
		imgPage = [[NSImage alloc] initWithData:[self dataImageForPage:i widthFormat:1]];
		[pagesPrint addPageWithImage:imgPage];
		[imgPage release];
		
	}
	
    NSPrintInfo *printInfo = [self printInfo];
	
	[printInfo setPaperName:[[_pageFormat objectAtIndex:_format] objectForKey:@"name"]];
	[printInfo setPaperSize:[self frameWidthFormatAndOrientation].size];
	
	if(_orientation==0)	[printInfo setOrientation:NSPortraitOrientation];
    else [printInfo setOrientation:NSLandscapeOrientation];
	
	[printInfo setRightMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setTopMargin:0.0];
    [printInfo setBottomMargin:0.0];
	
    NSPrintOperation *printOperation = 	[NSPrintOperation printOperationWithView:pagesPrint printInfo:printInfo];
    [pagesPrint release];
    
    return printOperation;
	
}
@end
