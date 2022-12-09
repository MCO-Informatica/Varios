#INCLUDE "Protheus.ch" 
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณRFATACOM  ณ RADMIN	                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 20.04.07 ณ Robson                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 20.04.07 ณ Robson Bueno                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ ??.??.?? - Nome - Descri็ใo                                             บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MADPCOD()

  Local aAreaAtu	:= GetArea()												// Salva a area atual
  Local lRet		:= .T.
  LOCAL cDesComp :=Space(255)
  LOCAL cDe  :=Space(15)
  LOCAL cPara:=SPACE(15)
  Local oDlgL
  Local cTitulo :="Produtos DE x PARA"
  @ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina p/ migrar produto")
  @ 003,008 To 85,200 Title OemToAnsi("Digite Produtos Envolvidos?")
 
  @ 015,015 Say OemToAnsi("Codigo De:")  OF Odlgl PIXEL
  @ 015,045 msget cDe  SIZE 60,10 F3 "SB1" OF OdlgL PIXEL
  @ 035,015 Say OemToAnsi("Codigo Para:") OF Odlgl PIXEL
  @ 035,045 msget cPara  SIZE 60,10 F3 "SB1" OF OdlgL PIXEL
  @ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,cDe,cPara)},cTitulo,"Atualizando dados, aguarde...")
  @ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
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
Static Function OkProc(odlg1,cDe,cPara)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ transferencia de codigos em 48 tabelas                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea     := GetArea()
Local aAreaSA5
Local aAreaSA7 
Local cFornece
Local cLoja
Local cCliente
if MsgYesNo("Esta rotina TRANSFERE/EXCLUI todos os movimentos gerados pelo sistema sob um codigo de produto (DE). O processamento requer alto conhecimento de Produto. Deseja realmente processar esta rotina?")
BEGIN TRANSACTION
// ORDENS DE SERVICO (COD) fk
ProcRegua(40)
dbSelectArea("AB7")
DbSetOrder(9)
dbSeek(xFilial("AB7")+cDe) 
IncProc("TR-... TB: AB7--O. DE SERVICO (COD)")
While !EOF() .And. AB7->AB7_CODPRO = cDe
	RecLock("AB7",.F.)
	AB7->AB7_CODPRO:=cPara
	MsUnlock()
    dbSeek(xFilial("AB7")+cDe) 
EndDo
// ORDENS DE SERVICO (CODPRE)fk
dbSelectArea("AB7")
DbSetOrder(6)
dbSeek(xFilial("AB7")+cDe) 
IncProc("TR-... Tabela: AB7--O. DE SERVICO (CODPRE)")
While !EOF() .And. AB7->AB7_CODPRE = cDe
	RecLock("AB7",.F.)
	AB7->AB7_CODPRE:=cPara  
	MsUnlock()
	dbSeek(xFilial("AB7")+cDe) 
EndDo
// ORDENS DE SERVICO (CODPRS)fk
dbSelectArea("AB7")
DbSetOrder(7)
dbSeek(xFilial("AB7")+cDe) 
IncProc("TR-... TB: AB7--O. DE SERVICO (CODPRS)")
While !EOF() .And. AB7->AB7_CODPRS = cDe
	RecLock("AB7",.F.)
	AB7->AB7_CODPRS:=cPara
	MsUnlock()
    dbSeek(xFilial("AB7")+cDe) 
EndDo


/*
// CONTRATOS DE PARCERIA (CODPRS)fk
dbSelectArea("ADB")
DbSetOrder(7)
dbSeek(xFilial("ADB")+cDe) 
IncProc("TR-... TB: ADB--CONTRATOS DE PARCERIA")
While !EOF() .And. ADB->ADB_PRODUTO = cDe
	RecLock("ADB",.F.,.T.)
	ADB->ADB_PRODUTO:=cPara
	dbSkip()
EndDo
*/


