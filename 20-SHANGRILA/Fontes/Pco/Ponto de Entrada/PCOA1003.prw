#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*
* Funcao		:	PCOA1003
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	Sincroniza o cadastro de conta orçamentária na planilha orçamentária
* Retorno		: 	
*/
User Function PCOA1003()


	Return {{"# Sinc. C.O", {|| SincAK5() }, "","# Sinc. C.O" }}

/*
* Funcao		:	SincAK5
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	Executa sincronização
* Retorno		: 	
*/
Static Function SincAK5()
	Local cPerg := "STPCO01"
	Private _nNivel := 2
	Private _cPai   := ""
	Private _cCoAnt := ""

	ValidaPerg(cPerg)
	If !Pergunte (cPerg,.T.)
		Return()
	Endif

	AK5->(DbSetOrder(1))
	AK5->(dbSeek(xFilial("AK5") + If(Empty(MV_PAR01),'',MV_PAR01)))

	ProcRegua(LastRec())

	While !AK5->( Eof() ) .And. xFilial("AK5")==AK5->AK5_FILIAL .And. AK5->AK5_CODIGO <= MV_PAR02
		If AK5->AK5_MSBLQL = '1'
			AK5->( DbSkip() )
			Loop
		EndIF
		IncProc()
		PcoSincAK5("AK5",2)
		AK5->( dbSkip() )
	EndDo
	Aviso("Processo Finalizado","A Sincronização das Contas Orçamentárias foi concluido com sucesso, será necessario fechar a planilha e acessar novamente!",{"OK"})
	Return
	
/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function PcoSincAK5(cAlias,nOpc)

	Default cAlias := "AK5"
	Default nOpc := "2"

	Do Case
	Case cAlias == "AK5"
		Do Case
		Case nOpc == 2 // 1- Inclusao , 2- Alteracao
			dbSelectArea("AK3")
			dbSetOrder(1)
			If MsSeek(xFilial("AK3")+ AK1->AK1_CODIGO + AK1->AK1_VERSAO + PadR(AK5->AK5_CODIGO,Len(AK5->AK5_CODIGO)))
				RecLock("AK3",.F.)
			Else
				If	RecLock("AK3",.T.)

					AK3->AK3_FILIAL  := xFilial("AK3")
					AK3->AK3_ORCAME  := AK1->AK1_CODIGO
					AK3->AK3_VERSAO  := AK1->AK1_VERSAO
					AK3->AK3_CO      := AK5->AK5_CODIGO
					AK3->AK3_TIPO    := AK5->AK5_TIPO
					AK3->AK3_DESCRI  := AK5->AK5_DESCRI

					If Len(Alltrim(AK3->AK3_CO)) == 1
						_cPai := AK1->AK1_CODIGO
						_nNivel:= 2
					ElseIf AK3->AK3_TIPO = '1'
						If Len(Alltrim(AK3->AK3_CO)) == 2
							_cPai := AK1->AK1_CODIGO
							_nNivel:= 3
						ElseIf Len(Alltrim(AK3->AK3_CO)) == 3
							_cPai := AK1->AK1_CODIGO
							_nNivel:= 4
						ElseIf Len(Alltrim(AK3->AK3_CO)) == 5
							_cPai := AK1->AK1_CODIGO
							_nNivel:= 5
						EndIf
					Else
						_nNivel := 6
						_cPai := AK5->AK5_COSUP
					EndIf

					AK3->AK3_PAI     := _cPai

					If Alltrim(_cPai) == Alltrim(AK1->AK1_CODIGO)
						AK3->AK3_NIVEL   :=  StrZero(_nNivel,3)
					Else
						AK3->AK3_NIVEL   :=  StrZero(_nNivel,3)
					EndIf

				EndIf
				_cCoAnt := _cPai
				MsUnlock()
			EndIf
		EndCase
	EndCase
	Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function ValidaPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","Conta De?"      ,"Conta De?"      ,"Conta De?"       ,"mv_ch1","C",20,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
	aAdd(aRegs,{cPerg,"02","Conta Até?"     ,"Conta Até?"     ,"Conta Até?"      ,"mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

	Return

