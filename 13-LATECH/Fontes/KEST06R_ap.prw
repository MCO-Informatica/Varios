#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKEST06R_APบAutor  ณRicardo Correia     บ Data ณ nใo definidaบฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para impressใo de etiquetas especifico Kenia       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/





User Function KEST06R()

Processa({|| U_ETIQUETA()})

Return

User Function ETIQUETA()

Local 	lContinua 	:= .T.
Local 	lRet      	:= .T.
Local	_cPerg		:=	"EST06R"

Private _aLote:={},_aTpBar:={},_aCodBar:={},_aCliente:={},_aOP:={},_aRevisor:={},_aArtigo:={},_aCor:={},_aQtde:={},_aCompos:={},_aCNPJ:={},_aNome:={}

Pergunte(_cPerg,.t.)


dbSelectArea("SZ3")
dbSetOrder(1)
dbSeek(xFilial("SZ3")+MV_PAR01,.F.)
ProcRegua(RecCount())

While !Eof() .and. xFilial("SZ3") == SZ3->Z3_FILIAL .and. SZ3->Z3_LOTE <= MV_PAR02
	
	IncProc("Montando Tabela de Etiquetas...")
	
	AADD(_aLote	  	, 	SZ3->Z3_LOTE	)
	AADD(_aTpBar  	, 	"CODE128" 		)
	AADD(_aCodBar 	,	SZ3->Z3_LOTE	)
	AADD(_aCliente	,	SZ3->Z3_CLIENTE	)
	AADD(_aOP		,	SZ3->Z3_PARTIDA	)
	AADD(_aRevisor	,	Transform(SZ3->Z3_REVISOR,"@E 999"))
	AADD(_aArtigo	,	SZ3->Z3_ARTIGO	)
	AADD(_aCor		,	SZ3->Z3_COR		)
	AADD(_aQtde		,	Transform( SZ3->Z3_QUANTID,"@E 999,999.99"))
	AADD(_aCompos	,	SZ3->Z3_COMP	)
	AADD(_aCNPJ		,	Iif(Empty(SZ3->Z3_CNPJ),"50747674000122",SZ3->Z3_CNPJ))
	AADD(_aNome		,	Iif(Empty(SZ3->Z3_NOME),"KENIA",SZ3->Z3_NOME	))
	
	dbSelectArea("SZ3")
	dbSkip()
EndDo

ImpEtiq()	//----> FUNCAO PARA IMPRESSAO DA ETIQUETA


Return


Static Function ImpEtiq()

LOCAL oPrint
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL oBrush

oPrint:=TMSPrinter():New( "Etiquetas Laser" )
oPrint:SetPortrait() 	//----> OU SETLANDSCAPE()
//oPrint:StartPage()   	//----> INICIA UMA NOVA PAGINA

//Parโmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20n:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont22n:= TFont():New("Eras Bold ITC",9,22,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",0)





