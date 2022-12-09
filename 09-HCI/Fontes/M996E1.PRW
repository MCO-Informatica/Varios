/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M996E1   ³ Autor ³ Rogerio Leite         ³ Data ³26.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Processamento da apuracao do PIS/COFINS - Deducao do contas ³±±
±±³          ³a receber dos valores pagos por retencao                    ³±±
±±³          ³Filtrar apenas d acordo com a filial que ser quer Financeiro³±±
±±³          ³compratilhado e fiscal exclusivo.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Expc1: Filtro - AVOID MATA996 - Fiscal                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³MV_PAR07 - Filial Inicial                                   ³±±
±±³Parametros³MV_PAR08 - Filial Final                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                                          
User Function M996E1()

Local cFiltro996 := " E1_PREFIXO >= '   ' AND E1_PREFIXO <= 'zzz' "
Local cFilIni    := ""
Local cFilFim    := ""
Local nConsFil   := 2
AJUSTASX1()
     
If AllTrim(FunName(0)) == 'MATR906'
	Pergunte('MTR906',.F.)     
	nConsFil:= MV_PAR06
	cFilIni := MV_PAR07
	cFilFim := MV_PAR08
Else
	cFilIni := '  '
	cFilFim := 'ZZ'
Endif
 
If nConsFil == 1   
	If TcSrvType()<>"AS/400"
	   If cFilIni == '  '                     
	      cFiltro996 :=  " E1_PREFIXO >= '   ' "
	   Else
         cFiltro996 :=  " E1_PREFIXO >= '" + cFilIni + "0'"
	   Endif
	   *
		If cFilFim == 'ZZ'
			cFiltro996 +=  " And E1_PREFIXO <= 'zzz' "
		Else
         cFiltro996 += " And E1_PREFIXO <= '" + cFilFim + "Z'"
		Endif
	Endif           
Endif
 

Return cFiltro996
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³03.07.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}
Local cPerg	:=	PadR("MTA996",Len(SX1->X1_GRUPO))
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}
//
/*-----------------------MV_PAR05--------------------------*/
Aadd( aHelpPor, "Informe numero do livro a ser processado" )
Aadd( aHelpEng, "Ledger Book number                      " )
Aadd( aHelpSpa, "Numero del Libro Fiscal                 " ) 

PutSx1(cPerg, "05","Livro Selecionado","Livro Seleccionado"	,"Selected Book","mv_ch5","C",3,0,0,"G",  			, "   ","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ",aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR06--------------------------*/
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}
Aadd( aHelpPor, "Informe se deseja imprimir os valores   " )
Aadd( aHelpPor, "por filial, apresentando um resumo ao   " )
Aadd( aHelpPor, "final com o total das movimentacoes     " ) 
Aadd( aHelpEng, "Informe se deseja imprimir os valores   " )
Aadd( aHelpEng, "por filial, apresentando um resumo ao   " )
Aadd( aHelpEng, "final com o total das movimentacoes     " ) 
Aadd( aHelpSpa, "Informe se deseja imprimir os valores   " )
Aadd( aHelpSpa, "por filial, apresentando um resumo ao   " )
Aadd( aHelpSpa, "final com o total das movimentacoes     " ) 
PutSx1(cPerg, "06","Processa Filiais ?","Processa Filiais ?","Processa Filiais ?","mv_ch6","N",1,0,0,"C",,"","","","mv_par06","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","",""," ",aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR07--------------------------*/
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}
Aadd( aHelpPor, "Informe a filial inicial a ser          " )
Aadd( aHelpPor, "processada, caso deseje imprimir o      " )
Aadd( aHelpPor, "relatorio por filial.                   " ) 
Aadd( aHelpEng, "Informe a filial inicial a ser          " )
Aadd( aHelpEng, "processada, caso deseje imprimir o      " )
Aadd( aHelpEng, "relatorio por filial.                   " ) 
Aadd( aHelpSpa, "Informe a filial inicial a ser          " )
Aadd( aHelpSpa, "processada, caso deseje imprimir o      " )
Aadd( aHelpSpa, "relatorio por filial.                   " ) 
PutSx1(cPerg, "07","Da Filial ?","Da Filial ?","Da Filial ?","mv_ch7","C",2,0,0,"G",,"","","","mv_par07","","","","","","","","","","","","","","",""," ",aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR08--------------------------*/
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}
Aadd( aHelpPor, "Informe a filial final a ser            " )
Aadd( aHelpPor, "processada, caso deseje imprimir o      " )
Aadd( aHelpPor, "relatorio por filial.                   " ) 
Aadd( aHelpEng, "Informe a filial final a ser            " )
Aadd( aHelpEng, "processada, caso deseje imprimir o      " )
Aadd( aHelpEng, "relatorio por filial.                   " ) 
Aadd( aHelpSpa, "Informe a filial final a ser            " )
Aadd( aHelpSpa, "processada, caso deseje imprimir o      " )
Aadd( aHelpSpa, "relatorio por filial.                   " ) 
PutSx1(cPerg, "08","Ate Filial ?","Ate Filial ?","Ate Filial ?","mv_ch8","C",2,0,0,"G",,"","","","mv_par08","","","","","","","","","","","","","","",""," ",aHelpPor,aHelpEng,aHelpSpa)

Return 


