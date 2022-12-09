#Include "Protheus.CH"

#DEFINE CRLF CHR(13) + CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIDA001


@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		08/07/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User function HCIDA001()

	Private _cFile := cGetFile('Arquivo Import Produto','Selecione arquivo',0,'',.T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)
	Private _aRet
	
	If !Empty(_cFile)
		If !File(_cFile)
			MsgAlert("Arquivo não localizado",'Arquivo Import Produto')
			Return
		Else
			Processa({|| _fHA001() },"Aguarde...","Importando registros...")
		EndIf
	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fHA001


@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		08/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fHA001()

	Local aAreaAnt		:= GetArea()
	Local _acFile		:= Separa(_cFile,"\")
	Local _nHandle		:= 0 
	Local _aArray		:= {}
	Local _aCabec		:= {}
	Local _aProd		:= {}
	Local _nPrdOk		:= 0
	Local _nPrdNOk		:= 0
	Local _nI			:= 0
	Local _nPrdCOk		:= 0
	Local _cDir			:= ""
	Local _cArquivo		:= "LOG_"+DtoS(dDataBase)+"_"+StrTran(Time(),":")+"_"+_AcFile[len(_acFile)]
	Local _cLinha		:= ""
	Local _cLog			:= ""
	Local _cChave		:= ""
	
	Private lMsErroAuto := .F.
	
	For _nI := 1 To Len(_acFile)-1
		_cDir	+= _acFile[_nI]+"\"
	Next _nI
	
	_nHandle	:= FCreate(AllTrim(_cDir)+AllTRim(_cArquivo))
	
	If _nHandle <= 0
		MsgAlert("Atenção, não foi possível criar o arquivo de log no diretório especificado ["+AllTrim(_cDir)+AllTRim(_cArquivo)+"]. Favor verificar!")
		Return(Nil)
	Else
	
		FT_FUSE(_cFile)
		
		ProcRegua(FT_FLASTREC())
		
		FT_FGOTOP()
		
		_cBuffer 	:= FT_FREADLN()
		If Len(_cBuffer) > 1022
			FT_FSKIP()
			_cBuffer	+= FT_FREADLN()
		Endif
		
		_cLinha	:= AllTrim(_cBuffer)+";LOG;CHAVE"
		FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		
		FT_FSKIP()
		_aCabec	:= Separa(_cBuffer,";")
		
		If Len(_aCabec) <> 39
			Aviso(OEMTOANSI("Atenção!"), OEMTOANSI("O arquivo selecionado não possui a estrutura correata para a importação ") + CRLF + '[' + AllTrim(_cFile) + '].'+CRLF+;
							"Favor verificar!",{"Ok"},2)
		Else
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))		
			
			While !FT_FEOF()
				IncProc(OEMTOANSI("Processando arquivo de importação... " ))
				
				_cBuffer 	:= FT_FREADLN()
				If Len(_cBuffer) > 1022
					FT_FSKIP()
					_cBuffer	+= FT_FREADLN()
				Endif
				
				_aArray	:= Separa(_cBuffer,";")
				_cChave	:= xFilial("SB1")+PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])
				
				SB1->(dbGoTop())
				If !SB1->(dbSeek(xFilial("SB1")+PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])))
