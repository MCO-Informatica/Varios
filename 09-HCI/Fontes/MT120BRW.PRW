#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT1120BRW บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPONTO DE ENTRADA PARA IMPRESSAO E ENVIO DE FOLLOW P/ DILIG  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT120BRW()             
  aAdd(aRotina, {"Troca.Fornecedor"	,"U_MT120RT1()" , 0 , 6})
  aAdd(aRotina, {"Tr. Filial"	,"U_MT120RT3()" , 0 , 6})
  aAdd(aRotina, {"FollowUp"	,"U_MT120FLW()" , 0 , 6})
  Aadd(aRotina, {"DesvinculaPO","u_MT120RT2()",0,6})  
  aadd(aRotina, {"Importar","u_ATUACOM()",0,6}) 
  
  IF cPaisLoc == "BRA"
  	aAdd(aRotina, {"Troca Amz HCI-EIC","U_ChgAmzHCI" , 0 , 6})
  EndIF				
Return()






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
User Function MT120FLW(cAlias, nRecno, nOpc)
Local aArea		:= GetArea()
Local lConfirma := .f.
sTATIC oBold
Static nSdep :=0 
Static cC7Tpc:="OC"		// TIPO2 
Static cC7Num			// NUMERO OC
Static cC7Item			// ITEM Oc
Static cC7Nfor			// FORNECEDOR
Static nC7Qtd 			// QUANTIDADE CASADA
Static dC7Prz			// PRAZO ENTRADA
Static cCod				// Codigo do Produto da OC
Private INCLUI := .F.	
Private oGet2 
Private cCodForn:=""
Private cLoja   :="" 
Private cOc     :=""   
PRIvATE cItemOc :=""
Private cDesForn:=""
Private cTelef  :=""
Private cContato:=""
IF SC7->C7_QUANT=SC7->C7_QUJE
   MsgInfo("Nao e necessario fazer follow-up, item ja entregue")
   return
ENDIF

DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Follow Up de Compras") FROM C(178),C(181) TO C(645),C(963) PIXEL
cOc:=SC7->C7_NUM
cItemOc:=SC7->C7_ITEM
dbselectarea("SC7") 
SC7->(DbSetOrder(1))
if SC7->(DbSeek(xFilial("SC7")+cOc+cItemOc))
  cOc:=SC7->C7_NUM   
endif
cCodForn:=SC7->C7_FORNECE
cLoja   :=SC7->C7_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1))
if SA2->(DbSeek(xFilial("SA2")+cCodForn))
   cDesForn:=SA2->A2_NOME
   cTelef:=SA2->A2_TEL
   cContato:= SA2->A2_CONTATO
endif 
// CARREGANDO DADOS DA OC PARA POSSIVEL GRAVACAO DE AMARRACAO DE OC COM PV
cC7Num	:=cOc
cC7Item	:=cItemOc
cC7Nfor	:=SA2->A2_NREDUZ
nC7Qtd 	:=SC7->C7_QUANT-SC7->C7_QUJE
dC7Prz	:=SC7->C7_DATPRF
cCod	:=SC7->C7_PRODUTO
/*
DbSelectArea("SC7") aColsAnt1[nElemAnt1,1]
SC7->(DbSetOrder(1))
*/
@ C(014),C(005) Say "OC.  : " + cOc + " - " + "Fornecedor : " + cCodForn + "-" + cLoja + "-" + cDesForn + " - Contato: " + cContato + "-" + cTelef   Size C(350),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF _oDlg
@ C(024),C(005) Say "Item.: " + SC7->C7_ITEM + " - " + "Codigo: " + SC7->C7_PRODUTO + " - DESCRI: " + SC7->C7_DESCRI + " - Saldo: " + TRANSFORM(SC7->C7_QUANT-SC7->C7_QUJE,"@E 99999")+ " - Prazo: "+ SUBSTR(DTOS(SC7->C7_DATPRF),7,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),5,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),1,4)  Size C(350),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
@ C(034),C(005) Say "Venda: "+ SC7->C7_XPI +" - Item: " + SC7->C7_XITPI + " - Cliente: " + SC7->C7_XNREDCL + " - Qtd: " + TRANSFORM(SC7->C7_XQTVD, "@E 9999") + " - Pzo Vda:" + SUBSTR(DTOS(SC7->C7_XPZVDA),7,2)+"/"+SUBSTR(DTOS(SC7->C7_XPZVDA),5,2)+"/"+SUBSTR(DTOS(SC7->C7_XPZVDA),1,4) Size C(350),C(008)  COLOR CLR_BLUE PIXEL OF _oDlg
nSdep:=SC7->C7_QUANT-SC7->C7_QUJE
GetDoc2()

