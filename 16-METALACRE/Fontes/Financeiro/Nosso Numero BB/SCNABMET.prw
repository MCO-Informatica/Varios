#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SCNABMET  ºAutor  ³Fabio Santos        º Data ³  23/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes utilizadas no CNAB da Folha de Pagamento           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºUso       ³ Metalacre                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SCNABMET(cTipo,_nTam)
//cTipo D=Muda a sequencia diariamente  I=Incremental

//Controle da Numeracao diaria
If UPPER(cTipo)=="D"
	//Caso nao exista a tabela, efetua criacao da mesma
	If !File("\SCNABC.DBF")
		aCampos:={}
		AADD(aCampos,{"SFIL  ","C",02,0})
		AADD(aCampos,{"SDATA ","D",08,0})
		AADD(aCampos,{"SNUM  ","N",02,0})
		cArqTMP := dbCreate("\SCNABC",aCampos)
	Endif
	//Abre o arquivo temporario
	dbUseArea(.T.,,"\SCNABC","TMP",.T.)
	Private cIndTMP := CriaTrab(Nil,.F.)
	//Cria chave de indexacao
	IndRegua("TMP",cIndTMP,"SFIL+DTOS(SDATA)",,,OemToAnsi("Criando Indice...") )
	
	dbSelectArea("TMP")
	If dbSeek(xFilial()+DTOS(dDataBase))
		cNumDia:=StrZero(TMP->SNUM+1,_nTam)
		//Altera o registro do dia
		RecLock("TMP",.F.)
		Field->SNUM := Val(cNumDia)
		MsUnLock("TMP")
	Else
		cNumDia:="00001"
		//Faz a gravacao do novo registro
		RecLock("TMP",.T.)
		Field->SFIL := xFilial()
		Field->SDATA:= dDataBase
		Field->SNUM := 1                                                          
		
		MsUnLock("TMP")
	EndIf
    dbSelectARea("TMP")
    dbCloseArea()
    Ferase(cIndTMP+OrdBagExt())
EndIf

//Controle da numeracao Incremental
If UPPER(cTipo)=="I"                 
//Busca numeracao sequencial do parametro
   dbSelectArea("SEE")
   If Empty(SEE->EE_SEQCNAB)
      cNumDia:=1
   Else
   	  cNumDia:=Soma1(SEE->EE_SEQCNAB,17)
   EndIf
//Atualiza Numeracao do Parametro
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
    Field->EE_SEQCNAB := cNumDia
	MsUnLock()
	cNumDia:=StrZero(Val(cNumDia),_nTam)
EndIf                           
Return(cNumDia)
