#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOPCONN.CH'
/*
Número do Título	aValores[1,1]
Data da Baixa		aValores[1,2]
Tipo do Título		aValores[1,3]
Nosso Número		aValores[1,4]
Despesa				aValores[1,5]
Desconto			aValores[1,6]
Abatimento			aValores[1,7]
Valor Recebido		aValores[1,8]
Juros				aValores[1,9]
Multa				aValores[1,10]
Valor CC			aValores[1,11]
Credito				aValores[1,12]
Ocorrência			aValores[1,13]
Buffer				aValores[1,14]
*/

User Function F650VAR()
Local cE1_NUM	:= ""
Local cE1_PARC	:= ""
Local _aValores := ParamIxb
Local cAux		:= ""

If Empty( _aValores[1][4] )

   _aValores[1][4] := Substr( _aValores[ 1 ][14], 63, 8 ) + Space( 2 )
   cTipo           := 'NF '
   _aValores[1][3] := 'NF'
   SE1->( dbSetOrder( 19 ) )
   SE1->( dbSeek( _aValores[1][4], .F. ) )

   While SE1->E1_IDCNAB = _aValores[1][4]

      If ( SE1->E1_VALOR <> ( Val( Substr( xBuffer, 154, 12 ) ) / 100 ) )

         SE1->( dbSkip() )

      Else

         cNumTit := _aValores[1][4]
         Exit

      End
   
   End

End

//Se for CNAB Recebimento
If MV_PAR07 = 1 .AND. AllTrim(Upper(MV_PAR02))$ "BRDFAC.RET|"
	If At("/", cNumTit) > 0
		cE1_NUM 	:=	StrZero(Val(Substring(cNumTit, 1, At("/", cNumTit)-1)),TamSx3("E1_NUM")[1])
		cE1_PARC	:=	U_ConvParc(Substring(cNumTit, At("/", cNumTit)+1, 3))
		
		cNumTit		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1][8])
	Else
		cE1_NUM 	:=	StrZero(Val(Substring(cNumTit, 1, 7)),TamSx3("E1_NUM")[1])
		cE1_PARC	:=	Substring(cNumTit, 8, 1)
		
		cAux	:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1][8])
		
		//Algumas FIDCs enviam numero 2 na frente do titulo, por este motivo, se não encontrar o titulo, tenta localizar desconsiderando o "2"
		/*
		If Empty(cAux) .AND. Substring(cNumTit, 1, 1) == "2"
			cE1_NUM 	:=	StrZero(Val(Substring(cNumTit, 2, 6)),TamSx3("E1_NUM")[1])
			cE1_PARC	:=	Substring(cNumTit, 8, 1)
			
			cAux		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1][8])
		EndIf
		*/
		If Empty(cAux) .AND. Substring(cNumTit, 1, 1) $ "2/1"
			cE1_NUM 	:=	StrZero(Val(Substring(cNumTit, 2, LEN(AllTrim(cNumTit))-2)),TamSx3("E1_NUM")[1])
			cE1_PARC	:=	Right(cNumTit, 1)
			
			cAux		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1][8])
		EndIf

		cNumTit := cAux
	EndIf
EndIf

Return( NIL )

/*/{Protheus.doc} CriaIdCnab
//TODO cria um idcnab com forme o produto padrão.
@author Bruno
@since 12/04/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CriaIdCnab()
Local cIdCnab 	:= GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,19)
Local aAreaSE1	:= SE1->(GetArea())

dbSelectArea("SE1")
dbSetOrder(16)

While SE1->(dbSeek(xFilial("SE1")+cIdCnab))
	If ( __lSx8 )
		ConfirmSX8()
	EndIf
	cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,19)
EndDo

ConfirmSx8()

RestArea(aAreaSE1)
Return cIdCnab

User Function ConvParc(cParc)
Local cRet		:= "A"
Local nI		:= 0
Local nParc		:= Val(Substring(cNumTit, At("/", cNumTit)+1, 3))

For nI := 1 to nParc
	If nI > 1
		cRet := Soma1(cRet)
	EndIf
Next nI

Return cRet

User Function AchaTitu(cE1_NUM, cE1_PARC, cTipoT, nVlr, nEncargo)
Local cQry 		:= ""
Local cIdCnab	:= ""
Local cTMPAlia	:= GetNextAlias()
Default nEncargo := 0

cQry := "SELECT E1_IDCNAB, R_E_C_N_O_ AS RECN "+CRLF
cQry += "FROM "+RetSqlName("SE1")+"           "+CRLF
cQry += "WHERE E1_NUM       = '"+cE1_NUM +"'  "+CRLF
cQry += "AND   E1_PARCELA   = '"+cE1_PARC+"'  "+CRLF
cQry += "AND   E1_PORTADO   = '"+MV_PAR06+"'  "+CRLF
cQry += "AND   E1_AGEDEP    = '"+MV_PAR07+"'  "+CRLF
cQry += "AND   E1_CONTA     = '"+MV_PAR08+"'  "+CRLF

If lFDVldVl
	cQry += "AND   E1_VALOR 	= "+cValToChar(nvlr-nEncargo)+CRLF
EndIf
cQry += "AND   D_E_L_E_T_  <> '*'             "+CRLF

//Executa a query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTMPAlia,.T.,.T.)

If (cTMPAlia)->(!Eof())
	cIdCnab := (cTMPAlia)->E1_IDCNAB
	DbSelectArea("SE1")
	SE1->(DbGoTo((cTMPAlia)->RECN))

	If Empty(cIdCnab)
		cIdCnab := CriaIdCnab()
		
		RecLock("SE1", .F.)
			SE1->E1_IDCNAB := cIdCnab
		SE1->(MsUnlock()) 
	EndIf
EndIf

Return cIdCnab
