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

#import "HotspotPattern.h"
#include <ApplicationServices/ApplicationServices.h>

#define GRAY_LEVEL 0.3

static float intensity = 0;

static CGRect convertToCGRect(NSRect rect) {
    return *(CGRect*)&rect;
}

static void  myCalculateShadingValues(void *info, const float *in, float *out) {
    size_t components = (size_t)info;
	size_t k;
    for(k = 0; k < components - 1; k++) {
        *out++ = 0;
	}
	float value = 1 - *in;
	*out++ = value * value * GRAY_LEVEL * intensity; // alpha
}

static CGFunctionRef myGetFunction(CGColorSpaceRef colorspace) {
    static const float input_value_range[2] = { 0, 1 };
    static const float output_value_ranges[8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0, &myCalculateShadingValues, NULL };
	
    size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace); 
    return CGFunctionCreate((void*)components,  
							1,  
							input_value_range,  
							components,  
							output_value_ranges,  
							&callbacks); 
}

@implementation HotspotPattern

- (void)drawRect:(NSRect)rect {
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGRect bounds = convertToCGRect([self bounds]);
    float width = bounds.size.width;
    float height = bounds.size.height;
    CGPoint startPoint = CGPointMake(width/2, height/2);
	
	// compute hotspot size and intensity
	if(state > 10) {
		state = 10;
	} else if(state < 0) {
		state = 0;
	}
	intensity = 1.0 * state / 10;
	float startRadius = 0;   
    float endRadius = intensity * (height / 3.0);
	
	// create colorspace and shading function
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();  
    CGFunctionRef shading_function = myGetFunction(colorspace); 
    CGShadingRef shading = CGShadingCreateRadial(colorspace,  
												 startPoint, startRadius,
												 startPoint, endRadius,
												 shading_function,
												 false, false);
	
    CGContextSaveGState(context); 
	
	// clear background
    CGContextSetRGBFillColor(context, GRAY_LEVEL, GRAY_LEVEL, GRAY_LEVEL, 1); 
    CGContextFillRect(context, bounds);
	
	// draw shading
    CGContextDrawShading(context, shading); 
    
	// write hotspt description
	CGContextSelectFont(context, "Times-Roman", 24, kCGEncodingMacRoman);
    CGContextSetShouldAntialias(context, true);
    CGContextSetGrayFillColor(context, 0, 1);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	char message[128];
	int message_len = sprintf(message, "Hotspot %d%%", (int)(intensity * 100));
    CGContextShowTextAtPoint(context, 2, 2, message, message_len);

	// release allocated resources
	CGColorSpaceRelease(colorspace); 
    CGShadingRelease(shading);
    CGFunctionRelease(shading_function);
    CGContextRestoreGState(context);
}

@end
