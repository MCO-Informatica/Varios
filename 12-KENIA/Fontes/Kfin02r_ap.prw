#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kfin02r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("CBTXT,CBCONT,NLINHA,M_PAG,WNREL,CPERGUNTA")
SetPrvt("TAMANHO,LIMITE,NTIPO,TITULO,CABEC1,CABEC2")
SetPrvt("CSTRING,LABORTPRINT,_SALDO,LEND,_NPRAZO,NREGISTRO,A,_Nvalor")
SetPrvt("CBANCO,NFLOAT,CBORDERO,_NVALSALDO,_2Dias,_Saldo2,_Juros,_NVALDESAGIO,_NVALIOF")
SetPrvt("_NVALTARIFA,_NVALCPMF,_NVALLIQUIDO,_NQTDTIT,_NQTDDIAS,_NLIQUIDO")
SetPrvt("AREGISTRO,NLACO,J,_Jdesagio,_Jiof,_Jcpmf")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN02R  ³ Autor ³Ricardo Correa de Souza³ Data ³31/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao dos Demonstrativos de Operacoes de Descontos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDesc1   := 'Este relatorio tem por objetivo a demonstracao da opera-'
cDesc2   := 'cao de desconto de duplicatas, atraves do bordero de desconto.'
cDesc3   := 'Kenia Industrias Texteis Ltda'
aReturn  :=  { 'Zebrado', 1,'Administracao', 1, 2, 1, '',1 }
nomeprog := 'KFIN02R'
nLastKey :=  0
cbtxt    :=  space(10)
cbcont   :=  0
nLinha   :=  90
m_pag    :=  1
wnrel    :=  'KFIN02R'
cPergunta := 'FIN02R    '
tamanho  := 'M'
limite   := 132
nTipo    := 15
titulo := 'Operacao de Desconto de Duplicatas'
cabec1 := 'DUPLICATA        EMISSAO     VENCTO        VALOR    DESAGIO        IOF      TARIFA      CPMF      LIQUIDO   DIAS'
//         123 123456 1  99/99/9999 99/99/9999 9.999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 9.999.999,99 999999
//         0   4      11 14         25         36           49         60         71         82         93           106
cabec2 := ' '
cString  := 'SEA'
lAbortPrint := .f.
lEnd := .f.
_nPrazo := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // Do Bordero                               ³
//³ mv_par02         // Ate o bordero                            ³
//³ mv_par03         // Qtde de copias                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CriaPerg()
pergunte(cPergunta,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPergunta,titulo,cDesc1,cDesc2,cDesc3,.f.,,.f.,tamanho)
if LastKey() == 27 .or. nLastKey == 27
	return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aceita parametros e faz ajustes necessarios                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetDefault(aReturn,cString)
if LastKey() == 27 .or. nLastKey == 27
	return
endif

#IFDEF WINDOWS
	RptStatus({|| ImpDemo() }, ' Bordero de Desconto de Duplicatas ')// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(ImpDemo) }, ' Bordero de Desconto de Duplicatas ')
#ELSE
	ImpDemo()
#ENDIF


return
*-------------------------------------------------------------------------*

*-------------------------------------------------------------------------*
Static Function ImpDemo
*-------------------------------------------------------------------------*

dbselectarea('sea')
dbsetorder(1)
dbseek(xFilial('SEA')+mv_par01)
if found() == .f.
	msgbox('Numero de bordero nao encontrado','Bordero de Desconto','ALERT')
	return
endif

nRegistro := recno()

SetRegua(Reccount() - Recno())

