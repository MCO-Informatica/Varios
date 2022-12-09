#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO1     � Autor � RODRIGO ALEXANDRE  � Data �  23/05/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LS_MOVBANC


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mov. Banc�ria"
Local cPict          := ""
Local titulo       := "Movimenta��o Banc�ria"
Local nLin         := 80
                     /*1   5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80   85   90   95   100*/
Local Cabec1       := "Fl                 Bco  Ag     CTA        Data"
Local Cabec2       := "  Tp   Natureza    Benefici�rio                    Hist�rico                                        Valor" 
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "LS_MOVBANC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "SE5MOV"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LS_MOVBANC" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE5"

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  08/12/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cData


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������


_cQuery :="SELECT E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA,"
_cQuery += _cEnter + " E5_DATA, E5_TIPO, E5_NATUREZ, E5_BENEF,"
_cQuery += _cEnter + " E5_HISTOR, E5_VALOR, SUM(E5_VALOR) TOTAL"
_cQuery += _cEnter + " FROM " + RetSqlName('SE5') + " SE5 (NOLOCK) "
_cQuery += _cEnter + "WHERE E5_FILIAL = '" + MV_PAR04 + "' AND E5_DATA BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQuery += _cEnter + "AND E5_CLIFOR <= '000009' "
_cQuery += _cEnter + "AND E5_BANCO >= '001' "
_cQuery += _cEnter + "AND SE5.D_E_L_E_T_ = '' "
If mv_par01==2  // Mesma Empresa
	_cQuery += _cEnter + "AND E5_LOJA = E5_FILIAL "
EndIf
_cQuery += _cEnter + "GROUP BY E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DATA, E5_TIPO, E5_NATUREZ, E5_BENEF, E5_HISTOR, E5_VALOR "
_cQuery += _cEnter + "ORDER BY E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DATA, E5_NATUREZ"
   
U_GravaQuery('ls_movbanc.SQL',_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)

TcSetField('TRB','E5_DATA','D',0)
            
count to _nLastRec
SetRegua(_nLastRec)

_cEmpresa := Posicione('SM0',1,cEmpAnt + mv_par04,'M0_NOME')
SM0->(DbSeek(cEmpAnt + cFilAnt))

dbGoTop()
While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	                    
		@++nLin,00 PSAY TRB->E5_FILIAL + ' ' + _cEmpresa + ' ' + TRB->E5_BANCO + '  ' + TRB->E5_AGENCIA + '  ' + TRB->E5_CONTA + ' ' + DTOC(TRB->E5_DATA)

		DbSkip()
		IncRegua()
		
		_nTotal:= 0
		_cData := TRB->E5_DATA
		_cBanco:= TRB->E5_BANCO
		_cAg   := TRB->E5_AGENCIA
		_cConta:= TRB->E5_CONTA
		_cFl   := TRB->E5_FILIAL
		
			DO WHILE _cFl == TRB->E5_FILIAL .AND. _cData == TRB->E5_DATA .AND. _cBanco == TRB->E5_BANCO .AND. _cAg == TRB->E5_AGENCIA .AND. _cConta == TRB->E5_CONTA .AND. !EOF()
					
			
			//���������������������������������������������������������������������Ŀ
			//� Verifica o cancelamento pelo usuario...                             �
			//�����������������������������������������������������������������������
			
			If lAbortPrint
				@nLin,01 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//���������������������������������������������������������������������Ŀ
			//� Impressao do cabecalho do relatorio. . .                            �
			//�����������������������������������������������������������������������
			
			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@ ++nLin,02 PSAY TRB->E5_TIPO + '  ' + TRB->E5_NATUREZ + '  ' + TRB->E5_BENEF + '  ' + left(TRB->E5_HISTOR,40) + tran(TRB->E5_VALOR,'@E 999,999,999.99')
			If len(alltrim(TRB->E5_HISTOR)) > 40
				@ ++nLin,54 PSAY SUBSTR(TRB->E5_HISTOR,41) 
			EndIf
			
			_nTotal += TRB->E5_VALOR
			
			dbSkip()
			IncRegua()
			
					
		EndDo
		@ ++nLin		
		@ ++nLin,66 PSAY "Total das Movimenta��es: " + Trans(_nTotal,'@E 999,999,999.99')
		@ ++nlin,00 pSay __PrtThinLine()
		
EndDo

dbClosearea()

If aReturn[5]==1
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
