#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH" 
#INCLUDE "Rwmake.CH"
  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120BUT  บAutor  ณROBSON BUENO        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada na Ordem de Compra (PC) para agregar       บฑฑ
ฑฑบ          ณobservacoes especificas do negocio HCI (VIA CONTRATO)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function QNC040BUT()             

aAdd(aRotina, {"Reabre NC","U_MAQNC01()" , 0 , 6})
aAdd(aRotina, {"Itens NC","U_QNCITPV()" , 0 , 6})		  
  
Return()
//{{},{"Reabre NC","U_MAQNC01()" , 0 , 6}}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B1   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarrar Observacao na OC                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAQNC01(cAlias, nRecno, nOpc)

  Local aAreaAtu	:= GetArea()												// Salva a area atual
  Local lRet		:= .T.
  Local oDlgL
  Local cRnc := QI2->QI2_FNC
  Local cTitulo :="Reabertura de RNC Encerrada"
  @ 000,000 To 100,400 Dialog Odlg1 Title OemToAnsi("Rotina p/ migrar produto")
  @ 003,008 To 45,200 Title OemToAnsi("Deseja realmente reabrir RNC No: "+ cRnc + "?")
  @ 015,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,cRnc)},cTitulo,"Atualizando dados, aguarde...")
  @ 015,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
  Activate Dialog Odlg1 CENTER

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc(odlg1,cRnc)

  dbSelectArea("QI2")
  DbSetOrder(2)
  IF MsSeek(xFilial("QI2")+crnc)
    Reclock("QI2",.F.)
    QI2->QI2_CONREA:=CTOD("  /  /  ")
    MsUnLock()
  endif
Close(Odlg1)
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlg1)

Close(Odlg1)

Return          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B3   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarrar Oc a PV                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function QNCITPV(cAlias, nRecno, nOpc)
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local lConfirma :=.F.
Local oDlgL
Local cNumeroNc:=Space(15)
LOCAL cRevisao:=Space(2)
Local dData
Local cTipo:=Space(2)
Local cNumero:= Space(6)
Local cNome  := Space(50)
Local cResult:=space(50)
Local cCod  
Local cLoja
Local cTitulo :="Itens da Nao Conformidade"
Private oGet2 
IF QI2->QI2_NUMERO="      " 
  Aviso("Atencao","Operacao nao permitida se numero em branco",{"Voltar"},2)
  RestArea(aAreaATU)
  RETURN