// EIC (EI5_COD_I) fk
dbSelectArea("EI5")
DbSetOrder(1)
dbSeek(xFilial("EI5")+cDe) 
IncProc("TR-... TB: EI5--EASY IMPORT CONTROL")
While !EOF() .And. EI5->EI5_COD_I = cDe
	RecLock("EI5",.F.)
	EI5->EI5_COD_I:=cPara
	MsUnlock()
	dbSeek(xFilial("EI5")+cDe) 
EndDo

// EIC (EIS_COD_I) fk
DbSelectArea("EIS")
DbSetOrder(5)
dbSeek(xFilial("EIS")+cDe) 
IncProc("TR-... TB: EIS--EASY IMPORT CONTROL")
While !EOF() .And. EIS->EIS_COD_I = cDe
	RecLock("EIS",.F.)
	EIS->EIS_COD_I := cPara
	MsUnlock()
	dbSeek(xFilial("EIS")+cDe) 
EndDo
// PRODUTOS ALTERNATIVOS (PA1_PROD)fk
dbSelectArea("PA1") 
DbSetOrder(1)
dbSeek(xFilial("PA1")+cDe) 
IncProc("TR-... TB: PA1--PROD ALTERNATIVOS (PAI)")
While !EOF() .And. PA1->PA1_PROD = cDe
	RecLock("PA1",.F.)
	PA1->PA1_PROD = cPara
	MsUnlock()
	dbSeek(xFilial("PA1")+cDe) 
EndDo

// PRODUTOS ALTERNATIVOS (PA1_Altern) fk
dbSelectArea("PA1")
DbSetOrder(2)
dbSeek(xFilial("PA1")+cDe)
IncProc("TR-... TB: PA1--PROD ALTERNATIVOS (FILHO)")
While !EOF() .And. PA1->PA1_ALTERN = cDe
	RecLock("PA1",.F.)
	PA1->PA1_ALTERN = cPara
	MsUnlock()
	dbSeek(xFilial("PA1")+cDe) 
EndDo

// AMARRACAO PRODUTOXFORNECEDOR       pk
dbSelectArea("SA5")
DbSetOrder(2)
dbSeek(xFilial("SA5")+cDe) 
IncProc("TR-... TB: SA5--AMARRACAO PROD X FORN")
While !EOF() .And. SA5->A5_PRODUTO = cDe
     cFornece:=SA5->A5_FORNECE
     cLoja:=SA5->A5_LOJA
     if !dbSeek(xFilial("SA5")+cPara+cFornece+cLoja) 
        dbSeek(xFilial("SA5")+cDE+cFornece+cLoja)
        RecLock("SA5",.F.)
	    SA5->A5_PRODUTO:=cPara
	    MsUnlock()
	    dbSeek(xFilial("SA5")+cDe)
	 ELSE   
	    dbSeek(xFilial("SA5")+cDe+cFornece+cLoja)
	    SA5->(DbSkip())
	 ENDIF
	  
EndDo


// AMARRACAO PRODUTO X CLIENTE        pk
dbSelectArea("SA7")
DbSetOrder(2)
dbSeek(xFilial("SA7")+cDe) 
IncProc("TR-... TB: SA7--AMARRACAO PROD X CLI")
While !EOF() .And. SA7->A7_PRODUTO = cDe
     cCliente:=SA7->A7_CLIENTE
     cLoja:=SA7->A7_LOJA
     aAreaSA7   :=  SA7->(GetArea())
     if !dbSeek(xFilial("SA7")+cPara+cCliente+cLoja) 
        dbSeek(xFilial("SA7")+cDE+cCliente+cLoja)
        RecLock("SA7",.F.)
	    SA7->A7_PRODUTO:=cPara
	    MsUnlock()
        dbSeek(xFilial("SA7")+cDe)
     ELSE   
	    dbSeek(xFilial("SA7")+cDe+cCliente+cLoja)
	    SA7->(DbSkip())
	 ENDIF
EndDo

