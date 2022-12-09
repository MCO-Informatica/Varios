#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA032   º Autor ³ Renato Ruy		 º Data ³  23/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para Controle de Pagamento Antecipado de Postos.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Remuneração de Parceiros                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA032


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de Pagamento Antecipado"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar"	,"AxPesqui"				,0,1} ,;
		             {"Visualizar"	,"U_CRPA032A(2)"		,0,2} ,;
		             {"Incluir"		,"U_CRPA032A(3)"		,0,3} ,;
		             {"Alterar"		,"U_CRPA032A(4)"		,0,4} ,;
		             {"Excluir"		,"U_CRPA032A(5)"		,0,5} ,;
		             {"Relatorio"	,"U_CRPA032R()"		,0,6} ,;
		             {"Integ.Baixas","U_CRPA032I()"		,0,7}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZ7"

dbSelectArea("ZZ7")
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

User Function CRPA032A(nOpcx)

//Campos que serao usados no aHeader.
Local cHeader   := "ZZ7_TITULO|ZZ7_CODPAR"
//Campos que serao usados no aCols.
Local cItens   	:= "ZZ7_PERIOD|ZZ7_PARCEL|ZZ7_VALOR|ZZ7_SALDO|ZZ7_NOTIFI|ZZ7_LOGNOT"
Local nUsado	:= 0 
Local cZZ7TIT	:= ""
Local cZZ7PAR	:= ""
Local lAlt		:= .T.
//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
Local nLinGetD	:= 0
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
Local cTitulo	:= "Remuneração - Títulos de Pagamento Antecipado"
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
Private cLinhaOk 	:= ".T."
Private cTudoOk  	:= "ExecBlock('CRPA032T',.f.,.f.)"
Private cValCod	:= "ExecBlock('CRPA032B',.f.,.f.)"
Private aCols		:= {}
//+------------------------------------------------+
//¦ Variaveis do cabecalho						   ¦
//+------------------------------------------------+
Private cPreTit	:= Space(3)
Private cNumTit	:= Space(10)
Private cParTit	:= Space(2)
Private cCodPar	:= Space(6)
Private cPerIni	:= Space(6)
Private cDesPar	:= Space(50)
Private cCodFor	:= Space(6)
Private cLojFor	:= Space(2)
Private nValTit	:= 0
Private nValTot	:= 0
Private nValSal	:= 0
Private npago		:= 0
Private nQtdPar	:= 0

//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZZ7")

aHeader:={}

While !Eof() .And. (SX3->X3_ARQUIVO == "ZZ7")
	
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
If nOpcx == 2 .Or. nOpcx == 4 .Or. nOpcx == 5
	nUsado := nUsado+1
		
	AADD(aHeader,{ 	"RECNO"			,;
					"RECNO"			,;
					""				,;
					15				,;
					0				,;
					""				,;
					"€€€€€€€€€€€€€€",;
					"N"				,; 
					"ZZ7"			,;
					"V"		 		})
EndIf

If nOpcx == 3 
	//+-----------------------------------------------+
	//¦ Montando aCols para a GetDados                ¦
	//+-----------------------------------------------+
	aCols:=Array(1,nUsado+1)
	SX3->(DbGoTop())
	DbSeek("ZZ7")
	nUsado := 0
	
	While !Eof() .And. (x3_arquivo == "ZZ7")
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
	
