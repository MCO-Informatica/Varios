#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE ENTER CHR(13)+CHR(10)

// Programa.: LA_CONCEX
// Autor....: Alexandre Dalpiaz
// Data.....: 13/07/10
// Descrição: WF de conciliação do extrato bancário do banco do brasil
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_CONCEX()
///////////////////////

_cPerg         := left("CONCEX    ",len(SX1->X1_GRUPO))
ValidPerg()
Pergunte(_cPerg, .f.)

Define MsDialog _oDlgMenu TITLE "Conciliação de extrato bancário" FROM 1, 1 to 200, 420 OF oMainWnd Pixel
@ 02,10 TO 077,200	 Pixel OF _oDlgMenu

@ 10,018 Say " Este programa gerará títulos a receber " 	Pixel OF _oDlgMenu
@ 18,018 Say " a partir do movimento dos PDVs da filial" 	Pixel OF _oDlgMenu
@ 26,018 Say " atual, para posterior conciliação" 			Pixel OF _oDlgMenu

@ 080, 060 button 'Parâmetros' 	size 40,15 action pergunte (_cPerg,.t.) OF _oDlgMenu Pixel
@ 080, 110 button 'OK' 			size 40,15 action (Processa ({|lEnd| U_LACONCEX(.f.)}, "Processando..."),_oDlgMenu:End()) OF _oDlgMenu Pixel
@ 080, 160 button 'Fechar' 		size 40,15 action _oDlgMenu:End() OF _oDlgMenu Pixel

ACTIVATE MSDIALOG _oDlgMenu CENTERED

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
lay-out
---------------------------------
001-005 05 agencia
006-019 12 conta
022-029 08 data
031-038 08 data
040-043 04
045-049 05
051-067 17 identificacao
069-071 03 codigo movimento
073-097 25 descricao movimento
099-115 17 valor
117-117 01 debito/credito
119-155 37 historico

eventos
---------------------------------
000;SALDO ANTERIOR           
002;CHEQUE                   
055;PAGTOS DIV AUTORIZADOS   
103;CHEQUE PAGO OUTRA AGENCIA
109;PAGAMENTO DE TíTULO      
114;DEVOLUC CHEQUE DEPOSITADO
170;TAR ASSINATURA SERV MALOT
170;TAR PROC SERVICO MALOTE  
242;DEBITO PRESTACAO LEASING 
263;TAR EXTRATO MEIO MAGNET  
263;TARIFA DE EXTRATO POSTADO
280;ESTORNO DE CREDITO       
310;TAR DOC/TED ELETRONICO   
375;IMPOSTOS                 
393;TED TRANSF.ELETR.DISPONIV
435;TARIFA PACOTE DE SERVICOS
438;TED                      
470;TRANSFERENCIA ON LINE    
500;TARIFA RENOVACAO CADASTRO
580;ESTORNO AUTENT PAGAMENTO 
612;RECEBIMENTO FORNECEDOR   
623;DOC CREDITO EM CONTA     
623;DOC-PAG DE DIVIDENDOS    
631;DESBLOQUEIO DE DEPOSITO  
729;TRANSFERENCIA            
830;DEPOSITO ONLINE          
870;TRANSFERENCIA ON LINE    
910;DEP CHEQUE BB LIQUIDADO  
911;DEPOSITO BLOQUEAD.1D UTIL
912;DEPOSITO BLOQ.2DIAS UTEIS
913;DEPOSITO BLOQ.3DIAS UTEIS
914;DEPOSIT.BLOQ.4 DIAS UTEIS
999;S A L D O                

*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LACONCEX(_lJob)
///////////////////////
_cEnter  := chr(13)
_cInicio := left(time(),5)

If _lJob
	mv_par01 := ''
	mv_par02 := ''
	mv_par03 := ''
EndIf
// ARRAY _AARQS - mesma estrutura do array criado pela função DIRECTORY(), utilizada njo WF - usa somente o nome do arquivo
//		nome do arquivo, tamanho, data, blablabla

