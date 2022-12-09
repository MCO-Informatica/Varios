#Include "PROTHEUS.CH"        

USER FUNCTION GFAT0002( )
Local Ar
Local oGet1
Public cGet1:="           " 
Static oDlg

IF M->C5_VEND1 == "VA0012"
 
 DEFINE MSDIALOG oDlg TITLE "SELECIONE/DIGITE A AR" FROM 000, 000  TO 010, 027 COLORS PIXEL
    @ 020, 029 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg F3 "SZ3" PIXEL 
    @ 020, 003 SAY Ar PROMPT "AR" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 048, 009 BUTTON OK PROMPT "OK" SIZE 037, 012 OF oDlg PIXEL;
    Action (oDlg:End ( ) ) Valid EXISTCPO("SZ3",cGet1)
    @ 048, 056 BUTTON Cancelar PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL;
    Action ( oDlg:End()) Cancel Of oDlg
  ACTIVATE MSDIALOG oDlg CENTERED 
  
EndIf

Return(cGet1)