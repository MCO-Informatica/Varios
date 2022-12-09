#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "06"
#DEFINE cPERIODO_PONTO "2019101620191115"
#DEFINE cCHAVE_PBB     "  06001759"

user function CSRH260()
	conout("CSRH260 iniciado em: " + dtoc(date()) + ' - ' + time())
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL

	//u_CSRH011("", cDEBUG_cFILIAL, "", "", cPERIODO_PONTO)
	regra99()
	ajustaPBB()
	procAllPBB()

	RESET ENVIRONMENT
	conout("CSRH260 finalizado em: " + dtoc(date()) + ' - ' + time())
return

user function CSRH261()
	local aFile := {"marcacao-2.02.js", "area-rh-2.02.js"}
	loca i := 1
	
	conout("CSRH261 iniciado em: " + dtoc(date()) + ' - ' + time())
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL

	for i := 1 to len(aFile)
		if CpyT2S( "C:\p12-loboguarana\protheus_data\web\pp\ponto_eletronico\scripts\"+aFile[i], "web\pp\ponto_eletronico\scripts", .F., .T. )
			conout("copiou")
		else
			conout("nao copiou")
		endif
	next

	RESET ENVIRONMENT
	conout("CSRH261 finalizado em: " + dtoc(date()) + ' - ' + time())
return	



static function procAllPBB()
	local cChavePBB  := ""
	local cChvPBBAnt := ""
	local cAtrAnt := ""
	local cAtrHe := ""	

	cChavePBB := cCHAVE_PBB

	if empty(cChavePBB) //vazio processa todos
		conout("CSRH260 processo geral")
		PBB->(dbSetOrder(2))
		PBB->( dbSeek( xFilial("PBB")+cDEBUG_cFILIAL ) )
		while PBB->(!EoF()) 
			if PBB->PBB_FILMAT != cDEBUG_cFILIAL
				exit
			endif
			if cChvPBBAnt != PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
				fPB7SAPR(PBB->PBB_FILMAT, PBB->PBB_MAT)
				cAtrAnt := ""
				cAtrAnt := ""
			endif

			if PBB->PBB_PAPONT = cPERIODO_PONTO
				conout("PBB: " + PBB->PBB_FILMAT+" | "+PBB->PBB_MAT+" | "+DTOC(PBB->PBB_DTAPON))
				atuPB7(PBB->PBB_FILMAT, PBB->PBB_MAT, PBB->PBB_DTAPON)
				conout("")
			endif
			cChvPBBAnt := PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
			cAtrAnt := PBB->PBB_STAATR
			cAtrAnt := PBB->PBB_STAHE
			PBB->(dbSkip())

		end
		fPB7SAPR(cChvPBBAnt)
	else
		conout("CSRH260 chave PBB:" + cChavePBB )
		PBB->(dbSetOrder(2))
		if PBB->( dbSeek( cChavePBB ) )
			while PBB->(!EoF()) .and. cChavePBB == PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
				if cChvPBBAnt != PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
					fPB7SAPR(PBB->PBB_FILMAT, PBB->PBB_MAT)
				endif

				if PBB->PBB_PAPONT = cPERIODO_PONTO
					conout("PBB: " + PBB->PBB_FILMAT+" | "+PBB->PBB_MAT+" | "+DTOC(PBB->PBB_DTAPON))
					atuPB7(PBB->PBB_FILMAT, PBB->PBB_MAT, PBB->PBB_DTAPON, cAtrAnt, cAtrHe)
					conout("")
				endif
				cChvPBBAnt := PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
				PBB->(dbSkip())
			end
			fPB7SAPR(cChvPBBAnt)
		endif
	endif
return

static function atuPB7(cFuncFil, cFuncMat, dApon, cAtrAnt, cAtrHe)
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local lProcessado := .F.

	default cFuncFil := ""
	default cFuncMat := ""
	default dApon := ctod("//")	
	default cAtrAnt := ""
	default cAtrHe := ""	

	if empty(cFuncFil) .or. empty(cFuncMat) .or. empty(dApon)
		return lProcessado
	endif 

	cQuery := QryPB7Ver(cFuncFil, cFuncMat, dApon)
	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		PB7->(dbSetOrder(1))
		while (calias)->(!Eof())
			dbSelectArea("PB7")
			dbGoTo( (calias)->REC )
			if (calias)->REC == PB7->(recno() )
				conout("PB7: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA ))

				atuPBB(cFuncFil, cFuncMat, dApon, cAtrAnt, cAtrHe)
				aprovFinal(cFuncFil, cFuncMat, dApon)

				lProcessado := .T.
			endif
			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif
return lProcessado

static function atuPBB(cFuncFil, cFuncMat, dApon, cAtrAnt, cAtrHe)
	local lAprovAtr := .F.
	local lAprovHe  := .F.
	local lAprovRH  := .F.
	local cStaAprv := ""
	local cStaIgnN := ""
	local cStaIgnP := ""
	local cAprRep := ""
	local cStaAtr := ""
	local cStaHe := ""
	local aAreaPBB := PBB->(GetArea())
	local aAreaPB7 := PB7->(GetArea())

	default cFuncFil := ""
	default cFuncMat := ""
	default dApon := ctod("//")	
	default cAtrAnt := ""
	default cAtrHe := ""

	if 	 (!empty( PB7->PB7_HRNEGE ) .and. PB7->PB7_HRNEGV == 0) ;
	.or. (!empty( PB7->PB7_HRPOSE ) .and. PB7->PB7_HRPOSV == 0)

		recLock("PB7",.F.)
		PB7->PB7_STATUS := "1"
		PB7->PB7_STAATR := iif(!empty( PB7->PB7_HRNEGE ), "1", "0")
		PB7->PB7_STAHE  := iif(!empty( PB7->PB7_HRPOSE ), "1", "0")
		PB7->( msUnlock() )
		U_CSRH012(cFuncFil, cFuncMat, cPERIODO_PONTO, "000000", dApon, dApon, .F. )
		restArea( aAreaPBB )
		restArea( aAreaPB7 )
	endif


	lAprovAtr := !empty( PB7->PB7_HRNEGE ) .and. PB7->PB7_HRNEGV > 0
	lAprovHe  := !empty( PB7->PB7_HRPOSE ) .and. PB7->PB7_HRPOSV > 0

	if !empty(PB7->PB7_AFASTA) .or. !empty(PB7->PB7_ALTERH) .or. existeRF0()
		lAprovRH  := ( lAprovHe .or. lAprovAtr  )
	endif

	cStaAprv := iif( lAprovRH			, "5"		, "2" )
	cStaIgnN := iif( lAprovAtr			, iif( PBB->PBB_STATUS == "3", iif(lAprovAtr, "3","5"), cStaAprv) 	,   iif(lAprovRH, "5", "6") )
	cStaIgnP := iif( lAprovHe			, iif( PBB->PBB_STATUS == "3", iif(lAprovHe , "3","5"), cStaAprv)	,   iif(lAprovRH, "5", "6") )
	cAprRep  := iif( PBB->PBB_STATUS == "3"	, "3/4"		, "" )
	cStaAtr  := iif( lAprovAtr .and. !(PBB->PBB_STAATR $ cAprRep+cStaAprv), cStaAprv, cStaIgnN )
	cStaHe   := iif( lAprovHe  .and. !(PBB->PBB_STAHE  $ cAprRep+cStaAprv), cStaAprv, cStaIgnP )

	dbSelectArea("PBB")
	recLock("PBB",.F.)
	if PBB->PBB_STATUS == "3"
		PBB->PBB_STAATR := cStaAtr
		PBB->PBB_STAHE  := cStaHe
	else
		PBB->PBB_STAATR := iif(!empty(cAtrAnt), cAtrAnt, cStaAtr)
		PBB->PBB_STAHE  := iif(!empty(cAtrHe ), cAtrHe , cStaHe)
	endif
	PBB->( msUnlock() )

	dbSelectArea("PB7")
	recLock("PB7",.F.)
	PB7->PB7_STATUS := iif( !lAprovAtr .and. !lAprovHe, iif( lAprovRH, "5", "6" ), cStaAprv  )
	if PBB->PBB_STATUS == "3"
		PB7->PB7_STAATR := cStaAtr
		PB7->PB7_STAHE  := cStaHe
	else
		PB7->PB7_STAATR := iif(PB7->PB7_STAATR == "3", iif(lAprovAtr, "3","5"),  iif(!empty(cAtrAnt), cAtrAnt, cStaAtr))
		PB7->PB7_STAHE  := iif(PB7->PB7_STAHE  == "3", iif(lAprovHe , "3","5"),  iif(!empty(cAtrHe ), cAtrHe , cStaHe))
	endif
	PB7->( msUnlock() )

	conout("Status atualizados...: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
	if PBB->PBB_STATUS == "1"
		conout( "Nao aprovado.....: " + posicione("RD0", 1, xFilial("RD0")+PBB->PBB_APROV , "RD0_NOME" ) )
	endif
	conout("	PB7 Status ......: " + PB7->PB7_STATUS)
	conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
	conout("	PB7 Status He....: " + PB7->PB7_STAHE)	
	conout("	PBB Status Atraso: " + PBB->PBB_STAATR)
	conout("	PBB Status He....: " + PBB->PBB_STAHE)



return


Static Function QryPB7Ver(cFilFunc, cMatFunc, dApon)
	local cRetorno 	 := ""

	default cFilFunc   := ""
	default cPerAponta := ""
	default dApon := ctod("//")

	cRetorno := " SELECT  "
	cRetorno += " 	PB7.PB7_ORDEM, PB7.PB7_DATA, PB7.R_E_C_N_O_ REC"
	cRetorno += " FROM  ( "
	cRetorno += "        SELECT PB7_FILIAL "
	cRetorno += "             , PB7_MAT    "
	cRetorno += "             , PB7_DATA   "
	cRetorno += "             , MAX(PB7_VERSAO) VERSAO   "
	cRetorno += "        FROM  "+RetSqlName("PB7")+" "
	cRetorno += "        WHERE PB7_FILIAL = '" + cFilFunc + "'"
	cRetorno += "          AND PB7_MAT    = '" + cMatFunc + "'"
	if !empty(dApon)
		cRetorno += "          AND PB7_DATA    = '" + dtos(dApon) + "'"
	endif
	cRetorno += "          AND PB7_PAPONT = '"+cPERIODO_PONTO+"' "
	cRetorno += "          AND D_E_L_E_T_ = ' ' "
	cRetorno += "        GROUP BY PB7_FILIAL, PB7_MAT, PB7_DATA "
	cRetorno += "       ) PB7FIL "
	cRetorno += " INNER JOIN "+RetSqlName("PB7")+" PB7 ON "
	cRetorno += " 		PB7FIL.PB7_FILIAL = PB7.PB7_FILIAL "
	cRetorno += "       AND PB7FIL.PB7_MAT    = PB7.PB7_MAT    "
	cRetorno += "       AND PB7FIL.PB7_DATA   = PB7.PB7_DATA   "
	cRetorno += "       AND PB7FIL.VERSAO     = PB7.PB7_VERSAO "
	cRetorno += "       AND PB7.D_E_L_E_T_ = ' ' "
	cRetorno += "       AND PB7.PB7_PAPONT = '"+cPERIODO_PONTO+"'"
	cRetorno += " ORDER BY PB7.PB7_ORDEM, PB7.PB7_DATA, PB7.R_E_C_N_O_"
Return(cRetorno)


static function existeRF0( )
	RF0->(dbSetOrder(1))
return RF0->(dbSeek( PB7->(PB7_FILIAL+PB7_MAT+DTOS(PB7_DATA))))


static function fPB7SAPR(cFuncFil, cFuncMat)
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local lAprovAtr := .F.
	local lAprovHe  := .F.
	local lAprovRH  := .F.
	local aAreaPBB := PBB->(GetArea())
	local aAreaPB7 := PB7->(GetArea())	

	default cFuncFil := "" 
	default cFuncMat := ""

	cQuery := QryPB7Ver(cFuncFil, cFuncMat)
	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		PB7->(dbSetOrder(1))
		while (calias)->(!Eof())
			dbSelectArea("PB7")
			dbGoTo( (calias)->REC )
			if (calias)->REC == PB7->( recno() )
				if PB7->PB7_STATUS $ "0/1"

					lAprovAtr := !empty( PB7->PB7_HRNEGE ) .and. PB7->PB7_HRNEGV > 0
					lAprovHe  := !empty( PB7->PB7_HRPOSE ) .and. PB7->PB7_HRPOSV > 0

					if !empty(PB7->PB7_AFASTA) .or. !empty(PB7->PB7_ALTERH) .or. existeRF0()
						lAprovRH  := ( lAprovHe .or. lAprovAtr  )
					endif				


					dbSelectArea("PB7")
					recLock("PB7",.F.)
					PB7->PB7_STATUS := iif( lAprovRH , "5", "6"  )
					PB7->PB7_STAATR := iif( lAprovAtr, "9", iif( lAprovRH, "5", "6"  ) )
					PB7->PB7_STAHE  := iif( lAprovHe , "9", iif( lAprovRH, "5", "6"  ) )
					PB7->( msUnlock() )				

					conout("Sem aprovacao........: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
					conout("	PB7 Status ......: " + PB7->PB7_STATUS)
					conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
					conout("	PB7 Status He....: " + PB7->PB7_STAHE)	

				endif
			endif

			PBB->(dbSetOrder(2))
			if !(PBB->(dbSeek( xFilial("PBB")+cFuncFil+cFuncMat+(cAlias)->PB7_DATA )))
				dbSelectArea("PB7")
				recLock("PB7",.F.)
				PB7->PB7_STAATR := iif( PB7->PB7_STATUS == "5", "5", "6"  )
				PB7->PB7_STAHE  := iif( PB7->PB7_STATUS == "5", "5", "6"  )
				PB7->( msUnlock() )

				conout("Sem registro PBB.....: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
				conout("	PB7 Status ......: " + PB7->PB7_STATUS)
				conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
				conout("	PB7 Status He....: " + PB7->PB7_STAHE)	
			endif

			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif
	restArea( aAreaPBB )
	restArea( aAreaPB7 )	
return

static function aprovFinal(cFilFunc, cFuncMat, dApon)
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local lProcessado := .F.


	default cFuncFil := ""
	default cFuncMat := ""
	default dApon := ctod("//")	

	if empty(cFilFunc) .or. empty(cFuncMat) .or. empty(dApon)
		return lProcessado
	endif 



	cQuery := " SELECT "
	cQuery += " COUNT(*) QTD "
	cQuery += " FROM "
	cQuery += " "+RetSqlName("PBB")+" PBB "
	cQuery += " WHERE "
	cQuery += " PBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND PBB.PBB_STATUS IN ('1','2') "
	cQuery += " AND PBB.PBB_FILMAT = '"+cFilFunc+"' "
	cQuery += " AND PBB.PBB_MAT	   = '"+cFuncMat+"' "
	cQuery += " AND PBB.PBB_DTAPON = '"+DTOS(dApon)+"' "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		if (calias)->QTD == 0
			if PB7->PB7_STATUS == "2"
				recLock("PB7",.F.)
				lProcessado := .T.
				PB7->PB7_STATUS := "7"
				PB7->( msUnlock() )
			endif

			conout("Status calculado.....: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
			conout("	PB7 Status ......: " + PB7->PB7_STATUS)
			conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
			conout("	PB7 Status He....: " + PB7->PB7_STAHE)	
			conout("	PBB Status Atraso: " + PBB->PBB_STAATR)
			conout("	PBB Status He....: " + PBB->PBB_STAHE)

		endif

		(calias)->(dbCloseArea())
	endif
return lProcessado

static function regra99()
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local dDia := ctod("16/08/2019")

	cQuery := " SELECT "
	cQuery += "    RA_FILIAL, "
	cQuery += "    RA_MAT, "
	cQuery += "    RA_NOME, "
	cQuery += "    COUNT(P8_MAT) SP8, "
	cQuery += "    COUNT(PC_MAT) SPC, "
	cQuery += "    COUNT(PK_MAT) SPK, "
	cQuery += "    COUNT(PB7_MAT) PB7, "
	cQuery += "    COUNT(PBB_MAT) PBB, "
	cQuery += "    COUNT(PI_MAT) SPI  "
	cQuery += " FROM "
	cQuery += "    SRA010 SRA " 
	cQuery += "    LEFT JOIN "
	cQuery += "       SP8010 SP8 " 
	cQuery += "       ON SP8.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND P8_FILIAL = RA_FILIAL " 
	cQuery += "       AND P8_MAT = RA_MAT  "
	cQuery += "    LEFT JOIN "
	cQuery += "       SPC010 SPC " 
	cQuery += "       ON SPC.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND PC_FILIAL = RA_FILIAL " 
	cQuery += "       AND PC_MAT = RA_MAT  "
	cQuery += "    LEFT JOIN "
	cQuery += "       SPK010 SPK " 
	cQuery += "       ON SPK.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND PK_FILIAL = RA_FILIAL " 
	cQuery += "       AND PK_MAT = RA_MAT  "
	cQuery += "       AND PK_DATA = '20190816' " 
	cQuery += "    LEFT JOIN "
	cQuery += "       PB7010 PB7 " 
	cQuery += "       ON PB7.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND PB7_FILIAL = RA_FILIAL " 
	cQuery += "       AND PB7_MAT = RA_MAT  "
	cQuery += "    LEFT JOIN "
	cQuery += "       PBB010 PBB " 
	cQuery += "       ON PBB.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND PBB_FILMAT = RA_FILIAL " 
	cQuery += "       AND PBB_MAT = RA_MAT  "
	cQuery += "    LEFT JOIN SPI010 SPI ON "
	cQuery += "       SPI.D_E_L_E_T_ = ' ' "
	cQuery += "       AND PI_FILIAL = RA_FILIAL "
	cQuery += "       AND PI_MAT = RA_MAT "
	cQuery += "       AND PI_DATA >= '20190816' "	
	cQuery += " WHERE "
	cQuery += "    SRA.D_E_L_E_T_ = ' ' " 
	cQuery += "    AND RA_REGRA = '99'  "
	cQuery += " GROUP BY "
	cQuery += "    RA_FILIAL, "
	cQuery += "    RA_MAT, "
	cQuery += "    RA_NOME  "
	cQuery += " HAVING "
	cQuery += " ( COUNT(P8_MAT) > 0 " 
	cQuery += "    OR COUNT(PC_MAT) > 0 " 
	cQuery += "    OR COUNT(PK_MAT) > 0  "
	cQuery += "    OR COUNT(PB7_MAT) > 0 " 
	cQuery += "    OR COUNT(PBB_MAT) > 0 "
	cQuery += "    OR COUNT(PI_MAT)  > 0  )

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		while (calias)->(!EoF())
			if (calias)->SP8 > 0
				SP8->( dbSetOrder(1) )
				if SP8->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) )
					while SP8->(!EoF() ) .and.  (calias)->(RA_FILIAL+RA_MAT) == SP8->(P8_FILIAL+P8_MAT)
						recLock("SP8",.F.)
						CONOUT("DEL SP8: "+SP8->(P8_FILIAL+P8_MAT))
						SP8->( dbDelete() )
						SP8->( msUnlock() )
						SP8->( dbSkip() )
					end
				endif
			endif

			if (calias)->SPC > 0
				SPC->( dbSetOrder(1) )
				if SPC->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) )
					while SPC->(!EoF() ) .and.  (calias)->(RA_FILIAL+RA_MAT) == SPC->(PC_FILIAL+PC_MAT)
						recLock("SPC",.F.)
						CONOUT("DEL SPC: "+SPC->(PC_FILIAL+PC_MAT))
						SPC->( dbDelete() )
						SPC->( msUnlock() )
						SPC->( dbSkip() )
					end
				endif
			endif

			if (calias)->SPK > 0
				SPK->( dbSetOrder(1) )
				if SPK->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) )
					while SPK->(!EoF() ) .and.  (calias)->(RA_FILIAL+RA_MAT) == SPK->(PK_FILIAL+PK_MAT)
						if SPK->PK_DATA >= dDia
							recLock("SPK",.F.)
							CONOUT("DEL SPK: "+SPK->(PK_FILIAL+PK_MAT))
							SPK->( dbDelete() )
							SPK->( msUnlock() )
						endif
						SPK->( dbSkip() )
					end
				endif		
			endif

			if (calias)->PB7 > 0	
				PB7->( dbSetOrder(1) )
				if PB7->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) )
					while PB7->(!EoF() ) .and.  (calias)->(RA_FILIAL+RA_MAT) == PB7->(PB7_FILIAL+PB7_MAT)
						recLock("PB7",.F.)
						CONOUT("DEL PB7: "+PB7->(PB7_FILIAL+PB7_MAT))
						PB7->( dbDelete() )
						PB7->( msUnlock() )
						PB7->( dbSkip() )
					end
				endif
			endif

			if (calias)->PBB > 0
				PBB->( dbSetOrder(2) )
				if PBB->( dbSeek( (calias)->(xFilial("PBB")+RA_FILIAL+RA_MAT) ) )
					while PBB->(!EoF() ) .and.  (calias)->(xFilial("PBB")+RA_FILIAL+RA_MAT) == PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
						recLock("PBB",.F.)
						CONOUT("DEL PBB: "+PBB->(PBB_FILMAT+PBB_MAT))
						PBB->( dbDelete() )
						PBB->( msUnlock() )
						PBB->( dbSkip() )
					end
				endif			
			endif
			
			if (calias)->SPI > 0
				SPI->( dbSetOrder(1) )
				if SPI->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) )
					while SPI->(!EoF() ) .and.  (calias)->(RA_FILIAL+RA_MAT) == SPI->(PI_FILIAL+PI_MAT)
						if SPI->PI_DATA >= dDia
							recLock("SPI",.F.)
							CONOUT("DEL SPI: "+SPI->(PI_FILIAL+PI_MAT))
							SPI->( dbDelete() )
							SPI->( msUnlock() )
						endif
						SPI->( dbSkip() )
					end
				endif		
			endif			

			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif

