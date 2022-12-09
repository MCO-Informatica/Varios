#Include "totvs.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA036   º Autor ³ Renato Ruy	     º Data ³  23/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para tratamento de visita externa.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA036()

	Local aACabec 	:= {/*Campos do cabeçalho que serão alterados*/}
	Local nX
	Local aBotoes	:= {}
	Local cTitulo	:= ""
	
	Private aItens 		:= {"Z6_CODENT", "Z6_DESENT", "Z6_VLRPROD", "Z6_BASECOM", "Z6_VALCOM","Z6_REGCOM","AHG_NUMEXE"}
	Private aAItens 	:= {"CODIGO","DESCRICAO ENTIDADE","VALOR UNITARIO", "VALOR BASE","VALOR COMISSAO","HORA IMPORTACAO","RECNO"}
	Private aCabec  	:= {}
	Private aHeaderEx 	:= {}
	Private aCampos 	:= {}
	Private aColsEx 	:= {}
	Private aDados		:= {}
	Private oGetItens
	Private oCabec
	
	Static oDlg
 
	DEFINE MSDIALOG oDlg TITLE "Titulo" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL
		oDlg:lMaximized := .T.
		
		RegToMemory("SZ6",.T.)
		
		oCabec := Msmget():New("SZ6",0,3,,,,aCabec,{15,1,70,315},aACabec,3,,,,oDlg,,.T.,,,,,,,,.T.)
	
		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aItens)
			If SX3->(DbSeek(aItens[nX])) 
			    
			    If "Z6_CODENT" $ SX3->X3_CAMPO
			    	cTitulo := "CODIGO"
			    ElseIf "Z6_DESENT" $ SX3->X3_CAMPO
					cTitulo := "DESCRICAO ENTIDADE"
				ElseIf "Z6_VLRPROD" $ SX3->X3_CAMPO
					cTitulo := "VALOR UNITARIO"
				ElseIf "Z6_BASECOM" $ SX3->X3_CAMPO
					cTitulo := "VALOR BASE"
				ElseIf "Z6_VALCOM" $ SX3->X3_CAMPO
					cTitulo := "VALOR COMISSAO"
				ElseIf "Z6_REGCOM" $ SX3->X3_CAMPO
					cTitulo := "HORA IMPORTACAO"
				Elseif "AHG_NUMEXE" $ SX3->X3_CAMPO
					cTitulo := "RECNO"
				EndIf
			
				Aadd(aHeaderEx, {;
						cTitulo,;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						SX3->X3_RELACAO})
			Endif
		Next nX
		
		//Chama rotina para carregar acols
		CRPA036L()
		
		oGetItens := MsNewGetDados():New( 130, 000, 250, 250, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aAItens,0, 99999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
	  	
		//oCabec:oBox:Align := CONTROL_ALIGN_TOP
		oGetItens:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		AAdd(aBotoes,{"BMPCONS",{|| GdSeek(oGetItens,"Busca Itens",oGetItens:aHeader,oGetItens:aCols,If(Type("oGetItens:aIniCpos")=="A",.T.,)) },"Procurar"} )
		AAdd(aBotoes,{"BMPCONS",{|| CRPA036I()}	 																							   ,"Incluir"} )
		AAdd(aBotoes,{"BMPCONS",{|| CRPA036A()}	 																							   ,"Alterar"} )
		AAdd(aBotoes,{"BMPCONS",{|| CRPA036E()}	 																							   ,"Excluir"} )
 
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| Processa({|| })},{|| oDlg:End(),RollbackSX8()},,aBotoes) CENTERED
 
Return

//Renato Ruy - 23/11/16
//Exclusão de lançamentos importados.
Static Function CRPA036E()

Local nRecnoz := AScan( aHeaderEx, {|p| AllTrim(p[2])=="AHG_NUMEXE"})

DbSelectArea("SZ6")
SZ6->(DbGoTo(oGetItens:ACOLS[oGetItens:nAt,nRecnoz]))

If SZ6->(Recno()) == oGetItens:ACOLS[oGetItens:nAt,nRecnoz] .And. MsgYesNo("Você tem certeza que deseja excluir o lançamento?")
	SZ6->(Reclock("SZ6",.F.))
	SZ6->(Dbdelete())
	SZ6->(Msunlock()) 
	
	//Abre novamente para atualizar a tela.
	CRPA036L()
	oGetItens:ForceRefresh()
	
	MsgInfo("O registro foi excluido!")
