
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR008  บAutor  ณMicrosiga           บ Data ณ  01/24/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ     RELATORIO EXTRAวรO DO BUDGET E FORECAST                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFATR008()  

Local _cRotina	:= "RFATR008"
Local _cFile	:= _cRotina
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _nQtdCopy	:= 1
Local _cFolder  := cGetFile( '*.xml' , 'Excel (XML)', 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T.)

Local aValores := {}
Local nJ := 0	

Local _cAliasTmp:= GetNextAlias() 

Private oExcel		:= FWMSEXCEL():New()

Private _aPar		:= {}

Private cPerg		:= _cRotina

ValidPerg()

Pergunte(cPerg,.T.)

_cQry := " SELECT SBM1.BM_DESC,A1_VEND,A3_NREDUZ, A1_NOME,
_cQry += " B1_DESCINT, A1_NREDUZ, Z2_PRODUTO,	Z2_CLIENTE,	Z2_LOJA,	Z2_ANO,	Z2_TOPICO,	Z2_QTM01,	Z2_QTM02,	Z2_QTM03,	Z2_QTM04,	Z2_QTM05,	Z2_QTM06,	Z2_QTM07,	Z2_QTM08,	Z2_QTM09,	Z2_QTM10,	Z2_QTM11,	Z2_QTM12,
_cQry += " Z2_QTM01 *Z2_PRECO01 VLR1,	Z2_QTM02*Z2_PRECO02 VLR2,	Z2_QTM03*Z2_PRECO03 VLR3,	Z2_QTM04*Z2_PRECO04 VLR4,	Z2_QTM05*Z2_PRECO05 VLR5,	
_cQry += " Z2_QTM06*Z2_PRECO06 VLR6,	Z2_QTM07*Z2_PRECO07 VLR7,	Z2_QTM08*Z2_PRECO08 VLR8,	Z2_QTM09*Z2_PRECO09 VLR9,	Z2_QTM10*Z2_PRECO10 VLR10,	Z2_QTM11*Z2_PRECO11 VLR11,	Z2_QTM12*Z2_PRECO12 VLR12 FROM SZ2010 Z2
_cQry += " INNER JOIN SA1010 A1 ON A1_COD = Z2_CLIENTE AND A1_LOJA = Z2_LOJA AND A1.D_E_L_E_T_<> '*'
_cQry += " INNER JOIN SB1010 B1 ON B1_COD = Z2_PRODUTO AND B1.D_E_L_E_T_<> '*' 
_cQry += " INNER JOIN SA3010 A3 ON A3_COD = A1_VEND AND A3.D_E_L_E_T_ <> '*'
_cQry += " LEFT JOIN SA7010 A7 ON A7_CLIENTE = Z2_CLIENTE AND A7_LOJA = Z2_LOJA AND A7_PRODUTO = Z2_PRODUTO AND A7.D_E_L_E_T_<> '*'
_cQry += " LEFT JOIN AOV010 AOV WITH (NOLOCK)ON  AOV.D_E_L_E_T_ <> '*' AND A7_XSEGMEN = AOV.AOV_CODSEG
_cQry += " LEFT JOIN SBM010 SBM1 WITH (NOLOCK) ON SBM1.D_E_L_E_T_='' AND SBM1.BM_FILIAL='01' AND SBM1.BM_GRUPO=AOV.AOV_GRUPO 
_cQry += " WHERE
_cQry += " (Z2_QTM01<>0 OR Z2_QTM02<>0 OR Z2_QTM03<>0 OR Z2_QTM04<>0 OR Z2_QTM05<>0 OR Z2_QTM06<>0 OR Z2_QTM07<>0 OR Z2_QTM08<>0 OR Z2_QTM09<>0 OR Z2_QTM10<>0 OR Z2_QTM11<>0 OR Z2_QTM12<>0)  
_cQry += " AND Z2_ANO = '"+MV_PAR01+"' AND 
IF MV_PAR02 == 1
_cQry += " Z2_TOPICO = 'B' AND
ELSE
_cQry += " Z2_TOPICO = 'F' AND
ENDIF
_cQry += " SBM1.BM_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND
_cQry += " A1_VEND BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND
_cQry += " A1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND
_cQry += " B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  AND
_cQry += " Z2.D_E_L_E_T_<> '*' 

