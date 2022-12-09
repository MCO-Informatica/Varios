#Include 'Protheus.ch'
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"
#Include 'tbiconn.ch'

Static cTipoTemp

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/12/2014 - 13:13:00
* @description: Relatorio comparativo de horas improdutivas/produtivas.
*/ 
User Function shmatr03()
	
	local aArea	   := getArea()
	
	private cTamanho := "G"
	private cTitulo  := "Relatório comparativo de horas improdutivas/produtivas."
	private cDesc1   := "Relacao  comparativo de horas improdutivas/produtivas."
	private cDesc2   := ""
	private cDesc3   := ""
	private cString  := "SH6"
	private aOrd     := {"Por OP","Por Recurso","Por Motivo","Por Data","Por Operador"}
	private wnrel    := "SHMATR03"
	//private cPerg	 := "MTR826" //Utilizando o mesmo grupo de perguntas do relatório SHMATR02.
	private cPerg	 := wnrel
	
	private oFont08		:= TFont():New("Calibri"		, 08,	8.5,, .F.,,,,, .F., .F.)
	private oFont10		:= TFont():New("Calibri"		, 09,	10,, .F.,,,,, .F., .F.)
	private oFont10N	:= TFont():New("Arial"			, 09,  9.9,, .T.,,,,, .F., .F.)
	private oFont11		:= TFont():New("Calibri"		, 09,	11,, .F.,,,,, .F., .F.)
	private oFont11N	:= TFont():New("Calibri"		, 09,	11,, .T.,,,,, .F., .F.)
	private oFont12A	:= TFont():New("Arial"			, 09,	12,, .F.,,,,, .F., .F.)
	private oFont12		:= TFont():New("Calibri"		, 09,	12,, .F.,,,,, .F., .F.)
	private oFont12S	:= TFont():New("Courier New"	, 09,	12,, .F.,,,,, .T., .F.) // Sublinhado
	private oFont12I	:= TFont():New("Courier New"	, 09,	12,, .F.,,,,, .F., .T.) // Itálico
	private oFont12N 	:= TFont():New("Calibri"		, 09,	12,, .T.,,,,, .F.,.F.)  // Negrito	              
	
	
	
	//Variaveis utilizadas para parametros                         
	// mv_par01     // De  OP										 
	// mv_par02     // Ate OP										
	// mv_par03     // De  Recurso                                  
	// mv_par04     // Ate Recurso                                  
	// mv_par05     // De  Motivo                                   
	// mv_par06     // Ate Motivo                                   
	// mv_par07     // De  Data                                     
	// mv_par08     // Ate Data	   
	// mv_par09     // De  Operador                                 
	// mv_par10   	// Ate Operador                                 
	
	criaSx1(cPerg)
	
	pergunte(cPerg,.F.)
	
	oReport := TReport():new(wnrel, cTitulo, cPerg, { || procRel() }, cDesc1)
	
	//oReport:lUserFilter := .T.		
	
	oReport:setLandscape() //oReport:setPortrait() 	
	 		
	oReport:setTitle(cTitulo)
	
	oReport:lDisableOrientation := .T. //Orientação (Retrato/Paisagem) não poderá ser modificada.
	
	//oReport:HideParamPage() //Desabilita a página com as perguntas (parâmetros).
			
	oReport:printDialog()
	
	If lastKey() == 27 
		return
	Endif
	
	
	restArea(aArea)
			
Return


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/12/2014 - 13:15:09
* @description: Layout do relatório 
*/ 
Static Function procRel()

	local cAlias	:= ""
	local cMes		:= ""
	local cAno		:= ""
	local nAnoDe	:= 0
	local nAnoAte	:= 0
	local nMesDe	:= 0
	local nMesAte	:= 0 
	local nHsProdut	:= 0 //Horas Produtivas
	local nHsImprod	:= 0 //Horas Improdutivas
	local nHrAbMeta := 0 //Horas abaixo da meta
	local nHsOcupada:= 0 //Horas ocupadas = horas produtivas - horas abaixo da meta
	local nHsPrevist:= 0 //Horas Previstas
	local nHsPerdida:= 0 //horas improdutivas - horas paradas programadas
	local nHsFull	:= 0 //Horas ocupadas + horas perdidas + paradas programadas
	local nHsDispPPR:= 0 //h.ocup + h.imp
	local nHsImprodu:= 0 //h.perd - h.n.prev.
	local aMotivos	:= {}
	local nProcura	:= 0
	local cHsProdut	:= ""
	local cHsImprod := ""
	local cHsPrevist:= ""
	local nColuna	:= 200  
	local nContador	:= 1 //contador de posição de impressão. Para verificar a coluna.
		
	local nX		:= 0
	
	local nxPos	:= 0
	local aXHoras	:= {}
	local i
	
	//Totalizadores da tabela ZRM - Resumo de Metas
	private nTotPP	:= 0
	private nTotHP	:= 0
	private nTotHM	:= 0
	private nTotOU	:= 0
	private nTotPR	:= 0
	private aZRM	:= {}
	
	//Cálculos das porcentagens
	private nPercOcup	:= 0
	private nPercPerd	:= 0
	private nPercProd	:= 0
	private nPercImp 	:= 0
	private nPercOcup2	:= 0
	private nPercAbaix	:= 0
	private nPercent 	:= 0
	private nPercHOcup	:= 0
	private nPercHPerd	:= 0
	private nPercPProg	:= 0
	private nMetaHora 	:= 0
	private cMaskPerc 	:= "@E 999999.999"
	private cMaskVal	:= "@E 9999.99"
	
	//Variáveis para o cálculo das diferenças de porcentagens
	private nAntHsFull	:= 0 
	private nAntHsOcup	:= 0
	private nAntHsPerd	:= 0
	private nAntTotPr	:= 0
	private nAntHsDisp	:= 0
	private nAntHsPPR	:= 0
	private nAntHsProd	:= 0
	private nAntHsImpr	:= 0
	
	private nDifHsFull	:= 0 
	private nDifHsOcup	:= 0
	private nDifHsPerd	:= 0
	private nDifTotPr	:= 0
	private nDifHsDisp	:= 0
	private nDifHsPPR	:= 0
	private nDifHsProd	:= 0
	private nDifHsImpr	:= 0
	
	private nPagina		:= 1 //Contador de páginas
		
	nMesDe := month(MV_PAR07)
	nMesAte:= month(MV_PAR08)
	nAnoDe := year(MV_PAR07)
	nAnoAte:= year(MV_PAR08)
	
	//Tratativa para utilizar o ano no for.
	if nAnoDe <> nAnoAte
		nMesAte += 12
	endIf 
	
	SG2->(DbSetOrder(1))
	
	oReport:StartPage()
	
	//Incluindo os registros na régua
	oReport:setMeter((nMesAte - nMesDe)*2)
	
	for nX := nMesDe to nMesAte
		
		//Zerando as variáveis
		nHsProdut 	:= 0
		nHsPrevist	:= 0
		nHsImprod 	:= 0
		aMotivos  	:= {}
		aZRM	  	:= {}
		nTotPP		:= 0
		nTotHP		:= 0
	 	nTotHM		:= 0
	 	nTotOU		:= 0
	 	nTotPR		:= 0
		nHrAbMeta	:= 0
		
		if nX <= 12
			cMes := allTrim(cValToChar(nX))
			cAno := allTrim(cValToChar(nAnoDe))
		else
			
			cAno := allTrim(cValToChar(nAnoAte))
			
			Do Case
			Case nX == 13
				cMes := "1"				
			Case nX == 14
				cMes := "2"				
			Case nX == 15
				cMes := "3"				
			Case nX == 16
				cMes := "4"				
			Case nX == 17
				cMes := "5"				
			Case nX == 18
				cMes := "6"				
			Case nX == 19
				cMes := "7"				
			Case nX == 20
				cMes := "8"				
			Case nX == 21
				cMes := "9"				
			Case nX == 22
				cMes := "10"				
			Case nX == 23
				cMes := "11"				
			Case nX == 24
				cMes := "12"															
			EndCase
			
		endIf
		
		cAlias := retDados(cMes,cAno)
		
		DbSelectArea("SH6")
		
		(cAlias)->(DbGoTop())
		
		//VARRENDO OS VALORES DE HORAS PRODUTIVAS, IMPRODUTIVAS E ABAIXO DA META DO MES E ANO SELECIONADOS.
		while !(cAlias)->(eof())
			
			SH6->(DbGoTo((cAlias)->RECNO))
		
			if allTrim(SH6->H6_TIPO) == 'P'
				nXHsProdut := Val(StrTran(R825Calc("0000:00"),':','.')) 
				nXHsPrevist:= R895Calc() 
				nHsProdut += Val(StrTran(R825Calc("0000:00"),':','.')) 
				nHsPrevist+= R895Calc() 
			elseIf allTrim(SH6->H6_TIPO) == 'I'
				nHsImprod += Val(StrTran(R825Calc("0000:00"),':','.'))
			endIf
			
			//Montando o array aMotivos para o calculo dos registros da tabela ZRM.
			if SH6->H6_TIPO == "I"
				nProcura := aScan(aMotivos,{|x| x[1] == H6_MOTIVO})
				if nProcura = 0
					AADD(aMotivos,{SH6->H6_MOTIVO,R825Calc("0000:00")})
				else
					aMotivos[nProcura,2]:=R825Calc(aMotivos[nProcura,2])
				endIf			
			endIf
			
			if allTrim(SH6->H6_TIPO) == 'P'
				nxPos := Ascan(aXHoras,{|x| x[1] = (SH6->H6_FILIAL + SH6->H6_OP) } )
				if nxPos > 0
					aXHoras[nxPos,2] += nXHsProdut
					aXHoras[nxPos,3] += nXHsPrevist
				else
					aadd(aXHoras,{SH6->H6_FILIAL + SH6->H6_OP,nXHsProdut,nXHsPrevist})
				endif
			endif
			
			(cAlias)->(DbSkip())
		end
		
		(cAlias)->(DbCloseArea())
		
		//Cálculo dos registros da tabela ZRM
		calcZRM(aMotivos)
		
		
		//Cálculos da hora abaixo da meta. Verifica se a hora prevista é maior que a hora produzida.
		/*if nHsPrevist < nHsProdut
			nHrAbMeta := nHsProdut - nHsPrevist
		endIf*/			
			
		
			
		
		for i := 1 to len(aXHoras)
			//Cálculos da hora abaixo da meta. Verifica se a hora prevista é maior que a hora produzida.
		
			if aXHoras[i,3] < aXHoras[i,2]
				nHrAbMeta += aXHoras[i,2] - aXHoras[i,3]
			endIf

			//ALERT("OP "+axHoras[i,1]+" PROD "+Str(axHoras[i,2])+" PREV "+Str(axHoras[i,3])+" HR AB META "+Str(nHrAbMeta))


		next
		
		
		//Horas ocupadas = Horas produtivas - horas abaixo da meta 
		nHsOcupada := nHsProdut //*- nHrAbMeta	
		nHsPerdida := nTotPP + nTotHP + nTotHM + nTotOU //*+ nHrAbMeta
								
		nHsFull    := nHsOcupada + nHsPerdida + nTotPR
		
		nHsDispPPR := nHsOcupada + (nHsPerdida - nTotOU)
		nHsImprodu := nHsPerdida - nTotOU
		
		//Cálculos das Porcentagens	
		nPercHOcup:= round(retPorcent(100, nHsFull, nHsOcupada),3) 		//Horas Ocupadas
		nPercHPerd:= round(retPorcent(100, nHsFull, nHsPerdida),3) 		//Horas Perdidas
		nPercPProg:= round(retPorcent(100, nHsFull, nTotPR),3) 		//Paradas Programadas
		
		nPercOcup := round(retPorcent(100, nHsOcupada + nHsPerdida, nHsOcupada),3) 		//Horas Ocupadas	
		nPercPerd := round(retPorcent(100, nHsOcupada + nHsPerdida, nHsPerdida),3) 		//Horas Perdidas	 
		
		nPercOcup2:= round(retPorcent(100, nHsOcupada + (nHsPerdida - nTotOU), nHsOcupada),3) 		//Horas Ocupadas(h.prod. - prd. ab. meta)
		nPercImp  := round(retPorcent(100, nHsOcupada + (nHsPerdida - nTotOU), nHsPerdida - nTotOU),3) 		//Horas Improdutivas(h.perd - h.n prev.)	
				
		oReport:incMeter()	
		nHrAbMeta := 0
		
		//Desenhando o layout da tela
		layout(oReport,val(allTrim(cMes)),nHsProdut,nHsImprod,nHrAbMeta,nHsFull,nHsOcupada,nHsPerdida,nTotPR,nColuna,nContador,nHsDispPPR,nHsImprodu)
		
		//(cAlias)->(DbCloseArea())
		
		nContador	+= 1 //Contador de coluna, para controlar o layout da impressão.

		if nContador < 3 .AND. nPagina == 1
			nColuna 	+= 370
		elseIf nContador < 3 .AND. nPagina == 2
			nColuna 	+= 480
		else
			nColuna 	+= 450 
		endIf
		
		//Quebra de página a cada seis registros impressos.
		if nContador > 6
			oReport:EndPage()
			nContador := 1
			nColuna	:= 200	
			nPagina++		
		endIf
	
		oReport:incMeter()
		
	next nX 
	
	oReport:EndPage()
	
	//Impressão do relatório detalhado.
	nContador 	:= 1
	nColuna		:= 200	
	nPagina 	:= 1
		
	layoutZRM(nMesDe,nMesAte,nAnoDe,nAnoAte)
		
	oReport:EndPage() 
	
