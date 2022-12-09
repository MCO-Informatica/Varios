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
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 //³ Define Variaveis   
 ³ //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := {  { "Pesquisar","AxPesqui"  , 0 , 1,,.F. },;  //"Pesquisar"      
                                  { "Visualizar","AxVisual"  , 0 , 2 },;  //"Visualizar"      
                                  { "Compensar","U_XAFCMPAD" , 0 , 4 },;  //"Compensar"       
                                  { "Excluir","Fa340Desc" , 0 , 4 },;  //"Excluir"      
                                  { "Legenda","Fa340Leg"  ,0,2, ,.F.} }      //"Legenda"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Carrega fun‡„o Pergunte                                     
³ //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetKey (VK_F12,{|a,b| AcessaPerg("AFI340",.T.)})
 Pergunte("AFI340",.F.)
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas    ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := "Compensação de Titulos Automatico"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote     
   ³ //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//PRIVATE cLoteLoteCont( "FIN" )
PRIVATE VALOR  := 0
PRIVATE VLRINSTR := 0 
Private aTxMoedas := {}
 dbSelectArea("SE2")
 dbSetOrder(1)
 dbGoTop() 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endere‡a a Fun‡„o de BROWSE    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"SE2",,,,,,aCores)
 dbSelectArea("SE2")
 dbSetOrder(nSavInd)
 dbGoTo(nSavRec)
Return 

/* Programa | XAFCMPAD
==========================================================
 Desc.    | Realiza a compensação do titulo de adiantamento 
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o pergunte da rotina de compensação financeira³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
PERGUNTE("AFI340",.F.)
 lContabiliza := MV_PAR11 == 1
 lAglutina  := MV_PAR08 == 1
 lDigita   := MV_PAR09 == 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenação das tabelas envolvidas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE2->(dbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
 aRecAux := {}
 aRecAux := XGetTitAd(SE2->E2_FORNECE,SE2->E2_LOJA )
 For nX := 1 To Len(aRecAux)
     aADD(aRecPA,aRecAux[nX])
 Next nX
 If !Empty(aRecPA)
				    DEFINE MSDIALOG oDlg FROM 080,000 TO 190,260 TITLE "Data de Baixa para a Compensação" PIXEL
				    oDlg:lMaximized := .F.
				    oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20) 
				    oPanel:Align := CONTROL_ALIGN_ALLCLIENT   
                     @ 015, 010 SAY "Dt. Baixa: " SIZE 52, 08 OF oPanel PIXEL 
                     @ 015, 035 MSGET dBaixaCMP Valid !Empty(dBaixaCMP) SIZE 52, 08 OF oPanel PIXEL hasbutton  
                     DEFINE SBUTTON FROM 034,050 TYPE 1 ACTION {||oDlg:End(),nOpca:=1} ENABLE OF oDlg 
                     DEFINE SBUTTON FROM 034,080 TYPE 2 ACTION {||oDlg:End(),nOpca:=0} ENABLE OF oDlg  
                     ACTIVATE MSDIALOG oDlg CENTERED 
                   If nOpca == 1 .and. !MaIntBxCP(2,aRecSE2,,aRecPA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,dBaixaCMP)    
                   Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)    
            ElseIf nOpca == 0  
                     MsgInfo("Processo não realizado por desistência do usuário","Atencao")   
            Else     
                     MsgInfo("Compensação Automática Concluida","Atencao")   
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