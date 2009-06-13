// Copyright 2004, 2005 Steve Bjorg
//
// This file is part of LCDTest.
// 
// LCDTest is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// LCDTest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with LCDTest; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#import <Cocoa/Cocoa.h>
#import "PatternView.h"

@interface GuideControl : NSObject {
	
	// outlets
    IBOutlet NSPopUpButton* displayDevice;
    IBOutlet NSTextView* testDescription;
    IBOutlet NSTableView* testList;
	IBOutlet NSWindow* window;
	IBOutlet NSButton* button;
	IBOutlet NSView* preview_placeholder;
	
	// controller state
	NSMutableArray* pattern_list;
	NSMutableArray* filtered_row_list;
	NSMutableArray* device_flags_list;
	NSMutableDictionary* attribute_to_flag_map;
	PatternView* preview_pattern;
	NSTimer* timer;
}

// event handling
- (IBAction)selectDevice:(id)sender;
- (IBAction)showPattern:(id)sender;

@end
