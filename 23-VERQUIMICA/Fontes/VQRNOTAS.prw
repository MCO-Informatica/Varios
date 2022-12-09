#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

#DEFINE CRLF CHR(13) + CHR(10)

user function VQRNOTAS()
	IF PERGUNTE("VQRNFSSGI")
		VQGRREL()
	ENDIF
return
             

//Função para verificar se é orçamento

Static Function VQGRREL()
Local cNotas := ""       
Private cPath	:= GetSrvProfString("StartPath", "")   
Private cLogoD 	:= GetSrvProfString("Startpath","") + "logo.bmp"
Private oPrint  := FwMSPrinter():New('rpt_notas.pdf',6,.T.,,.T.)
Private cQry := ""
Private nTotalReg := 0

oPrint:SetResolution(72)
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
oPrint:SetMargin(0,0,0,0)
oPrint:cPathPDF:= "c:\temp\" 
                                                                 
Private oFont10n := TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private OFONT12N := TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
Private oFnt11nn := TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
Private oFont16n := TFont():New("Arial",,16,,.F.,,,,,.F.,.F.)
Private oFnt16nn := TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
Private oFont22n := TFont():New("Arial",,22,,.F.,,,,,.F.,.F.)
Private oFont26n := TFont():New("Arial",,26,,.F.,,,,,.F.,.F.)

Private nLinha1 := 200
Private nLinha2 := 600
Private nLinha3 := 0   
Private nMaxLin := 2800 
Private nPagina := 1

cQry := " "
cQry += " SELECT SF2.F2_DOC FROM "
cQry += "	" + RetSqlName("SF2") + " SF2  "
cQry += "		INNER JOIN " + RetSqlName("SD2") + " SD2 ON (SD2.D_E_L_E_T_ <> '*' AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA) "
cQry += "		INNER JOIN " + RetSqlName("SF4") + " SF4 ON (SF4.D_E_L_E_T_ <> '*' AND SF4.F4_CODIGO = SD2.D2_TES) "
cQry += " WHERE "
cQry += "	SF2.D_E_L_E_T_ <> '*' AND "
cQry += "	SF2.F2_ESPECIE = 'SPED' AND "
cQry += "	SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
cQry += "	SF2.F2_TIPO = 'N' AND "
cQry += "	SF4.F4_ESTOQUE = 'S' AND "
cQry += "	SF4.F4_DUPLIC = 'S' "
cQry += " GROUP BY F2_DOC "
cQry += " ORDER BY F2_DOC "

cQry := ChangeQuery(cQry)

TCQUERY cQry NEW ALIAS "QRY"
 
DbSelectArea("QRY")

nTotalReg := Contar("QRY", "!EoF()")
QRY->(dbGoTop())

oPrint:StartPage()                                          


	oPrint:Say(nLinha1+100,100,"Relatório - Quantidade de Notas Emitidas (VENDAS) ", oFnt16nn)
	oPrint:Say(nLinha1+150,100,"Período de: " + DTOC(MV_PAR01) +" Até: " + DTOC(MV_PAR02), oFnt16nn)
	oPrint:sayBitmap(nLinha1-100,1500,cLogoD, 520,305)          
	oPrint:Say(nLinha1+300,100,"Total de: " + cvaltochar(nTotalReg) + " Notas emitidas.", oFnt16nn)                          
	
	nCont := 1
	While !QRY->(Eof())   
		IF nLinha2 >= nMaxLin
			oPrint:EndPage()    
			oPrint:StartPage()
			nLinha2 := 200
			nPagina++
		EndIF    
		If nCont == 14
			cNotas := cNotas + CRLF
			nCont := 1
			oPrint:Say(nLinha2,100,cNotas, oFont12n)       
			nLinha2+=50 
			cNotas := ""
		Else
		 	cNotas +=  QRY->F2_DOC + "/"
		 	nCont += 1
		EndIf
		QRY->(DbSkip())
	EndDo		        

	Processa({||oPrint:Preview()},"Quantidade de Notas","Gerando visualização do PDF", .F.)

FreeObj(oPrint)
oPrint := Nil
				
Return()                        

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "Emissao de: "	  		, "", "", "mv_ch1", "D",8,0,0,"G","", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Emissao Ate: "	  		, "", "", "mv_ch2", "D",8,0,0,"G","", "", "", "", "mv_par02")
return              

static function validaPrm()
	lRet := .T.
	cMsgErro := "" 
	
	If(Empty(MV_PAR01))
		cMsgErro += "Preencha o código do orçamento" + cEoF
		lRet :=  .F.
	EndIf                                                       
	
return lRet