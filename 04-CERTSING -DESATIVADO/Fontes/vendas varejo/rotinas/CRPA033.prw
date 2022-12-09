#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO7     º Autor ³ AP6 IDE            º Data ³  20/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA033


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Tabela IFEN"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar" ,"AxPesqui"	  ,0,1},;
		             {"Visualizar","U_CRPA033A(2)",0,2},;
		             {"Importar"  ,"U_CRPA033G()",0,3} ,;
		             {"Alterar"	  ,"U_CRPA033A(4)",0,4},;
		             {"Excluir"	  ,"U_CRPA033A(7)",0,5},;
		             {"Incluir"	  ,"U_CRPA033A(3)",0,6}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZ9"

dbSelectArea("ZZ9")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA032B   º Autor ³ Renato Ruy		 º Data ³  23/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para inclusao de dados. 						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Remuneração de Parceiros                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA033A(nOpcx)

//Campos que serao usados no aHeader.
Local cHeader   := "ZZ9_COD|ZZ9_DTINI|ZZ9_DTFIM"
//Campos que serao usados no aCols.
Local cItens   	:= "ZZ9_DESC|ZZ9_PROD|ZZ9_VALSW|ZZ9_VALHW|ZZ9_VLRENO"
Local nUsado	:= 0 
Local nQtdPar	:= 0
//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
Local nLinGetD	:= 0
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
Local cTitulo	:= "Manutenção da Tabela de Preços IFEN"
//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
Local aC		:= {}
//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
Local aR		:= {}
//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
Local aCGD		:= {100,5,100,350}

//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+
Private cLinhaOk 	:= "ExecBlock('CRPA033F',.f.,.f.)"
Private cTudoOk  	:= "ExecBlock('CRPA033B',.f.,.f.)"
Private aCols		:= {}
//+------------------------------------------------+
//¦ Variaveis do cabecalho						   ¦
//+------------------------------------------------+
Private cCodTab	:= "001"
Private dDataIni:= CtoD("  /  /  ")
Private dDataFim:= CtoD("  /  /  ")

//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+  

//Se e inclusão, alimento contador.
If nOpcx == 3
	ZZ9->(DbSetOrder(1))
	ZZ9->(DBGoBottom())
	cCodTab := Soma1(ZZ9->ZZ9_COD)
EndIf

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZZ9")

aHeader:={}

//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+

nUsado := 0

While !Eof() .And. (SX3->X3_ARQUIVO == "ZZ9")
	
	IF X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
	
		nUsado := nUsado+1
		
		AADD(aHeader,{ 	TRIM(X3_TITULO)	,;
						X3_CAMPO		,;
						X3_PICTURE		,;
						X3_TAMANHO		,;
						X3_DECIMAL		,;
						X3_VALID		,;
						X3_USADO		,;
						X3_TIPO			,; 
						X3_ARQUIVO		,;
						X3_CONTEXT 		})
	Endif
	dbSkip()
End
//Adiciono o Recno para controle de exclusão e gravação.
If nOpcx == 2 .Or. nOpcx == 4 .Or. nOpcx == 7
	nUsado := nUsado+1
		
	AADD(aHeader,{ 	"RECNO"			,;
					"ZZ9_DESC"		,;
					""				,;
					15				,;
					0				,;
					" "				,;
					"€€€€€€€€€€€€€€€",;
					"N"				,; 
					"ZZ9"			,;
					"V"		 		})
EndIf

If nOpcx == 3 
	//+-----------------------------------------------+
	//¦ Montando aCols para a GetDados                ¦
	//+-----------------------------------------------+
	aCols:=Array(1,nUsado+1)
	SX3->(DbGoTop())
	DbSeek("ZZ9")
	nUsado := 0
	
	While !Eof() .And. (x3_arquivo == "ZZ9")
		IF X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
			nUsado:=nUsado+1
			IF nOpcx == 3
				IF x3_tipo == "C"
					aCOLS[1][nUsado] := SPACE(SX3->X3_TAMANHO)
				Elseif x3_tipo == "N"
					aCOLS[1][nUsado] := 0
				Elseif x3_tipo == "D"
					aCOLS[1][nUsado] := dDataBase
				Elseif x3_tipo == "M"
					aCOLS[1][nUsado] := ""
				Else
					aCOLS[1][nUsado] := .F.
				Endif
			Endif
		Endif
		dbSkip()
	End
	
	aCOLS[1][nUsado+1] := .F.
	
ElseIf nOpcx == 2 .Or. nOpcx == 4 .Or. nOpcx == 7
    cCodTab	:= ZZ9->ZZ9_COD
	dDataIni:= ZZ9->ZZ9_DTINI
	dDataFim:= ZZ9->ZZ9_DTFIM
	
	ZZ9->(DbgoTop())
	ZZ9->(DbSetOrder(1))
	ZZ9->(DbSeek(xFilial("ZZ9")+cCodTab))
    
    While !ZZ9->(EOF()) .And. cCodTab == ZZ9->ZZ9_COD
    	
    	aAdd(aCols,{ZZ9->ZZ9_PROD,Posicione("PA8",1,xFilial("PA8")+ZZ9->ZZ9_PROD,"PA8_DESBPG"),ZZ9->ZZ9_VALSW,ZZ9->ZZ9_VALHW,ZZ9->ZZ9_VLRENO,ZZ9->(Recno()),.F.})
    		
   		nQtdPar += 1
    		
    	ZZ9->(DbSkip())
    Enddo