/*
//CADASTRO DE PRODUTOS                pk
dbSelectArea("SB1")
DbSetOrder(1)
dbSeek(xFilial("SB1")+cPara) 
IncProc("TR-... TB: SB1--CADASTRO DE PRODUTOS")
While !EOF() .And. SB1->B1_COD = cPara
	RecLock("SB1",.F.)
	dbSkip()
EndDo
*/
dbSelectArea("SB1")
DbSetOrder(1)
dbSeek(xFilial("SB1")+cDe)
IncProc("EXCLUINDO... TB: SB1--CAD. DE PRODUTOS")
While !EOF() .And. SB1->B1_COD = cDe
	RecLock("SB1",.F.)
	SB1->B1_ALTER:=cPara
	DBDELETE()
	SB1->(DbSkip())
EndDo 
/*
//SALDOS FISICOS E FINANCEIROS        pk
dbSelectArea("SB2")
DbSetOrder(1)
dbSeek(xFilial("SB2")+cPara)
IncProc("TR-... TB: SB2--SALDOS FISICOS E FINANCEIROS")
While !EOF() .And. SB2->B2_COD = cPara
	RecLock("SB2",.F.,.T.)
	dbSkip()
EndDo
*/
dbSelectArea("SB2")
DbSetOrder(1)
dbSeek(xFilial("SB2")+cDe)
IncProc("EXCLUINDO... TB: SB2--SDOS FISICOS ")
While !EOF() .And. SB2->B2_COD = cDe
	RecLock("SB2",.F.)
	DBDELETE()
	SB2->(DbSkip())
EndDo
/*

//  DEMANDAS  PK
dbSelectArea("SB3")
DbSetOrder(1)
dbSeek(xFilial("SB3")+cPara) 
IncProc("TR-... TB: SB3--DEMANDAS")
While !EOF() .And. SB3->B3_COD = cPara
	RecLock("SB3",.F.,.T.)
	dbSkip()
EndDo
*/
dbSelectArea("SB3")
DbSetOrder(1)
dbSeek(xFilial("SB3")+cDe)
IncProc("EXCLUINDO... TB: SB3--DEMANDAS")
While !EOF() .And. SB3->B3_COD = cDe
	RecLock("SB3",.F.)
	DBDELETE()
	SB3->(DbSkip())
EndDo
*/

// SALDOS EM PODER DE TERCEIROS    FK
dbSelectArea("SB6")
DbSetOrder(1)
dbSeek(xFilial("SB6")+cDe)
IncProc("TRS... TB: SB6 - SDOS PODER DE TERC")
While !EOF() .And. SB6->B6_PRODUTO = cDe
	RecLock("SB6",.F.)
	SB6->B6_PRODUTO := cPara
	MsUnlock()
    dbSeek(xFilial("SB6")+cDe)
EndDo  



// SALDOS POR LOTE                 FK
dbSelectArea("SB8")
DbSetOrder(1)
dbSeek(xFilial("SB8")+cDe)
IncProc("EXCLUINDO... TB: SB8--SALDOS POR LOTE")
While !EOF() .And. SB8->B8_PRODUTO = cDe
	RecLock("SB8",.F.)
	DBDELETE()
	SB8->(DbSkip())
EndDo 
/*
// SALDOS INICIAIS                 PK
dbSelectArea("SB9")
DbSetOrder(1)
dbSeek(xFilial("SB9")+cPara)
IncProc("TRS... TB: SB9--SALDOS INICIAIS")
While !EOF() .And. SB9->B9_COD = cPara
	RecLock("SB9",.F.,.T.)
	dbSkip()
EndDo
*/
dbSelectArea("SB9")
DbSetOrder(1)
dbSeek(xFilial("SB9")+cDe)
IncProc("EXCLUINDO... TB: SB9--SALDOS INICIAIS")
While !EOF() .And. SB9->B9_COD = cDe
	RecLock("SB9",.F.)
	DBDELETE()
	SB9->(DbSkip())
