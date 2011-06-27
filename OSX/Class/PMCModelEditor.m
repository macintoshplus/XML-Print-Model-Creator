//
//  PMCModelEditor.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCModelEditor.h"
#import "PMCPropertiesView.h"
#import "PMCPageContainer.h"

@implementation PMCModelEditor

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		
		_format=1;
		_orientation=0;
		
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
		
		_propertyCol_inEdit = FALSE;
		_propertyRow_inEdit = FALSE;
		
		_pageFormat = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PageFormat" ofType:@"plist"]];
		_fontList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"]];

		NSRect rect;
		if(_orientation==0) rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]);
		else rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]);
		
		_page1 = [[PMCPages alloc] initWithFrame:rect];
		[_page1 setDelegate:self];
		_page2 = [[PMCPages alloc] initWithFrame:rect];
		[_page2 setDelegate:self];
		_page3 = [[PMCPages alloc] initWithFrame:rect];
		[_page3 setDelegate:self];
		_actualPage=[_page1 retain];
		//NSLog(@"_pageFormat = %@",_pageFormat);
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ModelEditor";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:NO];	
    [toolbar setAutosavesConfiguration:NO];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[toolbar validateVisibleItems];
    [[self windowForSheet] setToolbar:[toolbar autorelease]];    
	
	
	[main_SplitVertical replaceSubview:[[main_SplitVertical subviews] objectAtIndex:0] with:main_ObjectListView];
	//[main_SplitVertical replaceSubview:[[main_SplitVertical subviews] lastObject] with:main_PreView];
	[main_SplitVertical adjustSubviews];
	
	[self setInspectorForObject:@"doc"];
	
	NSRect r = [_actualPage frame];
	NSSize cr = [main_ScroolView contentSize];
	[main_ScroolView setPostsFrameChangedNotifications:TRUE];
	int margin = 40;
	r.size.width=(cr.width>r.size.width+margin)? cr.width:r.size.width+margin;
	r.size.height=(cr.height>r.size.height+margin)? cr.height:r.size.height+margin;
	PMCPageContainer * p = [[PMCPageContainer alloc] initWithFrame:r];
	[p setMargin:margin];
	[p setContentView:_actualPage];
	[p setNeedsDisplay:TRUE];
	[p apply];
	[p changeContent];
	[main_ScroolView setDocumentView:p];/**/
	//[main_ScroolView setDocumentView:_actualPage];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectTableViewSelectionChange:) name:NSTableViewSelectionDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitViewWillResizeSubviews:) name:NSSplitViewWillResizeSubviewsNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitViewDidResizeSubviews:) name:NSSplitViewDidResizeSubviewsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:main_ScroolView];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectOnPageDidChange:) name:PMCObjectPageDidChange object:nil];
	
	[self setInspectorForObject:@"doc"];
	
	//NSLog(@"Main Scrool View (contentView) : %@",[main_ScroolView contentView]);
	
	[ol_ObjectTableView registerForDraggedTypes:[NSArray arrayWithObject:@"PMCObjectType"]];
	[ol_ObjectTableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
	
	[property_Array_ColRowList registerForDraggedTypes:[NSArray arrayWithObject:@"PMCRowColType"]];
	[property_Array_ColRowList setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
	
}

-(void) observeValueForKeyPath:(NSString*) keyPath ofObject:(id) object change:(NSDictionary*) change context:(void*)context 
{ 
	
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
	[dico setObject:_colorFontPagination forKey:@"DocColorFontPagination"];
	
	
	NSMutableDictionary * ar = [[NSMutableDictionary alloc] init];
	[ar setObject:[_page1 getDataForSave] forKey:@"Page1"];
	[ar setObject:[_page2 getDataForSave] forKey:@"Page2"];
	[ar setObject:[_page3 getDataForSave] forKey:@"Page3"];
	[ar setObject:dico forKey:@"InfosDocs"];
	
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
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		//NSLog(@"Object number : %i : ClassName : %@ ; Dico : %@", i, [obj objectForKey:@"ObjectClassName"], obj);
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"])
			[_page1 addObject:[[PMCTrait alloc] initWithData:obj] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			//NSLog(@"Description : %@",r);
			[_page1 addObject:r atPlan:0];
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"])
			[_page1 addObject:[[PMCText alloc] initWithData:obj] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"])
			[_page1 addObject:[[PMCTableau alloc] initWithData:obj] atPlan:0];
		
		/*
		*/
	}
	
	ar = [doc objectForKey:@"Page2"];
	max=[ar count]-1;
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"])
			[_page2 addObject:[[PMCRectangle alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"])
			[_page2 addObject:[[PMCTrait alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"])
			[_page2 addObject:[[PMCText alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"])
			[_page2 addObject:[[PMCTableau alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
	}
	
	
	ar = [doc objectForKey:@"Page3"];
	max=[ar count]-1;
	
	for(i=0;i<=max;i++){
		obj = [ar objectAtIndex:i];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"])
			[_page3 addObject:[[PMCRectangle alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"])
			[_page3 addObject:[[PMCTrait alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"])
			[_page3 addObject:[[PMCText alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"])
			[_page3 addObject:[[PMCTableau alloc] initWithData:[ar objectAtIndex:max-i]] atPlan:0];
	}
	
	/**/
	
	[_actualPage reDraw];
	[ol_ObjectTableView reloadData];
	
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
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
    /**/
    if ( [itemIdentifier isEqualToString:@"orderUpTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderUpTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderUp"]];
		[item setTarget:_actualPage];
		[item setAction:@selector(orderUpSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDoubleUpTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDoubleUpTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDoubleUp"]];
		[item setTarget:_actualPage];
		[item setAction:@selector(orderDoubleUpSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDownTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDownTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDown"]];
		[item setTarget:_actualPage];
		[item setAction:@selector(orderDownSelectedObject:)];
    } else if ( [itemIdentifier isEqualToString:@"orderDoubleDownTool"] ) {
		[item setLabel:NSLocalizedStringFromTable(@"orderDoubleDownTool",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"OrderDoubleDown"]];
		[item setTarget:_actualPage];
		[item setAction:@selector(orderDoubleDownSelectedObject:)];
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
		[item setTarget:_actualPage];
		[item setAction:@selector(deleteSelectedObject:)];
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
    } else if ( [itemIdentifier isEqualToString:@"zoomSelector"] ) {
		NSRect fRect = [tool_ZoomView frame];
		
		[item setLabel:NSLocalizedStringFromTable(@"zoomSelectorTitle",@"Localizable",@"Tools")];
		[item setToolTip:[item label]];
		[item setPaletteLabel:[item label]];
		[item setView:tool_ZoomView];
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
			@"zoomSelector", @"lineTool", @"rectTool", @"textTool", @"arrayTool", @"deleteTool", @"orderUpTool", @"orderDoubleUpTool", @"orderDownTool", @"orderDoubleDownTool", nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:@"lineTool", @"rectTool", @"textTool", @"arrayTool", NSToolbarFlexibleSpaceItemIdentifier, @"deleteTool", NSToolbarSeparatorItemIdentifier, @"orderDoubleUpTool", @"orderUpTool", @"orderDownTool", @"orderDoubleDownTool", NSToolbarFlexibleSpaceItemIdentifier,
			@"zoomSelector", nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	//NSLog(@"validateToolbarItem : %@ - PicSelected : %@",[theItem itemIdentifier],(([[HexPicController sharedInstance] deviceIsSelected])? @"YES":@"NO"));
    
    //if ([[theItem itemIdentifier] isEqualToString:@"deleteTool"]) return ([_actualPage getSelectedObjectIndex]>-1);
		return YES;
	
	//return NO;
}

#pragma mark -
#pragma mark DataSources
/*************************************/
/*            DataSources            */
/*************************************/
- (int)numberOfRowsInTableView:(NSTableView *)aTableView{
	//NSLog(@"Nb obj : %i",[_actualPage objCount]);
	if(aTableView==ol_ObjectTableView) return [_actualPage objCount];
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet!=nil) return [_tmpArrayObjet count];
	return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex{
	if(aTableView==ol_ObjectTableView){
		if([[aTableColumn identifier] isEqualToString:@"type"]) return NSLocalizedStringFromTable([[_actualPage getObjectAtIndex:rowIndex] className],@"Localizable",@"Objects");
		if([[aTableColumn identifier] isEqualToString:@"name"]) return [[_actualPage getObjectAtIndex:rowIndex] getName];
	}
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet) {
		if([[aTableColumn identifier] isEqualToString:@"col"]){
			if(_propertyCol_inEdit){
				return [[_tmpArrayObjet objectAtIndex:rowIndex] name];
			}else if(_propertyRow_inEdit){
				return [[_tmpArrayObjet objectAtIndex:rowIndex] name];
			}
		}
		
	}
	return @"N/D";
}

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
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet){
		if (operation == NSTableViewDropAbove) {//NSTableViewDropAbove
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
			NSLog(@"Move Row : %i to %i",indexObject , row);
			int finalDest=0;
			if(indexObject==row) return FALSE; //annule le déplacement si la source et la destintation sont égale
			if(indexObject>row || row==0)finalDest=row;
			else finalDest=row-1;
			id obj = [[_actualPage getObjectAtIndex:indexObject] retain];
			NSLog(@"retain count : %i",[obj retainCount]);
			[_actualPage deleteObjectAtIndex:indexObject];
			[_actualPage addObject:obj atPlan:finalDest];
			[obj release];
			[_actualPage reDraw];
			[ol_ObjectTableView reloadData];
			return TRUE;
		}
		return FALSE;
	}
	
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet){
		int indexObject = [[[info draggingPasteboard] stringForType:@"PMCRowColType"] intValue];
		if(operation==NSTableViewDropAbove){
			int finalDest=0;
			if(indexObject==row) return FALSE; //annule le déplacement si la source et la destintation sont égale
			if(indexObject>row || row==0)finalDest=row;
			else finalDest=row-1;
			id obj = [[_tmpArrayObjet objectAtIndex:indexObject] retain];
			NSLog(@"retain count : %i",[obj retainCount]);
			[_tmpArrayObjet removeObjectAtIndex:indexObject];
			[_tmpArrayObjet insertObject:obj atIndex:finalDest];
			[obj release];
			[property_Array_ColRowList reloadData];
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
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet){
		return [NSArray arrayWithObject:@"PMCRowColType"];
	}
	return nil;
}
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard{
	//NSLog(@"writeRowsWithIndexes:%@",rowIndexes);
	if(aTableView==ol_ObjectTableView){
		[pboard declareTypes:[NSArray arrayWithObjects:@"PMCObjectType",nil] owner:self];
		[pboard setString:[NSString stringWithFormat:@"%i",[rowIndexes firstIndex]] forType:@"PMCObjectType"]; 
		return TRUE;
	}
	if(aTableView==property_Array_ColRowList && _tmpArrayObjet){
		[pboard declareTypes:[NSArray arrayWithObjects:@"PMCRowColType",nil] owner:self];
		[pboard setString:[NSString stringWithFormat:@"%i",[rowIndexes firstIndex]] forType:@"PMCRowColType"]; 
		return TRUE;
	}
	return FALSE;
}

#pragma mark -
#pragma mark Delegates
/*************************************/
/*             Delegates             */
/*************************************/
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
	if(aTableView==ol_ObjectTableView){
		if([[aTableColumn identifier] isEqualToString:@"name"] && [_actualPage getSelectedObjectIndex]>-1){
			[[_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]] setName:[anObject copy]];
			[self setPropertiesForSelectedObject];
			[ol_ObjectTableView reloadData];
		}
	}
}
/*- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
	//if(row%2==0) return 30.0;
	return 15.0;

}
*/
#pragma mark -
#pragma mark Other

/* Définit si un objet est sélectionné.
 * Lit les données de la mémoire pour les afficher dans la palette des propriétés.
 */
- (void)setSelectedObjectAtIndex:(int)idx{ 
	[ol_ObjectTableView reloadData];
	if(idx>-1 && idx<[_actualPage objCount]){
		[ol_ObjectTableView selectRow:idx byExtendingSelection:FALSE];
	}
	if(idx==-1){
		[ol_ObjectTableView deselectAll:nil];
	}
}

//cette fonction permet de choisir la fonction qui gèrea l'affichage des propriétés
- (void)setPropertiesForSelectedObject{
	if([_actualPage getSelectedObjectIndex]==-1){
		[self setPropertiesForDocuments];
		[self setPropertiesForFont];
		return;
	}
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCTrait"]){
		[self setPropertiesForLine];
		[self setPropertiesForSize];
	}
	if([cn isEqualToString:@"PMCRectangle"]){
		[self setPropertiesForRect];
		[self setPropertiesForBGB];
		[self setPropertiesForSize];
	}
	if([cn isEqualToString:@"PMCText"]){
		[self setPropertiesForText];
		[self setPropertiesForFont];
		[self setPropertiesForBGB];
		[self setPropertiesForSize];
	}
	/*
	*/
	if([cn isEqualToString:@"PMCTableau"]){
		[self setPropertiesForArray];
		//[self setPropertiesForFont];
		[self setPropertiesForBGB];
		[self setPropertiesForSize];
	}
}

- (void)setPropertiesForDocuments{
	[property_doc_format removeAllItems];
	int i;
	for(i=0;i<[_pageFormat count];i++){
		[property_doc_format addItemWithTitle:[[_pageFormat objectAtIndex:i] objectForKey:@"name"]];
	}
	[property_doc_format selectItemAtIndex:_format];
	[property_doc_orientation selectItemAtIndex:_orientation];
	
	[property_doc_fistPage setState:(_firstPage)? NSOnState:NSOffState];
	[property_doc_otherPage setState:(_otherPage)? NSOnState:NSOffState];
	[property_doc_lastPage setState:(_lastPage)? NSOnState:NSOffState];
	
	[property_doc_enabledPagination setState:(_enabledPagination)? NSOnState:NSOffState];
	[property_doc_formatPagination setStringValue:_formatPagination];
	
	[property_doc_xPaginationStepper setIntValue:_xPagination];
	[property_doc_xPaginationStepper setMaxValue:(double)[[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]];
	[property_doc_xPaginationStepper setMinValue:0.0];
	[property_doc_xPagination setStringValue:[NSString stringWithFormat:@"%i",_xPagination]];
	[property_doc_yPagination setStringValue:[NSString stringWithFormat:@"%i",_yPagination]];
	[property_doc_yPaginationStepper setIntValue:_yPagination];
	[property_doc_yPaginationStepper setMaxValue:(double)[[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]];
	[property_doc_yPaginationStepper setMinValue:0.0];
	
}

- (void)setPropertiesForSize{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCRectangle"] || [cn isEqualToString:@"PMCText"] || [cn isEqualToString:@"PMCTrait"] || [cn isEqualToString:@"PMCTableau"]){
		[property_size_height setIntValue:[obj getSizeAndPosition].size.height];
		[property_size_heightStepper setIntValue:[obj getSizeAndPosition].size.height];
		[property_size_heightStepper setMinValue:0.0];
		[property_size_heightStepper setMaxValue:1000000.0];
		[property_size_width setIntValue:[obj getSizeAndPosition].size.width];
		[property_size_widthStepper setIntValue:[obj getSizeAndPosition].size.width];
		[property_size_widthStepper setMinValue:0.0];
		[property_size_widthStepper setMaxValue:1000000.0];
		
		[property_size_x setIntValue:[obj getSizeAndPosition].origin.x];
		[property_size_xStepper setIntValue:[obj getSizeAndPosition].origin.x];
		[property_size_xStepper setMinValue:0.0];
		[property_size_xStepper setMaxValue:1000000.0];
		[property_size_y setIntValue:[obj getSizeAndPosition].origin.y];
		[property_size_yStepper setIntValue:[obj getSizeAndPosition].origin.y];
		[property_size_yStepper setMinValue:0.0];
		[property_size_yStepper setMaxValue:1000000.0];
	}
	if([cn isEqualToString:@"PMCTrait"]){
		
	}
}


- (void)setPropertiesForFont{
	[property_font_name removeAllItems];
	int i;
	for(i=0;i<[_fontList count];i++){
		[property_font_name addItemWithTitle:[_fontList objectAtIndex:i]];
	}
	if([_actualPage getSelectedObjectIndex]==-1){
		[property_font_name selectItemAtIndex:_fontIndexPagination];
		[property_font_size setIntValue:_fontSizePagination];
		[property_font_sizeStepper setIntValue:_fontSizePagination];
		[property_font_sizeStepper setMaxValue:80.0];
		[property_font_sizeStepper setMinValue:5.0];
		[property_font_color setColor:_colorFontPagination];
		
		[property_font_bold  setState:(_boldFontPagination)? NSOnState:NSOffState];
		[property_font_italic  setState:(_italicFontPagination)? NSOnState:NSOffState];
		[property_font_underline  setState:(_underlineFontPagination)? NSOnState:NSOffState];
		
		[property_font_align setSelectedSegment:_alignPagination];
	}else{
		id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
		NSString * cn = [obj className];
		
		if([cn isEqualToString:@"PMCText"]){
			[property_font_name selectItemAtIndex:[obj getTextFontIndex]];
			[property_font_size setIntValue:[obj getTextSize]];
			[property_font_sizeStepper setIntValue:[obj getTextSize]];
			[property_font_sizeStepper setMaxValue:80.0];
			[property_font_sizeStepper setMinValue:5.0];
			[property_font_color setColor:[obj getTextColor]];
			
			[property_font_bold  setState:([obj getTextBold])? NSOnState:NSOffState];
			[property_font_italic  setState:([obj getTextItalic])? NSOnState:NSOffState];
			[property_font_underline  setState:([obj getTextUnderline])? NSOnState:NSOffState];
			
			[property_font_align setSelectedSegment:[obj getTextAlign]];
		}
	
	}
}


- (void)setPropertiesForLine{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCTrait"]){
		[property_line_name setStringValue:[obj getName]];
		[property_line_visible setState:([obj isVisible])? NSOnState:NSOffState];
		[property_line_color setColor:[obj getColor]];
		[property_line_styles selectItemAtIndex:[obj getStyle]];
	}
}


- (void)setPropertiesForBGB{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCRectangle"] || [cn isEqualToString:@"PMCText"] || [cn isEqualToString:@"PMCTableau"]){
		[property_BGB_BGColor setColor:[obj getBgroundColor]];
		[property_BGB_BGVisible setState:([obj getBackgroundVisibility])? NSOnState:NSOffState];
		
		[property_BGB_BorderWidth setIntValue:[obj getBorderWidthByInt]];
		[property_BGB_BorderWidthStepper setIntValue:[obj getBorderWidthByInt]];
		[property_BGB_BorderWidthStepper setMinValue:0.0];
		[property_BGB_BorderWidthStepper setMaxValue:50.0];
		[property_BGB_BottomColor setColor:[obj getBorderBottomColor]];
		[property_BGB_BottomVisible setState:([obj getBorderBottomVisibility])? NSOnState:NSOffState];
		[property_BGB_LeftColor setColor:[obj getBorderLeftColor]];
		[property_BGB_LeftVisible setState:([obj getBorderLeftVisibility])? NSOnState:NSOffState];
		[property_BGB_RightColor setColor:[obj getBorderRightColor]];
		[property_BGB_RightVisible setState:([obj getBorderRightVisibility])? NSOnState:NSOffState];
		[property_BGB_TopColor setColor:[obj getBorderTopColor]];
		[property_BGB_TopVisible setState:([obj getBorderTopVisibility])? NSOnState:NSOffState];
	}
}


- (void)setPropertiesForText{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCText"]){
		[property_Text_name setStringValue:[obj getName]];
		[property_Text_visible setState:([obj isVisible])? NSOnState:NSOffState];
		[property_Text_value setStringValue:[obj getText]];
	}
}


- (void)setPropertiesForRect{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCRectangle"]){
		[property_Rect_name setStringValue:[obj getName]];
		[property_Rect_visible setState:([obj isVisible])? NSOnState:NSOffState];
	}
	
}

- (void)setPropertiesForArray{
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	NSString * cn = [obj className];
	
	if([cn isEqualToString:@"PMCTableau"]){
		[property_Array_name setStringValue:[obj getName]];
		[property_Array_visible setState:([obj isVisible])? NSOnState:NSOffState];
		
		[property_Array_header setState:([obj showHeader])? NSOnState:NSOffState];
		[property_Array_header_repeat setState:([obj repeatHeader])? NSOnState:NSOffState];
		
		[property_Array_repeat setState:([obj repeatArrayToOtherPage])? NSOnState:NSOffState];
		[property_Array_height_other setIntValue:[obj heightOnOtherPage]];
		[property_Array_top_other setIntValue:[obj topOnOtherPage]];
		
		[property_Array_dataSource setStringValue:[obj dataSource]];
		
		int nb = [[obj columnDef] count];
		if(nb<2) [property_Array_col_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleColButton",@"Localizable",@"Other"),nb]];
		if(nb>1) [property_Array_col_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleColsButton",@"Localizable",@"Other"),nb]];
		nb = [[obj rowDef] count];
		if(nb<2) [property_Array_row_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleRowButton",@"Localizable",@"Other"),nb]];
		if(nb>1) [property_Array_row_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleRowsButton",@"Localizable",@"Other"),nb]];
	}
	
}

- (void)readObjectAndSetArrayColRowProperties{
	//Enregistre les dernières modifications avant de lire les valeurs de l'objet sélectionné
	if(_tmpLastIndexObj!=-1) [self compareAndSaveArrayColRowProperties];
	int index = [property_Array_ColRowList selectedRow];
	if(index>-1 && index<[_tmpArrayObjet count]){
		//Indique que la ligne en cour est celle sélectionné
		_tmpLastIndexObj = [property_Array_ColRowList selectedRow];
	}else{
		_tmpLastIndexObj = -1;
		if(_propertyCol_inEdit) [self disableColProperties];
		else if(_propertyRow_inEdit) [self disableRowProperties];
		return;
	}
	//Lit les données de l'objet
	if(_propertyCol_inEdit){
		PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
		
		[property_Array_Col_Name setStringValue:[obj2 name]];
		[property_Array_Col_Width setIntValue:[obj2 colWidth]];
		[property_Array_Col_Width_Stepper setIntValue:[obj2 colWidth]];
		[property_Array_Col_Width_Stepper setMaxValue:12000.0];
		[property_Array_Col_Width_Stepper setMinValue:0.0];
		[property_Array_Col_Align setSelectedSegment:[obj2 dataAlign]];
		[property_Array_Col_Data setStringValue:[obj2 data]];
		[property_Array_Col_HAlign setSelectedSegment:[obj2 headerAlign]];
		[property_Array_Col_HData setStringValue:[obj2 headerData]];
		[property_Array_Col_BEnable setState:([obj2 borderRightVisible])? NSOnState:NSOffState];
		[property_Array_Col_BWidth setIntValue:[obj2 borderRightWidth]];
		[property_Array_Col_BWidthStepper setIntValue:[obj2 borderRightWidth]];
		[property_Array_Col_BWidthStepper setMaxValue:10.0];
		[property_Array_Col_BWidthStepper setMinValue:1.0];
		[property_Array_Col_BColor setColor:[obj2 borderRightColor]];
		[self checkColumnBounds];
		[self enableColProperties];
		
	}else if(_propertyRow_inEdit){
		PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
		
		[property_Array_Row_Name setStringValue:[obj2 name]];
		[property_Array_Row_Height setIntValue:[obj2 hauteurLigne]];
		[property_Array_Row_Height_Stepper setIntValue:[obj2 hauteurLigne]];
		[property_Array_Row_Height_Stepper setMaxValue:100.0];
		[property_Array_Row_Height_Stepper setMinValue:5.0];
		[property_Array_Row_Type setStringValue:[obj2 genre]];
		[property_Array_Row_BGEnable setState:([obj2 backgroundVisible])? NSOnState:NSOffState];
		[property_Array_Row_BGColor setColor:[obj2 colorBG]];
		[property_Array_Row_Font selectItemAtIndex:[obj2 fontIndex]];
		[property_Array_Row_FontSize setIntValue:[obj2 fontSize]];
		[property_Array_Row_FontSize_Stepper setIntValue:[obj2 fontSize]];
		[property_Array_Row_FontSize_Stepper setMaxValue:80.0];
		[property_Array_Row_FontSize_Stepper setMinValue:4.0];
		[property_Array_Row_FontColor setColor:[obj2 fontColor]];
		[property_Array_Row_BTopEnable setState:([obj2 borderTopVisible])? NSOnState:NSOffState];
		[property_Array_Row_BTopWidth setIntValue:[obj2 borderTopWidth]];
		[property_Array_Row_BTopWidth_Stepper setIntValue:[obj2 borderTopWidth]];
		[property_Array_Row_BTopWidth_Stepper setMaxValue:10.0];
		[property_Array_Row_BTopWidth_Stepper setMinValue:1.0];
		[property_Array_Row_BTopColor setColor:[obj2 borderTopColor]];
		[property_Array_Row_BBEnable setState:([obj2 borderBottomVisible])? NSOnState:NSOffState];
		[property_Array_Row_BBWidth setIntValue:[obj2 borderBottomWidth]];
		[property_Array_Row_BBWidth_Stepper setIntValue:[obj2 borderBottomWidth]];
		[property_Array_Row_BBWidth_Stepper setMaxValue:10.0];
		[property_Array_Row_BBWidth_Stepper setMinValue:1.0];
		[property_Array_Row_BBColor setColor:[obj2 borderBottomColor]];
		[self enableRowProperties];
	}
	
}

- (void)compareAndSaveArrayColRowProperties{
}

/*
 * Il désactive les propriétés pour une colonne
 */
- (void)disableColProperties{

	[property_Array_Col_Name setEnabled:FALSE];
	[property_Array_Col_Width setEnabled:FALSE];
	[property_Array_Col_Width_Stepper setEnabled:FALSE];
	[property_Array_Col_Align setEnabled:FALSE];
	[property_Array_Col_Data setEnabled:FALSE];
	[property_Array_Col_HAlign setEnabled:FALSE];
	[property_Array_Col_HData setEnabled:FALSE];
	[property_Array_Col_BEnable setEnabled:FALSE];
	[property_Array_Col_BWidth setEnabled:FALSE];
	[property_Array_Col_BWidthStepper setEnabled:FALSE];
	[property_Array_Col_BColor setEnabled:FALSE];

}

/*
 * Il active les propriétés pour une colonne
 */
- (void)enableColProperties{
	
	[property_Array_Col_Name setEnabled:TRUE];
	[property_Array_Col_Width setEnabled:TRUE];
	[property_Array_Col_Width_Stepper setEnabled:TRUE];
	[property_Array_Col_Align setEnabled:TRUE];
	[property_Array_Col_Data setEnabled:TRUE];
	[property_Array_Col_HAlign setEnabled:TRUE];
	[property_Array_Col_HData setEnabled:TRUE];
	[property_Array_Col_BEnable setEnabled:TRUE];
	[property_Array_Col_BWidth setEnabled:TRUE];
	[property_Array_Col_BWidthStepper setEnabled:TRUE];
	[property_Array_Col_BColor setEnabled:TRUE];
	
}

/*
 * Il desactive les propriétés pour une ligne
 */
- (void)disableRowProperties{
	[property_Array_Row_Name setEnabled:FALSE];
	[property_Array_Row_Height setEnabled:FALSE];
	[property_Array_Row_Height_Stepper setEnabled:FALSE];
	[property_Array_Row_Type setEnabled:FALSE];
	[property_Array_Row_BGEnable setEnabled:FALSE];
	[property_Array_Row_BGColor setEnabled:FALSE];
	[property_Array_Row_Font setEnabled:FALSE];
	[property_Array_Row_FontSize setEnabled:FALSE];
	[property_Array_Row_FontSize_Stepper setEnabled:FALSE];
	[property_Array_Row_FontColor setEnabled:FALSE];
	[property_Array_Row_BTopEnable setEnabled:FALSE];
	[property_Array_Row_BTopWidth setEnabled:FALSE];
	[property_Array_Row_BTopWidth_Stepper setEnabled:FALSE];
	[property_Array_Row_BTopColor setEnabled:FALSE];
	[property_Array_Row_BBEnable setEnabled:FALSE];
	[property_Array_Row_BBWidth setEnabled:FALSE];
	[property_Array_Row_BBWidth_Stepper setEnabled:FALSE];
	[property_Array_Row_BBColor setEnabled:FALSE];
}

/*
 * Il active les propriétés pour une ligne
 */
- (void)enableRowProperties{
	[property_Array_Row_Name setEnabled:TRUE];
	[property_Array_Row_Height setEnabled:TRUE];
	[property_Array_Row_Height_Stepper setEnabled:TRUE];
	[property_Array_Row_Type setEnabled:TRUE];
	[property_Array_Row_BGEnable setEnabled:TRUE];
	[property_Array_Row_BGColor setEnabled:TRUE];
	[property_Array_Row_Font setEnabled:TRUE];
	[property_Array_Row_FontSize setEnabled:TRUE];
	[property_Array_Row_FontSize_Stepper setEnabled:TRUE];
	[property_Array_Row_FontColor setEnabled:TRUE];
	[property_Array_Row_BTopEnable setEnabled:TRUE];
	[property_Array_Row_BTopWidth setEnabled:TRUE];
	[property_Array_Row_BTopWidth_Stepper setEnabled:TRUE];
	[property_Array_Row_BTopColor setEnabled:TRUE];
	[property_Array_Row_BBEnable setEnabled:TRUE];
	[property_Array_Row_BBWidth setEnabled:TRUE];
	[property_Array_Row_BBWidth_Stepper setEnabled:TRUE];
	[property_Array_Row_BBColor setEnabled:TRUE];
}

/*
 * Vérifie que la largeur cumulé de toutes les colonnes ne dépasse pas la largeur du tableau.
 * Affiche la largeur en rouge dans le cas ou cela dépasse.
 */
- (void)checkColumnBounds{
	int i;
	int cumul=0;
	id obj = ([_actualPage getSelectedObjectIndex]==-1)? nil:[_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	if(!obj) return;
	for(i=0;i<[_tmpArrayObjet count];i++){
		cumul+=[[_tmpArrayObjet objectAtIndex:i] colWidth];
	}
	//NSLog(@"Cumul: %i Width: %f", cumul, [obj getSizeAndPosition].size.width);
	if((float)cumul>[obj getSizeAndPosition].size.width){
		[property_Array_Col_Width setTextColor:[NSColor redColor]];
	}else{
		[property_Array_Col_Width setTextColor:[NSColor blackColor]];
	}
}

- (void)writeSelectedObjectToPasteboard:(NSPasteboard*)pb{
	[pb declareTypes:[NSArray arrayWithObject:@"PMCObject"] owner:self];
	[pb setData:[NSArchiver archivedDataWithRootObject:[[_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]] getDataForSave]] forType:@"PMCObject"];
}

- (BOOL)readObjectFromPasteboard:(NSPasteboard*)pb{
	NSString * type;
	
	type = [pb availableTypeFromArray:[NSArray arrayWithObject:@"PMCObject"]];
	
	if(type){
		id obj = [NSUnarchiver unarchiveObjectWithData:[pb dataForType:@"PMCObject"]];
		
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTrait"])
			[_page1 addObject:[[PMCTrait alloc] initWithData:obj] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCRectangle"]){
			PMCRectangle * r = [[PMCRectangle alloc] initWithData:obj];
			//NSLog(@"Description : %@",r);
			[_page1 addObject:r atPlan:0];
		}
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCText"])
			[_page1 addObject:[[PMCText alloc] initWithData:obj] atPlan:0];
		if([[obj objectForKey:@"ObjectClassName"] isEqualToString:@"PMCTableau"])
			[_page1 addObject:[[PMCTableau alloc] initWithData:obj] atPlan:0];
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

- (void)objectTableViewSelectionChange:(NSNotification*)n{
	//NSLog(@"Sélection object a changé : %@ !",n);
	if([n object]==ol_ObjectTableView) [_actualPage setSelectedObject:[ol_ObjectTableView selectedRow]];
	if([n object]==property_Array_ColRowList) [self readObjectAndSetArrayColRowProperties];//Changement d'objet dont enregistrement des données d'avant et lecture des nouvelles données
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

- (void)objectOnPageDidChange:(NSNotification *)aNotification{
	[self setSelectedObjectAtIndex:-1];
	[ol_ObjectTableView reloadData];
}

- (CGFloat)splitView:(NSSplitView *)sender constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)offset{
	//NSLog(@"---- position : %f ; subview at : %i", proposedPosition, offset);
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
	if(sender==main_SplitVertical){
		if (offset == 0)
			return 217.;
		else 
			return proposedCoord;
	}
	return proposedCoord;
}

// ---------------------------------------------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedCoord ofSubviewAt:(NSInteger)offset
{
	if(sender==main_SplitVertical){
		if (offset == 0)
			return 300.;
		else 
			return proposedCoord;
	}
	return proposedCoord;
}


#pragma mark -
#pragma mark Inspector

-(void)setInspectorForObject:(NSString*)name{
	[self setPropertiesForSelectedObject];
	PMCPropertiesView * pv = [[[PMCPropertiesView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 260.0, 1.0)] autorelease];
	//NSLog(@"setInspectorForObject: %@",name);
	if([name isEqualToString:@"doc"]){
		[pv addView:main_DocPropertyView];
		[pv	addView:main_FontPropertyView];
	}else if([name isEqualToString:@"PMCTrait"]){
		[pv addView:main_LinePropertyView];
		[pv addView:main_SizePropertyView];
	}else if([name isEqualToString:@"PMCText"]){
		[pv addView:main_TextPropertyView];
		[pv	addView:main_FontPropertyView];
		[pv addView:main_BGAndBorderPropertyView];
		[pv addView:main_SizePropertyView];
	}else if([name isEqualToString:@"PMCRectangle"]){
		[pv addView:main_RectanglePropertyView];
		[pv addView:main_BGAndBorderPropertyView];
		[pv addView:main_SizePropertyView];
	}else if([name isEqualToString:@"PMCTableau"]){
		[pv addView:main_ArrayPropertyView];
		[pv addView:main_BGAndBorderPropertyView];
		[pv addView:main_SizePropertyView];
	}
	
	
	[main_ScroolPropertyView setDocumentView:pv];
}


#pragma mark -
#pragma mark Setter Getter

- (void)setFirstPage:(BOOL)val{
	if(_firstPage==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFirstPage:_firstPage];
	if(![undo isUndoing]){
		if(!_firstPage) [undo setActionName:@"enable first page"];
		else [undo setActionName:@"disable first page"];
	}
	_firstPage=val;
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}


- (void)setOtherPage:(BOOL)val{
	if(_otherPage==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setOtherPage:_otherPage];
	if(![undo isUndoing]){
		if(!_otherPage) [undo setActionName:@"enable other page"];
		else [undo setActionName:@"disable other page"];
	}
	_otherPage=val;
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}


- (void)setLastPage:(BOOL)val{
	if(_lastPage==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setLastPage:_lastPage];
	if(![undo isUndoing]){
		if(!_lastPage) [undo setActionName:@"enable last page"];
		else [undo setActionName:@"disable last page"];
	}
	_lastPage=val;
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPageFormat:(int)val{
	if(_format==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPageFormat:_format];
	if(![undo isUndoing]){
		[undo setActionName:@"change page format"];
	}
	_format=val;
	
	NSRect rect;
	if(_orientation==0) rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]);
	else rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]);
	
	[_page1 setFrame:rect];
	[_page2 setFrame:rect];
	[_page3 setFrame:rect];
	//[[main_ScroolView documentView] setZoom:[_actualPage actualZoom]];
	
	PMCPageContainer * p = [main_ScroolView documentView];
	[p apply];
	
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPageOrientation:(int)val{
	if(_orientation==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPageOrientation:_orientation];
	if(![undo isUndoing]){
		[undo setActionName:@"change page orientation"];
	}
	_orientation=val;
	NSRect rect;
	if(_orientation==0) rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue]);
	else rect = NSMakeRect(0, 0, [[[_pageFormat objectAtIndex:_format] objectForKey:@"height"] intValue], [[[_pageFormat objectAtIndex:_format] objectForKey:@"width"] intValue]);
	
	[_page1 setFrame:rect];
	[_page2 setFrame:rect];
	[_page3 setFrame:rect];
	
	PMCPageContainer * p = [main_ScroolView documentView];
	[p apply];
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPagination:(BOOL)val{
	if(_enabledPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPagination:_enabledPagination];
	if(![undo isUndoing]){
		if(!_enabledPagination) [undo setActionName:@"enable pagination"];
		else [undo setActionName:@"disable pagination"];
	}
	_enabledPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setFormatPagination:(NSString*)val{
	if(_formatPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setFormatPagination:_formatPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination format"];
	}
	[_formatPagination release];
	_formatPagination=[val retain];
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationPositionX:(int)val{
	if(_xPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationPositionX:_xPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination X position"];
	}
	_xPagination=val;
	//[property_doc_xPaginationStepper setIntValue:_xPagination];
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationPositionY:(int)val{
	if(_yPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationPositionY:_yPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination X position"];
	}
	_yPagination=val;
	//[property_doc_yPaginationStepper setIntValue:_yPagination];
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationFont:(int)val{
	if(_fontIndexPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFont:_fontIndexPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination font"];
	}
	_fontIndexPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationFontSize:(int)val{
	if(_fontSizePagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontSize:_fontSizePagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination font size"];
	}
	_fontSizePagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}


- (void)setPaginationFontColor:(NSColor*)val{
	if([_colorFontPagination isEqual:val]) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontColor:_colorFontPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination font color"];
	}
	_colorFontPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}


- (void)setPaginationFontBold:(BOOL)val{
	if(_boldFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontBold:_boldFontPagination];
	if(![undo isUndoing]){
		if(!_boldFontPagination) [undo setActionName:@"set bold"];
		else [undo setActionName:@"unset bold"];
	}
	_boldFontPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationFontItalic:(BOOL)val{
	if(_italicFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontItalic:_italicFontPagination];
	if(![undo isUndoing]){
		if(!_italicFontPagination) [undo setActionName:@"set italic"];
		else [undo setActionName:@"unset italic"];
	}
	_italicFontPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}

- (void)setPaginationFontUnderline:(BOOL)val{
	if(_underlineFontPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontUnderline:_underlineFontPagination];
	if(![undo isUndoing]){
		if(!_underlineFontPagination) [undo setActionName:@"set underline"];
		else [undo setActionName:@"unset underline"];
	}
	_underlineFontPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
}


- (void)setPaginationFontAlign:(int)val{
	if(_alignPagination==val) return;
	NSUndoManager * undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] setPaginationFontAlign:_alignPagination];
	if(![undo isUndoing]){
		[undo setActionName:@"change pagination alignment"];
	}
	_alignPagination=val;
	
	[self setSelectedObjectAtIndex:-1];
	[self setInspectorForObject:@"doc"];
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
	if([_actualPage getSelectedObjectIndex]>-1){
		[self copy:sender];
		[_actualPage deleteSelectedObject:sender];
	}
}

- (IBAction)copy:(id)sender
{
	if([_actualPage getSelectedObjectIndex]>-1){
		NSPasteboard * pb = [NSPasteboard generalPasteboard];
		[self writeSelectedObjectToPasteboard:pb];
	}
}

- (IBAction)paste:(id)sender
{
	NSPasteboard * pb = [NSPasteboard generalPasteboard];
	if(![self readObjectFromPasteboard:pb]) NSBeep();
	else{
		[ol_ObjectTableView reloadData];
		[_actualPage reDraw];
	}
}

- (IBAction)delete:(id)sender{
	if([_actualPage getSelectedObjectIndex]>-1){
		[_actualPage deleteSelectedObject:sender];
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

- (IBAction)ol_PageChange:(id)sender
{
	if([sender indexOfSelectedItem]==0)
		_actualPage=_page1;
	else if([sender indexOfSelectedItem]==1)
		_actualPage=_page2;
	else if([sender indexOfSelectedItem]==2)
	_actualPage=_page3;
	
	[_actualPage setNeedsDisplay:TRUE];
	
	PMCPageContainer * p = [main_ScroolView documentView];
	[p setContentView:_actualPage];
	[p setNeedsDisplay:TRUE];
	[p apply];
	[p changeContent];
	//[main_ScroolView setDocumentView:p];
	[ol_ObjectTableView reloadData];
}


- (IBAction)tool_NewLine:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"New Line %i",[_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	//[NSString stringWithFormat:]
	PMCTrait * nl = [[PMCTrait alloc] initWithName:name];
	[nl setSizeAndPosition:NSMakeRect(100, 100, 150, 10)];
	[nl setWidth:10];
	[_actualPage addObject:nl atPlan:0];
	//[_actualPage reDraw];
	[ol_ObjectTableView reloadData];
	[[self windowForSheet] setDocumentEdited:TRUE];
	
}

- (IBAction)tool_NewRect:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"New Rectangle %i",[_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCRectangle * nl = [[PMCRectangle alloc] initWithName:name];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 150, 50)];
	NSLog(@"New Object [%@] : %@", [nl className], nl);
	[_actualPage addObject:nl atPlan:0];
	//[_actualPage reDraw];
	[ol_ObjectTableView reloadData];
	[[self windowForSheet] setDocumentEdited:TRUE];
}

- (IBAction)tool_NewText:(id)sender
{
	NSString *name = [[NSString alloc] initWithFormat:@"New Text %i",[_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCText * nl = [[PMCText alloc] initWithName:name];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 150, 50)];
	[nl setText:name];
	[nl setTextFontIndex:1];
	[nl setTextSize:12];
	
	[_actualPage addObject:nl atPlan:0];
	//[_actualPage reDraw];
	[ol_ObjectTableView reloadData];
	[[self windowForSheet] setDocumentEdited:TRUE];
}


- (IBAction)tool_NewArray:(id)sender{
	NSString *name = [[NSString alloc] initWithFormat:@"New Array %i",[_actualPage objCount]+1];
	//NSLog(@"name = %@",name);
	PMCTableau * nl = [[PMCTableau alloc] initWithName:name];
	[nl setSizeAndPosition:NSMakeRect(130, 10, 300, 150)];
	
	[_actualPage addObject:nl atPlan:0];
	//[_actualPage reDraw];
	[ol_ObjectTableView reloadData];
	[[self windowForSheet] setDocumentEdited:TRUE];
}


- (IBAction)tool_deleteSelectedObject:(id)sender{
	[_actualPage deleteSelectedObject:sender];
}

- (IBAction)tool_orderUpSelectedObject:(id)sender{
	[_actualPage orderUpSelectedObject:sender];
}

- (IBAction)tool_orderDoubleUpSelectedObject:(id)sender{
	[_actualPage orderDoubleUpSelectedObject:sender];
}

- (IBAction)tool_orderDownSelectedObject:(id)sender{
	[_actualPage orderDownSelectedObject:sender];
}

- (IBAction)tool_orderDoubleDownSelectedObject:(id)sender{
	[_actualPage orderDoubleDownSelectedObject:sender];
}

- (IBAction)properties_valueChange:(id)sender{
	//Marque le doculment comme modifier
	[[self windowForSheet] setDocumentEdited:TRUE];
	
	//NSLog(@"properties_valueChange: %@",[sender className]);
	id obj = ([_actualPage getSelectedObjectIndex]==-1)? nil:[_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	//if(obj) NSLog(@"Object a modifier : %@",obj);
	#pragma mark properties_VC : Document
	/* Document Properties */
	if(sender == property_doc_format){
		[self setPageFormat:[sender indexOfSelectedItem]];
	}
	if(sender == property_doc_orientation){
		[self setPageOrientation:[sender indexOfSelectedItem]];
	}
	if(sender == property_doc_fistPage){
		[self setFirstPage:([sender state]==NSOnState)];
	}
	if(sender == property_doc_otherPage){
		[self setOtherPage:([sender state]==NSOnState)];
	}
	if(sender == property_doc_lastPage){
		[self setLastPage:([sender state]==NSOnState)];
	}
	if(sender == property_doc_enabledPagination){
		[self setPagination:([sender state]==NSOnState)];
	}
	if(sender == property_doc_formatPagination){
		[self setFormatPagination:[sender stringValue]];
	}
	if(sender == property_doc_xPagination){
		[self setPaginationPositionX:[sender intValue]];
		//_xPagination=[sender intValue];
		//[property_doc_xPaginationStepper setIntValue:_xPagination];
	}
	if(sender == property_doc_yPagination){
		[self setPaginationPositionY:[sender intValue]];
		//_yPagination=[sender intValue];
		//[property_doc_yPaginationStepper setIntValue:_yPagination];
	}
	if(sender == property_doc_xPaginationStepper){
		[self setPaginationPositionX:[sender intValue]];
		//_xPagination=[sender intValue];
		//[property_doc_xPagination setIntValue:_xPagination];
	}
	if(sender == property_doc_yPaginationStepper){
		[self setPaginationPositionY:[sender intValue]];
		//_yPagination=[sender intValue];
		//[property_doc_yPagination setIntValue:_yPagination];
	}
	
	#pragma mark properties_VC : Font
	/* Font Properties */
	if(sender == property_font_name){
		if(obj==nil){
			[self setPaginationFont:[sender indexOfSelectedItem]];
		}else{
			NSUndoManager * undo = [self undoManager];
			[[undo prepareWithInvocationTarget:obj] setTextFontIndex:[obj getTextFontIndex]];
			if(![undo isUndoing]){
				[undo setActionName:@"change font"];
			}
			[obj setTextFontIndex:[sender indexOfSelectedItem]];
		}
	}
	if(sender == property_font_size){
		NSLog(@"Valeur taille police : %i",[sender intValue]);
		if(obj==nil){
			[self setPaginationFontSize:[sender intValue]]; //_fontSizePagination=[sender intValue];
		}else{
			[obj setTextSize:[sender intValue]];
			[property_font_sizeStepper setIntValue:[sender intValue]];
		}
	}
	if(sender == property_font_sizeStepper){
		if(obj==nil){
			//_fontSizePagination=[sender intValue];
			//[property_font_size setIntValue:_fontSizePagination];
			[self setPaginationFontSize:[sender intValue]];
		}else{
			[obj setTextSize:[sender intValue]];
			//[property_font_size setIntValue:[obj getTextSize]];
			[property_font_size setIntValue:[sender intValue]];
		}
	}
	
	if(sender == property_font_color){
		if(obj==nil) [self setPaginationFontColor:[[sender color] copy]];
		else [obj setTextColor:[[sender color] copy]];
	}
	if(sender == property_font_bold){
		if(obj==nil) [self setPaginationFontBold:([sender state]==NSOnState)];
		else [obj setTextBold:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_font_italic){
		if(obj==nil) [self setPaginationFontItalic:([sender state]==NSOnState)];
		else [obj setTextItalic:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_font_underline){
		if(obj==nil) [self setPaginationFontUnderline:([sender state]==NSOnState)];
		else [obj setTextUnderline:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_font_align){
		if(obj==nil) [self setPaginationFontAlign:[sender selectedSegment]];
		else [obj setTextAlign:[sender selectedSegment]];
	}
	
#pragma mark properties_VC : Size
	/* Size Properties */
	if(sender == property_size_x){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.origin.x=[sender intValue];
			[obj setSizeAndPosition:r];
		}
	}
	if(sender == property_size_y){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.origin.y=[sender intValue];
			[obj setSizeAndPosition:r];
		}
	}
	if(sender == property_size_xStepper){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.origin.x=[sender intValue];
			[obj setSizeAndPosition:r];
			[property_size_x setIntValue:[obj getSizeAndPosition].origin.x];
		}
	}
	if(sender == property_size_yStepper){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.origin.y=[sender intValue];
			[obj setSizeAndPosition:r];
			[property_size_y setIntValue:[obj getSizeAndPosition].origin.y];
		}
	}
	if(sender == property_size_width){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.size.width=[sender intValue];
			[obj setSizeAndPosition:r];
		}
	}
	if(sender == property_size_height){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.size.height=[sender intValue];
			[obj setSizeAndPosition:r];
		}
	}
	if(sender == property_size_widthStepper){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.size.width=[sender intValue];
			[obj setSizeAndPosition:r];
			[property_size_width setIntValue:[obj getSizeAndPosition].size.width];
		}
	}
	if(sender == property_size_heightStepper){
		if(obj){
			NSRect r = [obj getSizeAndPosition];
			r.size.height=[sender intValue];
			[obj setSizeAndPosition:r];
			[property_size_height setIntValue:[obj getSizeAndPosition].size.height];
		}
	}
	
	#pragma mark properties_VC : Backgound and Border
	/* Backgound and Border Properties */
	if(sender == property_BGB_BGVisible){
		if(obj) [obj setBackgroundVisibility:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_BGB_BGColor){
		if(obj) [obj setBgroundColor:[[sender color] copy]];
	}
	if(sender == property_BGB_TopVisible){
		if(obj) [obj setBorderTopVisibility:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_BGB_TopColor){
		if(obj) [obj setBorderTopColor:[[sender color] copy]];
	}
	if(sender == property_BGB_RightVisible){
		if(obj) [obj setBorderRightVisibility:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_BGB_RightColor){
		if(obj) [obj setBorderRightColor:[[sender color] copy]];
	}
	if(sender == property_BGB_BottomVisible){
		if(obj) [obj setBorderBottomVisibility:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_BGB_BottomColor){
		if(obj) [obj setBorderBottomColor:[[sender color] copy]];
	}
	if(sender == property_BGB_LeftVisible){
		if(obj) [obj setBorderLeftVisibility:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_BGB_LeftColor){
		if(obj) [obj setBorderLeftColor:[[sender color] copy]];
	}
	if(sender == property_BGB_BorderWidth){
		if(obj) [obj setBorderWidthByInt:[sender intValue]];
	}
	if(sender == property_BGB_BorderWidthStepper){
		if(obj){
			[obj setBorderWidthByInt:[sender intValue]];
			[property_BGB_BorderWidth setIntValue:[obj getBorderWidthByInt]];
		}
	}
	
	#pragma mark properties_VC : Line
	/* Line Properties */
	if(sender == property_line_visible){
		if(obj) [obj setVisible:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_line_name){
		if(obj) [obj setName:[[sender stringValue] copy]];
	}
	if(sender == property_line_color){
		if(obj) [obj setColor:[[sender color] copy]];
	}
	if(sender == property_line_styles){
		if(obj) [obj setStyle:[sender indexOfSelectedItem]];
	}
	
	#pragma mark properties_VC : Text
	/* Text Properties */
	if(sender == property_Text_visible){
		if(obj) [obj setVisible:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Text_name){
		if(obj) [obj setName:[[sender stringValue] copy]];
	}
	if(sender == property_Text_value){
		if(obj) [obj setText:[[sender stringValue] copy]];
	}
	
	#pragma mark properties_VC : Rect
	/* Rect Properties */
	if(sender == property_Rect_visible){
		if(obj) [obj setVisible:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Rect_name){
		if(obj) [obj setName:[[sender stringValue] copy]];
	}
	
	#pragma mark properties_VC : Array
	/* Array properties */
	if(sender == property_Array_visible){
		if(obj) [obj setVisible:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Array_name){
		if(obj) [obj setName:[[sender stringValue] copy]];
	}
	
	if(sender == property_Array_repeat){
		if(obj) [obj setRepeatArrayToOtherPage:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Array_top_other){
		if(obj) [obj setTopOnOtherPage:[sender intValue]];
	}
	if(sender == property_Array_height_other){
		if(obj) [obj setHeightOnOtherPage:[sender intValue]];
	}
	if(sender == property_Array_header){
		if(obj) [obj setShowHeader:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Array_header_repeat){
		if(obj) [obj setRepeatHeader:(([sender state]==NSOnState)? TRUE:FALSE)];
	}
	if(sender == property_Array_dataSource){
		if(obj) [obj setDataSource:[sender stringValue]];
	}
	
	#pragma mark properties_VC : Exented Array
	/* Extended Properties for Array */
	if(sender == property_Array_ColRowAddRemove){ //Ajout ou suppression d'une colonne ou ligne
		if(obj && _tmpArrayObjet){ //[obj setRepeatHeader:(([sender state]==NSOnState)? TRUE:FALSE)];
			if([sender indexOfSelectedItem]==0){ //Ajout
				if(_propertyCol_inEdit){
					PMCTableauCol * ncol = [[PMCTableauCol alloc] init];
					//NSLog(@"New Col : %@", ncol);
					[_tmpArrayObjet addObject:ncol];
				}else if(_propertyRow_inEdit){
					PMCTableauRow * nrow = [[PMCTableauRow alloc] init];
					//NSLog(@"New Row : %@", nrow);
					[_tmpArrayObjet addObject:nrow];
				}
				[property_Array_ColRowList reloadData];
			}else{ //suppression
				_tmpLastIndexObj=-1;
				[_tmpArrayObjet removeObjectAtIndex:[property_Array_ColRowList selectedRow]];
				[property_Array_ColRowList deselectAll:sender];
				[property_Array_ColRowList reloadData];
			}
		}
	}
	
	#pragma mark properties_VC : Exented Array : Column
	/* Extended Properties for Array (Column Properties) */
	if(sender == property_Array_Col_Name){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setName:[sender stringValue]];
			}
		}
	}
	if(sender == property_Array_Col_Width){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setColWidth:[sender intValue]];
				[self checkColumnBounds];
				[property_Array_Col_Width_Stepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Col_Width_Stepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setColWidth:[sender intValue]];
				[self checkColumnBounds];
				[property_Array_Col_Width setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Col_Align){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setDataAlign:[sender selectedSegment]];
			}
		}
	}
	if(sender == property_Array_Col_Data){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setData:[sender stringValue]];
			}
		}
	}
	if(sender == property_Array_Col_HAlign){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setHeaderAlign:[sender selectedSegment]];
			}
		}
	}
	if(sender == property_Array_Col_HData){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setHeaderData:[sender stringValue]];
			}
		}
	}
	if(sender == property_Array_Col_BEnable){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderRightVisible:([sender state]==NSOnState)? TRUE:FALSE];
			}
		}
	}
	if(sender == property_Array_Col_BWidth){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderRightWidth:[sender intValue]];
				[property_Array_Col_BWidthStepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Col_BWidthStepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderRightWidth:[sender intValue]];
				[property_Array_Col_BWidth setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Col_BColor){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyCol_inEdit){
				PMCTableauCol * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderRightColor:[sender color]];
			}
		}
	}
	
	#pragma mark properties_VC : Exented Array : Row
	/* Extended Properties for Array (Row Properties) */
	
	if(sender == property_Array_Row_Name){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setName:[sender stringValue]];
			}
		}
	}
	if(sender == property_Array_Row_Height){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setHauteurLigne:[sender intValue]];
				[property_Array_Row_Height_Stepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_Height_Stepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setHauteurLigne:[sender intValue]];
				[property_Array_Row_Height setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_Type){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setGenre:[sender stringValue]];
			}
		}
	}
	if(sender == property_Array_Row_BGEnable){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBackgroundVisible:([sender state]==NSOnState)? TRUE:FALSE];
			}
		}
	}
	if(sender == property_Array_Row_BGColor){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setColorBG:[sender color]];
			}
		}
	}
	if(sender == property_Array_Row_Font){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setFontSize:[sender indexOfSelectedItem]];
			}
		}
	}
	if(sender == property_Array_Row_FontSize){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setFontSize:[sender intValue]];
				[property_Array_Row_FontSize_Stepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_FontSize_Stepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setFontSize:[sender intValue]];
				[property_Array_Row_FontSize setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_FontColor){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setFontColor:[sender color]];
			}
		}
	}
	if(sender == property_Array_Row_BTopEnable){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderTopVisible:([sender state]==NSOnState)? TRUE:FALSE];
			}
		}
	}
	if(sender == property_Array_Row_BTopWidth){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderTopWidth:[sender intValue]];
				[property_Array_Row_BTopWidth_Stepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_BTopWidth_Stepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderTopWidth:[sender intValue]];
				[property_Array_Row_BTopWidth setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_BTopColor){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderTopColor:[sender color]];
			}
		}
	}
	if(sender == property_Array_Row_BBEnable){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderBottomVisible:([sender state]==NSOnState)? TRUE:FALSE];
			}
		}
	}
	if(sender == property_Array_Row_BBWidth){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderBottomWidth:[sender intValue]];
				[property_Array_Row_BBWidth_Stepper setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_BBWidth_Stepper){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderBottomWidth:[sender intValue]];
				[property_Array_Row_BBWidth setIntValue:[sender intValue]];
			}
		}
	}
	if(sender == property_Array_Row_BBColor){ 
		if(obj && _tmpArrayObjet && _tmpLastIndexObj>-1){
			if(_propertyRow_inEdit){
				PMCTableauRow * obj2 = [_tmpArrayObjet objectAtIndex:_tmpLastIndexObj];
				[obj2 setBorderBottomColor:[sender color]];
			}
		}
	}
	
	[_actualPage setNeedsDisplay:YES];
	[ol_ObjectTableView reloadData];
	if(_propertyCol_inEdit || _propertyRow_inEdit) [property_Array_ColRowList reloadData];
}