EndIf	

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
AADD(aC,{"cCodTab" 	,{015,001} ,"Código Tabela"  ,"@!"				,""	,""	,.F.})
AADD(aC,{"dDataIni"	,{015,095} ,"Dt.Ini.Vigência","@!"				,""	,""	,.T.})
AADD(aC,{"dDataFim"	,{015,195} ,"Dt.Fim Vigência","@!"				,""	,""	,.T.})

//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
//AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados", "@E 999",,,.F.})

//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou
lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)

If lRet .And. nOpcx == 3
	CRPA033C() //Inclusao
ElseIf lRet .And. nOpcx == 4
	CRPA033D() //Alteração
ElseIf lRet .And. nOpcx == 7
	CRPA033E()
EndIf

Return

//TudoOk - Valida se os campos estão preenchidos.
User Function CRPA033B()

Local lRet := .T.

If Empty(dDataIni)
	lRet := .F.
	MsgInfo("A data inicial da vigência da tabela deve ser informada!")
EndIf

Return lRet

//Grava os Dados
Static Function CRPA033C()

Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_PROD" 	})
Local nPosVsw	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VALSW" 	})
Local nPosVhw	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VALHW"  })
Local nPosVre	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VLRENO" })


For i := 1 to Len(aCols)
	ZZ9->(Reclock("ZZ9",.T.))
		ZZ9->ZZ9_FILIAL := xFilial("ZZ9")  
		ZZ9->ZZ9_COD	:= cCodTab
		ZZ9->ZZ9_DTINI	:= dDataIni
		ZZ9->ZZ9_DTFIM	:= dDataFim
		ZZ9->ZZ9_PROD	:= aCols[i][nPosPrd]  
		ZZ9->ZZ9_VALSW 	:= aCols[i][nPosVsw]  
		ZZ9->ZZ9_VALHW 	:= aCols[i][nPosVhw]  
		ZZ9->ZZ9_VLRENO	:= aCols[i][nPosVre]
	ZZ9->(MsUnlock())  
Next

Return

//Altera os Dados
Static Function CRPA033D()

Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_PROD" 	})
Local nPosVsw	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VALSW" 	})
Local nPosVhw	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VALHW"  })
Local nPosVre	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_VLRENO" })
Local nPosRec	:= aScan(aHeader,{|x| AllTrim(x[1]) == "RECNO"		})


For i := 1 to Len(aCols)

	//Me posiciono se tem recno.
	If !Empty(aCols[i][nPosRec])
		ZZ9->(DbGoTo( aCols[i][nPosRec] ))
	EndIf
	
	If !aCols[i][Len(aHeader)+1]
		//se tem recno atualiza.
		If !Empty(aCols[i][nPosRec]) 
			ZZ9->(Reclock("ZZ9",.F.))
		//Caso contrario grava novo.
		Else
			ZZ9->(Reclock("ZZ9",.T.))
		EndIf
			ZZ9->ZZ9_FILIAL := xFilial("ZZ9")  
			ZZ9->ZZ9_COD	:= cCodTab
			ZZ9->ZZ9_DTINI	:= dDataIni
			ZZ9->ZZ9_DTFIM	:= dDataFim
			ZZ9->ZZ9_PROD	:= aCols[i][nPosPrd]  
			ZZ9->ZZ9_VALSW 	:= aCols[i][nPosVsw]  
			ZZ9->ZZ9_VALHW 	:= aCols[i][nPosVhw]  
			ZZ9->ZZ9_VLRENO	:= aCols[i][nPosVre]  
		ZZ9->(MsUnlock())  
	Elseif !Empty(aCols[i][nPosRec])
		ZZ9->(RecLock('ZZ9',.F.))
			ZZ9->(dbDelete())
		ZZ9->(MsUnlock())
	Endif
Next

Return

//Exclui os Dados
Static Function CRPA033E()

Local nPosRec	:= aScan(aHeader,{|x| AllTrim(x[1]) == "RECNO"		})


For i := 1 to Len(aCols)

	//Me posiciono se tem recno.
	If !Empty(aCols[i][nPosRec])
		ZZ9->(DbGoTo( aCols[i][nPosRec] ))
	EndIf
	
	If !Empty(aCols[i][nPosRec]) .And. aCols[i][Len(aHeader)+1]
		ZZ9->(RecLock('ZZ9',.F.))
			ZZ9->(dbDelete())
		ZZ9->(MsUnlock())
	Endif
Next

Return

//TudoOk - Valida se os campos estão preenchidos.
User Function CRPA033F()

Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ9_PROD" 	})
Local lRet 		:= .T.

If Empty(aCols[Len(aCols)][nPosPrd])
	MsgInfo("O Código do Produto deve ser preenchido!")
	lRet := .F.
