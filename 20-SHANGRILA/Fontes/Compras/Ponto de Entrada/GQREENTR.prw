#Include "Protheus.ch"
#Include "RWMAKE.ch"

/*
* Funcao		:	GQREENTR
* Autor			:	João Zabotto
* Data			: 	13/09/2012
* Descricao		:	Ponto de Entrada para geração do complemento de NF de Importação
* Retorno		:
*/
User Function GQREENTR()
Local _aArea      := GetArea()

&&->variaveis de browse para complemento de importacao
Private aHeadDI := {}		&& aHeader Sped-Nfe e Sped-Fiscal - TAG DI
Private aColsDI := {} 		&& aCols Sped-Nfe e Sped-Fiscal - TAG DI
Private nDI		:= 0
Private _oGetDI			    && NewGet Sped-Nfe e Sped-Fiscal - TAG DI

Private aCols     := {}
Private aHeader   := {}
Private n		  := 1
Private _cMens	  := space(200)

If SF1->F1_EST == 'EX'  &&.AND. SF1->F1_FORMUL = 'S' .AND. SF1->F1_TIPO $ 'N,I'
	
	SA2->(dbSeek(xFilial("SA2") + SF1->(F1_FORNECE+F1_LOJA) ))
	
	@ 114,22 To 469,914 Dialog mkwdlg Title OemToAnsi("Informacoes Complementares")
	@ 10,15 Say OemToAnsi("Mensagem da NF:") Size 57,8
	@ 07,65 Get _cMens Size 300,10
	
	@ 30,10 To 140,425 Title OemToAnsi("SPED NFe - Complemento de nota de importacao (DI)")
	
	AtuDI(@aHeadDI, @aColsDI)
	_oGetDI := MsNewGetDados():New(40,15,135,420,3,,,,,,1,,,,mkwdlg,aHeadDI,aColsDI)
	
	@ 150,360 Button OemToAnsi("_Gravar Complemento") Size 60,16 Action GravaComp()
	
	Activate Dialog mkwdlg centered
	
endif

RestArea(_aArea)
Return()

Static Function AtuDI(aHeadDI,aColsDI,_nOpc)
Local nUsado2	:= 0
Local nI		:= 0

&&->Limpa os dados carregados no aCols
aColsDI	:= {}

&&->Monta tela da DI
nUsado2 := 0

Aadd(aHeadDI,{"Doc.Imp","CD5_DOCIMP","@!",10,0,,,"C",})
Aadd(aHeadDI,{"Dt.Imp","CD5_DTDI","@!",8,0,,,"C",})
Aadd(aHeadDI,{"Loc.Desemb.","CD5_LOCDES","@!", 15,0,,,"C",})
Aadd(aHeadDI,{"Uf.Desemb.","CD5_UFDES","@!", 2,0,,,"C",})
Aadd(aHeadDI,{"Dt.Desemb.","CD5_DTDES","@!", 8,0,,,"C",})

nUsado2 := Len(aHeadDI)
aColsDI := Array( 1 , (nUsado2+1) )
aColsDI[1,nUsado2+1] := .F.
For nI := 1 To nUsado2
	aColsDI[1,nI] := CriaVar(aHeadDI[nI,2],.T.)
Next

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³GravaComp ³ Grava complemento -tabela CD5 - Sped-Fiscal      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaComp()
Local aAreaSd1 := SD1->(getArea())
Local cMens := ""
Local cNrDI := ""
Local nX
Local _lGrava := .T.

&&->Analisa as informacoes da DI
if len(aColsDI) > 0
	
	aCols := _oGetDI:aCols
	aHeader := _oGetDI:aHeader
	
	for nX := 1 to len(aCols)
		
		if !aCols[nX,Len(aHeader)+1]
			
			if empty(aCols[nX,2])
				cMens := "Nro. do Documento de Importacao, "
			endif
			
			if empty(aCols[nX,2])
				cMens += "Data do Documento de Importacao, "
			endif
			
			if empty(aCols[nX,3	])
				cMens += "Local do Desembaraço, "
			endif
			
			if empty(aCols[nX,4])
				cMens += "UF do Desembaraço, "
			endif
			
			if empty(aCols[nX,5])
				cMens += "Data do Desembaraço, "
			endif
			
			If !empty(cMens)
				cMens += "não foi(ram) informado(s)."+chr(13)
				cMens += "Inclusao das informacoes complementares nao pode ser confirmada."
				MsgAlert(cMens,"Atencao ...")
				_lGrava := .F.
			endif
			
		endif
		
	Next
	
