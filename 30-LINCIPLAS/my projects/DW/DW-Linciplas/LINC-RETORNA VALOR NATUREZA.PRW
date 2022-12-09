#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#DEFINE CRLF Chr(13)+Chr(10)

//AADD(AMOVTO,{PDN->C5_EMISSAO 		DT EMISSAO	1
//	,month(STOD(PDN->C5_EMISSAO))	MES			2
//	,STOD(PDN->C5_EMISSAO)			DT EMISSAO	3
//	,cCliente						CLIENTE		4
//	,nQtd							QTD     	5 CAP
//	,nValor							VALOR   	6 CAP
//	,Day(STOD(PDN->C5_EMISSAO))})	DIA			7
//	,nQtd							QTD     	8 ASS
//	,nValor							VALOR   	9 ASS
// *--------------------------------------------------*
User Function LPBrinde(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOB 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOB, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOB) .AND. AMOVTOB[_XX][2] == cMes
	nret += AMOVTOB[_XX][10]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPPAGOPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOB 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOB, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOB) .AND. AMOVTOB[_XX][2] == cMes
	nret += AMOVTOB[_XX][6]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPQTDPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOC 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOC, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOC) .AND. AMOVTOC[_XX][2] == cMes
	nret += AMOVTOC[_XX][5]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPPGASSPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOD 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOD, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOD) .AND. AMOVTOD[_XX][2] == cMes
	nret += AMOVTOD[_XX][9]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPQTDAPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOE 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOE, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOE) .AND. AMOVTOE[_XX][2] == cMes
	nret += AMOVTOE[_XX][8]
	_XX ++
ENDDO

RETURN(nRET)
// FIM PEDIDO DE VENDA MENSAL ------------------------

// INICIO NOTA FISCAL MENSAL -------------------------
// FATURADOS -----------------------------------------*
// *--------------------------------------------------*
User Function LPNFBrinde(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOF 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOF, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOF) .AND. AMOVTOF[_XX][2] == cMes
	nret += AMOVTOF[_XX][10]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPPAGONF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOF 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOF, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOF) .AND. AMOVTOF[_XX][2] == cMes
	
	nret += AMOVTOF[_XX][6]
	
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPQTDNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOG 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOG, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOG) .AND. AMOVTOG[_XX][2] == cMes
	nret += AMOVTOG[_XX][5]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPPGASSNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOH 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOH, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOH) .AND. AMOVTOH[_XX][2] == cMes
	nret += AMOVTOH[_XX][9]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPQTDANF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOI 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOI, {|x| x[2] == cMes })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOI) .AND. AMOVTOI[_XX][2] == cMes
	nret += AMOVTOI[_XX][8]
	_XX ++
ENDDO
RETURN(nRET)
// FIM NOTA FISCAL MENSAL

// *--------------------------------------------------*
// pego as informacoes para montar os dias
// AADD(AMOVTO,{PDN->C5_EMISSAO 		DT EMISSAO	1
//	,month(STOD(PDN->C5_EMISSAO))	MES			2
//	,STOD(PDN->C5_EMISSAO)			DT EMISSAO	3
//	,cCliente						CLIENTE		4
//	,nQtd							QTD     	5 CAP
//	,nValor							VALOR   	6 CAP
//	,Day(STOD(PDN->C5_EMISSAO))})	DIA			7
//	,nQtd							QTD     	8 ASS
//	,nValor							VALOR   	9 ASS
// *--------------------------------------------------*
// BRINDE DIARIO PEDIDO DE VENDA
User Function LPDBrinde(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOJ 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOJ, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOJ) .AND. AMOVTOJ[_XX][3] == CtoD(cData)
	nret += AMOVTOJ[_XX][10]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDQTDPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOJ 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOJ, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOJ) .AND. AMOVTOJ[_XX][3] == CtoD(cData)
	nret += AMOVTOJ[_XX][5]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDPAGOPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOK 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOK, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOK) .AND. AMOVTOK[_XX][3] == CtoD(cData)
	nret += AMOVTOK[_XX][6]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDQTDAPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOL 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOL, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOL) .AND. AMOVTOL[_XX][3] == CtoD(cData)
	nret += AMOVTOL[_XX][8]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDPGAPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOM 	:= ASort(aMOVTOPV,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOM, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOM) .AND. AMOVTOM[_XX][3] == CtoD(cData)
	nret += AMOVTOM[_XX][9]
	_XX ++
ENDDO
RETURN(nRET)
// FIM PEDIDO DE VENDA DIARIO
// ----------------------------------
// INICIO NOTA FISCAL DIARIO
// *--------------------------------------------------*
// BRINDE DIARIO NOTA FISCAL
User Function LPNFDBrinde(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTON 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTON, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTON) .AND. AMOVTON[_XX][3] == CtoD(cData)
	nret += AMOVTON[_XX][10]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDQTDNF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTON 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTON, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTON) .AND. AMOVTON[_XX][3] == CtoD(cData)
	nret += AMOVTON[_XX][5]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDPAGONF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOO 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOO, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOO) .AND. AMOVTOO[_XX][3] == CtoD(cData)
	nret += AMOVTOO[_XX][6]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDQTDANF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOP 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOP, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOP) .AND. AMOVTOP[_XX][3] == CtoD(cData)
	nret += AMOVTOP[_XX][8]
	_XX ++
ENDDO
RETURN(nRET)

// *--------------------------------------------------*
User Function LPDPGANF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOQ 	:= ASort(aMOVTONF,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOQ, {|x| x[3] == ctod(cData) })
_XX    		:= POSINI
DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOQ) .AND. AMOVTOQ[_XX][3] == CtoD(cData)
	nret += AMOVTOQ[_XX][9]
	_XX ++
ENDDO
RETURN(nRET)
// *--------------------------------------------------*
// Fim Dias - INFORMACOES DIARIAS
// *--------------------------------------------------*


