#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE ENTER CHR(13)+CHR(10)

// Programa.: 
// Autor....: Alexandre Dalpiaz
// Data.....: 15/08/10
// Descrição: de conciliação do extrato bancário do banco do brasil na guanabara
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function GuanConc()
////////////////////////

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
aAdd(_aEstruBB,{"OK"      , "C" , 02 , 0})

If !file('GUANABARA.DTC')
	DbCreate('guanabara',_aEstruBB)
	DbUseArea(.t.,, 'guanabara','TMP',.t.,.f.)
	Index on dtos(DTMOV) + AGORIG + IDENTIF to guanabara
	Processa({|| geraTmp()})
Else
 	DbUseArea(.t.,, 'guanabara','TMP',.t.,.f.)
	OrdListAdd('guanabara.cdx')
EndIf
//Set Filter To CODMOV = '830'
DbGoTop()

_cArqQry := CriaTrab(,.f.)

_cQuery := "SELECT PAT_FILIAL, PAT_DTFECH, SUM(PAT_VLRSIS) AS VALOR, SUM(PAT_VLRDIG) AS VALORDIG, PAT_TURNO, PAT_FORMA, PAT_BANCO,"
_cQuery += _cEnter + " PAT_AGENCI, PAT_CONTA, PAT_NUMCFI, PAT_OPERAD, PAT_PDV, PAT_FORMA, R_E_C_N_O_, '  ' OK"
_cQuery += _cEnter + " FROM PAT010 PAT "
_cQuery += _cEnter + " WHERE PAT_FORMA = 'R$' AND "
_cQuery += _cEnter + " PAT.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAT_STATUS <> 'S' "
_cQuery += _cEnter + " AND PAT_DTFECH > '20100101'"
_cQuery += _cEnter + " and PAT_VLRSIS + PAT_VLRDIG > 0"
_cQuery += _cEnter + " and PAT_BANCO = '001'"
_cQuery += _cEnter + " AND PAT_CONTA = '5001560'"

_cQuery += _cEnter + " and PAT_FILIAL in ('G1','G2','G3','G4','G5','GA','GB','GD','GE','GF','GG')
//_cQuery += _cEnter + " and PAT_FILIAL in ('GF')
//_cQuery += _cEnter + " AND PAT_DTFECH = '20100111'"

_cQuery += _cEnter + " GROUP BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI, PAT_OPERAD, PAT_PDV, PAT_FORMA, R_E_C_N_O_"
_cQuery += _cEnter + " ORDER BY PAT_FILIAL, R_E_C_N_O_, PAT_DTFECH, PAT_TURNO"

u_GravaQuery("GUANCON.SQL",_cQuery)
MsAguarde({|| GeraQry()},'Selecionando movimentos PDV')

Processa({|| RunProc()})

DbCloseArea()
TMP->(DbCloseArea())

//ferase('guanabara.dtc')
//ferase('guanabara.cdx')
ferase(_cArqQry + '.dtc')
return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

_aAg := {}
aAdd(_aAg,{'G5','2862'})
aAdd(_aAg,{'G4','2862'})
aAdd(_aAg,{'G3','2862'})
aAdd(_aAg,{'G1','2862'})
aAdd(_aAg,{'G2','2862'})
aAdd(_aAg,{'GC','3594'})
aAdd(_aAg,{'GB','3594'})
aAdd(_aAg,{'GD','3594'})
aAdd(_aAg,{'GA','4811'})
aAdd(_aAg,{'GE','4830'})
aAdd(_aAg,{'GF','4830'})
aAdd(_aAg,{'GG','4422'})
                     
