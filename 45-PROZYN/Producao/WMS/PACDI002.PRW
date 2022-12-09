#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} GET
//Impresso de Etiqueta de Endereo.
@author Zanni
@since 08/07/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/                            
User Function PACDI002()
Local cPerg		:= PadR("PACDI002",10)          

AjustaSx1(cPerg)


If Pergunte(cPerg,.T.)    

	Processa( {|| ImpEtqEnd() },"Aguarde" ,"Processando...")

EndIf

Return() 

          
/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
/* Emite eqtiqueta de Endereo                                               */
/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function ImpEtqEnd()
If EMpty(mv_par05)
   Alert('Favor selecionar a impressora!')
   Return .F.
EndIf
DbSelectArea('SBE')
DbGoTop()

_cQuery := "Select BE_LOCAL, BE_LOCALIZ, BE_DESCRIC From "+RetSqlName('SBE')+" Where BE_LOCAL Between '"+mv_par01+"' And '"+mv_par02+"' And BE_LOCALIZ Between '"+mv_par03+"' And '"+mv_par04+"' Order By BE_LOCALIZ"
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_SBE",.F.,.T.)

Do While !EoF()
    //Impar
    If mv_par06 == 1
	   If Mod(Val(Substring(_SBE->BE_LOCALIZ,8,3)),2) <> 0
	   Else
	      DbSkip()
		  Loop
	   EndIf
	ElseIf mv_par06 == 2
	   If Mod(Val(Substring(_SBE->BE_LOCALIZ,8,3)),2) <> 0
	      DbSkip()
		  Loop
	   EndIf
	EndIf
    /*
    If SBE->BE_LOCAL > mv_par02 .or. SBE->BE_LOCAL < mv_par01
	   DbSkip()
	   Loop
	ENDIF

    If SBE->BE_LOCALIZ > mv_par04 .or. SBE->BE_LOCALIZ < mv_par03
	   DbSkip()
	   Loop
	ENDIF
    */
	cCodigo := Alltrim(_SBE->BE_LOCALIZ)
	//MSCBLOADGRF("SIGA.GRF")
	CB5SetImp(mv_par05)
	MSCBBEGIN(1,6)
	/*
	MSCBBOX(30,05,76,05)
	MSCBBOX(02,12.7,76,12.7)
	MSCBBOX(02,21,76,21)
	MSCBBOX(30,01,30,12.7,3)
	//MSCBGRAFIC(2,3,"SIGA")
	MSCBSAY(33,02,'ENDERECO',"N","0","025,035",,,,,.t.)
	MSCBSAY(33,06,"CODIGO","N","A","012,008")
	MSCBSAY(33,08, AllTrim(SBE->BE_LOCALIZ), "N", "0", "032,035")
	MSCBSAY(05,14,"DESCRICAO","N","A","012,008")
	MSCBSAY(05,17,SBE->BE_DESCRIC,"N", "0", "020,030")
	MSCBSAYBAR(23,22,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	*/
	MSCBSAY(70,10,cCodigo,"R","C","85")
	//MSCBSAY(63,30,cCodigo,"B","0","090,100",,,,,.t.)
	MSCBSAYBAR(16,20,cCodigo,"R","MB07",35,.F.,.F.,.F.,,3,1,.F.,.F.,"1",.T.)
	MSCBInfoEti("Endereco","30X100")
	MSCBEND()

	DbSkip()
EndDo	
_SBE->(DbCloseArea())

Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {}
Local I := 0

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Local de?"		    ,"mv_par01"	,"C",2,0,0,"G","",	"mv_par01","","","","","NNR" } )
AADD(	aSx1,{ cPerg,"02","Local Ate?"			,"mv_par02"	,"C",2,0,0,"G","",	"mv_par02","","","","","NNR","" } )
AADD(	aSx1,{ cPerg,"03","Endereco De?"		,"mv_par03"	,"C",13,0,0,"G","",	"mv_par03","","","","","SBE" } ) 
AADD(	aSx1,{ cPerg,"04","Endereco Ate?"		,"mv_par04"	,"C",13,0,0,"G","",	"mv_par04","","","","","SBE","" } ) 
AADD(	aSx1,{ cPerg,"05","Local de Impressao?"	,"mv_par05"	,"C",06,0,0,"G","",	"mv_par05","","","","","CB5","" } ) 
//AADD(	aSx1,{ cPerg,"15","Qual posicao?      "  ,"","","mv_chF","N",08,0,0,"C","","mv_par15","Analítico","","","","","Sintético","","","","","","","","","","","","","","","","","","","",""})

If SX1->X1_GRUPO != cPerg
	For I := 1 To Len( aSx1 )
		If !SX1->( DBSeek( aSx1[I][1] + aSx1[I][2] ) )
			Reclock( "SX1", .T. )
			SX1->X1_GRUPO		:= aSx1[i][1] //Grupo
			SX1->X1_ORDEM		:= aSx1[i][2] //Ordem do campo
			SX1->X1_PERGUNT		:= aSx1[i][3] //Pergunta
			SX1->X1_PERSPA		:= aSx1[i][3] //Pergunta Espanhol
	   		SX1->X1_PERENG		:= aSx1[i][3] //Pergunta Ingles
			SX1->X1_VARIAVL		:= aSx1[i][4] //Variavel do campo
			SX1->X1_TIPO		:= aSx1[i][5] //Tipo de valor
			SX1->X1_TAMANHO		:= aSx1[i][6] //Tamanho do campo
			SX1->X1_DECIMAL		:= aSx1[i][7] //Formato numerico
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre seleo do combo
			SX1->X1_GSC			:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Definies do combo-box
			SX1->X1_DEF02		:= aSx1[i][12]
			SX1->X1_DEF03		:= aSx1[i][13]
			SX1->X1_DEF04		:= aSx1[i][14]
			SX1->X1_VALID		:= aSx1[i][15]
			SX1->X1_F3			:= aSx1[i][16]
			MsUnlock()
		Endif
	Next
Endif

RestArea(aRea)

Return(cPerg)		