/*					_aProd:= {	{"B1_COD"     ,PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])		,Nil},;
				 				{"B1_DESC"    ,_aArray[02]		,Nil},;
								{"B1_TIPO"    ,_aArray[03]		,Nil},;
								{"B1_LOCPAD"  ,_aArray[04]		,Nil},;
								{"B1_UM"      ,_aArray[05]		,Nil},;
								{"B1_GRUPO"   ,_aArray[06]		,Nil},;
								{"B1_ESPECIF" ,_aArray[07]		,Nil},;//								{"B1_XDESANT" ,_aArray[08]		,Nil},;
								{"B1_POSIPI"  ,_aArray[09]		,Nil},;
								{"B1_EX_NCM"  ,_aArray[10]		,Nil},;
								{"B1_EX_NBM"  ,_aArray[11]		,Nil},;
								{"B1_XSTATUS" ,"EN"				,Nil},;
								{"B1_IPI"     ,Val(_aArray[12])		,Nil},;
								{"B1_ALIQISS" ,Val(_aArray[13])		,Nil},;
								{"B1_CODISS"  ,_aArray[14]		,Nil},;
								{"B1_TRIBMUN" ,_aArray[15]		,Nil},;
								{"B1_CNAE"    ,_aArray[16]		,Nil},;
								{"B1_TE"      ,_aArray[17]		,Nil},;
								{"B1_SEGUM"   ,_aArray[18]		,Nil},;
								{"B1_TS"      ,_aArray[19]		,Nil},;
								{"B1_PICMRET" ,Val(_aArray[20])   ,Nil},;
								{"B1_PICMENT" ,Val(_aArray[21])   ,Nil},;
								{"B1_IMPZFRC" ,_aArray[22]		,Nil},;
								{"B1_CONV"    ,Val(_aArray[23])		,Nil},;
								{"B1_TIPCONV" ,_aArray[24]		,Nil},;
								{"B1_PRV1"    ,Val(_aArray[25])   ,Nil},;
								{"B1_CONTA"   ,_aArray[26]		,Nil},;
								{"B1_CC"      ,_aArray[27]		,Nil},;
								{"B1_ITEMCC"  ,_aArray[28]		,Nil},;
								{"B1_ORIGEM"  ,_aArray[29]		,Nil},;
								{"B1_CLASFIS" ,_aArray[30]		,Nil},;
								{"B1_FANTASM" ,_aArray[31]		,Nil},;
								{"B1_RASTRO"  ,_aArray[32]		,Nil},;
								{"B1_GRTRIB"  ,_aArray[33]		,Nil},;
								{"B1_PIS"     ,_aArray[34]		,Nil},;
								{"B1_COFINS"  ,_aArray[35]		,Nil},;
								{"B1_CSLL"    ,_aArray[36]		,Nil},;
								{"B1_GARANT" ,"N"				,Nil}} 
					lMsErroAuto := .F.
					MSExecAuto({|x,y| Mata010(x,y)},_aProd,3) //Inclusao
					
					If lMsErroAuto
						MostraErro()
						_nPrdNOk++
					Else
						_nPrdOk++
					EndIf
*/				
					If RecLock("SB1",.T.)
						SB1->B1_COD		:= PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])
		 				SB1->B1_DESC	:= _aArray[02]
						SB1->B1_TIPO	:= _aArray[03]
						SB1->B1_LOCPAD	:= _aArray[04]
						SB1->B1_UM		:= _aArray[05]
						SB1->B1_GRUPO	:= _aArray[06]
						SB1->B1_ESPECIF	:= _aArray[07]
						SB1->B1_POSIPI	:= _aArray[09]
						SB1->B1_EX_NCM	:= _aArray[10]
						SB1->B1_EX_NBM	:= _aArray[11]
						SB1->B1_XSTATUS	:= "EN"
						SB1->B1_IPI		:= Val(_aArray[12])
						SB1->B1_ALIQISS	:= Val(_aArray[13])
						SB1->B1_CODISS	:= _aArray[14]
						SB1->B1_TRIBMUN	:= _aArray[15]
						SB1->B1_CNAE	:= _aArray[16]
						SB1->B1_TE		:= _aArray[17]
						SB1->B1_SEGUM	:= _aArray[18]
						SB1->B1_TS		:= _aArray[19]
						SB1->B1_PICMRET	:= Val(_aArray[20])
						SB1->B1_PICMENT	:= Val(_aArray[21])
						SB1->B1_IMPZFRC	:= _aArray[22]
						SB1->B1_CONV	:= Val(_aArray[23])
						SB1->B1_TIPCONV	:= _aArray[24]
						SB1->B1_PRV1	:= Val(_aArray[25])
						SB1->B1_CONTA	:= _aArray[26]
						SB1->B1_CC		:= _aArray[27]
						SB1->B1_ITEMCC	:= _aArray[28]
						SB1->B1_ORIGEM	:= _aArray[29]
						SB1->B1_CLASFIS	:= _aArray[30]
						SB1->B1_FANTASM	:= _aArray[31]
						SB1->B1_RASTRO	:= _aArray[32]
						SB1->B1_GRTRIB	:= _aArray[33]
						SB1->B1_PIS		:= _aArray[34]
						SB1->B1_COFINS	:= _aArray[35]
						SB1->B1_CSLL	:= _aArray[36]
						SB1->B1_XUNDNEG	:= _aArray[37]
						SB1->B1_XATMAT	:= _aArray[38]
						SB1->B1_XTPMAT	:= _aArray[39]
						SB1->B1_GARANT	:= "N"
						_cLog	:= "Produto cadastrado com sucesso."
						_nPrdOk++
						SB1->(MsUnLock())						
					Else
						_cLog	:= "Produto nao cadastrado."
						_nPrdNOk++
					EndIf 
				Else
					_nPrdCOk++
					_cLog	:= "Produto ja cadastrado."
				EndIf
				
				_cLinha	:= AllTrim(_cBuffer)+";"+_cLog+";"+_cChave
				FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
								
				FT_FSKIP()
			EndDo
		EndIf
		
		FClose(_nHandle)	
		FT_FUSE()
		
		ShellExecute( "Open", AllTrim(_cDir)+AllTRim(_cArquivo), " ", "C:\TEMP\", 3 ) 
		
	EndIf
	// Restaura area
	RestArea(aAreaAnt)
	
	Aviso("Atencao!", 	"Foram processados os registros contidos no arquivo " + CRLF + '"' + _cFile + '".'+CRLF+;
						AllTrim(Str(_nPrdOk)) + " produto(s) incluso(s) com sucesso."+CRLF+AllTrim(Str(_nPrdNOk)) + " produto(s) com erro(s) de inclusão."+CRLF+;
						AllTrim(Str(_nPrdCOk)) + " produto(s) já cadastrado(s).",{"Ok"},3)

Return()