return


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 30/12/2014 - 11:51:21
* @description: Layout do relatório detalhado. 
*/ 
static function layoutZRM(nMesDe,nMesAte,nAnoDe,nAnoAte)
	
	local cDescri	:= ""
	local cMes 		:= ""
	
	local nHsProdut	:= 0
	local nHsPrevist:= 0 
	local nHsImprod	:= 0
	
	local nX		:= 0
	local nB		:= 1
	local nR		:= 0
	local nY		:= 0
	
	private aDados		:= {}
	private aTmp		:= {}
	private aTopoDados	:= {}
	private nTopAbMeta	:= 0
	private nTopo		:= 0
	private nTopoTmp	:= 0
	private nTmp		:= 0
	private nDados		:= 0
	
	aZRM	  		:= {}
	nTotPP			:= 0
	nTotHP			:= 0
	nTotHM			:= 0
	nTotOU			:= 0
	nTotPR			:= 0
	
	//Zerando as variáveis
	aMotivos  	:= {}
				
	for nX := nMesDe to nMesAte
		
		if nX <= 12
			cMes := allTrim(cValToChar(nX))
			cAno := allTrim(cValToChar(nAnoDe))
		else
			
			cAno := allTrim(cValToChar(nAnoAte))
			
			Do Case
			Case nX == 13
				cMes := "1"				
			Case nX == 14
				cMes := "2"				
			Case nX == 15
				cMes := "3"				
			Case nX == 16
				cMes := "4"				
			Case nX == 17
				cMes := "5"				
			Case nX == 18
				cMes := "6"				
			Case nX == 19
				cMes := "7"				
			Case nX == 20
				cMes := "8"				
			Case nX == 21
				cMes := "9"				
			Case nX == 22
				cMes := "10"				
			Case nX == 23
				cMes := "11"				
			Case nX == 24
				cMes := "12"															
			EndCase
			
		endIf
		
		cAlias := retDados(cMes,cAno)
		
		DbSelectArea("SH6")
		
		(cAlias)->(DbGoTop())
		
		//VARRENDO OS VALORES DE HORAS PRODUTIVAS, IMPRODUTIVAS E ABAIXO DA META DO MES E ANO SELECIONADOS.
		while !(cAlias)->(eof())
			
			SH6->(DbGoTo((cAlias)->RECNO))
			
			//Montando o array aMotivos para o calculo dos registros da tabela ZRM.
			if SH6->H6_TIPO == "I"
				nProcura := aScan(aMotivos,{|x| x[1] == H6_MOTIVO})
				if nProcura = 0
					AADD(aMotivos,{SH6->H6_MOTIVO,R825Calc("0000:00")})
				else
					aMotivos[nProcura,2]:=R825Calc(aMotivos[nProcura,2])
				endIf			
			endIf
			
			(cAlias)->(DbSkip())
		end
		
		(cAlias)->(DbCloseArea())
					
	next nX
	
	//Não se houver nenhum motivo, não printa o relatório detalhado.
	if len(aMotivos) == 0
		return
	endIf
	//Verificando todos os motivos
	calcZRM(aMotivos)
	
	//ordenando o vetor para impressao na tela - Todos os dados detalhados improdutivos.
	aZRM := aSort(aZrm, , , {|x,y| x[5] < y[5] })

	nZRM := len(aZRM)
	
	//cTipo 	:= iif(nZRM > 0 ,aZRM[1][1],"")
	
	//Varrendo o ZRM para montar o array com as descrições e os dados.
	while nB <= nZRM
		
		cDescri := posicione("SX5",1,xFilial("SX5")+"ZZ"+aZRM[nB][1],"X5_DESCRI")
		
		cTipo 	:= aZRM[nB][1]
				
		while aZRM[nB][1] == cTipo
			
			cTipo := aZRM[nB][1]
						
			aaDD(aTmp,{aZRM[nB][1],aZRM[nB][2],aZRM[nB][3]})  
			
			nB++
			
			if nB > nZRM	 		
				exit	
			endIf
		end
		
		//Primeira posição recebe o título do grupo.Na segunda posição fica o total do grupo. Na terceira posição vem um array com os itens do grupo.
		aadd(aDados, {"GRUPO|"+cDescri,aTmp}) 
		
		aTmp := {}
		
	end 
	
	//Ajustando o array aDados para ter cada registro em um linha, para poder comparar com os registros
	// mes a mes do array aZRM (comparar com os valores de mes a mes).
	aTmp := aClone(aDados)
	nTmp := len(aTmp)
	
	aDados := {}
		
	for nX:=1 to nTmp
		
		aadd(aDados,{allTrim(aTmp[nX][1]),allTrim(aTmp[nX][2][1][1])})
		
		for nY:=1 to len(aTmp[nX][2])
			aadd(aDados,{allTrim(aTmp[nX][2][nY][1]),allTrim(aTmp[nX][2][nY][2]),allTrim(aTmp[nX][2][nY][3])})
		next nY
		
	next nX  
	
	nDados := len(aDados)
	
	//TÍTULOS 'FIXOS'
	printTitul()
	
	nTopo := nTopoTmp 
	
	//CÁLCULO DOS VALORES - VARRENDO MÊS A MÊS
	printValor(nMesDe,nMesAte,nAnoDe,nAnoAte)
			
