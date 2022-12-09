#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M030INC º Autor ³ Luiz Alberto     º Data ³ 30/11/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Responsavel na Replicacao do Cadastro do Cliente
				Entre Empresas.
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function M030INC()
Local aArea := GetArea()

// Joga todos os dados da Empresa atual nas demais empresas

aDados := {}
For nI := 1 To SA1->(FCount())
	AAdd(aDados, {SA1->(FieldName(nI)),SA1->(FieldGet(nI))} )
Next

If Type("M->A1_COD") <> "U"
	cCodigo := M->A1_COD
	cLoja	:= M->A1_LOJA
Else
	Return .t.
Endif

If cEmpAnt == '01'
	// Log Vendedores
	U_LogVen(1,M->A1_COD,M->A1_LOJA,M->A1_NOME,'','',M->A1_VEND,Posicione("SA3",1,xFilial("SA3")+M->A1_VEND,"A3_NOME"))
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////q

	cModo := 'C'
	EmpOpenFile("SA102","SA1",1,.T.,'02',@cModo)
	EmpOpenFile("SA104","SA1",1,.T.,'04',@cModo)

	If SA102->(dbSetOrder(1), dbSeek(xFilial("SA102")+cCodigo+cLoja))
		SA102->(dbGoBottom())
		
		cCodigo := Soma1(SA102->A1_COD,6)
	Endif

	If !SA102->(dbSetOrder(1), dbSeek(xFilial("SA102")+cCodigo+cLoja))
		If RecLock("SA102",.t.)
			For nI := 1 To Len(aDados)
	    		If aDados[nI,1]=='A1_FILIAL'
	    			SA102->A1_FILIAL := xFilial("SA102")
	    		ElseIf aDados[nI,1]=='A1_COD'
	    			SA102->A1_COD := cCodigo
	    		ElseIf aDados[nI,1]=='A1_LOJA'
	    			SA102->A1_LOJA := cLoja
	    		Else
					nPos := SA102->(FieldPos(aDados[nI,1]))
					SA102->(FieldPut(nPos,aDados[nI,2]))
				Endif
			Next
			SA102->(MsUnlock())
		Endif
    Endif

	If SA104->(dbSetOrder(1), dbSeek(xFilial("SA104")+cCodigo+cLoja))
		SA104->(dbGoBottom())
		
		cCodigo := Soma1(SA104->A1_COD,6)
	Endif

	If !SA104->(dbSetOrder(1), dbSeek(xFilial("SA104")+cCodigo+cLoja))
		If RecLock("SA104",.t.)
			For nI := 1 To Len(aDados)
	    		If aDados[nI,1]=='A1_FILIAL'
	    			SA104->A1_FILIAL := xFilial("SA104")
	    		ElseIf aDados[nI,1]=='A1_COD'
	    			SA104->A1_COD := cCodigo
	    		ElseIf aDados[nI,1]=='A1_LOJA'
	    			SA104->A1_LOJA := cLoja
	    		Else
					nPos := SA104->(FieldPos(aDados[nI,1]))
					SA104->(FieldPut(nPos,aDados[nI,2]))
				Endif
			Next
			SA104->(MsUnlock())
		Endif
	Endif
	SA102->(dbCloseArea())
	SA104->(dbCloseArea())
Endif
RestArea(aArea)
Return .t.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LogVen     º Autor ³ Luiz Alberto     º Data ³ 02/07/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Responsavel na Replicacao do Cadastro do Cliente
				Entre Empresas.
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function LogVen(nTipo,cCodCli,cLojCli,cNomCli,cVendA,cNomA,cVenN,cNomN)
Local aArea := GetArea()  
Local cAcao := ''

If nTipo	== 1	// Inclusao
	cAcao	:=	"Inclusão de Cliente"
ElseIf nTipo == 2	// Alteracao
	cAcao   :=	"Alteraçao de Cliente"
ElseIf nTipo == 3 	// Exclusão
	cAcao	:=	"Exclusão de Cliente"
Endif

// Inclusão de LOG

Begin Transaction

If RecLock("SZG",.T.)	
	SZG->ZG_FILIAL	:=	xFilial("SZG")
	SZG->ZG_DATA	:=	dDataBase
	SZG->ZG_HORA	:=	Left(Time(),5)
	SZG->ZG_COD		:=	cCodCli
	SZG->ZG_LOJA	:=	cLojCli
	SZG->ZG_NOME	:=	cNomCli
	SZG->ZG_VENDA	:=	cVendA
	SZG->ZG_VENNA	:=	cNomA
	SZG->ZG_VENDN	:=	cVenN
	SZG->ZG_VENNN	:=	cNomN
	SZG->ZG_ACAO	:=	cAcao
	SZG->ZG_USER	:=	__cUserId
	SZG->ZG_NOMUS  	:=	UsrFullName(__cUserID)
	SZG->(MsUnlock())
Endi

End Transaction

Return .T.
