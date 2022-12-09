#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CHQALM    ºAutor  ³ROBSON BUENO        º Data ³  19/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para Verificacao e cadastro de Almoxarifado        º±±
±±º          ³com base em demanda                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CHQALM()             
  Local aAreaAtu	:= GetArea()
  Local nPProduto	:= aScan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"} )
  Local nPAlmo  	:= aScan(aHeader,{|x| Trim(x[2]) == "C6_LOCAL"} )
  Local lRet		:=.T.
  dbSelectArea("SB2")
  cEntr		:=xfilial("SB2")
  dbSetOrder(1)
  If !MsSeek(cEntr+aCols[n,nPProduto]+aCols[n,nPAlmo],.F.)
	TONE(3500,1)
    If MsgYesNo("Deseja Criar Almoxarifado:-->"+ aCols[n,nPAlmo] + "   Para o Produto:-->" +aCols[n,nPProduto]) 
      CriaSB2(aCols[n,nPProduto],aCols[n,nPAlmo],cEntr)
	Else
	  lRet:=.F.
	EndIf             
  EndIf	
  RestArea(aAreaAtu)

Return lRet 
                    
 