ENDIF 
cNumeroNc:=SUBSTRING(QI2->QI2_FNC,6,6)+"/"+SUBSTRING(QI2->QI2_FNC,12,4)
cRevisao :=QI2->QI2_REV
dData    :=QI2->QI2_REGIST
cTipo    :=QI2->QI2_TIPO
cNumero  :=QI2->QI2_NUMERO
cNome    :=if(cTipo=="PV",Posicione("SA1",1,xFilial("SA1")+QI2->QI2_CODCLI+QI2->QI2_LOJCLI,"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+QI2->QI2_CODFOR+QI2->QI2_LOJFOR,"A2_NOME")) 
cCod     :=if(cTipo=="PV",QI2->QI2_CODCLI,QI2->QI2_CODFOR)
cLoja    :=if(cTipo=="PV",QI2->QI2_LojCLi,QI2->QI2_LojFor)
cResult  :=if(cTipo=="PV","Pedido de Venda","Ordem de Compra") 
DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Itens da Nao Conformidade") FROM C(178),C(181) TO C(645),C(963) PIXEL

@ C(014),C(005) Say "NaoConf.N.: " + cNumeroNc + " - " + "Revisao : " + cRevisao +  "- Emissao: " + DTOC(dData)  Size C(350),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF _oDlg
@ C(024),C(005) Say "Tipo      :  "+ cResult + " - " + "Numero: " + cNumero  Size C(350),C(008) COLOR CLR_BLUE PIXEL OF _oDlg

GetDoc2(SUBSTRING(QI2->QI2_FNC,6,10),cTipo,cNumero)

//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| (lConfirma := .t.,_oDlg:End())},{||_oDlg:End()},,)                                                                                 
If lConfirma
   FOR nLin:=1 to len(oGet2:acols)
//     IF oGet2:ACOLS[nLin,10]="MAN" .OR. oGet2:ACOLS[nLin,7]>0 
       dbSelectArea("SZG")
       DbSetOrder(1)
       IF MsSeek(xFilial("SZG")+SUBSTRING(QI2->QI2_FNC,6,10)+SPACE(20-LEN(SUBSTRING(QI2->QI2_FNC,6,10)))+oGet2:ACOLS[nLin,1])
         Reclock("SZG",.F.)
       ELSE
         Reclock("SZG",.T.)
       ENDIF
       IF OGET2:ACOLS[nLin,14]==.T.
         SZG->(DbDelete())
       ELSE  
        
        //"ZG_NCITEM","ZG_TIPO","ZG_REF","ZG_ITEM","ZG_COD","ZG_DESCRI","ZG_QT","ZG_QTNC","ZG_RI","ZG_CORRIDA","ZG_NF","ZG_NFITEM","ZG_DATA","ZG_PONTOS"
        //     1     ,    2    ,     3  ,   4     ,   5    ,    6      ,   7   ,   8     ,   9   ,   10       ,  11   ,    12     ,   13    ,    14 
         SZG->ZG_FILIAL :=xfilial("SZG")                 	// FILIAL
         SZG->ZG_NC     :=SUBSTRING(QI2->QI2_FNC,6,10)   	// NUMERO DA NAO CONFORMIDADE
         SZG->ZG_TIPO   :=cTipo     				    	// TIPO PV OU OC 
         SZG->ZG_REF    :=oGet2:ACOLS[nLin,3]             	// NUMERO DO PV/OC
         SZG->ZG_ITEM   :=oGet2:ACOLS[nLin,4]             	// ITEM PV/OC
         SZG->ZG_COD    :=oGet2:ACOLS[nLin,5]           	// DATA PROGRAMACAO
         SZG->ZG_DESCRI :=oGet2:ACOLS[nLin,6]           	// CONTATO
         SZG->ZG_QT     :=oGet2:ACOLS[nLin,7]              // DATA FOLLOWUP
         SZG->ZG_QTNC   :=oGet2:ACOLS[nLin,8]          	// SITUACAO DO FOLLOWUP
         SZG->ZG_NF     :=oGet2:ACOLS[nLin,11]              // USUARIO RESPONSAVEL PELO AGENDAMENTO
         SZG->ZG_DATA   :=oGet2:ACOLS[nLin,12]              // Processo encerrado s/n
         SZG->ZG_NCITEM :=oGet2:ACOLS[nLin,1]              // Processo encerrado s/n
         SZG->ZG_RI     :=oGet2:ACOLS[nLin,9]              // Processo encerrado s/n
         SZG->ZG_CORRIDA:=oGet2:ACOLS[nLin,10]              // Processo encerrado s/n
         SZG->ZG_PONTOS :=oGet2:ACOLS[nLin,13]              // Processo encerrado s/n
       ENDIF
       MsUnLock()
    // ENDIF
   next
ENDIF
RestArea(aAreaATU)
Return(.T.)

                 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณGetDocs1()  ณ Autor ณ Robson Bueno          ณ Data ณ13/02/07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados - Compras Casadas                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDoc2(cNum,cTipo,cNumero)
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZG_NCITEM","ZG_TIPO","ZG_REF","ZG_ITEM","ZG_COD","ZG_DESCRI","ZG_QT","ZG_QTNC","ZG_RI","ZG_CORRIDA","ZG_NF","ZG_NFITEM","ZG_DATA","ZG_PONTOS"}                                                                                                
Local aAlter       	:= {"ZG_NCITEM","ZG_TIPO","ZG_REF","ZG_ITEM","ZG_COD","ZG_DESCRI","ZG_QT","ZG_QTNC","ZG_RI","ZG_CORRIDA","ZG_NF","ZG_NFITEM","ZG_DATA","ZG_PONTOS"}                                                                                                
Local nSuperior    	:= C(044)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(219)           
Local nDireita     	:= C(390)           
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE                                                                          
//Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cLinhaOk     	:= "U_szgok()"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TdObs1()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= "+ZG_NCITEM"    // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                       // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                       // segundo campo>+..."                                                               
Local nFreeze      	:= 000             // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCola       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	ENDIF                                                                                                                         
Next nX                                                                                                                         
// Carrega aCol                                                                                         
DbSelectArea("SZG")                                                                                                             
SZG->(DbSetOrder(1)) // Campo                                                                                                   
if SZG->(DbSeek(xFilial("SZG")+cNum))
	While xFilial("SZG") == SZG->ZG_FILIAL .and. ! SZG->(Eof()) .and. TRIM(SZG->ZG_NC) == cNum  
		aAdd(aCola,{SZG->ZG_NCITEM,SZG->ZG_TIPO,SZG->ZG_REF,SZG->ZG_ITEM,SZG->ZG_COD,SZG->ZG_DESCRI,SZG->ZG_QT,SZG->ZG_QTNC,SZG->ZG_RI,SZG->ZG_CORRIDA,SZG->ZG_NF,SZG->ZG_DATA,SZG->ZG_PONTOS,.F.})
		SZG->(DbSkip())
	EndDo 
                                                                                                
Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
    Aadd(aAux,.F.)
    Aadd(aColA,aAux) 
    // atribui o valor 1 para o campo sequencia
    aCOLA[1,aScan(aHead,{|x|Trim(x[2])=="ZG_NCITEM"})] := "0001" 
    aCOLA[1,aScan(aHead,{|x|Trim(x[2])=="ZG_TIPO"  })] := cTipo 
    aCOLA[1,aScan(aHead,{|x|Trim(x[2])=="ZG_REF"  })] := cNumero                                                                   
Endif
// cLinhaOk                                                                    
oGet2 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,{ || U_szgok(nOpc)},{|| .T.},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColA)                                   
Return Nil 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER Function Szgok(nOpc)                                                         
  LOCAL lRet:=.t.

Return(lRet) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER Function VLQNCBT()      
    Local cCodRet
     //"ZG_NCITEM","ZG_TIPO","ZG_REF","ZG_ITEM","ZG_COD","ZG_DESCRI","ZG_QT","ZG_QTNC","ZG_RI","ZG_CORRIDA","ZG_NF","ZG_ITEMNF","ZG_DATA","ZG_PONTOS"
     //     1     ,    2    ,     3  ,   4     ,   5    ,    6      ,   7   ,   8     ,   9   ,   10       ,  11   ,    12     ,   13    ,    14 
    IF ACOLS[N,2]="PV"
         dbSelectArea("SC6")
         DbSetOrder(1)
         MsSeek(xFilial("SC6")+ACOLS[N,3]+SUBSTRING(ACOLS[N,4],1,2))
         ACOLS[N,5]   :=SC6->C6_PRODUTO         	// DATA PROGRAMACAO
         cCodRet      :=SC6->C6_PRODUTO         	// DATA PROGRAMACAO
         ACOLS[N,6]   :=SC6->C6_DESCRI          	// CONTATO
         ACOLS[N,7]   :=SC6->C6_QTDVEN              // DATA FOLLOWUP
         ACOLS[N,8]   :=SC6->C6_QTDVEN          	// SITUACAO DO FOLLOWUP
         ACOLS[N,11]   :=SC6->C6_NOTA             // USUARIO RESPONSAVEL PELO AGENDAMENTO
         ACOLS[N,12]   :=SC6->C6_DATFAT           // Processo encerrado s/n
    ENDIF
    IF ACOLS[N,2]="OC"     
         dbSelectArea("SC7")
         DbSetOrder(1)
         MsSeek(xFilial("SC7")+ACOLS[N,3]+ACOLS[N,4])
         ACOLS[N,5]   :=SC7->C7_PRODUTO         	// DATA PROGRAMACAO
         cCodRet      :=SC7->C7_PRODUTO         	// DATA PROGRAMACAO
         ACOLS[N,6]   :=SC7->C7_DESCRI          	// CONTATO
         ACOLS[N,7]   :=SC7->C7_QUANT              // DATA FOLLOWUP
         ACOLS[N,8]   :=SC7->C7_QUANT            	// SITUACAO DO FOLLOWUP
    ENDIF
    IF ACOLS[N,2]="OS"     
         dbSelectArea("AB7")
         DbSetOrder(1)
         MsSeek(xFilial("AB7")+ACOLS[N,3]+ACOLS[N,4])
         ACOLS[N,5]   :=AB7->AB7_CODPRE         	// DATA PROGRAMACAO
         cCodRet      :=AB7->AB7_CODPRE         	// DATA PROGRAMACAO
         ACOLS[N,6]   :=AB7->AB7_DESENT          	// CONTATO
         ACOLS[N,7]   :=AB7->AB7_QTENT            // DATA FOLLOWUP
         ACOLS[N,8]   :=AB7->AB7_QTENT            	// SITUACAO DO FOLLOWUP
    ENDIF
    
    
    
Return (.T.)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
  //ณTratamento para tema "Flat"ณ                                               
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 




