#Include "Rwmake.ch"             
#Include "Protheus.ch"             
#Include "topconn.ch"                                                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR007  บAutor  ณEduardo Antunes     บ Data ณ  01/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio rastreamento do lote referente a Materia Prima    บฑฑ    
																		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Protheus 11                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR007

oFont2     := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont4     := TFont():New( "Courier New",,08,,.f.,,,,,.f. )
oFont3     := TFont():New( "Courier New",,09,,.f.,,,,,.f. )
 
                                                                
Private oDlg
Private aCA       :={OemToAnsi("Confirma"),OemToAnsi("Abandona")} // "Confirma", "Abandona"
Private cCadastro := OemToAnsi("Relatorio rastreamento do lote Materia Prima ")
Private aSays:={}, aButtons:={}
Private nOpca     := 0
Private _nQtde    := 0    
Private _nAcum    := 0  
Private _lVer     := .F. 
Private _cTipo    := ""
Private _nQtdAp   := 0 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn    := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 } // ###
Private nLastKey   := 0
Private cPerg      := "RFATR007"

ValidPerg()

Pergunte(cPerg,.F.)

_cProd := MV_PAR09

//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aSays,OemToAnsi( "  Este programa ira imprimir o rastreamento do lote da Mat.Prima"))
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
	//Private	_cLoja    := ""
	Private _aCab := {}
	Private _aEns := {} 
	Private _aNota := {}
	
	Private _cEnsP := ""    
	Private	_cEns       := ""
	Private	_cDeso      := ""
	
	Private _nCol  := 0 
	Private _nCont := 0		 
	
	//Private _cLote := ""
	Private _lVer := .F.
	//Private _nVeza := 1         
	Private _nVezb := 1 
	Private _cDeProd := ""		
	
	
	Private _cCodCtl := "" // codigo do lote  
    Private 	_nVez5  := 1     
    Private _dDataH := Ddatabase
    //Private _nVez5 := 1 
    Private _nAcmMP := 0 
    
    	                     
	nHeight    :=15
	lBold      := .F.
	lUnderLine := .F.
	lPixel     := .T.               
	lPrint      :=.F.
	nSedex     := 1

    QrkY := "SELECT D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_LOTECTL,D1_DTVALID,D1_QUANT,B1_TIPO " 
	QrkY += "FROM  " + RetSQLName("SD1") + " SD1, "
	QrkY += "      " + RetSQLName("SB1") + " SB1 "
	QrkY += " WHERE SD1.D1_FILIAL  = '" + xFilial("SD1") + "'  AND "  
	QrkY += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "'  AND "  
	QrkY += "       SD1.D1_FORNECE   >= '" + MV_PAR01 + "'   AND" 
	QrkY += "       SD1.D1_FORNECE   <= '" + MV_PAR02 + "'   AND" 
	QrkY += "       SD1.D1_LOJA      >= '" + MV_PAR03 + "'   AND" 
	QrkY += "       SD1.D1_LOJA      <= '" + MV_PAR04 + "'   AND" 
	QrkY += "       SD1.D1_DOC       >= '" + MV_PAR05 + "'   AND" 
	QrkY += "       SD1.D1_DOC       <= '" + MV_PAR06 + "'   AND" 
	QrkY += "       SD1.D1_SERIE   	 >= '" + MV_PAR07 + "'   AND" 
	QrkY += "       SD1.D1_SERIE     <= '" + MV_PAR08 + "'   AND" 
	QrkY += "       SD1.D1_COD       = '" + MV_PAR09 + "'   AND"  
	QrkY += "       SD1.D1_LOTECTL   = '" + MV_PAR10 + "'   AND"  	
	QrkY += "       SD1.D1_DTVALID   > '" + dtos(_dDataH)  + "'   AND" 
	QrkY += "       SD1.D1_LOTECTL   <> ' '  AND" 	
	QrkY += "       SD1.D1_COD       =  SB1.B1_COD  AND" 
	QrkY += "       SB1.B1_TIPO      IN  ('MP','EM')    AND" 
	QrkY += "	    SD1.D_E_L_E_T_ = ' '   AND "	          
	QrkY += "	    SB1.D_E_L_E_T_ = ' ' "	                                     
	QrkY += "GROUP BY D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_LOTECTL,D1_DTVALID,D1_QUANT,B1_TIPO " 
	QrkY += "ORDER BY  D1_LOTECTL "
	QrkY := ChangeQuery(QrkY)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,QrkY),"TSD1X",.F.,.T.)
	
	DbSelectArea("TSD1X")     
	
	While !EOF() 
		
		_cCodCtl := TSD1X->D1_LOTECTL  
		
		
		While !EOF() .and. _cCodCtl =  TSD1X->D1_LOTECTL  
		        
			If _nVez = 1 
				_nPag := _nPag + 1 
				cabec1()
				cabec2()
				cabec3() 
				_nVez := 2
			Endif         
			
			If _nLin > 2100       
				_nPag := _nPag + 1
				cabec1()
				cabec2()
				cabec3()	
			Endif
		        
				Qrwy := "SELECT B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 
				Qrwy += "FROM  " + RetSQLName("SB8") + " SB8 "
				Qrwy += " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "'	AND "
				Qrwy += "       SB8.B8_PRODUTO  = '" + TSD1X->D1_COD + "'   AND"   
				Qrwy += "       SB8.B8_LOTECTL  =  '" + TSD1X->D1_LOTECTL + "'   AND" 
				Qrwy += "   	SB8.D_E_L_E_T_ = ' ' 		    				"
				Qrwy += "GROUP BY B8_PRODUTO,B8_LOCAL,B8_SALDO,B8_EMPENHO,B8_LOTECTL " 						
				Qrwy := ChangeQuery(Qrwy)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qrwy),"TSB8",.F.,.T.)  
					
					
				DbSelectArea("TSB8")
									
				If !EOF() 
					_nCalcPa := TSB8->B8_SALDO - TSB8->B8_EMPENHO						
				Endif
				TSB8->(DbCloseArea())                                       
		        
		        
				_cLote := TSD1X->D1_LOTECTL
				
				_cAno := substr(TSD1X->D1_DTVALID,1,4)
				_cMes := substr(TSD1X->D1_DTVALID,5,2)
				_cDia := substr(TSD1X->D1_DTVALID,7,2)                                                                            
	
		         
				_nLin := _nLin + 0040
				oPrn:Say( _nLin,0040,TSD1X->D1_DOC,oFont2,100) // NUMERO DA NOTA FISCAL 
		   		oPrn:Say( _nLin,0500,TSD1X->D1_SERIE,oFont2,100)  // SERIE DA NOTA FISCAL 
		   		oPrn:Say( _nLin,0700,Posicione("SA1",1,xFilial("SA1")+TSD1X->D1_FORNECE+TSD1X->D1_LOJA,"A1_NOME"),oFont2,100) // NOME DO CLIENTE 
		   		oPrn:Say(_nLin,1400,transform(TSD1X->D1_QUANT,"@E 99,9999.999"),oFont2,100)  // QUANTIDADE FATURADA
		   		oPrn:Say(_nLin,1800,TSD1X->D1_LOTECTL,oFont2,100)  //
		   		oPrn:Say(_nLin,2100,_cDia+"/"+_cMes+"/"+_cAno,oFont2,100)  //  
		   		oPrn:Say(_nLin,2300,Transform(_nCalcPa,"@E 99,9999.999"),oFont2,100)  //  
		   		
				_nLin := _nLin + 0080  
				oPrn:Box(_nLin,0040,_nLin,2500)                       
					
				
				Qry := "SELECT * " 
				Qry += "FROM  " + RetSQLName("SD4") + " SD4 "
				Qry += " WHERE SD4.D4_FILIAL  = '" + xFilial("SD4") + "'   AND "
				Qry += "       SD4.D4_COD     = '" + TSD1X->D1_COD + "'       AND " 
				Qry += "       SD4.D4_LOTECTL = '" + TSD1X->D1_LOTECTL + "'   AND " 		            
				Qry += "	   SD4.D_E_L_E_T_ = ' ' 		
				Qry := ChangeQuery(Qry)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qry),"QRs",.F.,.T.)
							    
				DbSelectArea("QRs")     
				
				                                            
				While !EOF() 
				
				
					Qrwy := "SELECT * " 
					Qrwy += "FROM  " + RetSQLName("SD3") + " SD3 "
					Qrwy += " WHERE SD3.D3_FILIAL   = '" + xFilial("SD3") + "'	AND "
					Qrwy += "       SD3.D3_COD      = '" + TSD1X->D1_COD + "'   AND"   
					Qrwy += "       SD3.D3_LOTECTL  =  '" + TSD1X->D1_LOTECTL + "'   AND"    
					Qrwy += "       SD3.D3_OP       =  '" + QRs->D4_OP  + "'   AND"     
					Qrwy += "       SD3.D3_TM       =  '999'   AND"     					
					Qrwy += "   	SD3.D_E_L_E_T_  = ' ' 		    				"
					Qrwy := ChangeQuery(Qrwy)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,Qrwy),"TSD3",.F.,.T.)  
						
						
					DbSelectArea("TSD3")
										
					If !EOF() 
					 	_nQtdAp := TSD3->D3_QUANT					
					Endif		
				    TSD3->(DbCloseArea())
				      
					IF _nVez5  = 1   
					    
					    _nPag := _nPag + 1
						//cabec1()
						//cabec2()
						//cabec3()                
						
						oPrn:Box(_nLin,0040,_nLin,2500)                       
						
					    _nLin := _nLin + 0080
						   
						oPrn:Say( _nLin,1100, "Rela็ใo das OPs - Referente a Nota ",oFont2,100) //codigo materia prima 
					
						_nLin := _nLin + 0080
						oPrn:Say( _nLin,0040, "Numero O.P. ",oFont2,100) //codigo materia prima 
						oPrn:Say( _nLin,0450, "Local",oFont2,100) //UNIDADE DE MEDIDA
						oPrn:Say( _nLin,0750, "Data",oFont2,100) //Lote    
						oPrn:Say( _nLin,1100, "Qtd Ori.",oFont2,100) //Quantidade Utilizada  						
				 		oPrn:Say( _nLin,1500, "Lote",oFont2,100) //Quantidade Utilizada  
	   					_nLin := _nLin + 0080
				 		_nvez5 := 2  
					
					Endif
					
					If _nLin > 2100       
						
						_nPag := _nPag + 1
						cabec1()
						cabec2()
						cabec3()                
						_nLin := _nLin + 0080
						   
						oPrn:Say( _nLin,1100, "Rela็ใo das OPs - Referente a Nota ",oFont2,100) //codigo materia prima 
					
						_nLin := _nLin + 0040
						oPrn:Say( _nLin,0040, "Numero O.P. ",oFont2,100) //codigo materia prima 
						oPrn:Say( _nLin,0450, "Local",oFont2,100) //UNIDADE DE MEDIDA
						oPrn:Say( _nLin,0750, "Data",oFont2,100) //Lote    
						oPrn:Say( _nLin,1100, "Qtd Ori.",oFont2,100) //Quantidade Utilizada  
	   					oPrn:Say( _nLin,1500, "Lote",oFont2,100) //Quantidade Utilizada  
	   				
	   				
	   				Endif  
	   				
   					oPrn:Say( _nLin,0040,QRs->D4_OP,oFont4,100) 
					oPrn:Say( _nLin,0450,QRs->D4_LOCAL,oFont4,100) 
					oPrn:Say( _nLin,0750,QRs->D4_DATA,oFont4,100) 
					oPrn:Say( _nLin,1000,transform(_nQtdAp,"@E 99,9999.999"),oFont4,100) 
				    oPrn:Say( _nLin,1500,QRs->D4_LOTECTL,oFont4,100) 
				    
				    _nLin := _nLin + 0040
		            
					_nAcmMP  := _nAcmMP + _nQtdAp
					
					_lVer := .T.
		
					DbSelectArea("QRs")
		    		DbSkip()
				Enddo  
				QRs->(DbCloseArea())   
				
				If _lVer 
					_nLin := _nLin + 0040
					oPrn:Say(_nLin,0040,"Total Utilizado ----->",oFont2,100)  // QUANTIDADE FATURADA
					oPrn:Say(_nLin,1000,transform(_nAcmMP,"@E 99,9999.999"),oFont2,100)  // QUANTIDADE FATURADA
					_nLin := _nLin + 0100 
					_lVer := .F.  
					oPrn:Box(_nLin,0040,_nLin,2500)
				Endif	                                
				
				Ensaio()			
				
					
			_nVez := 1       
			_nVez5 := 1    
			_nAcmMP := 0
			DbSelectArea("TSD1X")
			DbSkip()  
		    
		
		Enddo
		Ensaio(_cCodCtl,TSD1X->D1_COD)
	
	   	
	Enddo 	
	TSD1X->(DbCloseArea())	
		
    oPrn:Preview()
    
	MS_FLUSH()
  
    
	
