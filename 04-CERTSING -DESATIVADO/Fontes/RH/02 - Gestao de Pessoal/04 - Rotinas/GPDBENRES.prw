#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPDBENRES º Autor ³ AP6 IDE            º Data ³  26/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera Descontos nao utilizados na Rescisao                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPDBENRES

Local c_Turno	:= ""
Local n_VT		:= 0 //Dias nao utilizados de VT
Local n_VR		:= 0 //Dias nao utilizados de VR
Local n_VA		:= 0 //Dias nao utilizados de VA
Local n_UniVT	:= 0 //Valor Diario de VT
Local n_UniVR	:= 0 //Valor Diario de VR
Local n_UniVA	:= 0 //Valor Diario de VA
Local c_PDVT	:= "331" //Verba de Devolucao VT nao utilizado
Local c_PDVR	:= "360" //Verba de Devolucao VR nao utilizado
Local c_PDVA	:= "361" //Verba de Devolucao VA nao utilizado
Local c_Query1	:= ""
Local a_Area	:= GetArea()
Local l_VT		:= 0 //0-Nao Encontrado/1-Aberto/2-Fechado
Local l_VR		:= 0 //0-Nao Encontrado/1-Aberto/2-Fechado
Local l_VA		:= 0 //0-Nao Encontrado/1-Aberto/2-Fechado
Local n_TotVT	:= 0 //Total Compra VT
Local n_TotVR	:= 0 //Total Compra VR
Local n_TotVA 	:= 0 //Total Compra VA
Local n_UltDia	:= Min(f_UltDia(dDataDem),30)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os periodos de VT esta aberto ou fechado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c_Query1	:= "SELECT * FROM " + RetSqlName("RCH") + " WHERE D_E_L_E_T_ = ' ' AND RCH_ROTEIR = 'VTR' AND RCH_FILIAL = '"+RCH->RCH_FILIAL+"' AND RCH_PER = '"+RCH->RCH_PER+"'"
c_Query1 	:= ChangeQuery(c_Query1)
TCQuery c_Query1 New Alias "WGPE"
If !WGPE->(Eof())
	If !Empty(WGPE->RCH_DTFECH)
		l_VT := 2
	Else
		l_VT := 1
	Endif
