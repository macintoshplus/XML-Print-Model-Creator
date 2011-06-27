//
//  PMCModelEditor.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

/*
 main_	: fenêtre document
 ol_	: objet contenu dans la vue ObjectList
 tool_	: objet pour les outils
 */

#import <Cocoa/Cocoa.h>
#import "PMCPages.h"
#import "PMCTrait.h"
#import "PMCRectangle.h"
#import "PMCText.h"
#import "PMCTableau.h"
#import "PMCFippedView.h"


@interface PMCModelEditor : NSDocument
{
	IBOutlet NSView *main_ObjectListView;
	IBOutlet NSView *main_DocPropertyView;
	IBOutlet NSView *main_BGAndBorderPropertyView;
	IBOutlet NSView *main_LinePropertyView;
	IBOutlet NSView *main_RectanglePropertyView;
	IBOutlet NSView *main_TextPropertyView;
	IBOutlet NSView *main_ImgPropertyView;
	IBOutlet NSView *main_ArrayPropertyView;
	
	IBOutlet NSView *main_SizePropertyView;
	IBOutlet NSView *main_FontPropertyView;
	
    IBOutlet NSSplitView *main_SplitVertical;
    //IBOutlet NSSplitView *main_SplitPropertyVertical;
    IBOutlet NSScrollView *main_ScroolView;
    IBOutlet NSScrollView *main_ScroolPropertyView;
	IBOutlet NSView * tool_ZoomView;
	IBOutlet NSPopUpButton * tool_ZoomMenu;
	IBOutlet NSPopUpButton * ol_PageSelector;
	IBOutlet NSTableView * ol_ObjectTableView;
	
	/* Document Properties */
	IBOutlet NSPopUpButton * property_doc_format;
	IBOutlet NSPopUpButton * property_doc_orientation;
	IBOutlet NSButton * property_doc_fistPage;
	IBOutlet NSButton * property_doc_otherPage;
	IBOutlet NSButton * property_doc_lastPage;
	IBOutlet NSButton * property_doc_enabledPagination;
	IBOutlet NSTextField * property_doc_formatPagination;
	IBOutlet NSTextField * property_doc_xPagination;
	IBOutlet NSTextField * property_doc_yPagination;
	IBOutlet NSStepper * property_doc_xPaginationStepper;
	IBOutlet NSStepper * property_doc_yPaginationStepper;
	
	/* Font Properties */
	IBOutlet NSPopUpButton * property_font_name;
	IBOutlet NSTextField * property_font_size;
	IBOutlet NSStepper * property_font_sizeStepper;
	IBOutlet NSColorWell * property_font_color;
	IBOutlet NSButton * property_font_bold;
	IBOutlet NSButton * property_font_italic;
	IBOutlet NSButton * property_font_underline;
	IBOutlet NSSegmentedControl * property_font_align;
	
	/* Size Properties */
	IBOutlet NSTextField * property_size_x;
	IBOutlet NSTextField * property_size_y;
	IBOutlet NSStepper * property_size_xStepper;
	IBOutlet NSStepper * property_size_yStepper;
	IBOutlet NSTextField * property_size_width;
	IBOutlet NSTextField * property_size_height;
	IBOutlet NSStepper * property_size_widthStepper;
	IBOutlet NSStepper * property_size_heightStepper;
	
	/* Backgound and Border Properties */
	IBOutlet NSButton * property_BGB_BGVisible;
	IBOutlet NSColorWell * property_BGB_BGColor;
	IBOutlet NSButton * property_BGB_TopVisible;
	IBOutlet NSColorWell * property_BGB_TopColor;
	IBOutlet NSButton * property_BGB_RightVisible;
	IBOutlet NSColorWell * property_BGB_RightColor;
	IBOutlet NSButton * property_BGB_BottomVisible;
	IBOutlet NSColorWell * property_BGB_BottomColor;
	IBOutlet NSButton * property_BGB_LeftVisible;
	IBOutlet NSColorWell * property_BGB_LeftColor;
	IBOutlet NSTextField * property_BGB_BorderWidth;
	IBOutlet NSStepper * property_BGB_BorderWidthStepper;
	
	/* Line Properties */
	IBOutlet NSButton * property_line_visible;
	IBOutlet NSTextField * property_line_name;
	IBOutlet NSColorWell * property_line_color;
	IBOutlet NSPopUpButton * property_line_styles;
	
	/* Text Properties */
	IBOutlet NSButton * property_Text_visible;
	IBOutlet NSTextField * property_Text_name;
	IBOutlet NSTextField * property_Text_value;
	
	/* Rect Properties */
	IBOutlet NSButton * property_Rect_visible;
	IBOutlet NSTextField * property_Rect_name;
	
	/* Array Properties */
	IBOutlet NSButton * property_Array_visible;
	IBOutlet NSTextField * property_Array_name;
	IBOutlet NSButton * property_Array_col_button;
	IBOutlet NSButton * property_Array_row_button;
	IBOutlet NSButton * property_Array_repeat;
	IBOutlet NSTextField * property_Array_top_other;
	IBOutlet NSTextField * property_Array_height_other;
	IBOutlet NSButton * property_Array_header;
	IBOutlet NSButton * property_Array_header_repeat;
	IBOutlet NSTextField * property_Array_dataSource;
	