// OUTROS TOTAL
// *--------------------------------------------------*
User Function LPOPGPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][2] == cMes
	nret += AMOVTOT[_XX][6]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOQTDPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][2] == cMes
	nret += AMOVTOT[_XX][5]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOAPGPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][2] == cMes
	nret += AMOVTOT[_XX][9]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOAQTDPV(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][2] == cMes
	nret += AMOVTOT[_XX][8]
	_XX ++
ENDDO

RETURN(nRET)
// *--------------------------------------------------*
// FATURADOS -----------------------------------------*
// *--------------------------------------------------*
User Function LPOPGNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][2] == cMes
	nret += AMOVTOV[_XX][6]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOQTDNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][2] == cMes
	nret += AMOVTOV[_XX][5]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOAPGNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][2] == cMes
	nret += AMOVTOV[_XX][9]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPOAQTDNF(cCol,cMes)
// *--------------------------------------------------*
nRET 		:= 0
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[2] == cMes })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][2] == cMes
	nret += AMOVTOV[_XX][8]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
// OUTROS DIARIO
// *--------------------------------------------------*
User Function LPODPGPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][3] == CtoD(cData)
	nret += AMOVTOT[_XX][6]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODQTDPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][3] == CtoD(cData)
	nret += AMOVTOT[_XX][5]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODAPGPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][3] == CtoD(cData)
	nret += AMOVTOT[_XX][9]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODAQPV(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOT 	:= ASort(aMovtoOP,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOT, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOT) .AND. AMOVTOT[_XX][3] == CtoD(cData)
	nret += AMOVTOT[_XX][8]
	_XX ++
ENDDO

RETURN(nRET)
// *--------------------------------------------------*
// FATURADOS -----------------------------------------*
// *--------------------------------------------------*
User Function LPODPGNF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][3] == CtoD(cData)
	nret += AMOVTOV[_XX][6]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODQTDNF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][3] == CtoD(cData)
	nret += AMOVTOV[_XX][5]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODAPGNF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][3] == CtoD(cData)
	nret += AMOVTOV[_XX][9]
	_XX ++
ENDDO

RETURN(nRET)

// *--------------------------------------------------*
User Function LPODAQNF(cCol,cDia,cMes)
// *--------------------------------------------------*
nRET 		:= 0
cData		:= alltrim(str(cDia))+"/"+alltrim(str(cMes))+"/"+MV_PAR03
AMOVTOV 	:= ASort(aMovtoON,,,{|x,y|x[1]<y[1]})
POSINI 		:= aScan(aMOVTOV, {|x| x[3] == CtoD(cData) })
_XX    		:= POSINI

DO WHILE _XX > 0 .AND. _XX <= LEN(AMOVTOV) .AND. AMOVTOV[_XX][3] == CtoD(cData)
	nret += AMOVTOV[_XX][8]
	_XX ++
ENDDO

RETURN(nRET)


// *--------------------------------------------------*
User Function LPPVVEN(dtini,dtfim)
// *--------------------------------------------------*

If Select("PDN") > 0
	dbSelectArea("PDN")
	dbCloseArea()
Endif

cQuery := " SELECT DISTINCT C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, C5_TIPO " 												+ CRLF
//cQuery += "-- , CASE WHEN C6_PRODUTO LIKE 'SPI35%' THEN 'ASS' ELSE 'CAP' END AS 'TIPO1' " 										+ CRLF
cQuery += " , CASE WHEN C6_PRODUTO LIKE 'SPI35%' AND C6_TES NOT IN ('569','590','597') THEN 'ASS' " 								+ CRLF
cQuery += " 	   WHEN C6_PRODUTO NOT LIKE 'SPI35%' AND C6_TES NOT IN ('569','590','597') THEN 'CAP' " 							+ CRLF
cQuery += " ELSE 'ERR' END AS 'TIPO1' " 																							+ CRLF
cQuery += " , CASE WHEN C6_PRODUTO NOT LIKE 'SPI35%' AND C6_TES IN ('569','590','597') THEN 'BRINDE' ELSE 'VENDA' END AS 'TIPO2' " 	+ CRLF
//cQuery += "-- , C6.* " 																											+ CRLF
cQuery += " , C5_FRETE, C6_NUM, C6_QTDVEN, C6_PRODUTO, C6_TES, C6_PRCVEN, C6_VALOR, C6_FILIAL, C6_ITEM " 							+ CRLF
cQuery += " FROM SC5010 C5, SC6010 C6, SB1010 B1 " 																					+ CRLF
cQuery += " WHERE C5_FILIAL 				= C6_FILIAL " 																			+ CRLF
cQuery += " AND C5_NUM 						= C6_NUM " 																				+ CRLF
cQuery += " AND C5_EMISSAO >= '" + DTOS(DTIni) + "' AND C5_EMISSAO <= '" + DTOS(DTFim) + "' " 										+ CRLF
cQuery += " AND ((SUBSTRING(C6_PRODUTO,1,4) >= 'S000' AND SUBSTRING(C6_PRODUTO,1,4) <= 'S999') " 									+ CRLF
cQuery += " OR SUBSTRING(C6_PRODUTO,1,5) 	= 'SPI35') " 																			+ CRLF
cQuery += " AND B1.B1_COD 					= C6.C6_PRODUTO " 																		+ CRLF
cQuery += " AND LTRIM(RTRIM(B1.B1_GRUPO)) 	= 'CAP.' " 																				+ CRLF
cQuery += " AND C5_FILIAL 					= '02'" 																				+ CRLF
cQuery += " AND C6_FILIAL 					= '02'" 																				+ CRLF
//cQuery += " AND C6_NUM	 				= '002116'" 																			+ CRLF
//cQuery += " AND C6_TES	 				NOT IN ('569') " //!= '569'" 															+ CRLF
cQuery += " AND C5.D_E_L_E_T_ 				!= '*' " 																				+ CRLF
cQuery += " AND C6.D_E_L_E_T_ 				!= '*' " 																				+ CRLF
cQuery += " ORDER BY C6_NUM, C6_FILIAL, C6_ITEM, C6_PRODUTO, 1 " 																	+ CRLF