ElseIf nOpcx == 2 .Or. nOpcx == 4 .Or. nOpcx == 5
    cPreTit	:= ZZ7->ZZ7_PRETIT
    cZZ7TIT	:= ZZ7->ZZ7_TITULO
    cParTit := ZZ7->ZZ7_PARTIT
	cZZ7PAR	:= ZZ7->ZZ7_CODPAR
	
	ZZ7->(DbgoTop())
	ZZ7->(DbSetOrder(2))
	ZZ7->(DbSeek(xFilial("ZZ7")+cPreTit+cZZ7TIT+cParTit))
    
    While !ZZ7->(EOF()) .And. cZZ7TIT == ZZ7->ZZ7_TITULO
    	
    	If cZZ7PAR	== ZZ7->ZZ7_CODPAR
    		
    		aAdd(aCols,{ZZ7->ZZ7_PERIOD,ZZ7->ZZ7_PARCEL,ZZ7->ZZ7_VALOR,ZZ7->ZZ7_SALDO,ZZ7->ZZ7_NOTIFI,ZZ7->ZZ7_LOGNOT,ZZ7->(Recno()),.F.})
    		
    		If Empty(cPerIni)
    			cPerIni := ZZ7->ZZ7_PERIOD
    		Endif
    		
    		nQtdPar += 1
    		nValTit += ZZ7->ZZ7_VALOR
    		    		    		
    	EndIf

    	ZZ7->(DbSkip())
    Enddo 
    cNumTit := cZZ7TIT
    cCodPar := cZZ7PAR
    SZ3->(DbSetOrder(1))
    If SZ3->(DbSeek(xFilial("SZ3")+cZZ7PAR))
	   	cDesPar := SZ3->Z3_DESENT
	   	cCodFor := SZ3->Z3_CODFOR
	   	cLojFor := SZ3->Z3_LOJA
	Endif
   	
   	SE2->(DbSetOrder(1))
	If SE2->(DbSeek(xFilial("SE2")+cPreTit+cZZ7TIT+SubStr(cParTit,1,1)+"PA "+cCodFor+cLojFor))
		nValTot := SE2->E2_VALOR
		nValSal := SE2->E2_SALDO
		npago	 := SE2->E2_VALOR-SE2->E2_SALDO
	Endif

EndIf	

//Verifica se e inclusao para alterar o campo
lAlt := Iif(nOpcx == 3,.T.,.F.)

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
AADD(aC,{"cPreTit" 	,{015,001} ,"Pref.Tit.    "	,"@!"					,""					  		,""	  		,.T.})
AADD(aC,{"cNumTit" 	,{015,095} ,"Tit.Pagar"	   	,"@!"					,"U_CRPA032C(cNumTit)"	,"SE2PA"	,.T.})
AADD(aC,{"cParTit" 	,{015,195} ,"Parc.Tit.    "	,"@!"					,""					  		,""	  		,.T.})
AADD(aC,{"nValTit"	,{015,295} ,"Saldo Devedor"	,"@E 999,999,999.99"	,""			   		  		,""	  		,.T.})

AADD(aC,{"cPerIni"  ,{030,001} ,"Per.Inicial"		,"@!			   ",""			   		  ,""	  ,.T.})
AADD(aC,{"nQtdPar"  ,{030,095} ,"Parcelas"		,"@E 999,999,999"	,"U_CRPA032D(nQtdPar)","" ,lAlt})
AADD(aC,{"nValTot"  ,{030,195} ,"Adiantamento"	,"@E 999,999,999.99",""			   		  ,""	  ,.F.})
AADD(aC,{"nValSal"  ,{030,295} ,"Saldo"			,"@E 999,999,999.99",""			   		  ,""	  ,.F.})
AADD(aC,{"nPago"    ,{030,395} ,"Val.Pago"		,"@E 999,999,999.99",""			   		  ,""	  ,.F.})

AADD(aC,{"cCodPar"  ,{045,001} ,"Cod.Parceiro "	,"@!			   ","U_CRPA032B(cCodPar)","SZ3"  ,.T.})
AADD(aC,{"cDesPar"  ,{045,080} ,"Desc.Parceiro"	,"@!			   ",""			   		  ,""	  ,.F.})


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
	CRPA032E(cNumTit,cCodPar)
ElseIf lRet .And. nOpcx == 4
	CRPA032F(cNumTit,cCodPar)
ElseIf lRet .And. nOpcx == 5
	CRPA032G(cNumTit,cCodPar)
EndIf

Return

//Validação no campo codigo da entidade.
User Function CRPA032B(cCodPar) 

Local lRet := .F.

SZ3->(DbSetOrder(1))
If SZ3->(DbSeek(xFilial("SZ3")+cCodPar))
	cDesPar := SZ3->Z3_DESENT
	lRet	:= .T.
Else
	MsgInfo("Parceiro não localizado!")
EndIf

Return lRet

//Validação no campo titulo.
User Function CRPA032C(cNumTit) 

Local lRet := .F.

SE2->(DbSetOrder(1))
If SE2->(DbSeek(xFilial("SE2") + cPreTit + PadR(AllTrim(cNumTit),9," ") + cParTit + "PA"))
	nValTit := SE2->E2_SALDO
	lRet	:= .T.
