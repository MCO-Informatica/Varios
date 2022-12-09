#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR003  º  Autor ³ Antonio Carlos     º Data ³  10/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Romaneios.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
       
User Function FATR003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Fechamento de Consignacao"
Local cPict			:= ""
Local titulo		:= "Romaneios"
Local nLin			:= 80


Local Cabec1		:= ""
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 120 
Private tamanho		:= "P"
Private nomeprog	:= "FATR003"
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 2, "", 1}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "FATR003"
Private cPerg		:= Padr("FATR03",len(SX1->X1_GRUPO)," ")
Private cString 	:= "PA6"

Pergunte("FATR03",.F.)

Private _lFaz		:= .T.

Pergunte(cPerg,.F.)
                         
Do While .t.        

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
					 //(cString,NomeProg,"",@titulo,"", "", "",.F.,.F.,.F.,Tamanho,,.F.)
    If aReturn[5] == 1 
		_cTexto := 'Gerando o romaneio na tela não será impresso o código de barras.' + _cEnter  + _cEnter 
		_cTexto += 'Deseja gerar o relatório SPOOL (impressora ou PDF Creator)?'	
		If !MsgBox(_cTexto,'ATENÇÃO!!!','YESNO')
			Exit
		EndIf
	Else
		Exit
	EndIf
	
EndDo

If nLastKey == 27
	Return
EndIf