cQuery := ChangeQuery(cQuery)
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"PDN",.F.,.T.)},"Pedidos de Venda...","Processando Dados...")

DbSelectArea("PDN")
DbGoTop()

cNumPV 	:= "" //PDN->C6_NUM
nFrete	:= 0
lValid	:= .T.
//ProcRegua( ("PDN")->( RecCount() ) )
//IncProc( "Aguarde, Processando Pedidos de Venda" )
//PROCREGUA(1000)
DO WHILE !EOF()
	
	IF CNUMPV	!= PDN->C6_NUM //.AND. LVALID
		nFrete	:= PDN->C5_FRETE
		cNumPV 	:= PDN->C6_NUM
		LVALID	:= .F.
	ELSE
		lValid	:= .T.
		nFrete	:= 0
	ENDIF
	
	//CalcImp(cCliente,cLoja,cTipoPV,cTipoCli,cProduto,cTES,nQtd,nPrcVen,nValMerc)
	cCliente 	:= ALLTRIM(PDN->C5_CLIENTE)+PDN->C5_LOJACLI
	nQtd   		:= PDN->C6_QTDVEN
	nValImp		:= CalcImp(ALLTRIM(PDN->C5_CLIENTE),PDN->C5_LOJACLI,PDN->C5_TIPO,PDN->C5_TIPOCLI,PDN->C6_PRODUTO,PDN->C6_TES,PDN->C6_QTDVEN,PDN->C6_PRCVEN,PDN->C6_PRCVEN)
	nVALOR 		:= IIF(PDN->TIPO2!="BRINDE",PDN->C6_VALOR+nValImp+nFrete,0) 	// VALOR TOTAL UNIT*QTD
	cTpProd		:= PDN->TIPO1
	cTpVen		:= PDN->TIPO2
	
	// INCLUI NO ARRAY OU SOMA A LINHA DO ARRAR JA EXISTENTE
	POSINI 		:= aScan(aMOVTOPV, {|x| Upper(Alltrim(x[1])) == PDN->C5_EMISSAO})
	IF cTpVen != "BRINDE"
		IF cTpProd == "CAP"
			IF POSINI == 0
				AADD(AMOVTOPV,{PDN->C5_EMISSAO,month(STOD(PDN->C5_EMISSAO)),STOD(PDN->C5_EMISSAO),cCliente,nQtd,nValor,DAY(STOD(PDN->C5_EMISSAO)),0,0,0})
			ELSE
				aMovtoPV[POSINI][5] += nQtd
				aMovtoPV[POSINI][6] += nvalor
			ENDIF
		ELSEIF cTpProd == "ASS"
			IF POSINI == 0
				AADD(AMOVTOPV,{PDN->C5_EMISSAO,month(STOD(PDN->C5_EMISSAO)),STOD(PDN->C5_EMISSAO),cCliente,0,0,DAY(STOD(PDN->C5_EMISSAO)),nQtd,nValor,0})
			ELSE
				aMovtoPV[POSINI][8] += nQtd
				aMovtoPV[POSINI][9] += nvalor
			ENDIF
		ENDIF
	ELSE
		IF POSINI == 0
			AADD(AMOVTOPV,{PDN->C5_EMISSAO,month(STOD(PDN->C5_EMISSAO)),STOD(PDN->C5_EMISSAO),cCliente,0,0,DAY(STOD(PDN->C5_EMISSAO)),0,0,nQtd})
		ELSE
			aMovtoPV[POSINI][10] += nQtd
		ENDIF
	ENDIF
	DbSelectArea("PDN")
	dbskip()
ENDDO

RETURN

// *--------------------------------------------------*
User Function LPPVFAT(dtini,dtfim)
// *--------------------------------------------------*

If Select("PDN") > 0
	dbSelectArea("PDN")
	dbCloseArea()
Endif

cQuery := " SELECT DISTINCT F2_EMISSAO, F2_CLIENTE, F2_LOJA " 																	+ CRLF
//cQuery += " , CASE WHEN D2_COD LIKE 'SPI35%' THEN 'ASS' ELSE 'CAP' END AS 'TIPO1' " 											+ CRLF
cQuery += " , CASE WHEN D2_COD LIKE 'SPI35%' AND D2_TES NOT IN ('569','590','597') THEN 'ASS' " 								+ CRLF
cQuery += "        WHEN D2_COD NOT LIKE 'SPI35%' AND D2_TES NOT IN ('569','590','597') THEN 'CAP' " 							+ CRLF
cQuery += " ELSE 'ERR' END AS 'TIPO1' " 																						+ CRLF
cQuery += " , CASE WHEN D2_COD NOT LIKE 'SPI35%' AND D2_TES IN ('569','590','597') THEN 'BRINDE' ELSE 'VENDA' END AS 'TIPO2' " 	+ CRLF
cQuery += " , F2_FRETE, D2.* " 																									+ CRLF
cQuery += " FROM SF2010 F2, SD2010 D2, SB1010 B1 " 																				+ CRLF
cQuery += " WHERE F2_FILIAL 				= D2_FILIAL " 																		+ CRLF
cQuery += " AND F2_DOC 						= D2_DOC " 																			+ CRLF
cQuery += " AND F2_EMISSAO >= '" + DTOS(DTIni) + "' AND F2_EMISSAO <= '" + DTOS(DTFim) + "' " 									+ CRLF
cQuery += " AND ((SUBSTRING(D2_COD,1,4) 	>= 'S000' AND SUBSTRING(D2_COD,1,4) <= 'S999') " 									+ CRLF
cQuery += " OR SUBSTRING(D2_COD,1,5) 		= 'SPI35') " 																		+ CRLF
cQuery += " AND B1.B1_COD 					= D2.D2_COD " 																		+ CRLF
cQuery += " AND LTRIM(RTRIM(B1.B1_GRUPO)) 	= 'CAP.' " 																			+ CRLF
cQuery += " AND F2.D_E_L_E_T_ 				!= '*' " 																			+ CRLF
cQuery += " AND D2.D_E_L_E_T_ 				!= '*' " 																			+ CRLF
cQuery += " AND F2_FILIAL 					= '02'" 																			+ CRLF
cQuery += " AND D2_FILIAL 					= '02'" 																			+ CRLF
//cQuery += " AND D2_FILIAL 				= '000001340'" 																		+ CRLF
//cQuery += " AND D2_TES	 				NOT IN ('569') " //!= '569'" 														+ CRLF
cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_FILIAL, D2_ITEM, D2_COD, 1 " 															+ CRLF