for a:=1 to mv_par03
	dbselectarea('sea')
	dbsetorder(1)
	dbgoto(nRegistro)
	
	nLinha    := 90
	
	m_pag     := 1
	nTipo     := 15
	
	setprc(0,0)
	
	@prow(),00 PSAY AvalImp(limite)
	
	while eof() == .f. .and.;
		xFilial('SEA') == ea_filial .and.;
		ea_numbor >= mv_par01 .and.;
		ea_numbor <= mv_par02
		
		#IFNDEF WINDOWS
			inkey()
			
			if lastkey() == 286
				lEnd := .t.
			endif
		#ELSE
			if lAbortPrint
				lEnd := .t.
			endif
		#ENDIF
		if lEnd
			@prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			exit
		endif
		
		if SEA->EA_CART <> "R"
			dbskip()
			Loop
		endif
		
		dbselectarea('sa6')
		dbsetorder(1)
		dbseek(xFilial()+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)
		if found()
			cBanco := alltrim(sea->ea_portado)+' - '+;
			alltrim(sea->ea_agedep)+' - '+;
			alltrim(sea->ea_numcon)+' - '+sa6->a6_nome
			
			//nFloat := mv_par04
		else
			cBanco := alltrim(sea->ea_portado)+' - '+;
			alltrim(sea->ea_agedep)+' - '+;
			alltrim(sea->ea_numcon)
			
			//nFloat := mv_par04
		endif
		
		cBordero  := sea->ea_numbor
		titulo    := 'Operacao de Desconto de Duplicatas - Bordero: '+cBordero
		nLinha    := 90
		m_pag     := 1
		
		if nLinha >= 65
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			
			nLinha := prow() + 1
			
			@nLinha,010 PSAY 'Banco...........: '+cBanco
			nLinha := nLinha + 1
			
			dbselectarea('szr')
			dbsetorder(1)
			dbseek(xFilial('SZR')+cBordero)
			if found()
				@nLinha,010 PSAY 'Taxa Permanencia...: '+transform(szr->zr_contrat,'@e 999.9999')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Valor TAC..........: '+transform(szr->zr_tac    ,'@e 999,999.99')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Valor TED/DOC......: '+transform(szr->zr_doc    ,'@e 999,999.99')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Taxa IOF...........: '+transform(szr->zr_iof    ,'@e 999.9999')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Valor Cobranca.....: '+transform(szr->zr_tarifa ,'@e 999,999.99')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Taxa CPMF..........: '+transform(szr->zr_cpmf   ,'@e 999.9999')
				nLinha := nLinha + 1
				@nLinha,010 PSAY 'Float .............: '+transform(szr->zr_float  ,'999')
				nLinha := nLinha + 1
				
			endif
			
			@nLinha,000 PSAY replicate('-',limite)
			
			nLinha := nLinha + 1
		endif
		
		dbselectarea('sea')
		dbsetorder(1)
		
		_nValSaldo     := 0
		_nValDesagio   := 0
		_nValIof       := 0
		_nValTarifa    := 0
		_nValCpmf      := 0
		_nValLiquido   := 0
		_nQtdTit       := 0
		_nQtdDias      := 0
		_nTotDesagio	:= 0
		_nTotBordero	:= 0
		
		while eof() == .f. .and. (ea_filial + ea_numbor) ==;
			(xFilial('SEA')+cBordero)
			
			#IFNDEF WINDOWS
				inkey()
				
				if lastkey() == 286
					lEnd := .t.
				endif
			#ELSE
				if lAbortPrint
					lEnd := .t.
				endif
			#ENDIF
			
			if lEnd
				@prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
				exit
			endif
			
			IncRegua()
			
			if nLinha >= 65
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				
				nLinha := prow() + 1
				
				@nLinha,010 PSAY 'Banco...........: '+cBanco
				
				nLinha := nLinha + 1
				
				dbselectarea('szr')
				dbsetorder(1)
				dbseek(xFilial('SZR')+cBordero)
				if found()
					@nLinha,010 PSAY 'Taxa Permanencia...: '+transform(szr->zr_contrat,'@e 999.9999')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Valor TAC..........: '+transform(szr->zr_tac    ,'@e 999,999.99')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Valor TED/DOC......: '+transform(szr->zr_doc    ,'@e 999,999.99')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Taxa IOF...........: '+transform(szr->zr_iof    ,'@e 999.9999')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Valor Cobranca.....: '+transform(szr->zr_tarifa ,'@e 999,999.99')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Taxa CPMF..........: '+transform(szr->zr_cpmf   ,'@e 999.9999')
					nLinha := nLinha + 1
					@nLinha,010 PSAY 'Float .............: '+transform(szr->zr_float  ,'999')
					nLinha := nLinha + 1
				endif
				
				@nLinha,000 PSAY replicate('-',limite)
				
				nLinha := nLinha + 1
			endif
			
			dbselectarea('se1')
			dbsetorder(1)
			dbseek(xFilial('SE1')+sea->ea_prefixo+sea->ea_num+sea->ea_parcela+sea->ea_tipo)
			
			dbselectarea('sea')
			dbsetorder(1)
			
			_nLiquido := se1->e1_saldo -  (szr->zr_desagio+szr->zr_iof+szr->zr_cpmf)
			
			_nDias         := (SE1->e1_vencrea + SZR->ZR_FLOAT) - dDataBase
			_nTaxaContrato := round(SZR->ZR_CONTRAT / 30,6)
			
			_nTarifa		:=	SZR->ZR_TARIFA
			
			_nPercentual   := round((_nTaxaContrato * _nDias) / 100,10)
			_nDesagio      := round(SE1->e1_saldo * _nPercentual,2)
			
			_nPercentual   := round((SZR->ZR_IOF * _nDias) / 100,6)
			_nIof          := round(SE1->e1_saldo * _nPercentual,2)
			
			_nCpmf         := round(SE1->e1_saldo * round(SZR->ZR_CPMF / 100,8),2)
			
			_nDesconto     := _nDesagio + _nIof + _nCpmf + _nTarifa
			
			_nTotDesagio   := _nTotDesagio + _nDesconto
			
			_nTotBordero   := _nTotBordero + SE1->e1_saldo
			
			
			
			@nLinha,000 PSAY se1->e1_prefixo
			@nLinha,004 PSAY se1->e1_num
			@nLinha,011 PSAY se1->e1_parcela
			@nLinha,014 PSAY se1->e1_emissao
			@nLinha,025 PSAY se1->e1_vencrea
			@nLinha,036 PSAY se1->e1_saldo                    						picture '@e 9,999,999.99'
			@nLinha,049 PSAY _nDesagio						  						picture '@e 999,999.99'
			@nLinha,060 PSAY _nIof							  						picture '@e 999,999.99'
			@nLinha,071 PSAY _nTarifa                         						picture '@e 999,999.99'
			@nLinha,082 PSAY _nCpmf				              						picture '@e 999,999.99'
			@nLinha,093 PSAY SE1->E1_SALDO - _nDesagio - _nIof - _nCpmf	- _nTarifa  picture '@e 999,999.99'
			@nLinha,106 PSAY _nDias				              						picture '999'
			//@nLinha,109 PSAY se1->e1_cnpj            picture '@R 99.999.999/9999-99'
			
			
			_nValSaldo     	:= _nValSaldo	+	se1->e1_saldo
			_nValDesagio   	:= _nValDesagio	+	_nDesagio
			_nValIof       	:= _nValIof		+	_nIof
			_nValdoc       	:= SZR->ZR_DOC
			_nValTarifa    	:= _nValTarifa 	+	_nTarifa
			_nValDoc		:= SZR->ZR_DOC
			_nValTac		:= SZR->ZR_TAC
			_nValCpmf      	:= _nValCpmf	+	_nCpmf
			_nValLiquido   	:= _nValLiquido	+	_nLiquido
			_nQtdTit       	:= _nQtdTit		+	1
			_nQtdDias      	:= _nQtdDias	+	_nDias
			_nPrazo        	:= _nPrazo		+	(_nDias * se1->e1_saldo)
			
			nLinha := nLinha + 1
			
			dbselectarea('sea')
			dbsetorder(1)
			dbskip()
		enddo
		
		if _nValSaldo >= 0.01
			@nLinha,000 PSAY replicate('-',limite)
			
			nLinha := nLinha + 1
			
			@nLinha,036 PSAY _nValSaldo             picture '@e 9,999,999.99'
			@nLinha,049 PSAY _nValDesagio           picture '@e 999,999.99'
			@nLinha,060 PSAY _nValIof               picture '@e 999,999.99'
			@nLinha,071 PSAY _nValTarifa            picture '@e 999,999.99'
			@nLinha,082 PSAY _nValCpmf              picture '@e 999,999.99'
			@nLinha,093 PSAY _nValSaldo-_nValDesagio-_nValIof-_nValCpmf-_nValTarifa           picture '@e 999,999.99'
			@nLinha,110 PSAY 'Media de Dias: '+transform ((_nPrazo / _nValSaldo ),'999')
			
			nLinha := nLinha + 2
			
			@nLinha,093 PSAY _nValTac           picture '@e 999,999.99'
			@nLinha,110 PSAY 'Valor TAC'
			nLinha := nLinha + 1
			
			@nLinha,093 PSAY _nValDoc           picture '@e 999,999.99'
			@nLinha,110 PSAY 'Valor TED/DOC'
			nLinha := nLinha + 1
			
			//@nLinha,093 PSAY _nValTarifa           picture '@e 999,999.99'
			//@nLinha,110 PSAY 'Valor Cobranca'
			//nLinha := nLinha + 1
			
			@nLinha,093 PSAY _nValSaldo-_nValDesagio-_nValIof-_nValCpmf-_nValTac-_nValDoc-_nValTarifa           picture '@e 999,999.99'
			@nLinha,110 PSAY 'Total Liquido'
			nLinha := nLinha + 1
			
			
			@nLinha,000 PSAY replicate('-',limite)
			
			nLinha := nLinha + 1
		endif
	enddo
	
	_nPrazo    := 0
	_nValSaldo := 0
	
	roda(cbcont,cbtxt,tamanho)
next

if aReturn[5] == 1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif

MS_FLUSH()

return
*-------------------------------------------------------------------------*

*-------------------------------------------------------------------------*
Static Function CriaPerg
*-------------------------------------------------------------------------*

aRegistro := {}

AADD(aRegistro,{cPergunta,'01','Do Bordero         ?','mv_ch1','C',06,0,0,'G','','mv_par01','','','','','','','','','','','','','','',''})
AADD(aRegistro,{cPergunta,'02','Ate o Bordero      ?','mv_ch2','C',06,0,0,'G','','mv_par02','','','','','','','','','','','','','','',''})
AADD(aRegistro,{cPergunta,'03','Qtde de Copias     ?','mv_ch3','N',02,0,0,'G','','mv_par03','','','','','','','','','','','','','','',''})

for nLaco:=1 to len(aRegistro)
	dbselectarea('sx1')
	dbsetorder(1)
	dbseek(cPergunta+strzero(nLaco,2))
	if found() == .f.
		reclock('SX1',.t.)
		
		for j:=1 to FCount()
			FieldPut(j,aRegistro[nLaco,j])
		next
		
		MsUnlock()
	endif
next

return
*-------------------------------------------------------------------------*

  