fErase(__relDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
////////////////////////////////////////////////////
Local nOrdem
Local _nQtItens	:= 0
Local _nQt2um  	:= 0

cQuery	:= "SELECT MIN(ISNULL(Z09_ENDER,'ZZ')) Z09_ENDER, B1_DESC, B1_CODBAR, PA6_NUMROM, PA6_FILORI, PA6_FILDES, PA6_DTROM,PA7_ITEM ,PA7_CODPRO, B1_GRUPO, PA6_TOQUEH, PA6_TOQUED, PA6_TOQUEU,"
cQuery	+= _cEnter + "(PA7_QTDORI/ CASE WHEN B1_GRUPO = '0002' THEN CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END ELSE 1 END) AS PA7_QTDORI, "
//cQuery	+= _cEnter + "SUM(PA7_QTDORI/ CASE WHEN B1_GRUPO = '0002' THEN CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END ELSE 1 END) AS PA7_QTDORI, "
cQuery	+= _cEnter + "B1_ENCALHE, B1_WMSSEQ, BM_DESC, PA7_QTDORI TOT, ISNULL(A2_NOME,'') A2_NOME, COALESCE(Z4_COD,'') AS Z4_COD, COALESCE(Z4_DESCR,'') AS Z4_DESCR " //C5_TRANSP, A4_NOME "

cQuery	+= _cEnter + "FROM " + RetSqlName('PA6') + " PA6 (NOLOCK)"

cQuery	+= _cEnter + "INNER JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK)"
cQuery	+= _cEnter + "ON PA6_NUMROM = PA7_NUMROM"
cQuery	+= _cEnter + "AND PA7.D_E_L_E_T_ = '' "

cQuery	+= _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
cQuery	+= _cEnter + "ON PA7_CODPRO = B1_COD"
cQuery	+= _cEnter + "AND SB1.D_E_L_E_T_ = '' "

cQuery	+= _cEnter + "INNER JOIN " + RetSqlName('SBM') + " SBM (NOLOCK)"
cQuery	+= _cEnter + "ON BM_GRUPO = B1_GRUPO"
cQuery	+= _cEnter + "AND SB1.D_E_L_E_T_ = '' "

cQuery  += _cEnter + " LEFT JOIN " + RetSqlName('SZ4') + " SZ4 (NOLOCK) "
cQuery  += _cEnter + " ON B1_CODEDIT = Z4_COD "
cQuery  += _cEnter + " AND SZ4.D_E_L_E_T_ = '' "

cQuery	+= _cEnter + "LEFT JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
cQuery	+= _cEnter + "ON A2_COD = B1_PROC"
cQuery	+= _cEnter + "AND A2_LOJA = B1_LOJPROC"
cQuery	+= _cEnter + "AND SB1.D_E_L_E_T_ = '' "
                                                          
cQuery	+= _cEnter + "left JOIN " + RetSqlName('Z09') + " Z09 (NOLOCK)"
cQuery	+= _cEnter + "ON Z09.D_E_L_E_T_ = ''"
cQuery	+= _cEnter + "AND Z09_FILIAL = RIGHT(PA6_NUMROM,2)"
cQuery	+= _cEnter + "AND Z09_CODPRO = B1_COD"

cQuery	+= _cEnter + "WHERE PA6_DTROM BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND "

If alltrim(MV_PAR01)<>'' .AND. alltrim(MV_PAR02) <>''
	cQuery	+= _cEnter + " PA6_NUMROM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
EndIf
If alltrim(MV_PAR05)<>''
	cQuery	+= _cEnter + " PA6_STATUS = '"+MV_PAR05+"' AND "
EndIf
If alltrim(MV_PAR06) <> ''
	cQuery	+= _cEnter + " B1_GRUPO = '"+MV_PAR06+"' AND "
EndIf
If alltrim(MV_PAR07) <> '' .AND. alltrim(MV_PAR08) <> ''
	cQuery	+= _cEnter + " PA6_FILDES BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
EndIf
cQuery	+= _cEnter + " PA6.D_E_L_E_T_ = '' "
//cQuery	+= _cEnter + " GROUP BY B1_DESC, B1_CODBAR, PA6_NUMROM, PA6_FILORI, PA6_FILDES, PA6_DTROM,PA7_ITEM ,PA7_CODPRO, B1_ENCALHE, B1_WMSSEQ, BM_DESC, B1_GRUPO, PA7_QTDORI, A2_NOME, Z4_COD, PA6_TOQUEH, PA6_TOQUED, PA6_TOQUEU, Z4_DESCR "
cQuery	+= _cEnter + " GROUP BY PA7_QTDORI, B1_CONV, B1_DESC, B1_CODBAR, PA6_NUMROM, PA6_FILORI, PA6_FILDES, PA6_DTROM,PA7_ITEM ,PA7_CODPRO, B1_ENCALHE, B1_WMSSEQ, BM_DESC, B1_GRUPO, PA7_QTDORI, A2_NOME, Z4_COD, PA6_TOQUEH, PA6_TOQUED, PA6_TOQUEU, Z4_DESCR "
cQuery	+= _cEnter + " ORDER BY PA6_DTROM, PA6_NUMROM, Z09_ENDER, B1_WMSSEQ "
U_GravaQuery('FATR003.SQL',cQuery)

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .F., .T.)
TcSetField('TRB','B1_ENCALHE','D',0)
TcSetField('TRB','PA6_TOQUED','D',0)

