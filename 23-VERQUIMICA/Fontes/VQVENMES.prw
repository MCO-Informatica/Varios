#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

User Function VQVENMES()

/*
//==========================================
Pergunte("VQRLFATAN",.T.)

//==========================================
dDtIni	:=DtoS(Mv_Par01)
dDtFim	:=DtoS(Mv_Par02)                                                     
*/


//==========================================

cQuery := " 		SELECT    " 
cQuery += " 		D2_CLIENTE COD, A1_NREDUZ NOME,   "
//cQuery += " 		D2_COD, B1_DESC,   "
cQuery += "		SUM( CASE WHEN MES = '01' THEN D2_QUANT ELSE 0 END )  JAN,     "
cQuery += "		SUM( CASE WHEN MES = '02' THEN D2_QUANT ELSE 0 END )  FEV,     "
cQuery += "		SUM( CASE WHEN MES = '03' THEN D2_QUANT ELSE 0 END )  MAR,     "
cQuery += "		SUM( CASE WHEN MES = '04' THEN D2_QUANT ELSE 0 END )  ABR,     "
cQuery += "		SUM( CASE WHEN MES = '05' THEN D2_QUANT ELSE 0 END )  MAIO,     "
cQuery += "		SUM( CASE WHEN MES = '06' THEN D2_QUANT ELSE 0 END )  JUN,   "
cQuery += "		SUM( CASE WHEN MES = '07' THEN D2_QUANT ELSE 0 END )  JUL,     "
cQuery += "		SUM( CASE WHEN MES = '08' THEN D2_QUANT ELSE 0 END )  AGO,     "
cQuery += "		SUM( CASE WHEN MES = '09' THEN D2_QUANT ELSE 0 END )  SETE,     "
cQuery += "		SUM( CASE WHEN MES = '10' THEN D2_QUANT ELSE 0 END )  OUTU,     "
cQuery += "		SUM( CASE WHEN MES = '11' THEN D2_QUANT ELSE 0 END )  NOV,     "
cQuery += "		SUM( CASE WHEN MES = '12' THEN D2_QUANT ELSE 0 END )  DEZ,   "
cQuery += "		SUM( D2_QUANT )  TOTAL,   "
cQuery += "		SUM( D2_QUANT )/12  MEDIA,   "
cQuery += "		MAX( D2_QUANT )  MAIOR   "
cQuery += "		FROM (SELECT SUBSTRING(D2_EMISSAO,5,2)  MES,   "
cQuery += "		D2_CLIENTE, A1_NREDUZ,    "
//cQuery += "		D2_COD, B1_DESC,   "
cQuery += "		D2_QUANT   "
cQuery += "		FROM SD2010 SD2, SF4010 SF4, SA1010 SA1, SB1010 SB1   "
cQuery += "		 WHERE SD2.D_E_L_E_T_ <> '*'  "
cQuery += "		 AND SF4.D_E_L_E_T_ <> '*'    "
cQuery += "		 AND SA1.D_E_L_E_T_ <> '*'    "
cQuery += "		 AND SB1.D_E_L_E_T_ <> '*'    "
cQuery += "		 AND D2_COD = B1_COD   		  "
cQuery += "		 AND D2_CLIENTE = A1_COD      "
cQuery += "		 AND D2_LOJA = A1_LOJA        "
cQuery += "		 AND D2_TES = F4_CODIGO       "
cQuery += "		 AND F4_DUPLIC = 'S'          "
cQuery += "		 AND D2_EMISSAO BETWEEN '20140501' AND '20150631'   "
cQuery += "		 AND D2_TIPO = 'N')  D2   "
//cQuery += "		  GROUP BY D2_COD, B1_DESC   "
cQuery += "		  GROUP BY D2_CLIENTE, A1_NREDUZ   "
//cQuery += "		  --ORDER BY D2_CLIENTE, A1_NREDUZ   "

//==========================================   
xSize		:= MsAdvSize(.F.,.F.)
xInfo 		:= { xSize[ 1 ], xSize[ 2 ], xSize[ 3 ], xSize[ 4 ], 3, 3 } 
DEFINE MSDIALOG oDlg FROM xSize[7],0 To xSize[6],xSize[5] of oMainWnd PIXEL
oPanel		:= tPanel():Create(oDlg,xSize[1],xSize[2],"RELATORIO DE FATURAMENTO MENSAL"	,,,,,,xSize[3],xSize[4])


//==========================================
oBrowse:=FWBrowse():New(oPanel)
oBrowse:SetDataQuery()
oBrowse:SetQuery(cQuery)
oBrowse:SetAlias("DADOS")                                                                                                                          


//========================================================================================================================
ADD COLUMN oColumn DATA { ||Alltrim(COD)			} 		TITLE "CLIENTE "   	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Alltrim(NOME)			} 		TITLE "NOME " 	   	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||JAN								} 		TITLE "JANEIRO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(FEV,  "@E 9,999,999.99")			} 		TITLE "FEVEREIRO "	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(MAR,  "@E 9,999,999.99")			} 		TITLE "MARCO " 	  	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(ABR,  "@E 9,999,999.99")			} 		TITLE "ABRIL " 	  	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(MAIO, "@E 9,999,999.99")			} 		TITLE "MAIO " 	  	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(JUN,  "@E 9,999,999.99")			} 		TITLE "JUNHO " 	  	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(JUL,  "@E 9,999,999.99")			} 		TITLE "JULHO " 	  	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(AGO,  "@E 9,999,999.99")			} 		TITLE "AGOSTO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(SETE, "@E 9,999,999.99")			} 		TITLE "SETEMBRO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(OUTU, "@E 9,999,999.99")			} 		TITLE "OUTUBRO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(NOV,  "@E 9,999,999.99")			} 		TITLE "NOVEMBRO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(DEZ,  "@E 9,999,999.99")			} 		TITLE "DEZEMBRO " 	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(TOTAL, "@E 99,999,999.99")			} 		TITLE "TOTAL " 	   	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(MEDIA, "@E 9,999,999.99")			} 		TITLE "MEDIA " 	   	SIZE  10 OF oBrowse
ADD COLUMN oColumn DATA { ||Transform(MAIOR, "@E 9,999,999.99")			} 		TITLE "MAIOR VENDA" SIZE  10 OF oBrowse


//==============================================
oBrowse:DisableConfig()
oBrowse:DisableSaveConfig()
oBrowse:SetDelete(.F.)
oBrowse:SetEditCell(.F.)
oBrowse:SetInsert(.F.)
                        

ACTIVATE FWBROWSE oBrowse
ACTIVATE MSDIALOG oDlg CENTERED

                        
Return()