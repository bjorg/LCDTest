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

#import "GuideControl.h"
#import "FullscreenWindow.h"
#import "PatternDescriptor.h"

/*
 * Property List Keys
 */
static NSString* ATTRIBUTES_KEY = @"Attributes";
static NSString* DEVICES_KEY = @"Devices";
static NSString* PATTERNS_KEY = @"Patterns";
static NSString* KEY_KEY = @"Key";
static NSString* ACTIVE_KEY = @"Active";
static NSString* CLASS_KEY = @"Class";
static NSString* DESCRIPTION_RTF_FILE_KEY = @"DescriptionRtfFile";
static NSString* TITLE_KEY = @"Title";
static NSString* DESCRIPTION_KEY = @"Description";

@implementation GuideControl

/*
 * Private Methods
 */
- (void)loadRTFFileFromMainBundle:(NSString*)name {
	
	// check if a valid name was provided
	if(name && ![name isEqualToString:@""]) {
		
		// compute path to bundle
		NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"rtf"];
		
		// load RTF file from path 
		NSAttributedString* contents = [[NSAttributedString alloc] initWithPath:path documentAttributes:nil];
		
		// replace text view contents
		[testDescription setString:@""];
		[testDescription replaceCharactersInRange:NSMakeRange(0, 0) withRTF:[contents RTFFromRange: NSMakeRange(0, [contents length]) documentAttributes:nil]];
	} else {
		[testDescription setString:@"(no description)"];
	}
}

- (void)showTestPattern:(NSView*)pattern {
	
	// create the test window with the test pattern
	FullscreenWindow* test_window = [[FullscreenWindow alloc] initWithView:pattern onScreen:[window screen]];
	
	// display the window
	[test_window setReleasedWhenClosed:YES];
	[test_window makeKeyAndOrderFront:nil];
}

- (void)selectedPatternChanged:(NSNotification*)notificaiton {
	
	// stop the preview timer
	if(timer) {
		[timer invalidate];
		[timer release];
		timer = nil;
	}
	
	// remove preview
	if(preview_pattern) {
		[preview_pattern removeFromSuperview];
		[preview_pattern release];
		preview_pattern = nil;
	}
	
	int row = [testList selectedRow];
	if((row >= 0) && (row < [filtered_row_list count])) {
		[button setTitle:@"Show"];
		
		// show description
		PatternDescriptor* pattern = [filtered_row_list objectAtIndex:row];
		[self loadRTFFileFromMainBundle:[pattern descriptionFile]];
		
		// show preview
		preview_pattern = [pattern createPatternView];
		if(!preview_pattern) {
			NSLog(@"unable to create pattern preview (%@)", [pattern title]);
			[NSApp terminate:nil];
		}
		[preview_pattern initWithFrame:[preview_placeholder frame] asPreview:YES];
		[[preview_placeholder superview] addSubview:preview_pattern];
		
		// create the preview timer
		timer = [[NSTimer scheduledTimerWithTimeInterval:2.0
												  target:self
												selector:@selector(nextPatternState)
												userInfo:nil
												 repeats:YES] retain];
	} else {
		[button setTitle:@"Quit"];
		[self loadRTFFileFromMainBundle:nil];
	}
}

- (void)nextPatternState {
	if(preview_pattern) {
		[preview_pattern nextState];
	}
}

- (int)convertAttributesToFlags:(NSArray*)attributes {
	int result = 0;
	int index;
	for(index = 0; index < [attributes count]; ++index) {
		NSNumber* flag = [attribute_to_flag_map objectForKey:[attributes objectAtIndex:index]];
		if(flag) {
			result |= [flag intValue];
		}
	}
	return result;
}