return

static function ajustaPBB()
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.

	cQuery := " SELECT "
	cQuery += "    PBB_FILMAT, "
	cQuery += "    PBB_MAT, "
	cQuery += "    PBB_APROV, "
	cQuery += "    COUNT(PBB_STATUS) " 
	cQuery += " FROM "
	cQuery += "    ( "
	cQuery += "       SELECT "
	cQuery += "          PBB_FILMAT, "
	cQuery += "          PBB_MAT, "
	cQuery += "          PBB_APROV, "
	cQuery += "          PBB_STATUS  "
	cQuery += "       FROM "
	cQuery += "          PBB010 PBB " 
	cQuery += "       WHERE "
	cQuery += "          PBB.D_E_L_E_T_ = ' ' " 
	cQuery += "       GROUP BY "
	cQuery += "          PBB_FILMAT, "
	cQuery += "          PBB_MAT, "
	cQuery += "          PBB_APROV, "
	cQuery += "          PBB_STATUS  "
	cQuery += "       ORDER BY "
	cQuery += "          1, "
	cQuery += "          2, "
	cQuery += "          3, "
	cQuery += "          4 "
	cQuery += "    ) "
	cQuery += "    TAB  "
	cQuery += " GROUP BY "
	cQuery += "    PBB_FILMAT, "
	cQuery += "    PBB_MAT, "
	cQuery += "    PBB_APROV  "
	cQuery += " HAVING "
	cQuery += "    COUNT(PBB_STATUS) > 1 "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		while (calias)->(!EoF())
			PBB->(dbSetOrder(2))
			if PBB->(dbSeek( (calias)->(xFilial("PBB")+PBB_FILMAT+PBB_MAT)) )
				while PBB->(!EoF() ) .and.  (calias)->(xFilial("PBB")+PBB_FILMAT+PBB_MAT) == PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
					if (calias)->PBB_APROV == PBB->PBB_APROV .and. PBB->PBB_STATUS != "3"
						recLock("PBB",.F.)
						CONOUT("Ajustando PBB_STATUS: "+PBB->(PBB_FILMAT+PBB_MAT) +" - "+DTOC(PBB->PBB_DTAPON))
						PBB->PBB_STATUS := "3"
						PBB->PBB_DTAVAL := date()
						PBB->PBB_LOG := "Ajuste CSRH260" 
						PBB->( msUnlock() )
					endif
					PBB->( dbSkip() )
				end
			endif
			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif		
return