_aArqs  := {{alltrim(mv_par02),0,ctod(''),'',''}}

// ARRAY _ABANCOS:
//		nome da estrutura
//		tamanho da linha,
//		codigo do banco
//		codigo de depositos identificados
_aBancos := {}
aAdd(_aBancos, {'_aEstruBB',	158, 	'001',	'830'})

_aEstruBB := {}
//aAdd(_aEstruBB,{"BANCO"   , "C" , 03 , 0})
aAdd(_aEstruBB,{"AGENCIA" , "C" , 05 , 0})
aAdd(_aEstruBB,{"CONTA"   , "C" , 12 , 0})
aAdd(_aEstruBB,{"BRANCO"  , "C" , 01 , 0})
aAdd(_aEstruBB,{"DTMOV"   , "D" , 08 , 0})
aAdd(_aEstruBB,{"DTBAL"   , "D" , 08 , 0})
aAdd(_aEstruBB,{"AGORIG"  , "C" , 04 , 0})
aAdd(_aEstruBB,{"NRLOTE"  , "C" , 05 , 0})
aAdd(_aEstruBB,{"IDENTIF" , "C" , 17 , 0})
aAdd(_aEstruBB,{"CODMOV"  , "C" , 03 , 0})
aAdd(_aEstruBB,{"DESCMOV" , "C" , 25 , 0})
aAdd(_aEstruBB,{"VALOR"   , "N" , 17 , 2})
aAdd(_aEstruBB,{"DC"      , "C" , 01 , 0})
aAdd(_aEstruBB,{"HISTOR"  , "C" , 35 , 0})

// ARRAY _APATHS
//		caminho
//		array da estrutura do banco
//		tamanho da linha do arquivo
_aPaths := {{alltrim(mv_par01), aClone(&(_aBancos[mv_par03,1])), _aBancos[mv_par03,2]}}
_aBaixas := {}
_aErros  := {}
_aValDif := {}
_aJaBaix := {}