_aArredonda := {'G1','G2','G3','G4','G5','GA','GB','GC','GD','GE','GF','GG'}
/*
_aAg := {}
aAdd(_aAg,{'02','2862'})
aAdd(_aAg,{'03','2862'})
aAdd(_aAg,{'04','2862'})
aAdd(_aAg,{'05','2862'})
aAdd(_aAg,{'06','2862'})
aAdd(_aAg,{'07','3594'})
aAdd(_aAg,{'08','3594'})
aAdd(_aAg,{'09','3594'})
aAdd(_aAg,{'10','4811'})
aAdd(_aAg,{'11','4830'})
aAdd(_aAg,{'12','4830'})
aAdd(_aAg,{'13','4422'})
                     
_aArredonda := {'02','03','04','05','06','07','08','09','10','11','12'}
*/
ProcRegua(LastRec())
DbGoTop()
Do while !eof()
	_cAgencia  := _aAg[aScan(_aAg, {|X| X[1] == QRY->PAT_FILIAL}),2]
	_cChave    := QRY->PAT_FILIAL + QRY->PAT_DTFECH
	_nValor    := 0
	_nValorDig := 0
	_aQryRecno    := {}
	Do while !eof() .and. _cChave == QRY->PAT_FILIAL + QRY->PAT_DTFECH .and. empty(QRY->OK)
		IncProc()
		DbSelectArea('TMP')
		DbSeek(dtos(DataValida(stod(QRY->PAT_DTFECH)+1)) + _cAgencia,.f.)
		_lAchou := .f.
		Do While !eof() .and. dtos(DataValida(stod(QRY->PAT_DTFECH)+1)) + _cAgencia == dtos(TMP->DTMOV) + TMP->AGORIG
			If (TMP->VALOR == QRY->VALORDIG .or. (abs(TMP->VALOR - QRY->VALORDIG) < 1 .and. aScan(_aArredonda, QRY->PAT_FILIAL) > 0)) .and. empty(QRY->OK)
				_lAchou := .t.                                                         
				_lArredonda := (abs(TMP->VALOR - QRY->VALORDIG) < 1 .and. aScan(_aArredonda, QRY->PAT_FILIAL) > 0)
 				GravaSE5(QRY->VALOR, QRY->VALORDIG,	{{QRY->R_E_C_N_O_,QRY->(Recno())}})
			EndIf
			DbSelectArea('TMP')
			DbSkip()
		EndDo
		
		If !_lAchou
			aAdd(_aQryRecno,{QRY->R_E_C_N_O_,QRY->(Recno())})
			_nValorDig += QRY->VALORDIG
			_nValor    += QRY->VALOR
		EndIf
		
		DbSelectArea('QRY')
		DbSkip()
		
	EndDo
	DbSkip(-1)
	
	If len(_aQryRecno) > 0	
		DbSelectArea('TMP')
		DbSeek(dtos(DataValida(stod(QRY->PAT_DTFECH)+1)) + _cAgencia,.f.)
		Do While !eof() .and. dtos(DataValida(stod(QRY->PAT_DTFECH)+1)) + _cAgencia == dtos(TMP->DTMOV) + TMP->AGORIG
			If TMP->VALOR == _nValorDig .or. (abs(TMP->VALOR - _nValorDig) < 1 .and. aScan(_aArredonda, QRY->PAT_FILIAL) > 0)
				_lArredonda := (abs(TMP->VALOR - _nValorDig) < 1 .and. aScan(_aArredonda, QRY->PAT_FILIAL) > 0)
				GravaSE5(_nValor, _nValorDig,_aQryRecno,{TMP->(Recno())})
			EndIf
			DbSelectArea('TMP')
			DbSkip()
		EndDo
	EndIf
			
	DbSelectArea('QRY')
	DbSkip()           
	
EndDo

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraTmp()
/////////////////////////

_nHdl := fOpen('c:\protheus8\guanabara\ano2010.txt')
If _nHdl > 0
	
	_nTamArq := fSeek(_nHdl,0,2)
	fSeek(_nHdl,0,0)
	_nLidos := 0
	ProcRegua(_nTamArq/158)
	Do While _nLidos <= _nTamArq
		IncProc()
		_xBuffer := Space(158)
		fRead(_nHdl,@_xBuffer,158)
		If substr(_xBuffer,69,3) <> '830'
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
		_nLidos+=158
		
	EndDo
	
Endif

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaSE5(_xValor, _xValorDig,_xRecno)
/////////////////////////////////////////////////////////////

Begin Transaction

