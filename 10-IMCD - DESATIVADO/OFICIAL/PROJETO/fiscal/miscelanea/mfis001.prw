#include "PROTHEUS.CH" 
#include "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFIS001   ºAutor  ³  Daniel   Gondran  º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para levar informacoes do EIC para a tabela de      º±±
±±º          ³ Complemento de Importacao (CD5)    SPED FISCAL             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MFIS001()
	Local cPerg   	:= "CFIS01"
	Local nOpca 	:= 0
	Local aSays		:= {}
	Local aButtons	:= {}
	Local aArea		:= GetArea()
	Local cCadastro	:= "Importacao de dados fiscais do EIC"
	Local aHelp     := {}

	aAdd(aSays, "Esta rotina importa dados fiscais do EIC para a tabela CD5")
	aAdd(aSays, "dos Livros Fiscais para efeito do SPED FISCAL")

	aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{|o| nOpca := 1 , o:oWnd:End()}} )
	aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Pergunte(cPerg, .F.)
		Processa({||MFIS001IMP()})
	EndIf
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFIS001IMPºAutor  ³  Daniel   Gondran  º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao dos dados da tabela SW6 para a CD5              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MFIS001IMP()    
	Local cQuery := "" 
	Local lAchou := .F.

	cQuery := "SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_ESPECIE, F1_HAWB, F1_VALIMP5, F1_VALIMP6, F1_BASIMP5, F1_BASIMP6"
	cQuery += " FROM " + RetSqlName("SF1") + " SF1"
	cQuery += " WHERE F1_FILIAL = '" + xFilial("SF1") + "'"
	cQuery += "   AND F1_EMISSAO >= '" + Dtos(MV_PAR01) + "'"
	cQuery += "   AND F1_EMISSAO <= '" + Dtos(MV_PAR02) + "'"
	cQuery += "   AND F1_EST = 'EX' "
	cQuery += "   AND SF1.D_E_L_E_T_ <> '*'"

	cQuery := ChangeQuery( cQuery )

	DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery ), "TRB1", .T., .T.)

	TRB1->(DbGoTop())

	While TRB1->(!Eof())
		dbSelectArea("SW6")
		dbSetOrder(1)
		If dbSeek(xFilial("SW6") + TRB1->F1_HAWB)
			dbSelectArea("CD5")
			dbSetOrder(1)
			lAchou := dbSeek(xFilial("CD5") + TRB1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + SW6->W6_DI_NUM))
			If !lAchou
				RecLock("CD5",.T.)
				CD5->CD5_FILIAL := xFilial("CD5")
				CD5->CD5_DOC	:= TRB1->F1_DOC
				CD5->CD5_SERIE	:= TRB1->F1_SERIE
				CD5->CD5_FORNEC	:= TRB1->F1_FORNECE
				CD5->CD5_LOJA	:= TRB1->F1_LOJA
				CD5->CD5_DOCIMP	:= SW6->W6_DI_NUM
				msUnlock()
			Endif	
			RecLock("CD5",.F.)   
			CD5->CD5_ESPEC	:= TRB1->F1_ESPECIE
			CD5->CD5_TPIMP 	:= "0"
			CD5->CD5_BSPIS	:= TRB1->F1_BASIMP6
			CD5->CD5_ALPIS	:= TRB1->F1_VALIMP6 / TRB1->F1_BASIMP6 * 100 
			CD5->CD5_VLPIS	:= TRB1->F1_VALIMP6
			CD5->CD5_DTPPIS	:= SW6->W6_DT
			CD5->CD5_BSCOF	:= TRB1->F1_BASIMP5
			CD5->CD5_ALCOF	:= TRB1->F1_VALIMP5 / TRB1->F1_BASIMP5 * 100 
			CD5->CD5_VLCOF	:= TRB1->F1_VALIMP5
			CD5->CD5_DTPCOF	:= SW6->W6_DT
			CD5->CD5_LOCAL	:= "0"
			CD5->CD5_NDI	:= SW6->W6_DI_NUM
			CD5->CD5_DTDI	:= SW6->W6_DTREG_D
			CD5->CD5_LOCDES	:= SW6->W6_LOCALN
			CD5->CD5_UFDES	:= SW6->W6_UFDESEM
			CD5->CD5_DTDES	:= SW6->W6_DT_DESE 
			CD5->CD5_CODEXP := TRB1->F1_FORNECE
			CD5->CD5_LOJAEXP:= TRB1->F1_LOJA
			CD5->CD5_CODFAB := TRB1->F1_FORNECE
			CD5->CD5_LOJAFAB:= TRB1->F1_LOJA
			CD5->CD5_NADIC  := "001"
			CD5->CD5_SEQADIC:= "001"
			CD5->CD5_ITEM   := "0001"
			msUnlock()
		Endif
		dbSelectArea("TRB1")
		dbSkip()
	Enddo
	TRB1->(dbCloseArea())
Return