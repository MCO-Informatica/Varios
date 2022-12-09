#INCLUDE "Rwmake.ch"
//#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function EICDI500()
Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))
Local cXUSRAce := '000390'
Local aOrd
IF cEMPANT == '02'
	If cParam == "INICIO_EIGRAVA"
		aOrd:= SaveOrd( {"Work_SWV"} )
		Work_SWV->(Dbgotop())
		Do While !Work_SWV->(Eof())
			Work_SWV->(RECLOCK("Work_SWV",.F.))
			Work_SWV->WV_DESC    := Posicione("SB1",1,xFilial("SB1")+Work_SWV->WV_COD_I,"B1_DESC")
			Work_SWV->(MSUNLOCK())
			Work_SWV->(Dbskip())
		Enddo
		RestOrd(aOrd)
	Endif
	
	if cParam == "GRAVA_EI"
		aOrd:= SaveOrd( {"Work_SWV"} )
		Work_SWV->(Dbgotop())
		Do While !Work_SWV->(Eof())
			Work_SWV->(RECLOCK("Work_SWV",.F.))
			Work_SWV->WV_DESC    := Posicione("SB1",1,xFilial("SB1")+Work_SWV->WV_COD_I,"B1_DESC")
			Work_SWV->(MSUNLOCK())
			Work_SWV->(Dbskip())
		Enddo
		RestOrd(aOrd)
	endif
	If cParam == "DI500SW8TWVGRV_GRV_WORKTWV"
		//		aOrd:= SaveOrd( {"Work_TWV"} )
		// 		Work_TWV->(Dbgotop())
		// 		Do While !Work_TWV->(Eof())
		// 			Work_TWV->(RECLOCK("Work_TWV",.F.))
		Work_TWV->WV_DESC    := Posicione("SB1",1,xFilial("SB1")+Work_TWV->WV_COD_I,"B1_DESC")
		//			Work_TWV->(MSUNLOCK())
		//	    	Work_TWV->(Dbskip())
		//	    Enddo
		//		RestOrd(aOrd)
	Endif
	
	If cParam == "ANT_VALID_SW6"
		
		if cNomeCampo == 'W6_DT_EMB'
			If !Empty(M->W6_DT_EMB)
				if M->W6_DESP  == "999999" .Or. M->W6_VIA_TRA == "99" .OR. M->W6_ORIGEM == "999" .OR. M->W6_DEST == "999" .OR. M->W6_AGENTE == "999"
					Alert("Processo com dados ainda em fase a definir, não é permitido colocar Data de Embarque")
					lSair := .T.
					lRet :=  .F.
				Endif
			Endif
			
		Endif
		
	Endif
	
	If cParam == "ANTES_TELA"
		
		//Funçao para visualização dos followups
		AADD(aBotoes1T,{"Follow-Up" ,{|| U_FLWMAN1()},"Follow-Up"})
		If Altera //Somente na alteração o botão conversão é apresentado pois garante que os itens já estão gravados na tabela.
			AADD(aBotoes1T,{"Conversão" ,{|| U_TXCONV()},"Conversão"})
		Endif
	EndIf
	
	If cParam == "ESTORNO"
		//Função para estorno do follow uo
		U_FWLESTO()
	Endif
	
	If cParam == "TELA_SELECAO"
		//		iF (__cUserId $ cXUSRAce)
		oDlgSelec:ACONTROLS[3]:CF3 := "SW2ESP"
		//		endif
	EndIf
	
	If cParam == "AROTINA"
		//função para gerenciamento dos followup
		aADD(aRotina,{"Follow-Ups","U_FLWMAN2()",0,6})
	EndIf
	
	If cParam == "POS_GRAVA_TUDO"
		//Ponto de entrada utilizado para gravar as alterações do embarque no pedido de compras. Caso existam mais de um pedido com o item do parametro, o processo 	será realizado para ambos
		If SW7->(Dbseek(xFilial("SW6")+M->W6_HAWB))
			aOrd     := SaveOrd({"SW7","SW2","SC7"})
			CMVXEICPRD :=  alltrim(GetMv("MV_XEICPRD",,.F.))
			Do While SW7->W7_FILIAL == xFilial("SW6") .and. SW7->W7_HAWB == M->W6_HAWB .AND. SW7->(!EOF())
				
				if  CMVXEICPRD == alltrim(SW7->W7_COD_I) .AND. SW7->W7_XSALDO  <>  SW7->W7_QTDE .AND. SW7->W7_XPRECO  <> SW7->W7_PRECO
					if SW2->(Dbseek(xFilial("SW6")+SW7->W7_PO_NUM))
						if SC7->(Dbseek(xFilial("SW6")+SW2->W2_PO_SIGA))
							
							SC7->(RecLock("SC7",.F.))
							
							SC7->C7_QUANT := SW7->W7_QTDE
							SC7->C7_PRECO := SW7->W7_PRECO
							SC7->C7_TOTAL   := SC7->C7_QUANT  *	SC7->C7_PRECO
							SC7->(MsUnlock())
						Endif
					Endif
				Endif
				SW7->(dBSKIp())
			Enddo
			RestOrd(aOrd)
		Endif
	EndIf
Endif

Return nil

//Função para  apresentar tela  com produto cadastrado no parametro, para conversão.
User Function TXCONV()

