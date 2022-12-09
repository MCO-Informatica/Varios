#Include "Rwmake.ch"             
#Include "Protheus.ch"             
#Include "topconn.ch"                                                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR006  บAutor  ณEduardo Antunes     บ Data ณ  01/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio rastreamento do lote referente ao produto acabado บฑฑ
																		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Protheus 11                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR006

oFont2     := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont4     := TFont():New( "Courier New",,08,,.f.,,,,,.f. )
oFont3     := TFont():New( "Courier New",,09,,.f.,,,,,.f. )
 
                                                                
Private oDlg
Private aCA       :={OemToAnsi("Confirma"),OemToAnsi("Abandona")} // "Confirma", "Abandona"
Private cCadastro := OemToAnsi("Relatorio rastreamento do lote acabado ")
Private aSays:={}, aButtons:={}
Private nOpca     := 0
Private _nQtde    := 0    
Private _nAcum    := 0  
Private _lVerPi   := .F.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn    := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 } // ###
Private nLastKey   := 0
Private cPerg      := "RFATR006"
Private _aMat := {}


ValidPerg()

Pergunte(cPerg,.F.)

_cProd := MV_PAR09

//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aSays,OemToAnsi( "  Este programa ira imprimir o rastreamento do lote acabado "))
AADD(aSays,OemToAnsi( "obedecendo os parametros escolhidos pelo cliente.          "))

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1
	Processa( { |lEnd| Imprel() })
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMREL     บAutor  ณEduardo Antunes       ณ  01/01/13        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao da Relatorio Necessidade                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso                                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprel()

	Local ic
	Local ai
	Local ib
	Local nHeight:=15
	Local lBold:= .F.
	Local lUnderLine:= .F.
	Local lPixel:= .T.
	Local lPrint:=.F.	
	Local nPag:=0
	Local nLin:= 0
	Local cPeriodo
	Local nI , nHoras , dData
	Private lContinua:= .T.
	Private _nVez := 1  
	Private _nVeza := 1 
	Private	_nQtdori := 0
	Private oPrn:=TMSPrinter():New()
	Private _nLin := 0 
	Private _dDatFab := ""
	
	// DEFINICAO REFERENTE AO FONTE RPCPR116
	
	Private _nQtdPr := 0 // quantidade produzida 
	Private _cProd := ""
	Private _cLote := ""
	Private _cDescPr := ""      
	Private _cDia
	Private _cMes 
	Private _cAno 
	Private _cOP 
	Private _nQtdEst := 0
	Private _nQtdUt  := 0 
	Private _cDocEnt := ""                                       
	Private _nCalcEs := 0   
	Private _nPag := 0 
    Private _nCalOri := 0 
	Private _cLoteFa := "" 
	Private _cUM  := ""
	
	Private _cNumNf := ""
	Private _cSerNf := ""  
	Private _nCalcPa := 0    
	Private _nQtdFat := 0  
	Private _cClient := ""
	Private _cLoja := ""      
	Private _aColeta := {}   
	Private _cItemcgr := ""  
	Private _cGrad    := ""
	
	Private	_cFornece := ""
//	Private	_cLoja    := ""
	Private _aCab := {}
	Private _aEns := {} 
	Private _aNota := {}
	
	Private _cEnsP := ""    
	Private	_cEns       := ""
	Private	_cDeso      := ""
	
	Private _nCol  := 0 
	Private _nCont := 0		 
	
//	Private _cLote := ""
	Private _lVer := .F.