EndDo
/*

// SUGESTAO DE COMPRAS             PK
dbSelectArea("SBL")
DbSetOrder(1)
dbSeek(xFilial("SBL")+cPara)
IncProc("TRS... TB: SBL--SUGESTAO DE COMPRAS")
While !EOF() .And. SBL->BL_PRODUTO = cPara
	RecLock("SBL",.F.)
	dbSkip()
EndDo
dbSelectArea("SBL")
DbSetOrder(1)
dbSeek(xFilial("SBL")+cDe)
IncProc("TRS... TB: SBL--SUGESTAO DE COMPRAS")
While !EOF() .And. SBL->BL_PRODUTO = cDe
	RecLock("SBL",.F.)
	dbSkip()
EndDo
*/
// SOLICITACOES DE COMPRA FK
dbSelectArea("SC1")
DbSetOrder(2)
dbSeek(xFilial("SC1")+cDe)
IncProc("TRS... TB: SC1--SOL DE COMPRAS")
While !EOF() .And. SC1->C1_PRODUTO = cDe
	RecLock("SC1",.F.)
	SC1->C1_PRODUTO = cPara
	MsUnlock()
	dbSeek(xFilial("SC1")+cDe)
EndDo

// ORDENS DE PRODUCAO FK
dbSelectArea("SC2")
DbSetOrder(2)
dbSeek(xFilial("SC2")+cDe)
IncProc("TRS... TB: SC2--ORDENS DE PRODUCAO")
While !EOF() .And. SC2->C2_PRODUTO = cDe
	RecLock("SC2",.F.)
	SC2->C2_PRODUTO = cPara
    MsUnlock()
    dbSeek(xFilial("SC2")+cDe)
EndDo
// itens da venda         fk
dbSelectArea("SC6")
DbSetOrder(2)
dbSeek(xFilial("SC6")+cDe)
IncProc("TRS... TB: SC6--ITENS DA VENDA")
While !EOF() .And. SC6->C6_PRODUTO = cDe
	RecLock("SC6",.F.)
	SC6->C6_PRODUTO = cPara
	MsUnlock()
    dbSeek(xFilial("SC6")+cDe)
EndDo

// itens da compra        fk
dbSelectArea("SC7")
DbSetOrder(2)
dbSeek(xFilial("SC7")+cDe)
IncProc("TRS... TB: SC7--ITENS DA COMPRA")
While !EOF() .And. SC7->C7_PRODUTO = cDe
	RecLock("SC7",.F.)
	SC7->C7_PRODUTO = cPara
	MsUnlock()
    dbSeek(xFilial("SC7")+cDe)
EndDo

// COTACOES               fk
dbSelectArea("SC8")
DbSetOrder(1)
dbSeek(xFilial("SC8")+cDe)
IncProc("TRS... TB: SC8--COTACOES")
While !EOF() .And. SC8->C8_PRODUTO = cDe
	RecLock("SC8",.F.)
	SC8->C8_PRODUTO = cPara
	MsUnlock()
    dbSeek(xFilial("SC8")+cDe)
EndDo

// PEDIDOS LIBERADOS       fk
dbSelectArea("SC9")
DbSetOrder(7)
dbSeek(xFilial("SC9")+cDe)
IncProc("TRS... TB: SC9--PEDIDOS LIBERADOS")
While !EOF() .And. SC9->C9_PRODUTO = cDe
	RecLock("SC9",.F.)
	SC9->C9_PRODUTO = cPara
	MsUnlock()
	dbSeek(xFilial("SC9")+cDe)
EndDo

// ORCAMENTOS             FK
dbSelectArea("SCK")
DbSetOrder(3)
dbSeek(xFilial("SCK")+cDe)
IncProc("TRS... TB: SCK--ORCAMENTOS")
While !EOF() .And. SCK->CK_PRODUTO = cDe
	RecLock("SCK",.F.)
	SCK->CK_PRODUTO = cPara
	MsUnlock()
	dbSeek(xFilial("SCK")+cDe)
EndDo

