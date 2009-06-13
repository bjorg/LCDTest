April 20th, 2005

LCDTest v2.0b
-=-=-=-=-=-=-
Copyright 2004-2005 Steve Bjorg

License
-------
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

Description
-----------
LCDTest is a small application to assist in common LCD adjustment tasks by providing test patterns.  These tasks include:
	1) Adjusting analog LCDs
	2) Detecting dead/lazy pixels
	3) Checking panel alignment
	4) Checking color transitions

These test patterns are designed to work for both monitors and projectors in single or multi-display configurations.  To test the desired display device, drag the 'LCDTest' window onto the display you wish to test.  Then click the 'Show Pattern' button.  All test patterns are terminated by pressing the Esc key.

Author's Notes
--------------
I wrote this application both as an exercise in Objective-C and as a port of a similar utility I had done earlier on the Windows platform.  I have found these patterns to invaluable on many occasions and hope they will prove just as useful to you.  If you have any suggestions for improvement, run into issues, or just want to say hi, don't hesitate to contact me.

Thanks to XIcons (www.xicons.com) for the free application icon.

Thanks to Daniel T. Griscom for his contributions on the gradient patterns.

Changes from 1.1 to 2.0
-----------------------
* factored out patterns into a pattern hierarchy* added hotspot pattern** changed color gradient pattern to leverage Quartz engine directly (not working well)* changed main interface to be more easily extensible* added pattern descriptor* added property list to describe patterns, devices, and flags* added pattern preview

Changes from 1.0 to 1.1
-----------------------
* Multiple gradient patterns
* Better presentation of the pattern instructions

Steve G. Bjorg
steve@bjorgs.com
www.bjorgs.com