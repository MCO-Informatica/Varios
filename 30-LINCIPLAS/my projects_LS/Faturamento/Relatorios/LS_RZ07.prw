#INCLUDE "rwmake.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ RODRIGO ALEXANDRE  บ Data ณ  05/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LS_RZ07


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Controle de Jornais"
Local cDesc				:= cDesc1 + chr(13) + chr(10) + cDesc2 + chr(13) + chr(10) + cDesc3
Local cPict         	:= ""
Local titulo	       	:= "Controle de Jornais"
Local nLin      	   	:= 80

Local Cabec1       		:= "Filial           Dia M๊s C๓digo           Descri็ใo                                   Entrada   Qtd_Vda   Encalhe     Perda     Custo Unit  %Encalhe    %Perda       Vlr Unit    Custo Total    Data Acerto"
Local Cabec2       		:= ""
Local imprime      		:= .T.
Local aOrd				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 120
Private tamanho         := "G"
Private nomeprog        := "LS_RZ07" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 15
Private aReturn    		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    	:= 0
Private cPerg       	:= "LS_RZ07"
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "LS_RZ07" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "Z07"

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

DO CASE
	CASE MV_PAR08 == 1
		
		If nLastKey == 27
			Return
		Endif
		
		fErase(__RelDir + wnrel + '.##r')
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Return
		Endif
		
		nTipo := If(aReturn[4]==1,15,18)
		
		
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		Return
		
EndCase

_nHdl := fCreate(__RelDir + 'CtrlJornal.csv')
If _nHdl < 0
	MsgBox('Nใo foi possํvel criar o arquivo ' + __RelDir + 'CtrlJornal.CSV','ATENวรO!!!','ALERT')
	Return()
EndIf

_cCabec1 := ''
_cCabec1 += 'Filial;Dia;M๊s;Codigo;Descri็ใo;Qtd_VD;Vl_Unit;ENTRADA;Encalhe;% Encalhe;Perda;% Perda;Custo Unit;Custo Total;Dt_Acerto' + _cEnter


_cQuery := "SELECT Z07_FILIAL, M0_FILIAL, RIGHT(Z07_DTPUBL,2) DIA, SUBSTRING(Z07_DTPUBL,5,2) MES, "
_cQuery += _cEnter + " 	Z07_CODPRO,	B1_DESC,	Z07_VENDAS,	Z07_PRRCVE,	Z07_QTDENT,	Z07_QTDENC,    "
_cQuery += _cEnter + " 	STR(Z07_QTDENC * 100 / Z07_QTDENT,9,2) PER_ENCALHE,	Z07_PERDAS,	STR(Z07_PERDAS * 100 / Z07_QTDENT,9,2)	PER_PERDAS,"
_cQuery += _cEnter + " 	Z07_PRCCOM,	Z07_DTACTO "
_cQuery += _cEnter + " FROM " + RetSQLName ("Z07") + " Z07 WITH(NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSQLName ("SB1") + " SB1 WITH(NOLOCK)"
_cQuery += _cEnter + " ON B1_COD = Z07_CODPRO "
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " LEFT JOIN sigamat_copia  "
_cQuery += _cEnter + " ON Z07_FILIAL = M0_CODFIL "

_cQuery += _cEnter + " WHERE Z07_DTPUBL BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
_cQuery += _cEnter + " AND Z07_FILIAL = '" + MV_PAR03 + "' "
_cQuery += _cEnter + " AND Z07_CODFOR BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' AND Z07_LOJA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' "
_cQuery += _cEnter + " AND Z07.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " ORDER BY MES, DIA "

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)},'Buscando informa็๕es')

TcSetField('TMP','Z07_DTACTO','D',0)

If eof()
	DbCloseArea()
	fClose(_nHdl)
	MsgBox('Arquivo ' + __RelDir + 'CtrlJornal.CSV sem dados para consulta','ATENวรO!!!','ALERT')
	Return()
EndIf
fWrite(_nHdl,_cCabec1,Len(_cCabec1))

Processa({|| RunProc()})

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

Count to _nLastRec
DbGoTop()
ProcRegua(_nLastRec)
Do While !eof()
	
	IncProc()

	_cLinha    := ''
	_cLinha += TMP->Z07_FILIAL + ' - ' + TMP->M0_FILIAL  + ';' + TMP->DIA + ';' + TMP->MES  + ';' + substr(TMP->Z07_CODPRO,1,15)  + ';' + substr(TMP->B1_DESC,1,40)  + ';' + Trans(TMP->Z07_VENDAS, '@E 999999999')  + ';' + Trans(TMP->Z07_PRRCVE, '@E 999,999,999.99')  + ';' + Trans(TMP->Z07_QTDENT, '@E 999999999')  + ';' + Trans(TMP->Z07_QTDENC, '@E 999999999')  + ';' + TMP->PER_ENCALHE + ';' + Trans(TMP->Z07_PERDAS, '@E 999999999')  + ';' + TMP->PER_PERDAS + ';' + Trans(TMP->Z07_PRCCOM, '@E 999,999,999.99') + ';' + Trans(TMP->(Z07_QTDENT * Z07_PRCCOM),'@E 999,999,999.99') + ';' + Iif(alltrim(DTOS(TMP->Z07_DTACTO)) == '', 'sem Acerto', DTOC(TMP->Z07_DTACTO)) +  _cEnter
	
	
	fWrite(_nHdl,_cLinha,Len(_cLinha))
	
	DbSkip()
	
