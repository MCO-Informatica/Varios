#Include "RwMake.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: MA080MNU   | Autor: Celso Ferrone Martins | Data: 13/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | PE para adicionar botao para copiar TES                    |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Usadoicao |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function MA080MNU()

Aadd(aRotina, {"Copiar Dados", "U_CfmCpTES()", 0, 9, 0, Nil})

Return (.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmCpTES   | Autor: Celso Ferrone Martins | Data: 13/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Rotina de Copia de Tipos de Entrada/Saida                  |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Usadoicao |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmCpTES()

Local aCampos     := {}
Local aRegistro   := {}
Private oJanela                        // Janela de Dialogo
Private lContinua := .F.               // Variavel Auxiliar
Private cF4CodOri := SF4->F4_CODIGO    // Obter Variaveis da Origem (TES Corrente) e Destino do Tipo de Entrada/Saida
Private cF4TipOri := SF4->F4_TIPO
Private cF4CodDes := Substr(SF4->F4_CODIGO, 1, 1) + "ZZ"

DbSelectArea("SF4") ; DbSetOrder(1)

@ 150, 180 To 270, 438 Dialog oJanela Title "Copia do Tipo de E/S " + Alltrim(cF4CodOri)

@ 015, 015 Say "Codigo a Ser Criado " Size 057, 010
@ 015, 068 Get cF4CodDes Picture "@!" Size 25, 10 Valid ValidTes()

@ 040, 052 BmpButton Type 1 Action Continua()
@ 040, 092 BmpButton Type 2 Action Close(oJanela)

Activate Dialog oJanela Center

If !lContinua .Or. Empty(cF4CodDes)
	Return (.T.)
Endif

If MsgYesNo("Confirma a Inclusao do Tipo de Entrada/Saida " + Alltrim(cF4CodDes) + " no Cadastro ?", "Tipos de Entrada/Saida")
	For nX := 1 To FCount()              // Captar os Campos de Origem

		cNomeCampo := Upper(Alltrim(FieldName(nX)))
		cConteudo  := FieldGet(nX)
		nPosicao   := FieldPos(cNomeCampo)

		If cNomeCampo == "F4_CODIGO"
			Aadd(aCampos, cF4CodDes)
		Elseif cNomeCampo == "F4_FINALID"
			Aadd(aCampos, "*** REVISAR *** " + cConteudo)
		Else
			Aadd(aCampos, cConteudo)
		Endif

	Next nX

	// Acumular o Registro de Origem p/ o Registro de Destino
	If Len(aCampos) > 0
		Aadd(aRegistro, aCampos)
	Endif

	// Copiar o Registro de Origem p/ o Novo Registro de Destino
	For nX := 1 To Len(aRegistro)        
		If !SF4->(DbSeek(xFilial("SF4") + cF4CodDes))
			Reclock("SF4", .T.)
			For Ny := 1 To FCount()
				FieldPut(nY, aRegistro[nX, Ny])
			Next Ny
			MsUnlock()
		Endif
	Next nX
	
Endif

Return (.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: MA080MNU   | Autor: Celso Ferrone Martins | Data: 13/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | PE para adicionar botao para copiar TES                    |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Usadoicao |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function Continua()

lContinua := .T.

Close(oJanela)

Return (.T.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: MA080MNU   | Autor: Celso Ferrone Martins | Data: 13/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Validacao do Tipo de Entrada/Saida a Ser Copiado           |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Usadoicao |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function ValidTes()

Local aAreaSf4 := SF4->(GetArea())
Local lRet     := .T.

If SF4->(DbSeek(xFilial("SF4") + cF4CodDes)) .And. !Empty(cF4CodDes)
	MsgAlert("O Codigo do Tipo de Entrada/Saida a Ser Criado " + Alltrim(cF4CodDes) + " Ja esta Cadastrado no Sistema, Verifique !!!", "Atencao !!!")
	lRet := .F.
Endif

If cF4CodDes <= "500" .And. cF4TipOri $ "S,"
	MsgAlert("O Tipo de Entrada/Saida " + Alltrim(cF4CodDes) + " Deve Ser de Saida de Acordo com o Tipo de Origem, Verifique !!!", "Atencao !!!")
	lRet := .F.
Elseif cF4CodDes > "500" .And. cF4TipOri $ "E,"
	MsgAlert("O Tipo de Entrada/Saida " + Alltrim(cF4CodDes) + " Deve Ser de Entrada de Acordo com o Tipo de Origem, Verifique !!!", "Atencao !!!")
	lRet := .F.
Endif

If Len(Alltrim(cF4CodDes)) < Len(SF4->F4_CODIGO) .And. !Empty(cF4CodDes)
	MsgAlert("O Tipo de Entrada/Saida " + Alltrim(cF4CodDes) + " Deve Possuir o Tamanho de " + Alltrim(Str(Len(SF4->F4_CODIGO), 10)) + " Posicoes Para Ser Valido, Verifique !!!", "Atencao !!!")
	lRet := .F.
Endif

If !lRet
	cF4CodDes := Space(Len(SF4->F4_CODIGO))
Endif

SF4->(RestArea(aAreaSf4))

Return (lRet)
