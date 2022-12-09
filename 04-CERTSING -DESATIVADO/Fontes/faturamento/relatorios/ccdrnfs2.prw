#Include "MATR680.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � MATR680	� Autor � Alexandre Inacio Lemes� Data � 15.03.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Pedidos nao entregues						  			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  				  ���
�������������������������������������������������������������������������Ĵ��
��� Atualizacoes sofridas desde a construcao inicial. 					 	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CCDRNFS2()

Local titulo    := "Relacao de Notas Fiscais geradas - Bpag"
Local cDesc1    := "Este programa ira emitir a relacao de Notas Fiscais "
Local cDesc2    := "cujos pedidos de venda, foram importados do Site Bpag. "
Local cDesc3    := "Este Relatorio pode gerar Pedidos Faturados e Nao Faturados."
Local cString   := "PA6"
Local tamanho   := "G"
Local wnrel     := "CCDRNFS"

Private aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
// Private nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
Private nomeprog:= "CCDRNFS"
Private cPerg	:= "CCP002" 
// Private cArqTrab:= ""
// Private cFilTrab:= ""
Private nLastKey:= 0

//��������������������������������������������������������������Ŀ
//� Inclusao das Perguntas especificas do cliente, quando estas  �
//� nao existirem no arquivo de Perguntas SX1                    �
//����������������������������������������������������������������
DbSelectArea("SX1")
If !MsSeek("CCD002")
	AjustaSX1()
Endif		

pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros		    			 �
//� mv_par01				// Do Pedido	                     �
//� mv_par02				// Ate o Pedido	                     �
//� mv_par03				// Do Produto				         �
//� mv_par04				// Ate o Produto					 �
//� mv_par05				// Do Cliente						 �
//� mv_par06				// Ate o cliente					 �
//� mv_par07				// Da data de entrega	    		 �
//� mv_par08				// Ate a data de entrega			 �
//� mv_par09				// Em Aberto , Todos 				 �
//� mv_par10				// C/Fatur.,S/Fatur.,Todos 			 �
//� mv_par11				// Mascara							 �
//� mv_par12				// Aglutina itens grade 			 �
//� mv_par13				// Considera Residuos (Sim/Nao)		 �
//� mv_par14				// Lista Tot.Faturados(Sim/Nao)		 �
//� mv_par15				// Salta pagina na Quebra(Sim/Nao)	 �
//� mv_par16				// Do vendedor                 		 �
//� mv_par17				// Ate o vendedor                    |
//� mv_par18				// Qual a moeda                      |
//� As proximas pertencem ao grupo MR680A que eh so para         |
//� Localizacoes...                                     	     �
//� mv_par18				// Movimenta stock    (Sim/Nao)	     �
//� mv_par19		 // Gen. Doc (Factura/Remito/Ent. Fut/Todos) �
//����������������������������������������������������������������
/*
��������������������������������������������������������������Ŀ
� Envia controle para a funcao SETPRINT 					   �
| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
����������������������������������������������������������������*/  
cOrdemRel := "Serie + No. Nota" 
aOrd  	 := {cOrdemRel} 				// aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.t.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � C680IMP	� Autor � Alexandre Incaio Lemes� Data � 15.03.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio 									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MATR680													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C680Imp(lEnd,WnRel,cString)

/* 
��������������������������������������������������������������Ŀ
� Define Variaveis   										   �
����������������������������������������������������������������*/  
Local titulo    := "Relacao de Notas Fiscais geradas - Bpag"
Local cFormPgto	:= "cRegPgto == QrySC5->Z5_TIPMOV" 
Local cNFiscal  := "" 
Local cNumPed   := "" 
Local CbTxt     := ""
Local cabec1    := ""
Local cabec2    := ""
Local tamanho   := "G"
Local limite    := 220
Local CbCont    := 0
Local nOrdem    := 0
Local nTotPgto 	:= 0  
Local nTotVen   := 0

Local nTotSal   := 0
Local nTotItem  := 0

Local lImpTot   := .F.
Local lContinua := .T.
Local nMoeda    := 1			// IIF(cPaisLoc == "BRA",MV_PAR18,1)

// Alimenta os parametros do Relatorio 
Local cPedIni   := Mv_Par01
Local cPedFim   := Mv_Par02
Local cBpagIni  := Mv_Par03
Local cBpagFim  := Mv_Par04
Local cCliIni   := Mv_Par05
Local cCliFim   := Mv_Par06
Local cDatIni   := Mv_Par07
Local cDatFim   := Mv_Par08
Local lFormPed	:= Mv_Par09 

/*
��������������������������������������������������������������Ŀ
� Variaveis utilizadas para Impressao do Cabecalho e Rodape	   �
����������������������������������������������������������������*/   
cbtxt   := Space(10)
cbcont  := 0
m_pag   := 1
li 	    := 80
nTipo   := IF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