Local cProdlib := GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+GetMv("MV_XEICPRD",,.F.),1)
Local cTitulo  := " Taxa de conversão do produto - " + cProdLib
Local bOk := {||IF(CONVTX(),(nOpcaoConv:=1,oDlgConv:End()),)} //FDR - 22/07/11
LOCAL bCancel:={|| nOpcaoConv:=0,oDlgConv:End() }
Local cChave := ""
local nOpcaoConv := 0
Private nTaxaConv := nPreco :=  nSaldo := nQtde := 0
Private nPreco1 :=  nQtde1 := nSaldo1 := 0
Private cUM := space(2)
Private oDlgConv := .T.
private aOrd := SaveOrd({"SC7","SW9"})

//Se o processo tiver invoices lançadas não é possivel rodar a rotina de conversão pois afetaria o financeiro gerando um possivel desbalanceamento.
SW9->(DBSETORDER(3))
IF SW9->(DBSEEK(xFilial("SW6")+M->W6_HAWB))
	Alert("Processo com invoice lançada, não pode ser efetivada a rotina de conversão")
	Return nil
Endif

//Caso não encontre o item do parametro nos itens do embarque.
SW7->(DBSETORDER(1))
SW7->(dBGOTOP())
If SW7->(Dbseek(xFilial("SW6")+M->W6_HAWB))
	CMVXEICPRD := alltrim(GetMv("MV_XEICPRD",,.F.)) 
	Do While SW7->W7_FILIAL == xFilial("SW6") .and. SW7->W7_HAWB == M->W6_HAWB .AND. SW7->(!EOF())
		
		if CMVXEICPRD == alltrim(SW7->W7_COD_I)
			cCHave := SW7->W7_FILIAL + SW7->W7_HAWB + SW7->W7_PGI_NUM + SW7->W7_CC + SW7->W7_COD_I
			nQtde  := SW7->W7_QTDE
			nSaldo := SW7->W7_SALDO_Q
			nPreco := SW7->W7_PRECO
			exit
		Else
			Alert("Item "+ cProdlib +"não encontrado no processo")
			Return nil
		Endif
		SW7->(dBSKIp())
	Enddo
Else
	Alert("Processo sem itens na SW7.")
	Return Nil
Endif
RestOrd(aOrd)

//Tela para inserção da taxa de conversão
DEFINE MSDIALOG oDlgConv TITLE cTitulo FROM 116,171 TO 456,750 OF oMainWnd PIXEL

oPanel:= TPanel():New(0, 0, "", oDlgConv,, .F., .F.,,, 116, 171)
oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

@ 1.5,.2  SAY "Taxa de conv." OF oPanel //"taxa conversão"
@ 1.5,8   MSGET nTaxaConv  SIZE 55,8 PICT "@E 9,999.99999"  VALID RFRSHTX() WHEN .T. OF oPanel

@ 3,.2  SAY "U.M." OF oPanel //"Unidade de medida"
@ 3,8   MSGET cUM  F3 "SAH"  SIZE 55,8 PICT "@!"  VALID ExistCpo("SAH") WHEN .T. OF oPanel

@ 4.5,.2  SAY "Quantidade Orig." OF oPanel //"taxa conversão"
@ 4.5,8   MSGET nQtde  SIZE 55,8 PICT "@E 999,999,999.99999"  WHEN .F. OF oPanel

@ 6.5,.2 SAY "Preço Unitario Orig." OF oPanel //"Unidade de medida"
@ 6.5,8  MSGET nPreco  SIZE 55,8 PICT "@E 999,999,999.99999"  WHEN .F. OF oPanel

@ 4.5,16  SAY "Quantidade Conv." OF oPanel //"taxa conversão"
@ 4.5,24   MSGET nQtde1  SIZE 55,8 PICT "@E 999,999,999.99999"  WHEN .F. OF oPanel

@ 6.5,16 SAY "Preço Unitario Conv." OF oPanel //"Unidade de medida"
@ 6.5,24  MSGET nPreco1  SIZE 55,8 PICT "@E 999,999,999.99999"  WHEN .F. OF oPanel

ACTIVATE MSDIALOG oDlgConv ON INIT EnchoiceBar(oDlgConv,bOk,bCancel,,) CENTERED

Return Nil

//Programa para atualizar dados após a gravação.
Static Function CONVTX()

lRet := .T.

lRet:= Msgyesno("Confirma a alteração segundo taxa de conversão informada?")

if lRet
	aOrd     := SaveOrd({"SW7","WORK"})
	
	If SW7->(Dbseek(xFilial("SW6")+M->W6_HAWB))
		CMVXEICPRD := alltrim(GetMv("MV_XEICPRD",,.F.)) 
		Do While SW7->W7_FILIAL == xFilial("SW6") .and. SW7->W7_HAWB == M->W6_HAWB .AND. SW7->(!EOF())
			
			if  CMVXEICPRD  == alltrim(SW7->W7_COD_I)
				SW7->(RecLock("SW7",.F.))
				
				SW7->W7_XSALDO    := SW7->W7_QTDE
				SW7->W7_XPRECO    := SW7->W7_PRECO
				SW7->W7_SALDO_Q  := nSaldo1
				SW7->W7_QTDE          := nQtde1
				SW7->W7_PRECO	     := nPreco1
				
				SW7->(MsUnlock())
			Endif
			SW7->(dBSKIp())
		Enddo
		
	Endif
	
	RestOrd(aOrd)
Endif


Return lRet

//para refrsh dos campos na tela
Static Function RFRSHTX()

nQtde1    := nQtde   * nTaxaConv
nSaldo1  := nSaldo *  nTaxaConv
nPreco1  := nPreco * nTaxaConv

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} IDI500MNU
Adiciona rotinas no browse da rotina EICDI500
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function IDI500MNU()
	local aRotina as array
	aRotina := {}
	Aadd(aRotina, {'Log Integ. Fiorde', "U_FILOGSHW()", 0, 2})

return aRotina