Else
	MsgInfo("Título não localizado!")
EndIf

Return lRet

// Validação no campo Parcelas para geração de dados no aCols.

User Function CRPA032D(nQtdPar)

Local lRet 		:= .T.
Local cItens   	:= "ZZ7_PERIOD|ZZ7_PARCEL|ZZ7_VALOR|ZZ7_SALDO"
Local nUsado	:= 0
Local cPerRem	:= cPerIni
Local nPosPer	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PERIOD" })
Local nPosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PARCEL" })
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_VALOR"  })
Local nPosSal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_SALDO"  })
Local xObj

aCols:= {}
aCols:=Array(nQtdPar,5)

If nQtdPar < 1
	MsgInfo("A quantidade de parcelas deve ser maior que zero!")
	Return .F.
EndIf

If nValTit < 1
	MsgInfo("O saldo não pode ser igual a zero!")
	Return .F.
EndIf
//Para cada parcela gero uma linha.
For i := 1 to nQtdPar
	
	SX3->(DbGoTop())
	DbSeek("ZZ7")
	
	While !Eof() .And. (x3_arquivo == "ZZ7")
		IF X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
			nUsado:=nUsado+1

			If AllTrim(SX3->X3_CAMPO) == "ZZ7_PERIOD"
				aCOLS[i][nPosPer] := cPerRem
				
				If SubStr(cPerRem,5,2) < "12"
					cPerRem := Soma1(cPerRem)
				Else
					cPerRem := Soma1(SubStr(cPerRem,1,4))+"01"
				EndIf
			
			ElseIf AllTrim(SX3->X3_CAMPO) == "ZZ7_PARCEL"
				aCOLS[i][nPosPar] := Padl(AllTrim(Str(i)),3,"0")
			ElseIf AllTrim(SX3->X3_CAMPO) == "ZZ7_VALOR"
				aCOLS[i][nPosVal] := nValTit / nQtdPar
			ElseIf AllTrim(SX3->X3_CAMPO) == "ZZ7_SALDO"
				aCOLS[i][nPosSal] := nValTit / nQtdPar
			EndIf 

		Endif
		dbSkip()
	End
	
	aCOLS[i][nUsado+1] := .F.
    
	nUsado := 0
Next	

//Atualiza o Browse do modelo 2.
xObj := CallMod2Obj()
xObj:oBrowse:Refresh()

Return lRet

//Gravação de Dados referente ao pagamento antecipado.
Static Function CRPA032E(cNumTit,cCodPar)

Local nPosPer	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PERIOD" })
Local nPosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PARCEL" })
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_VALOR"  })
Local nPosSal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_SALDO"  })

ZZ7->(DbSetOrder(3))
If ZZ7->(Dbseek(xFilial("ZZ7")+cCodPar+cPreTit+cNumTit+cParTit))
	MsgInfo("Já existe pagamento antecipado cadastrado para o Parceiro!")
	Return .F.
EndIf

For i := 1 to Len(aCols)
	ZZ7->(Reclock("ZZ7",.T.))
		ZZ7->ZZ7_FILIAL := xFilial("ZZ7")  
		ZZ7->ZZ7_PRETIT := cPreTit 
		ZZ7->ZZ7_TITULO := cNumTit 
		ZZ7->ZZ7_PARTIT := cParTit 
		ZZ7->ZZ7_CODPAR := cCodPar  
		ZZ7->ZZ7_PERIOD := aCols[i][nPosPer]  
		ZZ7->ZZ7_PARCEL := aCols[i][nPosPar]  
		ZZ7->ZZ7_VALOR  := aCols[i][nPosVal]   
		ZZ7->ZZ7_SALDO  := aCols[i][nPosSal]  
	ZZ7->(MsUnlock())  
Next

Return 

//Gravação de Dados da alteração.
Static Function CRPA032F(cNumTit,cCodPar)

Local nPosPer	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PERIOD" })
Local nPosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_PARCEL" })
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_VALOR"  })
Local nPosSal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ7_SALDO"  })
Local nPosRec	:= aScan(aHeader,{|x| AllTrim(x[2]) == "RECNO"  	})