- (IBAction)openSheetColSetting:(id)sender{
	
	//Vérifie qu'il y a bien un objet sélectionné
	if([_actualPage getSelectedObjectIndex]<0) return;
	
	//recherche l'objet sélectionné
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	
	//vérifie que c'est bien une PMCTableau
	if(![[obj className] isEqualToString:@"PMCTableau"]) return;
	
	// Indique quel type de données sont éditées
	_propertyCol_inEdit = TRUE;
	_propertyRow_inEdit = FALSE;
	
	[self disableColProperties];
	
	//NSLog(@"Object : %@", obj);
	//NSLog(@"Object columnDef : %@", [obj columnDef]);
	//NSLog(@"Class Name : %@", [[obj columnDef] className]);
	
	// renseigne le tableau remporaire (en copieur le contenue)
	_tmpArrayObjet = [[NSMutableArray alloc] initWithArray:[obj columnDef] copyItems:TRUE];
	//NSLog(@"_tmpArrayObjet = %@",_tmpArrayObjet);
	
	//Met la vue des propriétés en place
	PMCFippedView * v = [[PMCFippedView alloc] initWithFrame:[property_Array_ColView frame]];
	[v addSubview:property_Array_ColView];
	[property_Array_ColRowZone setDocumentView:v];
	
	//recharge la liste
	[property_Array_ColRowList reloadData];
	if([_tmpArrayObjet count]>0) [property_Array_ColRowList selectRow:0 byExtendingSelection:NO];
	//ouvre la fenêtre
	[NSApp beginSheet:property_Array_ColRowWin modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
}


- (IBAction)openSheetRowSetting:(id)sender{
	
	//Vérifie qu'il y a bien un objet sélectionné
	if([_actualPage getSelectedObjectIndex]<0) return;
	
	//recherche l'objet sélectionné
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	
	//vérifie que c'est bien une PMCTableau
	if(![[obj className] isEqualToString:@"PMCTableau"]) return;
	
	// Indique quel type de données sont éditées
	_propertyCol_inEdit = FALSE;
	_propertyRow_inEdit = TRUE;
	
	[self disableRowProperties];
	
	// renseigne le tableau remporaire (en copieur le contenue)
	_tmpArrayObjet = [[NSMutableArray alloc] initWithArray:[obj rowDef] copyItems:TRUE];
	//NSLog(@"_tmpArrayObjet = %@",_tmpArrayObjet);
	
	//Met la vue des propriétés en place
	PMCFippedView * v = [[PMCFippedView alloc] initWithFrame:[property_Array_RowView frame]];
	[v addSubview:property_Array_RowView];
	[property_Array_ColRowZone setDocumentView:v];
	
	//recharge la liste
	[property_Array_ColRowList reloadData];
	if([_tmpArrayObjet count]>0) [property_Array_ColRowList selectRow:0 byExtendingSelection:NO];
	
	//ouvre la fenêtre
	[NSApp beginSheet:property_Array_ColRowWin modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
}

- (IBAction)propertySheetColRowOK:(id)sender{
	//Vérifie qu'il y a bien un objet sélectionné
	if([_actualPage getSelectedObjectIndex]<0) return;
	//recherche l'objet sélectionné
	id obj = [_actualPage getObjectAtIndex:[_actualPage getSelectedObjectIndex]];
	
	//NSLog(@"propertySheetColRowOK !");
	if(_propertyCol_inEdit){
		//NSLog(@"_propertyCol_inEdit");
		
		//vérifie que c'est bien une PMCTableau
		if([[obj className] isEqualToString:@"PMCTableau"]){
			[obj setColumnDef:_tmpArrayObjet];
			//NSLog(@"%@",obj);
			[_tmpArrayObjet release];
			_tmpArrayObjet=nil;
			_tmpLastIndexObj=-1;
			[property_Array_ColRowList deselectAll:sender];
		}
		
		
	}else if(_propertyRow_inEdit){
		//NSLog(@"_propertyRow_inEdit");			
		//vérifie que c'est bien une PMCTableau
		if([[obj className] isEqualToString:@"PMCTableau"]){
			[obj setRowDef:_tmpArrayObjet];
			//NSLog(@"%@",obj);
			[_tmpArrayObjet release];
			_tmpArrayObjet=nil;
			_tmpLastIndexObj=-1;
			[property_Array_ColRowList deselectAll:sender];
		}
		
		
	}
	
	int nb = [[obj columnDef] count];
	if(nb<2) [property_Array_col_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleColButton",@"Localizable",@"Other"),nb]];
	if(nb>1) [property_Array_col_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleColsButton",@"Localizable",@"Other"),nb]];
	nb = [[obj rowDef] count];
	if(nb<2) [property_Array_row_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleRowButton",@"Localizable",@"Other"),nb]];
	if(nb>1) [property_Array_row_button setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"TitleRowsButton",@"Localizable",@"Other"),nb]];
	
	_propertyCol_inEdit = FALSE;
	_propertyRow_inEdit = FALSE;
	[property_Array_ColRowWin orderOut:sender];
	[NSApp endSheet:property_Array_ColRowWin returnCode:1];
}

- (IBAction)propertySheetColRowCancel:(id)sender{
	[_tmpArrayObjet release];
	_propertyCol_inEdit = FALSE;
	_propertyRow_inEdit = FALSE;
	[property_Array_ColRowWin orderOut:sender];
	[NSApp endSheet:property_Array_ColRowWin returnCode:2];
}


- (IBAction)exportToModel:(id)sender{
	
	NSSavePanel * panel = [NSSavePanel savePanel];
	[panel setCanCreateDirectories:YES];
	[panel setTitle:@"Export..."];
	[panel setPrompt:@"Export"];
	[panel setNameFieldLabel:@"Export to :"];
	[panel setRequiredFileType:@"xmlpm"];
	[panel setCanSelectHiddenExtension:YES];
	NSMutableArray * ar = [[NSMutableArray alloc] init];
	[ar addObject:@"xmlpm"];
	[panel setAllowedFileTypes:ar];
	//[panel setDirectory:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent]];
	
	NSString * proposedName = [[[[[self fileURL] absoluteString] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"xmlpm"];
	
	//[panel setMessage:@"Please select destination and name for export model :"];
	if([panel runModalForDirectory:[[[self fileURL] absoluteString] stringByDeletingLastPathComponent] file:proposedName]!=NSOKButton) return;
	
	NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"xmlpm"];
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
	[_page1 exportToModel:premiereNode];
	
	
	NSXMLElement *autreNode = [NSXMLNode elementWithName:@"autre"];
	[pagesNode addChild:autreNode];
	[autreNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_otherPage)? @"1":@"0")]];
	[_page2 exportToModel:autreNode];
	
	
	NSXMLElement *derniereNode = [NSXMLNode elementWithName:@"derniere"];
	[pagesNode addChild:derniereNode];
	[derniereNode addAttribute:[NSXMLNode attributeWithName:@"active" stringValue:((_lastPage)? @"1":@"0")]];
	[_page3 exportToModel:derniereNode];
	
	
	NSData * data = [xmlDoc XMLDataWithOptions:NSXMLDocumentTidyXML];
	[data writeToFile:[panel filename] atomically:YES];
	
	
	//NSLog(@"%@", [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
	
}


- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contectInfo{
	
}


@end