cQuery := ChangeQuery(cQuery)
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"PDN",.F.,.T.)},"Notas Fiscais...","Processando Dados...")

DbSelectArea("PDN")
DbGoTop()

cNumNF 	:= "" //PDN->D2_DOC
nFrete	:= 0
lValid	:= .T.

//ProcRegua( ("PDN")->( RecCount() ) )

DO WHILE !EOF()
	
	IF CNUMNF	!= PDN->D2_DOC .AND. LVALID
		nFrete	:= PDN->F2_FRETE
		cNumNF 	:= PDN->D2_DOC
		LVALID	:= .F.
	ELSE
		lValid	:= .T.
		nFrete	:= 0
	ENDIF
	
	cCliente 	:= ALLTRIM(PDN->F2_CLIENTE)+PDN->F2_LOJA
	nQtd   		:= PDN->D2_QUANT
	//nValImp		:= PDN
	nVALOR 		:= PDN->D2_TOTAL+PDN->D2_ICMSRET+nFrete	// (VALOR TOTAL UNIT+IMPOSTO)*QTD
	cTpProd		:= PDN->TIPO1
	cTpVen		:= PDN->TIPO2
	
	
	// INCLUI NO ARRAY OU SOMA A LINHA DO ARRAR JA EXISTENTE
	POSINI := aScan(aMOVTONF, {|x| Upper(Alltrim(x[1])) == PDN->F2_EMISSAO})
	IF cTpVen != "BRINDE"
		IF 	cTpProd	== "CAP"
			IF POSINI == 0
				AADD(AMOVTONF,{PDN->F2_EMISSAO,month(STOD(PDN->F2_EMISSAO)),STOD(PDN->F2_EMISSAO),cCliente,nQtd,nValor,DAY(STOD(PDN->F2_EMISSAO)),0,0,0})
			ELSE
				aMovtoNF[POSINI][5] += nQtd
				aMovtoNF[POSINI][6] += nvalor
			ENDIF
		ELSEIF cTpProd == "ASS"
			IF POSINI == 0
				AADD(AMOVTONF,{PDN->F2_EMISSAO,month(STOD(PDN->F2_EMISSAO)),STOD(PDN->F2_EMISSAO),cCliente,0,0,DAY(STOD(PDN->F2_EMISSAO)),nQtd,nValor,0})
			ELSE
				aMovtoNF[POSINI][8] += nQtd
				aMovtoNF[POSINI][9] += nvalor
			ENDIF
		ENDIF
	ELSE
		IF POSINI == 0
			AADD(AMOVTONF,{PDN->F2_EMISSAO,month(STOD(PDN->F2_EMISSAO)),STOD(PDN->F2_EMISSAO),cCliente,0,0,DAY(STOD(PDN->F2_EMISSAO)),0,0,nQtd})
		ELSE
			aMovtoNF[POSINI][10] += nQtd
		ENDIF
	ENDIF
	DbSelectArea("PDN")
	dbskip()
ENDDO

RETURN

// *--------------------------------------------------*
User Function LPOPVFAT(dtini,dtfim)
// *--------------------------------------------------*

Public aMOVTOOP	:= {}
Public aSC5		:= {}
Public nPFrete	:= 0
Public nFrete	:= 0
Public _cNumPV	:= ""

dbUseArea(.T.,,"DW\SC5010","_C5",.T.,.F.)
dbSetIndex("DW\SC5010")
dbSetOrder(2)
//dbSeek("01"+DTOS(DTINI))

WHILE ("_C5")->(!EOF())
	//WHILE !EOF()
	IF DTOS(_C5->C5_EMISSAO) >= DTOS(DTINI) .AND. DTOS(_C5->C5_EMISSAO) <= DTOS(DTFIM)
		AADD(ASC5,{_C5->C5_EMISSAO,_C5->C5_NUM,_C5->C5_FRETE})
	ENDIF
	DbSelectArea("_C5")
	("_C5")->(dbskip())
ENDDO

dbCloseArea("_C5")

