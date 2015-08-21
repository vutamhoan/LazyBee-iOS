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
#import "CommonDefine.h"
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

/*
 "<!DOCTYPE html>\n"
 "<html>\n"
 "<head>\n"
 "<style>\n"
 " figure {"
 "   text-align: center;"
 "   margin: auto;"
 "}"
 "figure.image img {"
 "   width: 100% !important;"
 "   height: auto !important;"
 "}"
 "figcaption {"
 "   font-size: 10px;"
 "}"
 "a {"
 " margin-top:5px;"
 "}"
 "</style>\n"
 "</head>\n"
 "<body onload='question.playQuestion()'>\n"
 "<div style='width:100%'>\n"
 "<div style='float:left;width:90%;text-align: center;'>\n"
 "<strong style='font-size:25pt;'>" s "</strong>\n"
 "</div>\n"
 "<div style='float:left;width:10%'>\n"
 "<a onclick='question.playQuestion();'><img src='ic_speaker.png'/><p>\n"
 "</div>\n"
 "</div>\n"
 "</body>\n"
 "</html>";
 
 */

- (NSString *)createHTMLForQuestion:(NSString *)word {
    NSString *htmlString = @"<!DOCTYPE html>\n"
                            "<html>\n"
                            "<head>\n"
                            "<style>\n"
                            " figure {"
                            "   text-align: center;"
                            "   margin: auto;"
                            "}"
                            "figure.image img {"
                            "   width: 100% !important;"
                            "   height: auto !important;"
                            "}"
                            "figcaption {"
                            "   font-size: 10px;"
                            "}"
                            "a {"
                            " margin-top:5px;"
                            "}"
                            "</style>\n"
                            "<script>"
                            "function playSound() {"
                            "    var speaker = new SpeechSynthesisUtterance();"
                            "speaker.text = \' %@ \';"
                            "speaker.lang = 'en-US';"
                            "speaker.rate = 0.2;"
                            "speaker.pitch = 1.0;"
                            "speaker.volume = 1.0;"
                            "speechSynthesis.speak(speaker);"
                            "}"
                            "</script>"
                            "</head>\n"
                            "<body onload='playSound()'>\n"
                            "<div style='width:100%'>\n"
                            "<div style='float:left;width:90%;text-align: center;'>\n"
                            "<strong style='font-size:25pt;'> %@ </strong>\n"
                            "</div>\n"
                            "<div style='float:left;width:10%'>\n"
                            "<a onclick='playSound();'><img src='ic_speaker.png'/><p>\n"
                            "</div>\n"
                            "</div>\n"
                            "</body>\n"
                            "</html>";
    
    htmlString = [NSString stringWithFormat:htmlString, word, word];
    
    return htmlString;
}
/*
- (NSString *)createHTMLForAnswer:(NSString *)word {
    NSString *htmlString = @"";
 String meaning = EMPTY;
 String explain = EMPTY;
 String example = EMPTY;
 
 String pronoun = EMPTY;
 String explainTagA = EMPTY;
 String exampleTagA = EMPTY;
 String imageURL = EMPTY;
 String debug = "</body></html>\n";
 String _example = context.getResources().getString(R.string.example);
 Object _explain = context.getResources().getString(R.string.explain);
 
 //Log.i(TAG, "getAnswerHTMLwithPackage: Card Answer:" + card.getAnswers());
 // System.out.print("getAnswerHTMLwithPackage: Card Answer:" + card.getAnswers() + "\n");
 try {
 JSONObject answerObj = new JSONObject(card.getAnswers());
 pronoun = answerObj.getString("pronoun");
 JSONObject packagesObj = answerObj.getJSONObject("packages");
 System.out.print("\npackagesObj.length():" + packagesObj.length());
 if (packagesObj.length() > 0) {
 System.out.print("\n Ok");
 JSONObject commonObj = packagesObj.getJSONObject(packages);
 meaning = commonObj.getString("meaning");
 explain = commonObj.getString("explain");
 example = commonObj.getString("example");
 } else {
 _example = EMPTY;
 _explain = EMPTY;
 System.out.print("\n not Ok");
 }
 
 } catch (Exception e) {
 //System.out.print("Error 2:" + e.getMessage() + "\n");
 e.printStackTrace();
 //return e.getMessage();
 }
 
 if (!explain.isEmpty()) {
 explainTagA = "<p style='margin-top:2px'><a onclick='explain.speechExplain();'><img src='ic_speaker_red.png'/></a></p>";
 }
 if (!example.isEmpty()) {
 exampleTagA = "<p style='margin-top:2px'><a onclick='example.speechExample();'><img src='ic_speaker_red.png'/></a></p>";
 }
 html = "\n<html>\n" +
 "<head>\n" +
 "<meta content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"\n" +
 "name=\"viewport\">\n" +
 "</head>\n" +
 "<body " + ((onload == true) ? "onload='question.playQuestion()'" : "") + ">\n" +
 "   <div style='width:100%'>\n" +
 
 "       <div style='float:left;width:90%;text-align: center;'>\n" +
 "           <strong style='font-size:35pt;'>" + card.getQuestion() + "</strong>\n" +
 "       </div>\n" +
 
 "       <div style='float:left;width:10%'>\n" +
 "           <a onclick='question.playQuestion();'><img src='ic_speaker_red.png'/></a>\n" +
 "       </div>\n" +
 
 "       <div style='width:90%'>\n" +
 "           <center><font size='4'>" + pronoun + "</font></center>\n" +
 "           <center><font size='5' color='blue'><em>" + meaning + "</em></font></center>\n" +
 "       </div>\n" +
 
 "           <p style=\"text-align: center;\">" + imageURL + "</p>\n" +
 
 "       <div style=\"width:100%\">\n" +
 "           <div style=\"float:left;width:90%\">" +
 "              <strong>" + _explain + "</strong>" + explain + "\n" +
 "           </div>\n" +
 "           <div style=\"float:right;width:10%;margin-top:25px\">\n " +
 "               " + explainTagA + "\n" +
 "           </div>\n" +
 "       </div>\n" +
 
 "       <div style=\"width:100%\">\n" +
 "           <div style=\"float:left;width:90%\">" +
 "              <strong>" + _example + "</strong>" + example + "\n" +
 "           </div>\n" +
 "           <div style=\"float:right;width:10%;margin-top:25px\">\n " +
 "               " + exampleTagA + "\n" +
 "           </div>\n" +
 "       </div>\n" +
 
 "   </div>\n";
 
 if (DEBUG) {
 debug = "           <div id='debug'>\n " +
 "              Debug infor:</br>\n" +
 "              -------------------------------------</br>\n" +
 "              Level:" + card.getLevel() + "</br>\n" +
 "              lat_ivl:" + card.getLast_ivl() + "</br>\n" +
 "              Factor:" + card.getFactor() + "</br>\n" +
 "              Rev_count:" + card.getRev_count() + "</br>\n" +
 "              Queue:" + card.getQueue() + "</br>\n" +
 "              Due:" + card.getDue() + "-" + new Date(card.getDue()).toString() + "</br>\n" +
 "              -------------------------------------</br>\n" +
 "           </div>\n" +
 "   </body>" +
 "</html>\n";
 }
 html += debug;
 //Log.i(TAG, "_getAnswerHTMLwithPackage: HTML return=" + html);
 //System.out.print("\n_getAnswerHTMLwithPackage: HTML return=" + html);
 //  Log.i(TAG, "Error:" + e.getMessage());
 return html;
 
 }

*/
@end
