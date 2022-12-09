#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGARA121   บAutor  ณArmando M. Tessaroliบ Data ณ  05/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCom base nas tabelas de log GTIN e GTOUT gera uma planilha  บฑฑ
ฑฑบ          ณcom pedidos a serem processados pela rotina GARA120.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OPVS                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GARA121()

Local cPerg		:= "GAR121"
Local aSays		:= {}
Local aButtons	:= {}
Local lPerg		:= .F.

//Rpcsettype(3)
//RpcSetEnv('01','02')

Aadd( aSays, "GERA ARQUIVO .CSV PARA PROCESSAR NA ROTINA GARA120" )
Aadd( aSays, "" )
Aadd( aSays, "Este programa vai fazer uma busca nos arquivos de log de controle dos processos" )
Aadd( aSays, "de integra็ใo com o GAR e gerar um arquivo no layout .CSV para ser processado" )
Aadd( aSays, "posteriormente na rotina GARA120." )
Aadd( aSays, "Este arquivo originalmente seria processado pelo GAR." )

AjustaSX1(cPerg)
Pergunte(cPerg, .T. )

Aadd(aButtons, { 5,.T.,{|| lPerg:=Pergunte(cPerg, .T. ) } } )
Aadd(aButtons, { 1,.T.,{|| Processa( {|| GAR121File(cPerg,lPerg) }, "Selecionando lan็amentos...") }} )
Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

DbSelectArea("SZ5")

FormBatch( "Gera arquivo de pend๊ncias...", aSays, aButtons )

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGARA121   บAutor  ณMicrosiga           บ Data ณ  06/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GAR121File(cPerg,lPerg)

Local cQuery	:= ""
Local nHandle	:= -1
Local cLinha	:= "Z5_FILIAL;Z5_PEDGAR;Z5_DATPED;Z5_EMISSAO;Z5_RENOVA;Z5_REVOGA;Z5_DATVAL;Z5_HORVAL;Z5_CNPJ;Z5_CNPJCER;Z5_NOMREC;Z5_DATPAG;Z5_VALOR;Z5_TIPMOV;Z5_STATUS;Z5_GARANT;Z5_CODAR;Z5_DESCAR;Z5_CODPOS;Z5_DESPOS;Z5_CODAGE;Z5_NOMAGE;Z5_CPFAGE;Z5_CERTIF;Z5_PRODUTO;Z5_DESPRO;Z5_GRUPO;Z5_DESGRU;Z5_TIPVOU;Z5_CODVOU;"
Local cParam	:= ""
Local aParam	:= {}
Local nQtd		:= 0
Local nRecGtIn	:= 0
Local lCabec	:= .F.

While .T.
	
	If !lPerg
		If !Pergunte(cPerg, .T. )
			Return(.F.)
		Endif
	Endif
	
	If Mv_Par02 < Mv_Par01
		MsgStop("Datas invแlidas...")
		lPerg := .F.
		Loop
	Endif
	
	If Empty(Mv_Par03)
		MsgStop("Arquivo invแvido...")
		lPerg := .F.
		Loop
	Endif
	
	If File(AllTrim(Mv_Par03))
		If MsgYesNo("Arquivo jแ existe. Deseja substituir?")
			If FERASE(AllTrim(Mv_Par03)) == -1
				MsgStop("Nใo foi possํvel excluir o arquivo atual...")
				Return(.F.)
			Endif
		Else
			lPerg := .F.
			Loop
		Endif
	Endif
	
	// Cria o arquivo de saida...
	nHandle := FCREATE(AllTrim(Mv_Par03),1)
	Exit
End

cQuery	:=	" SELECT   DISTINCT GT_PEDGAR " +;
" FROM     GTOUT " +;
" WHERE    SUBSTR(GT_ID,1,4)<>'GARA' AND GT_DATE BETWEEN '" + Dtos(Mv_Par01) + "' AND '" + Dtos(Mv_Par02) + "' AND " +;
"          GT_STATUS = 'N' AND " +;
"          GT_ULTIMO = 'S' AND " +;
"          GT_TYPE = 'E' AND " +;
"          GT_PEDGAR <> ' ' AND " +;
"          GT_XNPSITE = ' '  AND " +;
"          GT_CODMSG NOT IN('000120','000132', 'ER0003') AND " +; //
"          GT_PEDGAR NOT IN( SELECT GT_PEDGAR FROM GTOUT WHERE GT_STATUS='S' AND GT_ULTIMO='S' AND GT_TYPE='E' AND GT_XNPSITE = ' ' AND GT_PEDGAR <> ' 'GROUP BY GT_PEDGAR) AND " +;
"          D_E_L_E_T_ = ' ' "



MsgRun("Obtendo informa็๕es GTOUT...","Aguarde ...",{|| PLSQuery( cQuery, "GTOTMP" ) } )

ProcRegua( 0 )

//FWrite(nHandle, cLinha + CRLF )
cLinha := ""

USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"

