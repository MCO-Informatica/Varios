#include "protheus.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o    ? XAcAplic    ? Autor ? Rafael Rodrigues    ? Data ? 30/12/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o ? Aplica os conteudos programaticos previstos automaticamente  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?                                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Gestao Educacional                                           潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
User Function XACAplic()
	Processa( {|| ACAplica() } )
Return
Static Function ACAplica()
local dAula
local aDayOff
local aAulas
local i

private nAula	:= 0

ProcRegua( JB3->( RecCount() ) )

JAH->( dbSetOrder(4) )	// Filial + Curso + Versao
JAR->( dbSetOrder(1) )	// Filial + Curso Vigente + Periodo Letivo
JAT->( dbSetOrder(1) )	// 
JAU->( dbSetOrder(1) )	// 
JAZ->( dbSetOrder(1) )	// JAZ_FILIAL+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM
JB3->( dbSetOrder(2) )	// JB3_FILIAL+JB3_ANO+JB3_PERIOD+JB3_CURSO+JB3_VERSAO+JB3_PERLET+JB3_CODDIS
JBL->( dbSetOrder(4) )	// JBL_FILIAL+JBL_CODDIS+JBL_CODCUR+JBL_PERLET+JBL_TURMA
JBV->( dbSetOrder(1) )	// JBV_FILIAL+JBV_COD+JBV_ITEM

JB3->( dbGoTop() )

while JB3->( !eof() )

	// Incrementa a Regua de Processamento
	IncProc('Processando conte鷇os program醫icos de '+JB3_ANO+'...')

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砅ercorre os cursos vigentes ativos para o curso e versao em uso.?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	JAH->( dbSeek(xFilial("JAH")+JB3->JB3_CURSO+JB3->JB3_VERSAO) )

	while JAH->( !eof() .and. JAH_FILIAL+JAH_CURSO+JAH_VERSAO == xFilial("JAH")+JB3->JB3_CURSO+JB3->JB3_VERSAO )

		JAR->( dbSeek(xFilial("JAR")+JAH->JAH_CODIGO+JB3->(JB3_PERLET+JB3_HABILI)) )

		if JAR->JAR_ANOLET <> JB3->JB3_ANO .or. JAR->JAR_PERIOD <> JB3->JB3_PERIOD

			JAH->( dbSkip() )
			loop

		endif

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//矼onta array aDayOut com os feriados do calendario academico em uso.?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		JBV->( dbSeek(xFilial("JBV")+JAR->JAR_CALACA) )
		
		aDayOff := {}
		
		while JBV->( !eof() .and. JBV_FILIAL+JBV_COD == xFilial("JBV")+JAR->JAR_CALACA )

			aAdd( aDayOff, { JBV->JBV_DTINI, JBV->JBV_DTFIM } )
			JBV->( dbSkip() )
			
		end

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//砅ercorre a grade de aulas do curso vigente em uso.?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		JBL->( dbSeek(xFilial("JBL")+JB3->JB3_CODDIS+JAH->JAH_CODIGO+JB3->(JB3_PERLET+JB3_HABILI)) )

		aAulas	:= {}
		
		while JBL->( !eof() .and. JBL_FILIAL+JBL_CODDIS+JBL_CODCUR+JBL_PERLET+JBL_HABILI == xFilial("JBL")+JB3->JB3_CODDIS+JAH->JAH_CODIGO+JB3->(JB3_PERLET+JB3_HABILI))

			if aScan( aAulas, {|x| x[1] == JBL->JBL_TURMA} ) == 0
				aAdd( aAulas, {JBL->JBL_TURMA, { Val(JBL->JBL_DIASEM) }} )
			else
				aAdd( aAulas[aScan( aAulas, {|x| x[1] == JBL->JBL_TURMA} )][2]	, Val(JBL->JBL_DIASEM) )
			endif

			JBL->( dbSkip() )
				
		end
			
		for i := 1 to len( aAulas )

			dAula	:= JAR->JAR_DATA1 - 1
			nAula	:= 0

			JAZ->( dbSeek(xFilial("JAZ")+JB3->(JB3_CURSO+JB3_VERSAO+JB3_PERLET+JB3_HABILI+JB3_ANO+JB3_PERIOD+JB3_CODDIS)) )
			
			while JAZ->( !eof() .and. JAZ_FILIAL+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS == xFilial("JAZ")+JB3->( JB3_CURSO+JB3_VERSAO+JB3_PERLET+JB3_HABILI+JB3_ANO+JB3_PERIOD+JB3_CODDIS) )
			
				dAula := ProxAula( dAula, aAulas[i][2], aDayOff )

				if JAU->( !dbSeek(xFilial("JAU")+JAH->JAH_CODIGO+JB3->(JB3_PERLET+JB3_HABILI+JB3_CODDIS)+aAulas[i][1]+JAZ->JAZ_ITEM) ) .or. Empty( JAU->JAU_MATPRF )
			
					JAU->( RecLock("JAU", JAU->( !Found() ) ) )
					JAU->JAU_FILIAL	:= xFilial("JAU")
					JAU->JAU_CODCUR	:= JAH->JAH_CODIGO
					JAU->JAU_PERLET	:= JB3->JB3_PERLET
					JAU->JAU_HABILI	:= JB3->JB3_HABILI
					JAU->JAU_TURMA	:= aAulas[i][1]
					JAU->JAU_CODDIS	:= JB3->JB3_CODDIS
					JAU->JAU_ITEM	:= JAZ->JAZ_ITEM
					JAU->JAU_DATA	:= dAula

					MSMM(, TamSX3("JAU_CODPRE")[1],, MSMM(JAZ->JAZ_CODPRE), 1,,, "JAU", "JAU_CODPRE" )
					MSMM(, TamSX3("JAU_CODREA")[1],, MSMM(JAZ->JAZ_CODPRE), 1,,, "JAU", "JAU_CODREA" )
					
					JAU->( msUnlock() )
					
					// JAT_FILIAL+JAT_CODCUR+JAT_PERLET+JAT_TURMA+JAT_CODDIS+JAT_MATPRF
					if JAT->( !dbSeek(xFilial("JAT")+JAU->( JAU_CODCUR+JAU_PERLET+JAU_HABILI+JAU_CODDIS+JAU_TURMA )) )

						JAT->( RecLock("JAT", .T.) )

						JAT->JAT_FILIAL	:= xFilial("JAT")
						JAT->JAT_CODCUR	:= JAU->JAU_CODCUR
						JAT->JAT_PERLET	:= JAU->JAU_PERLET
						JAT->JAT_HABILI	:= JAU->JAU_HABILI
						JAT->JAT_TURMA	:= JAU->JAU_TURMA
						JAT->JAT_CODDIS	:= JAU->JAU_CODDIS

						JAT->( msUnlock() )
					endif
                endif
                
				JAZ->( dbSkip() )
                
			end
			
		next i
		JAH->( dbSkip() )

	end
	JB3->( dbSkip() )