//	Private _nVeza := 1         
	Private _nVezb := 1 
	Private _cDeProd := ""	 
	       
	Private _nVezOp := 1  
	
	Private _nCalLote := 0
	
	
	Private _aOp := {}	
		                     
	nHeight    :=15
	lBold      := .F.
	lUnderLine := .F.
	lPixel     := .T.               
	lPrint     :=.F.
	nSedex     := 1

	        //              1-NF         2-SERIE          3-CODCLI          4-LOJACLI                5-NOME CLI                                                         6-QUANTIDADE
	        //AADD(_aNota,{TSD2X->D2_DOC,TSD2X->D2_SERIE,TSD2X->D2_CLIENTE,TSD2X->D2_LOJA,Posicione("SA1",1,xFilial("SA1")+TSD2X->D2_CLIENTE+TSD2X->D2_LOJA,"A1_NOME"),TSD2X->D2_QUANT)
		
    QrkY := "SELECT D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_QTDAFAT,D2_QTDEFAT,D2_QUANT,D2_OP " 
	QrkY += "FROM  " + RetSQLName("SD2") + " SD2 "  
	QrkY += " WHERE SD2.D2_FILIAL  = '" + xFilial("SD2") + "'  AND "
	QrkY += "       SD2.D2_CLIENTE   >= '" + MV_PAR01 + "'   AND " 
	QrkY += "       SD2.D2_CLIENTE   <= '" + MV_PAR02 + "'   AND " 
	QrkY += "       SD2.D2_LOJA      >= '" + MV_PAR03 + "'   AND " 
	QrkY += "       SD2.D2_LOJA      <= '" + MV_PAR04 + "'   AND " 
	QrkY += "       SD2.D2_DOC       >= '" + MV_PAR05 + "'   AND " 
	QrkY += "       SD2.D2_DOC       <= '" + MV_PAR06 + "'   AND " 
	QrkY += "       SD2.D2_SERIE   	 >= '" + MV_PAR07 + "'   AND " 
	QrkY += "       SD2.D2_SERIE     <= '" + MV_PAR08 + "'   AND " 
	QrkY += "       SD2.D2_COD       = '" + MV_PAR09 + "'   AND " 
	QrkY += "       SD2.D2_LOTECTL   = '" + SUBSTRING(MV_PAR10,12,8) + "'   AND " 
	QrkY += "       SD2.D2_TIPO      = 'N'   AND "   
	QrkY += "	    SD2.D_E_L_E_T_ = ' '  "	   
	QrkY += "GROUP BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_QTDAFAT,D2_QTDEFAT,D2_QUANT,D2_OP " 
	QrkY += "ORDER BY  D2_LOTECTL "
	QrkY := ChangeQuery(QrkY)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrkY),"TSD2X",.F.,.T.)
	
	DbSelectArea("TSD2X")     
	
	While !EOF()       
		
		_lVer := .T.  
		
		
		
 		QrkXY := "SELECT * " 
		QrkXY += "FROM  " + RetSQLName("SC2") + " SC2 "  
		QrkXY += " WHERE SC2.C2_FILIAL    = '" + xFilial("SC2") + "'  AND " 
		QrkXY += "       SC2.C2_NUM      = '" + SUBSTRING(MV_PAR10,1,6) + "'   AND "  
		//QrkXY += "       SC2.C2_ITEM     = '" + SUBSTRING(MV_PAR10,7,2) + "'   AND "    
		//QrkXY += "       SC2.C2_SEQUEN   = '" + SUBSTRING(MV_PAR10,9,3) + "'   AND "	  
		QrkXY += "       SC2.C2_PRODUTO   = '" + TSD2X->D2_COD + "'   AND " 
		QrkXY += "       SC2.C2_LOTECTL   = '" + TSD2X->D2_LOTECTL + "'   AND "		 
		QrkXY += "	    SC2.D_E_L_E_T_ = ' '  "	   
		QrkXY := ChangeQuery(QrkXY)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrkXY),"TXD2X",.F.,.T.)
		
		DbSelectArea("TXD2X")     
				
		If !EOF()
			_dDatFab := substr(TXD2X->C2_EMISSAO,7,2)+"/"+substr(TXD2X->C2_EMISSAO,5,2)+"/"+substr(TXD2X->C2_EMISSAO,1,4)
		Endif              
		TXD2X->(DbCloseArea())
	
		
		_cLote := TSD2X->D2_LOTECTL
		_cAno := substr(TSD2X->D2_DTVALID,1,4)
		_cMes := substr(TSD2X->D2_DTVALID,5,2)
		_cDia := substr(TSD2X->D2_DTVALID,7,2)    
		
		// QUANTIDADE EM ESTOQUE  REFERENTE AO PRODUTO ACABADO 
		Qrwy := " "   
		Qrwy := "SELECT B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 
		Qrwy += "FROM  " + RetSQLName("SB8") + " SB8 "
		Qrwy += " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "'	AND "
		Qrwy += "       SB8.B8_PRODUTO  = '" + TSD2X->D2_COD + "'   AND"   
		Qrwy += "       SB8.B8_LOCAL    =  '" + TSD2X->D2_LOCAL + "'   AND" 
		Qrwy += "       SB8.B8_LOTECTL  =  '" + TSD2X->D2_LOTECTL + "'   AND" 
		Qrwy += "   	SB8.D_E_L_E_T_ = ' ' 		    				"
		Qrwy += "GROUP BY B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 						
		Qrwy := ChangeQuery(Qrwy)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qrwy),"TXSB8",.F.,.T.)  
			
			
		DbSelectArea("TXSB8")
							
		If !EOF() 
				_nCalLote := TXSB8->B8_SALDO - TXSB8->B8_EMPENHO						
		Endif
	   	TXSB8->(DbCloseArea())                                                           
			                                                                        
	    
		If _nVez = 1 
			_nPag := _nPag + 1 
			cabec1()
			cabec2(_cAno,_cDia,_cMes,_cLote,_dDatFab,_nCalLote)
			cabec3() 
			_nVez := 2
		Endif         
		If _nLin > 2100       
			_nPag := _nPag + 1
			cabec1()
			cabec2(_cAno,_cDia,_cMes,_cLote,_dDatFab)
			cabec3()	
		Endif     
		
		_nLin := _nLin + 0040
		oPrn:Say( _nLin,0040,TSD2X->D2_DOC,oFont2,100) // NUMERO DA NOTA FISCAL 
   		oPrn:Say( _nLin,0500,TSD2X->D2_SERIE,oFont2,100)  // SERIE DA NOTA FISCAL 
   		oPrn:Say( _nLin,0700,Posicione("SA1",1,xFilial("SA1")+TSD2X->D2_CLIENTE+TSD2X->D2_LOJA,"A1_NOME"),oFont2,100) // NOME DO CLIENTE 
   		oPrn:Say(_nLin,1400,transform(TSD2X->D2_QUANT,"@E 99,9999.999"),oFont2,100)  // QUANTIDADE FATURADA
		_nLin := _nLin + 0040  
		
		_nAcum := _nAcum + TSD2X->D2_QUANT  
		
	   DbSelectArea("TSD2X")     
	   DbSkip()  	
	Enddo                 
	TSD2X->(DbCloseArea())  
	
	_nLin := _nLin + 0040
	oPrn:Say(_nLin,0040,"Total Faturado ----->",oFont2,100)  // QUANTIDADE FATURADA
	oPrn:Say(_nLin,2000,transform(_nAcum,"@E 99,9999.999"),oFont2,100)  // QUANTIDADE FATURADA
	_nLin := _nLin + 0100  
	oPrn:Box(_nLin,0040,_nLin,2500)
				
	  	
	If _lVer  
	                                 
		Qrk := "SELECT C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_PRODUTO,C2_LOCAL,C2_QUANT,C2_EMISSAO,C2_QUJE,C2_LOTECTL,C2_DTVALID,C2_LOTECTL,C2_GRADE " 
		Qrk += "FROM  " + RetSQLName("SC2") + " SC2 "  
		Qrk += " WHERE SC2.C2_FILIAL  = '" + xFilial("SC2") + "'  AND "             
		Qrk += "       SC2.C2_NUM      = '" + SUBSTRING(MV_PAR10,1,6) + "'   AND "  
		//Qrk += "       SC2.C2_ITEM     = '" + SUBSTRING(MV_PAR10,7,2) + "'   AND "    
		//Qrk += "       SC2.C2_SEQUEN   = '" + SUBSTRING(MV_PAR10,9,3) + "'   AND "
		//Qrk += "       SC2.C2_PRODUTO     =  '" + MV_PAR09 + "'   AND" 
		//Qrk += "       SC2.C2_PRODUTO     <= '" + TSD2X->D2_COD + "'   AND" 
		Qrk += "       SC2.C2_LOTECTL     = '" + SUBSTRING(MV_PAR10,12,8) + "'   AND" 
		//Qrk += "       SC2.C2_LOTECTL     <= '" + TSD2X->D2_LOTECTL + "'   AND" 	
		Qrk += "	   SC2.D_E_L_E_T_ = ' ' "
		Qrk += "GROUP BY C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_PRODUTO,C2_LOCAL,C2_QUANT,C2_EMISSAO,C2_QUJE,C2_LOTECTL,C2_DTVALID,C2_LOTECTL,C2_GRADE "
		Qrk += "ORDER BY  C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_EMISSAO "
		Qrk := ChangeQuery(Qrk)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qrk),"QRX",.F.,.T.)
			
		DbSelectArea("QRX")
				
	    While !EOF()                                                                                                     
	    
	    
	     
			// QUANTIDADE EM ESTOQUE  REFERENTE AO PRODUTO ACABADO 
		   
			Qrwy := "SELECT B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 
			Qrwy += "FROM  " + RetSQLName("SB8") + " SB8 "
			Qrwy += " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "'	AND "
			Qrwy += "       SB8.B8_PRODUTO  = '" + QRX->C2_PRODUTO + "'   AND"   
			Qrwy += "       SB8.B8_LOCAL    =  '" + QRX->C2_LOCAL + "'   AND" 
			Qrwy += "       SB8.B8_LOTECTL  =  '" + QRX->C2_LOTECTL + "'   AND" 
			Qrwy += "   	SB8.D_E_L_E_T_ = ' ' 		    				"
			Qrwy += "GROUP BY B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 						
			Qrwy := ChangeQuery(Qrwy)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qrwy),"TSB8",.F.,.T.)  
			
			
			DbSelectArea("TSB8")
							
			If !EOF() 
				_nCalcPa := TSB8->B8_SALDO - TSB8->B8_EMPENHO						
			Endif
	   		TSB8->(DbCloseArea())                                                           
			
			
			//If _nVezOp = 1

				  	
			 //Endif

         		//                1                2          3                4           5           6             7               8           9               10           11         12
		    AADD(_aOp,{QRX->C2_PRODUTO,QRX->C2_LOCAL,QRX->C2_LOTECTL,QRX->C2_NUM,QRX->C2_ITEM,QRX->C2_SEQUEN,QRX->C2_ITEMGRD,QRX->C2_GRADE,QRX->C2_DTVALID,QRX->C2_QUANT,QRX->C2_QUJE,_nCalcPa}) 
           
	    	
	    	DbSelectArea("QRX")
		    DbSkip()
	    	
	    Enddo	         
	    QRX->(DbCloseArea())
	        
		For ai:=1 to Len(_aOp)		
			
			_cAno := substr(_aOp[ai][9],1,4)
			_cMes := substr(_aOp[ai][9],5,2)
			_cDia := substr(_aOp[ai][9],7,2)                                                                            
	    	_cProd := _aOp[ai][1]
		   	_cLote := _aOp[ai][3] 
			_cNum  := _aOp[ai][4]
			_cItem := _aOp[ai][5]
			_cSeq  := _aOp[ai][6]
			_cItemcgr := _aOp[ai][7]  
			_cGrad    := _aOp[ai][8]
			
			//alert( _cNum+_cItem+_cSeq)
			 
			_aCab := {}
			AADD(_aCab,{_cNum,_cItem,_cSeq,_cItemcgr,_cProd,_cLote,_cGrad,_aOp[ai][9]}) 
			
			If _nVezOp = 1 .or. _aOp[ai][6] = "002"
		 
				_nLin := _nLin + 0040 
				
				oPrn:Say( _nLin,0040, "Numero O.P. :"+" "+alltrim(_aOp[ai][4]+_aOp[ai][5]+_aOp[ai][6]),oFont2,100) // Numero da Ordem de Producao  
		   		oPrn:Say( _nLin,0600, "Quantidade da OP :"+" "+transform(_aOp[ai][10],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao  
		  		oPrn:Say( _nLin,1200, "Quantidade Produzida :"+" "+transform(_aOp[ai][11],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao
		 		oPrn:Say( _nLin,2000, "Saldo Lote Estoque :"+" "+transform(_aOp[ai][12],"@E 9999.999"),oFont2,100) // campo da SB8 QTD ESTOQUE  
		 		_nLin := _nLin + 0040  
		 	
		 		_nVezOp := 2         
		 		
		 	Endif 
		 	
		 	
		 
		 	/*	 
			Qry := "* " 
			Qry += "FROM  " + RetSQLName("SD4") + " SD4 "
			Qry += " WHERE SD4.D4_FILIAL  = '" + xFilial("SD4") + "'	AND "
			Qry += "       SD4.D4_OP = '" + _aOp[ai][4]+_aOp[ai][5]+_aOp[ai][6] + "'   AND"              
			//Qry += "       substring(SD4.D4_OP,1,6) = '" + _aOp[ai][4] + "'   AND"             
			Qry += "	   SD4.D_E_L_E_T_ = ' ' 		    				"
			Qry := ChangeQuery(Qry)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qry),"QRs",.F.,.T.)  
			*/
			
			Qry := "SELECT D4_COD,D4_LOCAL,D4_LOTECTL,D4_QUANT,D4_QTDEORI " 
			Qry += "FROM  " + RetSQLName("SD4") + " SD4, "          
		    Qry += "      " + RetSQLName("SB1") + " SB1  "          
			Qry += " WHERE SD4.D4_FILIAL  = '" + xFilial("SD4") +  "'    	AND "    
			//Qry +=" SUBSTRING(SD4.D4_OP,1,6) = '" + _aOp[ai][4] + "'  AND "     
			Qry +=" SD4.D4_OP = '" + _aOp[ai][4] +_aOp[ai][5]+_aOp[ai][6] + "'  AND "  
			Qry +=" D4_COD = B1_COD       AND " 
			Qry += "	SD4.D_E_L_E_T_ = ' '	 "
			Qry += "GROUP BY D4_COD,D4_LOCAL,D4_LOTECTL,D4_QUANT,D4_QTDEORI "
			Qry += "  ORDER BY SD4.D4_COD,D4_LOTECTL "          
			Qry := ChangeQuery(	Qry)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,	Qry),"QRs",.F.,.T.)
			
			
			DbSelectArea("QRs")            
			While !EOF()      
			
			     //                    1- descricao do produto                               unidade de medida 2                              codprod3           unidade 4                                      local 5       lote 6           cod Pa 7   qtd op 8   qtdori mat9      qtd mat 10    data fab 11  num op12    item op13     seq op14
			     AADD(_aMat,{POSICIONE("SB1",1,xFilial("SB1")+QRs->D4_COD,"B1_DESC"),POSICIONE("SB1",1,xFilial("SB1")+QRs->D4_COD,"B1_UM"),QRs->D4_COD,POSICIONE("SB1",1,xFilial("SB1")+QRs->D4_COD,"B1_UM"),QRs->D4_LOCAL,QRs->D4_LOTECTL,_aOp[ai][1],_aOp[ai][10],QRs->D4_QTDEORI,QRs->D4_QUANT,_aOp[ai][9],_aOp[ai][4],_aOp[ai][5],_aOp[ai][6]})
				DbSelectArea("QRs")            
				DbSkip()
			Enddo    
			QRs->(DbCloseArea())
		Next
		
					                   
		If _nVeza = 1    
			    
			
			
				_nPag := _nPag + 1  
			   
			    //For ib:=1 to len(_aOp)   
			    
					
	 		    //Next  
	 		    
	 		    _nLin := _nLin + 0040 
				oPrn:Box(_nLin,0040,_nLin,2500)
			   	_nLin := _nLin + 0080
			   	oPrn:Say( _nLin,0040, "Materia Prima ",oFont2,100) //codigo materia prima 
			   	oPrn:Say( _nLin+0030,0040, "Descricao",oFont2,100) //Descricao Materia Prima
			   	oPrn:Say( _nLin,0650, "UM",oFont2,100) //UNIDADE DE MEDIDA
			   	oPrn:Say( _nLin,0750, "Armaz.",oFont2,100) //Lote    
				oPrn:Say( _nLin+0030,0750, "Lote",oFont2,100) //Armazem 
				oPrn:Say( _nLin,0900, "Qtd Util.",oFont2,100) //Quantidade Utilizada
 				oPrn:Say( _nLin,1200, "Dta Valid.",oFont2,100) //data validade do lote 
				oPrn:Say( _nLin,1450, "Nfe Compras",oFont2,100) //Nota fiscal de compras  
				oPrn:Say( _nLin,1700, "Lote Fabr.",oFont2,100) //Lote Fabricante 
				oPrn:Say( _nLin,2100, "Saldo Atual",oFont2,100) //Saldo Atual 
				oPrn:Say( _nLin,2400, "Fornecedor",oFont2,100) //Saldo Atual  
				_nLin := _nLin + 0080 
				
				_nVeza := 2
			Endif         
			
			For ic:=1 to Len(_aMat)    
			                        
				
				
				// VERIFICA SE O PRODUTO NAO E UM PI
				
				Qry := " " 
				Qry := "SELECT * " 
				Qry += "FROM  " + RetSQLName("SB1") + " SB1 "
				Qry += " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "'	AND "
				Qry += "       SB1.B1_COD     = '" + _aMat[ic][3] + "'	    AND " 
				Qry += "       SB1.B1_TIPO    NOT IN ('PA','PI')     	    AND " 						
				Qry += "	   SB1.D_E_L_E_T_ = ' ' 		    				"
				Qry := ChangeQuery(Qry)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qry),"QRAs",.F.,.T.)
						    
				DbSelectArea("QRAs")            
					
				If !EOF() 
				
					If _nLin > 2100       
					
						cabec1() 
						
						// caso exista PI na Impressao 
						
						If _lVerPi
						_nLin := _nLin + 0040 
						Endif
						                        
					    For ib:=1 to len(_aOp)   
			    
							_nLin := _nLin + 0040 
							oPrn:Say( _nLin,0040, "Numero O.P. :"+" "+alltrim(_aOp[ib][4]+_aOp[ib][5]+_aOp[ib][6]),oFont2,100) // Numero da Ordem de Producao  
			   				oPrn:Say( _nLin,0600, "Quantidade da OP :"+" "+transform(_aOp[ib][10],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao  
			  				oPrn:Say( _nLin,1200, "Quantidade Produzida :"+" "+transform(_aOp[ib][11],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao
			 				oPrn:Say( _nLin,2000, "Saldo Lote Estoque :"+" "+transform(_aOp[ib][12],"@E 9999.999"),oFont2,100) // campo da SB8 QTD ESTOQUE  
			 				_nLin := _nLin + 0040
			   				//
			   				
			 		    Next(ib)
						
						_nLin := _nLin + 0040
			   			
						oPrn:Box(_nLin,0040,_nLin,2500)
						//oPrn:Box( _nLin,0040,_nLin,2500)             //tracinho que separa iniciar o logo 
					   	_nLin := _nLin + 0080
					   	oPrn:Say( _nLin,0040, "Materia Prima ",oFont2,100) //codigo materia prima 
					   	oPrn:Say( _nLin+0030,0040, "Descricao",oFont2,100) //Descricao Materia Prima
					   	oPrn:Say( _nLin,0650, "UM",oFont2,100) //UNIDADE DE MEDIDA
					   	oPrn:Say( _nLin,0750, "Armaz.",oFont2,100) //Lote    
						oPrn:Say( _nLin+0030,0750, "Lote",oFont2,100) //Armazem 
						oPrn:Say( _nLin,0900, "Qtd Util.",oFont2,100) //Quantidade Utilizada
		 				oPrn:Say( _nLin,1200, "Dta Valid.",oFont2,100) //data validade do lote 
						oPrn:Say( _nLin,1450, "Nfe Compras",oFont2,100) //Nota fiscal de compras  
						oPrn:Say( _nLin,1700, "Lote Fabr.",oFont2,100) //Lote Fabricante 
						oPrn:Say( _nLin,2100, "Saldo Atual",oFont2,100) //Saldo Atual 
						oPrn:Say( _nLin,2400, "Fornecedor",oFont2,100) //Saldo Atual  
						_nLin := _nLin + 0080 
					
					Endif 
					  
				    _nLin := _nLin + 0040
				    
					
				   //	Alert ("OP")
				   //	Alert (_aMat[ic][12]+_aMat[ic][13]+_aMat[ic][14])
				   //	Alert ("produto")
				   //	Alert (_aMat[ic][3])
				   //	Alert ("lote")
				   //	Alert (_aMat[ic][6])
					
					oPrn:Say( _nLin,0040,_aMat[ic][3],oFont4,100) //produto 
					oPrn:Say( _nLin+0030,0040,_aMat[ic][1],oFont4,100) //Descricao do Produto  
					oPrn:Say( _nLin,0650,_aMat[ic][2],oFont4,100) //Unidade de Medida
					oPrn:Say( _nLin,0750,_aMat[ic][6],oFont4,100) //produto 
					oPrn:Say( _nLin+0030,0750,_aMat[ic][7],oFont4,100) //produto
				                     
				    
					// QUANTIDADE DA ESTRUTURA 
					QrGy := "SELECT * " 
				   	QrGy += "FROM  " + RetSQLName("SG1") + " SG1 "
					QrGy += " WHERE SG1.G1_FILIAL  = '" + xFilial("SG1") + "'	AND "
					QrGy += "       SG1.G1_COD     = '" + _aMat[ic][7]  + "'   AND"   
					QrGy += "       SG1.G1_COMP    = '" + _aMat[ic][3]      + "'   AND"
					QrGy += "	   SG1.D_E_L_E_T_ = ' ' 		    				"
					QrGy := ChangeQuery(QrGy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrGy),"xGQRs",.F.,.T.)  
					
					DbSelectArea("xGQRs")
							
					If !EOF() 
						_nQtdEst := xGQRs->G1_QUANT						
					Endif
				    xGQRs->(DbCloseArea())	
							
					// CALCULO DA QUANTIDADE ORIGINAL 
							
					If _aMat[ic][10] = 0 
					   _nCalcOri := _aMat[ic][10] * _nQtdEst
					Else                                    
					   _nCalcOri := _aMat[ic][09] - _aMat[ic][10]
							
					Endif                                                                                   
					
					//_aMat[ic][3]
					
					 
					// COLETA A DATA DE VALDADE DO LOTE 
					
					QrXSy := "   " 
					QrXSy := "SELECT * " 
				   	QrXSy += " FROM  " + RetSQLName("SB8") + " SB8 "
					QrXSy += " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "'	AND "
					QrXSy += "       SB8.B8_LOTECTL = '" + _aMat[ic][06]  + "'   AND"   
					QrXSy += "   	 SB8.D_E_L_E_T_ = ' ' 		    				"
				   	QrXSy := ChangeQuery(QrXSy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrXSy),"QRSB8",.F.,.T.)  
					
					DbSelectArea("QRSB8")
									
					If !EOF()
					 
						_cDia := substr(QRSB8->B8_DTVALID,7,2)
						_cMes := substr(QRSB8->B8_DTVALID,5,2)
						_cAno := substr(QRSB8->B8_DTVALID,1,4)						
					
					Endif
				    QRSB8->(DbCloseArea())     
					
									
					_nQtdUt := _aMat[ic][09] - _aMat[ic][10]
					//oPrn:Say( _nLin+0030,1050,transform(_nCalcOri,"@E 99,9999.999"),oFont4,100) //Quantidade da estrutura SG1                                           
					oPrn:Say( _nLin+0030,0930,transform(_nQtdUt,"@E 99,9999.999"),oFont4,100) //QUANTIDADE DE origem
					//_cDia := substr(_aMat[ic][11],7,2)
					//_cMes := substr(_aMat[ic][11],5,2)
					//_cAno := substr(_aMat[ic][11],1,4)						
					oPrn:Say( _nLin+0030,1200,_cDia+"/"+_cMes+"/"+_cAno,oFont4,100) //data de validade 
			   
				  //                    1- descricao do produto                               unidade de medida 2                              codprod3           unidade 4                                      local 5       lote 6           cod Pa 7   qtd op 8   qtdori mat9      qtd mat 10     data fab 11
			   	
										
					QrDy := "SELECT D1_DOC,D1_LOTEFOR,D1_FORNECE,D1_LOJA,B1_TIPO,B1_COD " 
				   	QrDy += "FROM  " + RetSQLName("SD1") + " SD1, " 
				   	QrDy += "      " + RetSQLName("SB1") + " SB1 " 
				 	QrDy += " WHERE SD1.D1_FILIAL  = '" + xFilial("SD1") + "'	AND "
					QrDy += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "'	AND "
					QrDy += "       SD1.D1_COD     = '" + _aMat[ic][03]  + "'   AND "   
					QrDy += "       SD1.D1_LOTECTL = '" + _aMat[ic][06]   + "'   AND "     
					QrDy += "       SD1.D1_COD     = SB1.B1_COD    AND "  
					QrDy += "	    SD1.D_E_L_E_T_ = ' '            AND "
					QrDy += "	    SB1.D_E_L_E_T_ = ' ' 
					QrDy += "GROUP BY D1_DOC,D1_LOTEFOR,D1_FORNECE,D1_LOJA,B1_TIPO,B1_COD	"
					QrDy := ChangeQuery(QrDy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrDy),"DQRs",.F.,.T.) 
									
					DbSelectArea("DQRs")
				
					IF !EOF()               
						If DQRs->B1_TIPO <> "PA" .and. DQRs->B1_TIPO <> "PI"					
							_cDocEnt := DQRs->D1_DOC	 
							_cLoteFa := DQRs->D1_LOTEFOR 
							_cFornece := DQRs->D1_FORNECE
							_cLoja    := DQRs->D1_LOJA			
						Endif			
					Endif  
					DQRs->(DbCloseArea())
					oPrn:Say( _nLin+0030,1500,_cDocEnt,oFont4,100) //DOCUMENTO DE ENTRADA  
							
					// QUANTIDADE EM ESTOQUE  REFERENTE A MATERIA PRIMA  
					QrSy := "SELECT B2_QATU,B2_QEMP " 
				   	QrSy += "FROM  " + RetSQLName("SB2") + " SB2 "
					QrSy += " WHERE SB2.B2_FILIAL  = '" + xFilial("SB2") + "'	AND "
					QrSy += "       SB2.B2_COD     = '" + _aMat[ic][03]  + "'   AND"   
					QrSy += "       SB2.B2_LOCAL   = '" + _aMat[ic][05] + "'   AND"
					QrSy += "   	SB2.D_E_L_E_T_ = ' ' 		    				"
				   	QrSy += "GROUP BY B2_QATU,B2_QEMP						
					QrSy := ChangeQuery(QrSy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrSy),"SQRs",.F.,.T.)  
					
					DbSelectArea("SQRs")				
					
					If !EOF() 
						_nCalcEs := SQRs->B2_QATU 						
					Endif
				    SQRs->(DbCloseArea())     
						             
				    oPrn:Say( _nLin+0030,1700,_cLoteFa,oFont4,100) // LOTE FORNECEDOR 
				    oPrn:Say( _nLin+0030,2100,transform(_nCalcEs,"@E 99,9999.999"),oFont4,100) //CALCULO DO ESTOQUE REFERENTE A MATERIA PRIMA 
					oPrn:Say( _nLin+0030,2400,SUBSTR(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NOME"),1,15) ,oFont4,100) //NOME DO FORNECEDOR      
					    
					// inicializa as variaveis antunes 17/03/2015
					
					_cDocEnt  := ""	 
					_cLoteFa  := "" 
					_cFornece := ""
					_cLoja    := ""		
									
					_nLin := _nLin + 0080  
					_nVez := 1
				
				Else
				    
				    
					_lVerPi := .T. // indica que ira existir PI no layout de impressao 
				    
					If _nLin > 2100       
		
				
						cabec1() 
						For ib:=1 to len(_aOp)   
			    
							_nLin := _nLin + 0040 
							oPrn:Say( _nLin,0040, "Numero O.P.:"+alltrim(_aOp[ib][4]+_aOp[ib][5]+_aOp[ib][6]),oFont2,100) // Numero da Ordem de Producao  
			   				oPrn:Say( _nLin,0600, "Quantidade da OP :"+transform(_aOp[ib][10],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao  
			  				oPrn:Say( _nLin,1200, "Quantidade Produzida :"+transform(_aOp[ib][11],"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao
			 				oPrn:Say( _nLin,2000, "Saldo Lote Estoque :"+transform(_aOp[ib][12],"@E 9999.999"),oFont2,100) // campo da SB8 QTD ESTOQUE  
			 				_nLin := _nLin + 0040
			   				//oPrn:Box(_nLin,0040,_nLin,2500)
			   				
			 		    Next
	
						_nLin := _nLin + 0040
					   	oPrn:Box( _nLin,0040,_nLin,2500)             //tracinho que separa iniciar o logo 
					   	_nLin := _nLin + 0080
					   	oPrn:Say( _nLin,0040, "Materia Prima ",oFont2,100) //codigo materia prima 
					   	oPrn:Say( _nLin+0030,0040, "Descricao",oFont2,100) //Descricao Materia Prima
					   	oPrn:Say( _nLin,0650, "UM",oFont2,100) //UNIDADE DE MEDIDA
					   	oPrn:Say( _nLin,0750, "Armaz.",oFont2,100) //Lote    
						oPrn:Say( _nLin+0030,0750, "Lote",oFont2,100) //Armazem 
						oPrn:Say( _nLin,0900, "Qtd Util.",oFont2,100) //Quantidade Utilizada
		 				oPrn:Say( _nLin,1200, "Dta Valid.",oFont2,100) //data validade do lote 
						oPrn:Say( _nLin,1450, "Nfe Compras",oFont2,100) //Nota fiscal de compras  
						oPrn:Say( _nLin,1700, "Lote Fabr.",oFont2,100) //Lote Fabricante 
						oPrn:Say( _nLin,2100, "Saldo Atual",oFont2,100) //Saldo Atual 
						oPrn:Say( _nLin,2400, "Fornecedor",oFont2,100) //Saldo Atual  
						_nLin := _nLin + 0080 
					
					Endif   
				    
					//_cDeProd := POSICIONE("SB1",1,xFilial("SB1")+QRs->D4_COD,"B1_DESC")
					//_cUM   := POSICIONE("SB1",1,xFilial("SB1")+QRs->D4_COD,"B1_UM")
				    
				  //                    1- descricao do produto                               unidade de medida 2                              codprod3           unidade 4                                      local 5       lote 6           cod Pa 7   qtd op 8   qtdori mat9      qtd mat 10     data fab 11
			   	
						
					
					_nLin := _nLin + 0040
					
					oPrn:Say( _nLin,0040,_aMat[ic][03],oFont4,100) //produto 
					oPrn:Say( _nLin+0030,0040,_aMat[ic][01],oFont4,100) //Descricao do Produto  
					oPrn:Say( _nLin,0650,_aMat[ic][02],oFont4,100) //Unidade de Medida
					oPrn:Say( _nLin,0750,_aMat[ic][05],oFont4,100) //produto 
					oPrn:Say( _nLin+0030,0750,_aMat[ic][06],oFont4,100) //produto
		
	
			
				    
					// QUANTIDADE DA ESTRUTURA 
					QrGy := "SELECT * " 
				   	QrGy += "FROM  " + RetSQLName("SG1") + " SG1 "
					QrGy += " WHERE SG1.G1_FILIAL  = '" + xFilial("SG1") + "'	AND "
					QrGy += "       SG1.G1_COD     = '" + _aMat[ic][07]  + "'   AND"   
					QrGy += "       SG1.G1_COMP    = '" + _aMat[ic][03]  + "'   AND"
					QrGy += "	   SG1.D_E_L_E_T_ = ' ' 		    				"
					QrGy := ChangeQuery(QrGy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrGy),"GQRs",.F.,.T.)
					
					DbSelectArea("GQRs")  
							
					If !EOF() 
						_nQtdEst := GQRs->G1_QUANT						
					Endif
				    GQRs->(DbCloseArea())	
							
					// CALCULO DA QUANTIDADE ORIGINAL 
							
					If _aMat[ic][10] = 0 
					   _nCalcOri := _aMat[ic][10] * _nQtdEst
					Else                                    
					   _nCalcOri := _aMat[ic][09] - _aMat[ic][10]
							
					Endif 
									
					_nQtdUt := _aMat[ic][09] - _aMat[ic][10]
					//oPrn:Say( _nLin+0030,1050,transform(_nCalcOri,"@E 99,9999.999"),oFont4,100) //Quantidade da estrutura SG1                                           
					oPrn:Say( _nLin+0030,0930,transform(_nQtdUt,"@E 99,9999.999"),oFont4,100) //QUANTIDADE DE origem
					_cDia := substr(_aMat[ic][11],7,2)
					_cMes := substr(_aMat[ic][11],5,2)
					_cAno := substr(_aMat[ic][11],1,4)						
					oPrn:Say( _nLin+0030,1200,_cDia+"/"+_cMes+"/"+_cAno,oFont4,100) //data de validade 
			   		
					// QUANTIDADE EM ESTOQUE  REFERENTE A MATERIA PRIMA  
					QrSy := "SELECT B2_QATU,B2_QEMP " 
				   	QrSy += "FROM  " + RetSQLName("SB2") + " SB2 "
					QrSy += " WHERE SB2.B2_FILIAL  = '" + xFilial("SB2") + "'	AND "
					QrSy += "       SB2.B2_COD     = '" + _aMat[ic][03]  + "'   AND"   
					QrSy += "       SB2.B2_LOCAL   = '" + _aMat[ic][05] + "'   AND"
					QrSy += "   	SB2.D_E_L_E_T_ = ' ' 		    				"
				   	QrSy += "GROUP BY B2_QATU,B2_QEMP						
					QrSy := ChangeQuery(QrSy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrSy),"SQRs",.F.,.T.) 
					
					DbSelectArea("SQRs") 
									
					If !EOF() 
						_nCalcEs := SQRs->B2_QATU 						
					Endif
				    SQRs->(DbCloseArea())     
						             
				    oPrn:Say( _nLin+0030,1700,_cLoteFa,oFont4,100) // LOTE FORNECEDOR 
				    oPrn:Say( _nLin+0030,2100,transform(_nCalcEs,"@E 99,9999.999"),oFont4,100) //CALCULO DO ESTOQUE REFERENTE A MATERIA PRIMA 
					_nLin := _nLin + 0040
					
				Endif
				QRAs->(DbCloseArea())
				    
				//DbSelectArea("QRs") 
				//DbSkip() 
			
			Next(ic)
			//Enddo  
			//QRs->(DbCloseArea()) 
			                                      
			
			_nLin := _nLin + 0100  
			oPrn:Box(_nLin,0040,_nLin,2500)
			
			Ensaio() 
	        
	    //Next
	    
	    //Ensaio() 
	    
    //	DbSelectArea("TSD2X")
    //	DbSkip()
      
    // _cNumNf := TSD2X->D2_DOC
	// _cSerNf := TSD2X->D2_SERIE	     
	 
	  
    	//oPrn:Preview()
    
	    //If MV_PAR03 == 1
    	oPrn:Preview()
    	//Else
    	//oPrn:Print() // descomentar esta linha para imprimir 
    
		//Endif
	
		MS_FLUSH()
  
    //Enddo
    //TSD2X->(DbCloseArea())
	
	Else
	   Alert("NAO EXISTE NF EMITIDA PARA ESTE PRODUTO / LOTE VERIFIQUE ")	
	Endif
	
Return(.T.) 


Static Function Cabec1   
    
	oPrn:EndPage()                 
	oPrn:StartPage()
	 		
	_nLin := 0040  
	cBitMap:= "Lgrl01.Bmp"
	cBitMap:= FisxLogo("1")					//"Lgrl01.Bmp"     
	oPrn:SayBitmap( 0040,0040,cBitMap,0300,0040 )  //Logo da empresa 
	oPrn:Say( _nLin,2500, "Folha:"+strzero(_nPag,2),oFont2,600) //emissao
  	_nLin := _nLin + 40                  
	oPrn:Say( _nLin,0040, "Nome do Fonte:"+"RPCPR116",oFont2,100) //emissao
  	_nLin := _nLin + 40
	oPrn:Say( _nLin,0040, "Hora:"+time(),oFont2,100) 	
	oPrn:Say( _nLin,1100, "Rastreamento de Lote do Produto Acabado ",oFont2,100) //ordem de producao 
	oPrn:Say( _nLin,2500, "Emissao :"+Dtoc(ddatabase),oFont2,100) 
	_nLin := _nLin + 0040  
	_cEmp := "Salmix/Filial:Matriz"                             
	oPrn:Say( _nLin,0040, "Empresa:"+_cEmp  ,oFont2,100)                    
	_nLin := _nLin + 0040
	oPrn:Box( _nLin,0040,_nLin,2500)             //tracinho que separa o
	_nLin := _nLin + 0040  

Return
	
Static Function Cabec2()
	
	                      
	oPrn:Say( _nLin,0040, "Produto :"+" "+ALLTRIM(MV_PAR09),oFont2,100) //produto 
	oPrn:Say( _nLin,0700, "Descricao :"+" "+POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(MV_PAR09),"B1_DESC"),oFont2,100) //Descricao do Produto 
	oPrn:Say( _nLin,1600, "UM :"+" "+POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(MV_PAR09),"B1_UM"),oFont2,100) //Descricao do Produto  
	//oPrn:Say( _nLin,2000, "Saldo prod. Estoque :"+Transform(_nCalcPa,"@E 9999.99"),oFont2,100) //Descricao do Produto  
	oPrn:Say( _nLin,2000, "Saldo prod. Estoque :"+Transform(_nCalLote,"@E 9999.99"),oFont2,100) //Descricao do Produto 
	_nLin := _nLin + 0040 
	oPrn:Say( _nLin,0040, "Lote    :"+" "+	_cLote,oFont2,100) // Unidade de medida                    	                       
	oPrn:Say( _nLin,0700, "Validade do Lote :"+" "+_cDia+"/"+_cMes+"/"+_cAno,oFont2,100) //Validade do Lote
	oPrn:Say( _nLin,1600, "Data Fabricacao :"+" "+_dDatFab,oFont2,100) //data emissao 
	_nLin := _nLin + 0080 
	
Return	
	
Static Function Cabec3
	                                                                                            
	oPrn:Say( _nLin,0040, "Numero NF.",oFont2,100)
   	oPrn:Say( _nLin,0500, "Serie",oFont2,100)
   	oPrn:Say( _nLin,0700, "Nome do Cliente",oFont2,100)  
   	oPrn:Say( _nLin,1400, "Quantidade",oFont2,100)  
   	
   	//+
   	
   	_nLin := _nLin + 0040  

Return

/*
Static Function Cabec4
   	                 
   	oPrn:Say( _nLin,0040, "Numero O.P. :"+" "+alltrim(_cNum+_cItem+_cSeq),oFont2,100) // Numero da Ordem de Producao  
   	oPrn:Say( _nLin,0700, "Quantidade da OP :"+" "+transform(QRX->C2_QUANT,"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao  
   	oPrn:Say( _nLin,2000, "Quantidade Produzida :"+" "+transform(QRX->C2_QUJE,"@E 9999.999"),oFont2,100) // Numero da Ordem de Producao
   	oPrn:Say( _nLin,2300, "Saldo Lote Estoque :",oFont2,100) // campo da SB8 QTD ESTOQUE           
   	_nLin := _nLin + 0080
   	oPrn:Box(_nLin,0040,_nLin,2500)
Return    	
*/
/*   	  
Static Function Cabec5()
   	
   	_nLin := _nLin + 0040             
   	oPrn:Box( _nLin,0040,_nLin,2500)             //tracinho que separa iniciar o logo 
   	_nLin := _nLin + 0040
   	oPrn:Say( _nLin,0040, "Materia Prima ",oFont2,100) //codigo materia prima 
   	oPrn:Say( _nLin+0030,0040, "Descricao",oFont2,100) //Descricao Materia Prima
   	oPrn:Say( _nLin,0650, "UM",oFont2,100) //UNIDADE DE MEDIDA
	oPrn:Say( _nLin,0800, "Armaz.",oFont2,100) //Lote    
	oPrn:Say( _nLin+0030,0800, "Lote",oFont2,100) //Armazem 
	//oPrn:Say( _nLin,1100, "Qtd Orginal",oFont2,100) //Quantidade Estrutura 
	oPrn:Say( _nLin,0900, "Qtd Util.",oFont2,100) //Quantidade Utilizada
	oPrn:Say( _nLin,1300, "Dta Valid.",oFont2,100) //data validade do lote 
	oPrn:Say( _nLin,1700, "Nfe Compras",oFont2,100) //Nota fiscal de compras  
	oPrn:Say( _nLin,1800, "Lote Fabr.",oFont2,100) //Lote Fabricante 
	oPrn:Say( _nLin,2100, "Saldo Atual",oFont2,100) //Saldo Atual 
	oPrn:Say( _nLin,2400, "Fornecedor",oFont2,100) //Saldo Atual   
	
Return 	
*/
	_nLin := _nLin + 0080  
	
	
Return()  

Static Function Ensaio()
        
Local t
Local c
Local d
		/*
		If _nLin > 2100       
			_nPag := _nPag + 1
			cabec1()	        
			_nLin := _nLin + 0080
			oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Processo ",oFont2,100) //ordem de producao 
			_nLin := _nLin + 0100
			oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
			oPrn:Say( _nLin,1000,"Operacao",oFont3,100)  //Laboratorio
			oPrn:Say( _nLin,1400,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
			oPrn:Say( _nLin,1550,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
			oPrn:Say( _nLin,1700,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
			oPrn:Say( _nLin,1850,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
			oPrn:Say( _nLin,2200,"Medicoes ",oFont3,100)    //Ap   
			_nLin := _nLin + 0080       
			_nVezb := 1
		Endif   
		*/		
		
		
	    _cQrya := ""
		_cQrya := "SELECT QPR_OP,QPR_PRODUT,QPR_LOTE,QPR_REVI,QPR_ENSAIO,QPR_CHAVE,QPR_OPERAC,QP1_ENSAIO,QP1_DESCPO,QP1_TIPO,QQK_PRODUT,QQK_CODIGO,QQK_OPERAC,QQK_DESCRI,QQK_RECURS "
		_cQrya += "FROM "
		_cQrya += RetSqlName("QPR") + " QPR, "
		_cQrya += RetSqlName("QP1") + " QP1, "
		_cQrya += RetSqlName("QQK") + " QQK, "
		_cQrya += "WHERE QPR.QPR_OP IN ( " 
		For t:= 1 to Len(_aCab)			   
	   		if t > 1
	   	    _cQrya += ","
	   		Endif                        
	   		
	   		IF 	_aCab[t][7] == "S"
	   			_cQrya += "'"+ _aCab[t][1] + _aCab[t][2] + _aCab[t][3] + _aCab[t][4] +"'" //" //
	   		Else
	   			_cQrya += "'"+ _aCab[t][1] + _aCab[t][2] + _aCab[t][3] + "'" //" //
	   		Endif
	   	Next
		_cQrya += ") "
		_cQrya +=  "  AND QPR.QPR_PRODUT IN ( " 
		For c:= 1 to Len(_aCab)
			if c > 1
	   			_cQrya += ","
	   		Endif				                                      
			_cQrya +=	" '"+ _aCab[c][5] + "' " //  
	   	Next    	   		
		_cQrya += ") "
		_cQrya +=  "  AND QPR.QPR_LOTE IN ( " 
		For d:= 1 to Len(_aCab)
			if d > 1
	   			_cQrya += ","
	   		Endif				                                      
			_cQrya +=	" '"+ _aCab[d][6] + "' " //  
	   	Next    	   		
		_cQrya += ") "		
		_cQrya += "AND QPR.QPR_FILIAL = '" + xFilial("QPR")  + "' " //
		_cQrya += "AND QP1.QP1_FILIAL = '" + xFilial("QP1")  + "' "
	   	_cQrya += "AND QPR.QPR_ENSAIO = QP1.QP1_ENSAIO "   
	   	_cQrya += "AND QPR.QPR_PRODUT = QQK.QQK_PRODUT "
	   	_cQrya += "AND QPR.QPR_REVI   = QQK.QQK_REVIPR " 
	   	_cQrya += "AND QPR.QPR_OPERAC = QQK.QQK_OPERAC "
		_cQrya += "AND QPR.D_E_L_E_T_ <> '*' " //
		_cQrya += "AND QP1.D_E_L_E_T_ <> '*' "  
		_cQrya += "GROUP BY  QPR_OP,QPR_PRODUT,QPR_LOTE,QPR_REVI,QPR_ENSAIO,QPR_CHAVE,QPR_OPERAC,QP1_ENSAIO,QP1_DESCPO,QP1_TIPO,QQK_PRODUT,QQK_CODIGO,QQK_OPERAC,QQK_DESCRI,QQK_RECURS "
		//_cQrya += "ORDER BY QPR_ENSAIO "  
		_cQrya += "ORDER BY QQK_RECURS " 
		_cQrya := ChangeQuery(_cQrya)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrya),"KP6K",.F.,.T.)
	    
		DbSelectArea("KP6K")		                 
		
			
		While !EOF()  
		
		
				
		
				If _nLin > 2100       
					_nPag := _nPag + 1
					cabec1()	        
					_nLin := _nLin + 0080
					oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Processo ",oFont2,100) //ordem de producao 
					_nLin := _nLin + 0100
					oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
					oPrn:Say( _nLin,1000,"Operacao",oFont3,100)  //Laboratorio
					oPrn:Say( _nLin,1400,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
					oPrn:Say( _nLin,1550,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1700,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1850,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
					oPrn:Say( _nLin,2200,"Medicoes ",oFont3,100)    //Ap   
				   //	oPrn:Say( _nLin,2700,"Texto ",oFont2,100)
					_nLin := _nLin + 0080
					_nVeza := 1
					_nVezb := 2
				Endif   
		
		        
		
				If _nVezb = 1  		    
				    _nLin := _nLin + 0080
					oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Processo ",oFont2,100) //ordem de producao 
					_nLin := _nLin + 0100
					oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
					oPrn:Say( _nLin,1000,"Operacao",oFont3,100)  //Laboratorio
					oPrn:Say( _nLin,1400,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
					oPrn:Say( _nLin,1550,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1700,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1850,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
					oPrn:Say( _nLin,2200,"Medicoes ",oFont3,100)    //Ap   
					_nLin := _nLin + 0080
					_nVezb := 2
			    Endif   
		     
		
		
		
			    _cEnsP := KP6K->QPR_ENSAIO   
			    _cEns       := substr(Posicione("QP1",1,xFilial("QP1") +KP6K->QPR_ENSAIO,"QP1_DESCPO"),1,30) // ENSAIO 
				_cDeso      := substr(Posicione("SG2",1,xFilial("SG2") + KP6K->QPR_PRODUT + '01' + KP6K->QPR_PRODUT,"G2_DESCRI"),1,10) // DESCRICAO DA OPERACAO
			    _nQtde      := Posicione("QP1",1,xFilial("QP1") +KP6K->QPR_ENSAIO,"QP1_QTDE")
			    
			    While !EOF() .and. _cEnsP = KP6K->QPR_ENSAIO
			    	 
			    	 IF KP6K->QP1_TIPO = "D"
			    	 
			    	 	_cQrL := "SELECT QP7_ENSAIO,QP7_PRODUT,QP7_CODREC,QP7_OPERAC,QP7_LABOR,QP7_UNIMED,QP7_LIE,QP7_NOMINA,QP7_LSE,QP7_SEQLAB,QP7_CRINFE,QP7_CRSUPE  "
						_cQrL += "FROM  " + RetSQLName("QP7") + " QP7, "
						_cQrL += " WHERE QP7.QP7_FILIAL  = '" + xFilial("QP8") + "'	AND "
						_cQrL += "       QP7.QP7_PRODUT	 = '" + KP6K->QQK_PRODUT + "' AND"             
						_cQrL += "       QP7.QP7_CODREC  = '" + KP6K->QQK_CODIGO + "' AND "   
						_cQrL += "	     QP7.QP7_OPERAC  = '" + KP6K->QQK_OPERAC + "' AND " 
						//_cQrL += "	     QP7.QP7_REVI    = '" + _cRevEs + "' AND "  alterado por antunes 26-06-2014  
						_cQrL += "	     QP7.QP7_REVI    = '" + KP6K->QPR_REVI + "' AND " 
						_cQrL += "		 QP7.D_E_L_E_T_ = ' ' 		    				"
						_cQrL += "GROUP BY QP7_ENSAIO,QP7_PRODUT,QP7_CODREC,QP7_OPERAC,QP7_LABOR,QP7_UNIMED,QP7_LIE,QP7_NOMINA,QP7_LSE,QP7_SEQLAB,QP7_CRINFE,QP7_CRSUPE  "
						_cQrL += "      ORDER BY QP7_SEQLAB "
						_cQrL := ChangeQuery(_cQrL)
			   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrL),"KQP7",.F.,.T.)  
								
						DbSelectArea("KQP7") 
						
						IF !EOF()
							 if !Empty(KP6K->QP1_DESCPO)
			    				oPrn:Say( _nLin,0040,KP6K->QP1_DESCPO,oFont3,100) //descricao do ensaio                  
			    			 Else
			    				oPrn:Say( _nLin,0040,_cEns,oFont3,100) //descricao do ensaio                  
			    			 Endif
			     		     IF !Empty(KP6K->QQK_DESCRI)
			   				 	oPrn:Say( _nLin,1000,KP6K->QQK_DESCRI,oFont3,100) //descricao da Operacao 
			   			     Else
			   				 	oPrn:Say( _nLin,1000,_cDeso,oFont3,100) //descricao da Operacao 
			   				 Endif	
			   				 oPrn:Say( _nLin,1400,KQP7->QP7_UNIMED,oFont3,100) //unidade de medida
							 oPrn:Say( _nLin,1550,KQP7->QP7_LIE,oFont3,100) // LIMITE INFERIOR DE ENGENHARIA
							 oPrn:Say( _nLin,1700,KQP7->QP7_NOMINA,oFont3,100) // NOMINAL DE CONTROLE 
							 oPrn:Say( _nLin,1850,KQP7->QP7_LSE,oFont3,100) // LIMITE SUPERIOR DE ENGENHARIA     
							 _nCol := 1850
							      
							     // COLETA OS ENSAIOS 
							     
							    _cQrLz := "SELECT QPS_MEDICA "
								_cQrLz+= "FROM  " + RetSQLName("QPS") + " QPS, "
								_cQrLz += " WHERE QPS.QPS_FILIAL  = '" + xFilial("QPS") + "'	AND "
								_cQrLz += "       QPS.QPS_CODMED	 = '" + KP6K->QPR_CHAVE + "' AND"             
								_cQrLz += "		  QPS.D_E_L_E_T_ = ' ' 		    				"
								_cQrLz := ChangeQuery(_cQrLz)
					   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrLz),"KQPS",.F.,.T.)  
										
								DbSelectArea("KQPS") 
								
								_nCont := 0
								
								WHILE !EOF()
								    _nCol := _nCol + 150    
									oPrn:Say( _nLin,_nCol,"  "+KQPS->QPS_MEDICA+"  ",oFont3,100) //unidade de medida 
									
							    	DbSelectArea("KQPS") 
									DBskip()
							    Enddo             
							    KQPS->(DbCloseArea())
							 	_nLin := _nLin + 0040     
							 
			   		 	   //AADD(_aEns,{KQP7->QP7_LIE,KQP7->QP7_NOMINAL,KQP7->QP7_LSE})
			    	 	Endif  
			    	 	KQP7->(DbCloseArea())
			        
			    	
			    	Else
			    	
			    		_cQrXL := "SELECT QP8_TEXTO "
						_cQrXL += "FROM  " + RetSQLName("QP8") + " QP8, "
						_cQrXL += " WHERE QP8.QP8_FILIAL  = '" + xFilial("QP8") + "'	AND "
						_cQrXL += "       QP8.QP8_PRODUT	 = '" + KP6K->QQK_PRODUT + "' AND"             
						_cQrXL += "       QP8.QP8_ENSAIO     = '" + KP6K->QPR_ENSAIO + "' AND "   
						_cQrXL += "	      QP8.QP8_REVI       = '" + KP6K->QPR_REVI   + "' AND " 
						_cQrXL += " 	  QP8.D_E_L_E_T_ = ' ' 		    				"
						_cQrXL += "GROUP BY QP8_TEXTO "
						_cQrXL := ChangeQuery(_cQrXL)
			   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrXL),"KQP8",.F.,.T.)  
					    
					    DbSelectArea("KQP8")    
					    
						iF !EOF() 
							
							if !Empty(KP6K->QP1_DESCPO)
			    				oPrn:Say( _nLin,0040,KP6K->QP1_DESCPO,oFont3,100) //descricao do ensaio                  
			    			 Else
			    				oPrn:Say( _nLin,0040,_cEns,oFont3,100) //descricao do ensaio                  
			    			 Endif
			     		     IF !Empty(KP6K->QQK_DESCRI)
			   				 	oPrn:Say( _nLin,1000,KP6K->QQK_DESCRI,oFont3,100) //descricao da Operacao 
			   			     Else
			   				 	oPrn:Say( _nLin,1000,_cDeso,oFont3,100) //descricao da Operacao 
			   				 Endif	
			   				 oPrn:Say( _nLin,1400,KQP8->QP8_TEXTO,oFont3,100) //TEXTO ENSAIO  
			   				  _nCol := 1850
							
			   				 	_cQrLz := "SELECT QPQ_MEDICA "
								_cQrLz+= "FROM  " + RetSQLName("QPQ") + " QPQ, "
								_cQrLz += " WHERE QPQ.QPQ_FILIAL  = '" + xFilial("QPQ") + "'	AND "
								_cQrLz += "       QPQ.QPQ_CODMED	 = '" + KP6K->QPR_CHAVE + "' AND"             
								_cQrLz += "		  QPQ.D_E_L_E_T_ = ' ' 		    				"
								_cQrLz := ChangeQuery(_cQrLz)
					   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrLz),"KQPQ",.F.,.T.)  
										
								DbSelectArea("KQPQ") 
								
								_nCont := 0
								
								WHILE !EOF()
								    _nCol := _nCol + 200    
									oPrn:Say( _nLin,_nCol,"  "+KQPQ->QPQ_MEDICA+"  ",oFont3,100) //unidade de medida 
									
							    	DbSelectArea("KQPQ") 
									DBskip()
							    Enddo             
							    KQPQ->(DbCloseArea())
							 	_nLin := _nLin + 0040     
						Endif             
						KQP8->(DbCloseArea())
			    	 	
			    	
			    	Endif
			    
			  		DbSelectArea("KP6K")
					DbSkip()  
			    
			    Enddo
				  
        Enddo             
        KP6K->(DbCloseArea())  
        
        
        	
        

Return

//-------------------------------------------------------------------
//  Valida Perguntas
//-------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR112  บAutor  ณ Eduardo Antunes    บ Data ณ  01/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida as perguntas selecionadas.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus 10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local I, J
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

//------------------------------------------------------------------------------------
//  Variaveis utilizadas para parametros
//------------------------------------------------------------------------------------
//                                                                                                                                                            X             
AADD(aRegs,{cPerg,"01","De Cliente?       ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})
AADD(aRegs,{cPerg,"02","Ate Cliente?      ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})                                        
AADD(aRegs,{cPerg,"03","De Loja?          ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Loja?         ","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                        
AADD(aRegs,{cPerg,"05","De NF     ?       ","","","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SF2NF1","","",""})
AADD(aRegs,{cPerg,"06","Ate NF    ?       ","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SF2NF2","","",""}) 
AADD(aRegs,{cPerg,"07","De Serie  ?       ","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Serie ?       ","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"09","Ref. ao Produto?  ","","","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","",""})
AADD(aRegs,{cPerg,"10","Ref. a OP/Lote ?   ","","","mv_ch10","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SC2LT1","","",""}) 



For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return               