- (void)readConfiguration {
	
	// compute path to bundle
	NSString* path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
	NSString *error;
	NSPropertyListFormat format;
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSDictionary* config = [NSPropertyListSerialization propertyListFromData:data
														   mutabilityOption:NSPropertyListImmutable
																	 format:&format
														   errorDescription:&error];
	if(!config) {
		NSLog(@"unable to load configuration property list (reason: %@)", error);
		[error release];
		
		// TODO: show error dialog
		
		[NSApp terminate:nil];
	}
	NSArray* attributes = [config objectForKey:ATTRIBUTES_KEY];
	NSArray* devices = [config objectForKey:DEVICES_KEY];
	NSArray* patterns = [config objectForKey:PATTERNS_KEY];
	if(!attributes || !devices || !patterns) {
		NSLog(@"unable to read configuration attributes, devices, or patterns");
		
		// TODO: show error dialog
		
		[NSApp terminate:nil];
	}
	
	// create attribute to flag conversion map
	int index;
	int flag = 1;
	attribute_to_flag_map = [[NSMutableDictionary alloc] init];
	for(index = 0; index < [attributes count]; ++index) {
		NSDictionary* entry = [attributes objectAtIndex:index];
		NSString* attribute = [entry objectForKey:KEY_KEY];
		if(attribute) {
			[attribute_to_flag_map setObject:[NSNumber numberWithInt:flag] forKey:attribute];
			flag <<= 1;
		}
	}
	
	// create patterns
	pattern_list = [[NSMutableArray array] retain];
	for(index = 0; index < [patterns count]; ++index) {
		NSDictionary* pattern = [patterns objectAtIndex:index];
		if([[pattern objectForKey:ACTIVE_KEY] boolValue]) {
			NSString* cls = [pattern objectForKey:CLASS_KEY];
			NSString* rtf = [pattern objectForKey:DESCRIPTION_RTF_FILE_KEY];
			NSString* title = [pattern objectForKey:TITLE_KEY];
			NSArray* attrs = [pattern objectForKey:ATTRIBUTES_KEY];
			int flags = [self convertAttributesToFlags:attrs];
			[pattern_list addObject:[PatternDescriptor patternWithClassName:cls title:title descriptionFile:rtf flags:flags]];
		}
	}

	// initialize display menu
	[displayDevice removeAllItems];
	device_flags_list = [[NSMutableArray array] retain];
	for(index = 0; index < [devices count]; ++index) {
		NSString* description = [[devices objectAtIndex:index] objectForKey:DESCRIPTION_KEY];
		NSArray* attrs = [[devices objectAtIndex:index] objectForKey:ATTRIBUTES_KEY];
		[displayDevice addItemWithTitle:description];
		int flags = [self convertAttributesToFlags:attrs];
		[device_flags_list addObject:[NSNumber numberWithInt:flags]];
	}
}

/*
 * Data Source Methods
 */
- (int)numberOfRowsInTableView:(NSTableView *)table {
	
	// create a new array
	[filtered_row_list release];
	filtered_row_list = [[NSMutableArray array] retain];
	
	// determine the device specific flags
	int device = [displayDevice indexOfSelectedItem];
	int flags = [[device_flags_list objectAtIndex:device] intValue];
	
	// count the number of test which use that flag
	unsigned int index = 0;
	for(index = 0; index < [pattern_list count]; ++index) {
		if([[pattern_list objectAtIndex:index] isVisibleForFlags:flags]) {
			[filtered_row_list addObject:[pattern_list objectAtIndex:index]];
		}
	}
	return [filtered_row_list count];
}

- (id)tableView:(NSTableView*)table objectValueForTableColumn:(NSTableColumn*)column row:(int)row {
	return [[filtered_row_list objectAtIndex:row] title];
}

/*
 * Overriden Methods
 */
- (void)awakeFromNib {
	[self readConfiguration];
	
	// subscribe to change notification
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(selectedPatternChanged:)
												 name:@"NSTableViewSelectionDidChangeNotification" 
											   object:testList];
		
	// make initial selection
	[self selectDevice:self];
}

- (IBAction)windowWillClose:(id)sender {
	
	// destroy timer
	if(timer) {
		[timer invalidate];
		[timer release];
		timer = nil;
	}
	
	// remove preview
	if(preview_pattern) {
		[preview_pattern removeFromSuperview];
		[preview_pattern release];
		preview_pattern = nil;
	}
	
	// terminate application
    [NSApp terminate:nil];
}

/*
 * Public Methods
 */
- (IBAction)selectDevice:(id)sender {
	[testList deselectAll:self];
	[testList reloadData];
	if([filtered_row_list count] > 0) {
		[testList selectRow:0 byExtendingSelection:NO];
	}
}

- (IBAction)showPattern:(id)sender {
	
	// check which pattern was selected, if any
	int current_row = [testList selectedRow];
	if(current_row != -1) {
		
		// show selected pattern
		PatternDescriptor* pattern = [filtered_row_list objectAtIndex:[testList selectedRow]];
		NSView* view = [pattern createPatternView];
		if(!view) {
			NSLog(@"unable to create pattern view (%@)", [pattern title]);
			[NSApp terminate:nil];
		}
		[self showTestPattern:view];
		
		// select next pattern, if one exists
		int next_row = [testList selectedRow] + 1;
		if(next_row < [filtered_row_list count]) {
			[testList selectRow:next_row byExtendingSelection:NO];
		} else {
			[testList deselectAll:self];
		}
	} else {
		[window close];
	}
}

@end
