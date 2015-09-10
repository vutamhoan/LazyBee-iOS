//
//  HTMLHelper.m
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import "HTMLHelper.h"
#import "UIKit/UIKit.h"
#import "sqlite3.h"
#import "Common.h"
// Singleton
static HTMLHelper* sharedHTMLHelper = nil;

@implementation HTMLHelper


//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
+ (HTMLHelper*) sharedHTMLHelper {
    // lazy instantiation
    if (sharedHTMLHelper == nil) {
        sharedHTMLHelper = [[HTMLHelper alloc] init];
    }
    return sharedHTMLHelper;
}


//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
    }
    return self;
}

- (NSString *)createHTMLForQuestion:(NSString *)word {
    NSString *htmlString = @"<!DOCTYPE html>\n"
                            "<html>\n"
                            "<head>\n"
                                "<style>\n"
                                    "figure {"
                                    "   text-align: center;"
                                    "   margin: auto;"
                                    "}"
                                    "figure.image img {"
                                    "   width: 100%% !important;"
                                    "   height: auto !important;"
                                    "}"
                                    "figcaption {"
                                    "   font-size: 10px;"
                                    "}"
                                    "a {"
                                    "   margin-top:10px;"
                                    "}"
                                "</style>\n"
                                "<script>"
                                    "function playWord() {"
                                    "   var speaker = new SpeechSynthesisUtterance();"
                                    "   speaker.text = \' %@ \';"   //%@ will be replaced by word
                                    "   speaker.lang = 'en-US';"
                                    "   speaker.rate = 0.25;"
                                    "   speaker.pitch = 1.0;"
                                    "   speaker.volume = 1.0;"
                                    "   speechSynthesis.speak(speaker);"
                                    "}"
                                "</script>"
                            "</head>\n"
                            "<body onload='playWord()'>\n"
                                "<div style='width:100%%'>\n"
                                "<div style='float:left;width:90%%;text-align: center;'>\n"
                                "<strong style='font-size:20pt;'> %@ </strong>\n"   //%@ will be replaced by word
                                "</div>\n"
                                "<div style='float:left;width:10%%'>\n"
                                "<a onclick='playWord();'><img src='ic_speaker.png'/><p>\n"
                                "</div>\n"
                                "</div>\n"
                            "</body>\n"
                            "</html>";
    
    htmlString = [NSString stringWithFormat:htmlString, word, word];
    
    return htmlString;
}