While GTOTMP->( !Eof() )
	
	IncProc("Processando registro.: "+AllTrim(Str(nQtd++)))
	ProcessMessage()
	
	cQuery	:=	" SELECT  MIN(R_E_C_N_O_) R_E_C_N_O_" +;
	" FROM    GTIN " +;
	" WHERE   GTIN.GT_PEDGAR = '" + GTOTMP->GT_PEDGAR+ "' AND " +;
	"         GTIN.GT_TYPE = 'N' AND " +;
	"         D_E_L_E_T_ = ' ' " +;
	" ORDER BY R_E_C_N_O_ "
	
	nRecGtIn := 0
	
	USE (TcGenQry(,,cQuery)) ALIAS GTITMP EXCLUSIVE NEW VIA "TOPCONN"
	
	If GTITMP->( !Eof() )
		nRecGtIn := GTITMP->R_E_C_N_O_
	Endif
	
	GTITMP->( DbCloseArea() )
	
	If nRecGtIn == 0
		GTOTMP->( DbSkip() )
		Loop
	End
	
	GTIN->( DbGoTo( nRecGtIn ) )
	
	cParam := AllTrim(GTIN->GT_PARAM)
	
	If !Empty(cParam)
		cParam := '{"' + StrTran(cParam,CRLF,'","') + '"}'
		aParam := &(cParam)
		
		If !lCabec
			
			For nI := 1 To Len(aParam)
				cParam := aParam[nI]
				nPos := At("Z5_",cParam)
				If nPos > 0
					cLinha += Upper(SubStr(cParam,nPos,At("]",SubStr(cParam,nPos))-1)) + ";"
				Endif
			Next nI
			FWrite(nHandle, cLinha + CRLF )
			cLinha := ""
			cCampo := ""
			cConteudo:=""
			lCabec := .T.
		Endif
		
		// Cria o objeto client do WebSErvices
		oWSObj := WSCERTISIGNERP():New()
		
		For nI := 1 To Len(aParam)
			cParam := aParam[nI]
			nPos := At("Z5_",cParam)
			cCampo:=Upper(SubStr(cParam,nPos,At("]",SubStr(cParam,nPos))-1))
			If nPos > 0
				nI++
				If nI > Len(aParam)
					Exit
				Endif
				cParam := aParam[nI]
				cConteudo:=Upper(SubStr(cParam,nPos,At("]",SubStr(cParam,nPos))-1))
				If cCampo=='Z5_PEDGAR'
					oWSObj:OWSMOVNOTA:cZ5PEDGAR		:=cConteudo
				ElseIf cCampo=='Z5_DATPED'
					oWSObj:OWSMOVNOTA:dZ5DATPED		:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_EMISSAO'
					oWSObj:OWSMOVNOTA:dZ5EMISSAO	:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_RENOVA'
					oWSObj:OWSMOVNOTA:dZ5RENOVA		:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_REVOGA'
					oWSObj:OWSMOVNOTA:dZ5REVOGA		:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_DATVAL'
					oWSObj:OWSMOVNOTA:dZ5DATVAL		:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_HORVAL'
					oWSObj:OWSMOVNOTA:cZ5HORVAL		:=cConteudo
				ElseIf cCampo=='Z5_CNPJ'
					oWSObj:OWSMOVNOTA:cZ5CNPJ		:=cConteudo
				ElseIf cCampo=='Z5_CNPJCER'
					oWSObj:OWSMOVNOTA:cZ5CNPJCER	:=cConteudo
				ElseIf cCampo=='Z5_NOMREC'
					oWSObj:OWSMOVNOTA:cZ5NOMREC		:=cConteudo
				ElseIf cCampo=='Z5_DATPAG'
					oWSObj:OWSMOVNOTA:dZ5DATPAG		:=CtoD(cConteudo)
				ElseIf cCampo=='Z5_VALOR'
					oWSObj:OWSMOVNOTA:nZ5VALOR		:=(val(cConteudo))
				ElseIf cCampo=='Z5_TIPMOV'
					oWSObj:OWSMOVNOTA:cZ5TIPMOV		:=cConteudo
				ElseIf cCampo=='Z5_STATUS'
					oWSObj:OWSMOVNOTA:cZ5STATUS		:=cConteudo
				ElseIf cCampo=='Z5_CODAR'
					oWSObj:OWSMOVNOTA:cZ5CODAR		:=cConteudo
				ElseIf cCampo=='Z5_DESCAR'
					oWSObj:OWSMOVNOTA:cZ5DESCAR		:=cConteudo
				ElseIf cCampo=='Z5_CODPOS'
					oWSObj:OWSMOVNOTA:cZ5CODPOS		:=cConteudo
				ElseIf cCampo=='Z5_DESPOS'
					oWSObj:OWSMOVNOTA:cZ5DESPOS		:=cConteudo
				ElseIf cCampo=='Z5_CODAGE'
					oWSObj:OWSMOVNOTA:cZ5CODAGE		:=cConteudo
				ElseIf cCampo=='Z5_NOMAGE'
					oWSObj:OWSMOVNOTA:cZ5NOMAGE		:=cConteudo
				ElseIf cCampo=='Z5_CPFAGE'
					oWSObj:OWSMOVNOTA:cZ5CPFAGE		:=cConteudo
				ElseIf cCampo=='Z5_CERTIF'
					oWSObj:OWSMOVNOTA:cZ5CERTIF		:=''
				ElseIf cCampo=='Z5_PRODUTO'
					oWSObj:OWSMOVNOTA:cZ5PRODUTO	:=cConteudo
				ElseIf cCampo=='Z5_DESPRO'
					oWSObj:OWSMOVNOTA:cZ5DESPRO		:=cConteudo
				ElseIf cCampo=='Z5_GRUPO'
					oWSObj:OWSMOVNOTA:cZ5GRUPO		:=cConteudo
				ElseIf cCampo=='Z5_DESGRU'
					oWSObj:OWSMOVNOTA:cZ5DESGRU		:=cConteudo
				ElseIf cCampo=='Z5_GARANT'
					oWSObj:OWSMOVNOTA:cZ5GARANT		:=''
					
				Endif
				
				
				If cCampo=='Z5_VALOR'
					cLinha += str(val(cConteudo))+ ";"
				Else
					cLinha += cConteudo + ";"
				Endif
				
			Endif
		Next nI
		//Grava arquivo de Log
		
		
		//Gera nota fiscal
		
		// Liga , apegas para debug, as mensagens de echo e diagnostico
		// do client de webservices no protheus
		// WSDLDbgLevel(3)
		
		nTime := Seconds()
		
		If !Empty(oWSObj:OWSMOVNOTA:cZ5PEDGAR)
				 cPedLog:=(oWSObj:OWSMOVNOTA:cZ5PEDGAR)
				// Aghora chama o metodo de gerar nota
				// Um metodo client retorna .t. em caso de sucesso e .f. em caso de falha
				oWSObj:GERANOTA()
				cMsg :=''
				
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2)  // Soap Fault Code
				cSoapFDescr := GetWSCError(3)  // Soap Fault Description
				
				If !empty(cSoapFCode)
					//Caso a ocorr๊ncia de erro esteja com o fault_code preenchido ,
					//a mesma teve rela็ใo com a chamada do servi็o .
					Conout(cSoapFDescr + ' ' + cSoapFCode)
					
					aRet := {}
					Aadd( aRet, .F.)
					Aadd( aRet, "E00001" )
					Aadd( aRet, cPedLog )
					Aadd( aRet, "Falha ao tentar gerar o faturamento da entrega")
					U_GTPutOUT(cPedLog,"E",cPedLog,{"GARA121",aRet})
				ElseIf !Empty(cSvcError)
					//Caso a ocorr๊ncia nใo tenha o soap_code preenchido
					//Ela estแ relacionada a uma outra falha ,
					//provavelmente local ou interna.

					aRet := {}
					Aadd( aRet, .F.)
					Aadd( aRet, "E00001" )
					Aadd( aRet, cPedLog )
					Aadd( aRet, "Falha ao tentar gerar o faturamento da entrega")
					U_GTPutOUT(cPedLog,"E",cPedLog,{"GARA121",aRet})
					
					Conout(cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIวO')
				Endif
				
				
				
				
				If oWSObj:oWSGERANOTARESULT:lOk
					cMsg := "RETURN OK     - DETAILSTR "+oWSObj:oWSGERANOTARESULT:cDetailStr + " - "+ time()
					cLinha += cMsg+ ';'
					//	FWrite(nHandle, AllTrim(SZ5TMP->Z5_PEDGAR)+" ---> " + cMsg + CRLF )
				Else
						// Passou de 5 minutos tentando ? Desiste !
						cMsg := "RETURN FAILED - DETAILSTR "+oWSObj:oWSGERANOTARESULT:cDetailStr + " - " + time()
						cLinha += cMsg+ ';'
						//FWrite(nHandle, AllTrim(SZ5TMP->Z5_PEDGAR)+" ---> " + cMsg + CRLF )
				Endif
				
			
			FWrite(nHandle, cLinha + CRLF )
			// Terminou, elimina o objeto client da memoria.
		Endif
		
		
		FreeObj(oWSObj)
		
		Sleep(5000)
		
	Endif
	
	GTOTMP->( DbSkip() )
	
	cLinha := ""
	cCampo := ""
	cConteudo:= ""
	
	
End
GTOTMP->( DbCloseArea() )
GTIN->( DbCloseArea() )

FClose(nHandle)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGARA121   บAutor  ณMicrosiga           บ Data ณ  06/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Aadd(aRegs,{cPerg,"01","Data De",				"","","MV_CH1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data At้",				"","","MV_CH2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Drive+Path+File+Ext",	"","","MV_CH3","C",50,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

PlsVldPerg( aRegs )

Return(.T.)
