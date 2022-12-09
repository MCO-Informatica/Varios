#include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFOLHEXCEL   บAutor  ณCarlos Miranda    บ Data ณ  02.09.14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gera็ใo da folha de pagamento em Excel         บฑฑ
ฑฑบ          ณ Partida - Menu de usuario                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ IMCD                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION FOLHEXCEL()

Private aVerba := {}
Private aFolha  := {}
Private cArqSai	:= ""

cPerg := Padr("FOLHAEXCEL",10,"")

If !Pergunte(cPerg,.T.)
	Return
Endif

cPath := Alltrim(mv_par01)
cPath := If(Right(cPath,1) == "\",cPath,cPath+"\")

Processa({|| fGERTOTAL()  , "Aguarde a geracใo do Arquivo de Resumo...  [Proc 1/2]"})


Return

********************************
Static Function fGERTOTAL()
********************************
LOCAL cMes := ""
LOCAL cAno := ""
LOCAL dData
LOCAL cArq := ""

cArqSai := UPPER(cPath+Alltrim("FOLHAEXCEL.CSV"))

nArqTxt := MsFCreate(cArqSai)

If nArqTxt == -1
	MsgStop("Erro na cria็ใo do arquivo "+Alltrim(mv_par01)+" : " + Alltrim(Str(fError())))
	Return
EndIF


GERA(SUBS(MV_PAR02,1,2),SUBS(MV_PAR02,5,4))



FClose(nArqTxt)

If ! ApOleClient( 'MsExcel' ) // abre o arquivo .csv
	MsgAlert( 'MsExcel nao instalado' )
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqSai ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
EndIf

Return



STATIC FUNCTION GERA(cMes,cAno) //TOTAL DE SALARIOS

Local cPerAnt    := MV_PAR02
Local nVerba     := 0
Local cTable     := ""
Local cArq       := ""
Local cFolmes     := Getmv("MV_FOLMES")
Local X := 0
Local Y := 0
Local G := 0
Local T := 0
Local Z := 0

aVerba  := fMontaSRV()
nTotReg := FCONTA()


aFolha := Array(nTotReg,(len(aVerba)))

FOR X:= 1 TO nTotReg
	FOR Y := 1 TO len(aVerba)
		IF Y < 10
			aFolha[x,y] := ""
		else
			aFolha[x,y] := 0
		ENDIF
	NEXT
NEXT

NLI       := 1
nPrimeira := 0

DO While       (SUBS(MV_PAR02,3,4)+SUBS(MV_PAR02,1,2)) <= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2)) ;
	.AND. (SUBS(MV_PAR03,3,4)+SUBS(MV_PAR03,1,2)) >= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2))
	
	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGotop()
	cEmp  := "xx"
	nCont := 0
	lFaz  := .T.
	
	
	
	While !SM0->(Eof())
		
		If SM0->M0_CODIGO = "99" .OR. SM0->M0_CODFIL <> "01"
			SM0->(DbSkip())
			Loop
		Endif
		
		If cFolmes == SUBS(cPerAnt,3,4)+SUBS(cPerAnt,1,2)
			cArq := "SRC"
		Else
			cArq := "RC"
		EndIf
		
		cArq := "SRC" // na versใo 12  nใo usa mais tabelas RC
		
		If cArq = "RC"
			cTable := cArq+SM0->M0_CODIGO+SUBS(cPerAnt,5,2)+SUBS(cPerAnt,1,2)
		Else
			cTable := cArq+SM0->M0_CODIGO+"0"
		EndIf
		
		If !TCCanOpen(cTable) .OR. !TCCanOpen("SRA"+SM0->M0_CODIGO+"0") .OR. !TCCanOpen("CTT"+SM0->M0_CODIGO+"0")
			lFaz := .F.
		ENDIF
		
		IF lFaz
			
			If Select("CASRC3") > 0
				DbCloseArea("CASRC3")
			Endif
			
			
			CASRC3 := GetnextAlias()
			
			cQuery := "SELECT SRA.RA_ADMISSA, SRA.RA_HRSMES, SRC.RC_FILIAL,SRC.RC_MAT,SRA.RA_NOME,SRJ.RJ_DESC,SRC.RC_PD,SRC.RC_VALOR,CTT.CTT_DESC01 "
			cQuery += "FROM SRA"+SM0->M0_CODIGO+"0 SRA, SRJ010 SRJ	,"+cTable+" SRC, CTT"+SM0->M0_CODIGO+"0 CTT "
			cQuery += " WHERE SRA.D_E_L_E_T_  <> '*'AND SRC.D_E_L_E_T_  <> '*'AND SRJ.D_E_L_E_T_  <> '*'  AND CTT.D_E_L_E_T_  <> '*' "
			cQuery += "  AND SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO "
			cQuery += "  AND SRA.RA_CC = CTT.CTT_CUSTO"
			cQuery += " ORDER BY SRC.RC_FILIAL, SRC.RC_MAT, SRC.RC_PD  "
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), CASRC3, .T., .T.)
			DbSelectarea(CASRC3)
			
			If Select("CASRC3") > 0
				DbSelectArea("CASRC3")
			Endif
			
			TcQuery cQuery New Alias "CASRC3"
			
			
			
			while !(CASRC3)->(Eof())
				
				CFILANT := (CASRC3)->RC_FILIAL
				CMATANT := (CASRC3)->RC_MAT
				CFLAG   := 0
				
				WHILE (CASRC3)->RC_FILIAL = CFILANT .AND. (CASRC3)->RC_MAT = CMATANT
					
					if (nPos := Ascan(aVerba,{|x| x[1] = (CASRC3)->RC_PD  })) = 0
						(CASRC3)->(DbSkip());lOOP
					ENDIF
					
					IF CFLAG = 0
						
						aFolha[NLI,1] := (CASRC3)->RC_FILIAL
						aFolha[NLI,2] := (CASRC3)->RC_MAT
						aFolha[NLI,3] := (CASRC3)->RA_NOME
						aFolha[NLI,4] := (CASRC3)->RJ_DESC
						aFolha[NLI,5] := SUBS((CASRC3)->RA_ADMISSA,7,2) +"/"+ SUBS((CASRC3)->RA_ADMISSA,5,2) +"/"+ SUBS((CASRC3)->RA_ADMISSA,1,4)
						aFolha[NLI,6] := TRANSFORM((CASRC3)->RA_HRSMES,"@R 999.99")
						aFolha[NLI,7] := cPerAnt
						aFolha[NLI,8] := SM0->M0_NOME
						aFolha[NLI,9] := (CASRC3)->CTT_DESC01
					Endif
					
					aFolha[NLI,nPos] := (CASRC3)->RC_VALOR
					CFLAG += 1
					(CASRC3)->(DbSkip())
				ENDDO
				
				NLI += 1
				
			EndDo
			
			DbSelectArea("CASRC3")
			DbCloseArea("CASRC3")
			
		endif
		
		SM0->(DBSKIP())
		
	ENDDO
	
	IF SUBS(cPerAnt,1,2) = "12"
		cPerAnt :=  "01" + STRZERO((VAL(SUBS(cPerAnt,3,4))+1),4)
	ELSE
		cPerAnt :=  STRZERO((VAL(SUBS(cPerAnt,1,2))+1),2) +  SUBS(cPerAnt,3,4)
	ENDIF
	
	LOOP
	
