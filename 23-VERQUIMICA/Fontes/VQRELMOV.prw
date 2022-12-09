#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VQRELMOVº   Autor  ³Felipe Pieroni    º Data ³  06/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório que exporta direto para o Excel                   ±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VQRELMOV()

Local a_area   := {}
Private	cPerg := "VQ_MAPA"


PutSX1(cPerg,"01","Tipo"	  ,"","","MV_CH1","N",01,0,1,"C",""							 ,""   ,"","","MV_PAR01","Policia Federal","","","","Exercito","","","Policia Civil","","","Todos","","","","","","","","")
PutSX1(cPerg,"02","Grupo de"  ,"","","MV_CH2","C",5,0,0,"G","Vazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR02",""		   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"03","Grupo Ate" ,"","","MV_CH3","C",5,0,0,"G","Vazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR03",""	  	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Periodo De","","","MV_CH4","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR04",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Periodo Ate","","","MV_CH5","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR05",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")

If !Pergunte(cPerg,.T.)
	Return()
EndIF

a_area := getarea()

//Processa({|| GeraPlanila()}, "Relatorio em Excel", "Exportando Dados...",.T.)
Processa({|| PVQRELVD() }, "Relatorio em Excel", "Exportando Dados...",.T.)

Restarea(a_area)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GeraPlanilaº Autor  ³Felipe Pieroni    º Data ³  19/09/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GeraPlanila()

Local _aArea 	:= GetArea()      // salvo area atual
Local aStru     := {}
Local _lRet		:= .T.
Local nLinFim   := 65
Local cTitExcel := ""
Local oExcel
Private lAbortPrint := .F.
Private cPeriodoAnt := STOD(left(dtos(MV_PAR04),6)+"01")-1
Private cPeriodoDe  := dtos(MV_PAR04)
Private cPeriodoAte := dtos(MV_PAR05)

cArqEDI	:= "LOTEBF"

AADD(aStru, {"GRUPO"	,"C",006,00})	
AADD(aStru, {"DESCRICAO","C",020,00})	
AADD(aStru, {"COD_VERQ" ,"C",020,00})	
AADD(aStru, {"PRODUTO"	,"C",015,00})	
AADD(aStru, {"NOME"	    ,"C",050,00})	
AADD(aStru, {"UM"	    ,"C",002,00})	
AADD(aStru, {"TIPO"	    ,"C",002,00})	
AADD(aStru, {"POS_IPI"	,"C",010,00})

AADD(aStru, {"SALDO_I"	,"N",014,03})
AADD(aStru, {"COMPRA"	,"N",014,03})
AADD(aStru, {"DEV_COMP"	,"N",014,03})
AADD(aStru, {"PRODUCAO"	,"N",014,03})
AADD(aStru, {"CONSUMO"	,"N",014,03})
AADD(aStru, {"AJUSTE_E"	,"N",014,03})
AADD(aStru, {"AJUSTE_S"	,"N",014,03})
AADD(aStru, {"VENDA"	,"N",014,03})
AADD(aStru, {"DEV_VEND"	,"N",014,03})
AADD(aStru, {"SALDO_F"	,"N",014,03})

cArqTemp := CriaTrab(aStru,.T.)
DbuseArea(.T.,,cArqTemp,"_TRX")

                  
_cQry :=	" SELECT  B1_GRUPO, BM_DESC, B1_COD, B1_DESC, B1_TIPO, B1_VQ_COD, B1_UM, B1_POSIPI from "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB5")+" SB5, "+RetSqlName("SBM")+" SBM "
_cQry +=	" WHERE SB1.D_E_L_E_T_ = '' "
_cQry +=	" AND SB5.D_E_L_E_T_ = '' "
_cQry +=	" AND SBM.D_E_L_E_T_ = '' "  
_cQry +=	" AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
_cQry +=	" AND SB5.B5_FILIAL = '"+xFilial("SB5")+"' "
_cQry +=	" AND SBM.BM_FILIAL = '"+xFilial("SBM")+"' "
_cQry +=	" AND B1_COD = B5_COD "
_cQry +=	" AND B1_GRUPO = BM_GRUPO "           
_cQry +=	" AND B1_GRUPO BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' " 


If MV_PAR01 = 1 // Policia Federal
	_cQry +=	" AND B5_PRODPF = 'S' "
ElseIf MV_PAR01 = 3 // Policia Civil
	_cQry +=	" AND B5_PRODPC = 'S' "
ElseIf MV_PAR01 = 2 // Exercito
	_cQry +=	" AND B5_PRODEX = 'S' "
EndIf

_cQry +=	" ORDER BY B1_GRUPO, B1_COD "

_cQry := ChangeQuery(_cQry)

TCQUERY _cQry NEW ALIAS "TRB"

nContPg := 1
nLin:= 80

oExcel := FWMSEXCEL():New()
oExcel:AddworkSheet("MAPA")
oExcel:AddTable("MAPA","MAPA 1")
oExcel:AddColumn("MAPA","MAPA 1","GRUPO",1,1)
oExcel:AddColumn("MAPA","MAPA 1","DESCRICAO",2,2)
oExcel:AddColumn("MAPA","MAPA 1","COD_VERQ",3,3)
oExcel:AddColumn("MAPA","MAPA 1","PRODUTO",1,1)
oExcel:AddColumn("MAPA","MAPA 1","NOME",1,1)
oExcel:AddColumn("MAPA","MAPA 1","UM",1,1)
oExcel:AddColumn("MAPA","MAPA 1","TIPO",1,1)
oExcel:AddColumn("MAPA","MAPA 1","POS_IPI",1,1)
oExcel:AddColumn("MAPA","MAPA 1","SALDO_I",1,1)
oExcel:AddColumn("MAPA","MAPA 1","COMPRA",1,1)
oExcel:AddColumn("MAPA","MAPA 1","DEV_COMP",1,1)
oExcel:AddColumn("MAPA","MAPA 1","PRODUCAO",1,1)
oExcel:AddColumn("MAPA","MAPA 1","CONSUMO",1,1)
oExcel:AddColumn("MAPA","MAPA 1","AJUSTE_E",1,1)
oExcel:AddColumn("MAPA","MAPA 1","AJUSTE_S",1,1)
oExcel:AddColumn("MAPA","MAPA 1","VENDA",1,1)
oExcel:AddColumn("MAPA","MAPA 1","DEV_VEND",1,1)
oExcel:AddColumn("MAPA","MAPA 1","SALDO_F",1,1)

DbSelectArea("TRB")
TRB->(DbGoTop())
While !TRB->(Eof())
	
	IncProc(" Processando Dados " )
	
	If nLin > nLinFim
//		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin:= 0
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "| IMPRESSO EM: "+DTOC(dDatabase)+"                  RELAÇÃO DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURANÇA PUBLICA               PERÍODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))+"                    Folha:"+Transform(nContPg,"@E 9999")
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| EMPRESA: VERQUIMICA IND. COM. PROD. QUI.                        END.: AV. MARTINS JUNIOR, 2000                  GUARULHOS - SP - CEP: 07141-000          TEL: 2404-8800 FAX: 2404-8813 "
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| CGC: 43.588.060/0001-80           INSCRIÇÃO ESTADUAL: 336.125.845.118              CERTIFICADO DE VISTORIA: 079/13               DATADO DE 25/03/2013                   LICENÇA No.: 291/266/280 "
	    @nLin,219 pSay "|"	    
		nLin++	    
		@nLin,000 pSay Replicate("-",220)
		nLin++
    	@nLin,000 pSay " PRODUTO                                SALDO ANTERIOR                ENTRADAS                      PERDAS/SOBRAS                 SAIDAS                        UTILIZACAO                    SALDO"
		nLin++	    
		@nLin,000 pSay Replicate("=",220)
		nLin++	    
		cQuebra := ""
		nContPg++
	EndIf

	
	cGrupo :=	TRB->B1_GRUPO

    nSalIni := 0
    nEntra  := 0
    nPerda  := 0
    nSaida  := 0
    nUtil   := 0
    nSaldo  := 0

	@nLin,001 pSay SubStr(TRB->BM_DESC,1,20)

	
	While !TRB->(Eof()) .And. cGrupo ==	TRB->B1_GRUPO

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		If nLin > nLinFim
	//		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin:= 0
			@nLin,000 pSay Replicate("-",220)
			nLin++
		    @nLin,000 pSay "| IMPRESSO EM: "+DTOC(dDatabase)+"                  RELAÇÃO DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURANÇA PUBLICA               PERÍODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))+"                    Folha:"+Transform(nContPg,"@E 9999")
		    @nLin,219 pSay "|"
			nLin++
		    @nLin,000 pSay "| EMPRESA: VERQUIMICA IND. COM. PROD. QUI.                        END.: AV. MARTINS JUNIOR, 2000                  GUARULHOS - SP - CEP: 07141-000          TEL: 2404-8800 FAX: 2404-8813 "
		    @nLin,219 pSay "|"
			nLin++
		    @nLin,000 pSay "| CGC: 43.588.060/0001-80           INSCRIÇÃO ESTADUAL: 336.125.845.118              CERTIFICADO DE VISTORIA: 079/13               DATADO DE 25/03/2013                   LICENÇA No.: 291/266/280 "
		    @nLin,219 pSay "|"	    
			nLin++	    
			@nLin,000 pSay Replicate("-",220)
			nLin++
	    	@nLin,000 pSay " PRODUTO                                SALDO ANTERIOR                ENTRADAS                      PERDAS/SOBRAS                 SAIDAS                        UTILIZACAO                    SALDO"
			nLin++	    
			@nLin,000 pSay Replicate("=",220)
			nLin++	    
			cQuebra := ""
			nContPg++
		EndIf
	//                            1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                  DD/MM/AAAA     1234567890123456789012345678901234567890     1234567890123456789012345678901234567890     123456789012345678901234567890   123456789012345678901234567890   1234567890  12345678901234567890  999,999,999.99
	
	
	
	    nSalIni += SALDOB9(TRB->B1_COD,cPeriodoAnt)

	    nEntra  += (COMPRA(TRB->B1_COD,"N")+COMPRA(TRB->B1_COD,"D"))
	    nPerda  += (MOVSD3(TRB->B1_COD,"DEV")-MOVSD3(TRB->B1_COD,"REQ"))
	    nSaida  += (VENDA(TRB->B1_COD,"N")+VENDA(TRB->B1_COD,"D"))
	    nUtil   += (MOVSD3(TRB->B1_COD,"PRO")-MOVSD3(TRB->B1_COD,"CON"))
	    nSaldo  := nSalIni+nEntra+nPerda-nSaida+nUtil
//	    _TRX->(SALDO_I+COMPRA-DEV_COMP+PRODUCAO-CONSUMO+AJUSTE_E-AJUSTE_S-VENDA+DEV_VEND)         
//X->SALDO_F   := _TRX->(SALDO_I+COMPRA-DEV_COMP+PRODUCAO-CONSUMO+AJUSTE_E-AJUSTE_S-VENDA+DEV_VEND)	    
	    
	    /*
		@nLin,001 pSay SubStr(TRB->BM_DESC,1,20)
		// SALDO INICIAL
		@nLin,40 pSay SALDOB9(TRB->B1_COD,cPeriodoAnt) PICTURE "@E 999,999,999.99"
		// ENTRADAS
		@nLin,064 pSay COMPRA(TRB->B1_COD,"N")+COMPRA(TRB->B1_COD,"D")	PICTURE "@E 99,999,999.99"
		// PERDAS E SOBRAS
		@nLin,099 pSay MOVSD3(TRB->B1_COD,"DEV")-MOVSD3(TRB->B1_COD,"REQ") PICTURE "@E 99,999,999.99"
		// SAIDAS
		@nLin,122 pSay (VENDA(TRB->B1_COD,"N")+VENDA(TRB->B1_COD,"D"))*(-1) PICTURE "@E 99,999,999.99"
		// UTILIZACAO
		@nLin,156 pSay MOVSD3(TRB->B1_COD,"CON")  PICTURE "@E 99,999,999.99"
		// SALDO
		@nLin,182 pSay _TRX->(SALDO_I+COMPRA-DEV_COMP+PRODUCAO-CONSUMO+AJUSTE_E-AJUSTE_S-VENDA+DEV_VEND) PICTURE "@E 99,999,999.99"
	    */

		RecLock("_TRX",.T.)
		_TRX->GRUPO     := TRB->B1_GRUPO
		_TRX->DESCRICAO := TRB->BM_DESC
		_TRX->COD_VERQ  := TRB->B1_VQ_COD
		_TRX->PRODUTO   := TRB->B1_COD
		_TRX->NOME      := TRB->B1_DESC
		_TRX->TIPO      := TRB->B1_TIPO	
		_TRX->UM        := TRB->B1_UM
		_TRX->POS_IPI   := TRB->B1_POSIPI
	
		_TRX->SALDO_I   := SALDOB9(TRB->B1_COD,cPeriodoAnt)
		_TRX->COMPRA    := COMPRA(TRB->B1_COD,"N")
		_TRX->DEV_COMP  := VENDA(TRB->B1_COD,"D")	
		_TRX->PRODUCAO  := MOVSD3(TRB->B1_COD,"PRO")
		_TRX->CONSUMO   := MOVSD3(TRB->B1_COD,"CON")
		_TRX->AJUSTE_E  := MOVSD3(TRB->B1_COD,"DEV")
		_TRX->AJUSTE_S  := MOVSD3(TRB->B1_COD,"REQ")
		_TRX->VENDA     := VENDA(TRB->B1_COD,"N")
		_TRX->DEV_VEND  := COMPRA(TRB->B1_COD,"D")	
		_TRX->SALDO_F   := 	_TRX->(SALDO_I+COMPRA-DEV_COMP+PRODUCAO-CONSUMO+AJUSTE_E-AJUSTE_S-VENDA+DEV_VEND)
	
		_TRX->(msUnlock())
		
		oExcel:AddRow("MAPA","MAPA 1",{TRB->B1_GRUPO,TRB->BM_DESC,TRB->B1_VQ_COD,TRB->B1_COD,TRB->B1_DESC,TRB->B1_TIPO,TRB->B1_UM,TRB->B1_POSIPI,SALDOB9(TRB->B1_COD,cPeriodoAnt),COMPRA(TRB->B1_COD,"N"),VENDA(TRB->B1_COD,"D"),MOVSD3(TRB->B1_COD,"PRO"),	MOVSD3(TRB->B1_COD,"CON"),MOVSD3(TRB->B1_COD,"DEV"),MOVSD3(TRB->B1_COD,"REQ"),VENDA(TRB->B1_COD,"N"),COMPRA(TRB->B1_COD,"D"),_TRX->(SALDO_I+COMPRA-DEV_COMP+PRODUCAO-CONSUMO+AJUSTE_E-AJUSTE_S-VENDA+DEV_VEND)})	
		DbSelectArea("TRB")
		TRB->(DbSkip())
		
	EndDo

	// SALDO INICIAL
	@nLin,40 pSay nSalIni PICTURE "@E 999,999,999.99"
	// ENTRADAS
	@nLin,064 pSay nEntra	PICTURE "@E 99,999,999.99"
	// PERDAS E SOBRAS
	@nLin,099 pSay nPerda PICTURE "@E 99,999,999.99"
	// SAIDAS
	@nLin,122 pSay nSaida*(-1) PICTURE "@E 99,999,999.99"
	// UTILIZACAO
	@nLin,156 pSay nUtil PICTURE "@E 99,999,999.99"
	// SALDO
	@nLin,182 pSay nSaldo PICTURE "@E 99,999,999.99"
	nLin ++					
	
Enddo

If nContPg > 1
    
    If nLin > 60
    
    	nLin := 0
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "| IMPRESSO EM: "+DTOC(dDatabase)+"                  RELAÇÃO DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURANÇA PUBLICA               PERÍODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))+"                    Folha:"+Transform(nContPg,"@E 9999")
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| EMPRESA: VERQUIMICA IND. COM. PROD. QUI.                        END.: AV. MARTINS JUNIOR, 2000                  GUARULHOS - SP - CEP: 07141-000          TEL: 2404-8800 FAX: 2404-8813 "
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| CGC: 43.588.060/0001-80           INSCRIÇÃO ESTADUAL: 336.125.845.118              CERTIFICADO DE VISTORIA: 079/13               DATADO DE 25/03/2013                   LICENÇA No.: 291/266/280 "
	    @nLin,219 pSay "|"	    
		nLin++	    
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "  EMISSAO      EMPRESA                                       ENDEREÇO                                    BAIRRO                           CIDADE                           NF          PRODUTO                QUANTIDADE"
		nLin++	    
		@nLin,000 pSay Replicate("=",220)
		nLin++	      
		  	
    EndIf           
    
    nLin := 60
	@nLin,0160 pSay "O que declaro é a verdade, sob as penas da lei." 
	nLin ++	
	@nLin,0160 pSay "Guarulhos,  " + DTOC(dDatabase)
	nLin ++		
	@nLin,0160 pSay "Ass.: _________________________________________" 
	nLin ++		
	@nLin,0160 pSay "Responsável: Vera Lucia de Oliveira Franco "
	nLin ++		
	@nLin,0160 pSay "Cargo: Diretora "
	nLin ++		
	@nLin,0160 pSay "RG Nº 10.309.352-7 " 

EndIf

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

oExcel:Activate()
oExcel:GetXMLFile("C:\TEMP\MAPA_"+DTOS(DATE())+".xml")

TRB->(DbCloseArea())
DbSelectArea("_TRX") ; DbCloseArea()

// Abre no Excel
If !ApOleClient("MsExcel")
	MsgStop("Você não possui o excel instalado, entretanto, o arquivo gerado encontra-se em C:\TEMP\MAPA_"+DTOS(DATE())+".xml") 
	Return
EndIf 

//cArq  := cArqTemp+".DBF"
//__CopyFIle(cArq , AllTrim(GetTempPath())+cArqTemp+".XLS")

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open("C:\TEMP\MAPA_"+DTOS(DATE())+".xml")
oExcelApp:SetVisible(.T.)

Restarea(_aArea)

Return()                     

STATIC FUNCTION SALDOB9(cProd,cPeriodoAnt)

Local _cQryb9 := ""
Local _nRetB9 := 0
                                                                           
_cQryB9 :=	" SELECT SUM(B9_QINI) AS SALDOB9 FROM "+RetSqlName("SB9")+" SB9 "
_cQryB9 +=	" WHERE D_E_L_E_T_ = '' "
_cQryB9 +=	" AND B9_FILIAL = '"+xFilial("SB9")+"' "
_cQryB9 +=	" AND B9_DATA = '"+DTOS(cPeriodoAnt)+"' "
_cQryB9 +=	" AND B9_COD = '"+cProd+"'"

_cQryB9 := ChangeQuery(_cQryB9)
TCQUERY _cQryB9 NEW ALIAS "TRB9"

DbSelectArea("TRB9")
TRB9->(DbGoTop())
While !TRB9->(Eof())

	_nRetB9 += TRB9->SALDOB9

	DbSkip()

EndDo                               

TRB9->(DbCloseArea())

Return(_nRetB9)

STATIC FUNCTION COMPRA(cProd,cTipo)

Local _cQryD1 := ""
Local _nRetD1 := 0
                                                                           
_cQryD1 :=	" SELECT SUM(D1_QUANT) AS QUANT FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF4")+" SF4 "
_cQryD1 +=	" WHERE SD1.D_E_L_E_T_ = '' "                              
_cQryD1 +=	" AND SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
_cQryD1 +=	" AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
_cQryD1 +=	" AND SF4.D_E_L_E_T_ = '' "                              
_cQryD1 +=	" AND D1_DTDIGIT between '"+cPeriodoDe+"' and '"+cPeriodoAte+"' "
_cQryD1 +=	" AND D1_COD = '"+cProd+"'"
_cQryD1 +=	" AND D1_TES = F4_CODIGO "
_cQryD1 +=	" AND F4_ESTOQUE = 'S' "
_cQryD1 +=	" AND D1_TIPO = '"+cTipo+"' "