EndIf

For i := 1 to (Len(aCols) - 1)
	If aCols[Len(aCols)][nPosPrd] == aCols[i][nPosPrd]
		MsgInfo("O produto já foi informado na linha: " + AllTrim(Str(i)))
		lRet := .F.
	EndIf
Next

Return lRet

//Renato Ruy
//Importação de Arquivos - 04/02/2016
User Function CRPA033G

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Importação de Tabela de Preços IFEN" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 45,010 BUTTON "Arquivo"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA033H(@aDirIn,@cDirIn)
@ 45,060 BUTTON "Importar"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancelar"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) = 0
	MsgAlert("Não Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

Proc2BarGauge({|| CRPA033I(cDirIn,aDirIn) },"Processando Importação..")

Return

//Busca pastas para processamento
Static Function CRPA033H(aDirIn,cDirIn)
Local cAux 	 := "" 
Local cDirIn := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)

//Funcao le array e envia arquivos para processamento.
Static Function CRPA033I(cDirIn,aDirIn)

Private cArqTxt := ""
Private nHdl    := ""
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

For nIGeral:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nIGeral][1]
	nHdl    := fOpen(cArqTxt,68)
	IncProcG1("Proc. Arquivo "+aDirIn[nIGeral][1])
	ProcessMessage()
	CRPA033J()
Next

Return

//Funcao le array e faz a importação.
Static Function CRPA033J()

Local nTotRec := 0
Local xBuff   := ""
Local cCodTab := ""
Local dDataIni:= CtoD("  /  /  ")
Local dDataFim:= CtoD("  /  /  ")
Local cProduto:= ""
Local nValorSw:= 0
Local nValorHw:= 0
Local nValorRe:= 0

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()
BarGauge2Set( nTotRec )

FT_FGOTOP()

//=================================================||
//========        MODELO DE ARUIVO      ===========||
// Coluna 1 - Data Inicial de Vigência da Tabela   ||
// Coluna 2 - Data Final de Vigência da Tabela	   ||
// Coluna 3 - Produto							   ||
// Coluna 4 - Valor SW do Produto				   ||
// Coluna 5 - Valor HW do Produto				   ||
//=================================================||

While !FT_FEOF()
	
	//Leio a linha e gero array com os dados
	xBuff	:= alltrim(FT_FREADLN())
	
	//Faço tratamento para não gerar erro nas colunas
	While ";;" $ xBuff
		xBuff	:= StrTran(xBuff,";;",";-;")
	EndDo
	
	If SubStr(xBuff,len(xBuff),1) == ";"
		xBuff 	+= "-"
	EndIf
	
	aLin 	:= StrTokArr(xBuff,";")
	
	dDataIni:= If(Len(aLin)>0,CtoD(aLin[1]),CtoD("  /  /  "))
	dDataFim:= If(Len(aLin)>1,CtoD(aLin[2]),CtoD("  /  /  "))
	cProduto:= If(Len(aLin)>2,StrTran(PadR(aLin[3],32," "),"-"," ")," ")
	nValorSw:= If(Len(aLin)>3,Val(StrTran(aLin[4],",",".")),0)
	nValorHw:= If(Len(aLin)>4,Val(StrTran(aLin[5],",",".")),0)
	nValorRe:= If(Len(aLin)>5,Val(StrTran(aLin[6],",",".")),0)
	
	If Len(aLin) < 6 .Or. Empty(dDataIni) .Or. Empty(cProduto)
		FT_FSKIP()
		Loop
	EndIf
	
	//Verifico se ja existe tabela no periodo, se não existe, gero uma nova.
	ZZ9->(DbSetOrder(3))
	If !ZZ9->(DbSeek(xFilial("ZZ9")+DtoS(dDataIni)+DtoS(dDataFim)))
		ZZ9->(DbSetOrder(1))
		ZZ9->(DBGoBottom())
		cCodTab := Soma1(ZZ9->ZZ9_COD)
	//Já tem tabela, utilizo o código.
	Else
		cCodTab := ZZ9->ZZ9_COD
	EndIf
	
	//Atualizo o registro atual caso encontre
	ZZ9->(DbSetOrder(2))
	If ZZ9->(DbSeek(xFilial("ZZ9")+cProduto+cCodTab))
		ZZ9->(Reclock("ZZ9",.F.))
	//Caso contrario grava novo.
	Else
		ZZ9->(Reclock("ZZ9",.T.))
	EndIf
	ZZ9->ZZ9_FILIAL := xFilial("ZZ9")  
	ZZ9->ZZ9_COD	:= cCodTab
	ZZ9->ZZ9_DTINI	:= dDataIni
	ZZ9->ZZ9_DTFIM	:= dDataFim
	ZZ9->ZZ9_PROD	:= cProduto  
	ZZ9->ZZ9_VALSW 	:= nValorSw  
	ZZ9->ZZ9_VALHW 	:= nValorHw 
	ZZ9->ZZ9_VLRENO	:= nValorRe
	ZZ9->(MsUnlock())  

	FT_FSKIP()
Enddo

FT_FUSE()
fClose(nHdl)


Return