return	

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 01/01/2015 - 19:45:16
* @description: Printa as informações 'fixas', referentes aos títulos. 
*/ 
static function printTitul()
	
	local nCol		:= 050
	local nR		:= 0
	local aHoraPP	:= {}
	
	nTopo	:= 400
	nDados	:= len(aDados)
	
	//IMPRESSAO DAS INFORMAÇÕES "FIXAS (Títulos)"
	
	oReport:Line(nTopo, 0020, nTopo, 3270)
	
	nTopo += 50
	
	nTopoTmp := nTopo
		
	oReport:Say(nTopo 	, 0040, "HORAS PERDIDAS"								,oFont08,100,,,0)
	
	nTopo += 50 
		
	oReport:Line(nTopo, 0020, nTopo, 3270)

	nTopo += 30
	
	for nR:=1 to nDados
				
		nTitulo := rat("GRUPO|",aDados[nR][1])
		nItemPR	:= rat("PR",aDados[nR][1])
				
		if nTitulo > 0 .and. aDados[nR][1]<> "GRUPO|HORAS PARADAS PROGRAMADAS"
			oReport:Say(nTopo, nCol	, subStr(aDados[nR][1],rat("|",aDados[nR][1])+1,len(aDados[nR][1]))			,oFont08,100,,,0)	
			aadd(aTopoDados,nTopo)
			nTopo+=40
			
		//Imprime os itens que não são do grupo HORAS PARADAS PROGRAMADAS					
		elseIf nItemPR == 0
			oReport:Say(nTopo, nCol	+ 100, aDados[nR][2] +"  "+ subsTr(aDados[nR][3],1,28) 						,oFont08,100,,,0)
			aadd(aTopoDados,nTopo)	
			nTopo+=40
		else
			aadd(aHoraPP,aDados[nR])				
		endIf	
		
		//HORAS ABAIXO DA META - GRUPO PERCAS PRODUCAO
		if nR <> nDados
			if (aDados[nR][1] == "PP" .and. aDados[nR+1][1] <> "PP") 
				oReport:Say(nTopo, nCol	+ 100, "HORAS ABAIXO DA META"											,oFont08,100,,,0)
				nTopAbMeta := nTopo
				nTopo+=40				
			endIf
		else 
			if (aDados[nR][1] == "PP")
				oReport:Say(nTopo, nCol	+ 100, "HORAS ABAIXO DA META"											,oFont08,100,,,0)
				nTopAbMeta := nTopo
				nTopo+=40
			endIf	
		endIf
				
	next nR
	
	//HORAS PARADAS PROGRAMACAO
	nTopo += 40 
	oReport:Line(nTopo, 0020, nTopo, 3270)
	nTopo += 50
	
	for nR:=1 to len(aHoraPP)  
				
		nTitulo := rat("GRUPO|",aHoraPP[nR][1])
		//nItemPR	:= rat("PR",aHoraPP[nR][1])
				
		if nTitulo > 0 
			oReport:Say(nTopo, 040	, subStr(aHoraPP[nR][1],rat("|",aHoraPP[nR][1])+1,len(aHoraPP[nR][1]))		,oFont08,100,,,0)	
			aadd(aTopoDados,nTopo)
			nTopo += 50 
			oReport:Line(nTopo, 0020, nTopo, 3270)
			nTopo +=30
			
		//Imprime os itens que não são do grupo HORAS PARADAS PROGRAMADAS					
		else
			oReport:Say(nTopo, nCol	+ 100, aHoraPP[nR][2] +"  "+ aHoraPP[nR][3] 									,oFont08,100,,,0)	
			aadd(aTopoDados,nTopo)
			nTopo+=40
		endIf	
	
	next nR
	
