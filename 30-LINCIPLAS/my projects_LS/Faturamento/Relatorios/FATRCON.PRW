#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR002   º Autor ³ Antonio Carlos     º Data ³  12/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Acerto de Consignacao.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATRCON()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Acerto de Consignacao"
Local cPict			:= ""
Local titulo		:= "Acerto de Consignacao"
Local nLin			:= 80

//"Codigo           Descricao                       NF      Emissao                    Preco        Qtde Cons.  Valor Cons.     Dev/Jur     Valor            Qtde          Valor"
                       
//Local Cabec1		:= "Codigo                Descricao                                           NF          Emissao          Preco             Consignacao                 Saldo Consig.                A Pagar      "
//Local Cabec2		:= "                                                                                                                      Qtde        Valor           Qtde          Valor        Qtde         Valor" 

Local Cabec1		:= "Codigo                Descricao                       NF         Emissao        Preco                    A Pagar          "
Local Cabec2		:= "                                                                                                    Qtde        Valor     "

//Local Cabec1		:= ""
//Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 120
Private tamanho		:= "M"
Private nomeprog	:= "FATRCON" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 2, "", 1}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "FATRCON" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		:= "FATR02    "
Private cString 	:= "SB6"

Private _nB2CM1		:= 0
Private _nQtdeCo	:= 0
Private _nVlrCo		:= 0
Private _nQtdeB6	:= 0
Private _nVlrB6		:= 0
Private _nQtdePg	:= 0
Private _nVlrPg		:= 0
Private _nQtdeB2	:= 0
Private _nVlrB2		:= 0
Private _nDiv		:= 0
Private _nDiverg	:= 0   
Private _nCont		:= 0 
Private _nPrUnit	:= 0 

Private _nQtdeCoT	:= 0
Private _nVlrCoT	:= 0
Private _nQtdeB6T	:= 0
Private _nVlrB6T	:= 0
Private _nQtdeB2T	:= 0
Private _nVlrB2T	:= 0
Private _nQtdePgT	:= 0
Private _nVlrPgT	:= 0     

Private _nVlrUnit	:= 0
Private _nQtdAux	:= 0 
Private _nQtdBx		:= 0	
Private _lFaz		:= .T.
Private _lInclui	:= .T.	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...        1                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)       
fErase(__RelDir + wnrel + '.##r')

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _cFornece	:= Space(6)

cQuery	:= " SELECT DISTINCT(B6_PRODUTO), B1_DESC, B1_CODBAR, B6_CLIFOR, B6_LOJA, B6_EMISSAO, B6_DOC, B6_SERIE, B6_QUANT, B6_SALDO, ZB_NUMFEC, "
//cQuery	+= " 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, "
cQuery	+= " 'PRECO' = ROUND(B6_PRUNIT,4), "
cQuery	+= " ZB_VENDAS, ZB_ESTOQUE, ZB_QTDPAG, "
cQuery	+= " 'VLRQTDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_QUANT*(B6_CUSTO1/B6_QUANT),4) ELSE ROUND(B6_QUANT*B6_PRUNIT,4) END,
cQuery	+= " 'VLRSLDSB6' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_SALDO*(B6_CUSTO1/B6_QUANT),4) ELSE ROUND(B6_SALDO*B6_PRUNIT,4) END
cQuery	+= " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)" 

cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON B6_PRODUTO 			= B1_COD 				AND SB1.D_E_L_E_T_ = '' "
cQuery	+= " INNER JOIN "+RetSqlName("SZB")+" SZB (NOLOCK) ON B6_FILIAL+B6_PRODUTO	= ZB_FILIAL+ZB_PRODUTO	AND SZB.D_E_L_E_T_ = '' "

cQuery	+= " WHERE "
cQuery	+= " B6_FILIAL 			= '"+xFilial("SB6")+"' AND "
cQuery	+= " ZB_NUMFEC 			BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "  
cQuery	+= " ZB_QTDPAG 			> 0 AND "
cQuery	+= " B6_CLIFOR 			= ZB_FORNECE AND "
cQuery	+= " B6_LOJA 			= ZB_LOJA AND "
cQuery	+= " B6_PODER3 			= 'R' AND "
cQuery	+= " B6_ATEND 			<> 'S' AND "   
cQuery	+= " SB6.D_E_L_E_T_ 	= '' "
//cQuery	+= " ORDER BY B1_DESC, B6_EMISSAO "
cQuery	+= " ORDER BY ZB_NUMFEC, B1_DESC, B6_EMISSAO "

Memowrite("FATR013.SQL",cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .F., .T.)  

SetRegua(RecCount())