- (NSString *)createHTMLForAnswer:(WordObject *)word withPackage:(NSString *)package {
    NSString *htmlString = @"";
    NSString *imageLink = @"";
    
    //parse the answer to dictionary object
    NSData *data = [word.answers dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictAnswer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *strPronounciation = [dictAnswer valueForKey:@"pronoun"];
    
    //A word may has many meanings corresponding to many fields (common, it, economic...)
    //The meaning of each field is considered as a package
    NSDictionary *dictPackages = [dictAnswer valueForKey:@"packages"];
    NSDictionary *dictSinglePackage = [dictPackages valueForKey:package];
    //"common":{"meaning":"", "explain":"<p>The edge of something is the part of it that is farthest from the center.</p>", "example":"<p>He ran to the edge of the cliff.</p>"}}
    
    NSString *strExplanation = [dictSinglePackage valueForKey:@"explain"];
    NSString *strExample = [dictSinglePackage valueForKey:@"example"];
    
    //remove html tag, use for playing speech
    NSString *plainExplanation = @"";
    NSString *plainExample = @"";
    
    if (strExplanation) {
        plainExplanation = [[Common sharedCommon] stringByRemovingHTMLTag:strExplanation];
    }
    
    if (strExample) {
        plainExample = [[Common sharedCommon] stringByRemovingHTMLTag:strExample];
    }
    
    NSString *strMeaning = @"";
    
    if ([dictSinglePackage valueForKey:@"meaning"]) {
        strMeaning = [dictSinglePackage valueForKey:@"meaning"];
    }
    
    NSString *strExplainIconTag = @"";
    NSString *strExampleIconTag = @"";
    
    NSNumber *speedNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"SpeakingSpeed"];
    float speed = [speedNumberObj floatValue];
    //create html
    if (strExplanation && strExplanation.length > 0) {
        strExplainIconTag = @"<div style=\"float:left;width:90%%\">"
                            "   <em>%@</em> \n" //%@ will be replaced by strExplanation
                            "</div>\n"
                            "<div style=\"float:left;width:10%%\">\n "
                            "   <p><a onclick='playLongText(\"%@\", %f);'><img src='ic_speaker.png'/></a></p>\n"  //%@ will be replaced by strExplanation
                            "</div>\n";
        strExplainIconTag = [NSString stringWithFormat:strExplainIconTag, strExplanation, plainExplanation, speed];
    }
    
    if (strExample && strExample.length > 0) {
        strExampleIconTag = @"<div style=\"float:left;width:90%%\">"
                            "   <em>%@</em> \n" //%@ will be replaced by strExample
                            "</div>\n"
                            "<div style=\"float:left;width:10%%\">\n "
                            "   <p><a onclick='playLongText(\"%@\", %f);'><img src='ic_speaker.png'/></a></p>\n"  //%@ will be replaced by strExample
                            "</div>\n";
        strExampleIconTag = [NSString stringWithFormat:strExampleIconTag, strExample, plainExample, speed];
    }
    
    htmlString = @"<html>\n"
    "<head>\n"
    "<meta content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"\n"
    "name=\"viewport\">\n"
    "<style>\n"
        "figure {"
        "   text-align: center;"
        "   margin: auto;"
        "}"
        "figure.image img {"
        "   width: 100%% !important;"
        "   height: auto !important;"
        "}"
        "figcaption {"
        "   font-size: 10px;"
        "}"
        "a {"
        "   margin-top:10px;"
        "}"
    "</style>\n"
    "<script>"
    //play the word
    "function playWord() {"
    "   var speaker = new SpeechSynthesisUtterance();"
    "   speaker.text = \' %@ \';"   //%@ will be replaced by word
    "   speaker.lang = 'en-US';"
    "   speaker.rate = 0.25;"//0.25
    "   speaker.pitch = 1.0;"
    "   speaker.volume = 1.0;"
    "   speechSynthesis.speak(speaker);"
    "}"
    //play the explanation
    "function playLongText(content, rate) {"
    "   var speaker = new SpeechSynthesisUtterance();"
    "   speaker.text = content;"
    "   speaker.lang = 'en-US';"
    "   speaker.rate = rate;" //0.1
    "   speaker.pitch = 1.0;"
    "   speaker.volume = 1.0;"
    "   speechSynthesis.speak(speaker);"
    "}"
    "</script>"
    
    "</head>\n"
    "<body ((onload == true) ? onload='question.playQuestion()' : \"\")>\n"
    "   <div style='width:100%%'>\n"
    
    "       <div style='float:left;width:90%%;text-align: center;'>\n"
    "           <strong style='font-size:20pt;'> %@ </strong>\n"    //%@ will be replaced by word
    "       </div>\n"
    
    "       <div style='float:left;width:10%%'>\n"
    "           <a onclick='playWord();'><img src='ic_speaker.png'/></a>\n"
    "       </div>\n"
    
    "       <div style='width:90%%'>\n"
    "           <center><font size='4'> %@ </font></center>\n"  //%@ will be replaced by pronunciation
    "           <center><font size='5' color='blue'><em> %@ </em></font></center>\n"    //%@ will be replaced by meaning
    "       </div>\n"
    
    "           <p style=\"text-align: center;\"> %@ </p>\n"  //%@ will be replaced by image link, temporary leave it blank
    
    "       <div style=\"width:100%%\">\n"
    "            %@ \n"     //%@ will be replaced by strExplainIconTag
    "       </div>\n"
    
    "       <div style=\"width:100%%\"><strong>Example: </strong>\n"
    "            %@ \n"     //%@ will be replaced by strExplainIconTag
    "       </div>\n"
    
    "   </div>\n"
    "   </body>"
    "</html>\n";

    htmlString = [NSString stringWithFormat:htmlString, word.question, word.question, strPronounciation, strMeaning, imageLink, strExplainIconTag, strExampleIconTag];
    return htmlString;
    
}

@end
