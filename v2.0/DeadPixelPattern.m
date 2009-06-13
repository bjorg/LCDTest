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

#import "DeadPixelPattern.h"


@implementation DeadPixelPattern

- (void)drawRect:(NSRect)rect {

	// NOTE: this method draws a solid background in different colors.
	
	// check current state to determine the color to display
	switch(state) {
		default:
			state = 0;
			
			// FALL THROUGH
			
		case 0:
			[[NSColor redColor] set];
			break;
		case 1:
			[[NSColor blueColor] set];
			break;
		case 2:
			[[NSColor greenColor] set];
			break;
		case 3:
			[[NSColor cyanColor] set];
			break;
		case 4:
			[[NSColor magentaColor] set];
			break;
		case 5:
			[[NSColor yellowColor] set];
			break;
		case 6:
			[[NSColor whiteColor] set];
			break;
		case 7:
			[[NSColor grayColor] set];
			break;
		case 8:
			[[NSColor blackColor] set];
			break;
	}
	
	// repaint the whole region
    NSRectFill([self bounds]);
}

@end