endif

If _lGrava
	
	if !empty(_cMens)
		SF1->(RecLock("SF1",.F.))
		SF1->F1_MENNOTA	:= Alltrim(_cMens)
		SF1->(MsUnlock())
	endif
	
	CD5->(dbSetorder(1))
	CD5->(dbSeek(xFilial("CD5") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ,.f.))
	
	while CD5->(!Eof()) .and. CD5->(CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA) == xFilial("CD5") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		recLock("CD5",.f.,.t.)
		CD5->(dbDelete())
		msUnlock("CD5")
		CD5->(dbSkip())
	enddo
	
	dbSelectArea("SD1")
	dbSetOrder(1) && D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM
	
	if dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		while SD1->(!eof()) .and. xFilial("SD1")+SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
			
			if 	recLock("CD5",.t.)
				CD5->CD5_FILIAL 	:= 	xFilial("CD5")
				CD5->CD5_DOC    	:= 	SF1->F1_DOC
				CD5->CD5_SERIE  	:= 	SF1->F1_SERIE
				CD5->CD5_DOCIMP 	:= 	Alltrim(aCols[1,1])
				CD5->CD5_TPIMP  	:= 	"0"
				CD5->CD5_ESPEC  	:= 	SF1->F1_ESPECIE
				CD5->CD5_FORNEC 	:= 	SF1->F1_FORNECE
				CD5->CD5_LOJA   	:= 	SF1->F1_LOJA
				CD5->CD5_DTPPIS 	:= 	aCols[1,2]
				CD5->CD5_DTPCOF 	:= 	aCols[1,2]
				CD5->CD5_DTDI   	:= 	aCols[1,2]
				CD5->CD5_DTDES   	:= 	aCols[1,2]
				CD5->CD5_NDI    	:= 	Alltrim(aCols[1,1])
				CD5->CD5_UFDES  	:= 	aCols[1,4]
				CD5->CD5_LOCDES 	:= 	aCols[1,3]
				CD5->CD5_CODFAB 	:= 	SF1->F1_FORNECE
				CD5->CD5_LOJFAB 	:= 	SF1->F1_LOJA
				CD5->CD5_LOCAL  	:= 	"0"
				CD5->CD5_BSPIS  	:= 	SD1->D1_BASIMP6
				CD5->CD5_ALPIS  	:= 	SD1->D1_ALQIMP6
				CD5->CD5_VLPIS  	:= 	SD1->D1_VALIMP6
				CD5->CD5_BSCOF  	:= 	SD1->D1_BASIMP5
				CD5->CD5_ALCOF  	:=	SD1->D1_ALQIMP5
				CD5->CD5_VLCOF  	:= 	SD1->D1_VALIMP5
				CD5->CD5_CODEXP		:=	SD1->D1_FORNECE
				CD5->CD5_LOJEXP		:=	SD1->D1_LOJA
				CD5->CD5_NADIC		:=	SD1->D1_ZZADIC
				CD5->CD5_SQADIC		:=	SD1->D1_ZZSEQAD
				CD5->CD5_BCIMP		:=	(SF1->F1_VALMERC - SF1->F1_VALIPI - SF1->F1_VALICM)
				CD5->CD5_VLRII		:=	SD1->D1_II
				CD5->CD5_DSPAD		:=	0
				CD5->CD5_VLRIOF		:=	0
				CD5->CD5_ITEM		:=	SD1->D1_ITEM
				CD5->CD5_VTRANS		:=	'7'
				CD5->CD5_INTERM		:=	'1'				
				CD5->(msUnlock("CD5"))
			endif
			
			SD1->(dbSkip())
		enddo
	endif
	
	Close(mkwdlg)
	
endif
restArea(aAreaSd1)
Return()

 