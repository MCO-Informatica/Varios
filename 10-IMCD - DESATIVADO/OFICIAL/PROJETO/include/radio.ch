//зддддддддддддддддддддддддддддддддддддддд©
//Ё Monta condicoes para a funcao MsRadio Ё
//юддддддддддддддддддддддддддддддддддддддды
#xcommand @ <nRow>, <nCol> MSRADIO [ <oRadMenu> VAR ] <nVar> ;
[ <prm: PROMPT, ITEMS> <aItems> ] ;
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
[ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, <aItems>,;
[bSETGET(<nVar>)], <oWnd>, [{<nHelpId>}], <{uChange}>,;
<nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
<nWidth>, <nHeight>, <{uValid}>, <.lDesign.>, <.lLook3d.>,;
<.lPixel.> )
