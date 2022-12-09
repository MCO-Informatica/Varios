#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ETIZEBRA()


Local aCampos    := {{"Z3_OK"     ,,"",},;
					{"Z3_LOTE"   ,,"LOTE", "@!"},;
					{"Z3_QUANTID",,"QTDE","@E 999,999,999.99"},;
					{"Z3_ARTIGO" ,,"ARTIGO", "@!"},;
					{"Z3_COR"    ,,"COR", "@!"},;
					{"Z3_PARTIDA",,"OP", "@!"},;
					{"Z3_NOME"   ,,"CLIENTE", "@!"}}

Private cQuery
Private cMarca   := GetMark()
Private bMark    := {|| Mark()}
Private cFiltro	 := ""
Private cCadastro:= "Etiquetas Lote"
Private aRotina := {{"Pesquisar", "AxPesqui",0,1},;
					{"Imprimir", "Execblock('ZEBRA',.F.,.F.)",0,3}}
Private bMark    := {|| Mark()}

Private cPerg      := "EST06R"

If !Pergunte(cPerg,.T.)
	Return()
Else
	If !EMPTY(MV_PAR01)
		cFiltro := "Z3_LOTE >= '"+MV_PAR01+"' .AND. Z3_LOTE <= '"+MV_PAR02+"' .AND. "
	Else
		cFiltro := "Z3_IMP <> 'S'"
	EndIf
EndIF


_cQuery :=	""
_cQuery +=	"SELECT * FROM SZ3010 "
_cQuery +=	"WHERE "
If !EMPTY(MV_PAR01)
	_cQuery +=	"WHERE Z3_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
Else
	_cQuery +=	"WHERE Z3_IMP <> 'S' "
EndIf
_cQuery +=	"ORDER BY Z3_LOTECTL "

MEMOWRIT("C:\SQLREL.txt",_cQuery)
_cQuery := ChangeQuery(_cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)

TCSETFIELD( "SQL","C5_EMISSAO","D")
TCSETFIELD( "SQL","C6_ENTREG","D")





dbSelectArea("SZ3")
dbSetOrder(1)

Set Filter to &cFiltro

MarkBrow("SZ3","Z3_OK",,aCampos,,cMarca,,,,,)

Return

User Function ZEBRA()
       
Local cCmd, bExecok	:= .F.

dbSelectArea("SZ3")
dbGoTop()
ProcRegua(RecCount())

If Eof()
	MsgBox("Não há etiquetas a imprimir.","Etiquetas","Stop")
	dbSelectArea("SZ3")
	Return
EndIf

MSCBPRINTER("ELTRON","LPT1",,63,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
MSCBLOADGRF("ETIQ.PCX")
MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
MSCBINFOETI("Etiqueta Produto","")
MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a SZ3eratura da impressora

ProcRegua(SZ3->(RecCount()))

While  ! SZ3->(eof())
	
    If !Marked("Z3_OK")
        DbSkip()
        Loop
    EndIf

	If !Empty(SZ3->Z3_CNPJ)
		_cCNPJ := Subs(SZ3->Z3_CNPJ,1,2)+"."+Subs(SZ3->Z3_CNPJ,3,3)+"."+Subs(SZ3->Z3_CNPJ,6,3)+"/"+Subs(SZ3->Z3_CNPJ,9,4)+"-"+Subs(SZ3->Z3_CNPJ,13,2)
	ElseIf mv_par04==1
		_cCNPJ := "50.747.674/0001-22"
	Else
		_cCNPJ := "05.567.611/0001-30"
	EndIf
	
	bExecOk:= .T.
	IncProc("Imprimindo Etiqueta...")
	MSCBBEGIN(1,6,63) //Inicio da Imagem da Etiqueta
	MSCBGRAFIC(55,05,"ETIQ")
	//					MSCBGRAFIC(2,3,"ETIQ")
	//					MSCBBOX(05,02,99,48)
	//					MSCBLINEH(10,10,45)
	//					MSCBLINEH(15,15,45)
	//					MSCBLINEV(20,20,05)
	//					MSCBLINEH(20,20,45)
	//					MSCBLINEH(25,25,45)
	//					MSCBLINEV(55,55,48)
	MSCBSAY(05,05,Iif(!Empty(SZ3->Z3_NOME),SZ3->Z3_NOME,Iif(mv_par04==1,"KENIA","ONITEX")),"N","4","2,2")
	//MSCBSAY(20,14,SZ3->Z3_NOME,"N","2","1,1")
	MSCBSAY(05,21,"Lote:","N","2","1,1")
	MSCBSAY(15,21,SZ3->Z3_LOTE,"N","2","1,1")
	MSCBSAY(34,21,"OP:","N","2","1,1")
	MSCBSAY(39,21,SZ3->Z3_PARTIDA,"N","2","1,1")
	MSCBSAY(50,21,"Rev:","N","2","1,1")
	MSCBSAY(55,21,SZ3->Z3_REVISOR,"N","2","1,1")
	MSCBSAY(05,28,"Artigo:","N","2","1,1")
	MSCBSAY(15,28,SZ3->Z3_ARTIGO,"N","2","1,1")
	MSCBSAY(30,28,"Cor:","N","2","1,1")
	MSCBSAY(40,28,SZ3->Z3_COR,"N","2","1,1")
	MSCBSAY(50,28,"Qtde:","N","2","1,1")
	MSCBSAY(60,28,Transform(SZ3->Z3_QUANTID,"@E 999,999,999.99"),"N","2","1,1")
	MSCBSAYBAR(73,33,ALLTRIM(SZ3->Z3_LOTE),'N','MB07',08,.F.,.T.,.F.,,2,2,,,,.T.)
	MSCBSAY(05,35,"Compos:","N","2","1,1")
	MSCBSAY(15,35,SZ3->Z3_COMP,"N","2","1,1")
	MSCBSAY(05,42,"CNPJ:","N","2","1,1")
	MSCBSAY(15,42,_cCNPJ,"N","2","1,1")
	MSCBSAY(20,47,"**** RECLAMACOES SOMENTE COM ESTA ETIQUETA ****","N","2","1,1")
	MSCBSAY(05,63,"","N","2","1,1")
	MSCBEND()
	
	
	RecLock("SZ3",.F.)
	SZ3->Z3_IMP	:=	"S"
	SZ3->Z3_OK	:=	""
	MsUnLock()

	
	dbSelectArea("SZ3")
	dbSkip()
EndDo

dbSelectArea("SZ3")

Return
