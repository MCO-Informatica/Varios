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
User function HCIDA002()

	Private _cFile := cGetFile('Arquivo Import Roteiros','Selecione arquivo',0,'',.T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)
	Private _aRet
	
	If !Empty(_cFile)
		If !File(_cFile)
			MsgAlert("Arquivo não localizado",'Arquivo Import Roteiros')
			Return
		Else
			Processa({|| _fHA002() },"Aguarde...","Importando registros...")
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
Static Function _fHA002()

	Local aAreaAnt		:= GetArea()
	Local _acFile		:= Separa(_cFile,"\")
	Local _nHandle		:= 0 
	Local _aArray		:= {}
	Local _aCabec		:= {}
	Local _aProd		:= {}
	Local _nPrdOk		:= 0
	Local _nPrdNOk		:= 0
	Local _nPrdEx		:= 0
	Local _nI			:= 0
	Local _nPrdCOk		:= 0
	Local _cDir			:= ""
	Local _cArquivo		:= "LOG_"+DtoS(dDataBase)+"_"+StrTran(Time(),":")+"_"+_AcFile[len(_acFile)]
	Local _cLinha		:= ""
	Local _cLog			:= ""
	Local _cChave		:= ""
	Local _cChave2		:= ""
	
	For _nI := 1 To Len(_acFile)-1
		_cDir	+= _acFile[_nI]+"\"
	Next _nI

	_nHandle	:= FCreate(AllTrim(_cDir)+AllTRim(_cArquivo))
	
	If _nHandle <= 0
		MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado ["+AllTrim(_cDir)+AllTRim(_cArquivo)+"]. Favor verificar!")
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
		
		_cLinha	:= AllTrim(_cBuffer)+";LOG;CHAVE PRODUTO;CHAVE ROTEIRO"
		FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		
		FT_FSKIP()
		_aCabec	:= Separa(_cBuffer,";")
		
		If Len(_aCabec) <> 9
			Aviso(OEMTOANSI("Atenção!"), OEMTOANSI("O arquivo selecionado não possui a estrutura correata para a importação ") + CRLF + '[' + AllTrim(_cFile) + '].'+CRLF+;
							"Favor verificar!",{"Ok"},2)
		Else
			dbSelectArea("SG2")
			SG2->(dbSetOrder(1))		
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			
			While !FT_FEOF()
				IncProc(OEMTOANSI("Processando arquivo de importação... " ))
				
				_cBuffer 	:= FT_FREADLN()
				If Len(_cBuffer) > 1022
					FT_FSKIP()
					_cBuffer	+= FT_FREADLN()
				Endif
				
				_aArray		:= Separa(_cBuffer,";")
				_cChave		:= xFilial("SB1")+PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])
				_cChave2	:= ""
				
				SG2->(dbGoTop())
				SB1->(dbGoTop())
				If SB1->(dbSeek(xFilial("SB1")+PadR(AllTrim(_aArray[1]),TamSX3("B1_COD")[1])))
					_cChave2	:= xFilial("SG2") + PadR(AllTrim(_aArray[1]),TamSX3("G2_PRODUTO")[1]) + PadR(AllTrim(_aArray[2]),TamSX3("G2_CODIGO")[1]) + PadR(AllTrim(_aArray[3]),TamSX3("G2_OPERAC")[1])
					If !SG2->(dbSeek(xFilial("SG2") + PadR(AllTrim(_aArray[1]),TamSX3("G2_PRODUTO")[1]) + PadR(AllTrim(_aArray[2]),TamSX3("G2_CODIGO")[1]) + PadR(AllTrim(_aArray[3]),TamSX3("G2_OPERAC")[1])))
						If RecLock("SG2",.T.)
							SG2->G2_FILIAL	:= xFilial("SG2")
							SG2->G2_CODIGO	:= _aArray[2]
							SG2->G2_PRODUTO	:= _aArray[1]
							SG2->G2_OPERAC	:= _aArray[3]
							SG2->G2_RECURSO	:= _aArray[4]
							SG2->G2_DESCRI	:= _aArray[5]
							SG2->G2_SETUP	:= VAL(_aArray[6])
							SG2->G2_LOTEPAD	:= Val(_aArray[7])
							SG2->G2_TEMPAD	:= Val(_aArray[8])
							SG2->G2_CTRAB	:= _aArray[9]
							_nPrdOk++
							_cLog	:= "Roteiro cadastrado com sucesso."
							SG2->(MSUNLOCK())
							
						Else
							_cLog	:= "Roteiro nao cadastrado."
							_nPrdNOk++
						EndIf
					Else
						_cLog	:= "Roteiro ja cadastrado."
						_nPrdEx++
					EndIf
				Else
					_cLog	:= "Produto utilizado não cadastrado."
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
						AllTrim(Str(_nPrdOk)) + " roteiro(s) incluso(s) com sucesso."+CRLF+AllTrim(Str(_nPrdNOk)) + " roteiro com erro(s) de inclusão."+CRLF+;
						AllTrim(Str(_nPrdEx)) + " roteiro(s) já cadastrado(s).",{"Ok"},3)

Return()