FOR NC6 := 1 TO LEN(ASC5)
	
	dbUseArea(.T.,,"DW\SC6010","_C6",.T.,.F.)
	dbSetIndex("DW\SC6010")
	dbSetOrder(1)
	dbSeek("01"+ASC5[NC6][2])
	
	WHILE !EOF() .AND. ASC5[NC6][2] == _C6->C6_NUM
		
		IF _CNUMPV	!= _C6->C6_NUM //.AND. LVALID
			nPFrete		:= aScan(ASC5, {|x| Upper(Alltrim(x[2])) == _C6->C6_NUM}) //_C5->C5_FRETE
			IF nPFrete != 0
				nFrete	:= ASC5[nPFrete][3]
			ELSE
				nFRETE	:= 0
			ENDIF
			_cNumPV 	:= _C6->C6_NUM
			LVALID		:= .F.
		ELSE
			lValid		:= .T.
			nFrete		:= 0
		ENDIF
		
		cCliente 		:= ALLTRIM(_C6->C6_CLI)+_C6->C6_LOJA
		nQtd   			:= _C6->C6_QTDVEN
		nVALOR 			:= _C6->C6_VALOR+nFRETE //+PDN->D2_ICMSRET+nFrete	// (VALOR TOTAL UNIT+IMPOSTO)*QTD
		
		//502 VENDAS  (TES)
		//522 BRINDE  (TES)
		
		// REGRA QUE VERIFICA SE E CAPACETE OU ACESSORIO
		//IF alltrim(_C6->C6_PRODUTO) != "S0701" .OR. alltrim(_C6->C6_PRODUTO) != "SPI36"
		IF SUBSTR(_C6->C6_PRODUTO,1,5) == "SPI35" .AND. _C6->C6_TES == "502"
			cTpProd		:= "ASS" 		// ACESSORIO
		ELSEIF (SUBSTR(_C6->C6_PRODUTO,1,5) != "SPI35" .OR. alltrim(_C6->C6_PRODUTO) != "SPI36" ) .AND. (SUBSTRING(_C6->C6_PRODUTO,1,4) >= 'S000' .AND. SUBSTR(_C6->C6_PRODUTO,1,4) <= 'S999') .AND. _C6->C6_TES == "502" .AND. len(alltrim(_C6->C6_PRODUTO)) != len("S0701") //alltrim(_C6->C6_PRODUTO) != "S0701"
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_C6->C6_PRODUTO) == "S0701" .AND. _C6->C6_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_C6->C6_PRODUTO) == "SPI36" .AND. _C6->C6_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "ASS" 		// CAPACETE
		ELSE
			cTpProd		:= "ERR" 		// NENHUMA DAS ANTERIORES
		ENDIF
		//ELSE
		//cTpProd		:= "ERR" 		// NENHUMA DAS ANTERIORES
		//nQtd			:= 0
		//ENDIF
		
		// REGRA QUE VERIFICA SE E BRINDE OU VENDA
		IF SUBSTR(_C6->C6_PRODUTO,1,5) != "SPI35" .AND. _C6->C6_TES == "522"
			cTpVen		:= "BRINDE"
		ELSE
			cTpVen		:= "VENDA"
		ENDIF
		
		// INCLUI NO ARRAY OU SOMA A LINHA DO ARRAR JA EXISTENTE
		//POSINI 		:= aScan(aMOVTOOP, {|x| Upper(Alltrim(x[1])) == _C6->C6_ENTREG})
		POSINI 			:= aScan(aMOVTOOP, {|x| x[1] == ASC5[NC6][1] })
		IF cTpVen != "BRINDE"
			IF 	cTpProd	== "CAP"
				IF POSINI == 0
					AADD(AMOVTOOP,{ASC5[NC6][1],month(ASC5[NC6][1]),ASC5[NC6][1],cCliente,nQtd,nValor,DAY(ASC5[NC6][1]),0,0,0})
				ELSE
					aMovtoOP[POSINI][5] += nQtd
					aMovtoOP[POSINI][6] += nvalor
				ENDIF
			ELSEIF cTpProd == "ASS"
				IF POSINI == 0
					AADD(AMOVTOOP,{ASC5[NC6][1],month(ASC5[NC6][1]),ASC5[NC6][1],cCliente,0,0,DAY(ASC5[NC6][1]),nQtd,nValor,0})
				ELSE
					aMovtoOP[POSINI][8] += nQtd
					aMovtoOP[POSINI][9] += nvalor
				ENDIF
			ENDIF
		ELSE
			IF POSINI == 0
				AADD(AMOVTOOP,{ASC5[NC6][1],month(ASC5[NC6][1]),ASC5[NC6][1],cCliente,0,0,DAY(ASC5[NC6][1]),0,0,nQtd})
			ELSE
				aMovtoOP[POSINI][10] += nQtd
			ENDIF
		ENDIF
		//ENDIF
		DbSelectArea("_C6")
		("_C6")->(dbskip())
	ENDDO
	
	dbCloseArea("_C6")
	
NEXT NC6

RETURN

// *--------------------------------------------------*
User Function LPONFFAT(dtini,dtfim)
// *--------------------------------------------------*

Public aMOVTOON	:= {}
Public aSF2		:= {}

dbUseArea(.T.,,"DW\SF2010","_F2",.T.,.F.)
dbSetIndex("DW\SF2010")
dbSetOrder(2)
//dbSeek("01"+DTOS(DTINI))

WHILE ("_F2")->(!EOF())
	//WHILE !EOF()
	IF DTOS(_F2->F2_EMISSAO) >= DTOS(DTINI) .AND. DTOS(_F2->F2_EMISSAO) <= DTOS(DTFIM)
		AADD(ASF2,{_F2->F2_EMISSAO,_F2->F2_DOC})
	ENDIF
	DbSelectArea("_F2")
	("_F2")->(dbskip())
ENDDO

dbCloseArea("_F2")

