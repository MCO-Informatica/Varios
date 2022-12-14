#include 'std.ch'
#xCommand Debug <Flds,...> => MsgDbg(\{ <Flds> \}
#XCOMMAND @ <nRow>, <nCol> PSAY <cText> [ PICTURE <cPict> ] => PrintOut(<nRow>,<nCol>,<cText>,<cPict>)
#Translate PROW( => _PROW(
#Translate PCOL( => _PCOL(
#TransLate DEVPOS( => _DEVPOS(
#Translate EXECUTE( => IW_Exec(
#Translate PLAYWAVE( => IW_Wave(
#Translate CLOSE( => IW_End(
#Translate MSGBOX( => IW_MsgBox(
#Command @ <nRow>, <nCol> TO <nToRow>,<nToCol> DIALOG <oDlg> [TITLE <cTitle>] ;
	=> <oDlg> := IW_Window(<nRow>, <nCol>, <nToRow>,<nToCol>,[<cTitle>])
#Command @ <nRow>, <nCol> BITMAP [<oBmp>] SIZE <nWidth>,<nHeight> FILE <cFile> ;
	=> [ <oBmp> := ] IW_BitMap(<nRow>, <nCol>, <nWidth>,<nHeight>,<cFile>)
#Command @ <nRow>, <nCol> BUTTON <cCaption> [SIZE <nWidth>,<nHeight>] ACTION <cAction> [ OBJECT <oBtn>] ;
	=> [ <oBtn> := ] IW_Button(<nRow>, <nCol>, <cCaption>,<(cAction)>,<nWidth>,<nHeight>)
#Command ACTIVATE DIALOG <oDlg> [<center: CENTERED,CENTER>] [ ON INIT <cInit> ] [ VALID <cValid> ] ;
	=> IW_Activate(<oDlg> , <.center.> ,[<(cInit)>],[<(cValid)>])
#Command @ <nRow>,<nCol> SAY <cSay> [PICTURE <cPicture>] [<color: COLOR,COLORS> <nCor> [,<nCorBack>] ] [SIZE <nWidth> [,<nHeight>] ] [OBJECT <oSay>] ;
	=> [ <oSay> := ] IW_Say(<nRow>,<nCol>,<cSay>,[<cPicture>],[<nCor>],[<nCorBack>],[<nWidth>],[<nHeight>],<{cSay}>)
#Command @ <nRow>,<nCol> LISTBOX <nList> ITEMS <aList> SIZE <nWidth>,<nHeight> [<sort: SORTED>] [OBJECT <oLbx>] ;
	=> [ <oLbx> := ] IW_ListBox(<nRow>,<nCol>,<(nList)>,<aList>,[<.sort.>],<nWidth>,<nHeight>)
#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> [TITLE <cTitle>] [OBJECT <oGrp>] ;
	=> [ <oGrp> := ] IW_GroupBox(<nRow>,<nCol>,<nToRow>,<nToCol>,[<cTitle>])
#Command @ <nRow>,<nCol> CHECKBOX <cCaption> VAR <lCheck> [OBJECT <oCbx>];
	=> [ <oCbx> := ] IW_CheckBox(<nRow>,<nCol>,<cCaption>,<(lCheck)>)
#Command @ <nRow>,<nCol> RADIO <aRadio> VAR <nSelect> [OBJECT <oRdx>] ;
	=> [ <oRdx> := ] IW_Radio(<nRow>,<nCol>,<(nSelect)>,<aRadio>)
#Command @ <nRow>,<nCol> COMBOBOX <cVar> ITEMS <aCombo> SIZE <nWidth>,<nHeight> [OBJECT <oCox>] ;
	=> [ <oCox> := ] IW_ComboBox(<nRow>,<nCol>,<(cVar)>,<aCombo>,<nWidth>,<nHeight>)
#Command @ <nRow>,<nCol> GET <cVar> [PICTURE <cPicture>] [VALID <cValid>] [WHEN <cWhen>] [F3 <cF3>] [SIZE <nW>,<nH>] [OBJECT <oGet>] [<lMemo: MEMO>] [<lPass: PASSWORD>];
	=> [ <oGet> := ] IW_Edit(<nRow>,<nCol>,<(cVar)>,[<cPicture>],<nW>,<nH>,[<(cValid)>],[<(cWhen)>],[<cF3>],[<.lMemo.>],[<.lPass.>])
#Command @ <nRow>, <nCol> BMPBUTTON TYPE <nType> ACTION <cAction> [OBJECT <oBmt>] ;
	=> [ <oBmt> := ] IW_BmpButton(<nRow>, <nCol>,<(cAction)>,<nType>)
#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> BROWSE <cAlias> [MARK <cMark>] [ENABLE <cEnable>] [ OBJECT <oBrw> ] [ FIELDS <aFields> ];
	=> [ <oBrw> := ] IW_Browse(<nRow>,<nCol>,<nToRow>,<nToCol>,<cAlias>,<cMark>,<cEnable> [,<aFields>])
#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> MULTILINE [<lModi: MODIFY>] [<lDel: DELETE>] [VALID <cLineOk>] [FREEZE <nFreeze>] [OBJECT <oMtl>] ;
	=> [ <oMtl> := ] IW_MultiLine(<nRow>,<nCol>,<nToRow>,<nToCol>,<.lModi.>,<.lDel.>,<(cLineOk)>,<nFreeze>)
#xcommand DEFINE TIMER [ <oTimer> ] [ INTERVAL <nInterval> ] [ ACTION <uAction,...> ] ;
	=> [ <oTimer> := ] IW_Timer( <nInterval>, [{||<uAction>}] ) 
#xcommand ACTIVATE TIMER <oTimer> => IW_TimerActive(<oTimer>)
	