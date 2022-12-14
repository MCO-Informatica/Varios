/*
!short: FiveWin main Header File */

//#Translate Project Function <cNome> => Function P_<cNome>

#ifndef _FIVEWIN_CH
#define _FIVEWIN_CH

//#define FWVERSION   "FiveWin 1.9.2 - November 1996"
//#define FWCOPYRIGHT "(c) FiveTech, 1993-6"

//#include "Dialog.ch"
#include "Font.ch"
//#include "Ini.ch"
//#include "PTMenu.ch"
//#include "Print.ch"

//#ifndef CLIPPER501
//  #include "Colors.ch"
//  #include "DLL.ch"
//  #include "Folder.ch"
//  #include "msobject.ch"
//  #include "ODBC.ch"
//  #include "DDE.ch"
//  #include "Video.ch"
//  #include "VKey.ch"
//  #include "Tree.ch"
//  #include "WinApi.ch"
//#endif

//#define CRLF Chr(13)+Chr(10)

/*----------------------------------------------------------------------------//
!short: ACCESSING / SETTING Variables */

#xtranslate bSETGET(<uVar>) => ;
    { | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

/*----------------------------------------------------------------------------//
!short: Default parameters management */

#xcommand DEFAULT <uVar1> := <uVal1> ;
      [, <uVarN> := <uValN> ] => ;
    <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
   [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

/*----------------------------------------------------------------------------//
!short: General release command */


#xcommand RELEASE <ClassName> <oObj1> [,<oObjN>] ;
     => ;
       Iif( <oObj1> <> NIL , ( <oObj1>:End(),<oObj1> := NIL),) ;
      [ ; Iif ( <oObjN> <> NIL, ( <oObjN>:End(),<oObjN> := NIL),) ]

/*----------------------------------------------------------------------------//
!short: Brushes */

#xcommand DEFINE BRUSH [ <oBrush> ] ;
     [ STYLE <cStyle> ] ;
     [ COLOR <nRGBColor> ] ;
     [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
     [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
     => ;
   [ <oBrush> := ] TBrush():New( [ Upper(<(cStyle)>) ], <nRGBColor>,;
     <cBmpFile>, <cBmpRes> )

#xcommand SET BRUSH ;
     [ OF <oWnd> ] ;
     [ TO <oBrush> ] ;
     => ;
   <oWnd>:SetBrush( <oBrush> )

/*----------------------------------------------------------------------------//
!short: Pens */

#xcommand DEFINE PEN <oPen> ;
     [ STYLE <nStyle> ] ;
     [ WIDTH <nWidth> ] ;
     [ COLOR <nRGBColor> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     => ;
   <oPen> := TPen():New( <nStyle>, <nWidth>, <nRGBColor>, <oWnd> )

#xcommand ACTIVATE PEN <oPen> => <oPen>:Activate()

/*----------------------------------------------------------------------------//
!short: ButtonBar Commands */

#xcommand DEFINE BUTTONBAR [ <oBar> ] ;
     [ <size: SIZE, BUTTONSIZE, SIZEBUTTON > <nWidth>, <nHeight> ] ;
     [ <_3d: 3D, 3DLOOK> ] ;
     [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
     [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ CURSOR <oCursor> ] ;
    => ;
  [ <oBar> := ] TBar():New( <oWnd>, <nWidth>, <nHeight>, <._3d.>,;
     [ Upper(<(mode)>) ], <oCursor> )

#xcommand @ <nRow>, <nCol> BUTTONBAR [ <oBar> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ BUTTONSIZE <nBtnWidth>, <nBtnHeight> ] ;
     [ <_3d: 3D, 3DLOOK> ] ;
     [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
     [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ CURSOR <oCursor> ] ;
    => ;
  [ <oBar> := ] TBar():NewAt( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <nBtnWidth>, <nBtnHeight>, <oWnd>, <._3d.>, [ Upper(<(mode)>) ],;
     <oCursor> )

#xcommand DEFINE BUTTON [ <oBtn> ] ;
     [ <bar: OF, BUTTONBAR > <oBar> ] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
   [,<cResName2>[,<cResName3>] ] ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
   [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
     [ <action:ACTION,EXEC> <uAction,...> ] ;
     [ <group: GROUP > ] ;
     [ MESSAGE <cMsg> ] ;
     [ <adjust: ADJUST > ] ;
     [ WHEN <WhenFunc> ] ;
     [ TOOLTIP <cToolTip> ] ;
     [ <lPressed: PRESSED> ] ;
     [ ON DROP <bDrop> ] ;
     [ AT <nPos> ] ;
     [ PROMPT <cPrompt> ] ;
     [ FONT <oFont> ] ;
     [ <lNoBorder: NOBORDER> ] ;
    => ;
  [ <oBtn> := ] TBtnBmp():NewBar( <cResName1>, <cResName2>,;
    <cBmpFile1>, <cBmpFile2>, <cMsg>, [{|This|<uAction>}],;
    <.group.>, <oBar>, <.adjust.>, <{WhenFunc}>,;
    <cToolTip>, <.lPressed.>, [\{||<bDrop>\}], [\"<uAction>\"], <nPos>,;
    <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>] )

#xcommand @ <nRow>, <nCol> BTNBMP [<oBtn>] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName1> [,<cResName2>] ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ACTION <uAction,...> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <uWhen> ] ;
     [ <adjust: ADJUST> ] ;
     [ <lUpdate: UPDATE> ] ;
    => ;
  [ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
    <cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
    [{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
    <.lUpdate.> )

/*----------------------------------------------------------------------------//
!short: Icons */
/* [ INPLEMENTADOS ABAIXO NO PROTHEUS ]
#xcommand @ <nRow>, <nCol> ICON [ <oIcon> ] ;
     [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
     [ <border:BORDER> ] ;
     [ ON CLICK <uClick> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     => ;
   [ <oIcon> := ] TIcon():New( <nRow>, <nCol>, <cResName>,;
     <cIcoFile>, <.border.>, <{uClick}>, <oWnd>, <.update.>,;
     <{uWhen}>, <nClrFore>, <nClrBack> )

/*----------------------------------------------------------------------------//
#xcommand DEFINE ICON <oIcon> ;
     [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
     [ WHEN <WhenFunc> ] ;
     => ;
   <oIcon> := TIcon():New( ,, <cResName>, <cIcoFile>, <{WhenFunc}> )
*/
/*----------------------------------------------------------------------------//
!short: PUSHBUTTON */

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cCaption> ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ACTION <uAction> ] ;
     [ <default: DEFAULT> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
     [ FONT <oFont> ] ;
     [ <pixel: PIXEL> ] ;
     [ <design: DESIGN> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <WhenFunc> ] ;
     [ VALID <uValid> ] ;
     [ <lCancel: CANCEL> ] ;
    => ;
  [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <cCaption>, <oWnd>,;
    <{uAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <.default.>,;
    <.pixel.>, <.design.>, <cMsg>, <.update.>, <{WhenFunc}>,;
    <{uValid}>, <.lCancel.> )

/*----------------------------------------------------------------------------//
!short: CHECKBOX */

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
     [ PROMPT <cCaption> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <help:HELPID, HELP ID> <nHelpId> ] ;
     [ FONT <oFont> ] ;
     [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
     [ VALID   <ValidFunc> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <design: DESIGN> ] ;
     [ <pixel: PIXEL> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <WhenFunc> ] ;
    => ;
  [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
     [bSETGET(<lVar>)], <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
     [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
     <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}> )

/*----------------------------------------------------------------------------//
!short: COMBOBOX */

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
     [ <items: ITEMS, PROMPTS> <aItems> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
     [ <help:HELPID, HELP ID> <nHelpId> ] ;
     [ ON CHANGE <uChange> ] ;
     [ VALID <uValid> ] ;
     [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;
     [ FONT <oFont> ] ;
     [ <update: UPDATE> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <uWhen> ] ;
     [ <design: DESIGN> ] ;
     [ BITMAPS <acBitmaps> ] ;
     [ ON DRAWITEM <uBmpSelect> ] ;
     => ;
   [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
     <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
     [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
     <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
     <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}] )

/*----------------------------------------------------------------------------//
!short: LISTBOX */

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <cnVar> ;
     [ <items: ITEMS, PROMPTS> <aList>  ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ON CHANGE <uChange> ] ;
     [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
     [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
     [ VALID <uValid> ] ;
     [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;
     [ <design: DESIGN> ] ;
     [ FONT <oFont> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ BITMAPS <aBitmaps> ] ;
     [ ON DRAWITEM <uBmpSelect> ] ;
     [ <multi: MULTI, MULTIPLE, MULTISEL> ] ;
     [ <sort: SORT> ] ;
     [ ON RIGHT CLICK <uRClick> ] ;
    => ;
   [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, bSETGET(<cnVar>),;
     <aList>, <nWidth>, <nHeight>, <{uChange}>, <oWnd>, <{uValid}>,;
     <nClrFore>, <nClrBack>, <.pixel.>, <.design.>, <{uLDblClick}>,;
     <oFont>, <cMsg>, <.update.>, <{uWhen}>, <aBitmaps>,;
     [{|nItem|<uBmpSelect>}], <.multi.>, <.sort.>,;
     [\{|nRow,nCol,nFlags|<uRClick>\}] )

/*----------------------------------------------------------------------------//
!short: LISTBOX - BROWSE */
// Warning: SELECT <cField>  ==> Must be the Field key of the current INDEX !!!

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
      [ ALIAS <cAlias> ] ;
      [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
      [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
      [ SIZE <nWidth>, <nHeigth> ] ;
      [ <dlg:OF,DIALOG> <oDlg> ] ;
      [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
      [ ON CHANGE <uChange> ] ;
      [ ON [ LEFT ] CLICK <uLClick> ] ;
      [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
      [ ON RIGHT CLICK <uRClick> ] ;
      [ FONT <oFont> ] ;
      [ CURSOR <oCursor> ] ;
      [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
      [ MESSAGE <cMsg> ] ;
      [ <update: UPDATE> ] ;
      [ <pixel: PIXEL> ] ;
      [ WHEN <uWhen> ] ;
      [ <design: DESIGN> ] ;
      [ VALID <uValid> ] ;
      [ ACTION <uAction,...> ] ;
    => ;
   [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
      [\{|| \{<Flds> \} \}], ;
      [\{<aHeaders>\}], [\{<aColSizes>\}], ;
      <oDlg>, <(cField)>, <uValue1>, <uValue2>,;
      [<{uChange}>],;
      [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
      [\{|nRow,nCol,nFlags|<uRClick>\}],;
      <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
      <.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
      <.design.>, <{uValid}>, <{uLClick}>,;
      [\{<{uAction}>\}] )

/*----------------------------------------------------------------------------//
!short: RADIOBUTTONS */

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
     [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
     [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     [ <lLook3d: 3D> ] ;
     [ <lPixel: PIXEL> ] ;
     => ;
   [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, {<cItems>},;
     [bSETGET(<nVar>)], <oWnd>, [{<nHelpId>}], <{uChange}>,;
     <nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
     <nWidth>, <nHeight>, <{uValid}>, <.lDesign.>, <.lLook3d.>,;
     <.lPixel.> )

/*----------------------------------------------------------------------------//
!short: BITMAP */

#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <NoBorder:NOBORDER, NO BORDER> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
     [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
     [ <scroll: SCROLL> ] ;
     [ <adjust: ADJUST> ] ;
     [ CURSOR <oCursor> ] ;
     [ <pixel: PIXEL>   ] ;
     [ MESSAGE <cMsg>   ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
     [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
     [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
     <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
     <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xcommand DEFINE BITMAP [<oBmp>] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     => ;
   [ <oBmp> := ] TBitmap():Define( <cResName>, <cBmpFile>, <oWnd> )

/*----------------------------------------------------------------------------//
!short: SAY  */

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT,VAR > ] <cText> ;
     [ PICTURE <cPict> ] ;
     [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
     [ FONT <oFont> ]  ;
     [ <lCenter: CENTERED, CENTER > ] ;
     [ <lRight:  RIGHT >  ] ;
     [ <lBorder: BORDER > ] ;
     [ <lPixel: PIXEL, PIXELS > ] ;
     [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <design: DESIGN >  ] ;
     [ <update: UPDATE >  ] ;
     [ <lShaded: SHADED, SHADOW > ] ;
     [ <lBox:  BOX   >  ] ;
     [ <lRaised: RAISED > ] ;
    => ;
   [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
     [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
     <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
     <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.> )

/*----------------------------------------------------------------------------//
!short: GET  */

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
    [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
    [ <memo: MULTILINE, MEMO, TEXT> ] ;
    [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
    [ SIZE <nWidth>, <nHeight> ] ;
    [ FONT <oFont> ] ;
    [ <hscroll: HSCROLL> ] ;
    [ CURSOR <oCursor> ] ;
    [ <pixel: PIXEL> ] ;
    [ MESSAGE <cMsg> ] ;
    [ <update: UPDATE> ] ;
    [ WHEN <uWhen> ] ;
    [ <lCenter: CENTER, CENTERED> ] ;
    [ <lRight: RIGHT> ] ;
    [ <readonly: READONLY, NO MODIFY> ] ;
    [ VALID <uValid> ] ;
    [ ON CHANGE <uChange> ] ;
    [ <lDesign: DESIGN> ] ;
    [ <lNoBorder: NO BORDER, NOBORDER> ] ;
    [ <lNoVScroll: NO VSCROLL> ] ;
     => ;
   [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
     [<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
     <nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
     <cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
     <.lRight.>, <.readonly.>, <{uValid}>,;
     [\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,;
     [<.lNoBorder.>], [<.lNoVScroll.>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
    [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
    [ PICTURE <cPict> ] ;
    [ VALID <ValidFunc> ] ;
    [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
    [ SIZE <nWidth>, <nHeight> ]  ;
    [ FONT <oFont> ] ;
    [ <design: DESIGN> ] ;
    [ CURSOR <oCursor> ] ;
    [ <pixel: PIXEL> ] ;
    [ MESSAGE <cMsg> ] ;
    [ <update: UPDATE> ] ;
    [ WHEN <uWhen> ] ;
    [ <lCenter: CENTER, CENTERED> ] ;
    [ <lRight: RIGHT> ] ;
    [ ON CHANGE <uChange> ] ;
    [ <readonly: READONLY, NO MODIFY> ] ;
    [ <pass: PASSWORD> ] ;
    [ <lNoBorder: NO BORDER, NOBORDER> ] ;
    [ <help:HELPID, HELP ID> <nHelpId> ] ;
     => ;
   [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
     [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
     <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
     <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
     <.lCenter.>, <.lRight.>,;
     [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
     <.pass.>, [<.lNoBorder.>], <nHelpId> )

/*----------------------------------------------------------------------------//
!short: SCROLLBAR */

#xcommand @ <nRow>, <nCol> SCROLLBAR [ <oSbr> ] ;
     [ <h: HORIZONTAL> ] ;
     [ <v: VERTICAL> ] ;
     [ RANGE <nMin>, <nMax> ] ;
     [ PAGESTEP <nPgStep> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <up:UP, ON UP> <uUpAction> ] ;
     [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
     [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
     [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
     [ <pos: ON THUMBPOS> <uPos> ] ;
     [ <pixel: PIXEL> ] ;
     [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
     [ OF <oWnd> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oSbr> := ] TScrollBar():New( <nRow>, <nCol>, <nMin>, <nMax>, <nPgStep>,;
     (.not.<.h.>) [.or. <.v.> ], <oWnd>, <nWidth>, <nHeight> ,;
     [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
     [<{uPgDownAction}>], [\{|nPos| <uPos> \}], [<.pixel.>],;
     <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}>,;
     <.lDesign.> )

// for 'non-true ScrollBars' ( when using WS_VSCROLL or WS_HSCROLL styles )

#xcommand DEFINE SCROLLBAR [ <oSbr> ] ;
     [ <h: HORIZONTAL> ] ;
     [ <v: VERTICAL> ] ;
     [ RANGE <nMin>, <nMax> ] ;
     [ PAGESTEP <nPgStep> ] ;
     [ <up:UP, ON UP> <uUpAction> ] ;
     [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
     [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
     [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
     [ <pos: ON THUMBPOS> <uPos> ] ;
     [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ VALID <uValid> ] ;
     => ;
     [ <oSbr> := ] TScrollBar():WinNew( <nMin>, <nMax>, <nPgStep>, ;
     (.not.<.h.>) [.or. <.v.> ], <oWnd>, [<{uUpAction}>],;
     [<{uDownAction}>], [<{uPgUpAction}>], ;
     [<{uPgDownAction}>], [\{|nPos| <uPos> \}],;
     <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}> )

/*----------------------------------------------------------------------------//
!short: BOX - GROUPS */

#xcommand @ <nTop>, <nLeft> [ GROUP <oGroup> ] TO <nBottom>, <nRight > ;
     [ <label:LABEL,PROMPT> <cLabel> ] ;
     [ OF <oWnd> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ <lPixel: PIXEL> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
     <cLabel>, <oWnd>, <nClrFore>, <nClrBack>, <.lPixel.>,;
     [<.lDesign.>] )

/*----------------------------------------------------------------------------//
!short: Meter */

#xcommand @ <nRow>, <nCol> METER [ <oMeter> VAR ] <nActual> ;
    [ TOTAL <nTotal> ] ;
    [ SIZE <nWidth>, <nHeight> ];
    [ OF <oWnd> ] ;
    [ <update: UPDATE > ] ;
    [ <lPixel: PIXEL > ] ;
    [ FONT <oFont> ] ;
    [ PROMPT <cPrompt> ] ;
    [ <lNoPercentage: NOPERCENTAGE > ] ;
    [ <color: COLOR, COLORS> <nClrPane>, <nClrText> ] ;
    [ BARCOLOR <nClrBar>, <nClrBText> ] ;
    [ <lDesign: DESIGN> ] ;
    => ;
  [ <oMeter> := ] TMeter():New( <nRow>, <nCol>, bSETGET(<nActual>),;
    <nTotal>, <oWnd>, <nWidth>, <nHeight>, <.update.>, ;
    <.lPixel.>, <oFont>, <cPrompt>, <.lNoPercentage.>,;
    <nClrPane>, <nClrText>, <nClrBar>, <nClrBText>, <.lDesign.> )

/*----------------------------------------------------------------------------//
!short: Cursor Commands */
/* IMPLEMENTADO ABAIXO PROTHEUS
#xcommand DEFINE CURSOR <oCursor> ;
     [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
     [ <predef: ARROW, ICON, SIZENS, SIZEWE, SIZENWSE,;
    SIZENESW, IBEAM, CROSS, SIZE, UPARROW, WAIT> ] ;
     => ;
   <oCursor> := TCursor():New( <cResName>, [ Upper(<(predef)>) ] )
*/
/*----------------------------------------------------------------------------//
!short: Window Commands */

#xcommand DEFINE WINDOW [<oWnd>] ;
     [ MDICHILD ] ;
     [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
     [ TITLE <cTitle> ] ;
     [ BRUSH <oBrush> ] ;
     [ CURSOR <oCursor> ] ;
     [ MENU <oMenu> ] ;
     [ ICON <oIco> ] ;
     [ OF <oParent> ] ;
     [ <vscroll: VSCROLL, VERTICAL SCROLL> ] ;
     [ <hscroll: HSCROLL, HORIZONTAL SCROLL> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;
     [ STYLE <nStyle> ] ;
     [ <HelpId: HELPID, HELP ID> <nHelpId> ] ;
     [ BORDER <border: NONE, SINGLE> ] ;
     [ <NoSysMenu:  NOSYSMENU, NO SYSMENU> ] ;
     [ <NoCaption:  NOCAPTION, NO CAPTION, NO TITLE> ] ;
     [ <NoIconize:  NOICONIZE, NOMINIMIZE> ] ;
     [ <NoMaximize: NOZOOM, NO ZOOM, NOMAXIMIZE, NO MAXIMIZE> ] ;
     => ;
   [<oWnd> := ] TMdiChild():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
     <cTitle>, <nStyle>, <oMenu>, <oParent>, <oIco>, <.vscroll.>, <nClrFore>,;
     <nClrBack>, <oCursor>, <oBrush>, <.pixel.>, <.hscroll.>,;
     <nHelpId>, [Upper(<(border)>)], !<.NoSysMenu.>, !<.NoCaption.>,;
     !<.NoIconize.>, !<.NoMaximize.>, <.pixel.> )

#xcommand DEFINE WINDOW <oWnd> ;
     [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
     [ TITLE <cTitle> ] ;
     [ STYLE <nStyle> ] ;
     [ MENU <oMenu> ] ;
     [ BRUSH <oBrush> ] ;
     [ ICON <oIcon> ] ;
     [ MDI ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <vScroll: VSCROLL, VERTICAL SCROLL> ] ;
     [ <hScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
     [ MENUINFO <nMenuInfo> ] ;
     [ [ BORDER ] <border: NONE, SINGLE> ] ;
     [ OF <oParent> ] ;
     [ <pixel: PIXEL> ] ;
     => ;
   <oWnd> := TMdiFrame():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
     <cTitle>, <nStyle>, <oMenu>, <oBrush>, <oIcon>, <nClrFore>,;
     <nClrBack>, [<.vScroll.>], [<.hScroll.>], <nMenuInfo>,;
     [Upper(<(border)>)], <oParent>, [<.pixel.>] )

#xcommand DEFINE WINDOW <oWnd> ;
     [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> [<pixel: PIXEL>] ] ;
     [ TITLE <cTitle> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ];
     [ OF <oParent> ] ;
     [ BRUSH <oBrush> ] ;                // Contained Objects
     [ CURSOR <oCursor> ] ;
     [ ICON <oIcon> ] ;
     [ MENU <oMenu> ] ;
     [ STYLE <nStyle> ] ;                 // Styles
     [ BORDER <border: NONE, SINGLE> ] ;
     [ <NoSysMenu:  NOSYSMENU, NO SYSMENU> ] ;
     [ <NoCaption:  NOCAPTION, NO CAPTION, NO TITLE> ] ;
     [ <NoIconize:  NOICONIZE, NOMINIMIZE> ] ;
     [ <NoMaximize: NOZOOM, NO ZOOM, NOMAXIMIZE, NO MAXIMIZE> ] ;
     [ <vScroll: VSCROLL, VERTICAL SCROLL> ] ;
     [ <hScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
     => ;
   <oWnd> := TWindow():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
     <cTitle>, <nStyle>, <oMenu>, <oBrush>, <oIcon>, <oParent>,;
     [<.vScroll.>], [<.hScroll.>], <nClrFore>, <nClrBack>, <oCursor>,;
     [Upper(<(border)>)], !<.NoSysMenu.>, !<.NoCaption.>,;
     !<.NoIconize.>, !<.NoMaximize.>, <.pixel.> )

#xcommand ACTIVATE WINDOW <oWnd> ;
     [ <show: ICONIZED, NORMAL, MAXIMIZED> ] ;
     [ ON [ LEFT ] CLICK <uLClick> ] ;
     [ ON LBUTTONUP <uLButtonUp> ] ;
     [ ON RIGHT CLICK <uRClick> ] ;
     [ ON MOVE <uMove> ] ;
     [ ON RESIZE <uResize> ] ;
     [ ON PAINT <uPaint> ] ;
     [ ON KEYDOWN <uKeyDown> ] ;
     [ ON INIT <uInit> ] ;
     [ ON UP <uUp> ] ;
     [ ON DOWN <uDown> ] ;
     [ ON PAGEUP <uPgUp> ] ;
     [ ON PAGEDOWN <uPgDn> ] ;
     [ ON LEFT <uLeft> ] ;
     [ ON RIGHT <uRight> ] ;
     [ ON PAGELEFT <uPgLeft> ] ;
     [ ON PAGERIGHT <uPgRight> ] ;
     [ ON DROPFILES <uDropFiles> ] ;
     [ VALID <uValid> ] ;
     => ;
   <oWnd>:Activate( [ Upper(<(show)>) ],;
      <oWnd>:bLClicked [ := \{ |nRow,nCol,nKeyFlags| <uLClick> \} ], ;
      <oWnd>:bRClicked [ := \{ |nRow,nCol,nKeyFlags| <uRClick> \} ], ;
      <oWnd>:bMoved   [ := <{uMove}> ], ;
      <oWnd>:bResized  [ := <{uResize}> ], ;
      <oWnd>:bPainted  [ := \{ | hDC, cPS | <uPaint> \} ], ;
      <oWnd>:bKeyDown  [ := \{ | nKey | <uKeyDown> \} ],;
      <oWnd>:bInit    [ := \{ | Self | <uInit> \} ],;
      [<{uUp}>], [<{uDown}>], [<{uPgUp}>], [<{uPgDn}>],;
      [<{uLeft}>], [<{uRight}>], [<{uPgLeft}>], [<{uPgRight}>],;
      [<{uValid}>], [\{|nRow,nCol,aFiles|<uDropFiles>\}],;
      <oWnd>:bLButtonUp [ := <{uLButtonUp}> ] )

/*----------------------------------------------------------------------------//
!short: MESSAGE BAR */

#xcommand SET MESSAGE [ OF <oWnd> ] ;
     [ TO <cMsg> ] ;
     [ <center: CENTER, CENTERED> ] ;
     [ <clock: CLOCK, TIME> ] ;
     [ <date: DATE> ] ;
     [ <kbd: KEYBOARD> ] ;
     [ FONT <oFont> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
     [ <inset: NO INSET, NOINSET> ] ;
     => ;
   <oWnd>:oMsgBar := TMsgBar():New( <oWnd>, <cMsg>, <.center.>,;
          <.clock.>, <.date.>, <.kbd.>,;
          <nClrFore>, <nClrBack>, <oFont>,;
          [!<.inset.>] )

#xcommand DEFINE MESSAGE [ BAR ] [<oMsg>] ;
     [ OF <oWnd> ] ;
     [ PROMPT <cMsg> ] ;
     [ <center: CENTER, CENTERED> ] ;
     [ <clock: CLOCK, TIME> ] ;
     [ <date: DATE> ] ;
     [ <kbd: KEYBOARD> ] ;
     [ FONT <oFont> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
     [ <inset: NO INSET, NOINSET> ] ;
    => ;
  [<oMsg>:=] <oWnd>:oMsgBar := TMsgBar():New( <oWnd>, <cMsg>, <.center.>,;
          <.clock.>, <.date.>, <.kbd.>,;
          <nClrFore>, <nClrBack>, <oFont>,;
          [!<.inset.>] )

#xcommand DEFINE MSGITEM [<oMsgItem>] ;
     [ OF <oMsgBar> ] ;
     [ PROMPT <cMsg> ] ;
     [ SIZE <nSize> ] ;
     [ FONT <oFont> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
     [ ACTION <uAction> ] ;
     => ;
   [<oMsgItem>:=] TMsgItem():New( <oMsgBar>, <cMsg>, <nSize>,;
        <oFont>, <nClrFore>, <nClrBack>, .t.,;
        [<{uAction}>] )

/*----------------------------------------------------------------------------//
!short: Timer */

#xcommand DEFINE TIMER [ <oTimer> ] ;
     [ INTERVAL <nInterval> ] ;
     [ ACTION <uAction,...> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     => ;
   [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}], <oWnd> )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

/*----------------------------------------------------------------------------//
!short: PANEL */

#xcommand @ <nRow>, <nCol> MSPANEL [ <oPanel> <label: PROMPT,VAR > ] <cText> ;
     [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
     [ FONT <oFont> ]  ;
     [ <lCenter: CENTERED, CENTER > ] ;
     [ <lRight:  RIGHT >  ] ;
     [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <lLowered: LOWERED >  ] ;
     [ <lRaised: RAISED > ] ;
    => ;
   [ <oPanel> := ] TPanel():New( <nRow>, <nCol>, <cText>,;
     [<oWnd>], <oFont>, <.lCenter.>, <.lRight.>, ;
     <nClrText>, <nClrBack>, <nWidth>, <nHeight>, <.lLowered.>,;
     <.lRaised.> )

//----------------------------------------------------------------------------//
//????????????????????????????????????????????????????????????????????????
//? Comandos especificos para PROTHEUS (bof)                   ?
//????????????????????????????????????????????????????????????????????????
#xcommand DEFINE ICON <oIcon> ;
     [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
     [ WHEN <WhenFunc> ] ;
     => ;
   <oIcon> := <cResName>

#xcommand @ <nRow>, <nCol> ICON [ <oIcon> ] ;
     [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
     [ <border:BORDER> ] ;
     [ ON CLICK <uClick> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;     
     => ;
   [ <oIcon> := ] TBitmap():New( <nRow>, <nCol>, 32, 32,;
     <cResName>,<cIcoFile>,.T.,<oWnd>,;
     <{uClick}>,,,,,,,;
     <{uWhen}>,<.pixel.>,,,.T.)

#xcommand @ <nRow>, <nCol> SCROLLBOX [ <oSbr> ] ;
     [ <h: HORIZONTAL> ] ;
     [ <v: VERTICAL> ] ;
     [ SIZE <nHeight>,<nWidth> ] ;
     [ OF <oWnd> ] ;
     [ <lBorder: BORDER> ];
     => ;
   [ <oSbr> := ] TScrollBox():New( [<oWnd>], <nRow>, <nCol>, <nHeight>, <nWidth>,;
          <.v.>,<.h.>,<.lBorder.> )

#xcommand DEFINE CURSOR <oCursor> ;
     [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
     [ <predef: ARROW, ICON, SIZENS, SIZEWE, SIZENWSE,;
    SIZENESW, IBEAM, CROSS, SIZE, UPARROW, WAIT, HAND> ] ;
     => ;
   <oCursor> := If( <.predef.>, [ Upper(<(predef)>) ], <cResName> )

#xcommand DEFINE MAINTOOLBAR <oBar> OF <oWnd> => <oBar>:= TMainToolBar():New( <oWnd> )

#xcommand DEFINE MAINTOOLBARBUTTON <oBtn> OF <oBar>;
    [ PROMPT <cPrompt> ];
    [ RESOURCE <cResource> ];
    [ COLOR <nClrBack>,<nClrFore> ];
    [ FONT <oFont> ];
    [ ACTION <bAction> ]=>;
    <oBtn>:= TMainToolBarButton():New( <oBar>,[<cPrompt>],[<cResource>],;
       [<nClrBack>],[<nClrFore>], [<oFont>],[<{bAction}>] )

#xcommand MENU <oMenu> ADDBUTTON [ CAPTION <cCaption>];
      [ IMAGE <cImage> ];
      [ SERVER_ACTION <uSrvAction> ];
      [ CLIENT_ACTION <uCliAction> ] => <oMenu>:AddButton( [<cCaption> ],[<{uSrvAction}>],[<{uCliAction}>],[<cImage>] )


#xcommand @ <nRow>, <nCol> MSGRAPH [ <oGraph> ] ;
     [ SIZE <nHeight>,<nWidth> ] ;
     [ OF <oWnd> ] ;
     [ TYPE <cType: LINE, BAR, AREA> ];
     => ;
   [ <oGraph> := ] TMSGraph():New( <nRow>, <nCol>, [<nHeight>], [<nWidth>],;
          [<(cType)>], [<oWnd>] )

#xtranslate oSend( <o>,<m> [,<param,...>] ) => OSEND <o> METHOD <m> [ PARAM \{<param>\} ]
#xtranslate OSEND <o> METHOD <m> [PARAM <param>] => PT_oSend( <(o)>,<m>,<o> [,<param> ] )
#xtranslate OSEND <o>() METHOD <m> [PARAM <param>] => PT_oSend( <(o)>+"()",<m>, [,<param>] )


/*----------------------------------------------------------------------------//
!short: WORKTIME */

#xcommand @ <nRow>, <nCol> WORKTIME [ <oWorktime> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ RESOLUTION <nResolution> ] ;
     [ VALUE <cValue> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ WHEN <WhenFunc> ] ;
     [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
    => ;
  [ <oWorktime> := ] MsWorkTime():New( <oWnd>, <nRow>, <nCol>, <nWidth>, <nHeight>,;
  [<nResolution>], [<cValue>], <{WhenFunc}>, [<{uClick}>] )

//????????????????????????????????????????????????????????????????????????
//? Comandos especificos para PROTHEUS (eof)                             ?
//????????????????????????????????????????????????????????????????????????
#endif
