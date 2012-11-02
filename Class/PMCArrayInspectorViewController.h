//
//  PMCArrayInspectorViewController.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 04/03/10.
//  Copyright 2010 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCPaletteInspectorViewController.h"
#import "PMCPropertiesView.h"

@class PMCBook;

@interface PMCArrayInspectorViewController : PMCPaletteInspectorViewController {
	
	IBOutlet NSArrayController * colArrayController;
	IBOutlet NSArrayController * rowArrayController;
	
	/* Array Properties */
	IBOutlet NSButton * property_Array_col_button;
	IBOutlet NSButton * property_Array_row_button;
	
	/* Extended Properties for Array */
	IBOutlet NSWindow * property_Array_ColRowWin;
	IBOutlet NSView * property_Array_ColView;
	IBOutlet NSView * property_Array_RowView;
	IBOutlet NSTableView * property_Array_ColRowList;
	IBOutlet NSScrollView * property_Array_ColRowZone;
	IBOutlet NSSegmentedControl * property_Array_ColRowAddRemove;
	IBOutlet NSButton * property_Array_ColRowClose;
	
	/* Extended Properties for Array (Column Properties) */
	IBOutlet NSTextField * property_Array_Col_Name;
	IBOutlet NSTextField * property_Array_Col_Width;
	IBOutlet NSStepper * property_Array_Col_Width_Stepper;
	IBOutlet NSSegmentedControl * property_Array_Col_Align;
	IBOutlet NSTextField * property_Array_Col_Data;
	IBOutlet NSSegmentedControl * property_Array_Col_HAlign;
	IBOutlet NSTextField * property_Array_Col_HData;
	IBOutlet NSButton * property_Array_Col_BEnable;
	IBOutlet NSTextField * property_Array_Col_BWidth;
	IBOutlet NSStepper * property_Array_Col_BWidthStepper;
	IBOutlet NSColorWell * property_Array_Col_BColor;
	
	/* Extended Properties for Array (Row Properties) */
	IBOutlet NSTextField * property_Array_Row_Name;
	IBOutlet NSTextField * property_Array_Row_Height;
	IBOutlet NSStepper * property_Array_Row_Height_Stepper;
	IBOutlet NSTextField * property_Array_Row_Type;
	IBOutlet NSButton * property_Array_Row_BGEnable;
	IBOutlet NSColorWell * property_Array_Row_BGColor;
	IBOutlet NSPopUpButton * property_Array_Row_Font;
	IBOutlet NSTextField * property_Array_Row_FontSize;
	IBOutlet NSStepper * property_Array_Row_FontSize_Stepper;
	IBOutlet NSColorWell * property_Array_Row_FontColor;
	IBOutlet NSButton * property_Array_Row_BTopEnable;
	IBOutlet NSTextField * property_Array_Row_BTopWidth;
	IBOutlet NSStepper * property_Array_Row_BTopWidth_Stepper;
	IBOutlet NSColorWell * property_Array_Row_BTopColor;
	IBOutlet NSButton * property_Array_Row_BBEnable;
	IBOutlet NSTextField * property_Array_Row_BBWidth;
	IBOutlet NSStepper * property_Array_Row_BBWidth_Stepper;
	IBOutlet NSColorWell * property_Array_Row_BBColor;
	
	
	BOOL _propertyCol_inEdit;
	BOOL _propertyRow_inEdit;
	
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void) openSheetNotification:(NSNotification *)notification;

- (IBAction)openSheetColSetting:(id)sender;
- (IBAction)openSheetRowSetting:(id)sender;
- (IBAction)propertySheetColRowClose:(id)sender;

- (IBAction)addDelRowCol:(id)sender;

- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contectInfo;

@end