// HISTORICO DE PEDIDOS DE COMPRAS   FK
dbSelectArea("SCY")
DbSetOrder(2)
dbSeek(xFilial("SCY")+cDe)
IncProc("TRS... TB: SCY--HIST PEDIDOS DE COMPRAS")
While !EOF() .And. SCY->CY_PRODUTO = cDe
   RecLock("SCY",.F.)
   SCY->CY_PRODUTO = cPara
   MsUnlock()
   dbSeek(xFilial("SCY")+cDe)
EndDo

// SOLICITACOES AO ARMAZEM           FK
dbSelectArea("SCP")
DbSetOrder(2)
dbSeek(xFilial("SCP")+cDe)
IncProc("TRS... TB: SCP--SOLICITIACOES AO ARMAZEM")
While !EOF() .And. SCP->CP_PRODUTO = cDe
	RecLock("SCP",.F.)
	SCP->CP_PRODUTO = cPara
	MsUnlock()
	dbSeek(xFilial("SCP")+cDe)
EndDo


// ITENS DAS NFS DE ENTRADA          FK
dbSelectArea("SD1")
DbSetOrder(2)
dbSeek(xFilial("SD1")+cDe)
IncProc("TRS... TB: SD1--IT DAS NFs DE ENTRADA")
While !EOF() .And. SD1->D1_COD = cDe
	RecLock("SD1",.F.)
	SD1->D1_COD = cPara
	MsUnlock()
	dbSeek(xFilial("SD1")+cDe)
EndDo

// ITENS DAS NFS DE SAIDA             FK
dbSelectArea("SD2")
DbSetOrder(1)
dbSeek(xFilial("SD2")+cDe)
IncProc("TRS... TB: SD2--IT DAS NFs DE SAIDA")
While !EOF() .And. SD2->D2_COD = cDe
	RecLock("SD2",.F.)
	SD2->D2_COD = cPara 
	MsUnlock()
	dbSeek(xFilial("SD2")+cDe)
EndDo
/*
// MOVIMENTACOES INTERNAS             FK
dbSelectArea("SD3")
DbSetOrder(3)
dbSeek(xFilial("SD3")+cDe)
IncProc("TRS... TB: SD3--MOVIMENTOS INTERNOS/TRANSF")
While !EOF() .And. SD3->D3_COD = cDe
	RecLock("SD2",.F.)
	dbSkip()
EndDo

// REQUISICOES POR LOTE              FK
dbSelectArea("SD5")
DbSetOrder(2)
dbSeek(xFilial("SD5")+cDe)
IncProc("TRS... TB: SD5--REQUISICOES POR LOTE")
While !EOF() .And. SD5->D5_PRODUTO = cDe
	RecLock("SD5",.F.)
	dbSkip()
EndDo
*/
// LIVROS FISCAIS POR ITEM DE NF    FK
dbSelectArea("SFT")
DbSetOrder(7)
dbSeek(xFilial("SFT")+cDe)
IncProc("TRS... TB: SFT--LIVROS FISCAIS")
While !EOF() .And. SFT->FT_PRODUTO = cDe
  RecLock("SFT",.F.)
  SFT->FT_PRODUTO = cPara
  MsUnlock()
  dbSeek(xFilial("SFT")+cDe)
EndDo

// ESTRUTURAS DOS PRODUTOS           FK
dbSelectArea("SG1")
DbSetOrder(1)
dbSeek(xFilial("SG1")+cDe)
IncProc("TRS... TB: SG1--ESTRUTURAS DE PRODUTO")
While !EOF() .And. SG1->G1_COD = cDe
	RecLock("SG1",.F.)
	SG1->G1_COD = cPara
	MsUnlock()
    dbSeek(xFilial("SG1")+cDe)
EndDo

// SI (ITENS)                       FK
dbSelectArea("SW1")
DbSetOrder(3)
dbSeek(xFilial("SW1")+cDe)
IncProc("TRS... TB: SW1--SOLICITACAO DE IMPORTACAO")
While !EOF() .And. SW1->W1_COD_I = cDe
	RecLock("SW1",.F.)
	SW1->W1_COD_I = cPara
    MsUnlock()
    dbSeek(xFilial("SW1")+cDe)
