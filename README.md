# MyBigDate
A simple Garmin watchface that emphasizes larger font sizes, especially for the date.  Some watchfaces try to pack as much data as possible onto one screen, using the tiniest of fonts to accomplish it at the expense of readability.   Other watchfaces go for elegance and style, at the expense of usability.  

MyBigDate is for people who regularly forget the date and requires a glance at one's watch (with or without glasses on) without the need to extend an arm, move head back, squint, adjust lighting in hopes of being able to read the date.  MyBigDate accomplishes this, all without sacrificing elegance or usability (IMHO).  MyBigDate uses the highest contrast for visibility (white on black), and high contrast (yellow on black) to for style and spatial segmentation.
## Function Summary
The watchface is intended for the Garmin 735xt, only (at this time).  The watchface provides a large time of day configurable in standard or military format, prominently centered.  Below the time is the day, month, and date.  The battery meter is chunked into 1/5 sections, where each chunck represents 20% of battery life.  The left most chunk is broken into 2 pieces representing 1%-10% and 11%-20%.  Below the battery meter is the remaining battery life as a percentage.  

Within the drawn circles are the total number of steps for the day, denoted by the footprint image, and calories burned denoted by the fire image.    
## Technical
The watchface leverages many basic functions provided from the Garmin SDK (2.3).  The watchface is written expressly for the 735xt, which is 215x180 pixels (is not round).  Even if you don't have a 735, it would be easy to modify it for any Garmin.  

The project makes use of default properties and resource files.  It draws circles and rectangles.   It adds image files, setting of text and colors.  
## Future Releases
In order to support more devices, future releases will do a better job to support circular watchfaces, using refined porportional layout.  