//
//  OpenLuhnAppDelegate.m
//  OpenLuhn
//
//  Copyright (c) 2013 Cai, Zhi-Wei. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "OpenLuhnAppDelegate.h"

@implementation OpenLuhnAppDelegate

#pragma mark - Basic

+ (void) initialize
{
    // Hello world! :D
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    // Shut down the application when the main window closed.
	return YES;
}

#pragma mark - Main

- (IBAction)makeMeASandwish:(id)sender
{
    //
    [_textField_input setTextColor:[NSColor blackColor]];
    [_textField_result setStringValue:@""];
    
    if ([self isValidInput:[_textField_input stringValue]]) {
        
        int sum;
        
        sum = [self calc:string_cleanInput];
        
        //
        if (bool_VerificationMode) {
            
            if ( !(sum % 10) ) {
                [self showAlertWithMessageText:@"Yaaaaaaaaaah! 😊" informativeText:@"Correct 💳 Number!"];
            } else {
                [_textField_input setTextColor:[NSColor redColor]];
                [self showAlertWithMessageText:@"Oops... 😢" informativeText:@"Invalid 💳 Number!"];
            }
            
        } else {
            int         count, less;
            BOOL        isOdd;
            NSString    *string_New;
            
            isOdd           = (unsigned long)[string_cleanInput rangeOfString:@"#"  options:NSBackwardsSearch].location % 2;
            less = count    = 10 - sum % 10;
            count           = 0;
            
            for (int i = 15; i > -1; i--) {
                if ([[string_cleanInput substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"#"]) {
                    count++;
                }
            }
            
            NSCountedSet    *countedSet_countedSet;
            NSArray         *array_check;
            NSMutableArray  *mutableArray_resultArray;
            
            array_check                 = [string_cleanInput componentsSeparatedByString:@"#"];
            countedSet_countedSet       = [NSCountedSet setWithArray:array_check];
            mutableArray_resultArray    = [NSMutableArray arrayWithCapacity:[array_check count]];
            
            for(id obj in countedSet_countedSet) {
                if([countedSet_countedSet countForObject:obj] == 1) {
                    if ([obj length]) {
                        [mutableArray_resultArray addObject:obj];
                    }
                }
            }
            
            do {
                
                string_New      = @"";
                
                srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));
                for (int i = 0; i < count - 1; i++) {
                    string_New = [string_New stringByAppendingFormat:@"%c", "0123456789"[random()%10]];
                }
                string_New = [string_New stringByAppendingString:@"#"];
                
                if ([mutableArray_resultArray count] > 1) {
                    string_cleanInput = [mutableArray_resultArray componentsJoinedByString:string_New];
                } else if (isOdd) {
                    string_cleanInput = [NSString stringWithFormat:@"%@%@",
                                         [mutableArray_resultArray objectAtIndex:0],
                                         string_New];
                } else {
                    string_cleanInput = [NSString stringWithFormat:@"%@%@",
                                         string_New,
                                         [mutableArray_resultArray objectAtIndex:0]];
                }
                
                sum     = [self calc:string_cleanInput];
                less    = 10 - sum % 10;
                
            } while (less > 9);
            
            if (isOdd) {
                string_New = [NSString stringWithFormat:@"%i", less];
            } else {
                string_New = [NSString stringWithFormat:@"%c", "0516273849"[less]];
            }
            
            string_cleanInput = [string_cleanInput stringByReplacingOccurrencesOfString:@"#" withString:string_New];
            
            [_textField_result setStringValue:[self stringFormat:string_cleanInput withSeparator:@" " withRange:4]];
        }
        
    } else {
        //
        [_textField_input setTextColor:[NSColor redColor]];
        [self showAlertWithMessageText:@"Oops... 😢" informativeText:@"Invalid 💳 Number!"];
    }
}

- (BOOL)isValidInput:(NSString *)string_Input
{
    NSUInteger      counter1, counter2;
    NSString        *string_Output;
    NSCharacterSet  *charSet_validCharacterSet;
    NSCountedSet    *countedSet_countedSet;
    NSArray         *array_check;
    NSMutableArray  *mutableArray_resultArray;
    
    bool_VerificationMode           = NO;
    string_Output                   = @"";
    string_cleanInput               = @"";
    charSet_validCharacterSet       = [NSCharacterSet characterSetWithCharactersInString:@"0123456789#"];
    
    // Iterate over characters in the string, checking each.
    for(int i = 0; i < [string_Input length]; i++) {
        unichar currentChar = [string_Input characterAtIndex:i];
        if([charSet_validCharacterSet characterIsMember:currentChar]) {
            string_Output = [string_Output stringByAppendingFormat:@"%C", currentChar];
        }
    }
    
    array_check                 = [string_Output componentsSeparatedByString:@"#"];
    countedSet_countedSet       = [NSCountedSet setWithArray:array_check];
    mutableArray_resultArray    = [NSMutableArray arrayWithCapacity:[array_check count]];
    
    for(id obj in countedSet_countedSet) {
        if([countedSet_countedSet countForObject:obj] == 1) {
            if ([obj length]) {
                [mutableArray_resultArray addObject:obj];
            }
        }
    }
    
    counter1 = [mutableArray_resultArray count];
    counter2 = [string_Output length];
    
    if (counter1 == 1 && [[mutableArray_resultArray objectAtIndex:0] length] == 16) {
        bool_VerificationMode   = YES;
    } else if (counter1 < 3 && counter1 > 0 && counter2 == 16) {
        bool_VerificationMode   = NO;
    } else {
        return NO;
    }
    
    string_cleanInput       = string_Output;
    
    return YES;
}

- (int)calc:(NSString *)inputString
{
    int sum;
    
    sum = 0;
    
    for (int i = (int)[inputString length] - 1; i > -1; i--) {
        
        int thisNumber;
        
        thisNumber = [[inputString substringWithRange:NSMakeRange(i, 1)] intValue];
        
        if ( i % 2 == 0 ) {
            if (thisNumber > 4) sum -= 9;
            thisNumber *= 2;
        }
        
        sum += thisNumber;
        
    }
    
    return sum;
}

- (void)showAlertWithMessageText:(NSString *)aMessageText informativeText:(NSString *)anInformativeText
{
    //
    [[NSAlert alertWithMessageText:aMessageText
                     defaultButton:@"OK"
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"%@", anInformativeText] runModal];
    
}

#pragma mark - Misc

- (NSString *)stringFormat:(NSString *)sString withSeparator:(NSString *)aSeparator withRange:(int)aRange {
    
	NSMutableString *mutableString_New = [NSMutableString stringWithString:sString];
	unsigned int i = aRange;
	while (i < [mutableString_New length]) {
		[mutableString_New insertString:aSeparator atIndex:i];
		i += aRange + 1;
	}
	return [NSString stringWithString:mutableString_New];
}

- (IBAction)goToGithub:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:define_githubURL]];
}

@end