_cQryD1 := ChangeQuery(_cQryD1)
TCQUERY _cQryD1 NEW ALIAS "TRD1"

DbSelectArea("TRD1")
TRD1->(DbGoTop())
While !TRD1->(Eof())

	_nRetD1 += TRD1->QUANT

	DbSkip()
EndDo

TRD1->(DbCloseArea())

Return(_nRetD1)


STATIC FUNCTION VENDA(cProd,cTipo)

Local _cQryD2 := ""
Local _nRetD2 := 0
                                                                           
_cQryD2 :=	" SELECT SUM(D2_QUANT) AS QUANT FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF4")+" SF4 "
_cQryD2 +=	" WHERE SD2.D_E_L_E_T_ = '' "                              
_cQryD2 +=	" AND SF4.D_E_L_E_T_ = '' "                              
_cQryD2 +=	" AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
_cQryD2 +=	" AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
_cQryD2 +=	" AND D2_EMISSAO between '"+cPeriodoDe+"' and '"+cPeriodoAte+"' "
_cQryD2 +=	" AND D2_COD = '"+cProd+"'"
_cQryD2 +=	" AND D2_TES = F4_CODIGO "
_cQryD2 +=	" AND F4_ESTOQUE = 'S' "
_cQryD2 +=	" AND D2_TIPO = '"+cTipo+"' "