memowrite("rfatr008.txt",_cQry)
//Cria tabela temporแria com base no resultado da query 7
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)
	
dbSelectArea(_cAliasTmp)
DbGotop()
	

IF MV_PAR02 == 1 

//Sheet1 - Parโmetros
oExcel:AddworkSheet("BUDGET")
oExcel:AddTable("BUDGET","BUDGET") 
oExcel:AddColumn("BUDGET","BUDGET","Gerente",1,1)
oExcel:AddColumn("BUDGET","BUDGET","Unid Negocio",1,1)  
oExcel:AddColumn("BUDGET","BUDGET","Cod Produto",1,1)
oExcel:AddColumn("BUDGET","BUDGET","Produto",1,1)  
oExcel:AddColumn("BUDGET","BUDGET","Cod Cliente",1,1)
oExcel:AddColumn("BUDGET","BUDGET","Cliente",1,1)    
oExcel:AddColumn("BUDGET","BUDGET","Loja",1,1) 
oExcel:AddColumn("BUDGET","BUDGET","Ano",1,1)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Jan",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Jan",1,2)               
oExcel:AddColumn("BUDGET","BUDGET","Qtd Fev",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Fev",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Mar",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Mar",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Abr",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Abr",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Mai",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Mai",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Jun",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Jun",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Jul",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Jul",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Ago",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Ago",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Set",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Set",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Out",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Out",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Nov",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Nov",1,2)
oExcel:AddColumn("BUDGET","BUDGET","Qtd Dez",1,2) 
oExcel:AddColumn("BUDGET","BUDGET","Vlr Dez",1,2)

While !EOF()	

AAdd( aValores,{SUBSTR((_cAliasTmp)->A3_NREDUZ,1,30),;
				SUBSTR((_cAliasTmp)->BM_DESC,1,30),;  
				SUBSTR((_cAliasTmp)->Z2_PRODUTO,1,30),;
		     	SUBSTR((_cAliasTmp)->B1_DESCINT,1,30),;                
		     	SUBSTR((_cAliasTmp)->Z2_CLIENTE,1,30),;
				SUBSTR((_cAliasTmp)->A1_NREDUZ,1,30),;   
				SUBSTR((_cAliasTmp)->Z2_LOJA,1,30),;
			    (_cAliasTmp)->Z2_ANO,;
				Transform(ROUND((_cAliasTmp)->Z2_QTM01,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR1,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM02,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR2,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM03,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR3,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM04,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR4,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM05,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR5,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM06,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR6,0) ,"@E 999,999,999"),;	  
				Transform(ROUND((_cAliasTmp)->Z2_QTM07,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR7,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM08,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR8,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM09,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR9,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM10,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR10,0) ,"@E 999,999,999"),;			
				Transform(ROUND((_cAliasTmp)->Z2_QTM11,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->VLR11,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM12,0) ,"@E 999,999,999"),;            
				Transform(ROUND((_cAliasTmp)->VLR12,0) ,"@E 999,999,999")})				
DbSkip()
	
EndDo	

For nK := 1 to len(aValores)
	
oExcel:AddRow("BUDGET", "BUDGET",{aValores[nK][1],;
	aValores[nK][2],;
	aValores[nK][3],;
	aValores[nK][4],;
	aValores[nK][5],;
    aValores[nK][6],;
	aValores[nK][7],;
	aValores[nK][8],;
	aValores[nK][9],;
	aValores[nK][10],;
	aValores[nK][11],;
	aValores[nK][12],;   
	aValores[nK][13],;
	aValores[nK][14],;
	aValores[nK][15],;
	aValores[nK][16],;
	aValores[nK][17],;
	aValores[nK][18],;
	aValores[nK][19],;
	aValores[nK][20],;
	aValores[nK][21],;
	aValores[nK][22],;
	aValores[nK][23],;
	aValores[nK][24],;
	aValores[nK][25],;
	aValores[nK][26],;
	aValores[nK][27],;
	aValores[nK][28],; 
	aValores[nK][29],;
	aValores[nK][30],;
	aValores[nK][31],;
	aValores[nK][32]}) 

Next

oExcel:Activate()
oExcel:GetXMLFile("Budget.xml")

__CopyFile("Budget.xml",_cFolder+"Budget.xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cFolder+"Budget.xml.") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf


Else

//Sheet1 - Parโmetros
oExcel:AddworkSheet("FORECAST")
oExcel:AddTable("FORECAST","FORECAST") 
oExcel:AddColumn("FORECAST","FORECAST","Gerente",1,1)
oExcel:AddColumn("FORECAST","FORECAST","Unid Negocio",1,1)  
oExcel:AddColumn("FORECAST","FORECAST","Cod Produto",1,1)
oExcel:AddColumn("FORECAST","FORECAST","Produto",1,1)  
oExcel:AddColumn("FORECAST","FORECAST","Cod Cliente",1,1)
oExcel:AddColumn("FORECAST","FORECAST","Cliente",1,1)    
oExcel:AddColumn("FORECAST","FORECAST","Loja",1,1) 
oExcel:AddColumn("FORECAST","FORECAST","Ano",1,1)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Jan",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Jan",1,2)               
oExcel:AddColumn("FORECAST","FORECAST","Qtd Fev",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Fev",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Mar",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Mar",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Abr",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Abr",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Mai",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Mai",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Jun",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Jun",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Jul",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Jul",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Ago",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Ago",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Set",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Set",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Out",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Out",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Nov",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Nov",1,2)
oExcel:AddColumn("FORECAST","FORECAST","Qtd Dez",1,2) 
oExcel:AddColumn("FORECAST","FORECAST","Vlr Dez",1,2)

While !EOF()	

_cCodCli  := ALLTRIM((_cAliasTmp)->Z2_CLIENTE)
_cLojaCli := ALLTRIM((_cAliasTmp)->Z2_LOJA)
_cCodProd := PADR((_cAliasTmp)->Z2_PRODUTO,TAMSX3("Z2_PRODUTO")[01])
_cAno     := mv_par01


_nVLR_FCT := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,"2")	

_VLR1:= (_cAliasTmp)->Z2_QTM01 *_nVLR_FCT
_VLR2:= (_cAliasTmp)->Z2_QTM02 *_nVLR_FCT
_VLR3:= (_cAliasTmp)->Z2_QTM03 *_nVLR_FCT
_VLR4:= (_cAliasTmp)->Z2_QTM04 *_nVLR_FCT
_VLR5:= (_cAliasTmp)->Z2_QTM05 *_nVLR_FCT
_VLR6:= (_cAliasTmp)->Z2_QTM06 *_nVLR_FCT
_VLR7:= (_cAliasTmp)->Z2_QTM07 *_nVLR_FCT
_VLR8:= (_cAliasTmp)->Z2_QTM08 *_nVLR_FCT 
_VLR9:= (_cAliasTmp)->Z2_QTM09 *_nVLR_FCT
_VLR10:= (_cAliasTmp)->Z2_QTM10 *_nVLR_FCT
_VLR11:= (_cAliasTmp)->Z2_QTM11 *_nVLR_FCT
_VLR12:= (_cAliasTmp)->Z2_QTM12 *_nVLR_FCT

AAdd( aValores,{SUBSTR((_cAliasTmp)->A3_NREDUZ,1,30),;
				SUBSTR((_cAliasTmp)->BM_DESC,1,30),;  
				SUBSTR((_cAliasTmp)->Z2_PRODUTO,1,30),;
		     	SUBSTR((_cAliasTmp)->B1_DESCINT,1,30),;                
		     	SUBSTR((_cAliasTmp)->Z2_CLIENTE,1,30),;
				SUBSTR((_cAliasTmp)->A1_NREDUZ,1,30),;   
				SUBSTR((_cAliasTmp)->Z2_LOJA,1,30),;
			    (_cAliasTmp)->Z2_ANO,;
				Transform(ROUND((_cAliasTmp)->Z2_QTM01,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR1,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM02,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR2,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM03,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR3,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM04,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR4,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM05,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR5,0) ,"@E 999,999,999"),;
				Transform(ROUND((_cAliasTmp)->Z2_QTM06,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR6,0) ,"@E 999,999,999"),;	  
				Transform(ROUND((_cAliasTmp)->Z2_QTM07,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR7,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM08,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR8,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM09,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR9,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM10,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR10,0) ,"@E 999,999,999"),;			
				Transform(ROUND((_cAliasTmp)->Z2_QTM11,0) ,"@E 999,999,999"),;
				Transform(ROUND(_VLR11,0) ,"@E 999,999,999"),;				
				Transform(ROUND((_cAliasTmp)->Z2_QTM12,0) ,"@E 999,999,999"),;            
				Transform(ROUND(_VLR12,0) ,"@E 999,999,999")})				
DbSkip()

EndDo	

For nK := 1 to len(aValores)    
	
oExcel:AddRow("FORECAST", "FORECAST",{aValores[nK][1],;
	aValores[nK][2],;
	aValores[nK][3],;
	aValores[nK][4],;
	aValores[nK][5],;
    aValores[nK][6],;
	aValores[nK][7],;
	aValores[nK][8],;
	aValores[nK][9],;
	aValores[nK][10],;
	aValores[nK][11],;
	aValores[nK][12],;   
	aValores[nK][13],;
	aValores[nK][14],;
	aValores[nK][15],;
	aValores[nK][16],;
	aValores[nK][17],;
	aValores[nK][18],;
	aValores[nK][19],;
	aValores[nK][20],;
	aValores[nK][21],;
	aValores[nK][22],;
	aValores[nK][23],;
	aValores[nK][24],;
	aValores[nK][25],;
	aValores[nK][26],;
	aValores[nK][27],;
	aValores[nK][28],; 
	aValores[nK][29],;
	aValores[nK][30],;
	aValores[nK][31],;
	aValores[nK][32]}) 

Next



//	Transform(aValores[nK][6],"@E 999,999,999"),;
   
oExcel:Activate()
oExcel:GetXMLFile("FORECAST.xml")

__CopyFile("FORECAST.xml",_cFolder+"FORECAST.xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cFolder+"FORECAST.xml.") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

ENDIF



Return()
           

Static Function ValidPerg()

Local _sAlias	:= GetArea()
Local aRegs		:= {}
Local _x		:= 1
Local _y		:= 1
cPerg			:= PADR(cPerg,10)



AADD(aRegs,{cPerg,"01","Ano Ref:"							,"","","mv_ch1","C",04,0,3,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tipo:"						    	,"","","mv_ch2","C",01,0,3,"G","","MV_PAR02","B-BUDGET","","","","F-FORECAST","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cliente De:"						,"","","mv_ch3","C",06,0,3,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN","","","",""})
AADD(aRegs,{cPerg,"04","Cliente Ate:"						,"","","mv_ch4","C",06,0,3,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN","","","",""})  
AADD(aRegs,{cPerg,"05","Produto De:"						,"","","mv_ch5","C",15,0,3,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"06","Produto Ate:"						,"","","mv_ch6","C",15,0,3,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"07","Unid Negocio De:"					,"","","mv_ch7","C",15,0,3,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"08","Unid Negocio Ate:"					,"","","mv_ch8","C",15,0,3,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"09","Vendedor De:"						,"","","mv_ch9","C",06,0,3,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","",""})
AADD(aRegs,{cPerg,"10","Vendedor Ate:"						,"","","mv_cha","C",06,0,3,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","",""})
For _x := 1 To Len(aRegs)
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
		RecLock("SX1",.T.)		
		For _y := 1 To FCount()                              
			If _y <= Len(aRegs[_x])                         
				FieldPut(_y,aRegs[_x,_y])        
			Else
				Exit
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next

RestArea(_sAlias)