ENDDO

nVez := 0

IF nPrimeira = 0
	//MONTA O CABEวALHO DA PLANILHA
	cDetArq := "Filial"          +";"
	cDetArq += "Matricula"       +";"
	cDetArq += "Nome"            +";"
	cDetArq += "Funcao"          +";"
	cDetArq += "Admissใo"         +";"
	cDetArq += "Hrs Mes"         +";"
	cDetArq += "MesAno"          +";"
	cDetArq += "Empresa"         +";"
	cDetArq += "Centro de Custo" +";"
	
	
	FOR G = 10 TO LEN(AVERBA)
		
		if !EMPTY(ALLTRIM(aVerba[G,1]))
			cDetArq += "'" + aVerba[G,1] + "-" + POSICIONE("SRV",1,XFILIAL("SRV")+aVerba[G,1],"RV_DESC")     +";"
		ENDIF
	NEXT
	
	fWrite(nArqTxt,cDetArq+Chr(13)+Chr(10))
	
endif

nPrimeira ++

//MONTA OS VALORES DA FOLHA
For z = 1 to (len(aFolha) - 1)
	For t = 1 to len (aVerba)
		if nVez = 0
			cDetArq := "'" + aFolha[z,t] +";"
		else
			if t < 10
				cDetArq += "'" + aFolha[z,t] +";"
			else
				cDetArq += transform(aFolha[z,t],"@e 9,999,999.99")   +";"
			endif
		endif
		nVez += 1
		if t = 505
			n:=1
		endif
	next
	nVez := 0
	fWrite(nArqTxt,cDetArq+Chr(13)+Chr(10))
next


fWrite(nArqTxt,cDetArq+Chr(13)+Chr(10))




RETURN()

/*******************************************
Esta funcao ira retornar a quantidade de linha
de todas as folhas de todas empresas
*******************************************/
STATIC FUNCTION FCONTA()
Local nNum    := 0
Local cPerAnt    := MV_PAR02
Local cFolmes    := Getmv("MV_FOLMES")