_cQryD2 := ChangeQuery(_cQryD2)
TCQUERY _cQryD2 NEW ALIAS "TRD2"

DbSelectArea("TRD2")
TRD2->(DbGoTop())
While !TRD2->(Eof())
	_nRetD2 += TRD2->QUANT
	DbSkip()
EndDo

TRD2->(DbCloseArea())

Return(_nRetD2)




Static Function MOVSD3(cProd,cTipo)
Local _cQryD3a := ""
Local _nRetD3a := 0

_cQryD3a :=	" SELECT SUM(D3_QUANT) AS QUANT FROM "+RetSqlName("SD3")+" SD3 "
_cQryD3a +=	" WHERE SD3.D_E_L_E_T_ = '' "                              
_cQryD3a +=	" AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
_cQryD3a +=	" AND D3_EMISSAO between '"+cPeriodoDe+"' and '"+cPeriodoAte+"' "
_cQryD3a +=	" AND D3_COD = '"+cProd+"'"
_cQryD3a +=	" AND D3_ESTORNO = '' "

If cTipo = "CON" 
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2') "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "PRO" 	
	_cQryD3a +=	" AND D3_CF = 'PR0' "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "REQ" 	
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2','RE4','RE6','RE7')"
	_cQryD3a +=	" AND D3_OP = '' "