@ C(221),C(005) Say "Saldo a Entregar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF _oDlg

//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| lConfirma := .t.,IIf(U_FolTok(),_oDlg:End(),nOpca := 0)},{||_oDlg:End()},,)                                                                                 
ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| lConfirma := .t.,_oDlg:End()},{||_oDlg:End()},,)                                                                                 
If lConfirma
	_fSItPed()
ENDIF
RestArea(aArea)
Return(.T.)

/* ALTERAวรO EFETUADA DE ACORDO COM Chamado Aberto - Nบ: 6606 - PROTHEUS 11 (THAMIRES LOPES MAMONI (HCI) Depto: COMPRAS)*/

//-------------------------------------------------------------------
/*/{Protheus.doc} _fSItPed
Fun็ใo para sele็ใo dos itens do produto para inclusใo do follow up.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fSItPed()

	Local _aCmpPed		:= {}
	Local _aEstrut		:= {}
	Local _oDlgIPed		:= Nil
	Local _oGetIPed		:= Nil
	Local _cArqTMP		:= ""
	Local _cIndice		:= "ITP_ITEM"
	Local _nOldReg		:= 0
	Local _nOpc			:= 0
	Local _lInvert		:= .F.
	Local _cTitulo		:= OEMTOANSI("Sele็ใo dos itens do pedido: " + SC7->C7_NUM)

	Private _cAliasPed	:= GetNextAlias()	
	Private _cMark		:= GetMark()
	
	Aadd(_aEstrut,{"ITP_OK"			,"C",02							,00})
	Aadd(_aEstrut,{"ITP_ITEM"		,"C",TamSX3("C7_ITEM")[1]		,TAMSX3("C7_ITEM")[1]})
	Aadd(_aEstrut,{"ITP_PRD"		,"C",TamSX3("C7_PRODUTO")[1]	,TAMSX3("C7_PRODUTO")[1]})
	Aadd(_aEstrut,{"ITP_DESCR"		,"C",TamSX3("C7_DESCRI")[1]		,TAMSX3("C7_DESCRI")[1]})
	
	_aCmpPed	:= {{"ITP_OK"	,," "			,"@!"},;
					{"ITP_ITEM"	,,"Item"		,PesqPict('SC7','C7_ITEM')},;
					{"ITP_PRD"	,,"Produto"		,PesqPict('SC7','C7_PRODUTO')},;
					{"ITP_DESCR",,"Descricao"	,PesqPict('SC7','C7_DESCRI')}}


	_cArqTMP	:= CriaTrab(_aEstrut,.T.)     
	Iif(Select(_cAliasPed) > 0, (_cAliasPed)->(dbCloseArea()),Nil)
	dbUseArea(.T.,, _cArqTMP,_cAliasPed,.T.)
	IndRegua(_cAliasPed,_cArqTMP,_cIndice)
	dbSelectArea(_cAliasPed)
	
	_fGrvTmp()
	(_cAliasPed)->(dbGoTop())
	
	_oDlgIPed := TDialog():New(0,000,440,505,_cTitulo,,,,,,,,oMainWnd,.T.)
	
		_oGetIPed:= MsSelect():New(_cAliasPed,"ITP_OK","",_aCmpPed,@_lInvert,@_cMark,{004,004,207,251},,,,,)
		_oGetIPed:oBrowse:lhasMark := .t.
		_oGetIPed:oBrowse:lCanAllmark := .t.
		_oGetIPed:oBrowse:bAllMark := { || _nOldReg := (_cAliasPed)->(RecNo()), (_cAliasPed)->(DbGoTop()), ;
									(_cAliasPed)->(DbEval({|| RecLock(_cAliasPed, .f.), (_cAliasPed)->ITP_OK := ;
									Iif((_cAliasPed)->ITP_OK == _cMark, Space(2), _cMark), (_cAliasPed)->(MsUnlock()) })),;
									(_cAliasPed)->(DbGoTo(_nOldReg)), _oGetIPed:oBrowse:Refresh() }

	_oDlgIPed:Activate(,,,.T.,,,{||EnchoiceBar(_oDlgIPed,{|| _nOpc:=1,_oDlgIPed:End()},{|| _nOpc=0,_oDlgIPed:End()},,)},,)

	If _nOpc == 1
		Processa({|| _fGrvSZH()}, "Aguarde!", "Realizando grava็ใo do follow up.")
	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGrvSZH
Fun็ใo para grava็ใo da tabela SZH.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fGrvSZH()

	Local nLin := 0

	(_cAliasPed)->(dbGoTop())
	While (_cAliasPed)->(!EOF())
		If !Empty((_cAliasPed)->ITP_OK)
		   FOR nLin:=1 to len(oGet2:acols)
		//     IF oGet2:ACOLS[nLin,10]="MAN" .OR. oGet2:ACOLS[nLin,7]>0 
		       dbSelectArea("SZH")
		       DbSetOrder(1)
		       IF MsSeek(xFilial("SZH")+SC7->C7_NUM+(_cAliasPed)->ITP_ITEM+oGet2:ACOLS[nLin,2])
		         Reclock("SZH",.F.)
		       ELSE
		         Reclock("SZH",.T.)
		         SZH->ZH_USUARIO:=SUBSTR(cUsuario,7,15)             // USUARIO QUE ALIMENTOU O SISTEMA
		       ENDIF
		       IF OGET2:ACOLS[nLin,10]==.T.
		         SZH->(DbDelete())
		       ELSE  
		         SZH->ZH_FILIAL :=xfilial("SZH")                 	// FILIAL
		         SZH->ZH_STATUS :=oGet2:ACOLS[nLin,1]           	// STATUS DO FOLLOWUP
		         SZH->ZH_SEQ    :=oGet2:ACOLS[nLin,2]		    	// SEQUENCIA DE FOLLOWUP
		         SZH->ZH_OC     :=cC7num                         	// OC 
		         SZH->ZH_ITEM   :=(_cAliasPed)->ITP_ITEM           	// ITEM OC
		         SZH->ZH_FORN   :=Posicione("SC7",1,xFilial("SC7")+cC7Num+cC7Item,"C7_FORNECE")      
		         SZH->ZH_LOJA   :=Posicione("SC7",1,xFilial("SC7")+cC7Num+cC7Item,"C7_LOJA")       
		         SZH->ZH_DTPROG :=oGet2:ACOLS[nLin,3]           	// DATA PROGRAMACAO
		         SZH->ZH_CONTATO:=oGet2:ACOLS[nLin,4]           	// CONTATO
		         SZH->ZH_DTREG  :=oGet2:ACOLS[nLin,5]              // DATA FOLLOWUP
		         SZH->ZH_REG    :=oGet2:ACOLS[nLin,6]          	// SITUACAO DO FOLLOWUP
		         SZH->ZH_USUARIO:=oGet2:ACOLS[nLin,7]              // USUARIO RESPONSAVEL PELO AGENDAMENTO
		         SZH->ZH_USUACAO:=oGet2:ACOLS[nLin,8]              // USUARIO RESPONSAVEL PELA ACAO
		         SZH->ZH_ENCERRA:=oGet2:ACOLS[nLin,9]              // Processo encerrado s/n
		         if SZH->ZH_DTREG<>CTOD('  /  /  ')  
		           SZH->ZH_STATUS :="2"                         	// STATUS DO FOLLOWUP
		         else
		           SZH->ZH_STATUS :="1"
		           SZH->ZH_REG    :=""    					    	// SITUACAO DO FOLLOWUP
		         endif
		       ENDIF
		       MsUnLock()
		    // ENDIF
		   next
		EndIf
		(_cAliasPed)->(dbSkip())
	EndDo

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGrvTmp
Fun็ใo para grava็ใo dos dados da tabela temporแria.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		29/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fGrvTmp()

	Local _cQuery		:= ""
	Local _cAliasTmp	:= GetNextAlias()
	
	_cQuery := "SELECT C7_ITEM, C7_PRODUTO, C7_DESCRI "
	_cQuery	+= " FROM " + RetSqlName("SC7") + " SC7 "
	_cQuery += " WHERE C7_FILIAL = '" + SC7->C7_FILIAL + "' "
	_cQuery += " AND C7_NUM = '" + SC7->C7_NUM + "' "
	_cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY C7_ITEM "
	TcQuery _cQuery New Alias &(_cAliasTmp)
	
	If (_cAliasTmp)->(!EOF())
		ProcRegua((_cAliasTmp)->(RecCount()))
		While (_cAliasTmp)->(!EOF())
			IncProc()
			If RecLock((_cAliasPed),.T.)
				ITP_OK		:= Space(2)
				ITP_ITEM	:= (_cAliasTmp)->C7_ITEM
				ITP_PRD		:= (_cAliasTmp)->C7_PRODUTO
				ITP_DESCR	:= (_cAliasTmp)->C7_DESCRI
				(_cAliasTmp)->(MsUnLock())
			EndIf
			(_cAliasTmp)->(dbSkip())
		EndDo
	EndIf
	
	(_cAliasTmp)->(dbCloseArea())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTC450R01  บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTRATAMENTO PARA ROTINA DE LIQUIDACAO EM MASSA               บฑฑ
ฑฑบ          ณInclui Botoes Socios e Documentos no menu da rotina         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120RT1()
  
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local oDlgL
Local cFornAt:=Space(6)
LOCAL cLojaAt:=Space(2)
Local cFornNv:=Space(6)
Local cLoJaNv:=Space(2)
Local cTitulo :="Deseja Alterar Fornecedor"
cFornAt:=SC7->C7_FORNECE
cLoJaAt:=SC7->C7_LOJA 
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina para Alterar Fornecedor")
@ 003,008 To 85,200 Title OemToAnsi("Alteracao de Fornecedor")
@ 015,015 Say OemToAnsi("Forn Atual:") OF Odlgl PIXEL
@ 015,045 msget cfornAt SIZE 30,10 F3 "SA2" PICTURE PesqPict('SC7','C7_FORNECE') OF Odlgl PIXEL
@ 015,120 msget cLojaAt SIZE 10,10 PICTURE PesqPict('SC7','C7_LOJA') OF Odlgl PIXEL
@ 030,015 Say OemToAnsi("Forn Novo:") OF Odlgl PIXEL
@ 030,045 msget cfornNv SIZE 30,10 F3 "SA2" PICTURE PesqPict('SC7','C7_FORNECE') OF Odlgl PIXEL
@ 030,120 msget cLojaNV SIZE 10,10 PICTURE PesqPict('SC7','C7_LOJA') OF Odlgl PIXEL 
@ 065,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,SC7->C7_NUM,cfornNv,cLojaNv)},cTitulo,"Atualizando dados, aguarde...")
@ 065,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 

Return(.T.)

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
Static Function OkProc(oDlg1,cRef,cFornNv,cLojaNv)
Local lRet		:= .T.
// verificacao se pode alterar ou nao o fornecedor
// etapa1 (Verificar se ja houve entregas)
// etapa2 (Verificar se Existiu Cotacao de Compras)
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cRef)
do while (!Eof() .And. cRef==SC7->C7_NUM)
     IF SC7->C7_QUJE>0 .or. SC7->C7_NUMCOT<>"      " 
        LRET=.F.
     ENDIF
     dbSkip()
enddo
IF lRet=.F. 
   MsgInfo("Alteracao Cancelada.... Pedido C/ Entrega Efetuada ou Vencedora de Processo de Cotacao")
ELSE
  dbSelectArea("SC7")
  DbSetOrder(1)
  MsSeek(xFilial("SC7")+cRef)
  do while (!Eof() .And. cRef==SC7->C7_NUM)
    Reclock("SC7",.F.)
    SC7->C7_FORNECE:=cFornNv 
    SC7->C7_LOJA:=cLojaNv
    MsUnLock()
    dbSkip()
  enddo
ENDIF
Close(Odlg1)

Return .T.


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
Static Function Finaliza()
 Close(Odlg1)
Return .T.
                 
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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณGetDocs1()  ณ Autor ณ Robson Bueno          ณ Data ณ13/02/07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados - Compras Casadas                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDoc2()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZH_STATUS","ZH_SEQ","ZH_DTPROG","ZH_CONTATO","ZH_DTREG","ZH_REG","ZH_USUARIO","ZH_USUACAO","ZH_ENCERRA"}                                                                                                
Local aAlter       	:= {"ZH_STATUS","ZH_SEQ","ZH_DTPROG","ZH_CONTATO","ZH_DTREG","ZH_REG","ZH_USUARIO","ZH_USUACAO","ZH_ENCERRA"} 
Local nSuperior    	:= C(044)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(219)           
Local nDireita     	:= C(390)           
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE                                                                          
//Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cLinhaOk     	:= "U_FolLok()"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_Foltok()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= "+ZH_SEQ"        // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
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
DbSelectArea("SZH")                                                                                                             
SZH->(DbSetOrder(1)) // Campo                                                                                                   
if SZH->(DbSeek(xFilial("SZH")+SC7->C7_NUM + SC7->C7_ITEM))
	While xFilial("SZH") == SZH->ZH_FILIAL .and. ! SZH->(Eof()) .and. SZH->ZH_OC == SC7->C7_NUM  .AND. SZH->ZH_ITEM==SC7->C7_ITEM
		aAdd(aCola,{SZH->ZH_STATUS,SZH->ZH_SEQ,SZH->ZH_DTPROG,SZH->ZH_CONTATO,SZH->ZH_DTREG,SZH->ZH_REG, SZH->ZH_USUARIO,ZH_USUACAO,ZH_ENCERRA,.F.})
		SZH->(DbSkip())
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
    aCOLA[1,aScan(aHead,{|x|Trim(x[2])=="ZH_SEQ"})] := "001" 
    aCOLA[1,aScan(aHead,{|x|Trim(x[2])=="ZH_DTPROG"})] := SC7->C7_DATPRF-3                                                                                                      
Endif
// cLinhaOk                                                                    
oGet2 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,{ || U_FolLok(nOpc)},{ || U_FolTOK(nOpc)},cIniCpos,;                               
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
USER Function FolTok()                                                         
  LOCAL lRet:=.t.
  LOCAL N:=len(oGet2:acols)
  if oGet2:ACOLS[N,5]<>CTOD('  /  /  ') .and. oGet2:ACOLS[N,9]="N"
    MsgInfo("Processos nใo finalizados necessitam de novo agendamento ...")      
    lret:=.f. 
  endif
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
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER Function FolLok(nOpc)                                                         
  LOCAL lRet:=.t.
  if nOpc=7
    if oGet2:ACOLS[N,5]=CTOD('  /  /  ')
       MsgInfo("Nao e possivel incluir linha sem definicao da data de registro...")                                               
       oGet2:ACOLS[N,1]:="1"
       lret:=.f.
    else
      if oGet2:ACOLS[N,6]="                                                          "
         MsgInfo("Nao e possivel incluir linha sem a alimentacao do registro de follow-up...")                                               
         oGet2:ACOLS[N,1]:="1"
         lret:=.f.
      else
         IF oGet2:ACOLS[N,9]="S"
           MsgInfo("Nao e possivel incluir linha pois o processo foi dado como encerrado...")                                               
           lret:=.f.
         endif
         oGet2:ACOLS[N,1]:="2" 
      ENDIF
    endif
   
  endif
  
Return(lRet) 

User Function RtUssys()

return (substr(cUsuario,7,15))

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
USER Function FolTDok()                                                         
  LOCAL lRet:=.t.
  if oGet2:ACOLS[N,5]<>CTOD('  /  /  ') .and. oGet2:ACOLS[N,9]="N"
    MsgInfo("Processos nใo finalizados necessitam de novo agendamento ...")      
    lret:=.f. 
  endif
Return(lRet) 

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
User Function MT120RT2()
Local lRet		:= .T.
Local lTrava    := .F.
Local cRef:=sc7->c7_num
// verificacao se pode alterar ou nao o fornecedor
// etapa1 (Verificar se ja houve entregas)
// etapa2 (Verificar se Existiu Cotacao de Compras)
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cRef)
do while (!Eof() .And. cRef==SC7->C7_NUM)
     IF SC7->C7_QUJE<>SC7->C7_QUANT
       // LRET=.F.
     ENDIF
     dbSkip()
enddo
IF lRet=.F. 
   MsgInfo("Alteracao Cancelada.... Pedido C/ Entrega Efetuada ou Vencedora de Processo de Cotacao")
ELSE
    dbSelectArea("SC7")
    DbSetOrder(1)
    MsSeek(xFilial("SC7")+cRef)
    do while (!Eof() .And. cRef==SC7->C7_NUM)
      Reclock("SC7",.F.)
      IF SC7->C7_ORIGEM="EICPO400"
        SC7->C7_ORIGEM:="        " 
      ELSE
        SC7->C7_ORIGEM:="EICPO400"
        lTrava:=.T.
      ENDIF
      MsUnLock()
      dbSkip()
    enddo
    if lTrava=.F.
       MsgInfo("A Ordem de Compra n."+cRef+", foi desvinculada do EIC...")     
    Else
       MsgInfo("A Ordem de Compra n."+cRef+", foi VINCULADA NOVAMENTE ao EIC...")     
    ENDIF
ENDIF

Return .T.



User Function MT120RT3()
  
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local oDlgL
Local cNumAt:=Space(6)
LOCAL cFilAt:=Space(2)
Local cNumNv:=Space(6)
Local cFilNv:=Space(2)
Local cTitulo :="Transferencia de Pedido de Filial"
cNumAt:=SC7->C7_NUM
cFilAt:=SC7->C7_FILIAL 
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina Transferencia")
@ 003,008 To 85,200 Title OemToAnsi("Transferencia de Pedido")
@ 015,015 Say OemToAnsi("Num/Fil At:") OF Odlgl PIXEL
@ 015,045 msget cNumAt SIZE 30,10 PICTURE PesqPict('SC7','C7_NUM') OF Odlgl PIXEL
@ 015,120 msget cFilAt SIZE 10,10 PICTURE PesqPict('SC7','C7_FILIAL') OF Odlgl PIXEL
@ 030,015 Say OemToAnsi("Num/Fil Nv:") OF Odlgl PIXEL
@ 030,045 msget cNumNv SIZE 30,10 PICTURE PesqPict('SC7','C7_NUM') OF Odlgl PIXEL
@ 030,120 msget cFilNv SIZE 10,10 PICTURE PesqPict('SC7','C7_FILIAL') OF Odlgl PIXEL 
@ 065,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| U_MT120R3A(odlg1,cNumAt,cFilAt,cNumNv,cFilNv)},cTitulo,"Atualizando dados, aguarde...")
@ 065,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 

Return(.T.)





USER FUNCTION MT120R3A(odlg1,cNumAt,cFilAt,cNumNv,cFilNv)
  Local lContinua:=.T.
  Local cMotivo:=""
  Private cFilNovo  := cFilNv
  Private cFilAtu	:= cFilAt
  Private cNumAtu   := cNumAt
  Private cNumNovo	:= cNumNv
  DbSelectArea("SC7")
  dbSetOrder(1)
  IF MsSeek(cFilAtu+cNumAtu)
    if lContinua=.F.
      MsgInfo("Nao e possivel realizar operacao... Motivo: "+cMotivo, "Acesso Indevido")  
    else  
      If MsgYesNo("Deseja Realmente Transferir Pedido da Filial:-->"+ cFilAtu + "   Para a Filial:-->" + cFilNovo)
  	    DbSelectArea("SC7")
        dbSetOrder(1)
        IF MsSeek(cFilAtu+cNumAtu)
          WHILE (SC7->C7_NUM=cNumAtu)
            RecLock("SC7",.F.)
	      	SC7->C7_FILIAL := cFilNovo
	      	SC7->C7_NUM    := cNumNovo
	      	SC7->C7_FILENT := cFilNovo
		    MsUnLock()
            dbSelectArea("SB2")
            dbSetOrder(1)
            If !MsSeek(cFilNovo+SC7->C7_PRODUTO+SC7->C7_LOCAL)
              CriaSB2(SC7->C7_PRODUTO,SC7->C7_LOCAL,cFilNovo)
	        EndIf
            DbSelectArea("SC7")
            dbSetOrder(1)
            DBSeek(xfilial("SC7")+cNumAtu)
          ENDDO
        ENDIF
      EndIf
    endif
  endif  
RETURN () 
