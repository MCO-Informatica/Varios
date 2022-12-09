#include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³A030Copia ³Autor  ³Larson Zordan          ³Data  ³17/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ativa o sem foro informado que, na inclus„o, ser  usado     ³±±
±±³          ³o cliente corrente como modelo para o cliente novo.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.     	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao de Projetos                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cosme da	   |19/08/2008|Alteracao do codigo para copiar o cadastro de  ³±±
±±³Silva Nunes |          |cliente.                                       ³±±
±±³	     	   |          |	                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A030Copia()

Local aArea   	:= { Alias(), IndexOrd(), Recno() }
Local nPosSA1 	:= aArea[3]
//Local aRots 	:= AClone(aRotina)
Local lContinua	:= .T.

nSaveSX8:= GetSX8Len()

//aRotina := { { OemtoAnsi("Copia") ,"A030Copia" , 0, 3, 0, .F. }}           //"Copia"

If xFilial("SA1") # SA1->A1_FILIAL .or. (SA1->(EOF()) .and. SA1->(BOF()))
	HELP(" ",1,"ARQVAZIO")
	lContinua := .F.
Endif

If lContinua
	lCopia := .T.
	//A030Inclui("SA1",nPosSA1,1)//1  soh funciona no cadastro de produtos
    
    cCodCli  := GetSxeNum("SA1","A1_COD")
    cLojaCli := "01"
    
    aCamposSA1 := SA1->( DbStruct() )
    aDadosSA1  := {}
    aParam1    := {}
    
    lOpc := ParamBox( {	{1,"Codigo" ,cCodCli,"@!","","","",6,.F.},{1,"Loja",cLojaCli,"@!","","","",2,.F.}}, "Copia Cliente", @aParam1)  
    
    IF SA1->( DbSeek( xFilial("SA1")+cCodCli+cLojaCli,.F.))
       AVISO("Atencao","Codigo de Cliente já Cadastrado!",{"Retornar"},2,"Copia Cliente")
       Return
    ENDIF
       
    IF lOpc 
	    cCodCli  := MV_PAR01
	    cLojaCli := MV_PAR02
	    For nIxb := 1 To Len(aCamposSA1)
	        IF ! Alltrim(Len(aCamposSA1[nIxb,1])) $ "A1_COD|A1_LOJA"
	           AADD(aDadosSA1,{aCamposSA1[nIxb,1],SA1->( FieldGet( FieldPos(aCamposSA1[nIxb,1]))) })
	        ENDIF
	    Next       
	    RecLock("SA1",.T.)
	    For nIxb := 1 To Len( aDadosSA1 )
	        FieldPut( FieldPos( aDadosSA1[nIxb,1]),aDadosSA1[nIxb,2])    
	    Next
	    _FIELD->A1_COD  := cCodCli    
	    _FIELD->A1_LOJA := cLojaCli    
	    MSUnLock()              
	    nPosSA1 := Recno()
	    
	    If  __lSX8 
	        While (GetSX8Len() > nSaveSX8)
	            ConfirmSX8()
	        End
		Else
		       RollBackSX8()
		Endif
	    
	    A030Altera("SA1",nPosSA1,4)
		dbSelectArea( aArea[1] )
		dbSetOrder( aArea[2] )                             
		lCopia := .F.
    ELSE
	    RollBackSX8()
	ENDIF
    
EndIf

Return(.T.)