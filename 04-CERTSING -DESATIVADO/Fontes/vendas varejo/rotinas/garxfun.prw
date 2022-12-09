#INCLUDE "PROTHEUS.CH"

// PARA DELETAR A MOVIMENTACAO NA BASE DE TESTES
/*
TRUNCATE TABLE SA1010
TRUNCATE TABLE SC5010
TRUNCATE TABLE SC6010
TRUNCATE TABLE SC9010
TRUNCATE TABLE SE1010
TRUNCATE TABLE SE5010
TRUNCATE TABLE SZ5010
TRUNCATE TABLE SF2010
TRUNCATE TABLE SD2010
TRUNCATE TABLE SFT010
TRUNCATE TABLE SF3010
TRUNCATE TABLE GTIN
TRUNCATE TABLE GTRET
TRUNCATE TABLE GTOUT
TRUNCATE TABLE GTNFE
TRUNCATE TABLE CTK010
TRUNCATE TABLE CT2010
*/

// QUERY PARA RETORNAR A URI COM O PEDIDO E cgc DO CLIENTE PARA TESTAR NOTAS NO GAR
/*
SELECT	'EXPLORER "http://gestaoar-homolog.certisign.com.br/gestaoar/invoices/list?id='+TRIM(C5_CHVBPAG)+'&documento='+TRIM(C5_CNPJ)+'"'
FROM	SC5010
WHERE	C5_CHVBPAG = '7249'
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARXFUN   �Autor  �Armando M. Tessaroli� Data �  12/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Possui funcoes genericas de apoio ao processamento do       ���
���          �projeto GAR                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GARX3OK(cAlias, aDados, cPedGar)

Local aRet		:= {}
Local nI

Default cPedGar	:= "9999999999"

(cAlias)->( DbSetOrder(1) )
SX3->( DbSetOrder(2) )
For nI := 1 To Len(aDados)
	If !SX3->( MsSeek( aDados[nI][1] ) )
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000052" )
		Aadd( aRet, cPedGar )
		Aadd( aRet, aDados[nI][1] )
		Return(aRet)
	Else
		If SX3->X3_CONTEXT == "V"
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000053" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, aDados[nI][1] )
			Return(aRet)
		Endif
	Endif
	If ValType(aDados[nI][2]) <> ValType( &(cAlias+"->"+aDados[nI][1]) )
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000054" )
		Aadd( aRet, cPedGar )
		Aadd( aRet, aDados[nI][1] )
		Return(aRet)
	Endif
Next nI

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000055" )
Aadd( aRet, cPedGar )
Aadd( aRet, "" )

Return(aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARXFUN   �Autor  �Armando M. Tessaroli� Data �  12/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Possui funcoes genericas de apoio ao processamento do       ���
���          �projeto GAR                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GARCondic(cCampo,aDados,cPedGar)

Local aRet		:= {}
Local nPos1		:= 0
Local nPos2		:= 0

Default cPedGar	:= "9999999999"

Do Case
	Case cCampo == "A1_PFISICA"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="A1_PESSOA" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000056" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "F"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000057" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000058" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "E1_ADM"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="E1_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000059" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "2"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000060" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000061" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo $ "E1_PORTADO,E1_AGEDEP,E1_CONTA"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="E1_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000059" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If !(aDados[nPos2][2] $ "3,4,5")		// Cartao de debito, DA, DDA
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000107" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000108" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "C5_TIPVOU"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="C5_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000062" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "6"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000063" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000064" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "C5_CODVOU"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="C5_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000065" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "6"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000066" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000067" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "C5_MOTVOU"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="C5_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000065" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "6"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000152" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000153" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "Z5_TIPVOU"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="Z5_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000068" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "6"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000069" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000070" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "Z5_CODVOU"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="Z5_TIPMOV" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000071" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "6"
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000072" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000073" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
		
	Case cCampo == "Z5_GARANT"
		nPos2 := Ascan( aDados, { |x| AllTrim(x[1])=="Z5_STATUS" } )
		If nPos2 == 0
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000074" )
			Aadd( aRet, cPedGar )
			Aadd( aRet, "" )
			Return(aRet)
		Endif
		
		If aDados[nPos2][2] == "2"		// Renovacao
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 == 0
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000075" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
			If Empty(aDados[nPos1][2])
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000076" )
				Aadd( aRet, cPedGar )
				Aadd( aRet, "" )
				Return(aRet)
			Endif
		Else
			// Se o campo condicional veio e nao deveria vir, entaum eu elimino o conteudo
			nPos1 := Ascan( aDados, { |x| AllTrim(x[1])==AllTrim(cCampo) } )
			If nPos1 > 0 .AND. !Empty(aDados[nPos1][2])
				aDados[nPos1][2] := ""
			Endif
		Endif
	
Endcase

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000055" )
Aadd( aRet, cPedGar )
Aadd( aRet, "" )

Return(aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARXFUN   �Autor  �Microsiga           � Data �  03/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LogTime(cText, lFim)

Local cFileOut	:= "logtime.log"

Default lFim	:= .F.

If !(ValType(nLgTime) == "N" .AND. ValType(nMlSec) == "N")
	Return(.F.)
Endif

If nLgTime < 0
	If !File(cFileOut)
		nLgTime := FCreate(cFileOut,1)
	Else
		While FErase(cFileOut)==-1
		End
		nLgTime := FCreate(cFileOut,1)
	Endif
Endif

FWrite(nLgTime, Time()+" "+StrZero(Seconds()-nMlSec,6,3)+"  ---> "+cText+CRLF)
nMlSec := Seconds()

If lFim
	FClose(nLgTime)
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARXFUN   �Autor  �Armando M. Tessaroli� Data �  12/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Possui funcoes genericas de apoio ao processamento do       ���
���          �projeto GAR                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GARMensagem()

Local aMens	:= {}
Local nI	:= {}
Local aGrp	:= {}

Aadd( aGrp, {"01", "Foi encontrado um erro nos dados cadastrais fornecidos � Certisign para a emiss�o da sua NF-e"} )
Aadd( aGrp, {"02", "Ocorreu um erro durante a inclus�o dos seus dados no sistema de emiss�o de NF-e"} )
Aadd( aGrp, {"03", "O Depto. Financeiro da Certisign detectou um erro durante a inclus�o dos seus dados no sistema de emiss�o de NF-e"} )
Aadd( aGrp, {"04", "Erro: foi detectada uma diverg�ncia de informa��es durante a inclus�o dos seus dados no sistema de emiss�o de NF-e"} )
Aadd( aGrp, {"05", "OK"} )
Aadd( aGrp, {"06", "Ocorreu um erro durante a inclus�o dos seus dados no sistema de emiss�o de NF-e: informa��o inexistente"} )
Aadd( aGrp, {"07", "Foi encontrado um erro nas informa��es fornecidas � Certisign para a emiss�o da sua NF-e: a estrutura dos dados � incompat�vel"} )
Aadd( aGrp, {"08", "Erro na emiss�o da NF-e"} )
Aadd( aGrp, {"09", "Detectamos que o seu pedido correspondente � um processo corporativo. Neste caso, a NF-e n�o � fornecida a partir deste sistema"} )
Aadd( aGrp, {"10", "Nota fiscal j� emitida para esta compra"} )

Aadd( aMens, { "000001", "C5_TIPMOV --> Forma de Pagamento n�o localizada na estrutura do cabe�alho do pedido", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000002", "C5_TIPMOV --> Forma de Pagamento do pedido de vendas n�o pode ser vazia", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000003", "E1_TIPMOV --> Forma de Pagamento n�o localizada na estrutura do financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000004", "E1_TIPMOV --> Forma de Pagamento do financeiro n�o pode ser vazia", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000005", "C5_TIPMOV / E1_TIPMOV --> O tipo de movimento do pedido deve ser igual ao tipo de movimento do financeiro", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000006", "A1_CGC --> CNPJ do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000007", "A1_CGC --> CNPJ do cliente no cadastro de clientes n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000008", "C5_CNPJ --> CNPJ do cliente n�o localizada na estrutura do pedido de venda", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000009", "C5_CNPJ --> CNPJ do cliente no pedido de venda n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000010", "E1_CNPJ --> CNPJ do cliente n�o localizada na estrutura do movimento financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000011", "E1_CNPJ --> CNPJ do cliente no movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000012", "A1_CGC/C5_CNPJ/E1_CNPJ --> Diferenca no conteudo do campo CNPJ entre cliente, financeiro e pedido de vendas", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000013", "C5_TOTPED --> Valor total do pedido n�o localizada na estrutura do pedido de venda", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000014", "C5_TOTPED --> Valor total do pedido de venda n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000015", "E1_VALOR --> Valor total a pagar n�o localizada na estrutura do financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000016", "E1_VALOR --> Valor total do movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000017", "C5_TOTPED/E1_VALOR --> O Valor total informado o pedido de vendas n�o pode ser diferente do valor enviado no financeiro", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000018", "SE1 --> A estrutura de dados das parcelas est� diferente da estrutura do titulo principal", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000019", "SE1 --> A estrutura de dados das parcelas est� diferente da estrutura do titulo principal", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000020", "SE1 --> A estrutura de dados das parcelas est� diferente da estrutura do titulo principal", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000021", "SE1 --> A estrutura ou conte�do de dados das parcelas est� diferente da estrutura do titulo principal", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000022", "C5_TOTPED/E1_VALOR --> O Valor total informado No pedido de vendas n�o pode ser diferente do valor da soma das parcelas", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000023", "Inclus�o efetuada com sucesso...", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000024", "C5_TIPMOV --> Forma de Pagamento invalida", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000025", "A1_CGC --> CNPJ/CPF do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000026", "A1_CGC --> CNPJ/CPF do cliente n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000027", "SA1 --> Erro de inclus�o de clientes na rotina padr�o do sistema Protheus MSExecAuto", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000028", "C5_CHVBPAG --> N�mero do pedido GAR n�o localizada na estrutura do pedido de vendas", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000029", "C5_CHVBPAG --> N�mero do pedido GAR n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000030", "C5_CHVBPAG --> N�mero do pedido GAR j� est� cadastrado no ERP Protheus", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000031", "C6_PROGAR --> N�mero do produto no GAR n�o localizada na estrutura do item do pedido de vendas", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000032", "C6_PROGAR --> N�mero do produto no GAR n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000033", "C6_QTDVEN --> Quantidade vendida do produto no GAR n�o localizada na estrutura do item do pedido de vendas", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000034", "C6_QTDVEN --> Quantidade do produto no GAR n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000035", "C6_PROGAR --> C�digo do produto GAR localizado no De/Para e n�o localizado no cadastro de produtos no ERP", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000036", "C6_PROGAR --> C�digo do produto no GAR n�o localizado no De/Para ou cadastro de produtos do ERP", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000037", "B1_PRV1 --> Valor do produto n�o informado no cadastro do produto no ERP", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000038", "B1_TS --> Tipo de sa�da do produto n�o informado no cadastro do produto no ERP", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000039", "SF4 --> Tipo de sa�da informado no produto n�o cadastrada na tabela de TES do ERP", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000040", "F4_CF --> Classifica��o fiscal n�o informada no cadastro de TES", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000041", "F4_SITTRIB --> Situa��o tribut�ria n�o informada no cadastro de TES", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000042", "C5_VEND1 --> Problemas de cadastro no ERP. N�o h� vendedor cadastrado para o produto do pedido de vendas", aGrp[6][1], aGrp[6][2] } )
Aadd( aMens, { "000043", "C5_TOTPED --> Valor total do pedido no GAR n�o localizada na estrutura do item do pedido de vendas", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000044", "N�o foi poss�vel ajustar a diferenca de valores encontrada entre valor de tabela e valor GAR", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000045", "SC5, SC6 --> Erro de inclus�o de pedido de vendas na rotina padr�o do sistema Protheus MSExecAuto", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000046", "E1_EMISSAO --> Emiss�o de movimento financeiro n�o localizada na estrutura do item do contas a receber", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000047", "E1_EMISSAO --> Emiss�o de movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000048", "E1_VENCTO --> Vencimento de movimento financeiro n�o localizada na estrutura do item do contas a receber", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000049", "E1_VENCTO --> Vencimento de movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000050", "E1_VALOR --> Valor de movimento financeiro n�o localizada na estrutura do item do contas a receber", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000051", "E1_VALOR --> Valor de movimento financeiro n�o pode ser zero", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000052", "Campo inexistente no dicion�rio de dados", aGrp[7][1], aGrp[7][2] } )
Aadd( aMens, { "000053", "Campo do dicion�rio de dados tipo virtual no ERP", aGrp[7][1], aGrp[7][2] } )
Aadd( aMens, { "000054", "Inconsistencia no tipo de dados definido na tabela do ERP. Tipo do dado enviado diferente do tipo do dado esperado.", aGrp[7][1], aGrp[7][2] } )
Aadd( aMens, { "000055", "Checagem de dados ok", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000056", "A1_PESSOA --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000057", "A1_PFISICA --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000058", "A1_PFISICA --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000059", "E1_TIPMOV --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000060", "E1_ADM --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000061", "E1_ADM --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000062", "C5_TIPMOV --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000063", "C5_TIPVOU --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000064", "C5_TIPVOU --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000065", "C5_TIPMOV --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000066", "C5_CODVOU --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000067", "C5_CODVOU --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000068", "Z5_TIPMOV --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000069", "Z5_TIPVOU --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000070", "Z5_TIPVOU --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000071", "Z5_TIPMOV --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000072", "Z5_CODVOU --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000073", "Z5_CODVOU --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000074", "Z5_STATUS --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000075", "Z5_GARANT --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000076", "Z5_GARANT --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000077", "Campo � obrigat�rio e n�o foi enviado na estrutura da tabela de faturamento", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000078", "Campo de conte�do obrigat�rio e n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000079", "Z5_PEDGAR --> N�mero do pedido GAR n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000080", "Z5_TIPMOV --> Forma de Pagamento n�o localizada na estrutura do cabe�alho do pedido", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000081", "Z5_TIPMOV --> Forma de Pagamento do pedido de vendas n�o pode ser vazia", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000082", "Z5_VALOR --> Forma de Pagamento n�o localizada na estrutura do cabe�alho do pedido", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000083", "Z5_VALOR --> Forma de Pagamento do pedido de vendas n�o pode ser vazia", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000084", "Z5_CNPJ --> Forma de Pagamento n�o localizada na estrutura do cabe�alho do pedido", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000085", "Z5_CNPJ --> Forma de Pagamento do pedido de vendas n�o pode ser vazia", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000086", "Z5_STATUS --> Erro estrutural do campo obrigat�rio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000087", "Z5_STATUS --> Status do certificado n�o pode ser vazio", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000088", "Z5_PEDGAR --> N�mero do pedido do GAR n�o localizado no ERP", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000089", "SZ5 --> Este pedido eh da vers�o antiga e n�o poder� ser faturado pela integra��o GAR", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000090", "SC5/SZ5 TIPMOV --> A forma de pagamento do pedido est� diferente da forma de pagamento para faturamento.", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000091", "SC5/SZ5 VALOR --> O valor do pedido est� diferente do valor enviado para faturamento.", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000092", "SC5/SZ5 CNPJ --> O CNPJ do cliente no pedido est� diferente do CNPJ enviado para faturamento.", aGrp[4][1], aGrp[4][2] } )
Aadd( aMens, { "000093", "SC5 --> Este pedido j� foi faturado", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000094", "Para voucher corporativo a nota fiscal ser� emitida posteriormente � empresa", aGrp[9][1], aGrp[9][2] } )
Aadd( aMens, { "000095", "Tipo de movimento invalido", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000096", "NFS gerada com sucesso...", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000097", "SC6 --> Erro de altera��o do pedido de vendas na rotina padr�o do sistema Protheus MSExecAuto", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000098", "SC9 --> N�o h� itens dispon�veis no pedido para libera��o e faturamento", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000099", "Libera��o do pedido executada com sucesso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000100", "Grava��o do controle de faturamento executada com sucesso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000101", "Gera��o da Nota Fiscal realizada com sucesso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000102", "Compensa��o financeira realizada com sucesso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000103", "Z5_PEDGAR --> N�mero do pedido GAR n�o localizada na estrutura de solicita��o de faturamento", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000104", "E1_TIPMOV --> Forma de pagamento n�o localizada na estrutura do item do contas a receber", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000105", "E1_TIPMOV --> Forma de pagamento n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000106", "SE1 --> Erro de inclusao no financeiro na rotina padr�o do sistema Protheus MSExecAuto", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000107", "E1_PORTADO,E1_AGEDEP,E1_CONTA --> Estes campos n�o foram localizados na estrutura enviada pelo WS.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000108", "E1_PORTADO,E1_AGEDEP,E1_CONTA --> O conte�do destes campos � condicional e n�o podem ser vazios", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000109", "A1_PESSOA --> Pessoa (F)isica (J)uridica do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000110", "A1_PESSOA --> Pessoa (F)isica (J)uridica do cliente n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000111", "A1_EST --> Estado do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000112", "A1_EST --> Estado do cliente n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000113", "A1_COD_MUN --> C�digo do municipio do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000114", "A1_COD_MUN --> C�digo do municipio do cliente n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000115", "A1_MUN --> Municipio do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000116", "A1_MUN --> Municipio do cliente n�o pode ser vazio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000117", "E1_PEDGAR --> Este campo eh obrigatorio e nao foi localizado na estrutura do webservicess", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000118", "E1_PEDGAR --> Este campo eh obrigatorio e seu conteudo nao pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000119", "Parametro URLSPEDSERVICE no job de processamento nao configurado.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000120", "TOTVS SPED SERVICE FORA DO AR", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000121", "Falha ao obter identificador da Entidade", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000122", "Falha ao obter ambiente", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000123", "Falha ao obter modalidade", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000124", "Falha ao obter versao NFE", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000125", "Falha ao obter status Sefaz", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000126", "Nota Fiscal nao encontrada no sistema", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000127", "Nota Fiscal cancelada", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000128", "Nota Fiscal invalida para processamento ou ja processada", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000129", "XML Vazio para Nota Fiscal", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000130", "Erro de Envio da Remessa", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000131", "Nfe gerada / enviada com sucesso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000132", "NFe Recusada", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000133", "Nao foi poss�vel obter o ID do cliente para emiss�o do DANFEII", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000134", "Nao foi poss�vel gravar o arquivo PDF do espelho da nota fiscal", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000135", "Espelho do DANFEII gerado com sucasso", aGrp[5][1], aGrp[5][2] } )
Aadd( aMens, { "000136", "Os produtos informados no pedido abaixo n�o estao devidamente parametrizados para serem faturados", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000137", "Houve um erro inesperado na aplicacao.", aGrp[08][1], aGrp[08][2] } )
Aadd( aMens, { "000138", "O campo CEP nao foi encontrato na estrutura do webservices", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000139", "O campo CEP nao poder ser vazio pois eh um campo de conteudo obrigatorio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000140", "O campo BAIRRO nao foi encontrato na estrutura do webservices", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000141", "O campo BAIRRO nao poder ser vazio pois eh um campo de conteudo obrigatorio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000142", "O campo PAIS nao foi encontrato na estrutura do webservices", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000143", "O campo PAIS nao poder ser vazio pois eh um campo de conteudo obrigatorio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000144", "O campo NOME DO PAIS nao foi encontrato na estrutura do webservices", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000145", "O campo NOME DO PAIS nao poder ser vazio pois eh um campo de conteudo obrigatorio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000146", "O campo ENDERECO nao foi encontrato na estrutura do webservices", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000147", "O campo ENDERECO nao poder ser vazio pois eh um campo de conteudo obrigatorio", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000148", "N�o ser� poss�vel emitir a nota de entrega da mercadoria sem antes emitir a nota de entrega programada", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000149", "C�digo do Municipio n�o pertence ao estado de Sao Paulo", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000150", "A1_INSCR --> Inscricao do cliente n�o localizada na estrutura do cadastro de clientes", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000151", "O CEP informado para o cliente n�o existe na base de CEP do ERP", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000152", "C5_MOTVOU --> Este campo n�o foi localizado na estrutura enviada pelo WS.", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000153", "C5_MOTVOU --> O conte�do deste campo � condicional e n�o pode ser vazio", aGrp[2][1], aGrp[2][2] } )
Aadd( aMens, { "000154", "Pedido somente com nota de servico nao emite nota de entrega do produto.", aGrp[10][1], aGrp[10][2] } )
Aadd( aMens, { "000155", "Nota Fiscal j� emitida", aGrp[10][1], aGrp[10][2] } )
Aadd( aMens, { "000156", "Nota Fiscal n�o autorizada", aGrp[08][1], aGrp[08][2] } )
Aadd( aMens, { "000157", "Cadastro do cliente bloqueado por outro usuario do ERP Protheus", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000158", "Numero de pedido gar invalido. Provavelmente deve-se tratar de um pedido teste.", aGrp[1][1], aGrp[1][2] } )
Aadd( aMens, { "000159", "Erro de inconsistencia de faturamento na funcao interna do Protheus.", aGrp[8][1], aGrp[8][2] } )
Aadd( aMens, { "000160", "E1_PORTADO --> Banco n�o localizado na estrutura do movimento financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000161", "E1_PORTADO --> Banco no movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000162", "E1_AGEDEP --> Agencia bancaria n�o localizada na estrutura do movimento financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000163", "E1_AGEDEP --> Agencia bancaria no movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000164", "E1_CONTA --> Conta bancaria n�o localizada na estrutura do movimento financeiro", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000165", "E1_CONTA --> Conta bancaria no movimento financeiro n�o pode ser vazio", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000166", "Banco, agencia e conta informados, nao estao cadastrados no ERP", aGrp[3][1], aGrp[3][2] } )
Aadd( aMens, { "000167", "Banco, agencia e conta cadastrados no ERP estao bloqueadospara uso", aGrp[3][1], aGrp[3][2] } )


//Aadd( aMens, { "000000", "", aGrp[][1], aGrp[][2] } )

SZ7->( DbSetOrder(1) )
For nI := 1 To Len( aMens )
	If SZ7->( !MsSeek( xFilial("SZ7")+aMens[nI][1] ) )
		SZ7->( RecLock("SZ7", .T.) )
			SZ7->Z7_FILIAL := xFilial("SZ7")
			SZ7->Z7_CODMEN := aMens[nI][1]
			SZ7->Z7_DESMEN := aMens[nI][2]
			SZ7->Z7_CODGRU := aMens[nI][3]
			SZ7->Z7_DESGRU := aMens[nI][4]
		SZ7->( MsUnLock() )
	Else
		If AllTrim(SZ7->Z7_DESMEN) <> AllTrim(aMens[nI][2]) .OR. SZ7->Z7_CODGRU <> aMens[nI][3] .OR. AllTrim(SZ7->Z7_DESGRU) <> AllTrim(aMens[nI][4])
			SZ7->( RecLock("SZ7", .F.) )
			SZ7->Z7_DESMEN := aMens[nI][2]
			SZ7->Z7_CODGRU := aMens[nI][3]
			SZ7->Z7_DESGRU := aMens[nI][4]
			SZ7->( MsUnLock() )
		Endif
	Endif
Next nI

Return(.T.)