EndDo
DbCloseArea()

fClose(_nHdl)

MsgBox('Arquivo ' + __RelDir + 'CtrlJornal.CSV criado com sucesso. Utilizar o EXCEL para consultar.','ATENวรO!!!','ALERT')

MsgBox("Caso seja necessแrio salvar a planilha, tecle F12 do seu teclado e defina" + _cEnter + "o tipo de arquivo como sendo 'Pasta de trabalho do Excel' (.xls ou .xlsx).",'LEMBRE-SE!!!','INFO')

ShellExecute("open", "EXCEL" , + __RelDir + "CtrlJornal.CSV" ,"", 1 )

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Private _cAlias := Alias ()
Private _aRegs  := {}

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
/////////////////////////////////////////////////////
Local nOrdem

_cQuery := "SELECT Z07_FILIAL, M0_FILIAL, RIGHT(Z07_DTPUBL,2) DIA, SUBSTRING(Z07_DTPUBL,5,2) MES, "
_cQuery += _cEnter + " 	Z07_CODPRO,	B1_DESC,	Z07_VENDAS,	Z07_PRRCVE,	Z07_QTDENT,	Z07_QTDENC,    "
_cQuery += _cEnter + " 	STR(Z07_QTDENC * 100 / Z07_QTDENT,9,2) PER_ENCALHE,	Z07_PERDAS,	STR(Z07_PERDAS * 100 / Z07_QTDENT,9,2)	PER_PERDAS,"
_cQuery += _cEnter + " 	Z07_PRCCOM,	Z07_DTACTO "

_cQuery += _cEnter + " FROM " + RetSQLName("Z07") + " Z07 WITH(NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSQLName ("SB1") + " SB1 WITH(NOLOCK)"
_cQuery += _cEnter + " ON B1_COD = Z07_CODPRO "
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " LEFT JOIN sigamat_copia  "
_cQuery += _cEnter + " ON Z07_FILIAL = M0_CODFIL "

_cQuery += _cEnter + " WHERE Z07_DTPUBL BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
_cQuery += _cEnter + " 	AND Z07_FILIAL = '" + MV_PAR03 + "' "
_cQuery += _cEnter + " 	AND Z07_CODFOR BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' AND Z07_LOJA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' "
_cQuery += _cEnter + " 	AND Z07.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " ORDER BY MES, DIA "

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)

TcSetField('TRB','Z07_DTACTO','D',0)

count to _nLastRec
SetRegua(_nLastRec)

dbGoTop()

_nTEnt := 0
_nTPer := 0
_nTEnc := 0
_nTCus := 0
_nTVen := 0

Do While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	_cLinha := TRB->Z07_FILIAL + ' ' + alltrim(TRB->M0_FILIAL)  + '  ' + TRB->DIA + '  ' + TRB->MES  + '  ' + substr(TRB->Z07_CODPRO,1,15)  + '  ' 
	_cLinha += substr(TRB->B1_DESC,1,40)  + '  ' + 	Trans(TRB->Z07_QTDENT, '@E 999999999')  + ' ' + 	Trans(TRB->Z07_VENDAS, '@E 999999999')  + ' ' 
	_cLinha += Trans(TRB->Z07_QTDENC, '@E 999999999')  + ' ' + 	Trans(TRB->Z07_PERDAS, '@E 999999999')  + ' ' + 	Trans(TRB->Z07_PRCCOM, '@E 999,999,999.99') + ' ' 
	_cLinha += TRB->PER_ENCALHE + ' ' + TRB->PER_PERDAS + ' ' + Trans(TRB->Z07_PRRCVE, '@E 999,999,999.99')  + ' ' + Trans(TRB->(Z07_QTDENT * Z07_PRCCOM),'@E 999,999,999.99') + '    ' 
	_cLinha += iif(alltrim(DTOS(TRB->Z07_DTACTO)) == '', 'sem Acerto', DTOC(TRB->Z07_DTACTO))

	@++nLIn,0 pSay _cLinha
		
	_nTVen += TRB->Z07_VENDAS
	_nTEnt += TRB->Z07_QTDENT
	_nTPer += TRB->Z07_PERDAS
	_nTEnc += TRB->Z07_QTDENC 
	_nTCus += TRB->Z07_QTDENT * TRB->Z07_PRCCOM

	DbSkip()
	IncRegua()
	
EndDo

@ ++nLIn,0 pSay replicate('-',220)
_cLinha := Trans(_nTEnt, '@E 999999999')  + ' ' + 	Trans(_nTVen, '@E 999999999')  + ' '
_cLinha += Trans(_nTEnc, '@E 999999999')  + ' ' + 	Trans(_nTPer, '@E 999999999')  + '                   '
_cLinha += Trans(round(_nTEnc/_nTEnt * 100,2),'999.99') + '    ' + Trans(round(_nTPer/_nTEnt * 100,2),'999.99') + '                ' + Trans(_nTCus,'@E 999,999,999.99') + '    '
_cLinha += iif(alltrim(DTOS(TRB->Z07_DTACTO)) == '', 'sem Acerto', DTOC(TRB->Z07_DTACTO))

@ ++nLIn,84 pSay _cLinha

dbClosearea()

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
