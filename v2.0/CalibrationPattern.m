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

#import "CalibrationPattern.h"


@implementation CalibrationPattern

- (void)drawRect:(NSRect)rect {
	NSRect vertical_rectangle = [self bounds];
	
	// NOTE: this method draws a black and white alternating vertical stripes; this
	//		 patterns exhibits errors in the phase and shift adjustments of the
	//		 analog-to-digital circuitry in LCDs.
	
	// loop over vertical rectangles
	int x_start;
	int x_end = vertical_rectangle.size.width;
	for(x_start = 0; x_start < x_end; ++x_start) {
		
		// compute vertical update rectangle
		NSRect vertical_slice, vertical_remainder;
		NSDivideRect(vertical_rectangle, &vertical_slice, &vertical_remainder, 1.0, NSMinXEdge);
		vertical_rectangle = vertical_remainder;
		
		if((x_start & 1) == 0) {
			[[NSColor whiteColor] set];
		} else {
			[[NSColor blackColor] set];
		}
		NSRectFillUsingOperation(vertical_slice, NSCompositeSourceOver);
	}
}

@end