FOR ND2 := 1 TO LEN(ASF2)
	
	dbUseArea(.T.,,"DW\SD2010","_D2",.T.,.F.)
	dbSetIndex("DW\SD2010")
	dbSetOrder(3)
	dbSeek("01"+ASF2[ND2][2]+"1")
	
	WHILE !EOF() .AND. ASF2[ND2][2] == _D2->D2_DOC
		
		cCliente 	:= ALLTRIM(_D2->D2_CLIENTE)+_D2->D2_LOJA
		nQtd   		:= _D2->D2_QUANT
		nVALOR 		:= _D2->D2_TOTAL //+PDN->D2_ICMSRET+nFrete	// (VALOR TOTAL UNIT+IMPOSTO)*QTD
		
		//502 VENDAS  (TES)
		//522 BRINDE  (TES)
		
		// REGRA QUE VERIFICA SE E CAPACETE OU ACESSORIO
		//IF alltrim(_D2->D2_COD) != "S0701" .OR. alltrim(_D2->D2_COD) != "SPI36"
		IF SUBSTR(_D2->D2_COD,1,5) == "SPI35" .AND. _D2->D2_TES == "502"
			cTpProd		:= "ASS" 		// ACESSORIO
		ELSEIF (SUBSTR(_D2->D2_COD,1,5) != "SPI35" .OR. alltrim(_D2->D2_COD) != "SPI36" ) .AND. (SUBSTRING(_D2->D2_COD,1,4) >= 'S000' .AND. SUBSTR(_D2->D2_COD,1,4) <= 'S999') .AND. _D2->D2_TES == "502" .AND. alltrim(_D2->D2_COD) != "S0701"
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_D2->D2_COD) == "S0701" .AND. _D2->D2_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_D2->D2_COD) == "SPI36" .AND. _D2->D2_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "ASS" 		// CAPACETE
		ELSE
			cTpProd		:= "ERR" 		// NENHUMA DAS ANTERIORES
		ENDIF
		//ELSE
		//cTpProd			:= "ERR" 	// NENHUMA DAS ANTERIORES
		//nQtd			:= 0
		//ENDIF
		
		// REGRA QUE VERIFICA SE E BRINDE OU VENDA
		IF SUBSTR(_D2->D2_COD,1,5) != "SPI35" .AND. _D2->D2_TES == "522"
			cTpVen	:= "BRINDE"
		ELSE
			cTpVen	:= "VENDA"
		ENDIF
		
		// INCLUI NO ARRAY OU SOMA A LINHA DO ARRAR JA EXISTENTE
		//POSINI := aScan(aMOVTOON, {|x| Upper(Alltrim(x[1])) == _D2->D2_ENTREG})
		POSINI := aScan(aMOVTOON, {|x| x[1] == ASF2[ND2][1] })
		IF cTpVen != "BRINDE"
			IF 	cTpProd	== "CAP"
				IF POSINI == 0
					AADD(AMOVTOON,{ASF2[ND2][1],month(ASF2[ND2][1]),ASF2[ND2][1],cCliente,nQtd,nValor,DAY(ASF2[ND2][1]),0,0,0})
				ELSE
					aMovtoON[POSINI][5] += nQtd
					aMovtoON[POSINI][6] += nvalor
				ENDIF
			ELSEIF cTpProd == "ASS"
				IF POSINI == 0
					AADD(AMOVTOON,{ASF2[ND2][1],month(ASF2[ND2][1]),ASF2[ND2][1],cCliente,0,0,DAY(ASF2[ND2][1]),nQtd,nValor,0})
				ELSE
					aMovtoON[POSINI][8] += nQtd
					aMovtoON[POSINI][9] += nvalor
				ENDIF
			ENDIF
		ELSE
			IF POSINI == 0
				AADD(AMOVTOON,{ASF2[ND2][1],month(ASF2[ND2][1]),ASF2[ND2][1],cCliente,0,0,DAY(ASF2[ND2][1]),0,0,nQtd})
			ELSE
				aMovtoON[POSINI][10] += nQtd
			ENDIF
		ENDIF
		//ENDIF
		DbSelectArea("_D2")
		("_D2")->(dbskip())
	ENDDO
	
	dbCloseArea("_D2")
	
NEXT ND2

RETURN

////////////////////////////////////////////////////
// ********************************************** //
////////////////////////////////////////////////////
Static Function LPCalcImp(cCliente,cLoja           	,cTipoPV      ,cTipoCli        ,cProduto,cTES,nQtd,nPrcVen,nValMerc)
//		CalcImp(PDN->C5_CLIENTE ,PDN->C5_LOJACLI	,PDN->C5_TIPO ,PDN->C5_TIPOCLI,PDN->C6_PRODUTO,PDN->C6_TES,PDN->C6_QTDVEN,PDN->C6_PRCVEN,PDN->C6_PRCVEN)
Local aArea 		:= GetArea()
//Local cTipoCli 	:= ""
//Local cTipoNF 	:= "N"
Local nBasIPI 		:= 0
Local nAlqIPI 		:= 0
Local nValIPI 		:= 0
Local nValST		:= 0
Local nTotalImp		:= 0
//Local nVlrTotItem	:= TMP1->CK_VALOR
//Local nQuant 		:= TMP1->CK_QTDVEN
//Local nVlUnit 	:= TMP1->CK_PRCVEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifico o tipo da nota para efetuar o calculo |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If cTipoNF $ "DB"
cTipoCli 	:= IIf( Empty( cTipoCli ), SA2->A2_TIPO, cTipoCli )
// Inicializa a funcao fiscal para poder simular os valores dos impostos
MaFisIni(SA2->A2_COD,SA2->A2_LOJA,"F",cTipoNF,cTipoCli,,,.F.,"SB1")
Else
cTipoCli 	:= IIf( Empty( cTipoCli ), SA1->A1_TIPO, cTipoCli )
// Inicializa a funcao fiscal para poder simular os valores dos impostos
MaFisIni(SA1->A1_COD, SA1->A1_LOJA, "C", "S", cTipoCli,,, .F., "SB1")
EndIf
*/
MaFisIni(cCliente								,;	// 1-Codigo Cliente/Fornecedor
cLoja											,;	// 2-Loja do Cliente/Fornecedor
IIf(cTipoPV$'DB',"F","C")						,;	// 3-C:Cliente , F:Fornecedor
cTipoPV											,;	// 4-Tipo da NF
cTipoCli										,;	// 5-Tipo do Cliente/Fornecedor
Nil												,;
Nil												,;
Nil												,;
Nil												,;
"MATA410" 										) //"MATA461"										)

//Como no caso do orçamento não se tem nada de impostos e nem referências cadastradas nos valids dos campos
//(como temos no pedido de compras e vendas), é necessário inicializar a função fiscal com o MaFisIni e
//utilizar o MaFisAdd com os valores dos itens de cada uma das linhas do aCols.
//MaFisAdd(SB1->B1_COD, SF4->F4_CODIGO, nQuant,nVlUnit, 0, "", "",, 0, 0, 0, 0, nVlrTotItem, 0, SB1->(RecNo()))

MaFisAdd(cProduto	,;  // 01-Codigo do Produto 			( Obrigatorio )
cTES				,;	// 02-Codigo do TES 				( Opcional )
nQtd				,;  // 03-Quantidade 					( Obrigatorio )
nPrcVen				,;	// 04-Preco Unitario 				( Obrigatorio )
0					,;	// 05-Valor do Desconto 			( Opcional )
""					,;	// 06-Numero da NF Original 		( Devolucao/Benef )
""					,;	// 07-Serie da NF Original 			( Devolucao/Benef )
,					 ;	// 08-RecNo da NF Original no arq SD1/SD2
0					,;	// 09-Valor do Frete do Item 		( Opcional )
0					,;	// 10-Valor da Despesa do item 		( Opcional )
0					,;	// 11-Valor do Seguro do item 		( Opcional )
0					,;	// 12-Valor do Frete Autonomo 		( Opcional )
nValMerc*nQtd		,;	// 13-Valor da Mercadoria 			( Obrigatorio )
0					)	// 14-Valor da Embalagem 			( Opiconal )

