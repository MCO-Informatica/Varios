#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RNVCN003  ºAutor  ³ B2finance          º Data ³  02/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Le o arquivo .csv apontado pelo usuario, contendo a medicaoº±±
±±º          ³ do pedido de venda e efetua a medicao e o encerramento da  º±±
±±º          ³ medicao atravez de rotina automatica.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JUSATF()

AjustaSX1()

If MsgYesNo("Deseja efetuar ajuste dos bens de ativo - Movimentos e Saldos?" )
	Pergunte("JUSTATF",.T.)
	Processa( {|| U_PROCSN4() }, "Aguarde..Processando movimentos")
Else
	MsgStop( "Abandonando a rotina de processamento" )
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PROCSN4  ºAutor  ³Ajuste do SN4   º Data ³  28/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PROCSN4()

aDupliSN4 :={}
aBemAtf := {}
cChaveSN4 := ""
cChaveSN3 := ""

DbSelectArea("SN4")
DbSetOrder(1)
nRegs := SN4->(Reccount())
SN4->(DbGotop())
SN4->(DbSeek(mv_par01))
cMVPar := MV_PAR02

ProcRegua(nRegs)
nRegDupl := 0
While ! SN4->(EOF()) .AND.  SN4->N4_FILIAL <= cMVPar
	
	//IncProc("Processando Filial("+alltrim(SN4->N4_FILIAL)+")- Bem:"+alltrim(SN4->N4_CBASE)+"-"+alltrim(SN4->N4_ITEM))
	_cPrint := SN4->N4_CBASE+"-"+SN4->N4_ITEM
	_cTipoCnT := SN4->N4_TIPOCNT
	IncProc("Processando.. "+_cPrint)
	
	// Verifica se o tipo refere-se a depreciação
	if SN4->N4_OCORR <> "06"
		SN4->(DbSkip())
		Loop
	Endif
	
	// Verifica se o tipo refere-se a depreciação
	if ! _cTipoCnT $ "3/4"
		SN4->(DbSkip())
		Loop
	Endif
	
	// Define as chaves
	cChaveSN4 := SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM+SN4->N4_TIPO+SN4->N4_OCORR+SN4->N4_TIPOCNT+DTOS(SN4->N4_DATA)+STR(SN4->N4_VLROC1)
	cChaveSN3 := SN4->N4_FILIAL+SN4->N4_CBASE+SN4->N4_ITEM
	
	// Recupera os valores do movimento
	_nVlDprM1 := SN4->N4_VLROC1
	_nVlDprM2 := SN4->N4_VLROC2
	_nVlDprM3 := SN4->N4_VLROC3
	_nVlDprM4 := SN4->N4_VLROC4
	_nVlDprM5 := SN4->N4_VLROC5
	
	nPosLanct := aScan(aDupliSN4,{|aX|aX[1]+aX[2]+aX[3]+aX[4]+aX[5]+aX[6]+aX[7]+aX[8] == cChaveSN4 })
	
	// Apaga o movimento caso esteja duplicado
	IF nPosLanct > 0
		nRegDupl ++
		
		// Delete o registo duplicado
		Reclock("SN4",.F.)
		DBDELETE()
		Msunlock()
	Else
		AADD(aDupliSN4,{SN4->N4_FILIAL,SN4->N4_CBASE,SN4->N4_ITEM,SN4->N4_TIPO,SN4->N4_OCORR,SN4->N4_TIPOCNT,DTOS(SN4->N4_DATA),STR(SN4->N4_VLROC1)})
		// Busca o bem para acumular os valores
		nPosSN3 := aScan(aBemAtf,{|aX|aX[1]+aX[2]+aX[3] == cChaveSN3 })
		// Acumula o valor da depreciação acumulada
		if nPosSN3 > 0
			if _cTipoCnT = "3"
				// Atualiza colunas de depreciação mes
				aBemAtf[nPosSN3,4] := _nVlDprM1
				aBemAtf[nPosSN3,5] := _nVlDprM2
				aBemAtf[nPosSN3,6] := _nVlDprM3
				aBemAtf[nPosSN3,7] := _nVlDprM4
				aBemAtf[nPosSN3,8] := _nVlDprM5                      
			Else
				// Acumula colunas de depreciação do balanço
				aBemAtf[nPosSN3,9]  += _nVlDprM1
				aBemAtf[nPosSN3,10] += _nVlDprM2
				aBemAtf[nPosSN3,11] += _nVlDprM3
				aBemAtf[nPosSN3,12] += _nVlDprM4
				aBemAtf[nPosSN3,13] += _nVlDprM5
				// Acumula colunas de depreciação acumulada
				aBemAtf[nPosSN3,14] += _nVlDprM1
				aBemAtf[nPosSN3,15] += _nVlDprM2
				aBemAtf[nPosSN3,16] += _nVlDprM3
				aBemAtf[nPosSN3,17] += _nVlDprM4
				aBemAtf[nPosSN3,18] += _nVlDprM5
			Endif
		Else
			AADD(aBemAtf,{SN4->N4_FILIAL,SN4->N4_CBASE,SN4->N4_ITEM,_nVlDprM1,_nVlDprM2,_nVlDprM3,_nVlDprM4,_nVlDprM5,_nVlDprM1,_nVlDprM2,_nVlDprM3,_nVlDprM4,_nVlDprM5,_nVlDprM1,_nVlDprM2,_nVlDprM3,_nVlDprM4,_nVlDprM5})
		Endif
	Endif
	
	DbSelectArea("SN4")
	SN4->(DbSkip())
	