Endif
WGPE->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver fechado Busca o Valor do VT no RG2                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VT = 2
	c_Query1	:= "SELECT RG2_FILIAL,RG2_MAT,RG2_CODIGO,RG2_DIACAL,RG2_VALCAL,RG2_VALCAL/RG2_DIACAL*RG2_VTDUTE VUNIT,RG2_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("RG2")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND RG2_TPVALE = '0'
	c_Query1	+= " AND RG2_VALCAL > 0
	c_Query1	+= " AND RG2_DIACAL > 0
	c_Query1	+= " AND RG2_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND RG2_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND RG2_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVT += Round(WGPE->VUNIT,2)
		n_TotVT += Round(WGPE->RG2_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver Aberto Busca o Valor do VT no SR0                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VT = 1
	c_Query1	:= "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_QDIACAL,R0_VALCAL,R0_VALCAL/R0_QDIACAL*R0_QDIAINF VUNIT,R0_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("SR0")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND R0_TPVALE = '0'
	c_Query1	+= " AND R0_VALCAL > 0
	c_Query1	+= " AND R0_QDIACAL > 0
	c_Query1	+= " AND R0_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND R0_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND R0_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVT += Round(WGPE->VUNIT,2)
		n_TotVT += Round(WGPE->R0_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os periodos de VR esta aberto ou fechado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c_Query1	:= "SELECT * FROM " + RetSqlName("RCH") + " WHERE D_E_L_E_T_ = ' ' AND RCH_ROTEIR = 'VRF' AND RCH_FILIAL = '"+RCH->RCH_FILIAL+"' AND RCH_PER = '"+RCH->RCH_PER+"'"
c_Query1 	:= ChangeQuery(c_Query1)
TCQuery c_Query1 New Alias "WGPE"
If !WGPE->(Eof())
	If !Empty(WGPE->RCH_DTFECH)
		l_VR := 2
	Else
		l_VR := 1
	Endif
Endif
WGPE->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver fechado Busca o Valor do VR no RG2                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VR = 2
	c_Query1	:= "SELECT RG2_FILIAL,RG2_MAT,RG2_CODIGO,RG2_DIACAL,RG2_VALCAL,RG2_VALCAL/RG2_DIACAL VUNIT,RG2_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("RG2")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND RG2_TPVALE = '1'
	c_Query1	+= " AND RG2_VALCAL > 0
	c_Query1	+= " AND RG2_DIACAL > 0
	c_Query1	+= " AND RG2_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND RG2_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND RG2_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVR += Round(WGPE->VUNIT,2)
		n_TotVR += Round(WGPE->RG2_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver Aberto Busca o Valor do VR no SR0                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VR = 1
	c_Query1	:= "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_QDIACAL,R0_VALCAL,R0_VALCAL/R0_QDIACAL VUNIT,R0_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("SR0")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND R0_TPVALE = '1'
	c_Query1	+= " AND R0_VALCAL > 0
	c_Query1	+= " AND R0_QDIACAL > 0
	c_Query1	+= " AND R0_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND R0_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND R0_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVR += Round(WGPE->VUNIT,2)
		n_TotVR += Round(WGPE->R0_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

If n_UniVR > 0 .Or. n_UniVT > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe o periodo para o funcionario. Senao pega o generico @@@³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("RCG")
	dbSetOrder(1)
	If dbSeek(RCH->RCH_FILIAL + RCH->RCH_ANO + RCH->RCH_MES + SRA->RA_TNOTRAB +  RCH->RCH_NUMPAG)
		c_Turno := SRA->RA_TNOTRAB
	ElseIf dbSeek(RCH->RCH_FILIAL + RCH->RCH_ANO + RCH->RCH_MES + "@@@" + RCH->RCH_NUMPAG)
		c_Turno := "@@@"
	Endif
	
	If !Empty(c_Turno)
		While 	!RCG->(Eof()) .And.;
			RCG->RCG_FILIAL = RCH->RCH_FILIAL .And.;
			RCG->RCG_ANO = RCH->RCH_ANO .And.;
			RCG->RCG_MES = RCH->RCH_MES .And.;
			RCG->RCG_TNOTRA = c_Turno .And.;
			RCG->RCG_SEMANA = RCH->RCH_NUMPAG
			If RCG->RCG_DIAMES > dDataDem
				If RCG->RCG_VTRANS = "1"
					n_VT ++
				Endif
				If RCG->RCG_VREFEI = "1"
					n_VR ++
				Endif
			Endif
			RCG->(dbSkip())
		Enddo
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera a Verba de VT nao utilizado na Rescisao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If n_VT > 0
		fGeraVerba(c_PDVT,Min(n_VT * n_UniVT,n_TotVT),n_VT)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera a Verba de VR nao utilizado na Rescisao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If n_VR > 0
		fGeraVerba(c_PDVR,Min(n_VR * n_UniVR,n_TotVR),n_VR)
	Endif
	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os periodos de VA esta aberto ou fechado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c_Query1	:= "SELECT * FROM " + RetSqlName("RCH") + " WHERE D_E_L_E_T_ = ' ' AND RCH_ROTEIR = 'VAL' AND RCH_FILIAL = '"+RCH->RCH_FILIAL+"' AND RCH_PER = '"+RCH->RCH_PER+"'"
c_Query1 	:= ChangeQuery(c_Query1)
TCQuery c_Query1 New Alias "WGPE"
If !WGPE->(Eof())
	If !Empty(WGPE->RCH_DTFECH)
		l_VA := 2
	Else
		l_VA := 1
	Endif
Endif
WGPE->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver fechado Busca o Valor do VA no RG2                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VA = 2
	c_Query1	:= "SELECT RG2_FILIAL,RG2_MAT,RG2_CODIGO,RG2_DIACAL,RG2_VALCAL,RG2_VALCAL/30 VUNIT,RG2_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("RG2")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND RG2_TPVALE = '2'
	c_Query1	+= " AND RG2_VALCAL > 0
	c_Query1	+= " AND RG2_DIACAL > 0
	c_Query1	+= " AND RG2_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND RG2_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND RG2_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVA += Round(WGPE->VUNIT,2)
		n_TotVA += Round(WGPE->RG2_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se estiver Aberto Busca o Valor do VT no SR0                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l_VA = 1
	c_Query1	:= "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_QDIACAL,R0_VALCAL,R0_VALCAL/30 VUNIT,R0_PERIOD"
	c_Query1	+= " FROM "+RetSqlName("SR0")+" A
	c_Query1	+= " WHERE A.D_E_L_E_T_ = ' '
	c_Query1	+= " AND R0_TPVALE = '2'
	c_Query1	+= " AND R0_VALCAL > 0
	c_Query1	+= " AND R0_QDIACAL > 0
	c_Query1	+= " AND R0_FILIAL = '"+SRA->RA_FILIAL+"'"
	c_Query1	+= " AND R0_MAT = '"+SRA->RA_MAT+"'"
	c_Query1	+= " AND R0_PERIOD = '"+RCH->RCH_PER+"'"
	TCQuery c_Query1 New Alias "WGPE"
	While !WGPE->(Eof())
		n_UniVA += Round(WGPE->VUNIT,2)
		n_TotVA += Round(WGPE->R0_VALCAL,2)
		WGPE->(dbSkip())
	Enddo
	WGPE->(dbCloseArea())
Endif

n_VA := n_UltDia - Day(dDataDem) 

If n_VA
	fGeraVerba(c_PDVA,Min(n_VA * n_UniVA,n_TotVA),n_VA)
Endif   
 

//Alert("aqui")

RestArea(a_Area)
	
Return