	/* Extended Properties for Array */
	IBOutlet NSWindow * property_Array_ColRowWin;
	IBOutlet NSView * property_Array_ColView;
	IBOutlet NSView * property_Array_RowView;
	IBOutlet NSTableView * property_Array_ColRowList;
	IBOutlet NSScrollView * property_Array_ColRowZone;
	IBOutlet NSSegmentedControl * property_Array_ColRowAddRemove;
	IBOutlet NSButton * property_Array_ColRowOK;
	IBOutlet NSButton * property_Array_ColRowCancel;
	
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
	
	/* END PROPERTIES */
	
	/*
	 * Variable contenant la liste des polices disponible et la liste des format papier et leur description.
	 */
	
	NSArray * _pageFormat;
	NSArray * _fontList;
	
	/*
	 * Variable d'instance pour le document.
	 * Ici les propriétés.
	 */
	
	int _format;
	int _orientation;
	
	BOOL _firstPage;
	BOOL _otherPage;
	BOOL _lastPage;
	
	NSString * _formatPagination;
	int _alignPagination;
	int _xPagination;
	int _yPagination;
	BOOL _enabledPagination;
	int _fontIndexPagination;
	int _fontSizePagination;
	NSColor * _colorFontPagination;
	BOOL _boldFontPagination;
	BOOL _italicFontPagination;
	BOOL _underlineFontPagination;
	
	/*
	 * Pointeur des 3 pages possibles en édition.
	 * La page en cour d'utilisation est accessible via le pointeur _actualPage
	 */
	PMCPages * _page1;
	PMCPages * _page2;
	PMCPages * _page3;
	PMCPages * _actualPage;
	
	/*
	 * Permet de déterminé qui est le type d'objet contenu dans le tableau temporaire et
	 * contitionne les modifications
	 */
	BOOL _propertyCol_inEdit;
	BOOL _propertyRow_inEdit;
	
	/*
	 * Ce tableau contien une copie du tableau contenan les lignes ou les colonnes d'un tableau.
	 * C'est une copie car il faut pouvoir annuler toutes les modifications effectué dans la feuille.
	 */
	NSMutableArray * _tmpArrayObjet;
	int _tmpLastIndexObj;
}

- (void)setSelectedObjectAtIndex:(int)index;
- (void)setPropertiesForSelectedObject;
- (void)setPropertiesForDocuments;
- (void)setPropertiesForSize;
- (void)setPropertiesForFont;
- (void)setPropertiesForLine;
- (void)setPropertiesForBGB;
- (void)setPropertiesForText;
- (void)setPropertiesForRect;
- (void)setPropertiesForArray;
- (void)readObjectAndSetArrayColRowProperties;
- (void)compareAndSaveArrayColRowProperties;
- (void)disableColProperties;
- (void)enableColProperties;
- (void)disableRowProperties;
- (void)enableRowProperties;
- (void)checkColumnBounds;
- (void)writeSelectedObjectToPasteboard:(NSPasteboard*)pb;
- (BOOL)readObjectFromPasteboard:(NSPasteboard*)pb;

- (void)objectTableViewSelectionChange:(NSNotification*)n;

- (IBAction)tool_ZoomChange:(id)sender;
- (IBAction)ol_PageChange:(id)sender;


- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)tool_NewLine:(id)sender;
- (IBAction)tool_NewRect:(id)sender;
- (IBAction)tool_NewText:(id)sender;
- (IBAction)tool_NewArray:(id)sender;
- (IBAction)tool_deleteSelectedObject:(id)sender;
- (IBAction)tool_orderUpSelectedObject:(id)sender;
- (IBAction)tool_orderDoubleUpSelectedObject:(id)sender;
- (IBAction)tool_orderDownSelectedObject:(id)sender;
- (IBAction)tool_orderDoubleDownSelectedObject:(id)sender;

- (IBAction)properties_valueChange:(id)sender;
- (IBAction)openSheetColSetting:(id)sender;
- (IBAction)openSheetRowSetting:(id)sender;
- (IBAction)propertySheetColRowOK:(id)sender;
- (IBAction)propertySheetColRowCancel:(id)sender;

- (IBAction)exportToModel:(id)sender;

- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contectInfo;

- (void)setInspectorForObject:(NSString*)name;

- (void)setFirstPage:(BOOL)val;
- (void)setOtherPage:(BOOL)val;
- (void)setLastPage:(BOOL)val;
- (void)setPageFormat:(int)val;
- (void)setPageOrientation:(int)val;
- (void)setPagination:(BOOL)val;
- (void)setFormatPagination:(NSString*)val;
- (void)setPaginationPositionX:(int)val;
- (void)setPaginationPositionY:(int)val;
- (void)setPaginationFont:(int)val;
- (void)setPaginationFontSize:(int)val;
- (void)setPaginationFontColor:(NSColor*)val;
- (void)setPaginationFontBold:(BOOL)val;
- (void)setPaginationFontItalic:(BOOL)val;
- (void)setPaginationFontUnderline:(BOOL)val;
- (void)setPaginationFontAlign:(int)val;

@end