titulo  := titulo+" - Ordem => Serie + Nota Fiscal"		// + STR0007  "Por Pedido"
cabec1  := "Nota           Pedido       Pedido     Data      Codigo     Razao                                      Codigo      Descricao                               Valor    Forma    "
cabec2  := "Fiscal         Bpag         Protheus   Emissao   Cliente    Social                                     Produto     Produto                                 Notas    Pagamento" 
//   		999999 - XXX   9999999999   999999 	   99/99/99  999999-01  XxxxxxxxxxXxxxxxxxxxXxxxxxxxxxXxxxxxxxxx   XX99999999  XxxxxxxxxxXxxxxxxxxxXxxxxxxxxx  99.999.999,99
//   		0		   1         2         3   	    4         5         6         7         8		  9	      100       110       120       130  	  140	    150		  160       170
//   		012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "


/*
��������������������������������������������������������������Ŀ
�Monta Query para filtrar dados                                �
����������������������������������������������������������������*/  
DbSelectArea("SC5")
DbSetOrder(1)
                 
If Select("QrySC5") > 0
	QrySC5->(dbCloseArea())
EndIf 	

cQuery := "SELECT C5_NOTA, C5_SERIE, C5_CHVBPAG, C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_MOEDA,  " 
cQuery += "A1_NOME, C6_PRODUTO, C6_DESCRI, C6_VALOR, Z5_TIPMOV FROM "+RetSqlName("SC5")+" INNER JOIN " 
cQuery += RetSqlName("SZ5")+" ON Z5_PEDGAR = C5_CHVBPAG INNER JOIN  " 
cQuery += RetSqlName("SA1")+" ON C5_CLIENTE||C5_LOJACLI = A1_COD||A1_LOJA INNER JOIN  " 
cQuery += RetSqlName("SC6")+" ON C5_NUM = C6_NUM WHERE "+RetSqlName("SC5")+".D_E_L_E_T_ = ' ' AND " 
cQuery += RetSqlName("SC6")+".D_E_L_E_T_ = ' ' AND "+RetSqlName("SZ5")+".D_E_L_E_T_ = ' ' AND " 
cQuery += "C5_FILIAL =   '"+xFilial("SC5")+"' AND 
cQuery += "C5_NUM 	  >= '"+cPedIni +"' AND "
cQuery += "C5_NUM 	  <= '"+cPedFim +"' AND "
cQuery += "C5_CHVBPAG >= '"+cBpagIni+"' AND "	
cQuery += "C5_CHVBPAG <= '"+cBpagFim+"' AND "
cQuery += "C5_CLIENTE >= '"+cCliIni +"' AND "
cQuery += "C5_CLIENTE <= '"+cCliFim +"' AND "
cQuery += "C5_EMISSAO >= '"+Dtos(cDatIni)+"' AND "

If lFormPed == 1 				// Em Aberto 
	cQuery += "C5_EMISSAO <= '"+Dtos(cDatFim)+"' AND C5_NOTA = '' "
	cQuery += "ORDER BY Z5_TIPMOV, C5_NUM " 	
 ElseIf lFormPed == 2 			// Faturados  
	cQuery += "C5_EMISSAO <= '"+Dtos(cDatFim)+"' AND C5_NOTA <> '' "
	cQuery += "ORDER BY Z5_TIPMOV, C5_SERIE, C5_NOTA " 	
 ElseIf lFormPed == 3 			// Todos 
	cQuery += "C5_EMISSAO <= '"+Dtos(cDatFim)+"' " 
	cQuery += "ORDER BY Z5_TIPMOV, C5_NUM " 	
Endif	

cQuery := ChangeQuery(cQuery)
TcQuery cQuery NEW ALIAS "QrySC5"

DbSelectArea("QrySC5")
DbGoTop()
SetRegua(RecCount())                    	// Total de Elementos da Regua 

While !QrySC5->(Eof()) .And. lContinua
	
	If lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	If li > 58 		// .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf

	/*
	��������������������������������������������������������������Ŀ
	�Variaveis algumas informacoes para melhor apresentacao		   �
	����������������������������������������������������������������*/ 
	nValPed := xMoeda(QrySC5->C6_VALOR,QrySC5->C5_MOEDA,1,dDataBase,8)
   	cRegPgto:= QrySC5->Z5_TIPMOV
	cPagto 	:= QrySC5->Z5_TIPMOV
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='1'	, 'Boleto'	, cPagto) 
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='2'	, 'Cartao de Credito'	, cPagto)
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='3'	, 'Cartao de Debito'	, cPagto)
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='4'	, 'Debito Automatico'	, cPagto)
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='5'	, 'Debito Direto Autorizado'	, cPagto)  
	cPagto 	:= If(Left(QrySC5->Z5_TIPMOV,1)=='6'	, 'VOUCHER'	, cPagto)
	                                                                  
	/*cRegPgto:= QrySC5->PA6_PAGTO
	cPagto 	:= QrySC5->PA6_PAGTO
	cPagto 	:= If(Left(QrySC5->PA6_PAGTO,2)$'ar/AR'		, 'Aut. de Registro'	, cPagto) 
	cPagto 	:= If(Left(QrySC5->PA6_PAGTO,6)=='cartao'	, 'Cartao de Credito'	, cPagto)  */
	