end

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o    ? ProxAula    ? Autor ? Rafael Rodrigues    ? Data ? 08/08/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o ? Aplica o conteudo programatico previsto para os cursos       潮?
北?          ? vigentes existentes.                                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?                                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Gestao Educacional                                           潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function ProxAula( dAula, aAulas, aDayOff)
local dRet
local i
local nProx
local lVira

if Empty( aAulas )
	Return dAula
endif

while .T.

	lVira := nAula > len(aAulas)
	nAula := if( nAula > len(aAulas), 1, nAula )
	nProx := if( nAula == len(aAulas), 1, nAula + 1 )

	if nAula > 0
		if aAulas[nAula] > aAulas[nProx]
			dRet := dAula + ( 7 - ( aAulas[nAula] - aAulas[nProx] ) )
		else
			dRet := dAula + ( aAulas[nProx] - aAulas[nAula] )
		endif
	else
		dRet := dAula + 365
		nAula++

		for i := 1 to len( aAulas )
			if Dow( dAula ) > aAulas[i]
				dRet := if( dAula + ( 7 - ( Dow( dAula ) - aAulas[i] ) ) > dRet, dRet, dAula + ( 7 - ( Dow( dAula ) - aAulas[i] ) ) )
			else
				dRet := if( dAula + ( aAulas[i] - Dow( dAula ) ) > dRet, dRet, dAula + ( aAulas[i] - Dow( dAula ) ) )
			endif
		next i

	endif
	
	nAula++

	// trata a virada da semana
	dRet := if( dRet == dAula .and. lVira, dRet + 7, dRet )
	
	// Verifica se eh feriado, e finaliza o laco se for dia valido.
	if aScan( aDayOff, {|x| dRet >= x[1] .and. dRet <= x[2]} ) == 0
		exit
	endif

end

Return dRet