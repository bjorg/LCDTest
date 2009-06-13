// Copyright 2004 Steve Bjorg
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

#import "MainControl.h"
#import "FullscreenWindow.h"

@implementation MainControl

- (void)loadRTFFileFromMainBundle:(NSString*)name into:(NSTextView*)target {
	
	// compute path to bundle
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"rtf"];
	
	// load RTF file from path 
	NSAttributedString* contents = [[NSAttributedString alloc] initWithPath:path documentAttributes:nil];
	
	// replace text view contents
	[target replaceCharactersInRange:NSMakeRange(0, 0) withRTF:[contents RTFFromRange: NSMakeRange(0, [contents length]) documentAttributes:nil]];
}

- (void)awakeFromNib {
	[self loadRTFFileFromMainBundle:@"text_calibration" into:calibration];
	[self loadRTFFileFromMainBundle:@"text_pixels" into:pixels];
	[self loadRTFFileFromMainBundle:@"text_alignment" into:alignment];
	[self loadRTFFileFromMainBundle:@"text_gradients" into:gradients];
}

- (IBAction)showDeadPixels:(id)sender {
	NSLog(@"show dead pixels patterns");
	
	// create the test window with the dead-pixel test pattern
	FullscreenWindow* test_window = [[FullscreenWindow alloc] initDeadPixelsTestWithScreen:[window screen]];
	
	// display the window
	[test_window setReleasedWhenClosed:YES];
	[test_window makeKeyAndOrderFront:nil];
}

- (IBAction)showColorGradient:(id)sender {
	NSLog(@"show color gradient pattern");
	
	// create the test window with the color-gradient test pattern
	FullscreenWindow* test_window = [[FullscreenWindow alloc] initColorGradientTestWithScreen:[window screen]];
	
	// display the window
	[test_window setReleasedWhenClosed:YES];
	[test_window makeKeyAndOrderFront:nil];
}

- (IBAction)showCalibration:(id)sender {
	NSLog(@"show calibration pattern");
	
	// create the test window with the calibration test pattern
	FullscreenWindow* test_window = [[FullscreenWindow alloc] initCalibrationTestWithScreen:[window screen]];
	
	// display the window
	[test_window setReleasedWhenClosed:YES];
	[test_window makeKeyAndOrderFront:nil];
}

- (IBAction)showPanelAlignment:(id)sender {
	NSLog(@"show panel alignment patterns");
	
	// create the test window with the panel-alignment test pattern
	FullscreenWindow* test_window = [[FullscreenWindow alloc] initPanelAlignmentTestWithScreen:[window screen]];
	
	// display the window
	[test_window setReleasedWhenClosed:YES];
	[test_window makeKeyAndOrderFront:nil];
}

- (IBAction)windowWillClose:(id)sender {
    [NSApp terminate:nil];
}

@end
