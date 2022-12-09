#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MALTCLI º Autor ³ Luiz Alberto     º Data ³ 30/11/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada na Alteracao de Clientes
				Atualiza Campo Vendedor no Ciclo de Vendas
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
User Function MALTCLI()            
Local aArea := GetArea()

If cEmpAnt=='01'
	If SZ4->(dbSetOrder(1), dbSeek(xFilial("SZ4")+SA1->A1_COD+SA1->A1_LOJA))
		While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == xFilial('SZ4') .And. SZ4->Z4_CLIENTE+SZ4->Z4_LOJA == SA1->A1_COD+SA1->A1_LOJA
			If SZ4->Z4_ATIVO=='S'
				If RecLock("SZ4",.f.)
					SZ4->Z4_NOME := SA1->A1_NOME
					SZ4->Z4_VEND := SA1->A1_VEND
					SZ4->(MsUnlock())
				Endif
			Endif
			SZ4->(dbSkip(1))
		Enddo
	Endif     
Endif

// Joga todos os dados da Empresa atual nas demais empresas

aDados := {}
For nI := 1 To SA1->(FCount())
	AAdd(aDados, {SA1->(FieldName(nI)),SA1->(FieldGet(nI))} )
Next

If Type("M->A1_COD") <> "U"
	cCodigo := M->A1_COD
	cLoja	:= M->A1_LOJA
	cCnpj	:= M->A1_CGC
Else
	Return .t.
Endif

If cEmpAnt<>'01'
	Return .t.
Endif

cModo := 'C'
EmpOpenFile("SA10X","SA1",1,.T.,'02',@cModo)
EmpOpenFile("SA10Y","SA1",1,.T.,'04',@cModo)

If !SA10X->(dbSetOrder(3), dbSeek(xFilial("SA10X")+cCnpj))
	lAcao := .t.
Else
	lAcao := .f.
Endif
If lAcao
	If SA10X->(dbSetOrder(1), dbSeek(xFilial("SA10X")+cCodigo+cLoja))
		SA10X->(dbGoBottom())
		
		cCodigo := Soma1(SA10X->A1_COD,6)
	Endif
	
	// Efetua Inclusão

	If RecLock("SA10X",.t.)
		For nI := 1 To Len(aDados)
    		If aDados[nI,1]=='A1_FILIAL'
    			SA10X->A1_FILIAL := xFilial("SA10X")
    		ElseIf aDados[nI,1]=='A1_COD'
    			SA10X->A1_COD := cCodigo
    		ElseIf aDados[nI,1]=='A1_LOJA'
    			SA10X->A1_LOJA := cLoja
    		Else
				nPos := SA10X->(FieldPos(aDados[nI,1]))
				SA10X->(FieldPut(nPos,aDados[nI,2]))
			Endif
		Next
		SA10X->(MsUnlock())
	Endif
ElseIf !lAcao
	If RecLock("SA10X",.F.)
		For nI := 1 To Len(aDados)
    		If !aDados[nI,1]$'A1_FILIAL*A1_COD*A1_LOJA'
				nPos := SA10X->(FieldPos(aDados[nI,1]))
				SA10X->(FieldPut(nPos,aDados[nI,2]))
			Endif
		Next
		SA10X->(MsUnlock())
	Endif
Endif
If !SA10Y->(dbSetOrder(3), dbSeek(xFilial("SA10Y")+cCnpj))
	lAcao := .t.
Else
	lAcao := .f.
Endif
If lAcao
	If SA10Y->(dbSetOrder(1), dbSeek(xFilial("SA10Y")+cCodigo+cLoja))
		SA10Y->(dbGoBottom())
		
		cCodigo := Soma1(SA10Y->A1_COD,6)
	Endif
	
	// Efetua Inclusão

	If RecLock("SA10Y",.t.)
		For nI := 1 To Len(aDados)
    		If aDados[nI,1]=='A1_FILIAL'
    			SA10Y->A1_FILIAL := xFilial("SA10X")
    		ElseIf aDados[nI,1]=='A1_COD'
    			SA10Y->A1_COD := cCodigo
    		ElseIf aDados[nI,1]=='A1_LOJA'
    			SA10Y->A1_LOJA := cLoja
    		Else
				nPos := SA10Y->(FieldPos(aDados[nI,1]))
				SA10Y->(FieldPut(nPos,aDados[nI,2]))
			Endif
		Next
		SA10Y->(MsUnlock())
	Endif
ElseIf !lAcao
	If RecLock("SA10Y",.F.)
		For nI := 1 To Len(aDados)
    		If !aDados[nI,1]$'A1_FILIAL*A1_COD*A1_LOJA'
				nPos := SA10Y->(FieldPos(aDados[nI,1]))
				SA10Y->(FieldPut(nPos,aDados[nI,2]))
			Endif
		Next
		SA10X->(MsUnlock())
	Endif
Endif
SA10X->(dbCloseArea())
SA10Y->(dbCloseArea())

RestArea(aArea)
Return .T.    