ElseIf cTipo = "DEV" 	
	_cQryD3a +=	" AND D3_CF IN ('DE0','DE1','DE2','DE4','DE6','DE7')"
	_cQryD3a +=	" AND D3_OP = '' "
	
EndIf

_cQryD3a := ChangeQuery(_cQryD3a)
TCQUERY _cQryD3a NEW ALIAS "TRD3a"

DbSelectArea("TRD3a")
TRD3a->(DbGoTop())
While !TRD3a->(Eof())

	_nRetD3a += TRD3a->QUANT

	DbSkip()

EndDo

TRD3a->(DbCloseArea())

Return(_nRetD3a)

Static Function PVQRELVD()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Entregas"
Local cPict         := ""
Local titulo        := "Relação de Compra de Produtos Fiscalizados pela Secretaria de Segurança Publica     Período: " //+cPeriodoDe+" a "+cPeriodoAte
Local nLin          := 80
Local Cabec1        := "Empresa: Vequimica Ind. Com. Prod. Qui             End.: Av. Martins Junior, 2000 jd.     Guarulhos - SP - Cep: 07141-000    Tel: 2404-8800 Fax: 2404-8813 "
Local Cabec2        := "CGC: 43.588.060/0001-80          Inscrição Estadual: 336.125.845.118       Certificado de Vistoria: 079/13       Datado de 25/03/2013      Licenca No.: 291/266/280 "
Local imprime       := .T.
Local aOrd          := {}
Local lPergTk       := .F.
Local aRegs         := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"



Private nomeprog    := cPerg //"CFMRROMA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
//Private cPerg       := cPerg
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := cPerg
Private cString     := "SF2"
//Default lAutoZ13    := .F.



Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

//Private cPeriodoDe  := left(dtos(MV_PAR04),6)+"01"
//Private cPeriodoAte := dtos(lastday(MV_PAR04))


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| GeraPlanila(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return