Enddo

_nAtfSN3 := 0  

Aviso("Atenção","Identificado "+alltrim(str(nRegDupl))+" registros duplicados..",{"OK"})

For _nAtfSN3 := 1 to len(aBemAtf)

	// Abate o valor da depreciação acumulada
	cChaveSN3 := aBemAtf[_nAtfSN3,1]+aBemAtf[_nAtfSN3,2]+aBemAtf[_nAtfSN3,3]   
	IncProc("Ajustando SN3.. "+cChaveSN3)
	DbSelectArea("SN3")
	DbSetOrder(1)
	if SN3->(DbSeek(cChaveSN3))
		Reclock("SN3",.F.)
		// Depreciação mes
		SN3->N3_VRDMES1 :=  aBemAtf[_nAtfSN3,4]
		SN3->N3_VRDMES2 :=  aBemAtf[_nAtfSN3,5]
		SN3->N3_VRDMES3 :=  aBemAtf[_nAtfSN3,6]
		SN3->N3_VRDMES4 :=  aBemAtf[_nAtfSN3,7]
		SN3->N3_VRDMES5 :=  aBemAtf[_nAtfSN3,8]
		
		// Depreciação do balanço
		SN3->N3_VRDBAL1 :=  aBemAtf[_nAtfSN3,9]
		SN3->N3_VRDBAL2 :=  aBemAtf[_nAtfSN3,10]
		SN3->N3_VRDBAL3 :=  aBemAtf[_nAtfSN3,11]
		SN3->N3_VRDBAL4 :=  aBemAtf[_nAtfSN3,12]
		SN3->N3_VRDBAL5 :=  aBemAtf[_nAtfSN3,13]
		
		// Depreciação acumulada
		SN3->N3_VRDACM1 :=  aBemAtf[_nAtfSN3,14]
		SN3->N3_VRDACM2 :=  aBemAtf[_nAtfSN3,15]
		SN3->N3_VRDACM3 :=  aBemAtf[_nAtfSN3,16]
		SN3->N3_VRDACM4 :=  aBemAtf[_nAtfSN3,17]
		SN3->N3_VRDACM5 :=  aBemAtf[_nAtfSN3,18]
		
		Msunlock()
	Endif
	
	
Next _nAtfSN3


Aviso("Atenção","Finalizado processo de ajuste dos movimentos de ativo",{"OK"})


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Alexandre Lemes     º Data ³ 17/12/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local nTamSX1   := Len(SX1->X1_GRUPO)

PutSx1(PADR("JUSTATF",10),"01","Da Empresa?" ,"Da Empresa?" ,"Da Empresa?" ,"mv_ch1" ,"C",07 ,0 ,0 ,"G" ,"" ,"" ,"" ,"" ,"mv_par01","","" ,"" ,"" ,"","","","","","","","","","","","","","","","","","","","","SM0")
PutSx1(PADR("JUSTATF",10),"02","Ate Empresa?","Ate Empresa?","Ate Empresa?","mv_ch2" ,"C",07 ,0 ,0 ,"G" ,"" ,"" ,"" ,"" ,"mv_par02","","" ,"" ,"" ,"","","","","","","","","","","","","","","","","","","","","SM0")

dbSelectArea("SX1")
dbSetOrder(1)

If dbSeek(PADR("RECOMR01",nTamSX1)+"15")
	RecLock("SX1",.F.)
	X1_DEF03   := "Sim"
	X1_DEFSPA3 := "Sim"
	X1_DEFENG3 := "Yes"
	MsUnLock()
EndIf

Return