DbSelectArea("TRB")
TRB->(DbGoTop())
While !TRB->(Eof())
	_cFornece	:= TRB->B6_CLIFOR
	_cLoja		:= TRB->B6_LOJA
	_cProduto	:= TRB->B6_PRODUTO        
	_cNumFec	:= TRB->ZB_NUMFEC

	While !TRB->(Eof()) .And. TRB->ZB_NUMFEC == _cNumFec 

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		While !TRB->(Eof()) .And. _cProduto == TRB->B6_PRODUTO .And. _cNumFec == TRB->ZB_NUMFEC  
   
			_nCont++
   
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				@nLin,00 PSAY "Acerto: "+TRB->ZB_NUMFEC 
				nLin++
				@nLin,00 PSAY _cFornece +"-"+ _cLoja+" - "+Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,Substr("A2_NOME",1,30))
				nLin := nLin+2 
			Endif
 
			@nLin,00 PSAY TRB->B1_CODBAR
			@nLin,21 PSAY Substr(TRB->B1_DESC,1,30)
			@nLin,53 PSAY TRB->B6_DOC    
			@nLin,63 PSAY Substr(TRB->B6_EMISSAO,7,2)+"/"+Substr(TRB->B6_EMISSAO,5,2)+"/"+Substr(TRB->B6_EMISSAO,1,4)    		
			//@nLin,73 PSAY TRB->B6_PRUNIT   	Picture "@E 999,999,999.99"        
			@nLin,73 PSAY TRB->PRECO   			Picture "@E 999,999,999.99"        
			//@nLin,108 PSAY TRB->B6_QUANT  	Picture "@E 999,999,999.99"        
			//@nLin,122 PSAY TRB->VLRQTDSB6 	Picture "@E 999,999,999.99"        
			//@nLin,136 PSAY TRB->B6_SALDO   	Picture "@E 999,999,999.99"   
			//@nLin,150 PSAY TRB->VLRSLDSB6		Picture "@E 999,999,999.99" 	
			//@nLin,89 PSAY TRB->B6_SALDO   	Picture "@E 999,999,999.99"   
			//@nLin,105 PSAY TRB->VLRSLDSB6		Picture "@E 999,999,999.99" 	
	
			//If _nCont = 1     
				//_nB2CM1 := Posicione("SB2",1,xFilial("SB2")+TRB->B6_PRODUTO,"B2_CM1")
				//@nLin,138 PSAY TRB->ZB_ESTOQUE     Picture "@E 999,999,999.99"   
				//@nLin,152 PSAY Round(TRB->ZB_ESTOQUE*_nB2CM1,2)     Picture "@E 999,999,999.99" 
			//EndIf	
				
			_nQtdeCo	:= _nQtdeCo + TRB->B6_QUANT
			_nVlrCo		:= _nVlrCo  + TRB->VLRQTDSB6
			_nQtdeB6	:= _nQtdeB6 + TRB->B6_SALDO
			_nVlrB6		:= _nVlrB6  + TRB->VLRSLDSB6
			//_nPrUnit	:= TRB->B6_PRUNIT
			_nPrUnit	:= TRB->PRECO
			
			//If _nCont = 1
				//_nB2CM1 := Posicione("SB2",1,xFilial("SB2")+TRB->B6_PRODUTO,"B2_CM1")
				//_nQtdeB2	:= _nQtdeB2 + TRB->ZB_ESTOQUE
				//_nVlrB2		:= Round(_nQtdeB2*_nB2CM1,2)
			//EndIf	
			
			//_nQtdePg	:= TRB->ZB_VENDAS - TRB->Z9_QUANT
			_nQtdePg	:= TRB->ZB_QTDPAG 
			
			_nDiverg	+= _nDiv
			_nDiv := 0
	
			nLin++  
	
			TRB->(DbSkip())
	
		EndDo

		_nCont := 0
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		If Select("TMPSB6") > 0
			DbSelectArea("TMPSB6")
			DbCloseArea()			
		EndIf
   
		//cQuery1 := " SELECT B6_DOC, B6_SERIE, B6_IDENT, B6_PRUNIT, B6_SALDO " 
		cQuery1	:= " SELECT B6_DOC, B6_SERIE, B6_IDENT, 'PRECO' = CASE WHEN B6_CUSTO1 > 0 THEN ROUND(B6_CUSTO1/B6_QUANT,4) ELSE ROUND(B6_PRUNIT,4) END, B6_SALDO "
		cQuery1 += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
		cQuery1 += " WHERE "
		cQuery1 += " B6_FILIAL 		= '"+xFilial("SB6")+"' 	AND "
		cQuery1 += " B6_PRODUTO 	= '"+_cProduto+"' 		AND "
		cQuery1 += " B6_CLIFOR 		= '"+_cFornece+"' 		AND " 
		cQuery1 += " B6_LOJA 		= '"+_cLoja+"' 			AND " 			
		cQuery1 += " B6_PODER3 		= 'R' AND B6_SALDO > 0 	AND "
		cQuery1 += " SB6.D_E_L_E_T_ = '' "
		cQuery1 += " ORDER BY B6_EMISSAO "

		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMPSB6", .F., .T.) 
			
		DbSelectArea("TMPSB6") 
		TMPSB6->(DbGoTop())
		If TMPSB6->(!Eof()) 
			_nQtdAux := _nQtdePg
			While !TMPSB6->(Eof()) .And. _lFaz 
		
				If _nQtdAux <= TMPSB6->B6_SALDO
					_nQtdBx	:= _nQtdAux
					_lFaz	:= .F.
					_lInclui:= .T.		
				Else
					_nQtdBx	:= TMPSB6->B6_SALDO
					_nQtdAux-= _nQtdBx  
				EndIf 
					
				//_nVlrUnit	:= Round(TMPSB6->B6_PRUNIT,4)
				_nVlrUnit	:= Round(TMPSB6->PRECO,4)
				_nVlrPg		+=	Round((_nQtdBx * _nVlrUnit),4)  
				
			 	TMPSB6->(DbSkip())
		
			EndDo 
			
			_lFaz := .T. 
			
		EndIf		
		
		@nLin,00 PSAY "Total: " 
		
		//@nLin,108 PSAY _nQtdeCo  		Picture "@E 999,999,999.99"        
		//@nLin,122 PSAY _nVlrCo 		Picture "@E 999,999,999.99"        

		//@nLin,136 PSAY _nQtdeB6   	Picture "@E 999,999,999.99"   
		//@nLin,150 PSAY _nVlrB6    	Picture "@E 999,999,999.99"             

		//@nLin,138 PSAY _nQtdeB2   	Picture "@E 999,999,999.99"   
		//@nLin,152 PSAY _nVlrB2    	Picture "@E 999,999,999.99"             
		
		@nLin,89 PSAY _nQtdePg   		Picture "@E 999,999,999.99"        
		@nLin,105 PSAY _nVlrPg  		Picture "@E 999,999,999.99"

		/*
		If _nQtdeB2 > _nQtdeB6
			@nLin,166 PSAY 0   			Picture "@E 999,999,999.99"        
			@nLin,180 PSAY 0  			Picture "@E 999,999,999.99"
		Else
			@nLin,166 PSAY _nQtdePg   	Picture "@E 999,999,999.99"        
			@nLin,180 PSAY _nVlrPg  	Picture "@E 999,999,999.99"
		EndIf
		*/
	
		nLin := nLin+1
		@nLin,000 PSAY __PrtThinLine()                                                                                                     
	
		_nQtdeCoT	+= _nQtdeCo 
		_nVlrCoT	+= _nVlrCo
		_nQtdeB6T	+= _nQtdeB6
		_nVlrB6T	+= _nVlrB6
		_nQtdeB2T	+= _nQtdeB2
		_nVlrB2T	+= _nVlrB2
		_nQtdePgT	+= _nQtdePg
		_nVlrPgT	+= _nVlrPg

		_nQtdeCo	:= 0
		_nVlrCo		:= 0
		_nQtdeB6	:= 0
		_nVlrB6		:= 0
		_nQtdeB2	:= 0
		_nVlrB2		:= 0
		_nQtdePg	:= 0
		_nVlrPg		:= 0
		_nDiverg	:= 0
		_nPrUnit	:= 0
		_nVlrUnit	:= 0
	
		_cProduto := TRB->B6_PRODUTO
	
		nLin++
	
	   //TRB->(DbSkip()) // Avanca o ponteiro do registro no arquivo						  	
	EndDo

	@ nLin++,000 PSAY __PrtThinLine()

	
	@nLin,00 PSAY "Total Geral: "
	//@nLin,108 PSAY _nQtdeCoT  	Picture "@E 999,999,999.99"        
	//@nLin,122 PSAY _nVlrCoT 		Picture "@E 999,999,999.99"        

	//@nLin,136 PSAY _nQtdeB6T    	Picture "@E 999,999,999.99"   
	//@nLin,150 PSAY _nVlrB6T    	Picture "@E 999,999,999.99"             

	//nLin,138 PSAY _nQtdeB2T    	Picture "@E 999,999,999.99"   
	//@nLin,152 PSAY _nVlrB2T    	Picture "@E 999,999,999.99"             

	@nLin,89 PSAY _nQtdePgT  		Picture "@E 999,999,999.99"        
	@nLin,105 PSAY _nVlrPgT  		Picture "@E 999,999,999.99"

	_nQtdeCoT	:= 0
	_nVlrCoT	:= 0
	_nQtdeB6T	:= 0
	_nVlrB6T	:= 0
	_nQtdeB2T	:= 0
	_nVlrB2T	:= 0
	_nQtdePgT	:= 0
	_nVlrPgT	:= 0

	nLin := 80

EndDo

DbSelectArea("TRB")
DbCloseArea("TRB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return