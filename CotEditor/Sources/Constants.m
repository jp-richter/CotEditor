/*
 
 Constants.m
 
 CotEditor
 http://coteditor.com
 
 Created by nakamuxu on 2004-12-13.
 
 ------------------------------------------------------------------------------
 
 © 2004-2007 nakamuxu
 © 2014-2016 1024jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "Constants.h"


#pragma mark General

// ------------------------------------------------------
// General
// ------------------------------------------------------

// separator
NSString *_Nonnull const CESeparatorString = @"-";

// Exported UTI
NSString *_Nonnull const CEUTTypeTheme = @"com.coteditor.CotEditor.theme";

// General notification's userInfo keys
NSString *_Nonnull const CEOldNameKey = @"CEOldNameKey";
NSString *_Nonnull const CENewNameKey = @"CENewNameKey";

// Metadata dict keys for themes and syntax styles
NSString *_Nonnull const CEMetadataKey = @"metadata";
NSString *_Nonnull const CEAuthorKey = @"author";
NSString *_Nonnull const CEDistributionURLKey = @"distributionURL";
NSString *_Nonnull const CELicenseKey = @"license";
NSString *_Nonnull const CEDescriptionKey = @"description";


// Help anchors
NSString *_Nonnull const kHelpAnchors[] = {
    @"releasenotes",
    @"pref_general",
    @"pref_window",
    @"pref_appearance",
    @"pref_edit",
    @"pref_format",
    @"pref_filedrop",
    @"pref_keybindings",
    @"pref_print",
    @"whats_new",
    @"specification_changes",
    @"about_script_name",
    @"about_applescript",
    @"about_unixscript",
    @"pref_integration",
    @"about_file_mapping",
    @"about_cot",
};


// Convenient functions
/// compare CGFloats
BOOL CEIsAlmostEqualCGFloats(CGFloat float1, CGFloat float2) {
    const double ACCURACY = 5;
    return (fabs(float1 - float2) < pow(10, -ACCURACY));
}

/// invoke passed-in block on main thread
void dispatch_sync_on_main_thread(_Nonnull dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}



#pragma mark Syntax

// ------------------------------------------------------
// Syntax
// ------------------------------------------------------

// syntax style keys
NSString *_Nonnull const CESyntaxMetadataKey = @"metadata";
NSString *_Nonnull const CESyntaxExtensionsKey = @"extensions";
NSString *_Nonnull const CESyntaxFileNamesKey = @"filenames";
NSString *_Nonnull const CESyntaxInterpretersKey = @"interpreters";
NSString *_Nonnull const CESyntaxKeywordsKey = @"keywords";
NSString *_Nonnull const CESyntaxCommandsKey = @"commands";
NSString *_Nonnull const CESyntaxTypesKey = @"types";
NSString *_Nonnull const CESyntaxAttributesKey = @"attributes";
NSString *_Nonnull const CESyntaxVariablesKey = @"variables";
NSString *_Nonnull const CESyntaxValuesKey = @"values";
NSString *_Nonnull const CESyntaxNumbersKey = @"numbers";
NSString *_Nonnull const CESyntaxStringsKey = @"strings";
NSString *_Nonnull const CESyntaxCharactersKey = @"characters";
NSString *_Nonnull const CESyntaxCommentsKey = @"comments";
NSString *_Nonnull const CESyntaxCommentDelimitersKey = @"commentDelimiters";
NSString *_Nonnull const CESyntaxOutlineMenuKey = @"outlineMenu";
NSString *_Nonnull const CESyntaxCompletionsKey = @"completions";
NSString *_Nonnull const kAllSyntaxKeys[] = {
    @"keywords",
    @"commands",
    @"types",
    @"attributes",
    @"variables",
    @"values",
    @"numbers",
    @"strings",
    @"characters",
    @"comments"
};
NSUInteger const kSizeOfAllSyntaxKeys = sizeof(kAllSyntaxKeys)/sizeof(kAllSyntaxKeys[0]);

NSString *_Nonnull const CESyntaxKeyStringKey = @"keyString";
NSString *_Nonnull const CESyntaxBeginStringKey = @"beginString";
NSString *_Nonnull const CESyntaxEndStringKey = @"endString";
NSString *_Nonnull const CESyntaxIgnoreCaseKey = @"ignoreCase";
NSString *_Nonnull const CESyntaxRegularExpressionKey = @"regularExpression";

NSString *_Nonnull const CESyntaxInlineCommentKey = @"inlineDelimiter";
NSString *_Nonnull const CESyntaxBeginCommentKey = @"beginDelimiter";
NSString *_Nonnull const CESyntaxEndCommentKey = @"endDelimiter";

NSString *_Nonnull const CESyntaxBoldKey = @"bold";
NSString *_Nonnull const CESyntaxUnderlineKey = @"underline";
NSString *_Nonnull const CESyntaxItalicKey = @"italic";

// comment delimiter keys
NSString *_Nonnull const CEBeginDelimiterKey = @"beginDelimiter";
NSString *_Nonnull const CEEndDelimiterKey = @"endDelimiter";



#pragma mark File Drop

// ------------------------------------------------------
// File Drop
// ------------------------------------------------------

// keys for dicts in CEDefaultFileDropArrayKey
NSString *_Nonnull const CEFileDropExtensionsKey = @"extensions";
NSString *_Nonnull const CEFileDropFormatStringKey = @"formatString";

// tokens
NSString *_Nonnull const CEFileDropAbsolutePathToken = @"<<<ABSOLUTE-PATH>>>";
NSString *_Nonnull const CEFileDropRelativePathToken = @"<<<RELATIVE-PATH>>>";
NSString *_Nonnull const CEFileDropFilenameToken = @"<<<FILENAME>>>";
NSString *_Nonnull const CEFileDropFilenameNosuffixToken = @"<<<FILENAME-NOSUFFIX>>>";
NSString *_Nonnull const CEFileDropFileextensionToken = @"<<<FILEEXTENSION>>>";
NSString *_Nonnull const CEFileDropFileextensionLowerToken = @"<<<FILEEXTENSION-LOWER>>>";
NSString *_Nonnull const CEFileDropFileextensionUpperToken = @"<<<FILEEXTENSION-UPPER>>>";
NSString *_Nonnull const CEFileDropDirectoryToken = @"<<<DIRECTORY>>>";
NSString *_Nonnull const CEFileDropImagewidthToken = @"<<<IMAGEWIDTH>>>";
NSString *_Nonnull const CEFileDropImagehightToken = @"<<<IMAGEHEIGHT>>>";



#pragma mark Main Menu

// ------------------------------------------------------
// Main Menu
// ------------------------------------------------------

// Help document file names table
NSString *_Nonnull const kBundledDocumentFileNames[] = {
    @"Acknowledgements",
    @"ScriptMenu Folder",
    @"AppleScript",
    @"ShellScript"
};

// Online URLs
NSString *_Nonnull const kWebSiteURL = @"http://coteditor.com";
NSString *_Nonnull const kIssueTrackerURL = @"https://github.com/coteditor/CotEditor/issues";