Endif

Return

//Renato Ruy - 23/11/16
//Incluir registro manualmente
Static Function CRPA036I()

Local aRet := {}
Local aPar := {}


AAdd(aPar,{1,'Entidade'	, Space(10),''				,'','SZ3'	,'',050,.T.})
AAdd(aPar,{1,'O.S.'		, Space(10),''				,'',''		,'',050,.F.}) 
AAdd(aPar,{1,'Val.Unit'	, 		  0,'@E 999,999.99'	,'',''		,'',050,.T.}) 
AAdd(aPar,{1,'Val.Base'	,		  0,'@E 999,999.99'	,'',''		,'',050,.T.}) 
AAdd(aPar,{1,'Comissão'	, 		  0,'@E 999,999.99'	,'',''		,'',050,.T.}) 
AAdd(aPar,{1,'Agente'	, Space(50),''				,'',''		,'',100,.T.})

If ParamBox(aPar,'Reagendamento',@aRet)

	If Empty(aRet[2])
		aRet[2] := Strzero(Randomize( 1 , 999999 ),6)
	Else
		aRet[2] := Padl(AllTrim(aRet[2]),6,"0")
	Endif
	
	//Mesmo que o usuário não selecione se posiciona.
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+ aRet[1]))
	
	//Inclui um novo registro
	DbSelectArea("SZ6")
	Reclock("SZ6",.T.)
		SZ6->Z6_FILIAL 	:= xFilial("SZ6")
		SZ6->Z6_PERIODO	:= GetMv("MV_REMMES")
		SZ6->Z6_TIPO		:= "VISITA"
		SZ6->Z6_TPENTID	:= "B" //Tipo da Entidade
		SZ6->Z6_CODENT	:= SZ3->Z3_CODENT
		SZ6->Z6_DESENT	:= SZ3->Z3_DESENT
		SZ6->Z6_PRODUTO	:= "VISITAEXTERNA"
		SZ6->Z6_CATPROD	:= "2"
		SZ6->Z6_DESCRPR 	:= "VISITA EXTERNA"
		SZ6->Z6_PEDGAR 	:= aRet[2]
		SZ6->Z6_VLRPROD	:= aRet[3]
		SZ6->Z6_BASECOM	:= aRet[4]
		SZ6->Z6_VALCOM	:= aRet[5]
		SZ6->Z6_REGCOM 	:= "INC.MANUAL: " + DtoC(dDataBase) + " - " + Time()
		SZ6->Z6_CODCCR 	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_CODENT, SZ3->Z3_CODCCR) //Caso a entidade seja um CCR gravo o codigo.
		SZ6->Z6_CCRCOM	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_DESENT, SZ3->Z3_CCRCOM) //Caso a entidade seja um CCR gravo o nome.
		SZ6->Z6_NOMEAGE 	:= Upper(aRet[6]) 
	SZ6->(Msunlock())
    
   	//Abre novamente para atualizar a tela.
	CRPA036L()
	oGetItens:ForceRefresh()
    
	Msginfo("O registro foi incluido com sucesso!")
Else	
	Alert("Rotina cancelada pelo usuário!")
Endif

Return


//Renato Ruy - 23/11/16
//Alterar registro manualmente
Static Function CRPA036A()

Local aRet := {}
Local aPar := {}
Local nRecnoz := AScan( aHeaderEx, {|p| AllTrim(p[2])=="AHG_NUMEXE"})

DbSelectArea("SZ6")
SZ6->(DbGoTo(oGetItens:ACOLS[oGetItens:nAt,nRecnoz]))

