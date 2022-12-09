#INCLUDE "PROTHEUS.CH"   

#Define GD_INSERT 1
#Define GD_UPDATE 2                                                                                                                       
#Define GD_DELETE 4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISP002  º Autor ³ Antonio Carlos       º Data ³  02/05/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pela manutenção dos campos referente aos ±±
±±º          ³ Tipos de Entrada/Saida (Tes) na tabela SBZ.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±             
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FISP002()

Local aArea		:= GetArea()
Local cAlias  	:= "SBZ"

Private aRotina    := {}
Private cCadastro  := "Manutencao Tipo Entrada/Saida - Indicador de Produtos"

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_Fisp02" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_Fisp02"			,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_Fisp02" 		,0,4 })
Aadd(aRotina,{"Excluir"  			,"U_Fisp02" 		,0,5 })

mBrowse( 7, 4,20,74,cAlias,,,,,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)    

User Function FISP02(cAlias,nReg,nOpc)

Private _cProd	:= SBZ->BZ_COD
Private aHeader	:= {}
Private aCols	:= {}
Private oGetDados	

If nOpc == 3 .Or. nOpc == 5
	MsgStop("Opcao indisponivel !")          
	Return(.F.)
EndIf

DbSelectArea("SX3")
SX3->( DbSetorder(1) )
MsSeek("SBZ")                         
While SX3->( !Eof() ) .And. (SX3->X3_ARQUIVO == "SBZ")
	
	If Alltrim(SX3->X3_CAMPO) $ "BZ_FILIAL/BZ_TE/BZ_TS/BZ_TE_FORN/BZ_TS_FORN/BZ_TEC/BZ_TSC"
		
		If (cNivel >= SX3->X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIf
	
	EndIf	
	
	SX3->( DbSkip() )
	
EndDo

DbSelectArea("SBZ")
SBZ->( DbsetOrder(2) )
SBZ->( Dbseek(_cProd) )
While SBZ->( !Eof() ) .And. SBZ->BZ_COD == _cProd
	
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY	:= 1 To Len(aHeader)
		If ( aHeader[nY][10] == "V" )
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		ElseIf Alltrim(aHeader[nY][2]) == "BZ_FILIAL"
			aCols[Len(aCols)][nY] := SBZ->BZ_FILIAL+"-"+Posicione("SM0",1,Substr(cNumEmp,1,2)+SBZ->BZ_FILIAL,"M0_FILIAL")									
		Else		
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		EndIf			
	Next nY
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
	SBZ->( DbSkip() )
	
EndDo

nStyle := GD_INSERT+GD_UPDATE+GD_DELETE

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 300, 650 PIXEL

oGetDados := MsGetDados():New(20, 10, 130, 310, nOpc, , , , .F., {"BZ_TE","BZ_TS","BZ_TE_FORN","BZ_TEC","BZ_TSC"}, , .F., 200, , , ,  , oDlg)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || AtuDados(),oDlg:End() }, { ||  oDlg:End() } )

Return

Static Function AtuDados()
      
For nX := 1 To Len(aCols)
			
	/*
	RecLock("SBZ",.F.)
	
	For nX2 := 1 To Len(oGetDados:aHeader)
		If ( oGetDados:aHeader[nX2][10] != "V" )
			FieldPut(FieldPos(oGetDados:aHeader[nX2][2]),oGetDados:aCols[nX][nX2])
		EndIf
	Next
				
	SBZ->( MsUnLock() )
	*/
	
	DbSelectArea("SBZ")
	SBZ->( DbSetOrder(1) ) 
	If SBZ->( DbSeek(Substr(aCols[nX][1],1,2)+_cProd ) )
		RecLock("SBZ",.F.)
		SBZ->BZ_TE		:= aCols[nX][2]
		SBZ->BZ_TS		:= aCols[nX][3]
		SBZ->BZ_TE_FORN	:= aCols[nX][4]
		SBZ->BZ_TEC		:= aCols[nX][5]
		SBZ->BZ_TSC		:= aCols[nX][6]
		SBZ->( MsUnLock() ) 
	EndIf	
							
Next nX

MsgInfo("Atualizacao efetuada com sucesso!")

Return