EndDo

// PO (ITENS)                       FK
dbSelectArea("SW3")
DbSetOrder(3)
dbSeek(xFilial("SW3")+cDe)
IncProc("TRS... TB: SW3--PURCHASE ORDER")
While !EOF() .And. SW3->W3_COD_I = cDe
	RecLock("SW3",.F.)
	SW3->W3_COD_I = cPara
	MsUnlock()
	dbSeek(xFilial("SW3")+cDe)
EndDo

//  PII (ITENS)                      FK
dbSelectArea("SW5")
DbSetOrder(5)
dbSeek(xFilial("SW5")+cDe)
IncProc("TRS... TB: SW5--PEDIDO DE IMPORTACAO")
While !EOF() .And. SW5->W5_COD_I = cDe
	RecLock("SW5",.F.)
	SW5->W5_COD_I = cPara
	MsUnlock()
	dbSeek(xFilial("SW5")+cDe)
EndDo

// DI (ITENS)                        FK
dbSelectArea("SW7")
DbSetOrder(5)
dbSeek(xFilial("SW7")+cDe)
IncProc("TRS... TB: SW7--DI")
While !EOF() .And. SW7->W7_COD_I = cDe
    RecLock("SW7",.F.)
	SW7->W7_COD_I = cPara
    MsUnlock()
	dbSeek(xFilial("SW7")+cDe)
EndDo

// INVOICE (ITENS)                   FK
dbSelectArea("SW8")
DbSetOrder(7)
dbSeek(xFilial("SW8")+cDe)
IncProc("TRS... TB: SW8--INVOICE")
While !EOF() .And. SW8->W8_COD_I = cDe
	RecLock("SW8",.F.)
	SW8->W8_COD_I = cPara
	MsUnlock()
	dbSeek(xFilial("SW8")+cDe)
EndDo

// ITENS DAS NFS DE IMPORTACAO        FK
dbSelectArea("SWN")
DbSetOrder(4)
dbSeek(xFilial("SWN")+cDe)
IncProc("TRS... TB: SWN--ITENS DAS NFs DE IMPORTACAO")
While !EOF() .And. SWN->WN_PRODUTO = cDe
    RecLock("SWN",.F.)
	SWN->WN_PRODUTO = cPara
    MsUnlock()
	dbSeek(xFilial("SWN")+cDe)
EndDo

// COMPRA CASADA                      FK
dbSelectArea("SZK")
DbSetOrder(2)
dbSeek(xFilial("SZK")+cDe)
IncProc("TRS... TB: SZK--AMARRACAO OCXPV")
While !EOF() .And. SZK->ZK_COD = cDe
	RecLock("SZK",.F.)
	SZK->ZK_COD = cPara
	MsUnlock()
    dbSeek(xFilial("SZK")+cDe)
EndDo

// ROMANEIO DE EMBARQUE               FK
dbSelectArea("SZO")
DbSetOrder(2)
dbSeek(xFilial("SZO")+cDe)
IncProc("TRS... TB: SZO--ROMANEIO DE EMBARQUE")
While !EOF() .And. SZO->ZO_COD = cDe
	RecLock("SZO",.F.)
	SZO->ZO_COD = cPara
	MsUnlock()
    dbSeek(xFilial("SZO")+cDe)
EndDo
/*
// ITENS DAS NAO CONFORMIDADES         FK
dbSelectArea("SGZ")
DbSetOrder(1)
dbSeek(xFilial("SGZ")+cDe)
IncProc("TRS... TB: AGZ--ITENS DAS NAO CONFORMIDADES")
While !EOF() .And. SGZ->GZ_COD = cDe
	RecLock("SGZ",.F.)
	SGZ->GZ_COD = cPara
	dbSkip()
EndDo
*/
End Transaction

MsgInfo("Mudanca de Produto concluida com sucesso. Rotinas Automaticas")
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