Return(.T.) 


Static Function Cabec1   
    
	oPrn:EndPage()                 
	oPrn:StartPage()
	 		
	_nLin := 0040  
	cBitMap:= "Lgrl01.Bmp"
	cBitMap:= FisxLogo("1")					//"Lgrl01.Bmp"     
	oPrn:SayBitmap( 0040,0040,cBitMap,0300,0040 )  //Logo da empresa 
	oPrn:Say( _nLin,2500, "Folha:"+strzero(_nPag,2),oFont2,600) //emissao
   //	oPrn:Say( _nLin,2900,,oFont2,100) //emissao   
	_nLin := _nLin + 40                  
	oPrn:Say( _nLin,0040, "Nome do Fonte:"+"RPCPR117",oFont2,100) //emissao
   //	_cPeri :=  +  dToc(mv_par01) +  " - " +  dToc(mv_par02) 
	//oPrn:Say( _nLin,2500, "Dt.Ref :"+_cPeri,oFont2,100) //emissao
	_nLin := _nLin + 40
	oPrn:Say( _nLin,0040, "Hora:"+time(),oFont2,100) 	
	oPrn:Say( _nLin,1100, "Rastreamento de Lote Materia Prima ",oFont2,100) //ordem de producao 
	oPrn:Say( _nLin,2500, "Emissao :"+Dtoc(ddatabase),oFont2,100) 
	_nLin := _nLin + 0040  
	_cEmp := "Salmix/Filial:Matriz"                             
	oPrn:Say( _nLin,0040, "Empresa:"+_cEmp  ,oFont2,100)                    
	_nLin := _nLin + 0040
	oPrn:Box( _nLin,0040,_nLin,2500)             //tracinho que separa o
	_nLin := _nLin + 0040  