return


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 31/12/2014 - 16:06:19
* @description: Calculando os valores mês a mês, e printando as informações. 
*/ 
static function printValor(nMesDe,nMesAte,nAnoDe,nAnoAte)
	
	local cMes		:= ""
	local cAno		:= ""	
	local nHsProdut := 0
	local nHsPrevist:= 0
	local nHsImprod := 0
	local nDiferenca:= 0
	local nProcura	:= 0
	local nAntAbMeta:= 0	
	local aMotivos  := {}
	local aValorAnt	:= {} 
	local nPagina	:= 1
	local nContador := 0
	local nPorcent	:= 0
	local nPorcentAM:= 0 //Porcentagem abaixo da meta
	local cMaskPerc	:= "@E 99999.999" 
	local nAntHPerdi:= 0 
	
	local nX		:= 0
	local nY		:= 0
	local nB		:= 0 
		
	local nxPos	:= 0
	local aXHoras	:= {}
	local i
	
	
	nCol := 0450
	
	aValorAnt := array(nDados)
	
	for nB:=1 to len(aValorAnt)
		aValorAnt[nB] := 0
	next nB
	
	for nX := nMesDe to nMesAte
		
		aMotivos 	:= {}
		nHsProdut 	:= 0 
		nHsPrevist	:= 0 
		nHsImprod 	:= 0
				
		if nX <= 12
			cMes := allTrim(cValToChar(nX))
			cAno := allTrim(cValToChar(nAnoDe))
		else
			
			cAno := allTrim(cValToChar(nAnoAte))
			
			Do Case
			Case nX == 13
				cMes := "1"				
			Case nX == 14
				cMes := "2"				
			Case nX == 15
				cMes := "3"				
			Case nX == 16
				cMes := "4"				
			Case nX == 17
				cMes := "5"				
			Case nX == 18
				cMes := "6"				
			Case nX == 19
				cMes := "7"				
			Case nX == 20
				cMes := "8"				
			Case nX == 21
				cMes := "9"				
			Case nX == 22
				cMes := "10"				
			Case nX == 23
				cMes := "11"				
			Case nX == 24
				cMes := "12"															
			EndCase
			
		endIf
		
		cAlias := retDados(cMes,cAno)
		
		DbSelectArea("SH6")
		
		(cAlias)->(DbGoTop())
		
		//VARRENDO OS VALORES DE HORAS PRODUTIVAS, IMPRODUTIVAS E ABAIXO DA META DO MES E ANO SELECIONADOS.
		while !(cAlias)->(eof())
			
			SH6->(DbGoTo((cAlias)->RECNO))
			
			if allTrim(SH6->H6_TIPO) == 'P'
				nHsProdut += Val(StrTran(R825Calc("0000:00"),':','.')) 
				nHsPrevist+= R895Calc() 
				nXHsProdut := Val(StrTran(R825Calc("0000:00"),':','.')) 
				nXHsPrevist:= R895Calc() 
			elseIf allTrim(SH6->H6_TIPO) == 'I'
				nHsImprod += Val(StrTran(R825Calc("0000:00"),':','.'))
			endIf
					
			//Montando o array aMotivos para o calculo dos registros da tabela ZRM.
			if SH6->H6_TIPO == "I"
				nProcura := aScan(aMotivos,{|x| x[1] == H6_MOTIVO})
				if nProcura = 0
					AADD(aMotivos,{SH6->H6_MOTIVO,R825Calc("0000:00")})
				else
					aMotivos[nProcura,2]:=R825Calc(aMotivos[nProcura,2])
				endIf			
			endIf
			
			if allTrim(SH6->H6_TIPO) == 'P'
				nxPos := Ascan(aXHoras,{|x| x[1] = (SH6->H6_FILIAL + SH6->H6_OP) } )
				if nxPos > 0
					aXHoras[nxPos,2] += nXHsProdut
					aXHoras[nxPos,3] += nXHsPrevist
				else
					aadd(aXHoras,{SH6->H6_FILIAL + SH6->H6_OP,nXHsProdut,nXHsPrevist})
				endif
			endif
			
			(cAlias)->(DbSkip())
		end
		
		(cAlias)->(DbCloseArea())
		
		//Verificando todos os motivos
		aZRM 		:= {}
		nTotPP		:= 0
		nTotHP		:= 0 
		nTotHM		:= 0 
		nTotOU		:= 0
		nTotPR		:= 0
		nHrAbMeta	:= 0
		
		calcZRM(aMotivos)
		
		//ordenando o vetor para impressao na tela - Todos os dados detalhados improdutivos.
		aZRM := aSort(aZrm, , , {|x,y| x[5] < y[5] })

		//Cálculos da hora abaixo da meta. Verifica se a hora prevista é maior que a hora produzida.
		/*if nHsPrevist < nHsProdut
			nHrAbMeta := nHsProdut - nHsPrevist
		endIf*/
		
		nHrAbMeta :=0
		/*
		for i := 1 to len(aXHoras)
			//Cálculos da hora abaixo da meta. Verifica se a hora prevista é maior que a hora produzida.
			if aXHoras[i,3] < aXHoras[i,2]
				nHrAbMeta += aXHoras[i,2] - aXHoras[i,3]
			endIf
		next
		*/
		nHsPerdida := nTotPP + nTotHP + nTotHM + nTotOU// + nHrAbMeta
				
		//Veriricando o mês para printar a Descrição.
		Do Case
		Case val(cMes) == 1
			cMes := "JANEIRO"	
		Case val(cMes) == 2
			cMes := "FEVEREIRO"	
		Case val(cMes) == 3
			cMes := "MARÇO"	
		Case val(cMes) == 4
			cMes := "ABRIL"	
		Case val(cMes) == 5
			cMes := "MAIO"	
		Case val(cMes) == 6
			cMes := "JUNHO"	
		Case val(cMes) == 7
			cMes := "JULHO"	
		Case val(cMes) == 8
			cMes := "AGOSTO"	
		Case val(cMes) == 9
			cMes := "SETEMBRO"	
		Case val(cMes) == 10
			cMes := "OUTUBRO"	
		Case val(cMes) == 11
			cMes := "NOVEMBRO"	
		Case val(cMes) == 12
			cMes := "DEZEMBRO"		
		EndCase
		
		if nContador > 0
			oReport:Say(nTopoTmp - 200			, nCol+140	, cMes													,oFont10,100,,,0)
		else
			oReport:Say(nTopoTmp - 200			, nCol+100	, cMes													,oFont10,100,,,0)
		endIF
		oReport:Say(nTopoTmp - 100			, nCol+230	, "Porcent(%)"											,oFont08,100,,,0)
		
		if nContador > 0 .or. nPagina > 1
			oReport:Say(nTopoTmp - 100			, nCol+355	, "Dif.(%)"											,oFont08,100,,,0)
		endIf
		
		//APÓS CÁLCULO DOS VALORES DO MÊS, VARRER O ARRAY ADADOS, PARA PRINTAR AS INFORMAÇÕES.				
		for nY:=1 to nDados
			
			//HORAS PERDIDAS
			if nY == 1				
				oReport:Say(nTopoTmp 		, nCol+50	, StrTran(transfor(nHsPerdida	,cMaskVal),',',':')		,oFont08,100,,,0)
				//PERCENTUAL DE 100% PARA HORAS PERDIDAS
				oReport:Say(nTopoTmp	 	, nCol + 240, transfor(100			,cMaskPerc)						,oFont08,100,,,0)
				
				//Diferença de porcentagem entre os meses
				if nX <> nMesDe
					nDiferenca := nHsPerdida - nAntHPerdi
					if nAntHPerdi == 0
						nDiferenca := round( (nHsPerdida * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, nAntHPerdi, nDiferenca),3)
					endIf
					oReport:Say(nTopoTmp 	, nCol+355	, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)							
				endIf	
				
				nAntHPerdi := nHsPerdida
													
			endIf
					
			nTitulo := rat("GRUPO|",aDados[nY][1])
			//Printando os itens
			if nTitulo > 0
											
				if aDados[nY][2]  = "PP"					
					nTotPP += nHrAbMeta //Somando as horas extraviadas
					oReport:Say(aTopoDados[nY] 	, nCol+50, StrTran(transfor(nTotPP,cMaskVal),',',':')			,oFont08,100,,,0)

					//Diferença de porcentagem entre os meses				
					nDiferenca := nTotPP - aValorAnt[nY]
					if aValorAnt[nY] == 0
						nDiferenca := round( (nTotPP * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
				 
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					//if nContador > 0 .and. nPagina > 1
					if nContador > 0 .or. nPagina > 1
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)					,oFont08,100,,,0)
					endIf
					aValorAnt[nY] := nTotPP										
				elseIf aDados[nY][2] == "HP"
					oReport:Say(aTopoDados[nY] 	, nCol+50, StrTran(transfor(nTotHP,cMaskVal),',',':')			,oFont08,100,,,0)
					
					//Diferença de porcentagem entre os meses					
					nDiferenca := nTotHP - aValorAnt[nY]
					if aValorAnt[nY] == 0
						nDiferenca := round( (nTotHP * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
					 
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1	
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf
					aValorAnt[nY] := nTotHP							
				elseIf aDados[nY][2] == "HM"
					oReport:Say(aTopoDados[nY] 	, nCol+50, StrTran(transfor(nTotHM,cMaskVal),',',':')				,oFont08,100,,,0)
					
					//Diferença de porcentagem entre os meses					
					nDiferenca := nTotHM - aValorAnt[nY]
					if aValorAnt[nY] == 0
						nDiferenca := round( (nTotHM * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
					 
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf
					aValorAnt[nY] := nTotHM							
				elseIf aDados[nY][2] == "OU"
					oReport:Say(aTopoDados[nY] 	, nCol+50, StrTran(transfor(nTotOU,cMaskVal),',',':')				,oFont08,100,,,0)
					
					//Diferença de porcentagem entre os meses
					nDiferenca := nTotOU - aValorAnt[nY]
					if aValorAnt[nY] == 0
						nDiferenca := round( (nTotOU * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
									
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf
					
					aValorAnt[nY] := nTotOU		
				elseIf aDados[nY][2] == "PR"
					oReport:Say(aTopoDados[nY] 	, nCol+50, StrTran(transfor(nTotPR,cMaskVal),',',':')				,oFont08,100,,,0)	
					oReport:Say(aTopoDados[nY] 	, nCol + 240, transfor(100,cMaskPerc)								,oFont08,100,,,0)
					
					//Diferença de porcentagem entre os meses					
					nDiferenca := nTotPR - aValorAnt[nY]
					if aValorAnt[nY] == 0
						nDiferenca := round( (nTotPR * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
					 
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf
					aValorAnt[nY] := nTotPR					
				endIf
			else
				//Printando os subItens
				nPosValor := aScan(aZRM,{|x| AllTrim(x[2]) == aDados[nY][2]})
				if nPosValor > 0
					oReport:Say(aTopoDados[nY] 	, nCol+140, StrTran(transfor(aZRM[nPosValor][4]	,cMaskVal),',',':')	,oFont08,100,,,0)
					if aZRM[nPosValor][1] <> "PR"
						nPorcent := round(retPorcent(100, nHsPerdida, aZRM[nPosValor][4]),3)
						
						//Diferença de porcentagem entre os meses
						nDiferenca := aZRM[nPosValor][4] - aValorAnt[nY]
						if aValorAnt[nY] == 0
							nDiferenca := round( (aZRM[nPosValor][4] * 100) ,3)
						else
							nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
						endIf	
												
						aValorAnt[nY] := aZRM[nPosValor][4]
					else
						nPorcent := round(retPorcent(100, nTotPR, aZRM[nPosValor][4]),3)
						
						//Diferença de porcentagem entre os meses						
						nDiferenca := aZRM[nPosValor][4] - aValorAnt[nY]
						if aValorAnt[nY] == 0
							nDiferenca := round( (nTotPR * 100) ,3)
						else
							nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
						endIf	
												
						aValorAnt[nY] := nTotPR
					endIf
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf	
				else
					oReport:Say(aTopoDados[nY] 	, nCol+140, StrTran(transfor(0					,cMaskVal),',',':')	,oFont08,100,,,0)
					nPorcent := round(retPorcent(100, nHsPerdida, 0),3)
					
					//Diferença de porcentagem entre os meses
					nDiferenca := 0
					if aValorAnt[nY] == 0
						nDiferenca := round( (0 * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, aValorAnt[nY], nDiferenca),3)
					endIf	
					
					//NO PRIMEIRO MÊS NÃO PRINTA A DIFERENÇA DE PORCENTAGEM
					if nContador > 0 .or. nPagina > 1 
						oReport:Say(aTopoDados[nY] 	, nCol+355, transfor(nDiferenca,cMaskPerc)						,oFont08,100,,,0)
					endIf	
					
					aValorAnt[nY] := 0
						
				endIf						
				
			endIf			
			
			//HORAS ABAIXO DA META - GRUPO PERCAS PRODUCAO
			if nY <> nDados
				if (aDados[nY][1] == "PP" .and. aDados[nY+1][1] <> "PP") 
					oReport:Say(nTopAbMeta, nCol	+ 140, StrTran(transfor(nHrAbMeta	,cMaskVal),',',':')			,oFont08,100,,,0)
					nPorcentAM:= round(retPorcent(100, nHsPerdida, nHrAbMeta),3)
					
					//Diferença de porcentagem entre os meses
					nDiferenca := nHrAbMeta - nAntAbMeta
					if nAntAbMeta == 0
						nDiferenca := round( (nHrAbMeta * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, nAntAbMeta, nDiferenca),3)
					endIf
					
					if nContador > 0 .or. nPagina > 1
						oReport:Say(nTopAbMeta 	, nCol+355, transfor(nDiferenca,cMaskPerc)							,oFont08,100,,,0)
					endIf
										
					nAntAbMeta:= nHrAbMeta					
				endIf
			else 
				if (aDados[nY][1] == "PP")
					oReport:Say(nTopAbMeta, nCol	+ 140, StrTran(transfor(nHrAbMeta	,cMaskVal),',',':')			,oFont08,100,,,0)
					nPorcentAM:= round(retPorcent(100, nHsPerdida, nHrAbMeta),3)
					
					//Diferença de porcentagem entre os meses
					nDiferenca := nHrAbMeta - nAntAbMeta
					if nAntAbMeta == 0
						nDiferenca := round( (nHrAbMeta * 100) ,3)
					else
						nDiferenca := round(retPorcent(100, nAntAbMeta, nDiferenca),3)
					endIf
					
					if nContador > 0 .or. nPagina > 1
						oReport:Say(nTopAbMeta 	, nCol+355, transfor(nDiferenca,cMaskPerc)							,oFont08,100,,,0)
					endIf
										
					nAntAbMeta:= nHrAbMeta															
				endIf	
			endIf
			
			//PRINTANDO A PORCENTAGEM CALCULADA
			//Verificando se não é a porcentagem das Horas Abaixo da Meta, para printar a informação na linha correta.
			if nY <> nDados .and. nTitulo == 0
				if (aDados[nY][1] == "PP" .and. aDados[nY+1][1] <> "PP") 
					oReport:Say(aTopoDados[nY] 	, nCol + 240, transfor(nPorcent	,cMaskPerc)						,oFont08,100,,,0)
					oReport:Say(nTopAbMeta 	, nCol + 240, transfor(nPorcentAM	,cMaskPerc)						,oFont08,100,,,0)
				else
					oReport:Say(aTopoDados[nY] 	, nCol + 240, transfor(nPorcent	,cMaskPerc)						,oFont08,100,,,0)		
				endIf
			elseIf nTitulo == 0 
				if (aDados[nY][1] == "PP")
					oReport:Say(aTopoDados[nY] 	, nCol + 240, transfor(nPorcent	,cMaskPerc)						,oFont08,100,,,0)
					oReport:Say(nTopAbMeta 		, nCol + 240, transfor(nPorcentAM	,cMaskPerc)					,oFont08,100,,,0)
				else
					oReport:Say(aTopoDados[nY] 	, nCol + 240, transfor(nPorcent	,cMaskPerc)						,oFont08,100,,,0)															
				endIf	
			endIf		
			
		next nY
		
		//Contador da quantidade de meses impressos.
		nContador++
				
		//LINHA VERTICAL - DIVISAO ENTRE OS MESES
		if nPagina > 1
			//oReport:Line(nTopo - 60 , nCol+340, nTopo+ 1060,  nCol+340)
			if nContador < 6
				oReport:Line(nTopo - 220 	, nCol+470, aTopoDados[len(aTopoDados)]+50,  nCol+470)
			endIf				
		else
			if nContador == 1
				oReport:Line(nTopo - 220, nCol+360, aTopoDados[len(aTopoDados)]+50,  nCol+360)
			elseIf nContador < 6  
				oReport:Line(nTopo - 220, nCol+470, aTopoDados[len(aTopoDados)]+50,  nCol+470)
			endIf	
		endIf 
		
		if nContador == 1 .and. nPagina == 1
			nCol += 375
		else
			//nCol += 495
			nCol += 440
		endIf
		
		if nContador == 6 .and. nPagina == 1
			oReport:EndPage()
			printTitul()
			nTopo := nTopoTmp 
			nContador	:= 0
			nCol		:= 560
			nPagina++		
		endIf
	
		//Incluindo registros na regua de progressao
		oReport:incMeter()
					
	next nX
	
return	

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 26/12/2014 - 10:39:35
* @description: Montagem do layout em TMSPrinter. 
*/ 
static function layout(oReport,nMes,nHsProdut,nHsImprod,nHrAbMeta,nHsFull,nHsOcupada,nHsPerdida,nTotPR,nCol,nContador,nHsDispPPR,nHsImprodu)
	
	local nTopo		:= 200
	local cMes 		:= ""
	local nTotHsDisp:= 0
	
	Do Case
	Case nMes == 1
		cMes := "JANEIRO"	
	Case nMes == 2
		cMes := "FEVEREIRO"	
	Case nMes == 3
		cMes := "MARÇO"	
	Case nMes == 4
		cMes := "ABRIL"	
	Case nMes == 5
		cMes := "MAIO"	
	Case nMes == 6
		cMes := "JUNHO"	
	Case nMes == 7
		cMes := "JULHO"	
	Case nMes == 8
		cMes := "AGOSTO"	
	Case nMes == 9
		cMes := "SETEMBRO"	
	Case nMes == 10
		cMes := "OUTUBRO"	
	Case nMes == 11
		cMes := "NOVEMBRO"	
	Case nMes == 12
		cMes := "DEZEMBRO"		
	EndCase
	
	nTotHsDisp := nHsOcupada + nHsPerdida
			
	if nContador == 1 .AND. nPagina == 1
		
		if cMes <> 	"FEVEREIRO"		
			oReport:Say(nTopo + 0040, nCol+480, cMes									,oFont10N,,0,,0)
		else
			oReport:Say(nTopo + 0040, nCol+490, cMes									,oFont10N,,0,,0)
		endIf
		
		nTopo += 100
		
		oReport:Say(nTopo + 0020, nCol+0500,"Porcent(%)"							,oFont08,,0,,0)
								
		oReport:Line(nTopo + 0080, 0020, nTopo + 0080, 3270)
		
		oReport:Say(nTopo + 0120, 0040, "TOTAL HORAS FULL"							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0160, 0020, nTopo + 0160, 3270)
		
		oReport:Say(nTopo + 0200, 0040, "Horas Ocupadas"							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0240, 0040, "Horas Perdidas"							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0280, 0040, "Paradas Programadas"						,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0350, 0020, nTopo+ 0350,  3270)
		
		oReport:Say(nTopo + 0380, 0040, "TOTAL HORAS DISPONÍVEL"					,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0440, 0020, nTopo+ 0440,  3270)
		
		oReport:Say(nTopo + 0480, 0040, "Horas Ocupadas "							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0520, 0040, "Horas Perdidas "							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0590, 0020, nTopo+ 0590,  3270)
		
		oReport:Say(nTopo + 0620, 0040, "HORAS DISPONÍVEIS PPR (h.ocup. + h.imp.)"	,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0680, 0020, nTopo+ 0680,  3270)
		
		oReport:Say(nTopo + 0720, 0040, "Horas Produtivas (Trabalhadas)"			,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0760, 0040, "Horas Ocupadas(h.prod. - prd. ab. meta)"	,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0800, 0040, "Horas Improdutivas(h.perd - h.n prev.)"	,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0870, 0020, nTopo+ 0870,  3270)
		
		oReport:Say(nTopo + 0900, 0040, "HORAS PERDIDAS"							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0970, 0020, nTopo+ 0970,  3270)
		
		oReport:Say(nTopo + 1000, 0040, "HORAS PARADAS PROGRAMADA"					,oFont08,100,,,0)
		
		oReport:Line(nTopo + 1060, 0020, nTopo+ 1060,  3270)
	
	elseIf nContador == 1 .AND. nPagina > 1
		
		if cMes <> 	"FEVEREIRO"		
			oReport:Say(nTopo + 0040, nCol+480, cMes									,oFont10N,,0,,0)
		else
			oReport:Say(nTopo + 0040, nCol+490, cMes									,oFont10N,,0,,0)
		endIf
				
		nTopo += 100
		
		oReport:Say(nTopo + 0020, nCol+0480,"Porcent(%)"							,oFont08,,0,,0)
								
		oReport:Line(nTopo + 0080, 0020, nTopo + 0080, 3270)
		
		oReport:Say(nTopo + 0120, 0040, "TOTAL HORAS FULL"							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0160, 0020, nTopo + 0160, 3270)
		
		oReport:Say(nTopo + 0200, 0040, "Horas Ocupadas"							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0240, 0040, "Horas Perdidas"							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0280, 0040, "Paradas Programadas"						,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0350, 0020, nTopo+ 0350,  3270)
		
		oReport:Say(nTopo + 0380, 0040, "TOTAL HORAS DISPONÍVEL"					,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0440, 0020, nTopo+ 0440,  3270)
		
		oReport:Say(nTopo + 0480, 0040, "Horas Ocupadas "							,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0520, 0040, "Horas Perdidas "							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0590, 0020, nTopo+ 0590,  3270)
		
		oReport:Say(nTopo + 0620, 0040, "HORAS DISPONÍVEIS PPR (h.ocup. + h.imp.)"	,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0680, 0020, nTopo+ 0680,  3270)
		
		oReport:Say(nTopo + 0720, 0040, "Horas Produtivas (Trabalhadas)"			,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0760, 0040, "Horas Ocupadas(h.prod. - prd. ab. meta)"	,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0800, 0040, "Horas Improdutivas(h.perd - h.n prev.)"	,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0870, 0020, nTopo+ 0870,  3270)
		
		oReport:Say(nTopo + 0900, 0040, "HORAS PERDIDAS"							,oFont08,100,,,0)
		
		oReport:Line(nTopo + 0970, 0020, nTopo+ 0970,  3270)
		
		oReport:Say(nTopo + 1000, 0040, "HORAS PARADAS PROGRAMADA"					,oFont08,100,,,0)
		
		oReport:Say(nTopo + 0020, nCol+0630,"Dif. (%)"								,oFont08,,0,,0)
		
		//Cálculo da diferença da porcentagem entre os meses.
		//HORAS FULL
		nDifHsFull := nHsFull - nAntHsFull
		if nAntHsFull == 0
			nDifHsFull := round( (nHsFull * 100) ,3)
		else
			nDifHsFull := round(retPorcent(100, nAntHsFull, nDifHsFull),3) 		
		endIf
		//Horas Ocupadas
		nDifHsOcup := nHsOcupada -	nAntHsOcup
		if nAntHsOcup == 0
			nDifHsOcup := round( (nDifHsOcup * 100) ,3)
		else
			nDifHsOcup := round(retPorcent(100, nAntHsOcup, nDifHsOcup),3)
		endIf
		
		//Horas Perdidas
		nDifHsPerd := nHsPerdida - nAntHsPerd
		if nAntHsPerd == 0
			nDifHsPerd := round( (nDifHsPerd * 100) ,3)
		else
			nDifHsPerd := round(retPorcent(100, nAntHsPerd, nDifHsPerd),3)
		endIf
		
		//Paradas Programadas
		nDifTotPr := nTotPR - nAntTotPr
		if nAntTotPr == 0
			nDifTotPr := round( (nDifTotPr * 100) ,3)
		else
			nDifTotPr := round(retPorcent(100, nAntTotPr, nDifTotPr),3)
		endIf
		//HORAS DISPONIVEL 
		nDifHsDisp := nTotHsDisp - nAntHsDisp
		if nAntHsDisp == 0
			nDifHsDisp := round( (nDifHsDisp * 100) ,3)
		else
			nDifHsDisp := round(retPorcent(100, nAntHsDisp, nDifHsDisp),3)
		endIf
		
		//HORAS DISPONIVEL PPR
		nDifHsPPR  := nHsDispPPR - nAntHsPPR
		if nAntHsPPR == 0
			nDifHsPPR := round( (nDifHsPPR * 100) ,3)
		else
			nDifHsPPR := round(retPorcent(100, nAntHsPPR, nDifHsPPR),3)
		endIf
		
		//Horas Produtivas
		nDifHsProd := nHsProdut - nAntHsProd
		if nAntHsProd == 0
			nDifHsProd := round( (nDifHsProd * 100) ,3)
		else
			nDifHsProd := round(retPorcent(100, nAntHsProd, nDifHsProd),3)
		endIf
		
		//Horas Improdutivas
		nDifHsImpr := nHsImprodu - nAntHsImpr
		if nAntHsImpr == 0
			nDifHsImpr := round( (nDifHsImpr * 100) ,3)
		else
			nDifHsImpr := round(retPorcent(100, nAntHsImpr, nDifHsImpr),3)
		endIf
		
		//Printando as informações dos percentuais de diferença entre os meses.
		oReport:Say(nTopo + 0120, nCol + 0630, transfor(nDifHsFull,cMaskPerc)								,oFont08,100,,,0)		
		oReport:Say(nTopo + 0200, nCol + 0630, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0240, nCol + 0630, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0280, nCol + 0630, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0380, nCol + 0630, transfor(nDifHsDisp,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0480, nCol + 0630, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0520, nCol + 0630, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0620, nCol + 0630, transfor(nDifHsPPR,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0720, nCol + 0630, transfor(nDifHsProd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 0760, nCol + 0630, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0800, nCol + 0630, transfor(nDifHsImpr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0900, nCol + 0630, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 1000, nCol + 0630, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)	
		
		oReport:Line(nTopo + 1060, 0020, nTopo+ 1060,  3270)		
	elseIf nPagina == 1
		
		if cMes <> 	"FEVEREIRO"		
			oReport:Say(nTopo + 0040, nCol+520, cMes									,oFont10N,,0,,0)
		else
			oReport:Say(nTopo + 0040, nCol+490, cMes									,oFont10N,,0,,0)
		endIf
		
		nTopo += 100
		
		oReport:Say(nTopo + 0020, nCol+0500,"Porcent (%)"							,oFont08,,0,,0)
		oReport:Say(nTopo + 0020, nCol+0650,"Dif. (%)"								,oFont08,,0,,0)	
		
		//Cálculo da diferença da porcentagem entre os meses.
		//HORAS FULL
		nDifHsFull := nHsFull - nAntHsFull
		if nAntHsFull == 0
			nDifHsFull := round( (nHsFull * 100) ,3)
		else
			nDifHsFull := round(retPorcent(100, nAntHsFull, nDifHsFull),3) 		
		endIf
		//Horas Ocupadas
		nDifHsOcup := nHsOcupada -	nAntHsOcup
		if nAntHsOcup == 0
			nDifHsOcup := round( (nDifHsOcup * 100) ,3)
		else
			nDifHsOcup := round(retPorcent(100, nAntHsOcup, nDifHsOcup),3)
		endIf
		
		//Horas Perdidas
		nDifHsPerd := nHsPerdida - nAntHsPerd
		if nAntHsPerd == 0
			nDifHsPerd := round( (nDifHsPerd * 100) ,3)
		else
			nDifHsPerd := round(retPorcent(100, nAntHsPerd, nDifHsPerd),3)
		endIf
		
		//Paradas Programadas
		nDifTotPr := nTotPR - nAntTotPr
		if nAntTotPr == 0
			nDifTotPr := round( (nDifTotPr * 100) ,3)
		else
			nDifTotPr := round(retPorcent(100, nAntTotPr, nDifTotPr),3)
		endIf
		//HORAS DISPONIVEL 
		nDifHsDisp := nTotHsDisp - nAntHsDisp
		if nAntHsDisp == 0
			nDifHsDisp := round( (nDifHsDisp * 100) ,3)
		else
			nDifHsDisp := round(retPorcent(100, nAntHsDisp, nDifHsDisp),3)
		endIf
		
		//HORAS DISPONIVEL PPR
		nDifHsPPR  := nHsDispPPR - nAntHsPPR
		if nAntHsPPR == 0
			nDifHsPPR := round( (nDifHsPPR * 100) ,3)
		else
			nDifHsPPR := round(retPorcent(100, nAntHsPPR, nDifHsPPR),3)
		endIf
		
		//Horas Produtivas
		nDifHsProd := nHsProdut - nAntHsProd
		if nAntHsProd == 0
			nDifHsProd := round( (nDifHsProd * 100) ,3)
		else
			nDifHsProd := round(retPorcent(100, nAntHsProd, nDifHsProd),3)
		endIf
		
		//Horas Improdutivas
		nDifHsImpr := nHsImprodu - nAntHsImpr
		if nAntHsImpr == 0
			nDifHsImpr := round( (nDifHsImpr * 100) ,3)
		else
			nDifHsImpr := round(retPorcent(100, nAntHsImpr, nDifHsImpr),3)
		endIf
		
		//Printando as informações dos percentuais de diferença entre os meses.
		oReport:Say(nTopo + 0120, nCol + 0650, transfor(nDifHsFull,cMaskPerc)								,oFont08,100,,,0)		
		oReport:Say(nTopo + 0200, nCol + 0650, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0240, nCol + 0650, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0280, nCol + 0650, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0380, nCol + 0650, transfor(nDifHsDisp,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0480, nCol + 0650, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0520, nCol + 0650, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0620, nCol + 0650, transfor(nDifHsPPR,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0720, nCol + 0650, transfor(nDifHsProd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 0760, nCol + 0650, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0800, nCol + 0650, transfor(nDifHsImpr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0900, nCol + 0650, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 1000, nCol + 0650, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)				 					
	
	else
				
		oReport:Say(nTopo + 0040, nCol+430, cMes									,oFont10N,,0,,0)
		nTopo += 100
		
		oReport:Say(nTopo + 0020, nCol+0470,"Porcent (%)"							,oFont08,,0,,0)
		oReport:Say(nTopo + 0020, nCol+0620,"Dif. (%)"								,oFont08,,0,,0)	
		
		//Cálculo da diferença da porcentagem entre os meses.
		//HORAS FULL
		nDifHsFull := nHsFull - nAntHsFull
		if nAntHsFull == 0
			nDifHsFull := round( (nHsFull * 100) ,3)
		else
			nDifHsFull := round(retPorcent(100, nAntHsFull, nDifHsFull),3) 		
		endIf
		//Horas Ocupadas
		nDifHsOcup := nHsOcupada -	nAntHsOcup
		if nAntHsOcup == 0
			nDifHsOcup := round( (nDifHsOcup * 100) ,3)
		else
			nDifHsOcup := round(retPorcent(100, nAntHsOcup, nDifHsOcup),3)
		endIf
		
		//Horas Perdidas
		nDifHsPerd := nHsPerdida - nAntHsPerd
		if nAntHsPerd == 0
			nDifHsPerd := round( (nDifHsPerd * 100) ,3)
		else
			nDifHsPerd := round(retPorcent(100, nAntHsPerd, nDifHsPerd),3)
		endIf
		
		//Paradas Programadas
		nDifTotPr := nTotPR - nAntTotPr
		if nAntTotPr == 0
			nDifTotPr := round( (nDifTotPr * 100) ,3)
		else
			nDifTotPr := round(retPorcent(100, nAntTotPr, nDifTotPr),3)
		endIf
		//HORAS DISPONIVEL 
		nDifHsDisp := nTotHsDisp - nAntHsDisp
		if nAntHsDisp == 0
			nDifHsDisp := round( (nDifHsDisp * 100) ,3)
		else
			nDifHsDisp := round(retPorcent(100, nAntHsDisp, nDifHsDisp),3)
		endIf
		
		//HORAS DISPONIVEL PPR
		nDifHsPPR  := nHsDispPPR - nAntHsPPR
		if nAntHsPPR == 0
			nDifHsPPR := round( (nDifHsPPR * 100) ,3)
		else
			nDifHsPPR := round(retPorcent(100, nAntHsPPR, nDifHsPPR),3)
		endIf
		
		//Horas Produtivas
		nDifHsProd := nHsProdut - nAntHsProd
		if nAntHsProd == 0
			nDifHsProd := round( (nDifHsProd * 100) ,3)
		else
			nDifHsProd := round(retPorcent(100, nAntHsProd, nDifHsProd),3)
		endIf
		
		//Horas Improdutivas
		nDifHsImpr := nHsImprodu - nAntHsImpr
		if nAntHsImpr == 0
			nDifHsImpr := round( (nDifHsImpr * 100) ,3)
		else
			nDifHsImpr := round(retPorcent(100, nAntHsImpr, nDifHsImpr),3)
		endIf
		
		//Printando as informações dos percentuais de diferença entre os meses.
		oReport:Say(nTopo + 0120, nCol + 0620, transfor(nDifHsFull,cMaskPerc)								,oFont08,100,,,0)		
		oReport:Say(nTopo + 0200, nCol + 0620, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0240, nCol + 0620, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0280, nCol + 0620, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0380, nCol + 0620, transfor(nDifHsDisp,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0480, nCol + 0620, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0520, nCol + 0620, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0620, nCol + 0620, transfor(nDifHsPPR,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0720, nCol + 0620, transfor(nDifHsProd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 0760, nCol + 0620, transfor(nDifHsOcup,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0800, nCol + 0620, transfor(nDifHsImpr,cMaskPerc)								,oFont08,100,,,0)
		oReport:Say(nTopo + 0900, nCol + 0620, transfor(nDifHsPerd,cMaskPerc)								,oFont08,100,,,0)	
		oReport:Say(nTopo + 1000, nCol + 0620, transfor(nDifTotPr,cMaskPerc)								,oFont08,100,,,0)				 					
	
	endIf	
	
	//VALORES CALCULADOS
	
	nCol -= 3
	
	if nPagina == 1
	
		//TOTAL HORAS FULL"				
		oReport:Say(nTopo + 0120, nCol + 0350, padR(StrTran(transfor(nHsFull,cMaskVal),',',':'),9)				,oFont08,100,,,0)
		oReport:Say(nTopo + 0120, nCol + 0500, transfor(100,cMaskPerc)											,oFont08,100,,,0)
		//"Horas Ocupadas"
		oReport:Say(nTopo + 0200, nCol + 0350, padR(StrTran(transfor(nHsOcupada,cMaskVal),',',':'),9)			,oFont08,100,,,0)
		oReport:Say(nTopo + 0200, nCol + 0500, transfor(nPercHOcup,cMaskPerc)									,oFont08,100,,,0)
		
		//"Horas Perdidas"
		oReport:Say(nTopo + 0240, nCol + 0350, padR(StrTran(transfor(nHsPerdida,cMaskVal),',',':'),9)			,oFont08,100,,,0)
		oReport:Say(nTopo + 0240, nCol + 0500, transfor(nPercHPerd,cMaskPerc)									,oFont08,100,,,0)
		
		//"Paradas Programadas"
		oReport:Say(nTopo + 0280, nCol + 0350, padR(StrTran(transfor(nTotPR,cMaskVal),',',':'),9)				,oFont08,100,,,0)
		oReport:Say(nTopo + 0280, nCol + 0500, transfor(nPercPProg,cMaskPerc)									,oFont08,100,,,0)
		
		//"TOTAL HORAS DISPONÍVEL"				
		oReport:Say(nTopo + 0380, nCol + 0350, StrTran(transfor(nTotHsDisp,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0380, nCol + 0500, transfor(100,cMaskPerc)											,oFont08,100,,,0)
		
		//"Horas Ocupadas"
		oReport:Say(nTopo + 0480, nCol + 0350, StrTran(transfor(nHsOcupada,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0480, nCol + 0500, transfor(nPercOcup,cMaskPerc)									,oFont08,100,,,0)
		
		//"Horas Perdidas"
		oReport:Say(nTopo + 0520, nCol + 0350, StrTran(transfor(nHsPerdida,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0520, nCol + 0500, transfor(nPercPerd,cMaskPerc)									,oFont08,100,,,0)	
		
		//"HORAS DISPONÍVEIS PPR (h.ocup. + h.imp.)"		
		oReport:Say(nTopo + 0620, nCol + 0350, StrTran(transfor(nHsDispPPR,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0620, nCol + 0500, transfor(100,cMaskPerc)											,oFont08,100,,,0)	
		
		//"Horas Produtivas (Trabalhadas)"
		oReport:Say(nTopo + 0720, nCol + 0350, StrTran(transfor(nHsProdut,cMaskVal),',',':')					,oFont08,100,,,0)
			
		//"Horas Ocupadas(h.prod. - prd. ab. meta)"
		oReport:Say(nTopo + 0760, nCol + 0350, StrTran(transfor(nHsOcupada,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0760, nCol + 0500, transfor(nPercOcup2,cMaskPerc)									,oFont08,100,,,0)	
		
		//"Horas Improdutivas(h.perd - h.n prev.)"
		oReport:Say(nTopo + 0800, nCol + 0350, StrTran(transfor(nHsImprodu,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0800, nCol + 0500, transfor(nPercImp,cMaskPerc)										,oFont08,100,,,0)	
		
		//HORAS PERDIDAS
		oReport:Say(nTopo + 0900, nCol + 0350, StrTran(transfor(nHsPerdida,cMaskVal),',',':')					,oFont08,100,,,0)
		//oReport:Say(nTopo + 0900, nCol + 0500, transfor(100,cMaskPerc)											,oFont08,100,,,0)
		
		//HORAS PARADAS PROGRAMADAS
		oReport:Say(nTopo + 1000, nCol + 0350, StrTran(transfor(nTotPR,cMaskVal),',',':')						,oFont08,100,,,0)
	//oReport:Say(nTopo + 1000, nCol + 0500, transfor(100,cMaskPerc)											,oFont08,100,,,0)
	
	else
	
		//TOTAL HORAS FULL"				
		oReport:Say(nTopo + 0120, nCol + 0350, padR(StrTran(transfor(nHsFull,cMaskVal),',',':'),9)				,oFont08,100,,,0)
		oReport:Say(nTopo + 0120, nCol + 0470, transfor(100,cMaskPerc)											,oFont08,100,,,0)
		//"Horas Ocupadas"
		oReport:Say(nTopo + 0200, nCol + 0350, padR(StrTran(transfor(nHsOcupada,cMaskVal),',',':'),9)			,oFont08,100,,,0)
		oReport:Say(nTopo + 0200, nCol + 0470, transfor(nPercHOcup,cMaskPerc)									,oFont08,100,,,0)
		
		//"Horas Perdidas"
		oReport:Say(nTopo + 0240, nCol + 0350, padR(StrTran(transfor(nHsPerdida,cMaskVal),',',':'),9)			,oFont08,100,,,0)
		oReport:Say(nTopo + 0240, nCol + 0470, transfor(nPercHPerd,cMaskPerc)									,oFont08,100,,,0)
		
		//"Paradas Programadas"
		oReport:Say(nTopo + 0280, nCol + 0350, padR(StrTran(transfor(nTotPR,cMaskVal),',',':'),9)				,oFont08,100,,,0)
		oReport:Say(nTopo + 0280, nCol + 0470, transfor(nPercPProg,cMaskPerc)									,oFont08,100,,,0)
		
		//"TOTAL HORAS DISPONÍVEL"				
		oReport:Say(nTopo + 0380, nCol + 0350, StrTran(transfor(nTotHsDisp,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0380, nCol + 0470, transfor("100.000",cMaskPerc)									,oFont08,100,,,0)
		
		//"Horas Ocupadas"
		oReport:Say(nTopo + 0480, nCol + 0350, StrTran(transfor(nHsOcupada,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0480, nCol + 0470, transfor(nPercOcup,cMaskPerc)									,oFont08,100,,,0)
		
		//"Horas Perdidas"
		oReport:Say(nTopo + 0520, nCol + 0350, StrTran(transfor(nHsPerdida,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0520, nCol + 0470, transfor(nPercPerd,cMaskPerc)									,oFont08,100,,,0)	
		
		//"HORAS DISPONÍVEIS PPR (h.ocup. + h.imp.)"		
		oReport:Say(nTopo + 0620, nCol + 0350, StrTran(transfor(nHsDispPPR,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0620, nCol + 0470, transfor(100,cMaskPerc)											,oFont08,100,,,0)	
		
		//"Horas Produtivas (Trabalhadas)"
		oReport:Say(nTopo + 0720, nCol + 0350, StrTran(transfor(nHsProdut,cMaskVal),',',':')					,oFont08,100,,,0)
			
		//"Horas Ocupadas(h.prod. - prd. ab. meta)"
		oReport:Say(nTopo + 0760, nCol + 0350, StrTran(transfor(nHsOcupada,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0760, nCol + 0470, transfor(nPercOcup2,cMaskPerc)									,oFont08,100,,,0)	
		
		//"Horas Improdutivas(h.perd - h.n prev.)"
		oReport:Say(nTopo + 0800, nCol + 0350, StrTran(transfor(nHsImprodu,cMaskVal),',',':')					,oFont08,100,,,0)
		oReport:Say(nTopo + 0800, nCol + 0470, transfor(nPercImp,cMaskPerc)										,oFont08,100,,,0)	
		
		//HORAS PERDIDAS
		oReport:Say(nTopo + 0900, nCol + 0350, StrTran(transfor(nHsPerdida,cMaskVal),',',':')					,oFont08,100,,,0)
		//oReport:Say(nTopo + 0900, nCol + 0470, transfor(100,cMaskPerc)											,oFont08,100,,,0)
		
		//HORAS PARADAS PROGRAMADAS
		oReport:Say(nTopo + 1000, nCol + 0350, StrTran(transfor(nTotPR,cMaskVal),',',':')						,oFont08,100,,,0)
		
	
	endIf
	
	
		
	//LINHA DIVISÃO ENTRE MESES
	if nPagina == 1
		oReport:Line(nTopo - 60 , nCol+340, nTopo+ 1060,  nCol+340)
	else
		if nContador == 1
			oReport:Line(nTopo - 60 , nCol+340, nTopo+ 1060,  nCol+340)
		else
			oReport:Line(nTopo - 60 , nCol+280, nTopo+ 1060,  nCol+280)
		endIf	
	endIf
		
	//Armazendo os valores atuais para o cálculos da diferença da porcentagem entre os meses.
	nAntHsFull	:= nHsFull 
	nAntHsOcup	:= nHsOcupada
	nAntHsPerd	:= nHsPerdida
	nAntTotPr	:= nTotPR
	nAntHsDisp	:= nTotHsDisp
	nAntHsPPR	:= nHsDispPPR
	nAntHsProd	:= nHsProdut
	nAntHsImpr	:= nHsImprodu
	
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/12/2014 - 14:03:18
* @description: Consulta SQL para verificar os dados 
* @return: Retorna uma consulta SQL com as horas produtivas e improdutivas (H6_TIPO = 'P' ou 'I') do mês e ano informado.
*/ 
static function retDados(cMes,cAno)

	local cQuery := ""
	local cAlias := "ZZZ"
	
	cQuery += " SELECT * FROM ("+CRLF+CRLF
	
	//cQuery += " SELECT SH6.R_E_C_N_O_ AS RECNO,H6_TIPO,REPLACE(H6_TEMPO,':','.') AS TEMPO "+CRLF
	cQuery += " SELECT SH6.R_E_C_N_O_ AS RECNO "+CRLF
	cQuery += " FROM "+retSQLTab("SH6")+CRLF
	cQuery += " WHERE  SH6.D_E_L_E_T_ <> '*'"+CRLF
	cQuery += " AND H6_FILIAL = '"+xFilial("SH6")+"'"+CRLF
	cQuery += " 	AND H6_TIPO ='P'"+CRLF
	//If mv_par01#2
	cQuery += " AND (H6_OP = ' ' Or (H6_OP>= '"+mv_par01+"' And H6_OP<= '"+mv_par02+"' ))"+CRLF 
	/*Else
		cQuery += " AND H6_OP>='"+mv_par01+"' And H6_OP<='"+mv_par02+"'"+CRLF
	EndIf */
	cQuery += " AND H6_RECURSO>= '"+mv_par03+ "' And H6_RECURSO<='"+mv_par04+"'"+CRLF
	cQuery += " AND H6_MOTIVO>='"+mv_par05+"' And H6_MOTIVO<='"+mv_par06+"'"+CRLF
	//ORACLE - BANCO DO CLIENTE
	//cQuery += " AND TO_CHAR(TO_DATE(H6_DTAPONT,'YYYYMMDD'),'MM') ="+cMes+""+CRLF
	//cQuery += " AND TO_CHAR(TO_DATE(H6_DTAPONT,'YYYYMMDD'),'YYYY') ='"+cAno+"'"+CRLF+CRLF
	//SQL SERVER - BASE TESTE
	cQuery += " AND MONTH(H6_DTAPONT) ='"+cMes+"'"+CRLF
	cQuery += " AND YEAR(H6_DTAPONT) ='"+cAno+"'"+CRLF+CRLF
	
	cQuery += " UNION ALL"+CRLF+CRLF
	
	//cQuery += " SELECT SH6.R_E_C_N_O_ AS RECNO,H6_TIPO,REPLACE(H6_TEMPO,':','.') AS TEMPO "+CRLF
	cQuery += " SELECT SH6.R_E_C_N_O_ AS RECNO "+CRLF
	cQuery += " FROM "+retSQLTab("SH6")+CRLF
	cQuery += " WHERE  SH6.D_E_L_E_T_ <> '*'"+CRLF
	cQuery += " AND H6_FILIAL = '"+xFilial("SH6")+"'"+CRLF
	cQuery += " 	AND H6_TIPO ='I'"+CRLF
	//If mv_par01#2
		cQuery += " AND (H6_OP = ' ' Or (H6_OP>= '"+mv_par01+"' And H6_OP<= '"+mv_par02+"' ))"+CRLF 
	/*Else
		cQuery += " AND H6_OP>='"+mv_par02+"' And H6_OP<='"+mv_par03+"'"+CRLF
	EndIf */
	cQuery += " AND H6_RECURSO>= '"+mv_par03+ "' And H6_RECURSO<='"+mv_par04+"'"+CRLF
	cQuery += " AND H6_MOTIVO>='"+mv_par05+"' And H6_MOTIVO<='"+mv_par06+"'"+CRLF
	//ORACLE - BANCO DO CLIENTE
	//cQuery += " AND TO_CHAR(TO_DATE(H6_DTAPONT,'YYYYMMDD'),'MM') ="+cMes+""+CRLF
	//cQuery += " AND TO_CHAR(TO_DATE(H6_DTAPONT,'YYYYMMDD'),'YYYY') ='"+cAno+"'"+CRLF+CRLF
	//SQL SERVER - BASE TESTE
	cQuery += " AND MONTH(H6_DTAPONT) ='"+cMes+"'"+CRLF
	cQuery += " AND YEAR(H6_DTAPONT) ='"+cAno+"'"+CRLF+CRLF
	
	cQuery += ") A"
			
	TCQUERY cQuery NEW ALIAS &(cAlias)
	
return cAlias


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/12/2014 - 16:56:52
* @description: Fazendo o recálculo das horas abaixo da meta. Função copiada do fonte shmatr02, para utilizar a mesma logica para esta situação.
*/ 
Static Function R895Calc()

	Local nLotPad 	:= 0
	Local nTemPad 	:= 0
	Local nTempo  	:= Nil
	Local cTime   	:= Nil
	Local nQuant
	local cRoteiro	:= ""
		
	dbSelectArea("SC2")
	dbSeek(xFilial("SC2")+SH6->H6_OP)
	If !Empty(C2_ROTEIRO)
		cRoteiro:=C2_ROTEIRO
	Else
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SH6->H6_PRODUTO)
		cRoteiro:=B1_OPERPAD
	EndIf
	
	dbSelectArea("SG2")
	//Posicionando na tabela SG2.
	dbSeek(xFilial("SG2")+SH6->H6_PRODUTO+cRoteiro+SH6->H6_OPERAC)
	//dbSeek(xFilial("SG2")+SH6->H6_PRODUTO+SH6->H6_OPERAC+SH6->H6_OPERAC)
	
	nLotPad := If(SH6->H6_X_LOTEP==0,If(SG2->G2_LOTEPAD==0,1,SG2->G2_LOTEPAD),SH6->H6_X_LOTEP)
	nTemPad := If(SH6->H6_X_TEMPA==0,If(SG2->G2_TEMPAD ==0,1,SG2->G2_TEMPAD ),SH6->H6_X_TEMPA)
	
	nQuant  := SH6->H6_QTDPROD	//+H6_QTDPERD)

	If cTipoTemp == Nil
		cTipoTemp:=GetMV("MV_TPHR")
	EndIf

	//Se MV_TPHR for N (Normal) devo converter G2_TEMPAD para            
	// centesimal para permitir multiplicar pela quantidade produzida     

	If cTipoTemp == "N"
		nTemPad := Int(nTemPad) + (Mod(nTemPad, 1) / 0.6)
	Endif

	// Calcula Tempo de Duracao baseado no Tipo de Operacao
	If SG2->G2_TPOPER $ " 1"
		nTempo := nQuant * nTemPad / nLotPad
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+SH6->H6_RECURSO)
		If Found() .And. SH1->H1_MAOOBRA # 0
			nTempo :=Round( nTempo / H1_MAOOBRA,5)
		EndIf
		dbSelectArea("SH6")
	ElseIf SG2->G2_TPOPER == "4"
		nQuantAloc:= nQuant % nLotPad
		nQuantAloc:= Int(nQuant)+If(nQuantAloc>0,nLotPad-nQuantAloc,0)
		nTempo := Round(nQuantAloc * ( nTemPad / nLotPad ),5)
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+SH6->H6_RECURSO)
		If Found() .And. SH1->H1_MAOOBRA # 0
			nTempo :=Round( nTempo / H1_MAOOBRA,5)
		EndIf
		dbSelectArea("SH6")
	ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
		nTempo := nTemPad
	EndIf

	If cTipoTemp == "N"
		cTime  := StrZero(Int(nTempo), 3) + ":" + StrZero(Mod(nTempo, 1) * 100, 2)
		cTime := A680ConvHora(cTime, "C", "N")
	Endif
						
Return IF(cTipoTemp=="N",cTime,nTempo)



/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 19/12/2014 - 08:44:07
* @description: Cálculo dos registros da tabela ZRM. 
*/ 
static function calcZRM(aMotivos)
	
	local cMotivos	:= ""
	local nPosZRM	:= 0
	local nMotivos	:= 0
	local nZRM		:= 0
	local i			:= 0
	local j			:= 0
	local nR		:= 0
	
	For i:=1 to Len(aMotivos)
		cMotivos += "'"+aMotivos[i,1] + "',"
	next i
	cMotivos	:= subStr(cMotivos,1,len(cMotivos)-1)
	
	retZRM(cMotivos) // aZRM[x][1] = ZRM_RMETAS 
								// aZRM[x][2] = ZRM_CHAVE
								// aZRM[x][3] = ZRM_DESCRI
								// aZRM[x][4] = Soma das horas
								// aZRM[x][5] = campo para ordenação para impressao
	//Ordenando o vetor pela Meta
		
	nZRM := len(aZRM)
	
	//Calculando a Soma dos valores
	nMotivos := Len(aMotivos)
	for j:=1 to nMotivos
		
		nPosZRM := aScan(aZRM,{|x| AllTrim(x[2]) == aMotivos[j,1]}) 
		
		aZRM[nPosZRM][4] +=  Val(StrTran(aMotivos[j,2],':','.'))
		
	next j
	
	//Verificando se so tem tipo PP, para impressão da hora extraviada
	for nR:=1 to nZRM
		if aZRM[nR][1] <> "PP"
			lTipoPPUni := .F.
		endIf
		
		//Calculando os totais de cada grupo
		if aZRM[nR][1] == "PP"
			nTotPP += aZRM[nR][4]
			aZRM[nR][5]:= 0 //Posição 5 utilizada para ordenação do array para exibição.
		elseIf aZRM[nR][1] == "HP"
			nTotHP += aZRM[nR][4]
			aZRM[nR][5]:= 1
		elseIf aZRM[nR][1] == "HM"
			nTotHM += aZRM[nR][4]
			aZRM[nR][5]:= 2
		elseIf aZRM[nR][1] == "OU"
			nTotOU += aZRM[nR][4]
			aZRM[nR][5]:= 3
		elseIf aZRM[nR][1] == "PR"
			nTotPR += aZRM[nR][4]
			aZRM[nR][5]:= 4		
		endIf
	next nR

return



/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 19/12/2014 - 08:51:33
* @description:Função reutilizada. Retirada do fonte shmatr02. 
*/ 
Static Function R825Calc(cHoraOri)

	Local nHor1      := Val(StrTran(cHoraOri,':','.'))
	Local nHor2      := Val(StrTran(TimeH6("C"),':','.'))   // Uso H6_TEMPO que esta sempre no formato centesimal
	Local nTamHora	  := If(TamSX3("H6_TEMPO")[1]>7,TamSX3("H6_TEMPO")[1],7)
	Local cHoraDest  := '0000:00'

	If !Empty(cHoraOri)
		cHoraDest := StrTran(StrZero(nHor1+nHor2, nTamHora, 2),'.',':')
	EndIf

Return(cHoraDest)


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 19/12/2014 - 08:57:50
* @description: Consulta aos dados da tabela ZRM. 
*/ 
static function retZRM(cMotivos)
	
	local cQuery := ""
		
	if empty(allTrim(cMotivos))
		cMotivos := "' '"
	endIf
		
	cQuery := " SELECT * "+CRLF 
	cQuery += " FROM "+retSQLTab("ZRM")+CRLF
	cQuery += " WHERE "+retSQLDel("ZRM")+CRLF
	cQuery += " 	AND ZRM_FILIAL = '"+xFilial("ZRM")+"' "+CRLF
	cQuery += " 	AND ZRM_CHAVE IN ("+cMotivos+")"+CRLF
	cQuery += " ORDER BY ZRM_RMETAS "
			
	TCQUERY cQuery NEW ALIAS BBB
		
	while !BBB->(Eof())
		AADD(aZRM,{allTrim(BBB->ZRM_RMETAS),allTrim(BBB->ZRM_CHAVE),allTrim(BBB->ZRM_DESCRI),0,0})
		BBB->(DbSkip())
	End
	
	BBB->(DbCloseArea())
	
	
return 


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 19/12/2014 - 08:57:08
* @description: Regra de três para verificar a porcentagem das horas improdutivas.
*/ 
static function retPorcent(nPorcent,nValor1,nValor2)

	local nRet := 0
	
	nRet := (nPorcent * nValor2) / nValor1

return nRet


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 30/12/2014 - 10:56:36
* @description: Criação do grupo de perguntas. 
*/ 
static function criaSX1(cPerg)
	
	//putSx1(cPerg, '01', 'Lista Horas?'     	,'', '', 'mv_ch1', 'N', 1						, 0, 0, 'C', ''				, ''	, '', '', 'mv_par01',"Improdutivas",,,,"Produtivas",,,"Ambas")
	putSx1(cPerg, '01', 'De OP?'	      	,'', '', 'mv_ch1', 'C', TAMSX3("H6_OP")[1]		, 0, 0, 'G', ''				, 'SC2'	, '', '', 'mv_par01')
	putSx1(cPerg, '02', 'Ate OP?'		  	,'', '', 'mv_ch2', 'C', TAMSX3("H6_OP")[1]   	, 0, 0, 'G', ''				, 'SC2'	, '', '', 'mv_par02')
	putSx1(cPerg, '03', 'De Recurso'	 	,'', '', 'mv_ch3', 'C', TAMSX3("H6_RECURSO")[1]	, 0, 0, 'G', ''				, 'SH1'	, '', '', 'mv_par03')
	putSx1(cPerg, '04', 'Ate Recurso'	 	,'', '', 'mv_ch4', 'C', TAMSX3("H6_RECURSO")[1] , 0, 0, 'G', ''				, 'SH1'	, '', '', 'mv_par04')
	putSx1(cPerg, '05', 'De Motivo'		 	,'', '', 'mv_ch5', 'C', TAMSX3("H6_MOTIVO")[1] 	, 0, 0, 'G', ''				, ''	, '', '', 'mv_par05')
	putSx1(cPerg, '06', 'Ate Motivo'	 	,'', '', 'mv_ch6', 'C', TAMSX3("H6_MOTIVO")[1] 	, 0, 0, 'G', ''				, ''	, '', '', 'mv_par06')
	putSx1(cPerg, '07', 'De Data Apontam.' 	,'', '', 'mv_ch7', 'D', 8 				  		, 0, 0, 'G', ''				, ''	, '', '', 'mv_par07')
	putSx1(cPerg, '08', 'Ate Data Apontam.' ,'', '', 'mv_ch8', 'D', 8 					  	, 0, 0, 'G', 'U_vldData()'	, ''	, '', '', 'mv_par08')
	putSx1(cPerg, '09', 'De Operador'	 	,'', '', 'mv_ch9', 'C', TAMSX3("H6_OPERAC")[1] 	, 0, 0, 'G', ''				, ''	, '', '', 'mv_par09')
	putSx1(cPerg, '10', 'Ate Operador'	 	,'', '', 'mv_cha', 'C', TAMSX3("H6_OPERAC")[1]  , 0, 0, 'G', ''				, ''	, '', '', 'mv_par10')
	
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 30/12/2014 - 11:15:46
* @description: Validação do grupo de perguntas SHMATR03. Podem ser selecionados no máximo doze meses. 
*/ 
user function vldData()

	local lRet 		:= .T.
	local nMesDe	:= month(MV_PAR07) 
	local nMesAte	:= month(MV_PAR08)
	local nAnoDe	:= year(MV_PAR07)
	local nAnoAte	:= year(MV_PAR08)
	
	/* RICARDO
	if nAnoDe <> nAnoAte
		if (nAnoDe - nAnoAte) == 1
			nMesAte += 12
			if (nMesAte - nMesDe) > 12
				alert("Por favor, selecione o período máximo de 12 meses!")
				lRet := .F.
			endIf			
		else 
			alert("Por favor, selecione o período máximo de 12 meses!")
			lRet := .F.				
		endIf
	endIf 
	*/
	
	_nDias := (MV_PAR08 - MV_PAR07)
	
	If _nDias > 365
		alert("Por favor, selecione o período máximo de 12 meses!")
		lRet := .F.
	EndIf
return lRet