If iif(_lArredonda,TMP->VALOR,_xValorDig) <> _xValor
	RecLock('SE5',.t.)
	SE5->E5_FILIAL  := 'G0'  //QRY->PAT_FILIAL
	SE5->E5_DATA    := TMP->DTMOV
	SE5->E5_NATUREZ := iif(iif(_lArredonda,TMP->VALOR,_xValorDig) > _xValor,'SOBRACX','QUEBRACX')
	SE5->E5_TIPO    := '' //'PDV'
	SE5->E5_BANCO   := QRY->PAT_BANCO
	SE5->E5_AGENCIA := QRY->PAT_AGENCI
	SE5->E5_CONTA   := QRY->PAT_CONTA
	SE5->E5_DOCUMEN := QRY->PAT_FILIAL + DTOS(TMP->DTMOV) + QRY->PAT_TURNO
	SE5->E5_VENCTO  := TMP->DTMOV
	SE5->E5_RECPAG  := 'R'
	SE5->E5_BENEF   := Alltrim(GetAdvFVal("SM0","M0_NOME",'01' + QRY->PAT_FILIAL + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",'01' + QRY->PAT_FILIAL + QRY->PAT_FILIAL,1))
	SE5->E5_SERREC  := QRY->PAT_NUMCFI
	SE5->E5_ARQCNAB := 'GUAN ARRED'
	If iif(_lArredonda,TMP->VALOR,_xValorDig) > _xValor
		SE5->E5_HISTOR 	:= "SOBRA EM REAIS - " + DTOC(TMP->DTMOV) + " PER.: " + QRY->PAT_TURNO
		SE5->E5_TIPODOC := 'JR'
		SE5->E5_DEBITO 	:= '55511004'
		SE5->E5_VALOR   := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
	Else
		SE5->E5_HISTOR 	:= "FALTA EM REAIS (Q.C.) - " + DTOC(TMP->DTMOV) + " PER.: " + QRY->PAT_TURNO
		SE5->E5_TIPODOC := 'DC'
		SE5->E5_DEBITO 	:= '43011009'
		SE5->E5_VALOR   := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
	EndIf
	SE5->E5_LA      := 'N'
	SE5->E5_DTDIGIT := TMP->DTMOV
	SE5->E5_MOTBX   := 'NOR'
	SE5->E5_SEQ     := '01'
	SE5->E5_DTDISPO := TMP->DTMOV
	SE5->E5_FILORIG := QRY->PAT_FILIAL
	SE5->E5_MODSPB  := '4'
	SE5->E5_USERLGI := Embaralha(cUsername,0)
	MsUnLock()
EndIf

RecLock('SE5',.t.)
SE5->E5_FILIAL  := 'G0'		//QRY->PAT_FILIAL
SE5->E5_DATA    := TMP->DTMOV
SE5->E5_NATUREZ := 'DEPOSITO'
SE5->E5_TIPO    := ''  //'PDV'
SE5->E5_VALOR   := iif(_lArredonda,TMP->VALOR,max(_xValorDig,_xValor))
SE5->E5_BANCO   := QRY->PAT_BANCO
SE5->E5_AGENCIA := QRY->PAT_AGENCI
SE5->E5_CONTA   := QRY->PAT_CONTA
SE5->E5_DOCUMEN := QRY->PAT_FILIAL + DTOS(TMP->DTMOV) + QRY->PAT_TURNO
SE5->E5_VENCTO  := TMP->DTMOV
SE5->E5_RECPAG  := 'R'
SE5->E5_BENEF   := Alltrim(GetAdvFVal("SM0","M0_NOME",'01' + QRY->PAT_FILIAL + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",'01' + QRY->PAT_FILIAL + QRY->PAT_FILIAL,1))
SE5->E5_SERREC  := QRY->PAT_NUMCFI
SE5->E5_HISTOR 	:= "MOVTO EM REAIS - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
SE5->E5_TIPODOC := 'VL'
SE5->E5_LA      := 'N'
SE5->E5_DTDIGIT := TMP->DTMOV
SE5->E5_MOTBX   := 'NOR'
SE5->E5_SEQ     := '01'
SE5->E5_DTDISPO := TMP->DTMOV
SE5->E5_FILORIG := QRY->PAT_FILIAL
SE5->E5_SITCOB  := '4'
SE5->E5_USERLGI := Embaralha(cUsername,0)         
SE5->E5_ARQCNAB := 'GUAN ARRED'
If iif(_lArredonda,TMP->VALOR,_xValorDig) > _xValor
	SE5->E5_VLJUROS := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
	SE5->E5_VLACRES := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
Else
	SE5->E5_VLDESCO := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
	SE5->E5_VLDECRE := abs(iif(_lArredonda,TMP->VALOR,_xValorDig) - _xValor)
EndIf
MsUnLock()

DbSelectArea('PAT')
For _nI := 1 to len(_xRecno)
	DbGoTo(_xRecno[_nI,1])
	RecLock('PAT',.f.)
	PAT->PAT_STATUS := 'S'
	PAT->PAT_USERGI := upper(PAT->PAT_USERGI)
	MsUnLock()
Next

DbSelectArea('QRY')
_nRecno := Recno()
For _nI := 1 to len(_xRecno)
	DbGoTo(_xRecno[_nI,2])
	RecLock('QRY',.f.)
	QRY->OK := 'AR'
	MsUnLock()
Next
DbGoTo(_nRecno)

End Transaction
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraQry()
/////////////////////////

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "QRY", .F., .T.)
copy to &_cArqQry
DbCloseArea()
DbUseArea(.T., , _cArqQry, "QRY", .t., .f.)
DbGoTop()
Return()
