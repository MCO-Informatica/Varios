#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+==========================================================+
|Programa: DIV001 |Autor: Antonio Carlos |Data: 19/08/09   |
+==========================================================+
|Descrição: Programa utilizado para criar registros na     |
|tabela SE5 - Movimento Bancario ref. lançamentos eftuados |
|tipo PA (Pagamento Antecipado) Contas a Pagar.            |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

User Function DIV001()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cCadastro	:= "Gera Movimento Bancario - Tipo PA"

AADD(aSays,"Este programa tem o objetivo de gerar Movimento Bancario ")
AADD(aSays,"referente as movimentações de Pagamento Antecipado para ")
AADD(aSays,"processamento da Contabilidade.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
	Processa({|lEnd| AtuDados(@lEnd)},"Aguarde","Processando registros...",.T.)
EndIf		

Return

Static Function AtuDados(lEnd)

Local nTotRec	:= 0
Local _nReg		:= 0
Local _aBancos	:= {}

Aadd(_aBancos,{"01","399","1652","1262018"})
Aadd(_aBancos,{"A0","399","1652","1273737"})
Aadd(_aBancos,{"C0","399","1652","1271181"})
Aadd(_aBancos,{"C4","399","1652","1271181"})
Aadd(_aBancos,{"G0","399","1652","1698398"})
Aadd(_aBancos,{"R0","399","1652","1273656"})
Aadd(_aBancos,{"T0","104","1379","0032436"})

cQry := " SELECT E2_FILORIG, E2_EMISSAO, E2_VALOR, E2_NATUREZ, E2_NOMFOR, E2_HIST, E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_PARCELA, E2_TIPO "
cQry += " FROM "+RetSqlName("SE2")+" SE2 (NOLOCK)"
cQry += " LEFT JOIN " + RetSqlName('SE5')  + " (NOLOCK) "
cQry += " ON E2_FILORIG = E5_FILIAL AND E2_PREFIXO = E5_PREFIXO AND E2_NUM = E5_NUMERO AND "
cQry += " E2_FORNECE = E5_CLIFOR AND E2_LOJA = E5_LOJA AND SE5010.D_E_L_E_T_ = '' "
cQry += " WHERE "
cQry += " E2_TIPO = 'PA' AND "   
cQry += " E2_EMISSAO BETWEEN '20081001' AND '20081031' AND "
cQry += " E5_NUMERO IS NULL AND "
//cQry += " E2_NUM = '151008' AND "
cQry += " SE2.D_E_L_E_T_ = '' "
cQry += " ORDER BY E2_FILORIG, E2_EMISSAO "

TcQuery cQry NEW ALIAS "TMP"

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )

	While TMP->( !Eof() )

		IncProc("Processando...")
		
		DbSelectArea("SE5")
		SE5->( DbSetOrder(7) )
		If !SE5->( DbSeek(TMP->E2_FILORIG+TMP->E2_PREFIXO+TMP->E2_NUM+TMP->E2_PARCELA+TMP->E2_TIPO+TMP->E2_FORNECE+TMP->E2_LOJA) )
		
			nPos := aScan(_aBancos,{|x| x[1] == TMP->E2_FILORIG }) 
				
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	:= TMP->E2_FILORIG
			SE5->E5_DATA	:= STOD(TMP->E2_EMISSAO)
			SE5->E5_TIPO 	:= 'PA'
			SE5->E5_VALOR	:=	TMP->E2_VALOR
			SE5->E5_NATUREZ	:= TMP->E2_NATUREZ
			SE5->E5_BANCO	:= _aBancos[nPos,2]
			SE5->E5_AGENCIA := _aBancos[nPos,3]
			SE5->E5_CONTA	:= _aBancos[nPos,4]
			SE5->E5_RECPAG 	:= 'P'
			SE5->E5_BENEF	:= TMP->E2_NOMFOR
			SE5->E5_HISTOR	:= TMP->E2_HIST
			SE5->E5_TIPODOC	:= 'PA'
			SE5->E5_VLMOED2	:= TMP->E2_VALOR
			SE5->E5_PREFIXO	:= TMP->E2_PREFIXO
			SE5->E5_NUMERO	:= TMP->E2_NUM
			SE5->E5_CLIFOR	:= TMP->E2_FORNECE
			SE5->E5_LOJA	:= TMP->E2_LOJA	
			SE5->E5_DTDIGIT	:= STOD(TMP->E2_EMISSAO)
			SE5->E5_MOTBX 	:= 'NOR'
			SE5->E5_DTDISPO	:= STOD(TMP->E2_EMISSAO)
			SE5->E5_FILORIG	:= TMP->E2_FILORIG
			SE5->E5_FORNECE	:= TMP->E2_FORNECE
			SE5->E5_TASKPMS := 'S'
        	SE5->( MsUnLock() )
        	
        	_nReg++
        
		EndIf	        
		
		TMP->( DbSkip() )
	        
    EndDo
    
    MsgInfo("Processamento efetuado com sucesso! "+Alltrim(Str(_nReg))+" registros processados!" )
    
EndIf    

DbSelectArea("TMP")
DbCloseArea()

Return