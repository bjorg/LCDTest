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

#import "PanelAlignmentPattern.h"


@implementation PanelAlignmentPattern

- (void)drawRect:(NSRect)_rect {
	NSRect rect = [self bounds];
	
	// NOTE: this method draws a colored box on a black background; this pattern exhibits
	//		 alignment issues in multi-panel LCDs found in many projectors; the alignment
	//       error is shown by color bleeding on one or more of the rectangle's edges.
	
	// set the background to black
	[[NSColor blackColor] set];
	NSRectFill(rect);
	
	// check the current state to determine the color of the box
	switch(state) {
		default:
			state = 0;
			
			// FALL THROUGH
			
		case 0:
			[[NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:1.0] set];
			break;
		case 1:
			[[NSColor colorWithDeviceRed:1.0 green:0.0 blue:1.0 alpha:1.0] set];
			break;
		case 2:
			[[NSColor colorWithDeviceRed:0.0 green:1.0 blue:1.0 alpha:1.0] set];
			break;
		case 3:
			[[NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:1.0] set];
			break;
		case 4:
			[[NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
			break;
		case 5:
			[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0] set];
			break;
	}
	
	// compute the colored box boundaries and fill it with the chosen color
	rect.origin.x = rect.size.width / 4;
	rect.origin.y = rect.size.height / 4;
	rect.size.width /= 2;
	rect.size.height /= 2;
	NSRectFill(rect);
}

@end
