#include "PROTHEUS.CH"
#include "RWMAKE.CH"

User Function CMPCPAUT()
 Local nSavInd := IndexOrd()
 LOCAL nSavRec := RecNO()
 PRIVATE nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
 PRIVATE nTamTip := TamSX3("E2_TIPO")[1]
 Private  aCores :={ { 'E2_SALDO = E2_VALOR .AND. E2_ACRESC = E2_SDACRES','ENABLE'},; // Titulo nao Compensado      
                                { 'E2_SALDO =  0'         , 'DISABLE'},; // Titulo Compensado Totalmente       
                                { 'E2_SALDO <> 0'         , 'BR_AZUL'} } // Titulo Compensado Parcialmente
 //旼컴컴컴컴컴컴컴컴컴컴컴컴?
 //? Define Variaveis   
 ? //읕컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE aRotina := {  { "Pesquisar","AxPesqui"  , 0 , 1,,.F. },;  //"Pesquisar"      
                                  { "Visualizar","AxVisual"  , 0 , 2 },;  //"Visualizar"      
                                  { "Compensar","U_XAFCMPAD" , 0 , 4 },;  //"Compensar"       
                                  { "Excluir","Fa340Desc" , 0 , 4 },;  //"Excluir"      
                                  { "Legenda","Fa340Leg"  ,0,2, ,.F.} }      //"Legenda"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
 //? Carrega fun뇙o Pergunte                                     
? //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//SetKey (VK_F12,{|a,b| AcessaPerg("AFI340",.T.)})
 Pergunte("AFI340",.F.)
 //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define o cabe놹lho da tela de baixas    ?
 //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE cCadastro := "Compensa豫o de Titulos Automatico"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica o numero do Lote     
   ? //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//PRIVATE cLoteLoteCont( "FIN" )
PRIVATE VALOR  := 0
PRIVATE VLRINSTR := 0 
Private aTxMoedas := {}
 dbSelectArea("SE2")
 dbSetOrder(1)
 dbGoTop() 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Endere놹 a Fun뇙o de BROWSE    
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
mBrowse( 6, 1,22,75,"SE2",,,,,,aCores)
 dbSelectArea("SE2")
 dbSetOrder(nSavInd)
 dbGoTo(nSavRec)
Return 

/* Programa | XAFCMPAD
==========================================================
 Desc.    | Realiza a compensa豫o do titulo de adiantamento 
      */ 
uSER Function XAFCMPAD()
   Local aArea  := GetArea()
   Local aAreaSE2  := SE2->(GetArea())
   Local aRecPA    := {} // Array contendo os Recnos dos titulos PA
   Local aRecAux := {}
   Local nX  := 0
   Local lContabiliza := .F.
   Local lAglutina    := .F.
   Local lDigita    := .F.
   Local aRecSE2 := {SE2->(Recno())}
   LOCAL oDlg
   LOCAL nOpca := 0
   Local dBaixaCMP := dDataBase
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎arrega o pergunte da rotina de compensa豫o financeira?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
 
PERGUNTE("AFI340",.F.)
 lContabiliza := MV_PAR11 == 1
 lAglutina  := MV_PAR08 == 1
 lDigita   := MV_PAR09 == 1
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿚rdena豫o das tabelas envolvidas?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SE2->(dbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
 aRecAux := {}
 aRecAux := XGetTitAd(SE2->E2_FORNECE,SE2->E2_LOJA )
 For nX := 1 To Len(aRecAux)
     aADD(aRecPA,aRecAux[nX])
 Next nX
 If !Empty(aRecPA)
				    DEFINE MSDIALOG oDlg FROM 080,000 TO 190,260 TITLE "Data de Baixa para a Compensa豫o" PIXEL
				    oDlg:lMaximized := .F.
				    oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20) 
				    oPanel:Align := CONTROL_ALIGN_ALLCLIENT   
                     @ 015, 010 SAY "Dt. Baixa: " SIZE 52, 08 OF oPanel PIXEL 
                     @ 015, 035 MSGET dBaixaCMP Valid !Empty(dBaixaCMP) SIZE 52, 08 OF oPanel PIXEL hasbutton  
                     DEFINE SBUTTON FROM 034,050 TYPE 1 ACTION {||oDlg:End(),nOpca:=1} ENABLE OF oDlg 
                     DEFINE SBUTTON FROM 034,080 TYPE 2 ACTION {||oDlg:End(),nOpca:=0} ENABLE OF oDlg  
                     ACTIVATE MSDIALOG oDlg CENTERED 
                   If nOpca == 1 .and. !MaIntBxCP(2,aRecSE2,,aRecPA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,dBaixaCMP)    
                   Help("XAFCMPAD",1,"HELP","XAFCMPAD","N?o foi poss?vel a compensa豫o"+CRLF+" do titulo do adiantamento",1,0)    
            ElseIf nOpca == 0  
                     MsgInfo("Processo n?o realizado por desist?ncia do usu?rio","Atencao")   
            Else     
                     MsgInfo("Compensa豫o Autom?tica Concluida","Atencao")   
             EndIf
EndIf
   RestArea(aAreaSE2)
   RestArea(aArea)
Return 

Static Function XGetTitAd( cFornece,cLoja )
    Local aArea  := GetArea()
    Local aRecPA := {} // Array contendo os Recnos dos titulos PA
    Local cQuery := ""
    Local cTab  := GetNextAlias()
   If Select(cTab) > 0 
           (cTab)->(dbCloseArea())
  EndIf
cQuery += " SELECT "
cQuery += "  R_E_C_N_O_ SE2REC  "
cQuery += " FROM " + RetSqlTab("SE2")
cQuery += " WHERE  " 
cQuery += "  E2_FORNECE = '"+cFornece+"' AND "
cQuery += "  E2_LOJA  = '"+cLoja+"'  AND "
cQuery += "  E2_TIPO IN ('PA ','NDF') AND "
cQuery += "  E2_SALDO > 0 AND "
 cQuery  += RetSQLCond("SE2")
         cQuery := ChangeQuery(cQuery)
         dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTab, .F., .T.)
   (cTab)->(dbGoTop())
While (cTab)->(!EOF()) 
   aAdd(aRecPA,(cTab)->SE2REC) 
  (cTab)->(dbSkip()) 
EndDo
          (cTab)->(dbCloseArea())
RestArea(aArea)
Return aRecPA