//	"Nota           Pedido       Pedido     Data      Codigo     Razao                                      Codigo      Descricao                       Valor 		     Forma 
//	"Fiscal         Bpag         Protheus   Emissao   Cliente    Social                                     Produto     Produto                         Pedido           Pagamento
//   999999 - XXX 	9999999999   999999 	99/99/99  999999-01  XxxxxxxxxxXxxxxxxxxxXxxxxxxxxxXxxxxxxxxx  	XX99999999  XxxxxxxxxxXxxxxxxxxxXxxxxxxxxx  99.999.999,99
//   0		   1         2         3   	     4         5         6         7         8		   9	   100       110       120       130  	   140	     150		 160       170 
//   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

	If !(QrySC5->C5_SERIE+QrySC5->C5_NOTA == cNFiscal) 
		@li,  0 Psay QrySC5->C5_NOTA+" - "+ QrySC5->C5_SERIE
		@li, 15 Psay QrySC5->C5_CHVBPAG
		@li, 28 Psay QrySC5->C5_NUM 
		@li, 39 Psay Stod(QrySC5->C5_EMISSAO)  	Picture "99/99/99" 
		@li, 49 Psay QrySC5->C5_CLIENTE+"-"+QrySC5->C5_LOJACLI 
		@li, 60 Psay QrySC5->A1_NOME
	Endif 
		
	@li,103 Psay QrySC5->C6_PRODUTO 
	@li,116 Psay QrySC5->C6_DESCRI 
	@li,149 Psay nValPed	Picture 	PesqPict("SC6","C6_VALOR",12) 		// "@E 99,999,999.99"    
	@li,165 Psay cPagto 

	// @li,110 Psay QrySC5->C6_VALOR 	PICTURE "@E 99,999,999.99"   	PesqPict("SC6","C6_VALOR",12)
	// nCont++	desativado 
	nTotPgto+= nValPed
	nTotVen += nValPed
	li++
	
	/*
	��������������������������������������������������������������Ŀ
	� Tratamento das Quebras para nao repetir dados do pedido      �
	����������������������������������������������������������������*/ 
	If lFormPed == 1 .or. lFormPed == 3				// Em Aberto ou Todos 
		cNumPed := QrySC5->C5_NUM 
	  ElseIf lFormPed == 2
		cNFiscal:= QrySC5->C5_SERIE+QrySC5->C5_NOTA 
    Endif 
	IncRegua()
	QrySC5->(DbSkip()) 
    
	/* 
	��������������������������������������������������������������Ŀ
	�Quebra por Forma de Pagamento do Pedido - origem Bpag         �
	����������������������������������������������������������������*/ 
    If !&cFormPgto
		@li,  0 Psay __PrtThinLine()
		li++
		@Li,000 Psay "Total Forma Pgto: "+ cPagto
		@Li,148 Psay nTotPgto  	Picture   PesqPict("SC6","C6_VALOR",12)
        li:=li+2 
        nTotPgto:= 0	
    EndIf         
    
    /* 
	��������������������������������������������������������������Ŀ
	� Imprime o Total ou linha divisora conforme a quebra		   �
	����������������������������������������������������������������
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2
				@Li,000 Psay STR0025
				@Li,136 Psay nTotAR PICTURE PesqPictQt("C6_QTDVEN",12)

				@Li,149 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",12)
				@Li,162 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",12)
				li++
			Endif
			
			If nTotAR > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif
			
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		// nCont   := 0
	Endif			*/  

	
Enddo 

/* 
��������������������������������������������������������������Ŀ
� Imprime o Total do Pedido                                    �
����������������������������������������������������������������*/  
@li,  0 Psay __PrtThinLine()
li++
@Li,000 Psay "Total do Relatorio" 
@Li,148 Psay nTotVen  	Picture 	PesqPict("SC6","C6_VALOR",12)

If li != 80
	Roda(cbcont,cbtxt)
Endif

DbSelectArea("QrySC5")
DbCloseArea()

/*
���������������������������������������������������Ŀ
� Deleta arquivos de trabalho.                      �
�����������������������������������������������������*/  
// Ferase(cArqTrab+GetDBExtension())
// Ferase(cArqTrab+OrdBagExt())
// Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1    �Autor �  Paulo Eduardo       �Data� 17.03.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
Local cKey     := ""
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

PutSx1( "MTR680","19","Imprime             ","Imprime             ","Print               ","mv_chj","N",1,0,1,"C","","","","","mv_par19",;
		"Valor Total","Valor Total","Total Value","","Saldo","Saldo","Balance")	
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
aAdd(aHelpPor,"Informe qual valor sera impresso")
aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
aAdd(aHelpSpa,"Informe que valor se imprimira")
aAdd(aHelpSpa,"en el campo 'VALOR TOTAL'")
aAdd(aHelpEng,"Enter the value to be printed")
aAdd(aHelpEng,"in 'TOTAL VALUE' field.")
PutSX1Help("P.MTR68019.",aHelpPor,aHelpEng,aHelpSpa)						
Return