// Retorna valor dos impostos
//nBasIPI 	:= MaFisRet(1,'IT_BASEIPI')
nValIPI 	:= MaFisRet(1,'IT_VALIPI')
//nAlqIPI 	:= MaFisRet(1,'IT_ALIQIPI')
nValST		:= MaFisRet(1,"NF_VALSOL")

nTotalImp	:= nValIPI + nValST

// Encerra a funcao fiscal
MaFisEnd()
RestArea( aArea )

//Return ({nBasIPI,nAlqIPI,nValIPI})
Return nTotalImp


User Function LPRetAtr(lRet,cVar,dtini,dtfim)
/*
U_RetAtr(.T.,"A",dtini,dtfim)) // QTD		,CAPACETES
U_RetAtr(.F.,"A",dtini,dtfim)) // VALOR		,CAPACETES
U_RetAtr(.T.,"B",dtini,dtfim)) // QTD 		,ACESSORIOS
U_RetAtr(.F.,"B",dtini,dtfim)) // VALOR		,ACESSORIOS
U_RetAtr(.T.,"C",dtini,dtfim)) // QTD 		,BRINDES
U_RetAtr(.F.,"C",dtini,dtfim)) // VALOR		,BRINDES
*/

cQry 		:= " SELECT " 																			+ CRLF
cQry 		+= " SUBSTRING(C5_EMISSAO,1,6)" 														+ CRLF
cQry 		+= " , SUM(C6_QTDVEN)					AS QTD" 										+ CRLF
cQry 		+= " , SUM(C6_QTDENT)					AS QTDENT" 										+ CRLF
cQry 		+= " , SUM(C6_QTDVEN) - SUM(C6_QTDENT)	AS DIF" 										+ CRLF
cQry 		+= " , SUM(C6_PRCVEN)					AS PRCVEN" 										+ CRLF
cQry 		+= " , SUM(C6_VALOR)					AS TOTAL" 										+ CRLF
cQry 		+= " FROM SC5010 C5, SC6010 C6, SF4010 F4" 												+ CRLF
cQry 		+= " WHERE C5_FILIAL		= C6_FILIAL" 												+ CRLF
cQry 		+= " AND C5_NUM				= C6_NUM" 													+ CRLF
cQry 		+= " AND C5_FILIAL			= '02'" 													+ CRLF
cQry 		+= " AND C5_EMISSAO			BETWEEN '" + DTOS(DTIni) + "' AND '" + DTOS(DTFim) + "'" 	+ CRLF
// capacetes"
IF CVAR == "A" // CAPACETES
	cQry	+= " AND C6_PRODUTO			NOT LIKE 'SPI35%'" 											+ CRLF
	cQry	+= " AND C6_TES				IN ('564','573','576')" 									+ CRLF
	// acessorios"
ELSEIF CVAR == "B" // ACESSORIOS
	cQry 	+= " AND C6_PRODUTO 		LIKE 'SPI35%' " 											+ CRLF
	cQry 	+= " AND C6_TES				NOT IN ('569','590','597') " 								+ CRLF
	// BRINDES
ELSEIF CVAR == "C" // BRINDES
	cQry 	+= " AND C6_PRODUTO			NOT LIKE 'SPI35%'  "										+ CRLF
	cQry 	+= " AND C6_TES				IN ('590', '569','597') " 									+ CRLF
ENDIF
cQry 		+= " AND C6_QTDENT			< C6_QTDVEN" 												+ CRLF
cQry 		+= " AND F4_CODIGO			= C6_TES" 													+ CRLF
cQry 		+= " AND F4_DUPLIC			= 'S'" 														+ CRLF
cQry 		+= " AND C5.D_E_L_E_T_		!= '*' " 													+ CRLF
cQry 		+= " AND C6.D_E_L_E_T_		!= '*' " 													+ CRLF
cQry 		+= " AND F4.D_E_L_E_T_		!= '*' " 													+ CRLF
cQry 		+= " GROUP BY SUBSTRING(C5_EMISSAO,1,6) " 												+ CRLF

If Select("ATR") > 0
	dbSelectArea("ATR")
	dbCloseArea()
Endif

cQry		:= ChangeQuery(cQry)
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),"ATR",.F.,.T.)},"Atrasados...","Processando Dados...")

DbSelectArea("ATR")
DbGoTop()

IF lRET
	nRet := ATR->DIF
ELSE
	nRet := ATR->TOTAL
ENDIF

Return nRet


// *--------------------------------------------------*
User Function LPORetAtr(lRet,cVar,dtini,dtfim)
// *--------------------------------------------------*
/*
User Function LPRetAtr(lRet,cVar,dtini,dtfim)

U_RetAtr(.T.,"A",dtini,dtfim)) // QTD		,CAPACETES
U_RetAtr(.F.,"A",dtini,dtfim)) // VALOR		,CAPACETES
U_RetAtr(.T.,"B",dtini,dtfim)) // QTD 		,ACESSORIOS
U_RetAtr(.F.,"B",dtini,dtfim)) // VALOR		,ACESSORIOS
U_RetAtr(.T.,"C",dtini,dtfim)) // QTD 		,BRINDES
U_RetAtr(.F.,"C",dtini,dtfim)) // VALOR		,BRINDES
*/

Public aOAtra	:= {}
Public _aSC5	:= {}
Public _nQtd	:= 0
Public _nVal	:= 0
Public _cNumPV	:= ""

dbUseArea(.T.,,"DW\SC5010","_C5",.T.,.F.)
dbSetIndex("DW\SC5010")
dbSetOrder(2)
//dbSeek("01"+DTOS(DTINI))