Return
	
Static Function Cabec2()
	
	                      
	oPrn:Say( _nLin,0040, "Produto : "+ALLTRIM(MV_PAR09),oFont2,100) //produto 
	oPrn:Say( _nLin,0700, "Descricao :"+POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(MV_PAR09),"B1_DESC"),oFont2,100) //Descricao do Produto 
	oPrn:Say( _nLin,1400, "UM :"+POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(MV_PAR09),"B1_UM"),oFont2,100) //Descricao do Produto  
	oPrn:Say( _nLin,2000, "Saldo prod. Estoque :"+Transform(_nCalcPa,"@E 9999.99"),oFont2,100) //Descricao do Produto 
	_nLin := _nLin + 0040 
	//oPrn:Say( _nLin,0040, "Lote :"+	_cLote,oFont2,100) // Unidade de medida                    	
	//oPrn:Say( _nLin,0700, "Validade do Lote:"+_cDia+"/"+_cMes+"/"+_cAno,oFont2,100) //Validade do Lote         
	_nLin := _nLin + 0080 
	
Return	
	
Static Function Cabec3
	                                                                                            
	oPrn:Say( _nLin,0040, "Numero NF.",oFont2,100)
   	oPrn:Say( _nLin,0500, "Serie",oFont2,100)
   	oPrn:Say( _nLin,0700, "Nome do Fornec",oFont2,100)  
   	oPrn:Say( _nLin,1450, "Qtd",oFont2,100)  
   	oPrn:Say( _nLin,1850, "Lote",oFont2,100) 
   	oPrn:Say( _nLin,2100, "Val.Lote",oFont2,100)  
   	oPrn:Say( _nLin,2350, "Qtd do Lote",oFont2,100)  
   	
   	
   	_nLin := _nLin + 0040  

