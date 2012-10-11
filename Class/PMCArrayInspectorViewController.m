#import "PMCArrayInspectorViewController.h"
#import "PMCTableau.h"
#import "PMCFippedView.h"


@implementation PMCArrayInspectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSheetNotification:) name:@"openColSheet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSheetNotification:) name:@"openRowSheet" object:nil];
    //NSLog(@"INIT : PMCArrayInspectorViewController");
    return self;
}

- (void) openSheetNotification:(NSNotification *)notification{
    //NSLog(@"Notification : %@",notification);
    if([[notification name] isEqualToString:@"openColSheet"]){
        [self openSheetColSetting:self];
    }
    if([[notification name] isEqualToString:@"openRowSheet"]){
        [self openSheetRowSetting:self];
    }
}

/*
 * Vérifie que la largeur cumulé de toutes les colonnes ne dépasse pas la largeur du tableau.
 * Affiche la largeur en rouge dans le cas ou cela dépasse.
 */
- (void)checkColumnBounds{
	/*int i;
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
	 */
}


- (IBAction)openSheetColSetting:(id)sender{
	
	//Vérifie qu'il y a bien un objet sélectionné
	if([[self representedObject] isEqualTo:[NSNull null]]) return;
	
	// Indique quel type de données sont éditées
	_propertyCol_inEdit = TRUE;
	_propertyRow_inEdit = FALSE;
	
	
	[[property_Array_ColRowList tableColumnWithIdentifier:@"col"] unbind:@"value"];
	[[property_Array_ColRowList tableColumnWithIdentifier:@"col"] bind:@"value" toObject:colArrayController withKeyPath:@"arrangedObjects.name" options:nil];
	
	//Met la vue des propriétés en place
	PMCFippedView * v = [[PMCFippedView alloc] initWithFrame:[property_Array_ColView frame]];
	[v addSubview:property_Array_ColView];
	[property_Array_ColRowZone setDocumentView:v];
	[v release];
	//recharge la liste
	//[property_Array_ColRowList reloadData];
	//if([_tmpArrayObjet count]>0) [property_Array_ColRowList selectRow:0 byExtendingSelection:NO];
	//ouvre la fenêtre
	NSWindow* mainWindow = [NSApp mainWindow];
	NSDocument* doc = [[mainWindow windowController] document];
	[NSApp beginSheet:property_Array_ColRowWin modalForWindow:[doc windowForSheet] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
}


- (IBAction)openSheetRowSetting:(id)sender{
	//Vérifie qu'il y a bien un objet sélectionné
	if([[self representedObject] isEqualTo:[NSNull null]]) return;
	
	// Indique quel type de données sont éditées
	_propertyCol_inEdit = FALSE;
	_propertyRow_inEdit = TRUE;
	
	
	[[property_Array_ColRowList tableColumnWithIdentifier:@"col"] unbind:@"value"];
	[[property_Array_ColRowList tableColumnWithIdentifier:@"col"] bind:@"value" toObject:rowArrayController withKeyPath:@"arrangedObjects.name" options:nil];
	
	//Met la vue des propriétés en place
	PMCFippedView * v = [[PMCFippedView alloc] initWithFrame:[property_Array_RowView frame]];
	[v addSubview:property_Array_RowView];
	[property_Array_ColRowZone setDocumentView:v];
	[v release];
	//recharge la liste
	//[property_Array_ColRowList reloadData];
	//if([_tmpArrayObjet count]>0) [property_Array_ColRowList selectRow:0 byExtendingSelection:NO];
	//ouvre la fenêtre
	NSWindow* mainWindow = [NSApp mainWindow];
	NSDocument* doc = [[mainWindow windowController] document];
	[NSApp beginSheet:property_Array_ColRowWin modalForWindow:[doc windowForSheet] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
		
}

- (IBAction)propertySheetColRowClose:(id)sender{
	/*
	[_tmpArrayObjet release];
	 */
	_propertyCol_inEdit = FALSE;
	_propertyRow_inEdit = FALSE;
	[property_Array_ColRowWin orderOut:sender];
	[NSApp endSheet:property_Array_ColRowWin returnCode:2];
}


- (IBAction)addDelRowCol:(id)sender{
	if([sender indexOfSelectedItem]==0){ //Ajout
		
		NSWindow* mainWindow = [NSApp mainWindow];
		NSDocument* doc = [[mainWindow windowController] document];
		
		if(_propertyCol_inEdit){
			PMCTableauCol * ncol = [[PMCTableauCol alloc] init];
			[ncol setUndoManager:[doc undoManager]];
			//NSLog(@"New Col : %@", ncol);
			[colArrayController addObject:ncol];
            [ncol release];
			
		}else if(_propertyRow_inEdit){
			PMCTableauRow * nrow = [[PMCTableauRow alloc] init];
			[nrow setUndoManager:[doc undoManager]];
			//NSLog(@"New Row : %@", nrow);
			[rowArrayController addObject:nrow];
			[nrow release];
			
		}
		
	}else{ //suppression
		if(_propertyCol_inEdit)
			[colArrayController removeObjectsAtArrangedObjectIndexes:[colArrayController selectionIndexes]];
		else if(_propertyRow_inEdit)
			[rowArrayController removeObjectsAtArrangedObjectIndexes:[rowArrayController selectionIndexes]];
	}
	

}


- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contectInfo{
	//NSLog(@"Fin d'edition du tableau !");
	//[[self representedObject] didChangeValueForKey:FigureDrawingContentsKey];
}

@end
