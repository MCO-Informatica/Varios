#INCLUDE "RWMAKE.CH"

/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR005  บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de impressใo do laudo do produto conforme estrutura บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Especํfico para a empresa Prozyn.            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR005()

Local _cUser
Local _cData
Private _aSavArea := GetArea()
Private cPerg     := "RFATR005"

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

Processa( { || ImprPed() }, "Impressใo de Laudo", "Aguarde, processando as informa็๕es solicitadas...",.T.)

RestArea(_aSavArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณImprPed           ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Sub-rotina de processamento e impressใo das informa็๕es do บฑฑ
ฑฑบ          ณpedido de vendas.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFATR050                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImprPed()
Private _nLin    := 0			//Variแvel de controle das linhas para impressใo
Private oFont1   := TFont():New( "Arial",,14,.T.,,,,,,.F. )
Private oFont2   := TFont():New( "Arial",,14,.T.,,,,,,.F.,.T. )
Private oFont6   := TFont():New( "Arial",,14,.T.,.T.,,,,,.F. )
Private oFont5   := TFont():New( "Arial",,30,.T.,.T.,,,,,.F. )
Private oPrn     := TMSPrinter():New("Laudo de produto")
Private _cProd   := ""
Private _cUM     := ""
Private _nFator  := 0
Private _nAtivid := 0
Private _cLaudo  := ""
Private _cDesLau := ""
Private cBitMap2:= "AssLaudoTec.Bmp"




//L๓gica do relat๓rio
oPrn:SetPaperSize(9)
//oPrn:Setup()
oPrn:SetPortrait()


cQuery := "SELECT ISNULL((SELECT C2_EMISSAO FROM " + RetSqlName("SC2") + " SC2 WHERE SC2.D_E_L_E_T_='' AND SC2.C2_FILIAL='" + xFilial("SC2") + "' AND SC2.C2_PRODUTO=SD2.D2_COD AND SC2.C2_LOTECTL=SD2.D2_LOTECTL),'') AS [C2_EMISSAO], * FROM  " + RetSQLName("SD2") + " SD2, " + RetSQLName("SG1") + " SG1, " + RetSQLName("SA7") + " SA7 "
cQuery += "	WHERE SD2.D2_DOC      >= '" + mv_par01 + "'   	    	AND "
cQuery += "	      SD2.D2_DOC      <= '" + mv_par02 + "'   	    	AND "
cQuery += "	      SD2.D2_SERIE    >= '" + mv_par03 + "'   	    	AND "
cQuery += "	      SD2.D2_SERIE    <= '" + mv_par04 + "'   	    	AND "
cQuery += "	      SD2.D2_EMISSAO  >= '" + DTOS(mv_par05) + "'   	AND "
cQuery += "	      SD2.D2_EMISSAO  <= '" + DTOS(mv_par06) + "'   	AND "
cQuery += "		  SD2.D_E_L_E_T_  <> '*' 		                    AND "
cQuery += "		  SA7.D_E_L_E_T_  <> '*' 		                    AND "
cQuery += "	      SD2.D2_COD      =  SG1.G1_COD          	    	AND "
cQuery += "	      SD2.D2_TIPO     =  'N'                	    	AND "
cQuery += "	      SD2.D2_COD      =  SA7.A7_PRODUTO       	    	AND "
cQuery += "	      SA7.A7_PRODUTO  =  SG1.G1_COD          	    	AND "
cQuery += "	      SD2.D2_CLIENTE  =  SA7.A7_CLIENTE          	    AND "
cQuery += "	      SD2.D2_LOJA     =  SA7.A7_LOJA             	    AND "
//cQuery += "		  SG1.G1_ATIVIDA  <> '' 		                    AND "
cQuery += "	      SA7.A7_LAUDO    =  '0'          	            	AND "
cQuery += "		  SG1.G1_LAUDO    =  '1' 		                    AND "
cQuery += "		  SG1.D_E_L_E_T_  <> '*' 		                        "
cQuery += "       ORDER BY SD2.D2_COD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSD2",.F.,.T.)