For i := 1 to Len(aCols)
	
	//Me posiciono.
	ZZ7->(DbGoTo( aCols[i][nPosRec] ))
	
	//verifico se a linha nao esta deletada.
	If !aCols[i][nPosRec+1]                 
		//se tem recno atualiza.
		If aCols[i][nPosRec] > 0 
			ZZ7->(Reclock("ZZ7",.F.))
		//Caso contrario grava novo.
		Else
			ZZ7->(Reclock("ZZ7",.T.))
		EndIf
			ZZ7->ZZ7_FILIAL := xFilial("ZZ7")  
			ZZ7->ZZ7_PRETIT := cPreTit 
			ZZ7->ZZ7_TITULO := cNumTit 
			ZZ7->ZZ7_PARTIT := cParTit 
			ZZ7->ZZ7_CODPAR := cCodPar  
			ZZ7->ZZ7_PERIOD := aCols[i][nPosPer]  
			ZZ7->ZZ7_PARCEL := aCols[i][nPosPar]  
			ZZ7->ZZ7_VALOR  := aCols[i][nPosVal]   
			ZZ7->ZZ7_SALDO  := aCols[i][nPosSal]  
		ZZ7->(MsUnlock())  
  	Elseif aCols[i][nPosRec] > 0
  		ZZ7->(RecLock('ZZ7',.F.))
		ZZ7->(dbDelete())
		ZZ7->(MsUnlock())
  	EndIf
Next

Return 

//Exclusão de dados.
Static Function CRPA032G(cNumTit,cCodPar)

Local nPosRec	:= aScan(aHeader,{|x| AllTrim(x[2]) == "RECNO"  	})

If MsgYesNo("Você realmente deseja excluir este lançamento?")    
	For i := 1 to Len(aCols)
		//Me posiciono
		ZZ7->(DbGoTo( aCols[i][nPosRec] ))
		//Apago o registro.
	 	ZZ7->(RecLock('ZZ7',.F.))
			ZZ7->(dbDelete())
	  	ZZ7->(MsUnLock())

	Next
EndIf

Return 

//Relatório de Adiantamentos
User Function CRPA032R()
Local aRet 	:= {}
Local bValid  := {|| .T. }
Local aPar 	:= {}
Local cDirTemp:= GetTempPath()
Local oExcel 	:= FWMSEXCEL():New()

//Cria nova aba
oExcel:AddworkSheet("Adiantamentos")

//Cria Cabecalho da tabela
oExcel:AddTable ("Adiantamentos","Capa")

//Adiciona cabecalho da primeira planilha
oExcel:AddColumn("Adiantamentos","Capa","Parceiro"		, 2,1)
oExcel:AddColumn("Adiantamentos","Capa","Descricao"		, 2,1)
oExcel:AddColumn("Adiantamentos","Capa","Total PA"		, 2,3)
oExcel:AddColumn("Adiantamentos","Capa","Saldo PA"		, 2,3)

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})

