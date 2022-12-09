#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE cEol CHR(13)+CHR(10)
#DEFINE cSep ";"

user function fPonFix3()

	local bProcesso := {|oSelf| Fix003( oSelf )}

	private cCadastro  := "Integrar Aprovações do Portal no Sistema."
	private cDescricao := "Integrar Aprovações do Portal no Sistema."
	private aRet       := {}

	tNewProcess():New( "Fix003" , cCadastro , bProcesso , cDescricao , ,,,,,.T.,.F. ) 	

return

Static function Fix003(oSelf)
	local cQuery    := ""
	local cAlsMix   := GetNextAlias()
	local cChaveSPK := ""
	local nRecPos   := 0
	local nRecNeg   := 0
	local nRecPrc   := 0
	local cCPOSPC   := ""
	local nQtdSPC   := 0
	local aParamBox := {}

	//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ? 
	aAdd(aParamBox,{1              ,"Filial Inicial"   ,Space(02)                                      ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.F.}) // Filial Inicial
	aAdd(aParamBox,{1              ,"Filial Final"     ,Replicate("Z",02)                              ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.T.}) // Filial Inicial
	aAdd(aParamBox,{1              ,"Matricula Inicial",Space(        TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.F.}) // Matricula Inicial
	aAdd(aParamBox,{1              ,"Matricula Final"  ,Replicate("Z",TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.T.}) // Matricula Final
	aAdd(aParamBox,{1              ,"C. Custo inicial" ,Space(        TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.F.}) // C. de Custo Inicial
	aAdd(aParamBox,{1              ,"C. Custo Final"   ,Replicate("Z",TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.T.}) // C. de Custo Final
	aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Inicial
	aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Final

	if !(Parambox(aParambox,"Parametros de Processamento",@aRet))
		return
	endIf


	cQuery := "SELECT PB7_FILIAL "
	cQuery += "      ,PB7_CC     "
	cQuery += "      ,PB7_MAT    "
	cQuery += "      ,(SELECT RA_NOME FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ <> '*' AND RA_FILIAL = PB7_FILIAL AND RA_MAT = PB7_MAT) AS NOME "
	cQuery += "      ,PB7_DATA   "
	cQuery += "      ,PB7_HRPOSE "
	cQuery += "      ,PB7_HRPOSV "
	cQuery += "      ,PB7_HRNEGE "
	cQuery += "      ,PB7_HRNEGV "
	cQuery += "      ,SPCX.PCQTC "
	cQuery += "      ,SPCX.PCQTI "
	cQuery += "      ,SPCX.PCQTB "
	cQuery += "      ,PB7_STATUS "
	cQuery += "      ,PB7_STAATR "
	cQuery += "      ,PB7_STAHE  "
	cQuery += "      ,PB7_VERSAO "
	cQuery += "FROM "+RetSqlName("PB7")+" PB7 "
	cQuery += "INNER JOIN (SELECT PB7B.PB7_FILIAL  AS FIL "
	cQuery += "                  ,PB7B.PB7_MAT     AS MAT "
	cQuery += "                  ,PB7B.PB7_DATA    AS DTA "
	cQuery += "              ,MAX(PB7B.PB7_VERSAO) AS VRS "
	cQuery += "            FROM "+RetSqlName("PB7")+" PB7B      "
	cQuery += "            WHERE  PB7B.D_E_L_E_T_ <> '*'  "
	cQuery += "            GROUP BY PB7B.PB7_FILIAL       "
	cQuery += "                    ,PB7B.PB7_MAT          "
	cQuery += "                    ,PB7B.PB7_DATA) PB7B ON PB7B.FIL = PB7_FILIAL AND PB7B.MAT = PB7_MAT AND PB7B.DTA = PB7_DATA AND PB7B.VRS = PB7_VERSAO "
	cQuery += "LEFT OUTER JOIN (SELECT PC_FILIAL       AS PCFIL "
	cQuery += "                       ,PC_MAT          AS PCMAT "
	cQuery += "                       ,PC_DATA         AS PCDAT "
	cQuery += "                       ,SUM(PC_QUANTC)  AS PCQTC "
	cQuery += "                       ,SUM(PC_QUANTI)  AS PCQTI "
	cQuery += "                       ,SUM(PC_QTABONO) AS PCQTB "
	cQuery += "                 FROM "+RetSqlName("SPC")+" " 
	cQuery += "                 WHERE D_E_L_E_T_ <> '*' "
	cQuery += "                 GROUP BY PC_FILIAL, PC_MAT, PC_DATA "
	cQuery += "                 ORDER BY PC_FILIAL, PC_MAT, PC_DATA "
	cQuery += "                 ) SPCX ON PB7.PB7_FILIAL = SPCX.PCFIL AND PB7.PB7_MAT = SPCX.PCMAT AND PB7.PB7_DATA =  SPCX.PCDAT "
	cQuery += "WHERE PB7.D_E_L_E_T_ <> '*' "
	cQuery += "  AND PB7_FILIAL BETWEEN '"+     aRet[1] +"' AND '"+     aRet[2] +"' "
	cQuery += "  AND PB7_MAT    BETWEEN '"+     aRet[3] +"' AND '"+     aRet[4] +"' "
	cQuery += "  AND PB7_CC     BETWEEN '"+     aRet[5] +"' AND '"+     aRet[6] +"' "
	cQuery += "  AND PB7_DATA   BETWEEN '"+DToS(aRet[7])+"' AND '"+DToS(aRet[8])+"' "
	cQuery += "  AND (PB7.PB7_HRPOSE <> ' ' OR PB7.PB7_HRNEGE <> ' ')   "
	cQuery += "  AND PB7.PB7_STATUS IN('7','8','5')                         "
	cQuery += "ORDER BY PB7_FILIAL, PB7_MAT "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsMix)

	(cAlsMix)->(dbGoTop())

	oSelf:SetRegua1( (cAlsMix)->(RecCount()) )

	While (cAlsMix)->(!Eof()) 

		nRecPrc += 1

		oSelf:IncRegua1( "Processando registro..> "+AllTrim(Str(nRecPrc))+"...Aguarde." )
		if oSelf:lend 
			Break
		endif  

		SRA->(dbSetOrder(1))
		if SRA->(!dbSeek((cAlsMix)->(PB7_FILIAL+PB7_MAT)))
			(cAlsMix)->(dbSkip())
			loop
		endif

		if SRA->RA_SITFOLH == "D"
			(cAlsMix)->(dbSkip())
			loop
		endif

		SPC->(dbSetOrder(2))
		if SPC->(dbSeek( (cAlsMix)->(PB7_FILIAL+PB7_MAT+PB7_DATA) ) )

			while SPC->(!EoF()) .And. SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)) == (cAlsMix)->(PB7_FILIAL+PB7_MAT+PB7_DATA)

				if POSICIONE( 'SP9', 1, XFILIAL('SP9')+SPC->PC_PD, 'P9_CLASEV' ) $ '01' //-> Se for hora extra...

					cCPOSPC := Posicione("SP4",2,SPC->(PC_FILIAL+PC_PD),"P4_CODAUT")
					nQtdSPC := SPC->PC_QUANTC

					if (cAlsMix)->PB7_STAHE <> '3' 
						cCPOSPC := " "
						nQtdSPC := 0
					endIf

					nRecPos ++

					//Atualiza apontamento de hora extra
					SPC->(RecLock('SPC', .F.))
					SPC->PC_PDI    := cCPOSPC
					SPC->PC_QUANTI := nQtdSPC
					SPC->(MsUnLock())

				Elseif POSICIONE( 'SP9', 1, XFILIAL('SP9')+SPC->PC_PD, 'P9_CLASEV' ) $ '02/03/04/05' .And.; //-> Horas negativas.
				SPC->PC_USUARIO = ' '  .And. SPC->PC_ABONO = ' ' 

					cCPOSPC := (cAlsMix)->PB7_HRNEGE
					nQtdSPC := SPC->PC_QUANTC

					if (cAlsMix)->PB7_STAATR <> '3' 
						cCPOSPC := " "
						nQtdSPC := 0
					endIf

					nRecNeg ++

					//Atualiza SPC - Apontamento
					SPC->(RecLock('SPC', .F.))
					SPC->PC_ABONO   := cCPOSPC
					SPC->PC_QTABONO := nQtdSPC
					SPC->(MsUnLock())

					//Posiciona SPK - Abono
					cChaveSPK := (cAlsMix)->(PB7_FILIAL+PB7_MAT+PB7_DATA)+SPC->PC_PD

					SPK->(dbSetOrder(2)) //PK_FILIAL+PK_MAT+DTOS(PK_DATA)+PK_CODEVE+STR(PK_HORINI,5,2)+PK_CC
					if SPK->(dbseek(cChaveSPK)) 

						while SPK->(!EoF()) .And. cChaveSPK == SPK->(PK_FILIAL+PK_MAT+DTOS(PK_DATA)+PK_CODEVE)


							//Atualiza SPK - Abono
							SPK->(RecLock("SPK", .F.))
							SPK->PK_CODEVE := SPC->PC_PD
							SPK->PK_CODABO := SPC->PC_ABONO
							SPK->PK_HRSABO := SPC->PC_QTABONO          
							SPK->PK_HORINI := 0
							SPK->PK_HORFIM := 0				
							SPK->(MsUnLock())

							SPK->(dbSkip())  
						endDo
					Else
						if !Empty(cCPOSPC)    
							//Novo Registro SPK - Abono
							SPK->(RecLock("SPK", .T.))
							SPK->PK_FILIAL := SPC->PC_FILIAL
							SPK->PK_MAT    := SPC->PC_MAT
							SPK->PK_DATA   := SPC->PC_DATA
							SPK->PK_CODABO := SPC->PC_ABONO
							SPK->PK_HRSABO := SPC->PC_QTABONO          
							SPK->PK_HORINI := 0
							SPK->PK_HORFIM := 0				
							SPK->PK_CODEVE := SPC->PC_PD
							SPK->PK_CC     := SPC->PC_CC
							SPK->PK_FLAG   := 'I'
							SPK->(MsUnLock())
						endif
					endIf
				endIf
				SPC->( dbSkip() )
			endDo
		endIf

		(cAlsMix)->( dbSkip() ) 
	endDo

	Aviso("ATENNCAO!","Qtdes. processadas. Positivas.: "+AllTrim(Str(nRecPos))+" / Negativas.: "+AllTrim(Str(nRecNeg))+".",{"Ok"})

return