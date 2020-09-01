![Microsoft Word Citation and Bibliography Styles](https://github.com/codingo/BibWord/blob/master/BibWord.png "BibWord")

[![Twitter](https://img.shields.io/badge/twitter-@codingo__-blue.svg)](https://twitter.com/codingo_)

# Credit / Foreward
This work is only made possible by the original work of Yves Dhondt (yves.dhondt@gmail.com) and his original project, found at https://bibword.codeplex.com/. I have created this project to preserve this work as it will otherwise disappear with the closure of CodePlex and I found it invaluable in my own studies. I will aim to keep this up to date (feel free to raise issues) however should the original project be migrated to another source I will be closing this in favor of one maintained by its original author.

## Installation
To get the style files find the desired file using the above links. Once found, look for a button labelled "Raw". Either right-click this button and select "save linked content as" or, or click the button and right-click to save-as. Note that once downloaded, ensure that the filename extension is `.xsl`, some browsers will append `.txt`. Windows, by default hides file extensions.

To use the bibliography styles, they have to be copied into the Microsoft Word bibliography style directory. This directory can vary depending on where Word is installed. Once the styles are copied to the directory, they will show up every time Microsoft Word is opened.

It should be noted that on a 64 bit machine you have "Program Files" and "Program Files (x86)". For the majority of cases the style folder will be located within _Program Files x86_. Locations where files should then be installed are as follows:

### Windows
#### Word 2007
> <winword.exe directory>\Bibliography\Style

#### Word 2010
> <winword.exe directory>\Bibliography\Style

#### Word 2010 (32 bit systems)
> %programfiles%\Microsoft Office\Office14\Bibliography\Style
#### Word 2016 (Office 365)
> C:\Users\<currentusername>\AppData\Roaming\Microsoft\Bibliography\Style
or 
> %AppData%\Microsoft\Templates\LiveContent\15\Managed\Word Document Bibliography Styles

### Mac OS
#### Word 2008 and Word 2011
To use the bibliography styles, right-click on Microsoft Word 2008 and select show package contents. Put the files in:
> Contents/Resources/Style/
On most Macs with Microsoft Word 2008 this will be:
>  /Applications/Microsoft Office 2008/Microsoft Word.app/Contents/Resources/Style/
#### Word 2016 for Mac (version 15.17.0 and up)
To use the bibliography styles, place them in the following folder
> /Library/AppSupport/Microsoft/Office365/Citations/
More information can be found here: https://msdn.microsoft.com/VBA/Word-VBA/articles/create-custom-bibliography-styles?f=255&MSPPError=-2147217396

#### Office 365
For the latest releases of Office 365 these need to be placed within the application at:

> /Applications/Microsoft Word.app/Contents/Resources/Style

To do this, open Finder, right click on /Application/Microsoft Word (or /Application/Microsoft Word.app - depending on your Finder Preferences), then click Show Package Contents to see the folders within the .app file.

## FAQ 
### Why is a new style not showing up in Word when I add it to the Style directory?
The list of available reference styles gets loaded only once. So when you add a new style to the style directory, you need to restart Word.


### In Word 2008, new styles are only added for citations. How can I use the new styles for bibliographies?
Add the bibliography using one of the four predefined styles. Then go to the citation toolbox and select the style you want. This will update all the citations and bibliographies in your text to the new style.


### Why does it take Word so long to show the dropdown list with style names the first time?
Word has to retrieve the style names of every XSL in the style directory the first time. Hence, the more styles you put in the directory, the more time Word needs to fill the drop down list.


### Why do I get 'BO' instead of a number when using certain styles?
'BO' is often printed when the BibOrder number is not available. Use the BibWord Extender tool on the document to add the missing numbers.


### Why do certain styles have a * at the end of their name?
Although the usage of a * is not mandatory, it often indicates that part of the functionality of the style can only be used in combination with the BibWord Extender tool.


### Can I request to get a certain style?
No. Using BibWord, you really should try to create the style yourself. Keep in mind that even if you find someone prepared to create the style for you that you will have to provide him/her with detailed information about the formatting guidelines for your style. Messages containing "I need style x." will most likely be ignored.


### Can I (not) link my in-text citations to their bibliography entries?
Yes. Set the value of citation_as_link to 'yes' if you want in-text citations to link to their specific bibliography entry, or to any other value if you do not.


### Can I change the surrounding brackets for in-text citations?
Yes. You can change the surrounding brackets by changing the values of openbracket and closebracket
```
<openbracket>(</openbracket>
<closebracket>)</closebracket>
```
### How do I get my in-text citations in superscript?
In-text citations inherit the style of their surroundings. Only limited formatting (bold, underline, italic) can be applied to them through the reference style. For any further formatting, such as superscript, a character style has to be applied to all CITATION fields.

The following macro creates a character style called In-Text Citation if it does not yet exist. When the style is newly created, it sets the font to superscript. Then the style is applied to all CITATION fields in the document. By changing/updating the style In-Text Citation you can then update the formatting of all citations
```
Sub ApplyCitationStyle()
    Dim stylename As String
    Dim exists As Boolean
    Dim s As Style
    Dim fld As Field
                
    stylename = "In-Text Citation"
        
    ' Check if the style already exists.
    exists = False
        
    For Each s In ActiveDocument.Styles
        If s.NameLocal = stylename Then
           exists = True
           Exit For
        End If
    Next
    
    ' If the style did not exist yet, create it.
    If exists = False Then
        Set s = ActiveDocument.Styles.Add(stylename, wdStyleTypeCharacter)
        s.BaseStyle = ActiveDocument.Styles(wdStyleDefaultParagraphFont).BaseStyle
        s.Font.Superscript = True
    End If
    
    ' Now that the style really exists, select it.
    Set s = ActiveDocument.Styles(stylename)
     
    ' Apply the style to all in-text citations.
    For Each fld In ActiveDocument.Fields
        If fld.Type = wdFieldCitation Then
            fld.Select
            Selection.Style = s
        End If
    Next

End Sub
```
### How do I convert all my in-text citations to static text in one go?
You can use the following macro to convert all in-text citations:
```
Sub CitationsToStaticText()
    Dim fld As Field
            
    ' Go over all stories, including main, footnotes, ...
    For Each sr In ActiveDocument.StoryRanges
        ' Find all citation fields and convert them to static text.
        For Each fld In sr.Fields
            If fld.Type = wdFieldCitation Then
                fld.Select
                WordBasic.BibliographyCitationToText
            End If
        Next
    Next

End Sub
```
### Is there an easy way to get rid of sources which are not cited in the text?
You can use the following macro to remove all uncited sources from a document:
```
Sub RemoveUnusedCitations()
    ' Get the number of sources.
    idx = ActiveDocument.Bibliography.Sources.Count
    
    ' Remmove unused sources starting from the last one.
    Do While (idx > 0)
        If ActiveDocument.Bibliography.Sources(idx).Cited = False Then
            ActiveDocument.Bibliography.Sources(idx).Delete
        End If
        idx = idx - 1
    Loop
End Sub
```
### How do I set the indentation of my bibliography?
Add a bibliography to your document. Open the 'Styles' pane (CTRL+ALT+SHIFT+S) and look for a style called 'Bibliography' (or a localized translation of the word 'Bibliography'). Change the indentation settings there. That way, whenever your bibliography gets updated, the indentation will remain correct.


### Is it possible to group several citations? Currently I have something like (1)(2) and I want (1,2).
Yes. You can add a second source to a citation by using the '\m' switch and the tag of the source you want to add. In Word 2007, if you want to add a source with tag 'Bee99' to an existing citation, right click the citation and select 'Edit Field...'. It will show you something like 'CITATION Gup97 \l 2060'. To add the extra source, change it to 'CITATION Gup97 \l 2060 \m Bee99'. For more information, also see the Microsoft Office online help topic on the CITATION field code.

Alternatively, you can put your cursor inside any in-text citation, then go to 'References' tab in the ribbon and click 'Insert Citation'.

To change the separator between two grouped in-text citations, BibWord uses the separator element.


### Only the name of the first author is displayed correctly, all other author names are abbreviated. Is this a bug?
No. You probably made a mistake when entering the different author names. You should enter them one by one in the dialog that comes up when clicking the "Edit..." button next to the author field. That way you will not make a mistake.

If you really want to enter them as a string, then be aware that the correct format is "Last1, First1 Middle1; Last2, First2 Middle2; ...". So the names are separated by a ";" while name parts are separated by a ",".

Note that there is a bug in Word where sometimes the name conversion goes wrong.


### When using a numbered style (e.g. IEEE), the number is wrapped over multiple lines. Is this a bug?
No. Numbered styles are mostly represented using a 2 column table where the first column contains the number and the second column contains the text. The text wrap you see is caused by the first column not being wide enough. You can simple solve this by positioning your cursor on the the table border between the first and second column and drag it to the right.

This can also be used to add extra white space after the number if you set the halign element to left of the first column.


### My in-text citations are displayed in bold. How do I change this?
If you link your in-text citation to your bibliography, Word formats the link using the 'Heading 2 Character style'. So if that style is configured to use bold, so will the in-text citation. Assuming you cannot or do not want to change that style, there are two possible solutions:

#### Disable linking between in-text citations and bibliographies. 
This can be done easily be setting the value of citation_as_link to 'no' in the xsl file.

#### Format each in-text citation with another character style. 
This way you will be able to keep using the links between in-text citations and bibliographies. To ease this job, you could use the following macro which you can run every time you insert an in-text citation or once at the end.
```
Sub ApplyCitationStyle()
    Dim stylename As String
    Dim exists As Boolean
    Dim s As Style
    Dim fld As Field
                
    stylename = "In-Text Citation"
        
    ' Check if the style already exists.
    exists = False
        
    For Each s In ActiveDocument.Styles
        If s.NameLocal = stylename Then
           exists = True
           Exit For
        End If
    Next
    
    ' If the style did not exist yet, create it.
    If exists = False Then
        Set s = ActiveDocument.Styles.Add(stylename, wdStyleTypeCharacter)
        s.BaseStyle = ActiveDocument.Styles(wdStyleDefaultParagraphFont).BaseStyle
        s.Font.Bold = False
    End If
    
    ' Now that the style really exists, select it.
    Set s = ActiveDocument.Styles(stylename)
     
    ' Apply the style to all in-text citations.
    For Each fld In ActiveDocument.Fields
        If fld.Type = wdFieldCitation Then
            fld.Select
            Selection.Style = s
        End If
    Next

End Sub
```