If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA031" , .T., .F. )
	
	//Apaga arquivo temporario caso tenha sido emitido anteriormente
	If Select("TMPCAP") > 0
		DbSelectArea("TMPCAP")
		TMPCAP->(DbCloseArea())
	Endif
	
	//Busca dados para capa do relatório
	Beginsql Alias "TMPCAP"
		SELECT ZZ7_CODPAR, SUM(VALOR) VALOR, SUM(SALDO) SALDO FROM
		(SELECT  ZZ7_CODPAR,
		        ZZ7_PRETIT,
		        ZZ7_TITULO,
		        ZZ7_PARTIT,
		        NVL(MAX(E2_VALOR),SUM(ZZ7_VALOR)) VALOR,
		        NVL(MAX(E2_SALDO),0) SALDO
		FROM %Table:ZZ7% ZZ7
		LEFT JOIN %Table:SE2% SE2 
		ON E2_FILIAL = %xFilial:SE2% AND E2_PREFIXO = ZZ7_PRETIT AND E2_NUM = ZZ7_TITULO AND E2_NUM > ' ' AND E2_PARCELA = ZZ7_PARTIT AND SE2.%Notdel%
		WHERE
		ZZ7_FILIAL = %xFilial:ZZ7% AND
		ZZ7.%Notdel%
		GROUP BY  ZZ7_CODPAR,
		          ZZ7_PRETIT,
		          ZZ7_TITULO,
		          ZZ7_PARTIT)
		GROUP BY ZZ7_CODPAR
		ORDER BY ZZ7_CODPAR
	Endsql
	
	While !TMPCAP->(EOF())
		oExcel:AddRow("Adiantamentos","Capa",{	TMPCAP->ZZ7_CODPAR	,;
													Posicione("SZ3",1,xFilial("SZ3")+TMPCAP->ZZ7_CODPAR,"Z3_DESENT"),;
								                	TMPCAP->VALOR	,; 
								                	TMPCAP->SALDO	})
		TMPCAP->(DbSkip())
	Enddo
	
	//Se usuario nao informou periodo, somente gera capa.
	If Empty(aRet[1])
		MsgInfo("Não foi informado período, somente a capa do relatório será gerada!")
	Else
		//Apaga arquivo temporario caso tenha sido emitido anteriormente
		If Select("TMPPER") > 0
			DbSelectArea("TMPPER")
			TMPPER->(DbCloseArea())
		Endif
		
		//Busca dados por período
		Beginsql Alias "TMPPER"
	
			SELECT  ZZ7_CODPAR,
			        SUM(ZZ7_VALOR) VALOR
			FROM %Table:ZZ7% ZZ7
			WHERE
			ZZ7_FILIAL = %xFilial:ZZ7% AND
			ZZ7_PERIOD = %Exp:aRet[1]% AND
			ZZ7.%Notdel%
			GROUP BY  ZZ7_CODPAR
		
		Endsql
		
		//Cria nova aba
		oExcel:AddworkSheet("Período-"+aRet[1])
		
		//Cria Cabecalho da tabela
		oExcel:AddTable ("Período-"+aRet[1],"Adiantamentos")
		
		//Adiciona cabecalho da primeira planilha
		oExcel:AddColumn("Período-"+aRet[1],"Adiantamentos","Parceiro"		, 2,1)
		oExcel:AddColumn("Período-"+aRet[1],"Adiantamentos","Descricao"	, 2,1)
		oExcel:AddColumn("Período-"+aRet[1],"Adiantamentos","Total PA Mês"	, 2,3)
		
		While !TMPPER->(EOF())
			oExcel:AddRow("Período-"+aRet[1],"Adiantamentos",{	TMPPER->ZZ7_CODPAR	,;
														Posicione("SZ3",1,xFilial("SZ3")+TMPPER->ZZ7_CODPAR,"Z3_DESENT"),;
									                	TMPPER->VALOR	})
			TMPPER->(DbSkip())
		Enddo
		
		
	Endif
	
	//Salva o Arquivo
	oExcel:Activate()
	oExcel:GetXMLFile(cDirTemp+"Adiantamentos.xls") 
		
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cDirTemp+"Adiantamentos.xls" )
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
	
Else
	Alert("Relatório Cancelado!")
Endif


Return

//Validação no OK
User Function CRPA032T() 

Local lRet := .T.

If Empty(cNumTit)
	lRet := .F.
	MsgInfo("O Título deve ser preenchido!")
Endif

Return lRet

//Renato Ruy - 21/09/18
//Integrar baixas do controle de pagamento antecipado com fechamento
User Function CRPA032I

Beginsql Alias "TMPZZ7"

	SELECT ZZ7.R_E_C_N_O_ RECNOZZ7 FROM %TABLE:ZZ7% ZZ7
	JOIN %TABLE:ZZ6% ZZ6 
	ON ZZ6_FILIAL = %XFILIAL:ZZ6% AND ZZ6_CODENT = ZZ7_CODPAR AND ZZ6_PERIOD = ZZ7_PERIOD AND ZZ6_SALDO = 0 AND ZZ6.%NOTDEL%
	WHERE
	ZZ7_FILIAL = %XFILIAL:ZZ7% AND
	ZZ7_SALDO > 0 AND
	ZZ7.%NOTDEL%

Endsql

While !TMPZZ7->(EOF())
	ZZ7->(DbGoTo(TMPZZ7->RECNOZZ7))
	
	ZZ7->(RecLock("ZZ7",.F.))
		ZZ7->ZZ7_SALDO := 0
	ZZ7->(MsUnlock())
		
	
	TMPZZ7->(DbSkip())
Enddo

Msginfo("As baixas foram realizadas com sucesso!")

Return