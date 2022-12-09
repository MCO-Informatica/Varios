#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                            DBM SYSTEM LTDA.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma    ³VERIA001³Atualizaçao de campos do cadastro de produtos                    º±±
±±º            ³        ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto/PL  ³ -                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSolicitante ³99.99.99³ Verion                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor       ³25.05.08³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros  ³Nil                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno     ³Nil.                                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservações ³                                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterações  ³ 99.99.99 - Consultor - Descrição da Alteração                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VERIA001()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as variáveis da rotina                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlgPro
Local oPOSIPI
Local oPICM
Local oPIPI
Local oPPIS
Local oPCOF
//Local oCLASS                  
//Local oTS
Local oGRTRIB
Local oCODIGO
Local oTIPICMS
Local oSOL
Local oPCofe
Local oPPIse
Local oImpImpo
Local aAreaAtu		:= GetArea()
Local cCodBarra	:= Space (15)
Local cDesc      	:= Space (100)
Local nPreco		:= 0
Local cTitPOSIPI	:= Alltrim(TitSx3("B1_POSIPI")[1])
Local cTitPICM		:= Alltrim(TitSx3("B1_PICM")[1])
Local cTitPIPI		:= Alltrim(TitSx3("B1_IPI")[1])
Local cTitPPIS		:= Alltrim(TitSx3("B1_PPIS")[1])
Local cTitPCOF		:= Alltrim(TitSx3("B1_PCOFINS")[1])
//Local cTitCLAS		:= Alltrim(TitSx3("B1_CLASFIS")[1]) 
//Local cTitTS		:= Alltrim(TitSx3("B1_TS")[1]) 
Local cTitGRTRIB	:= Alltrim(TitSx3("B1_GRTRIB")[1]) 
Local cTitCODIGO	:= Alltrim(TitSx3("B1_CODIGO")[1]) 
Local cTitTIPICMS	:= Alltrim(TitSx3("B1_TIPICMS")[1]) 
Local cTitSol		:= Alltrim(TitSx3("B1_PICMRET")[1]) 
Local cTitPCofe   := Alltrim(TitSx3("B1_PCOFE")[1]) 
Local cTitPPIse	:= Alltrim(TitSx3("B1_PPISE")[1]) 
Local cTitImpImpo	:= Alltrim(TitSx3("B1_IMPIMPO")[1]) 
Local cPOSIPI		:= Space(10)
Local cPICM			:= 0.00
Local cPICMRET	:= 0.00
Local cPIPI			:= 0.00
Local cPPIS			:= 0.00
Local cPCOF			:= 0.00
Local nPCofe     	:= 0.00
Local nPPIse		:= 0.00
Local nImpImpo		:= 0.00                                                

//Local cTS			:= Space(3)
//Local cCLAS		:= Space(2)
Local	cGRTRIB		:= Space(3)
Local cCODIGO     := Space(3)
Local cTIPICMS    := Space(2)
Local cIndex1  	:= CriaTrab(Nil,.F.)
Local lOk			:= .F.

DEFINE MSDIALOG oDlgPro TITLE "Atualização de Produtos" From 0,100 to 430,350 of oMainWnd PIXEL

@ 00,1 SAY cTitPOSIPI OF oDlgPro PIXEL
@ 00,40 MSGET oPOSIPI VAR cPOSIPI OF oDlgPro SIZE 45,010 PIXEL PICTURE PesqPict("SB1","B1_POSIPI")

@ 15,1 SAY cTitPICM 	OF oDlgPro PIXEL
@ 15,40 MSGET oPICM VAR cPICM OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PICM")

@ 30,1 SAY cTitPIPI 	OF oDlgPro PIXEL
@ 30,40 MSGET oPIPI VAR cPIPI OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_IPI")

@ 45,1 SAY cTitPPIS 	OF oDlgPro PIXEL 
@ 45,40 MSGET oPPIS VAR cPPIS OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PPIS")

@ 60,1 SAY cTitPCOF 	OF oDlgPro PIXEL
@ 60,40 MSGET oPCOF VAR cPCOF OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PCOFINS")

//@ 90,1 SAY cTitCLAS 	OF oDlgPro PIXEL
//@ 90,40 MSGET oCLASS VAR cCLAS OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_CLASFIS")

//@ 105,1 SAY cTitTS 	OF oDlgPro PIXEL
//@ 105,40 MSGET oTS VAR cTS OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_TS")

@ 75,1 SAY cTitGRTRIB 	OF oDlgPro PIXEL
@ 75,40 MSGET oGRTRIB VAR cGRTRIB OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_GRTRIB")

@ 90,1 SAY cTitCODIGO 	OF oDlgPro PIXEL
@ 90,40 MSGET oCODIGO VAR cCODIGO OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_CODIGO")

@ 105,1 SAY cTitTIPICMS 	OF oDlgPro PIXEL
@ 105,40 MSGET oTIPICMS VAR cTIPICMS OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_TS")

@ 120,1 SAY cTitSol 	OF oDlgPro PIXEL
@ 120,40 MSGET oSOL VAR cPICMRET OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PICMRET")

@ 135,1 SAY cTitPCofe	OF oDlgPro PIXEL
@ 135,40 MSGET oPCofe VAR nPCofe OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PCOFE")

@ 150,1 SAY cTitPPIse	OF oDlgPro PIXEL
@ 150,40 MSGET oPPIse VAR nPPIse OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_PPISE")

@ 165,1 SAY cTitImpImpo	OF oDlgPro PIXEL
@ 165,40 MSGET oImpImpo VAR nImpImpo OF oDlgPro SIZE 30,010 PIXEL PICTURE PesqPict("SB1","B1_IMPIMPO")

@ 180,1  BUTTON "OK" SIZE 045,015 PIXEL OF oDlgPro ACTION (lOk:=.T.,oDlgPro:End())
@ 180,55 BUTTON "CANCELAR" SIZE 045,015 PIXEL OF oDlgPro ACTION (lOk:=.F.,oDlgPro:End())
																	
ACTIVATE MSDIALOG oDlgPro CENTERED

If lOk
	dbSelectArea("SB1")
	IndRegua("SB1",cIndex1,SB1->(INDEXKEY()),,'SB1->B1_POSIPI == "'+ cPOSIPI+'"',OemToAnsi("Selecionando Registros..."))
	dbGoTop()	
	While !Eof()
		RecLock("SB1",.F.)
		B1_PICM		:= cPICM
		B1_PICMRET := cPICMRET
		B1_IPI		:= cPIPI
		B1_PPIS		:= cPPIS
		B1_PCOFINS	:= cPCOF
//		B1_CLASFIS	:= cCLAS
//		B1_TS       := cTS
		B1_GRTRIB	:= cGRTRIB
		B1_CODIGO	:= cCODIGO
		B1_TIPICMS	:= cTIPICMS
		B1_PCOFE    := nPCofe
		B1_PPISE    := nPPIse
		B1_IMPIMPO  := nImpImpo
		MsUnLock()
		dbSkip()
	Enddo
	RetIndex("SB1")
	DbClearFilter()
	FErase(cIndex1+OrdBagExt())
	
Endif

RestArea( aAreaAtu )

Return( Nil )
