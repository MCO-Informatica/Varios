#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"

// Programa   	LS_CTBTXT
// Autor 		Alexandre Dalpiaz
// Data 		23/08/2013
// Descricao  	CONTABILIZAÇÃO TXT - VÁRIAS DATAS E FILIAIS - PRECISAR RODAR O REPROCESSAMENTO
// Uso         	LaSelva

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CTBTXT()
/////////////////////////
Local _Opcao := .f.

If MsgYesNO("Confirma Processamento?","Importação de arquivo texto")
	Processa({|| ImpTXT()},"Importando Dados...")
	MsgInfo("Importação Finalizada!!!")
	
EndIf

Return nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImpTXT()
//////////////////////////
Local _nI, _nLinha
_aArquivos  := Directory("\system\Integracao\CTBTXT\*.TXT","D")

_cErros := ''
_nErros := 0
For _nI := 1 to Len(_aArquivos)
	
	_cArqOpen := '\system\Integracao\CTBTXT\' + _aArquivos[_nI,1]
	_cErros += 'Arquivo: ' + _cArqOpen + _cEnter
	FT_FUSE(_cArqOpen)
	
	ProcRegua(FT_FLastRec())
	FT_FGotop()
	
	_nLinha   := 0
	_nErroArq := 0
	Do While ( !FT_FEof() )
		++_nLinha
		IncProc()
		_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))
		If empty(_cLinha)
			FT_FSkip()
			loop
		EndIf
		
		_cFilAnt := substr(_cLinha,5,2)
		If !SM0->(DbSeek('01' + _cFilAnt,.f.))
			++_nErroArq
			_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
			FT_FSkip()
			++_nlinha
			loop
		EndIf                    
		
		Do While ( !FT_FEof() ) .and. _cFilAnt == substr(_cLinha,5,2)
			_cData := dtos(ctod(tran(substr(_cLinha,8,8),'@R 99/99/9999')))
			_cLote := substr(_cLinha,19,6)
			If CT2->(DbSeek(_cFilAnt + _cData + _cLote ,.f.))
				++_nErroArq
				_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial + data + lote já existentes: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
				FT_FSkip()
				IncProc()
				_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))
				++_nlinha

				_cFilAnt := substr(_cLinha,5,2)
				If !SM0->(DbSeek('01' + _cFilAnt,.f.))
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
					FT_FSkip()
					++_nlinha
					exit
				EndIf                    
		
				loop

			EndIf

			_cQuery := "SELECT *"
			_cQuery += _cEnter + " FROM " + RetSqlName('CTG') + " (NOLOCK)"
			_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
			_cQuery += _cEnter + " AND '" + _cData + "' BETWEEN CTG_DTINI AND CTG_DTFIM"

			dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), "TMP", .F., .T.)
			_cStatus := TMP->CTG_STATUS
			DbCloseArea()
         	If _cStatus <> '1'
				++_nErroArq
				_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Calendário contábil ' + iif(empty(_cStatus),'não cadastrado.','bloqueado.') + '  Filial + data + lote: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
				FT_FSkip()
				IncProc()
				_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))
				++_nlinha
				_cFilAnt := substr(_cLinha,5,2)
				If !SM0->(DbSeek('01' + _cFilAnt,.f.))
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
					FT_FSkip()
					++_nlinha
					exit
				EndIf                    
				loop
			EndIf
			
			_nLinDoc := 0    
			_cDoc    := '000001'
			
			_cQuery := "SELECT MAX(CT2_SEQUEN) CT2_SEQUEN"
			_cQuery += _cEnter + "FROM " + RetSqlName('CT2') + " CT2 (NOLOCK)"
			_cQuery += _cEnter + "WHERE CT2.D_E_L_E_T_ = ''"
			_cQuery += _cEnter + "AND CT2_FILIAL = '" + _cFilAnt + "'"
			
			dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), "TMP", .F., .T.)
			_cSequen := TMP->CT2_SEQUEN
			DbCloseArea()
			
			Do While ( !FT_FEof() ) .and. _cFilAnt == substr(_cLinha,5,2) .and. _cData == dtos(ctod(tran(substr(_cLinha,8,8),'@R 99/99/9999'))) .and. _cLote == substr(_cLinha,19,6)
				
				If !empty(substr(_cLinha,26,20)) .and. Posicione('CT1',1,xFilial('CT1') + substr(_cLinha,26,20),'CT1_BLOQ') <> '2'
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Conta de débito' + substr(_cLinha,26,20) + iif(empty(CT1->CT1_BLOQ),'inexistente','bloqueada') + ' - Filial + data + lote: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
					FT_FSkip()
					IncProc()
					_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))

					_cFilAnt := substr(_cLinha,5,2)
					If !SM0->(DbSeek('01' + _cFilAnt,.f.))
						++_nErroArq
						_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
						FT_FSkip()
						++_nlinha
						exit
					EndIf                    

					++_nlinha
					loop
				EndIf
	
				If !empty(substr(_cLinha,47,20)) .and. Posicione('CT1',1,xFilial('CT1') + substr(_cLinha,47,20),'CT1_BLOQ') <> '2'
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Conta de crédito' + substr(_cLinha,47,20) + iif(empty(CT1->CT1_BLOQ),'inexistente','bloqueada') + ' - Filial + data + lote: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
					FT_FSkip()
					IncProc()
					_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))

					_cFilAnt := substr(_cLinha,5,2)
					If !SM0->(DbSeek('01' + _cFilAnt,.f.))
						++_nErroArq
						_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
						FT_FSkip()
						++_nlinha
						exit
					EndIf                    

					++_nlinha
					loop
				EndIf
	
				If !empty(substr(_cLinha,125,9)) .and. Posicione('CTT',1,xFilial('CTT') + substr(_cLinha,125,9),'CTT_BLOQ') <> '2'
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Centro Custo de débito ' + substr(_cLinha,125,9) + iif(empty(CTT->CTT_BLOQ),'inexistente','bloqueado') + ' - Filial + data + lote: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
					FT_FSkip()
					IncProc()
					_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))

					_cFilAnt := substr(_cLinha,5,2)
					If !SM0->(DbSeek('01' + _cFilAnt,.f.))
						++_nErroArq
						_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
						FT_FSkip()
						++_nlinha
						exit
					EndIf                    

					++_nlinha
					loop
				EndIf
	
				If !empty(substr(_cLinha,135,9)) .and. Posicione('CTT',1,xFilial('CTT') + substr(_cLinha,135,9),'CTT_BLOQ') <> '2'
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Centro Custo de crédito ' + substr(_cLinha,135,9) + iif(empty(CTT->CTT_BLOQ),'inexistente','bloqueado') + ' - Filial + data + lote: ' + _cFilAnt + ' / ' + dtoc(stod(_cData)) + ' / ' + _cLote + ' - ' + _cEnter
					FT_FSkip()
					IncProc()
					_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))

					_cFilAnt := substr(_cLinha,5,2)
					If !SM0->(DbSeek('01' + _cFilAnt,.f.))
						++_nErroArq
						_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
						FT_FSkip()
						++_nlinha
						exit
					EndIf                    

					++_nlinha
					loop
				EndIf
	
				IncProc()
				_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))
				_cFilAnt := substr(_cLinha,5,2)

				dbselectarea("CT2")
				_cData := dtos(ctod(tran(substr(_cLinha,8,8),'@R 99/99/9999')))
				RecLock("CT2",.t.)
				CT2->CT2_FILIAL  := _cFilAnt
				CT2->CT2_DATA    := stod(_cData)
				CT2->CT2_LOTE    := _cLote
				CT2->CT2_SBLOTE  := '001'
				CT2->CT2_DOC     := _cdoc
				CT2->CT2_LINHA   := strzero(++_nLinDoc,3)
				CT2->CT2_MOEDLC  := '01"
				CT2->CT2_DC      := iif(empty(substr(_cLinha,26,20)),'2',iif(empty(substr(_cLinha,47,20)),'1','3'))
				CT2->CT2_DEBITO  := substr(_cLinha,26,20)
				CT2->CT2_CREDIT  := substr(_cLinha,47,20)
				CT2->CT2_VALOR   := val(substr(_cLinha,68,15))/100
				CT2->CT2_HIST    := substr(_cLinha,84,40)
				CT2->CT2_CCD     := substr(_cLinha,125,9)
				CT2->CT2_CCC     := substr(_cLinha,135,9)
				CT2->CT2_ITEMD   := substr(_cLinha,145,9)
				CT2->CT2_ITEMC   := substr(_cLinha,155,9)
				CT2->CT2_AT01DB  := substr(_cLinha,165,20)
				CT2->CT2_AT01CR  := substr(_cLinha,186,20)
				CT2->CT2_ATIVDE  := substr(_cLinha,216,40)
				CT2->CT2_ATIVCR  := substr(_cLinha,257,40)
				CT2->CT2_DTVENC  := ctod(tran(substr(_cLinha,207,8),'@R 99/99/9999'))
				CT2->CT2_EMPORI  := '01'
				CT2->CT2_FILORI  := _cFilAnt
				CT2->CT2_TPSALD  := '1'
				CT2->CT2_SEQUEN  := Soma1(_cSequen)
				CT2->CT2_MANUAL  := '2'
				CT2->CT2_ORIGEM  := 'CTBTXT - ' + upper(U_ClearAcento(_cArqOpen,'S')) + ' - Linha: ' + str(_nLinha,5)
				CT2->CT2_ROTINA  := 'LS_CTBTXT'
				CT2->CT2_AGLUT   := '1'
				CT2->CT2_LP      := 'TXT'
				CT2->CT2_SEQHIS  := '001'
				CT2->CT2_SEQLAN  := '001'
				CT2->CT2_CRCONV  := '1'
				CT2->CT2_DTCV3   := DDATABASE
				MsUnLock()
				             
				If _nLinDoc == 999
					_cDoc := Soma1(_cDoc)
					_nLinDoc := 0
				EndIf
				FT_FSkip()

				_cFilAnt := substr(_cLinha,5,2)
				If !SM0->(DbSeek('01' + _cFilAnt,.f.))
					++_nErroArq
					_cErros += 'Linha ' + alltrim(str(_nLinha)) + ' não importada - Filial não encontrada: ' + _cFilAnt + _cEnter
					FT_FSkip()
					++_nlinha
					exit
				EndIf                    

				++_nlinha
			
			EndDo

		EndDo
		
	EndDo
	
	FT_FUSE()                 
	
	_cErros += _cEnter + 'Arquivo importado com ' + alltrim(str(_nErroArq)) + ' erro(s).' + _cEnter

	_cDestino := '\system\Integracao\ctbtxt\import\' + _aArquivos[_nI,1]
	copy file &_cArqOpen to &_cDestino
	fErase(_cArqOpen)
		
Next

_cErros += _cEnter + 'Total de erros na importação de ' + alltrim(str(_nI-1)) + 'arquivo(s): ' + alltrim(str(_nErros)) + _cEnter

Aviso('Contabilização TXT - Laselva',_cErros,{'OK'},3,'Verificar ocorrência de contabilização')

return nil
  
/*
NF-e
http://youtu.be/8aWso6a4nn4

CT-e
http://youtu.be/H2y3727yQbQ