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

#import <Cocoa/Cocoa.h>

@interface MainControl : NSObject {
	IBOutlet NSWindow* window;
	IBOutlet NSTextView* calibration;
	IBOutlet NSTextView* pixels;
	IBOutlet NSTextView* alignment;
	IBOutlet NSTextView* gradients;
}

// event handling
- (IBAction)windowWillClose:(id)sender;
- (IBAction)showColorGradient:(id)sender;
- (IBAction)showPanelAlignment:(id)sender;
- (IBAction)showCalibration:(id)sender;
- (IBAction)showDeadPixels:(id)sender;

@end