DO While (SUBS(MV_PAR02,3,4)+SUBS(MV_PAR02,1,2)) <= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2)) ;
	.AND. (SUBS(MV_PAR03,3,4)+SUBS(MV_PAR03,1,2)) >= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2))
	
	
	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGotop()
	cEmp  := "xx"
	nCont := 0
	
	DO While !SM0->(Eof())
		
		If SM0->M0_CODIGO = "99" .OR. SM0->M0_CODFIL <> "01"
			SM0->(DbSkip())
			Loop
		Endif
		
		If cFolmes == SUBS(cPerAnt,3,4)+SUBS(cPerAnt,1,2)
			cArq := "SRC"
		Else
			cArq := "RC"
		EndIf
		cArq := "SRC" // na versใo 12  nใo usa mais tabelas RC
		
		If cArq = "RC"
			cTable := cArq+SM0->M0_CODIGO+SUBS(cPerAnt,5,2)+SUBS(cPerAnt,1,2)
		Else
			cTable := cArq+SM0->M0_CODIGO+"0"
		EndIf
		
		if TCCanOpen(cTable)
			
			cAliasSRC4 := GetnextAlias()
			
			cQuery := " SELECT RC_FILIAL,RC_MAT  FROM "+cTable+"  WHERE D_E_L_E_T_  <> '*'  GROUP BY RC_FILIAL,RC_MAT"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSRC4, .T., .T.)
			DbSelectarea(cAliasSRC4)
			
			
			If Select("cAliasSRC4") > 0
				DbSelectArea("cAliasSRC4")
			Endif
			
			TcQuery cQuery New Alias "cAliasSRC4"
			
			DO WHILE !EOF()
				
				nNum += 1
				
				("cAliasSRC4")->(DBSKIP())
				
			ENDDO
			
			DbSelectArea("cAliasSRC4")
			dbclosearea("cAliasSRC4")
			
		ENDIF
		
		SM0->(DBSKIP())
		
	ENDDO
	
	IF SUBS(cPerAnt,1,2) = "12"
		cPerAnt :=  "01" + STRZERO((VAL(SUBS(cPerAnt,3,4))+1),4)
	ELSE
		cPerAnt :=  STRZERO((VAL(SUBS(cPerAnt,1,2))+1),2) +  SUBS(cPerAnt,3,4)
	ENDIF
	
	loop
	
enddo

RETURN(NNUM)


Static Function fMontaSRV()

Local aVet    := {}
Local aVetAux := {}
LOCAL cTable  := ""
Local nVerba  := 0
lOCAL nTotReg := 0
Local cPerAnt    := MV_PAR02
Local cFolmes    := Getmv("MV_FOLMES")
Local nX := 0
FOR nX := 1 TO 9
	AADD(aVetAux,{"000"})
NEXT


DO While (SUBS(MV_PAR02,3,4)+SUBS(MV_PAR02,1,2)) <= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2)) ;
	.AND. (SUBS(MV_PAR03,3,4)+SUBS(MV_PAR03,1,2)) >= (SUBS(cPerAnt,3,4)+ SUBS(cPerAnt,1,2))
	
	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGotop()
	cEmp  := "xx"
	nCont := 0
	
	While !SM0->(Eof())
		
		If SM0->M0_CODIGO = "99" .OR. SM0->M0_CODFIL <> "01"
			SM0->(DbSkip())
			Loop
		Endif
		
		
		If cFolmes == SUBS(cPerAnt,3,4)+SUBS(cPerAnt,1,2)
			cArq := "SRC"
		Else
			cArq := "RC"
		EndIf
		cArq := "SRC" // na versใo 12  nใo usa mais tabelas RC
		
		If cArq = "RC"
			cTable := cArq+SM0->M0_CODIGO+SUBS(cPerAnt,5,2)+SUBS(cPerAnt,1,2)
		Else
			cTable := cArq+SM0->M0_CODIGO+"0"
		EndIf
		
		if TCCanOpen(cTable)
			
			cASRC1 := GetnextAlias()
			
			cQuery := "SELECT RC_PD FROM "+cTable+" SRC "
			cQuery += " WHERE D_E_L_E_T_  <> '*' "
			cQuery += " GROUP BY RC_PD  "
			cQuery += " ORDER BY RC_PD  "
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cASRC1, .T., .T.)
			DbSelectarea(cASRC1)
			
			
			If Select("cASRC1") > 0
				DbSelectArea("cASRC1")
			Endif
			
			TcQuery cQuery New Alias "cASRC1"
			
			
			
			nPos := 0
			Do While !(cASRC1)->(eof())
				If ( nPos := Ascan(aVetAux,{|x| x[1] = (CASRC1)->RC_PD  })) = 0
					nVerba  += 1
					IF !EMPTY((CASRC1)->RC_PD)
						AADD(aVetAux,{(CASRC1)->RC_PD})
					ENDIF
				Endif
				(cASRC1)->(DbSkip())
			EndDo
			
			DBSELECTAREA("cASRC1")
			DbCloseArea("cASRC1")
			
		ENDIF
		
		SM0->(DBSKIP())
	ENDDO
	
	
	IF SUBS(cPerAnt,1,2) = "12"
		cPerAnt :=  "01" + STRZERO((VAL(SUBS(cPerAnt,3,4))+1),4)
	ELSE
		cPerAnt :=  STRZERO((VAL(SUBS(cPerAnt,1,2))+1),2) +  SUBS(cPerAnt,3,4)
	ENDIF
	
	Loop
ENDDO

ASort (aVetAux,,,{|x,y| x[1] < y[1] })

Return(aVetAux)