DbSelectArea("TRB")
count to _nLastRec
SetRegua(_nLastRec)
TRB->(DbGoTop())
Do While !Eof()
	
	_cNumRom	:= TRB->PA6_NUMROM
	_Grupo 	    := TRB->B1_GRUPO + ' - ' + TRB->BM_DESC
	_cDatRom	:= TRB->PA6_DTROM
	_cFilOri	:= TRB->PA6_FILORI
	_cFilDes	:= TRB->PA6_FILDES
	_TotItens   := 0
	
	Do While !Eof() .And. TRB->PA6_DTROM == _cDatRom .And. TRB->PA6_NUMROM == _cNumRom
		
		IncRegua()
	
		If lAbortPrint
			@ nLin,00 pSay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf
		
		_Tot        := TRB->TOT
		If nLin > 54
		    
		   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)     
								
			nLin := 8
				
			@ nLin   ,00 pSay "Romaneio: " + _cNumRom	 + " / Grp: " + alltrim(_Grupo) 			
			@ nLin+=1,00 pSay "Dt Emis.: " + dtoc(stod(TRB->PA6_DTROM))
			@ nLin+=1,00 pSay "Origem..: " + GetAdvFVal("SM0","M0_CODFIL",cEmpAnt + _cFilOri,1) + " - " + GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + _cFilOri,1)
			@ nLin+=1,00 pSay "Destino.: " + GetAdvFVal("SM0","M0_CODFIL",cEmpAnt + _cFilDes,1) + " - " + GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + _cFilDes,1)			
							
			If aReturn[5] <> 1
				oPr := ReturnPrtObj()                                              
				_nDv     := 0                    
				_cCodBar := left(Embaralha(_cNumRom + left(_cNumRom,4),1),12)
				For _nI := 1 to 12
					_nDv += val(substr(_cCodBar,_nI,1))
				Next
				Do While _nDv > 10
					_cDv := strzero(_nDv,3)
					_nDv := 0
					For _nI := 1 to 3      
						_nDv += val(substr(_cDv,_nI,1))
					Next
				EndDo           
                _cCodBar += iif(_nDv == 10,'0',str(_nDv,1))   
                                                               
				MsBar3("EAN13",1.8,9,_cCodBar,oPr,Nil,Nil,Nil,Nil,1.5 ,Nil,Nil,Nil,Nil,4,Nil)  				
				nLin+=1
						
			EndIf		
		
			nLin+=2
			
		EndIf
		
		_cLinha  := TRB->B1_CODBAR + ' ' + Substr(TRB->B1_DESC,1,47) + ' ' + tran(TRB->PA7_QTDORI,"@E 99999") //+ ' ' + TRB->B1_WMSSEQ
		@ nLin++,00 psay _cLinha 

		DbSelectArea('Z09')
		DbSetOrder(1)
		DbSeek(right(_cNumRom,2) + TRB->PA7_CODPRO,.F.)  
		_cLinha := ''
		Do While !eof() .and. right(_cNumRom,2) + TRB->PA7_CODPRO == Z09->Z09_FILIAL + Z09->Z09_CODPRO
			_cLinha += tran(Z09->Z09_ENDER,'@R AA.99.99') + ' / '
			DbSkip()
		EndDo           
		DbSelectArea('TRB')

	  	If left(_Grupo,4) $ '0004 0006'
			_cLinha += '- DATA ENC: ' + left(dtoc(TRB->B1_ENCALHE),5)
		ElseIf left(_Grupo,4) = '0002'
			_cLinha += tran(TRB->TOT, "@E 99999" ) 
		ElseIf left(_Grupo,4) $ '0003 0007'
			_cLinha += '/ ' + TRB->B1_WMSSEQ
		EndIf

		Do While len(_cLinha) > 0
			@ nLin++,00 pSay left(_cLinha,77)
			_cLinha := substr(_cLinha,78)
		EndDo
		
		
		@ nLin++,00 psay replicate('-',80)

		_nQtItens += TRB->PA7_QTDORI
		_nQt2UM   += TRB->TOT
		_nQuant   := 0

		_TotItens ++
		_cToqueU := TRB->PA6_TOQUEU
		_cToqueH := TRB->PA6_TOQUEH
		_cToqueD := TRB->PA6_TOQUED
		DbSkip()
		
	EndDo
	
	@ nLin,53 pSay "Total de Qtde:  " +Str(_nQtItens,4)
	If left(_Grupo,4) = '0002'
  	  	@nLin,75 pSay Str(_nQt2UM,4)
 	EndIf
	@ nLin+=1,53 pSay "Total de Itens: " +Str(_TotItens,4)
	@ nLin+=1,00 pSay __PrtThinLine()
	@ nLin+=1,00 pSay "SEPARADO POR:                            |  TOCADO POR: " + _cToqueU
	@ nLin+=1,00 pSay "DATA........:   /   /                    |  DATA......: " + dtoc(_cToqueD)
	@ nLin+=1,00 pSay "INICIO......:    :    / TERMINO:    :    |  INICIO....:    :    / TERMINO: " + tran(_cToqueH,'@R 99:99')
	
	nLin := 80
	_nQtItens := 0
	_TotItens := 0
	
EndDo

DbSelectArea("TRB")
DbCloseArea("TRB")

If aReturn[5]==1    	
	OurSpool(wnrel)
EndIf

MS_FLUSH()  

Return