For i:= 1 to Len(_aLote)
	
	
	//----> INICIA NOVA PAGINA
	oPrint:StartPage()
	
	//----> ETIQUETA 1
	oPrint:Box	(0170, 0030, 0690, 1110					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (0180, 0040, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (0170, 0620, 0690, 0620					) 	//---->	VERTICAL 1
	oPrint:Line (0255, 0030, 0255, 0620					)  	//---->	HORIZONTAL 1
	oPrint:Say  (0265, 0040, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (0290, 0040, _aCliente[i]	, oFont8	)	//----> _aCliente[i]
	oPrint:Line (0340, 0030, 0340, 0620					)  	//---->	HORIZONTAL 2
	oPrint:Say  (0350, 0040, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (0375, 0040, _aLote[i] 		, oFont8	)	//----> _CLOTE
	oPrint:Line (0340, 0230, 0425, 0230					)  	//---->	VERTICAL 2
	oPrint:Say  (0350, 0240, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (0375, 0240, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (0340, 0430, 0425, 0430					)  	//---->	VERTICAL 3
	oPrint:Say  (0350, 0430, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (0375, 0440, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (0425, 0030, 0425, 0620					)  	//---->	HORIZONTAL 3
	oPrint:Say  (0435, 0040, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (0460, 0040, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (0425, 0230, 0510, 0230					)  	//---->	VERTICAL 4
	oPrint:Say  (0435, 0240, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (0460, 0240, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (0425, 0430, 0510, 0430					)  	//---->	VERTICAL 5
	oPrint:Say  (0435, 0440, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (0460, 0440, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (0510, 0030, 0510, 1110					)  	//---->	HORIZONTAL 4
	oPrint:Say  (0520, 0040, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (0545, 0040, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (0605, 0030, 0605, 0620					)  	//---->	HORIZONTAL 5
	oPrint:Say  (0615, 0040, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (0640, 0040, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],2.6,3.3,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1
	
    If i > Len(_aLote)
    	Exit
    EndIf


	
	//----> ETIQUETA 2
	oPrint:Box	(0170, 1290, 0690, 2370					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (0180, 1300, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (0170, 1880, 0690, 1880					) 	//---->	VERTICAL 1
	oPrint:Line (0255, 1290, 0255, 1880					)  	//---->	HORIZONTAL 1
	oPrint:Say  (0265, 1300, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (0290, 1300, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (0340, 1290, 0340, 1880					)  	//---->	HORIZONTAL 2
	oPrint:Say  (0350, 1300, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (0375, 1300, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (0340, 1490, 0425, 1490					)  	//---->	VERTICAL 2
	oPrint:Say  (0350, 1500, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (0375, 1500, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (0340, 1690, 0425, 1690					)  	//---->	VERTICAL 3
	oPrint:Say  (0350, 1700, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (0375, 1700, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (0425, 1290, 0425, 1880					)  	//---->	HORIZONTAL 3
	oPrint:Say  (0435, 1300, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (0460, 1300, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (0425, 1490, 0510, 1490					)  	//---->	VERTICAL 4
	oPrint:Say  (0435, 1500, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (0460, 1500, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (0425, 1690, 0510, 1690					)  	//---->	VERTICAL 5
	oPrint:Say  (0435, 1700, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (0460, 1700, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (0510, 1290, 0510, 2370					)  	//---->	HORIZONTAL 4
	oPrint:Say  (0520, 1300, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (0545, 1300, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (0605, 1290, 0605, 1880					)  	//---->	HORIZONTAL 5
	oPrint:Say  (0615, 1300, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (0640, 1300, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],2.6,8.6,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1	
	
    If i > Len(_aLote)
    	Exit
    EndIf
	


	
	//----> ETIQUETA 3
	oPrint:Box	(0760, 0030, 1280, 1110					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (0770, 0040, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (0760, 0620, 1280, 0620					) 	//---->	VERTICAL 1
	oPrint:Line (0845, 0030, 0845, 0620					)  	//---->	HORIZONTAL 1
	oPrint:Say  (0855, 0040, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (0870, 0040, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (0930, 0030, 0930, 0620					)  	//---->	HORIZONTAL 2
	oPrint:Say  (0940, 0040, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (0965, 0040, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (0930, 0230, 1015, 0230					)  	//---->	VERTICAL 2
	oPrint:Say  (0940, 0240, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (0965, 0240, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (0930, 0430, 1015, 0430					)  	//---->	VERTICAL 3
	oPrint:Say  (0940, 0440, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (0965, 0440, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (1015, 0030, 1015, 0620					)  	//---->	HORIZONTAL 3
	oPrint:Say  (1025, 0040, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (1060, 0040, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (1015, 0230, 1100, 0230					)  	//---->	VERTICAL 4
	oPrint:Say  (1025, 0240, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (1060, 0240, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (1015, 0430, 1100, 0430					)  	//---->	VERTICAL 5
	oPrint:Say  (1025, 0440, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (1060, 0440, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (1100, 0030, 1100, 1110					)  	//---->	HORIZONTAL 4
	oPrint:Say  (1110, 0040, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (1135, 0040, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (1195, 0030, 1195, 0620					)  	//---->	HORIZONTAL 5
	oPrint:Say  (1205, 0040, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (1230, 0040, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],5.1,3.3,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1
	
    If i > Len(_aLote)
    	Exit
    EndIf


	
	//----> ETIQUETA 4
	oPrint:Box	(0760, 1290, 1280, 2370					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (0770, 1300, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (0760, 1880, 1280, 1880					) 	//---->	VERTICAL 1
	oPrint:Line (0845, 1290, 0845, 1880					)  	//---->	HORIZONTAL 1
	oPrint:Say  (0855, 1300, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (0870, 1300, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (0930, 1290, 0930, 1880					)  	//---->	HORIZONTAL 2
	oPrint:Say  (0940, 1300, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (0965, 1300, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (0930, 1490, 1015, 1490					)  	//---->	VERTICAL 2
	oPrint:Say  (0940, 1500, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (0965, 1500, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (0930, 1690, 1015, 1690					)  	//---->	VERTICAL 3
	oPrint:Say  (0940, 1700, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (0965, 1700, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (1015, 1290, 1015, 1880					)  	//---->	HORIZONTAL 3
	oPrint:Say  (1025, 1300, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (1060, 1300, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (1015, 1490, 1100, 1490					)  	//---->	VERTICAL 4
	oPrint:Say  (1025, 1500, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (1060, 1500, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (1015, 1690, 1100, 1690					)  	//---->	VERTICAL 5
	oPrint:Say  (1025, 1700, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (1060, 1700, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (1100, 1290, 1100, 2370					)  	//---->	HORIZONTAL 4
	oPrint:Say  (1110, 1300, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (1135, 1300, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (1195, 1290, 1195, 1880					)  	//---->	HORIZONTAL 5
	oPrint:Say  (1205, 1300, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (1230, 1300, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],5.1,8.6,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1	
	
    If i > Len(_aLote)
    	Exit
    EndIf



	
	//----> ETIQUETA 5
	oPrint:Box	(1350, 0030, 1870, 1110					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (1370, 0040, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (1350, 0620, 1870, 0620					) 	//---->	VERTICAL 1
	oPrint:Line (1435, 0030, 1435, 0620					)  	//---->	HORIZONTAL 1
	oPrint:Say  (1445, 0040, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (1470, 0040, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (1520, 0030, 1520, 0620					)  	//---->	HORIZONTAL 2
	oPrint:Say  (1530, 0040, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (1555, 0040, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (1520, 0230, 1605, 0230					)  	//---->	VERTICAL 2
	oPrint:Say  (1530, 0240, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (1555, 0240, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (1520, 0430, 1605, 0430					)  	//---->	VERTICAL 3
	oPrint:Say  (1530, 0440, "Revisor:"		, oFont8	)	//----> "REVCISOR"
	oPrint:Say  (1555, 0440, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (1605, 0030, 1605, 0620					)  	//---->	HORIZONTAL 3
	oPrint:Say  (1615, 0040, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (1650, 0040, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (1605, 0230, 1690, 0230					)  	//---->	VERTICAL 4
	oPrint:Say  (1615, 0240, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (1650, 0240, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (1605, 0430, 1690, 0430					)  	//---->	VERTICAL 5
	oPrint:Say  (1615, 0440, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (1650, 0440, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (1690, 0030, 1690, 1110					)  	//---->	HORIZONTAL 4
	oPrint:Say  (1700, 0040, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (1725, 0040, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (1775, 0030, 1775, 0620					)  	//---->	HORIZONTAL 5
	oPrint:Say  (1795, 0040, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (1820, 0040, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],7.6,3.3,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1
	
    If i > Len(_aLote)
    	Exit
    EndIf


	
	//----> ETIQUETA 6
	oPrint:Box	(1350, 1290, 1870, 2370					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (1360, 1300, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (1350, 1880, 1870, 1880					) 	//---->	VERTICAL 1
	oPrint:Line (1435, 1290, 1435, 1880					)  	//---->	HORIZONTAL 1
	oPrint:Say  (1445, 1300, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (1470, 1300, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (1520, 1290, 1520, 1880					)  	//---->	HORIZONTAL 2
	oPrint:Say  (1530, 1300, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (1555, 1300, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (1520, 1490, 1605, 1490					)  	//---->	VERTICAL 2
	oPrint:Say  (1530, 1500, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (1555, 1500, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (1520, 1690, 1605, 1690					)  	//---->	VERTICAL 3
	oPrint:Say  (1530, 1700, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (1555, 1700, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (1605, 1290, 1605, 1880					)  	//---->	HORIZONTAL 3
	oPrint:Say  (1615, 1300, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (1650, 1300, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (1605, 1490, 1690, 1490					)  	//---->	VERTICAL 4
	oPrint:Say  (1615, 1500, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (1650, 1500, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (1605, 1690, 1690, 1690					)  	//---->	VERTICAL 5
	oPrint:Say  (1615, 1700, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (1650, 1700, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (1690, 1290, 1690, 2370					)  	//---->	HORIZONTAL 4
	oPrint:Say  (1700, 1300, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (1735, 1300, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (1775, 1290, 1775, 1880					)  	//---->	HORIZONTAL 5
	oPrint:Say  (1795, 1300, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (1820, 1300, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],7.6,8.6,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1	
	
    If i > Len(_aLote)
    	Exit
    EndIf


	//----> ETIQUETA 7
	oPrint:Box	(1950, 0030, 2470, 1110					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (1960, 0040, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (1950, 0620, 2470, 0620					) 	//---->	VERTICAL 1
	oPrint:Line (2035, 0030, 2035, 0620					)  	//---->	HORIZONTAL 1
	oPrint:Say  (2045, 0040, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (2070, 0040, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (2120, 0030, 2120, 0620					)  	//---->	HORIZONTAL 2
	oPrint:Say  (2130, 0040, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (2155, 0040, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (2120, 0230, 2205, 0230					)  	//---->	VERTICAL 2
	oPrint:Say  (2130, 0240, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (2155, 0240, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (2120, 0430, 2205, 0430					)  	//---->	VERTICAL 3
	oPrint:Say  (2130, 0440, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (2155, 0440, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (2205, 0030, 2205, 0620					)  	//---->	HORIZONTAL 3
	oPrint:Say  (2215, 0040, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (2250, 0040, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (2205, 0230, 2290, 0230					)  	//---->	VERTICAL 4
	oPrint:Say  (2215, 0240, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (2250, 0240, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (2205, 0430, 2290, 0430					)  	//---->	VERTICAL 5
	oPrint:Say  (2215, 0440, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (2250, 0440, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (2290, 0030, 2290, 1110					)  	//---->	HORIZONTAL 4
	oPrint:Say  (2300, 0040, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (2325, 0040, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (2375, 0030, 2375, 0620					)  	//---->	HORIZONTAL 5
	oPrint:Say  (2395, 0040, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (2420, 0040, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],10.2,3.3,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1
	
    If i > Len(_aLote)
    	Exit
    EndIf


	//----> ETIQUETA 8
	oPrint:Box	(1950, 1290, 2470, 2370					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (1960, 1300, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (1950, 1880, 2470, 1880					) 	//---->	VERTICAL 1
	oPrint:Line (2035, 1290, 2035, 1880					)  	//---->	HORIZONTAL 1
	oPrint:Say  (2045, 1300, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (2070, 1300, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (2120, 1290, 2120, 1880					)  	//---->	HORIZONTAL 2
	oPrint:Say  (2130, 1300, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (2155, 1300, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (2120, 1490, 2205, 1490					)  	//---->	VERTICAL 2
	oPrint:Say  (2130, 1500, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (2155, 1500, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (2120, 1690, 2205, 1690					)  	//---->	VERTICAL 3
	oPrint:Say  (2130, 1700, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (2155, 1700, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (2205, 1290, 2205, 1880					)  	//---->	HORIZONTAL 3
	oPrint:Say  (2215, 1300, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (2250, 1300, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (2205, 1490, 2290, 1490					)  	//---->	VERTICAL 4
	oPrint:Say  (2215, 1500, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (2250, 1500, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (2205, 1690, 2290, 1690					)  	//---->	VERTICAL 5
	oPrint:Say  (2215, 1700, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (2250, 1700, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (2290, 1290, 2290, 2370					)  	//---->	HORIZONTAL 4
	oPrint:Say  (2300, 1300, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (2325, 1300, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (2375, 1290, 2375, 1880					)  	//---->	HORIZONTAL 5
	oPrint:Say  (2395, 1300, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (2420, 1300, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],10.2,8.6,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1	
	
    If i > Len(_aLote)
    	Exit
    EndIf


	
	//----> ETIQUETA 9
	oPrint:Box	(2550, 0030, 3070, 1110					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (2560, 0040, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (2550, 0620, 3070, 0620					) 	//---->	VERTICAL 1
	oPrint:Line (2635, 0030, 2635, 0620					)  	//---->	HORIZONTAL 1
	oPrint:Say  (2645, 0040, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (2670, 0040, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (2720, 0030, 2720, 0620					)  	//---->	HORIZONTAL 2
	oPrint:Say  (2730, 0040, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (2755, 0040, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (2720, 0230, 2805, 0230					)  	//---->	VERTICAL 2
	oPrint:Say  (2730, 0240, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (2755, 0240, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (2720, 0430, 2805, 0430					)  	//---->	VERTICAL 3
	oPrint:Say  (2730, 0440, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (2755, 0440, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (2805, 0030, 2805, 0620					)  	//---->	HORIZONTAL 3
	oPrint:Say  (2815, 0040, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (2850, 0040, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (2805, 0230, 2890, 0230					)  	//---->	VERTICAL 4
	oPrint:Say  (2815, 0240, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (2850, 0240, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (2805, 0430, 2890, 0430					)  	//---->	VERTICAL 5
	oPrint:Say  (2815, 0440, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (2850, 0440, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (2890, 0030, 2890, 1110					)  	//---->	HORIZONTAL 4
	oPrint:Say  (2900, 0040, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (2925, 0040, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (2975, 0030, 2975, 0620					)  	//---->	HORIZONTAL 5
	oPrint:Say  (2995, 0040, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (3020, 0040, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],12.7,3.3,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	i:= i + 1
	
    If i > Len(_aLote)
    	Exit
    EndIf


	//----> ETIQUETA 10
	oPrint:Box	(2550, 1290, 3070, 2370					)	//----> DESENHA O BOX DA ETIQUETA
	oPrint:Say  (2560, 1300, _aNome[i]		, oFont18n	)	//---->	"KENIA"
	oPrint:Line (2550, 1880, 3070, 1880					) 	//---->	VERTICAL 1
	oPrint:Line (2635, 1290, 2635, 1880					)  	//---->	HORIZONTAL 1
	oPrint:Say  (2645, 1300, "Cliente:"		, oFont8	)	//----> "CLIENTE"
	oPrint:Say  (2670, 1300, _aCliente[i] 		, oFont8	)	//----> _aCliente[i]
	oPrint:Line (2720, 1290, 2720, 1880					)  	//---->	HORIZONTAL 2
	oPrint:Say  (2730, 1300, "Lote:"   		, oFont8	)	//----> "LOTE"
	oPrint:Say  (2755, 1300, _aLote[i]    		, oFont8	)	//----> _aLote[i]
	oPrint:Line (2720, 1490, 2805, 1490					)  	//---->	VERTICAL 2
	oPrint:Say  (2730, 1500, "O.P.:"   		, oFont8	)	//----> "OP"
	oPrint:Say  (2755, 1500, _aOp[i]      		, oFont8	)	//----> _aOp[i]
	oPrint:Line (2720, 1690, 2805, 1690					)  	//---->	VERTICAL 3
	oPrint:Say  (2730, 1700, "Revisor:"		, oFont8	)	//----> "REVISOR"
	oPrint:Say  (2755, 1700, _aRevisor[i] 		, oFont8	)	//----> _aRevisor[i]
	oPrint:Line (2805, 1290, 2805, 1880					)  	//---->	HORIZONTAL 3
	oPrint:Say  (2815, 1300, "Artigo:" 		, oFont8	)	//----> "ARTIGO"
	oPrint:Say  (2850, 1300, _aArtigo[i]  		, oFont8	)	//----> _aArtigo[i]
	oPrint:Line (2805, 1490, 2890, 1490					)  	//---->	VERTICAL 4
	oPrint:Say  (2815, 1500, "Cor:"   		, oFont8	)	//----> "COR"
	oPrint:Say  (2850, 1500, _aCor[i]     		, oFont8	)	//----> _aCor[i]
	oPrint:Line (2805, 1690, 2890, 1690					)  	//---->	VERTICAL 5
	oPrint:Say  (2815, 1700, "Qtde.:"		, oFont8	)	//----> "QTDE"
	oPrint:Say  (2850, 1700, _aQtde[i]			, oFont8	)	//----> _aQtde[i]
	oPrint:Line (2890, 1290, 2890, 2370					)  	//---->	HORIZONTAL 4
	oPrint:Say  (2900, 1300, "Composi็ใo:" 	, oFont8	)	//----> "COMPOSICAO"
	oPrint:Say  (2925, 1300, _aCompos[i]  		, oFont8	)	//----> _aCompos[i]
	oPrint:Line (2975, 1290, 2975, 1880					)  	//---->	HORIZONTAL 5
	oPrint:Say  (2995, 1300, "C.N.P.J.:" 	, oFont8	)	//----> "CNPJ"
	oPrint:Say  (3020, 1300, _aCNPJ[i]    		, oFont8	)	//----> _aCNPJ[i]
	
	MSBAR(_aTpBar[i],12.7,8.6,_aCodBar[i],oPrint,.F.,,,0.0150,0.5,.T.,,,.F.)		//----> IMPRESSAO DO CODIGO DE BARRAS
	
	//i:= i + 1	
	
    If i > Len(_aLote)
    	Exit
    EndIf
	
	
	oPrint:EndPage()	//----> FINALIZA PAGINA

Next

oPrint:EndPage()		//----> FINALIZA PAGINA
oPrint:Preview()		//----> VISUALIZA ANTES DA IMPRESSAO

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  15/08/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := "ETBAR4"

aRegs :={}

aAdd(aRegs, {cPerg, "01", "Codigo do Produto de     ?", "", "", "mv_ch1", "C", 15, 0, 0, "G", "", "MV_PAR01", ""     , "", "", "", "", ""       , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SZ3", "", "", ""})
aAdd(aRegs, {cPerg, "02", "Codigo do Produto ate    ?", "", "", "mv_ch2", "C", 15, 0, 0, "G", "", "MV_PAR02", ""     , "", "", "", "", ""       , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SZ3", "", "", ""})
aAdd(aRegs, {cPerg, "03", "Quantidade de Etiquetas  ?", "", "", "mv_ch3", "N", 5, 0, 0, "G", "", "MV_PAR03", ""     , "", "", "", "", ""       , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "", "", ""})
//aAdd(aRegs, {cPerg, "04", "Qual Porta de Impressao  ?", "", "", "mv_ch4", "N", 1, 0, 4, "C", "", "MV_PAR04", "COM1" , "", "", "", "", "COM2"   , "", "", "", "", "LPT1"   , "", "", "", "", "LPT2", "", "", "", "", "", "", "", "", ""   , "", "", ""})
aAdd(aRegs, {cPerg, "04", "Qual o tipo de Etiqueta  ?", "", "", "mv_ch4", "N", 1, 0, 1, "C", "", "MV_PAR04", "Peca" , "", "", "", "", "Inter"  , "", "", "", "", "Master" , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "", "", ""})
aAdd(aRegs, {cPerg, "05", "Qual a Empresa           ?", "", "", "mv_ch5", "N", 1, 0, 1, "C", "", "MV_PAR05", "Etilux", "", "", "", "", "Mundial", "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "", "", ""})

//Aadd(aRegs,  {cPerg, "09", "Considera Financ.        ?", "", "", "mv_ch9", "N" ,1, 0, 0, "C", "", "mv_par09", "Sim", "", "", "", "", "Nao"  , "", "", "", "", "Ambos" , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
// LINHA CORRETA DE EXEMPLO ----- aAdd(aRegs,{cPerg,"04","Qual Impressao     ?","","","mv_ch4","N", 1,0,4,"C","","MV_PAR04","COM1","","",""              ,"","COM2","","","","","LPT1" ,"","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return