If SZ6->(Recno()) == oGetItens:ACOLS[oGetItens:nAt,nRecnoz]

	AAdd(aPar,{1,'Entidade'	, SZ6->Z6_CODENT	,''				,'','SZ3'	,'',050,.T.})
	AAdd(aPar,{1,'O.S.'		, SZ6->Z6_PEDGAR	,''				,'',''		,'',050,.F.}) 
	AAdd(aPar,{1,'Val.Unit'	, SZ6->Z6_VLRPROD	,'@E 999,999.99','',''		,'',050,.T.}) 
	AAdd(aPar,{1,'Val.Base'	, SZ6->Z6_BASECOM	,'@E 999,999.99','',''		,'',050,.T.}) 
	AAdd(aPar,{1,'Comissão'	, SZ6->Z6_VALCOM	,'@E 999,999.99','',''		,'',050,.T.}) 
	AAdd(aPar,{1,'Agente'	, SZ6->Z6_NOMEAGE	,''				,'',''		,'',100,.T.})
	
	If ParamBox(aPar,'Reagendamento',@aRet)
		
		//Mesmo que o usuário não selecione se posiciona.
		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek(xFilial("SZ3")+ aRet[1])) 
			
		DbSelectArea("SZ6")
		Reclock("SZ6",.F.)
			SZ6->Z6_CODENT	:= SZ3->Z3_CODENT
			SZ6->Z6_DESENT	:= SZ3->Z3_DESENT
			SZ6->Z6_PEDGAR 	:= aRet[2]
			SZ6->Z6_VLRPROD	:= aRet[3]
			SZ6->Z6_BASECOM	:= aRet[4]
			SZ6->Z6_VALCOM	:= aRet[5]
			SZ6->Z6_REGCOM 	:= "ALT.MANUAL: " + DtoC(dDataBase) + " - " + Time()
			SZ6->Z6_CODCCR 	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_CODENT, SZ3->Z3_CODCCR) //Caso a entidade seja um CCR gravo o codigo.
			SZ6->Z6_CCRCOM	:= Iif(SZ3->Z3_TIPENT == "9", SZ3->Z3_DESENT, SZ3->Z3_CCRCOM) //Caso a entidade seja um CCR gravo o nome.
			SZ6->Z6_NOMEAGE := Upper(aRet[6])
		SZ6->(Msunlock())
		
		//Abre novamente para atualizar a tela.
		CRPA036L()
		oGetItens:ForceRefresh()
		
	Endif
Else
	Alert("Rotina cancelada pelo usuário!")
Endif

// Renato Ruy - 23/11/16
// Busca na base de dados os registros
Static Function CRPA036L()

//Campos do aCols
Local nCodigo	:= 0
Local nDescri	:= 0
Local nVlUnit	:= 0
Local nVlBase	:= 0
Local nVlComi	:= 0
Local nHrImpo	:= 0
Local nRecnoz	:= 0

If Select("TMPVIS") > 0
	DbSelectArea("TMPVIS")
	TMPVIS->(DbCloseArea())
Endif

Beginsql Alias "TMPVIS"
	SELECT Z6_CODENT, Z6_DESENT, Z6_VLRPROD, Z6_BASECOM, Z6_VALCOM, Z6_REGCOM, R_E_C_N_O_ RECNOZ6 FROM SZ6010
	WHERE
	Z6_FILIAL = ' ' AND
	Z6_PERIODO = %Exp:GetMv("MV_REMMES")% AND
	Z6_TPENTID = 'B' AND
	%Notdel%
	ORDER BY Z6_DESENT
Endsql

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aItens)
	If DbSeek(aItens[nX])
		Aadd(aCampos, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aCampos, .F.)

//Busca posicao dos campos
nCodigo	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_CODENT" })
nDescri	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_DESENT" })
nVlBase	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_VLRPROD"})
nVlUnit	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_BASECOM"})
nVlComi	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_VALCOM" })
nHrImpo	:= AScan( aHeaderEx, {|p| AllTrim(p[2])=="Z6_REGCOM" })
nRecnoz := AScan( aHeaderEx, {|p| AllTrim(p[2])=="AHG_NUMEXE"})

aColsEx := {}

//Adiciona conteudo no aCols
While !TMPVIS->(EOF())
    
    aDados := Array(len(aHeaderEx)+1)
    
	//Adiciona conteudo
	aDados[nCodigo] := TMPVIS->Z6_CODENT
	aDados[nDescri] := TMPVIS->Z6_DESENT
	aDados[nVlBase] := TMPVIS->Z6_VLRPROD
	aDados[nVlUnit] := TMPVIS->Z6_BASECOM
	aDados[nVlComi] := TMPVIS->Z6_VALCOM
	aDados[nHrImpo] := TMPVIS->Z6_REGCOM
	aDados[nRecnoz] := TMPVIS->RECNOZ6
	aDados[Len(aItens)+1] := .F.
	
	//Cria linha no aCols
	Aadd(aColsEx, aDados)
	
	TMPVIS->(DbSkip())
Enddo

If Valtype(oGetItens) == "O"
	oGetItens:aCols := aColsEx
Endif

Return