Return

	
Return()  

Static Function Ensaio()
        

		If _nVezb = 1 .and. _nLin < 2100 
		
				oPrn:EndPage()                 
				oPrn:StartPage()		    
			    _nLin := 0040
			    _nLin := _nLin + 0080
				oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Entrada ",oFont2,100) //ordem de producao 
				_nLin := _nLin + 0100
				oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
				oPrn:Say( _nLin,0500,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
				oPrn:Say( _nLin,0750,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
				oPrn:Say( _nLin,1000,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
				oPrn:Say( _nLin,1250,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
				oPrn:Say( _nLin,1500,"Medicoes ",oFont3,100)    //Ap  
				_nLin := _nLin + 0080
				_nVezb := 2  
				
		Endif   
		
		If _nLin > 2100 .and. _nVezb <> 2 
		       
			_nPag := _nPag + 1
			cabec1()	        
			_nLin := _nLin + 0080
			oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Entrada ",oFont2,100) //ordem de producao 
			_nLin := _nLin + 0100
			oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
   			oPrn:Say( _nLin,0500,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
			oPrn:Say( _nLin,0750,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
			oPrn:Say( _nLin,1000,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
			oPrn:Say( _nLin,1250,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
			oPrn:Say( _nLin,1500,"Medicoes ",oFont3,100)    //Ap  		
			_nLin := _nLin + 0080
			//_nVezb := 1
		
		Endif   
				
		
		
	    _cQrya := ""
		_cQrya := "SELECT QER_PRODUT,QER_LOTE,QER_REVI,QER_ENSAIO,QER_CHAVE,QE1_ENSAIO,QE1_DESCPO,QE1_TIPO,QE1_CARTA"
		_cQrya += "FROM "
		_cQrya += RetSqlName("QER") + " QER, "
		_cQrya += RetSqlName("QE1") + " QE1, "
		_cQrya += "WHERE QER.QER_PRODUT = '" + TSD1X->D1_COD  + "' " 
		_cQrya += "  AND QER.QER_LOTE = '" + _cCodCtl + "' " 
		_cQrya += "AND QER.QER_FILIAL = '" + xFilial("QER")  + "' " //
		_cQrya += "AND QE1.QE1_FILIAL = '" + xFilial("QE1")  + "' "
	   	_cQrya += "AND QER.QER_ENSAIO = QE1.QE1_ENSAIO "   
	   	_cQrya += "AND QER.D_E_L_E_T_ <> '*' " //
		_cQrya += "AND QE1.D_E_L_E_T_ <> '*' "  
		_cQrya += "GROUP BY  QER_PRODUT,QER_LOTE,QER_REVI,QER_ENSAIO,QER_CHAVE,QE1_ENSAIO,QE1_DESCPO,QE1_TIPO,QE1_CARTA"
		//_cQrya += "ORDER BY QPR_ENSAIO "  
		//_cQrya += "ORDER BY QQK_RECURS " 
		_cQrya := ChangeQuery(_cQrya)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrya),"KE6K",.F.,.T.)
	    
		DbSelectArea("KE6K")		                 
		
			
		While !EOF()       
		
				If _nLin > 2100       
					_nPag := _nPag + 1
					cabec1()	        
					_nLin := _nLin + 0080
					oPrn:Say( _nLin,1100, "Dados Ref. a Inspe็ใo de Entrada ",oFont2,100) //ordem de producao 
					_nLin := _nLin + 0100
					oPrn:Say( _nLin,0040,"Ensaio",oFont3,100) //descricao do ensaio
					oPrn:Say( _nLin,0500,"UM",oFont3,100)     //Unidade oPrn:Say( _nLin,1000,"UM",oFont2,1000) modificado por antunes 26/04/2012      
					oPrn:Say( _nLin,0750,"LIE",oFont3,100)    //Lote Inferior	oPrn:Say( _nLin,1100,"LIE",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1000,"Nom.",oFont3,100) //Nominal oPrn:Say( _nLin,1250,"Nominal",oFont2,100) modificado por antunes 26/04/2012
					oPrn:Say( _nLin,1250,"LSE",oFont3,100)    //Lote Superioro Prn:Say( _nLin,1400,"LSE",oFont2,100) modificado por antunes 26/04/2012     
					oPrn:Say( _nLin,1500,"Medicoes ",oFont3,100)    //Ap  		
					//	oPrn:Say( _nLin,2700,"Texto ",oFont2,100)
					_nLin := _nLin + 0080
					//_nVeza := 1
				Endif   
		
		
			    _cEnsP := KE6K->QER_ENSAIO   
			    _cEns       := substr(Posicione("QE1",1,xFilial("QE1") +KE6K->QER_ENSAIO,"QE1_DESCPO"),1,30) // ENSAIO 
				//_cDeso      := substr(Posicione("SG2",1,xFilial("SG2") + KP6K->QPR_PRODUT + '01' + KP6K->QPR_PRODUT,"G2_DESCRI"),1,10) // DESCRICAO DA OPERACAO
			    _nQtde      := Posicione("QE1",1,xFilial("QE1") +KE6K->QER_ENSAIO,"QE1_QTDE")
			    
			    While !EOF() .and. _cEnsP = KE6K->QER_ENSAIO
			    	 
			    	 //IF KE6K->QE1_CARTA = "TXT"
			    	 
			    	 	_cQrL := "SELECT QE7_ENSAIO,QE7_PRODUT,QE7_LABOR,QE7_UNIMED,QE7_LIE,QE7_NOMINA,QE7_LSE,QE7_SEQLAB"
						_cQrL += "FROM  " + RetSQLName("QE7") + " QE7, "
						_cQrL += " WHERE QE7.QE7_FILIAL  = '" + xFilial("QE7") + "'	AND "
						_cQrL += "       QE7.QE7_PRODUT	 = '" + KE6K->QER_PRODUT + "' AND"             
						_cQrL += "	     QE7.QE7_REVI    = '" + KE6K->QER_REVI + "' AND " 
						_cQrL += "		 QE7.D_E_L_E_T_ = ' ' 		    				"
						_cQrL += "GROUP BY QE7_ENSAIO,QE7_PRODUT,QE7_LABOR,QE7_UNIMED,QE7_LIE,QE7_NOMINA,QE7_LSE,QE7_SEQLAB"
						_cQrL += "      ORDER BY QE7_SEQLAB "
						_cQrL := ChangeQuery(_cQrL)
			   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrL),"KQE7",.F.,.T.)  
								
						DbSelectArea("KQE7") 
						
						IF !EOF()
							 if !Empty(KE6K->QE1_DESCPO)
			    				oPrn:Say( _nLin,0040,KE6K->QE1_DESCPO,oFont3,100) //descricao do ensaio                  
			    			 Else
			    				oPrn:Say( _nLin,0040,_cEns,oFont3,100) //descricao do ensaio                  
			    			 Endif
			     		     //IF !Empty(KP6K->QQK_DESCRI)
			   				 //	oPrn:Say( _nLin,1000,KP6K->QQK_DESCRI,oFont3,100) //descricao da Operacao 
			   			     //Else
			   				 //	oPrn:Say( _nLin,1000,_cDeso,oFont3,100) //descricao da Operacao 
			   				 //Endif	
			   				 oPrn:Say( _nLin,0500,KQE7->QE7_UNIMED,oFont3,100) //unidade de medida
							 oPrn:Say( _nLin,0700,KQE7->QE7_LIE,oFont3,100) // LIMITE INFERIOR DE ENGENHARIA
							 oPrn:Say( _nLin,1000,KQE7->QE7_NOMINA,oFont3,100) // NOMINAL DE CONTROLE 
							 oPrn:Say( _nLin,1200,KQE7->QE7_LSE,oFont3,100) // LIMITE SUPERIOR DE ENGENHARIA     
							 _nCol := 1200                                 
							      
							     // COLETA OS ENSAIOS 
							     
							    _cQrLz := "SELECT QES_MEDICA "
								_cQrLz+= "FROM  " + RetSQLName("QES") + " QES, "
								_cQrLz += " WHERE QES.QES_FILIAL  = '" + xFilial("QES") + "'	AND "
								_cQrLz += "       QES.QES_CODMED	 = '" + KE6K->QER_CHAVE + "' AND"             
								_cQrLz += "		  QES.D_E_L_E_T_ = ' ' 		    				"
								_cQrLz := ChangeQuery(_cQrLz)
					   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrLz),"KQES",.F.,.T.)  
										
								DbSelectArea("KQES") 
								
								_nCont := 0
								
								WHILE !EOF()
								    _nCol := _nCol + 150    
									oPrn:Say( _nLin,_nCol,"  "+KQES->QES_MEDICA+"  ",oFont3,100) //unidade de medida 
									
							    	DbSelectArea("KQES") 
									DBskip()
							    Enddo             
							    KQES->(DbCloseArea())
							 	_nLin := _nLin + 0040     
							 
			   		 	   //AADD(_aEns,{KQP7->QP7_LIE,KQP7->QP7_NOMINAL,KQP7->QP7_LSE})
			    	 	Endif  
			    	 	KQE7->(DbCloseArea())
			                
			    	
			    	//Else
			    	
			    		_cQrXL := "SELECT QE8_TEXTO "
						_cQrXL += "FROM  " + RetSQLName("QE8") + " QE8, "
						_cQrXL += " WHERE QE8.QE8_FILIAL  = '" + xFilial("QE8") + "'	AND "
						_cQrXL += "       QE8.QE8_PRODUT	 = '" + KE6K->QER_PRODUT + "' AND"             
						_cQrXL += "       QE8.QE8_ENSAIO     = '" + KE6K->QER_ENSAIO + "' AND "   
						_cQrXL += "	      QE8.QE8_REVI       = '" + KE6K->QER_REVI   + "' AND " 
						_cQrXL += " 	  QE8.D_E_L_E_T_ = ' ' 		    				"
						_cQrXL += "GROUP BY QE8_TEXTO "
						_cQrXL := ChangeQuery(_cQrXL)
			   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrXL),"KQE8",.F.,.T.)  
					    
					    DbSelectArea("KQE8")    
					    
						iF !EOF() 
							
							if !Empty(KE6K->QE1_DESCPO)
			    				oPrn:Say( _nLin,0040,KE6K->QE1_DESCPO,oFont3,100) //descricao do ensaio                  
			    			 Else
			    				oPrn:Say( _nLin,0040,_cEns,oFont3,100) //descricao do ensaio                  
			    			 Endif
			     		     //IF !Empty(KP6K->QQK_DESCRI)
			   				 //	oPrn:Say( _nLin,1000,KP6K->QQK_DESCRI,oFont3,100) //descricao da Operacao 
			   			     //Else
			   				 //	oPrn:Say( _nLin,1000,_cDeso,oFont3,100) //descricao da Operacao 
			   				 //Endif	
			   				 oPrn:Say( _nLin,1400,KQE8->QE8_TEXTO,oFont3,100) //TEXTO ENSAIO  
			   				  _nCol := 1850
							
			   				 	_cQrLz := "SELECT QEQ_MEDICA "
								_cQrLz+= "FROM  " + RetSQLName("QEQ") + " QEQ, "
								_cQrLz += " WHERE QEQ.QEQ_FILIAL  = '" + xFilial("QEQ") + "'	AND "
								_cQrLz += "       QEQ.QEQ_CODMED	 = '" + KE6K->QER_CHAVE + "' AND"             
								_cQrLz += "		  QEQ.D_E_L_E_T_ = ' ' 		    				"
								_cQrLz := ChangeQuery(_cQrLz)
					   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrLz),"KQEQ",.F.,.T.)  
										
								DbSelectArea("KQEQ") 
								
								_nCont := 0
								
								WHILE !EOF()
								    _nCol := _nCol + 200    
									oPrn:Say( _nLin,_nCol,"  "+KQEQ->QEQ_MEDICA+"  ",oFont3,100) //unidade de medida 
									
							    	DbSelectArea("KQEQ") 
									DBskip()
							    Enddo             
							    KQEQ->(DbCloseArea())
							 	_nLin := _nLin + 0040     
						Endif             
						KQE8->(DbCloseArea())
			    	 	
			    	
			    	//Endif
			    
			  		DbSelectArea("KE6K")
					DbSkip()  
			    
			    Enddo
				  
        Enddo             
        KE6K->(DbCloseArea())  
        
        
        	
        

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

Local aRegs
Local cPerg
Local i
Local j


_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

//------------------------------------------------------------------------------------
//  Variaveis utilizadas para parametros
//------------------------------------------------------------------------------------
//                                                                                                                                                                         

AADD(aRegs,{cPerg,"01","De Fornece?       ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
AADD(aRegs,{cPerg,"02","Ate Fornece?      ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})                                        
AADD(aRegs,{cPerg,"03","De Loja?          ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Loja?         ","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                        
AADD(aRegs,{cPerg,"05","De NF     ?       ","","","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SF1NF1","","",""})
AADD(aRegs,{cPerg,"06","Ate NF    ?       ","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SF1NF1","","",""}) 
AADD(aRegs,{cPerg,"07","De Serie  ?       ","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Serie ?       ","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"09","Ref. ao Produto?  ","","","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","",""})
AADD(aRegs,{cPerg,"10","Lote do Produto?  ","","","mv_ch10","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SD1LOT","","",""})


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