If _lJob
	
	_aPaths := {}
	aAdd(_aPaths,{'\extratos\bancodobrasil\', _aEstruBB,158})
	WfPrepEnv( '01','01')
	ChkFile("SM0")
	
	mv_par01 := dDataBase - 10
	mv_par02 := dDataBase
	
EndIf
_aArqProc := {}
For _nPath := 1 to len(_aPaths)
	
	If _lJob .or. empty(mv_par02)
		_aArqs := Directory(_aPaths[_nPath,1] + '*.*')
	EndIf
	
	If empty(_aArqs)
		If _lJob
			Conout('Não há arquivos para processar em ' + _aPaths[_nPath,1] )
		Else
			MsgAlert('Não há arquivos para processar em ' + _aPaths[_nPath,1] )
		EndIf
		aAdd(_aArqProc,'Não há arquivos para processar em ' + _aPaths[_nPath,1] )
	EndIf
	
	For _nArq := 1 to len(_aArqs)
		
		_cPath     := _aPaths[_nPath,1]
		_aEstru    := _aPaths[_nPath,2]
		_nTamLinha := _aPaths[_nPath,3]
		_cArqTmp   := CriaTrab(_aEstru,.t.)
		
		
		DbUseArea(.t.,, _cArqTmp,'TMP',.t.,.f.)
		Index on dtos(DTMOV) + IDENTIF + CODMOV to &_cArqTmp
		
		If !_lJob
			_cArq := _aArqs[_nArq,1]
		EndIf
		aAdd(_aArqProc,_cPath +  _cArq)
		
		_nHdl := fOpen(_cPath + _cArq)
		If _nHdl > 0
			
			_nTamArq := fSeek(_nHdl,0,2)
			fSeek(_nHdl,0,0)
			_nLidos := 0
			
			Do While _nLidos <= _nTamArq
				
				_xBuffer := Space(_nTamLinha)
				fRead(_nHdl,@_xBuffer,_nTamLinha)
				If !(substr(_xBuffer,69,3) $ '830/280')
					_nLidos+=158
					loop
				EndIf
				RecLock('TMP',.t.)
				
				For _nI := 1 to fCount()
					
					_nPosic  := at(';',_xBuffer)
					_nPosic  := iif(_nPosic == 0, len(_xBuffer)+1, _nPosic)
					_xCampo  := left(_xBuffer,_nPosic-1)
					_xBuffer := substr(_xBuffer,_nPosic+1)
					_xTipo   := ValType(FieldGet(_nI))
					
					If _xTipo == 'D'
						_xCampo := ctod(tran(_xCampo,'@R 99/99/9999'))
					ElseIf _xTipo == 'N'
						_xCampo := val(_xCampo)/100
					EndIf
					
					FieldPut(_nI,_xCampo)
					
				Next
				
				MsUnLock()
				_nLidos+=_nTamLinha
				
			EndDo
			
		Endif
		
		DbGoTop()
		
		If !_lJob
			ProcRegua(LastRec())
		EndIf
		
		Do While !eof()
			                           
			If TMP->CODMOV ==  '280' //ESTORNO
				_cEstorno := TMP->IDENTIF
				_nEstorno := TMP->VALOR
				DbSkip()
				If _cEstorno == TMP->IDENTIF .and. _nEstorno == TMP->VALOR .and. TMP->CODMOV = '830'
					DbSkip()
				EndIf
				loop
			EndIf
			
			If TMP->CODMOV <>  '830' //_aBancos[_nPath, 4]
				DbSkip()
				loop
			EndIf
			
			DbSelectArea('SE1')
			
			// Título					Loja						Nat	Vencimento	Vencimento 	   Valor	Forma Pagamento
			// Z27 / 100711016 - 009	000001 / 27 - FOR SAGUAO 	27	11/07/10	12/07/10	3.729,52	MOEDA CORRENTE
			// Z27 / 100711016 - 011	000001 / 27 - FOR SAGUAO 	27	11/07/10	12/07/10	4.630,29	MOEDA CORRENTE
			// tmp->identif = 00000027011110710
			//                12345678901234569
			
			_cPrefixo := 'Z' + Posicione('SZJ',1, xFilial('SZJ') + substr(TMP->IDENTIF,6,3),'ZJ_CODFIL')			// prefixo (Z + loja)
			_cTitulo  := right(TMP->IDENTIF,2) + substr(TMP->IDENTIF,14,2) + substr(TMP->IDENTIF,12,2) + '016'		// titulo  (ano + mes + dia +  016 = dinheiro)
			_cParcela := substr(TMP->IDENTIF,9,3) 																	// parcela (nro do PDV)
 			_cTipo	  := 'PDV'																						// tipo
			
			If DbSeek(xFilial('SE1') + _cPrefixo + _cTitulo + _cParcela + _cTipo,.f.)
				
				If SE1->E1_SALDO == SE1->E1_VALOR
					
					//If abs(TMP->VALOR - SE1->E1_VALOR) <= SE1->E1_VALOR * GetMv('LA_PDVPDIF') /100
					If TMP->VALOR <> SE1->E1_VALOR
					
						If TMP->VALOR < SE1->E1_VALOR
							RecLock('SE1',.f.)
							SE1->E1_DECRESC := SE1->E1_VALOR - TMP->VALOR 
							SE1->E1_SDDECRE := SE1->E1_VALOR - TMP->VALOR 
							SE1->E1_SALDO   := TMP->VALOR 
							MsUnLock()
						ElseIf TMP->VALOR > SE1->E1_VALOR
							RecLock('SE1',.f.)
							SE1->E1_ACRESC  := TMP->VALOR - SE1->E1_VALOR
							SE1->E1_SDACRES := TMP->VALOR - SE1->E1_VALOR
							SE1->E1_SALDO   := TMP->VALOR
							MsUnLock()
						EndIf
					
					EndIf
						
						lMsErroAuto := .f.
						_aAutoSE1   := {}
						_cConta     := TMP->CONTA
						Do While left(_cConta,1) == '0'
							_cConta := substr(_cConta,2) + ' '
						EndDo
						/*
						aAdd(_aAutoSE1, {"E1_FILIAL"  , xFilial('SE1')          , Nil})
						aAdd(_aAutoSE1, {"E1_PREFIXO" , _cPrefixo               , Nil})
						aAdd(_aAutoSE1, {"E1_NUM"     , _cTitulo                , Nil})
						aAdd(_aAutoSE1, {"E1_PARCELA" , _cParcela               , Nil})
						aAdd(_aAutoSE1, {"E1_TIPO"    , _cTipo                  , Nil})
						
						aAdd(_aAutoSE1, {"AUTDTBAIXA"   , TMP->DTMOV          	, Nil})
						aAdd(_aAutoSE1, {"AUTDTCREDITO" , TMP->DTMOV          	, Nil})
						aAdd(_aAutoSE1, {"AUTJUROS"     , 0                  	, Nil})
						aAdd(_aAutoSE1, {"AUTMULTA"     , 0                  	, Nil})
						aAdd(_aAutoSE1, {"AUTHIST"    	, 'Baixa Automatica' 	, Nil})
						aAdd(_aAutoSE1, {"AUTMOTBX"   	, "NOR"    				, Nil})
						aAdd(_aAutoSE1, {"AUTVALREC"  	, TMP->VALOR		 	, Nil})
						aAdd(_aAutoSE1, {"AUTBANCO"   	, _aBancos[_nPath, 3]	, Nil})
						aAdd(_aAutoSE1, {"AUTAGENCIA" 	, TMP->AGENCIA 			, Nil})
						aAdd(_aAutoSE1, {"AUTCONTA"   	, _cConta   			, Nil})
						
						MSExecAuto({|x,y| fina070(x,y)}, _aAutoSE1, 3) // baixa de titulos
						
						/*/
						
						Begin Transaction
						
						RecLock('SE1',.f.)
						SE1->E1_VALLIQ  := TMP->VALOR
						SE1->E1_SALDO   -= TMP->VALOR
						SE1->E1_BAIXA   := TMP->DTMOV
						SE1->E1_MOVIMEN := TMP->DTMOV
						SE1->E1_STATUS  := 'B'
						SE1->E1_SDDECRE := 0
						SE1->E1_SDACRES := 0
						SE1->E1_USERLGA := Embaralha(cUsername,0)
						SE1->E1_HIST    := 'Movto R$ ' + dtoc(TMP->DTMOV) + ' - ' + SE1->E1_MSFIL + ' / ' + alltrim(SE1->E1_NOMCLI) + ' (PDV)'
						MsUnLock()
						                       
						If SE1->E1_ACRESC > 0 .or. SE1->E1_DECRESC > 0
							RecLock('SE5',.t.)
							SE5->E5_FILIAL  := xFilial('SE5')
							SE5->E5_DATA    := TMP->DTMOV
							SE5->E5_NATUREZ := iif(SE1->E1_ACRESC > 0,'SOBRACX','QUEBRACX')   //SE1->E1_NATUREZ
							SE5->E5_TIPO    := 'PDV'
							SE5->E5_BANCO   := _aBancos[_nPath, 3]
							SE5->E5_AGENCIA := TMP->AGENCIA
							SE5->E5_CONTA   := _cConta
							SE5->E5_RECPAG  := 'R'
							SE5->E5_BENEF   := SE1->E1_NOMCLI
							If SE1->E1_ACRESC  > 0 
								SE5->E5_HISTOR  := 'Movto R$ (ACRESCIMO) ' + dtoc(TMP->DTMOV) + ' - ' + SE1->E1_MSFIL + ' / ' + alltrim(SE1->E1_NOMCLI) + ' (PDV)'
								SE5->E5_TIPODOC := 'JR'
								SE5->E5_VALOR   := SE1->E1_ACRESC
								SE5->E5_VLMOED2 := SE1->E1_ACRESC
							ElseIf SE1->E1_DECRESC  > 0 
								SE5->E5_HISTOR  := 'Movto R$ (DECRESCIMO) ' + dtoc(TMP->DTMOV) + ' - ' + SE1->E1_MSFIL + ' / ' + alltrim(SE1->E1_NOMCLI) + ' (PDV)'
								SE5->E5_TIPODOC := 'DC'
								SE5->E5_VALOR   := SE1->E1_DECRESC
								SE5->E5_VLMOED2 := SE1->E1_DECRESC
							EndIf
							SE5->E5_LA      := 'N'
							SE5->E5_PREFIXO := _cPrefixo
							SE5->E5_NUMERO  := _cTitulo
							SE5->E5_PARCELA := _cParcela
							SE5->E5_CLIFOR  := SE1->E1_CLIENTE
							SE5->E5_LOJA    := SE1->E1_LOJA
							SE5->E5_DTDIGIT := TMP->DTMOV
							SE5->E5_MOTBX   := 'NOR'
							SE5->E5_SEQ     := '01'
							SE5->E5_DTDISPO := TMP->DTMOV
							SE5->E5_FILORIG := SE1->E1_LOJA
							SE5->E5_SITCOB  := '0'
							SE5->E5_CLIENTE := SE1->E1_CLIENTE
							SE5->E5_USERLGI := Embaralha(cUsername,0)
						MsUnLock()
						EndIf

						RecLock('SE5',.t.)
						SE5->E5_FILIAL  := xFilial('SE5')
						SE5->E5_DATA    := TMP->DTMOV
						SE5->E5_NATUREZ := 'DEPOSITO'		//SE1->E1_NATUREZ
						SE5->E5_TIPO    := 'PDV'
						SE5->E5_VALOR   := TMP->VALOR
						SE5->E5_BANCO   := _aBancos[_nPath, 3]
						SE5->E5_AGENCIA := TMP->AGENCIA
						SE5->E5_CONTA   := _cConta
						SE5->E5_RECPAG  := 'R'
						SE5->E5_BENEF   := SE1->E1_NOMCLI
						SE5->E5_HISTOR  := 'Movto R$ ' + dtoc(TMP->DTMOV) + ' - ' + SE1->E1_MSFIL + ' / ' + alltrim(SE1->E1_NOMCLI) + ' (PDV)'
						SE5->E5_TIPODOC := 'VL'
						SE5->E5_VLMOED2 := TMP->VALOR
						SE5->E5_LA      := 'N'
						SE5->E5_PREFIXO := _cPrefixo
						SE5->E5_NUMERO  := _cTitulo
						SE5->E5_PARCELA := _cParcela
						SE5->E5_CLIFOR  := SE1->E1_CLIENTE
						SE5->E5_LOJA    := SE1->E1_LOJA
						SE5->E5_DTDIGIT := TMP->DTMOV
						SE5->E5_MOTBX   := 'NOR'
						SE5->E5_SEQ     := '01'
						SE5->E5_DTDISPO := TMP->DTMOV
						SE5->E5_FILORIG := SE1->E1_LOJA
						SE5->E5_SITCOB  := '0'
						SE5->E5_CLIENTE := SE1->E1_CLIENTE
						SE5->E5_USERLGI := Embaralha(cUsername,0)
						If SE1->E1_ACRESC > 0 
							SE5->E5_VLJUROS := SE1->E1_ACRESC
							SE5->E5_VLACRES := SE1->E1_ACRESC
						ElseIf SE1->E1_DECRESC  > 0 
							SE5->E5_VLDESCO := SE1->E1_DECRESC
							SE5->E5_VLDECRE := SE1->E1_DECRESC
						EndIf
						MsUnLock()
						
						AtuSalBco( SE5->E5_BANCO, SE5->E5_AGENCIA, SE5->E5_CONTA, SE5->E5_DTDISPO, SE5->E5_VALOR, "+" )
						
						End Transaction
						
						_aTexto := {_cPrefixo + ' / ' + _cTitulo + ' - ' +  _cParcela , SE1->E1_CLIENTE + ' / ' + SE1->E1_LOJA + ' - ' + SE1->E1_NOMCLI, SE1->E1_MSFIL , dtoc(SE1->E1_VENCTO) , dtoc(SE1->E1_VENCREA), tran(SE1->E1_VALOR,'@E 999,999,999.99'), tran(SE1->E1_VALLIQ,'@E 999,999,999.99'), tran(SE1->E1_SALDO,'@E 999,999,999.99'), tran(TMP->VALOR,'@E 999,999,999.99')}
						aAdd(_aBaixas, _aTexto)
						
					//Else
					//	_aTexto := {_cPrefixo + ' / ' + _cTitulo + ' - ' +  _cParcela , SE1->E1_CLIENTE + ' / ' + SE1->E1_LOJA + ' - ' + SE1->E1_NOMCLI, SE1->E1_MSFIL , dtoc(SE1->E1_VENCTO) , dtoc(SE1->E1_VENCREA), tran(SE1->E1_VALOR,'@E 999,999,999.99'), tran(SE1->E1_VALLIQ,'@E 999,999,999.99'), tran(SE1->E1_SALDO,'@E 999,999,999.99'), tran(TMP->VALOR,'@E 999,999,999.99')}
					//	aAdd(_aValDif, _aTexto)
					//EndIf
					
				Else
					_aTexto := {_cPrefixo + ' / ' + _cTitulo + ' - ' +  _cParcela , SE1->E1_CLIENTE + ' / ' + SE1->E1_LOJA + ' - ' + SE1->E1_NOMCLI, SE1->E1_MSFIL , dtoc(SE1->E1_VENCTO) , dtoc(SE1->E1_VENCREA), tran(SE1->E1_VALOR,'@E 999,999,999.99'), tran(SE1->E1_VALLIQ,'@E 999,999,999.99'), tran(SE1->E1_SALDO,'@E 999,999,999.99'), tran(TMP->VALOR,'@E 999,999,999.99')}
					aAdd(_aJaBaix, _aTexto)
				EndIf
				
			Else
				_cLoja := ''
				If DbSeek(xFilial('SE1') + _cPrefixo + _cTitulo,.f.)
					_cLoja := SE1->E1_CLIENTE + ' / ' + SE1->E1_LOJA + ' - ' + SE1->E1_NOMCLI
				EndIf
				_aTexto := {_cPrefixo + ' / ' + _cTitulo + ' - ' +  _cParcela , TMP->IDENTIF, tran(TMP->VALOR,'@E 999,999,999.99')}
				aAdd(_aErros, _aTexto)
			EndIf
			
			DbSelectArea('TMP')
			DbSkip()
			
		EndDo
		
		DbCloseArea()
		fClose(_nHdl)
		_cOrigem  := _cPath + _cArq
		_cDestino := _cPath + 'processados\' + _cArq
		copy file &_cOrigem to &_cDestino
		fErase(_cOrigem)
		fErase(_cArqTmp + '.DTC')
		fErase(_cArqTmp + '.CDX')
		
	Next
	
Next

_cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_VALOR, E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_VALLIQ, E1_CLIENTE, E1_LOJA, E1_NOMCLI"
_cQuery += _cEnter + "FROM " + RetSqlName('SE1') + " SE1 (NOLOCK)"
_cQuery += _cEnter + "WHERE SE1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND E1_FILIAL = ''"
_cQuery += _cEnter + "AND E1_PREFIXO > 'Z'"
_cQuery += _cEnter + "AND E1_TIPO = 'PDV'"
_cQuery += _cEnter + "AND E1_SALDO > 0"
_cQuery += _cEnter + "ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SE1', .F., .T.)

If !_lJob
	U_GravaQuery('LA_CONCEX.SQL',_cQuery)
EndIf

TcSetField("_SE1","E1_EMISSAO","D",8,0)
TcSetField("_SE1","E1_BAIXA"  ,"D",8,0)

DbgoTop()
_aAbertos := {}
Do While !eof()
	aAdd(_aAbertos, {_SE1->E1_PREFIXO + ' / ' + _SE1->E1_NUM + ' - ' + _SE1->E1_PARCELA, _SE1->E1_CLIENTE + ' / ' + _SE1->E1_LOJA + ' - ' + _SE1->E1_NOMCLI, dtoc(_SE1->E1_EMISSAO), tran(_SE1->E1_VALOR,'@E 999,999,999.99'), dtoc(_SE1->E1_BAIXA), tran(_SE1->E1_SALDO,'@E 999,999,999.99'), tran(E1_VALLIQ,'@E 999,999,999.99')})
	DbSkip()
EndDo

DbCloseArea()

Email()

If _lJob
	Reset Environment
EndIf
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Private _cAlias := Alias ()
Private _aRegs  := {}

//           GRUPO  ORDEM PERGUNT                 PERSPA                  PERENG                  VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01       DEFSPA1     DEFENG1     CNT01 VAR02 DEF02        DEFSPA2      DEFENG2      CNT02 VAR03 DEF03       DEFSPA3     DEFENG3     CNT03 VAR04 DEF04 DEFSPA4 DEFENG4 CNT04 VAR05 DEF05 DEFSPA5 DEFENG5 CNT05 F3     GRPSXG
aAdd(_aRegs,{_cPerg, "01", "Caminho              ","","","mv_ch1", "C",50,  0,  0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "02", "Arquivo              ","","","mv_ch2", "C",50,  0,  0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "03", "Banco                ","","","mv_ch3", "N", 1,  0,  0, "C", "", "mv_par03", "Brasil", "", "", "", "HSBC", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea ("SX1")
DbSetOrder (1)
For _i := 1 to Len (_aRegs)
	RecLock ("SX1", !DbSeek (_cPerg + _aRegs [_i, 2]))
	For _j := 1 to FCount ()
		If _j <= Len (_aRegs [_i]) .and. !(left (fieldname (_j), 6) $ "X1_CNT/X1_PRESEL")
			FieldPut (_j, _aRegs [_i, _j])
		Endif
	Next
	MsUnlock ()
Next
DbSelectArea (_cAlias)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'siga@laselva.com.br'
cAssunto  	:= "Conciliação dos títulos de movimentações dos PDV's"
cRecebe     := GetMv('LA_PDVMAIL')
cRecebe 	:= strtran(cRecebe,';','@laselva.com.br;') + '@laselva.com.br'

_aTabelas := {}
aAdd(_aTabelas, aClone(_aBaixas))
aAdd(_aTabelas, aClone(_aValDif))
aAdd(_aTabelas, aClone(_aJaBaix))
aAdd(_aTabelas, aClone(_aErros))
aAdd(_aTabelas, aClone(_aAbertos))

_aLabel := {}
aAdd(_aLabel, {'Título','Loja','Natureza','Vencimento','Vencimento Real','Valor','Liquidado','Saldo','Valor Extrato'})
aAdd(_aLabel, {'Título','Loja','Natureza','Vencimento','Vencimento Real','Valor','Liquidado','Saldo','Valor Extrato'})
aAdd(_aLabel, {'Título','Loja','Natureza','Vencimento','Vencimento Real','Valor','Liquidado','Saldo','Valor Extrato'})
aAdd(_aLabel, {'Título','Identificação depósito','Valor Extrato'})
aAdd(_aLabel, {'Título','Loja','Emissão','Valor','Baixa','Saldo','Valor Baixado'})

_aWidth := { '90', '90', '90', '50', '90'}

_aSizes := {}
aAdd(_aSizes, {'20','22','5','5','8','10','10','10','10'})
aAdd(_aSizes, {'20','22','5','5','8','10','10','10','10'})
aAdd(_aSizes, {'20','22','5','5','8','10','10','10','10'})
aAdd(_aSizes, {'20','20','10'})
aAdd(_aSizes, {'20','20','10','10','10','10','10'})

_aAlign := {}
aAdd(_aAlign,{'','','','','','RIGHT','RIGHT','RIGHT','RIGHT'})
aAdd(_aAlign,{'','','','','','RIGHT','RIGHT','RIGHT','RIGHT'})
aAdd(_aAlign,{'','','','','','RIGHT','RIGHT','RIGHT','RIGHT'})
aAdd(_aAlign,{'','','RIGHT'})
aAdd(_aAlign,{'','','','RIGHT','','RIGHT','RIGHT'})

_aTitulos := {}
aAdd(_aTitulos,'Títulos baixados com sucesso:')
aAdd(_aTitulos,'Valor depositado diferente dos títulos gerados:')
aAdd(_aTitulos,'Títulos já baixados anteriormente (total ou parcialmente):')
aAdd(_aTitulos,'Depósitos com problemas de identificação:')
aAdd(_aTitulos,'Títulos de PDVs em aberto no sistema:')

_cHtml := '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + ENTER + ENTER

_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">Arquivos Processados:</h3></font>'

For _nI := 1 to len(_aArqProc)
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana">' + upper(_aArqProc[_nI]) + '</font></b>'+ ENTER
Next
_cHtml += ENTER + '<b><font size="3" color="#0000FF" face="Verdana">Data do processamento: ' + dtoc(date()) + '</font></b>'+ ENTER
_cHtml += '<b><font size="3" color="#0000FF" face="Verdana">Início....: ' + _cInicio + '</font></b>'+ ENTER
_cHtml += '<b><font size="3" color="#0000FF" face="Verdana">Término: ' + left(time(),5) + '</font></b>'+ ENTER+ ENTER

_cHtml += '<hr width=100% noshade>' + ENTER + ENTER

For _nJ := 1 to len(_aTabelas)
	
	If len(_aTabelas[_nJ]) > 0
		
		_cHtml += '<b><font size="3" color="#0000FF" face="Verdana">' + _aTitulos[_nJ] + '</font></b>'+ ENTER+ENTER
		
		_cHtml += '<TABLE WIDTH=' + _aWidth[_nJ] + '% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
		_cHtml += '	<TR VALIGN=TOP>                  '
		
		For _nI := 1 To Len(_aSizes[_nJ])
			_cHtml += '		<TD WIDTH=' + _aSizes[_nJ,_nI] + '%>'
			_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nJ,_nI]),'<h3 align = '+ _aAlign[_nJ,_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nJ,_nI] + '<B></P></font> '
			_cHtml += '		</TD>'
		Next
		
		For _nI := 1 To Len(_aTabelas[_nJ])
			
			_cHtml += '	<TR VALIGN=TOP>'
			
			For _nK := 1 to len(_aTabelas[_nJ,_nI])
				_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ,_nK] + '%>'
				_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ,_nK]),'<h3 align = '+ _aAlign[_nJ,_nK] + '>','') + '<font size="1" face="Verdana"><b> ' + _aTabelas[_nJ,_nI,_nK] + '</P></font>'
				_cHtml += '		</TD>'
			Next
		Next
		_cHtml += '	</TR>'
		
		_cHtml += '</TABLE>'
		_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
		
	EndIf
	
Next

_cHtml += '</P>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	
	
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
		If !REC->(eof())
			RecLock('REC',.F.)
			REC->EMAIL := .T.
			MsUnLock()
		EndIf
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
	If !REC->(eof())
		RecLock('REC',.F.)
		REC->EMAIL := .T.
		MsUnLock()
	EndIf
Endif

Return



User Function MVSX1VLD()
Local _lRet := .t.

//alert(paramixb[1])

Return(_lRet)