WHILE ("_C5")->(!EOF())
	//WHILE !EOF()
	IF DTOS(_C5->C5_EMISSAO) >= DTOS(DTINI) .AND. DTOS(_C5->C5_EMISSAO) <= DTOS(DTFIM)
		AADD(_ASC5,{_C5->C5_EMISSAO,_C5->C5_NUM,_C5->C5_FRETE})
	ENDIF
	DbSelectArea("_C5")
	("_C5")->(dbskip())
ENDDO

dbCloseArea("_C5")

FOR NC6 := 1 TO LEN(_ASC5)
	
	dbUseArea(.T.,,"DW\SC6010","_C6",.T.,.F.)
	dbSetIndex("DW\SC6010")
	dbSetOrder(1)
	dbSeek("01"+_ASC5[NC6][2])
	
	WHILE !EOF() .AND. _ASC5[NC6][2] == _C6->C6_NUM
		
		//IF _C6->C6_QTDENT < _C6->C6_QTDVEN
		//	DBSKIP()
		//	LOOP
		//ELSE
		IF _CNUMPV	!= _C6->C6_NUM //.AND. LVALID
			nPFrete		:= aScan(_ASC5, {|x| Upper(Alltrim(x[2])) == _C6->C6_NUM}) //_C5->C5_FRETE
			IF nPFrete != 0
				nFrete	:= _ASC5[nPFrete][3]
			ELSE
				nFRETE	:= 0
			ENDIF
			_cNumPV 	:= _C6->C6_NUM
			LVALID		:= .F.
		ELSE
			lValid		:= .T.
			nFrete		:= 0
		ENDIF
		
		cCliente 		:= ALLTRIM(_C6->C6_CLI)+_C6->C6_LOJA
		//_nQtd   		:= _C6->C6_QTDVEN
		_nVALOR 		:= _C6->C6_VALOR+nFRETE //+PDN->D2_ICMSRET+nFrete	// (VALOR TOTAL UNIT+IMPOSTO)*QTD
		
		//502 VENDAS  (TES)
		//522 BRINDE  (TES)
		
		// REGRA QUE VERIFICA SE E CAPACETE OU ACESSORIO
		//IF alltrim(_C6->C6_PRODUTO) != "S0701" .OR. alltrim(_C6->C6_PRODUTO) != "SPI36"
		IF SUBSTR(_C6->C6_PRODUTO,1,5) == "SPI35" .AND. _C6->C6_TES == "502"
			cTpProd		:= "ASS" 		// ACESSORIO
		ELSEIF (SUBSTR(_C6->C6_PRODUTO,1,5) != "SPI35" .OR. alltrim(_C6->C6_PRODUTO) != "SPI36" ) .AND. (SUBSTRING(_C6->C6_PRODUTO,1,4) >= 'S000' .AND. SUBSTR(_C6->C6_PRODUTO,1,4) <= 'S999') .AND. _C6->C6_TES == "502" .AND. alltrim(_C6->C6_PRODUTO) != "S0701"
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_C6->C6_PRODUTO) == "S0701" .AND. _C6->C6_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "CAP" 		// CAPACETE
		ELSEIF alltrim(_C6->C6_PRODUTO) == "SPI36" .AND. _C6->C6_TES == "502"
			nQtd		:= 0
			cTpProd 	:= "ASS" 		// CAPACETE
		ELSE
			cTpProd		:= "ERR" 		// NENHUMA DAS ANTERIORES
		ENDIF
		//ELSE
		//cTpProd		:= "ERR" 		// NENHUMA DAS ANTERIORES
		//nQtd			:= 0
		//ENDIF
		
		// REGRA QUE VERIFICA SE E BRINDE OU VENDA
		IF SUBSTR(_C6->C6_PRODUTO,1,5) != "SPI35" .AND. _C6->C6_TES == "522"
			cTpVen		:= "BRINDE"
		ELSE
			cTpVen		:= "VENDA"
		ENDIF
		
		// INCLUI NO ARRAY OU SOMA A LINHA DO ARRAR JA EXISTENTE
		//POSINI := aScan(aMOVTOOP, {|x| Upper(Alltrim(x[1])) == _C6->C6_ENTREG})
		//POSINI := aScan(aMOVTOOP, {|x| x[1] == _ASC5[NC6][1] })
		
		IF CVAR == "A" // CAPACETES
			IF cTpVen != "BRINDE"
				IF 	cTpProd	== "CAP" .AND. CVAR == "A" // CAPACETES
					_nQtd	:= _nQtd + (_C6->C6_QTDVEN - _C6->C6_QTDENT)
					_nVal	:= _nVal + _nVALOR //_C6->C6_VALOR
				ELSE
					_nQtd	:= _nQtd
					_nVal	:= _nVal
				ENDIF
			ENDIF
		ELSEIF CVAR == "B" // ACESSORIOS
			IF cTpVen != "BRINDE"
				IF cTpProd == "ASS" .AND. CVAR == "B" // ACESSORIOS
					_nQtd	:= _nQtd + (_C6->C6_QTDVEN - _C6->C6_QTDENT)
					_nVal	:= _nVal + _nVALOR //_C6->C6_VALOR
				ELSE
					_nQtd	:= _nQtd
					_nVal	:= _nVal
				ENDIF
			ENDIF
		ELSE
			IF CVAR == "C" // BRINDES
				IF CVAR == "C" // ACESSORIOS
					_nQtd	:= _nQtd + (_C6->C6_QTDVEN - _C6->C6_QTDENT)
					_nVal	:= _nVal + _nVALOR //_C6->C6_VALOR
				ENDIF
			ELSE
				_nQtd		:= _nQtd
				_nVal		:= _nVal
			ENDIF
		ENDIF
		//ENDIF
		DbSelectArea("_C6")
		("_C6")->(dbskip())
	ENDDO
	
	dbCloseArea("_C6")
	
NEXT NC6

IF lRET
	nRet := _nQtd
ELSE
	nRet := _nVal
ENDIF

RETURN nRet
