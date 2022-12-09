#INCLUDE "PROTHEUS.CH
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  ºAutor  ³Microsiga           º Data ³  03/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para alteração da Natureza Financeira nos º±±
±±º          ³ casos de adiantamento incluidos por gestão de contratos    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050GRV()

Local aAreaSE2	:= SE2->(GetArea())

// Luiz M Suguiura (24/10/2019) - Parâmetro para indicar o Gestor para liberação do título
Local cLiber := GetNewPar("MV_XLIBRJ", "000001") 
//Luiz M Suguiura (24/10/2019) - Linhas comentadas pois está em desuso (Solicitado por Wellington)
//Local cNatAdt	:= Space(10)
//If SE2->E2_PREFIXO = GETNEWPAR("MV_CNPREAD","AGT") .And. SE2->E2_TIPO = GETNEWPAR("MV_CNADITC","PA ") .And. SE2->E2_ORIGEM="CNTA100"
//	
//	nOpca := 0
//	
//	DEFINE MSDIALOG oDlg TITLE "Adiantamento - Gestão de Contratos" FROM 000,000 TO 090,350 PIXEL
//	@ 010,015 Say "Natureza de Adiantamento:" OF oDlg PIXEL
//	@ 010,080 MSGET cNatAdt Picture "@!" F3 "SED" Valid !EMPTY(cNatAdt).And.FinVldNat( .F.,cNatAdt, 2 ) OF oDlg Pixel
//	DEFINE SBUTTON FROM 033,150 TYPE 1 ENABLE OF oDlg ACTION ( nOpca := 1, oDlg:End() )
//	ACTIVATE MSDIALOG oDlg CENTERED
//	
//	If nOpca == 1
//		DbSelectArea("SE2")
//		RecLock("SE2", .F.)
//		SE2->E2_NATUREZ := cNatAdt
//		SE2->(MsUnLock())
//	Else
//		U_FA050GRV()
//	EndIf
//	
//EndIf

// Luiz M. Suguiura - 24/10/2019
// Atualização dos campos referentes a Recuperação Judicial
// Se posterior a RJ (16/10/2019) grava o título Liberado
DbSelectArea("SE2")

RecLock("SE2", .F.)
if  SE2->E2_EMISSAO > CtoD("16/10/2019") 
		If !( Alltrim(SE2->E2_NATUREZ) $ GetMV("MV_XBLQNAT"))//Bloqueia o titulo conforma natureza contida no parametro //couto 20/01/21
			SE2->E2_APROVA  := ""
			SE2->E2_DATALIB := dDataBase
			SE2->E2_STATLIB := "03"
			SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
			SE2->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
			SE2->E2_XRJ     := "N"
	    endif
else
	SE2->E2_APROVA  := ""
	SE2->E2_DATALIB := CtoD("  /  /    ")
	SE2->E2_STATLIB := ""
	SE2->E2_USUALIB := ""
	SE2->E2_CODAPRO := 	SE2->E2_CODAPRO := cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
	SE2->E2_XRJ     := "S"
endif
SE2->(MsUnLock())   

   
RestArea(aAreaSE2)

Return
