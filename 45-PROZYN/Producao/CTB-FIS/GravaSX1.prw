
/*/{Protheus.doc} GravaSX1
(long_description)
	
@author Robert Koch
@since 13/02/2002
@version 1.0
		
@param cInGrupo, character, ( Grupo de perguntas a atualizar)
@param cInSeqPerg, character, (Codigo (ordem) da pergunta)
@param _xValor, character, (Dado a ser gravado)

@return Sem retorno
 
@example
(Programa...: GravaSX1  Autor......: Robert Koch Data.......: 13/02/2002
// Cliente....: Generico
// Descricao..: Atualiza respostas das perguntas no SX1
//
// Historico de alteracoes:
// 01/09/2005 - Robert - Ajustes para trabalhar com profile de usuario (versao 8.11)
// 16/02/2006 - Robert - Melhorias gerais
// 12/12/2006 - Robert - Sempre grava numerico no X1_PRESEL
// 11/09/2007 - Robert - Parametros tipo aspassimplescomboaspassimples podem receber informacao numerica ou caracter.
//                     - Testa existencia da variavel __cUserId
// 02/04/2008 - Robert - Mostra mensagem quando tipo de dados for incompativel.
//                     - Melhoria geral nas mensagens.
// 03/06/2009 - Robert - Tratamento para aumento de tamanho do X1_GRUPO no Protheus10
// 26/01/2010 - Robert - Chamadas da msgalert trocadas por msgalert.
// 29/07/2010 - Robert - Soh trabalhava com profile de usuario na versao 8.
//
(examples)

@see (links_or_references)
/*/
User Function GravaSX1(cInGrupo, cInSeqPerg, _xValor)

	Local 	aAreaOld		:= GetArea ()
	Local 	cXUserName 	:= ""
	Local 	cXMemoProf 	:= ""
	Local 	nLinAux    	:= 0
	Local 	aLinhas   		:= {}
	Local 	lContinua 		:= .T.
	Local	cGrupoAux		:= cInGrupo
	Local	cSeqPerg		:= cInSeqPerg
	Local	cLinAux		:= ""

	// Na versao Protheus10 o tamanho das perguntas aumentou.
	cGrupoAux = padr (cGrupoAux, len (sx1 -> x1_grupo), " ")

	If lContinua
		If ! sx1 -> (dbseek (cGrupoAux + cSeqPerg, .F.))
			MsgAlert ("Programa " + procname () + ": grupo/pergunta '" + cGrupoAux + "/" + cSeqPerg + "' nao encontrado no arquivo SX1." + sfPilha(),ProcName(0)+"."+ Alltrim(Str(ProcLine(0))))
			lContinua = .F.
		Endif
	Endif

	If lContinua
		// Atualizarei sempre no SX1. Depois vou ver se tem profile de usuario.
		Do case
		Case sx1 -> x1_gsc == "C"
			reclock ("SX1", .F.)
			sx1 -> x1_presel = val (cvaltochar (_xValor))
			sx1 -> x1_cnt01 = ""
			sx1 -> (msunlock ())
		Case sx1 -> x1_gsc == "G"
			If ValType (_xValor) != sx1 -> x1_tipo
				MsgAlert ("Programa " + ProcName () + ": incompatibilidade de tipos: o parametro '" + cSeqPerg + "' do grupo de perguntas '" + cGrupoAux + "' eh do tipo '" + sx1 -> x1_tipo + "', mas o valor recebido eh do tipo '" + valtype (_xValor) + "'." + sfPilha(),ProcName(0)+"."+ Alltrim(Str(ProcLine(0))))
				lContinua = .F.
			Else
				reclock ("SX1", .F.)
				sx1 -> x1_presel = 0
				If sx1 -> x1_tipo == "D"
					sx1 -> x1_cnt01 = "'"+dtoc (_xValor)+"'"
				Elseif sx1 -> x1_tipo == "N"
					sx1 -> x1_cnt01 = str (_xValor, sx1 -> x1_tamanho, sx1 -> x1_decimal)
				Elseif sx1 -> x1_tipo == "C"
					sx1 -> x1_cnt01 = _xValor
				Endif
				sx1 -> (msunlock ())
			Endif
		otherwise
			MsgAlert ("Programa " + procname () + ": tratamento para X1_GSC = '" + sx1 -> x1_gsc + "' ainda nao implementado." + sfPilha(),ProcName(0)+"."+ Alltrim(Str(ProcLine(0))))
			lContinua := .F.
		EndCase
	Endif


	psworder (1) // Ordena arquivo de senhas por ID do usuario
	PswSeek(__cUserID) // Pesquisa usuario corrente
	cXUserName := PswRet(1) [1, 2]

	// Encontra e atualiza profile deste usuario para a rotina / pergunta atual.
	// Enquanto o usuario nao alterar nenhuma pergunta, ficarah usando do SX1 e
	// seu profile nao serah criado.
	If FindProfDef (Substr(cEmpAnt+cXUserName,1,15), cGrupoAux, "PERGUNTE", "MV_PAR")
		// Carrega memo com o profile do usuario (o profile fica gravado
		// em um campo memo)
		cXUserName	:= Substr(cEmpAnt+cXUserName,1,15)
		cXMemoProf := RetProfDef (cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR")
	ElseIf 	FindProfDef (cEmpAnt+cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR")
		cXUserName	:= Substr(cXUserName,1,15)
		cXMemoProf := RetProfDef (cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR")
	Endif
	
	// Monta array com as linhas do memo (tem uma pergunta por linha)
	aLinhas = {}
	For nLinAux = 1 To MLCount (cXMemoProf)
		Aadd (aLinhas, AllTrim (MemoLine (cXMemoProf,, nLinAux)) + chr (13) + chr (10))
	Next

	// Monta uma linha com o novo conteudo do parametro atual.
	// Pos 1 = tipo (numerico/data/caracter...)
	// Pos 2 = aspassimples#aspassimples
	// Pos 3 = GSC
	// Pos 4 = aspassimples#aspassimples
	// Pos 5 em diante = conteudo.
	cLinAux = sx1 -> x1_tipo + "#" + sx1 -> x1_gsc + "#" + iif (sx1 -> x1_gsc == "C", cValToChar (sx1 -> x1_presel), sx1 -> x1_cnt01) + chr (13) + chr (10)

	// Se foi passada uma pergunta que nao consta no profile, deve tratar-se
	// de uma pergunta nova, pois jah encontrei-a no SX1. Entao vou criar uma
	// linha para ela na array. Senao, basta regravar na array.
	
	If Val(cSeqPerg) > Len (aLinhas)
		Aadd (aLinhas, cLinAux)
	Else
		// Grava a linha de volta na array de linhas
		aLinhas [Val (cSeqPerg)] = cLinAux
	Endif

	// Remonta memo para gravar no profile
	cXMemoProf = ""
	For nLinAux = 1 To Len (aLinhas)
		cXMemoProf += aLinhas [nLinAux]
	Next

	// Grava o memo no profile
	If FindProfDef( cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR" )
		WriteProfDef(cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR", ; // Chave antiga
		cXUserName, cGrupoAux, "PERGUNTE", "MV_PAR", ; // Chave nova
		cXMemoProf) // Novo conteudo do memo.
	Endif

	Restarea (aAreaOld)

Return .T.



/*/{Protheus.doc} sfPilha
(long_description)
@author MarceloLauschner
@since 27/04/2014
@version 1.0
@return cRetPilha, Pilha de chamadas
@example
(examples)
@see (links_or_references)
/*/Static Function sfPilha()
	
	Local nI       	:= 0
	Local cRetPilha 	:= chr (13) + chr (10) + chr (13) + chr (10) + "Pilha de chamadas:"
	
	Do while procname (nI) != ""
		cRetPilha += chr (13) + chr (10) + procname (nI)
		nI++
	Enddo
	
Return cRetPilha
