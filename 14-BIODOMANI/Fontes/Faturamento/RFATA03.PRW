#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

User Function RFATA03()

    Local oDlg

    cTelefone  		:= "("+POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_DDD")+") "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TEL"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CONTATO"))
    cEndereco		:= ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_END"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_BAIRRO"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CEP"))
    cEntrega		:= ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_ENDENT"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_BAIRROE"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUNE"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_ESTE"))+" - "+ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CEPE"))
    cTransp		 	:= ALLTRIM(POSICIONE("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_NOME"))+" - "+ALLTRIM(POSICIONE("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_DDD"))+" - "+ALLTRIM(POSICIONE("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_TEL"))
    cCondPag		:= SC5->C5_CONDPAG+" - "+ALLTRIM(POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"E4_COND"))

    dbSelectArea("SM0")
    dbseek("01"+SC5->C5_X_EMPFA,.f.)

    cEmpFat			:=	SM0->M0_FILIAL

    DEFINE MSDIALOG oDlg FROM 0,0 TO 320,730 PIXEL TITLE "Observações"

    @ 003+(15*1),010 Say "Tel Cli:" of oDlg Pixel
    @ 002+(15*1),070 MsGet oEMISSAO Var cTelefone when .F. Size 50,10 of oDlg Pixel

    @ 003+(15*2),010 Say "Endereço:" of oDlg Pixel
    @ 002+(15*2),070 MsGet oLIBERACAO Var cEndereco when .F. Size 200,10 of oDlg Pixel

    @ 003+(15*3),010 Say "End. Entrega: " of oDlg Pixel
    @ 002+(15*3),070 MsGet oCREDITO Var cEntrega when .F. Size 200,10 of oDlg Pixel

    @ 003+(15*4),010 Say "Transportadora: " of oDlg Pixel
    @ 002+(15*4),070 MsGet oInSEPARACAO Var cTransp when .F. Size 100,10 of oDlg Pixel

    @ 003+(15*5),010 Say "Cond. Pagto.: " of oDlg Pixel
    @ 002+(15*5),070 MsGet oFnSEPARACAO Var cCondPag when .F. Size 100,10 of oDlg Pixel

    @ 003+(15*6),010 Say "Emp. Fat.: " of oDlg Pixel
    @ 002+(15*6),070 MsGet oFnSEPARACAO Var cEmpFat when .F. Size 100,10 of oDlg Pixel


    @ 145,230 BUTTON "Sair" SIZE 30,13 PIXEL OF oDlg ACTION (oDlg:End())

    ACTIVATE MSDIALOG oDlg CENTERED

Return nil