DbSelectArea("TMPSD2")                       
While ("TMPSD2")->(!Eof()) //.AND. TMPSD2->D2_COD <> _cProd
        
	_nLin := 0
	oPrn:StartPage()
	CabecRel()

/*	                                                 		
	_cProd   := TMPSD2->D2_COD
	_cUM     := TMPSD2->G1_UNATVLD //unidade de medida da atividade  antes: POSICIONE("SB1",1,xFilial("SB1") + TMPSD2->D2_COD,"B1_UM" )
	_cUM     := POSICIONE("SAH",4,xFilial("SAH") + Substr(TMPSD2->G1_UNATVLD+SPACE(40),1,40) ,"AH_UNIMED") //codigo da unidade de medida da atividade
	
	//Verifico na SAH se a unimed tem unidade de conversao
	If !Empty(POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_ATIV2"))
		_nFator  := POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_FATOR")
		_cUM2    := POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_ATIV2")  
	/*Else
		_cUM2   := TMPSD2->G1_UNATIV 
		_nFator := 1
	Endif
	*/
/*		Elseif Empty(TMPSD2->G1_ATIVIDA)
		_cUM2   := TMPSD2->G1_UNATVLD 
		_nFator := 1    
	    _nAtivid:= TMPSD2->G1_ATVLAUD
		Else 
		_cUM2   := TMPSD2->G1_UNATIV 
		_nFator := 1   
	Endif
	_cLaudo  := _nAtivid * _nFator
		*/
	
	// INICIO DA ALTERAวรO DANIEL EM 29/06/2017
	_cProd   := TMPSD2->D2_COD	
	IF EMPTY(TMPSD2->G1_UNATVLD)  
		_cUM     := POSICIONE("SAH",4,xFilial("SAH") + Substr(TMPSD2->G1_UNATIV+SPACE(40),1,40) ,"AH_UNIMED") //codigo da unidade de medida da atividade
		_cUM2	 := TMPSD2->G1_UNATIV
		_nAtivid := TMPSD2->G1_ATIVIDA
		_nFator  := 1
		ELSE
		_cUM     := POSICIONE("SAH",4,xFilial("SAH") + Substr(TMPSD2->G1_UNATVLD+SPACE(40),1,40) ,"AH_UNIMED") //codigo da unidade de medida da atividade	
		_cUM2	 := TMPSD2->G1_UNATVLD
		_nAtivid := TMPSD2->G1_ATVLAUD
		_nFator  := 1
	ENDIF		
	 
	If !Empty(POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_ATIV2"))
		_nFator  := POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_FATOR")
		_cUM2    := POSICIONE("SAH",1,xFilial("SAH") + _cUM,"AH_ATIV2")  
	//	_cLaudo  := _nAtivid * _nFator
	//	Else
	//	_cLaudo  := _nAtivid * _nFator
	Endif

	_cLaudo  := _nAtivid * _nFator

	//alert(TMPSD2->D2_COD)
	_nLin := _nLin +0100
	oPrn:Say(_nLin,0100,"PRODUTO",oFont6,100,,,3)
	oPrn:Say(_nLin,0850,POSICIONE("SB1",1,xFilial("SB1") + TMPSD2->D2_COD,"B1_DESC"),oFont1,100,,,3)
	_nLin := _nLin +0060
	oPrn:Say(_nLin,0100,"LOTE",oFont6,100,,,3)
	oPrn:Say(_nLin,0850,TMPSD2->D2_LOTECTL,oFont1,100,,,3)
	_nLin := _nLin +0060

	_dFabr := STOD(TMPSD2->C2_EMISSAO)
		
	DbSelectArea("SB8")
	DbSetOrder(3)
		
	If Empty(_dFabr)
		If Dbseek(xFilial("SB8") + TMPSD2->D2_COD+"98"+TMPSD2->D2_LOTECTL)
			_dFabr := SB8->B8_DATA
		ElseIf Dbseek(xFilial("SB8") + TMPSD2->D2_COD+TMPSD2->D2_LOCAL+TMPSD2->D2_LOTECTL)
			_dFabr := SB8->B8_DATA
	    Else
	    	_dFabr := CTOD("  /  /  ")
	    EndIf
    EndIf
    
	If Dbseek(xFilial("SB8") + TMPSD2->D2_COD+TMPSD2->D2_LOCAL+TMPSD2->D2_LOTECTL)
		_dValid := SB8->B8_DTVALID
    ELse
    	_dValid := CTOD("  /  /  ")
    endif
        
	oPrn:Say(_nLin,0100,"DATA DE FABRICAวรO",oFont6,100,,,3)
	oPrn:Say(_nLin,0850,DTOC(_dFabr),oFont1,100,,,3)
	_nLin := _nLin +0060
	oPrn:Say(_nLin,0100,"VALIDADE",oFont6,100,,,3)
	oPrn:Say(_nLin,0850,DTOC(_dValid),oFont1,100,,,3)
	_nLin := _nLin +0060
	oPrn:Say(_nLin,0100,"NOTA FISCAL",oFont6,100,,,3)
	oPrn:Say(_nLin,0850,TMPSD2->D2_DOC+"-"+TMPSD2->D2_SERIE,oFont1,100,,,3)
	_nLin := _nLin +0150
	
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0010,0120,"Parโmetros",oFont6,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0010,1020,"Especifica็ใo",oFont6,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0010,1820,"Resultado",oFont6,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Atividade Enzimแtica:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mํn.: " + AllTrim(Transform(_cLaudo,"@E 99,999,999")) + " " + _cUM2,oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Chumbo:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 5 ppm",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Ars๊nio:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 3 ppm",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Merc๚rio:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 0,5 ppm",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Cแdmio:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 0,5 ppm",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Coliformes 45บC:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 10 UFC/g",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Salmonella sp.(25 g):",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Aus๊ncia",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Estafilococos coagulase positiva:",oFont1,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 5 X 10ฒ UFC/g",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	_nLin := _nLin +0080
	oPrn:Box(_nLin,0100,_nLin+80,1000)
	oPrn:Say(_nLin+0008,0120,"Bacillus cereus:",oFont2,100,,,3)
	oPrn:Box(_nLin,1000,_nLin+80,1800)
	oPrn:Say(_nLin+0008,1020,"Mแx.: 10ณ UFC/g",oFont1,100,,,3)
	oPrn:Box(_nLin,1800,_nLin+80,2300)
	oPrn:Say(_nLin+0008,1820,"Aprovado*",oFont1,100,,,3)
	
	
	_nLin := _nLin +0500
	
	oPrn:Say(_nLin,0100,"*Estas anแlises nใo sใo feitas lote a lote, mas sim de acordo com o plano de amostragem ",oFont1,100,,,3)
	_nLin := _nLin +0050
	oPrn:Say(_nLin,0100,"e monitoramento de contaminantes Prozyn.",oFont1,100,,,3)
	
	
	_nLin := _nLin +0150
	oPrn:SayBitmap( _nLin,0100,cBitMap2,0400,0400 )  //Logo da assinatura
	_nLin := _nLin +0300
	oPrn:Say(_nLin,0100,"Jadyr Mendes de Oliveira",oFont6,100,,,3)
	_nLin := _nLin +0080
	oPrn:Say(_nLin,0100,"Responsแvel T้cnico",oFont1,100,,,3)
	_nLin := _nLin +0050
	oPrn:Say(_nLin,0100,"CRQ Nบ 04366891",oFont1,100,,,3)
	_nLin := _nLin +0150
	//oPrn:Box(_nLin,0100,_nLin,2300)
	//_nLin := _nLin +0080
	//oPrn:Say(_nLin,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)
	cBitMapRp := "RODAPE.PNG"
	oPrn:SayBitmap( _nLin-100,0000,cBitMapRp,2480,456 )  //RODAPE da empresa
	oPrn:EndPage()
	TMPSD2->(DbSkip())	
	//Endif
EndDo

TMPSD2->(DBCLOSEAREA())

If MV_PAR07 == 1
			
	cQuery := "SELECT * FROM  " + RetSQLName("SD2") + " SD2, " + RetSQLName("SA7") + " SA7, "
	cQuery += "	WHERE SD2.D2_DOC      >= '" + mv_par01 + "'   	    	AND "
	cQuery += "	      SD2.D2_DOC      <= '" + mv_par02 + "'   	    	AND "
	cQuery += "	      SD2.D2_SERIE    >= '" + mv_par03 + "'   	    	AND "
	cQuery += "	      SD2.D2_SERIE    <= '" + mv_par04 + "'   	    	AND "
	cQuery += "	      SD2.D2_EMISSAO  >= '" + DTOS(mv_par05) + "'   	AND "
	cQuery += "	      SD2.D2_EMISSAO  <= '" + DTOS(mv_par06) + "'   	AND "
	cQuery += "		  SD2.D_E_L_E_T_  <> '*' 		                    AND "
	cQuery += "		  SA7.D_E_L_E_T_  <> '*' 		                    AND "
	cQuery += "	      SD2.D2_COD      =  SA7.A7_PRODUTO       	    	AND "
	cQuery += "	      SD2.D2_CLIENTE  =  SA7.A7_CLIENTE          	    AND "
	cQuery += "	      SA7.A7_LAUDO    <>  '0'          	                    "
	cQuery += "      ORDER BY SD2.D2_DOC "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSD2",.F.,.T.)
		
	_lImprime := .F.
	
	DbSelectArea("TMPSD2")
	
	If ("TMPSD2")->(!EOF())
	
		_lImprime := .T.
		
		//Imprime pagina com produtos que nใo foram gerados laudo
		oPrn:StartPage()
		_nLin := 0
		CabecRel()
		_nLin := _nLin +0120
		oPrn:Box(_nLin,0100,_nLin+80,0700)
		oPrn:Say(_nLin+0010,0120,"Produto",oFont6,100,,,3)
		oPrn:Box(_nLin,0700,_nLin+80,1300)
		oPrn:Say(_nLin+0010,0720,"NF",oFont6,100,,,3)
		oPrn:Box(_nLin,1300,_nLin+80,1850)
		oPrn:Say(_nLin+0010,1320,"Lote",oFont6,100,,,3)
		oPrn:Box(_nLin,1850,_nLin+80,2400)
		oPrn:Say(_nLin+0010,1870,"Laudo",oFont6,100,,,3)
	EndIf
	
	While !Eof() .AND. TMPSD2->D2_COD <> _cProd
	

		
		If TMPSD2->A7_LAUDO == "1"
			_cDesLau	:= "NรO REQUERIDO"
		Elseif TMPSD2->A7_LAUDO == "2"
			_cDesLau	:= "ESPECIAL"
		Elseif TMPSD2->A7_LAUDO == "3"
			_cDesLau	:= "ORIGINAL"
		Elseif TMPSD2->A7_LAUDO == "4"
			_cDesLau	:= "SUPER"
		Endif
		
		//	for rt:=1 to 3
		_nLin := _nLin +0080
		oPrn:Box(_nLin,0100,_nLin+80,0700)
		oPrn:Say(_nLin+0010,0120,TMPSD2->D2_COD,oFont6,100,,,3)
		oPrn:Box(_nLin,0700,_nLin+80,1300)
		oPrn:Say(_nLin+0010,0720,TMPSD2->D2_DOC,oFont6,100,,,3)
		oPrn:Box(_nLin,1300,_nLin+80,1850)
		oPrn:Say(_nLin+0010,1320,TMPSD2->D2_LOTECTL,oFont6,100,,,3)
		oPrn:Box(_nLin,1850,_nLin+80,2400)
		oPrn:Say(_nLin+0010,1870,_cDesLau,oFont6,100,,,3)
		//	Next
		If _nLin > 2800
			//_nLin := _nLin +0150
			////oPrn:Box(3120,0100,3120,2400)
			//_nLin := _nLin +0080
			////oPrn:Say(3200,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)
			cBitMapRp := "RODAPE.PNG"
			oPrn:SayBitmap( 3040,0000,cBitMapRp,2480,456 )  //RODAPE da empresa
			oPrn:EndPage()
			oPrn:StartPage()
			_nLin := 0
			CabecRel()
			_nLin := _nLin +0120
			oPrn:Box(_nLin,0100,_nLin+80,0700)
			oPrn:Say(_nLin+0010,0120,"Produto",oFont6,100,,,3)
			oPrn:Box(_nLin,0700,_nLin+80,1300)
			oPrn:Say(_nLin+0010,0720,"NF",oFont6,100,,,3)
			oPrn:Box(_nLin,1300,_nLin+80,1850)
			oPrn:Say(_nLin+0010,1320,"Lote",oFont6,100,,,3)
			oPrn:Box(_nLin,1850,_nLin+80,2400)
			oPrn:Say(_nLin+0010,1870,"Laudo",oFont6,100,,,3)
		Endif
		TMPSD2->(DbSkip())
		
		
	EndDo
	
	If _lImprime
		//_nLin := _nLin +0150
		////oPrn:Box(3120,0100,3120,2400)
		//_nLin := _nLin +0080
		////oPrn:Say(3200,0550,"55.11.3732-0000 | www.prozyn.com.br | info@prozyn.com.br",oFont1,100,,,3)
		cBitMapRp := "RODAPE.PNG"
		oPrn:SayBitmap( 3040,0000,cBitMapRp,2480,456 )  //RODAPE da empresa
		oPrn:EndPage()
	EndIf
	
	DbSelectArea("TMPSD2")	
	TMPSD2->(DBCLOSEAREA())
Endif

oPrn:Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabecRel  บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sub-rotina para impressใo do cabe็alho do impresso.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFATR050                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabecRel()

//oPrn:StartPage()

//Empresa
_nLin := _nLin + 050
cBitMapCb1:= "cabecalho1.Bmp"
cBitMapCb2:= "cabecalho2.Bmp"
//cBitSim := "Simbol.Bmp"
//oPrn:SayBitmap( 0010,0011,cBitMap,040,400 )  //Logo da empresa
oPrn:SayBitmap( _nLin,0100,cBitMapCb1,465,330 )  //Logo da empresa
oPrn:SayBitmap( _nLin,1707,cBitMapCb2,593,330 )  //Logo da empresa
//oPrn:SayBitmap(_nLin,1700,FisxLogo("1"),500,300 )// Imprime logo
//oPrn:Say(0040,3000,AllTrim(SM0->M0_NOMECOM),oFont1,100,,,1)
//_nLin := _nLin +0300
oPrn:Say(_nLin+400,0700,"Certificado de Anแlise",oFont5,100,,,3)
oPrn:Box(_nLin+550,0100,_nLin+550,2300)
_nLin := _nLin +0600


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณRicardo Nisiyama      บ Data ณ  28/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se as perguntas existem na SX1. Caso nใo existam,  บฑฑ
ฑฑบ          ณas cria.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 (RFATR050)                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Local j
Local i
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,10)
aRegs   :={}

AADD(aRegs,{cPerg,"01","Da Nota Fiscal   ?","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2",""})
AADD(aRegs,{cPerg,"02","Ate Nota Fiscal  ?","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF2",""})
AADD(aRegs,{cPerg,"03","Da Serie         ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Serie        ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Data          ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Data         ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Imprime resumo outros laudos (S/N):      ?","","","mv_ch7","N",01,0,0,"C","","MV_PAR07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next

dbSelectArea(_sAlias)
Return
