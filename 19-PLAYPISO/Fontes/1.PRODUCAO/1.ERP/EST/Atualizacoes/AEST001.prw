#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AEST001   ºAutor  ³Mauro Nagata        º Data ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao especial para gerar os movimentos necessarios para   º±±
±±º          ³duplicar os estoques entre as filiais.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento,documento}
User Function AEST001(pArray)

	Local aArray_MI := pArray
	/*
	aArray_MI[1] = quantidade
	aArray_MI[2] = custo
	aArray_MI[3] = ordem de producao
	aArray_MI[4] = local
	aArray_MI[5] = entidade
	aArray_MI[6] = recno/registro
	aArray_MI[7] = tipo de movimentacao                
	aArray_MI[8] = documento de entrada/saida       //[Mauro Nagata, Actual Trend, 19/11/2010]         
	
	Obs.posicionar o produto a ser movimentado no SB1 e selecionar a tabela SD3
	*/
	
	If !Auto240(aArray_MI) //rotina automatica do MATA240
	   MsgBox("Movimentação interna não gerada","A T E N Ç Ã O","INFO")
	   //envio de e-mail ao responsavel pelo gerenciamento desta movimentacoes internas especificas
	EndIf   

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Auto240    ³ Autor ³ Mauto Nagata          ³ Data ³ 17/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina automatica do MATA240                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Lisonda/Actual Trend                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function Auto240(pArray_240)

	Local aArray240 := pArray_240
	Local aMata240  := {	{"D3_TM"      , aArray240[7]		, Nil}, ;  //tipo de movimento
	                        {"D3_COD"     , SB1->B1_COD			, Nil}, ;  //codigo do produto
	                        {"D3_UM"      , SB1->B1_UM			, Nil}, ;  //unidade de medida
	                        {"D3_QUANT"   , aArray240[1]		, Nil}, ;  //quantidade
	                        {"D3_CUSTO1"  , aArray240[2]		, Nil}, ;  //custo
	                        {"D3_CONTA"   , SB1->B1_CONTA		, Nil}, ;  //conta contabil
					     	{"D3_OP"      , aArray240[3]		, Nil}, ;  //ordem de producao
					    	{"D3_LOCAL"   , aArray240[4]		, Nil}, ;  //local
							{"D3_DOC"     , aArray240[8]    	, Nil}, ;  //documento de entrada / saida
							{"D3_GRUPO"   , SB1->B1_GRUPO		, Nil}, ;  //grupo do produto
							{"D3_EMISSAO" , dDatabase			, Nil}, ;    //data da emissao                                            
							{"D3_XCHVDOC" , aArray240[5]+AllTrim(StrZero(aArray240[6],7))	, Nil}}  //documento (entidade + registro)  //[Incluida a linha] [Mauro Nagata, Actual Trend, 19/11/2010]
	Local   aArea_Corr  := GetArea()						
	Private lMsErroAuto := .F.
	Private lRet        := .T.	   
	
	//movimentar os estou da outra filial quando faturar e tiver movimentacao de estoque            
	cFilOld := cFilAnt
  //	cFilAnt := If(cFilAnt="04","02","04")   ACTUAL-23092016
		cFilAnt := If(cFilAnt="01","02","01")
	SM0->(MsSeek(cEmpAnt + cFilAnt))          
	 
	aArea_SB2 := SB2->(GetArea())
	dbSelectArea("SB2")
	dbSetOrder(1)
    If !dbSeek(xFilial("SB2")+SB1->B1_COD+aArray240[4])
		CriaSB2(SB1->B1_COD,aArray240[4])
		MsUnlock()
	EndIf                         
	RestArea(aArea_SB2)       
	                              
	aArea_SF5 := SF5->(GetArea())
	SF5->(DbSetOrder(1))
	SF5->(DbSeek(xFilial("SF5")+aArray240[7])) 
	
	aArea_SD3 := SD3->(GetArea())
	DbSelectArea("SD3")
    RecLock("SD3",.T.)
    SD3->D3_FILIAL  := xFilial("SD3")
    SD3->D3_TM      := aArray240[7]
    SD3->D3_COD     := SB1->B1_COD
    SD3->D3_UM      := SB1->B1_UM
    SD3->D3_QUANT   := aArray240[1]
    SD3->D3_CF      := If(SF5->F5_CODIGO="010","DE6",If(SF5->F5_CODIGO="510","RE0",If(SF5->F5_CODIGO="011","DE6",If(SF5->F5_CODIGO="511","RE6",""))))
    SD3->D3_CONTA   := SB1->B1_CONTA
    SD3->D3_OP      := aArray240[3]
    SD3->D3_LOCAL   := aArray240[4]
    SD3->D3_DOC     := aArray240[8]
    SD3->D3_EMISSAO := dDatabase
    SD3->D3_GRUPO   := SB1->B1_GRUPO
    SD3->D3_CUSTO1  := aArray240[2]     //b2_vatu1
//    SD3->D3_CUSTO2  :=
//    SD3->D3_CUSTO3  :=
//    SD3->D3_CUSTO4  :=
//    SD3->D3_CUSTO5  :=
//    SD3->D3_CC      :=
//    SD3->D3_PARCTOT :=
//    SD3->D3_ESTORNO :=
    SD3->D3_NUMSEQ  := ProxNum()
//    SD3->D3_SEGUM   :=
//    SD3->D3_QTSEGUM :=
    SD3->D3_TIPO    := SB1->B1_TIPO
//    SD3->D3_NIVEL   :=
    SD3->D3_USUARIO := Substr(cUsuario,7,15)
//    SD3->D3_REGWMS  :=
//    SD3->D3_PERDA   :=
//    SD3->D3_DTLANC  :=
//    SD3->D3_TRT     :=
//    SD3->D3_CHAVE   :=
//    SD3->D3_IDENT   :=
//    SD3->D3_SEQCALC :=
//    SD3->D3_RATEIO  :=
//    SD3->D3_LOTECTL :=
//    SD3->D3_NUMLOTE :=
//    SD3->D3_DTVALID :=
//    SD3->D3_LOCALIZ :=
//    SD3->D3_NUMSERI :=
//    SD3->D3_CUSFF1  :=
//    SD3->D3_CUSFF2  :=
//    SD3->D3_CUSFF3  :=
//    SD3->D3_CUSFF4  :=
//    SD3->D3_CUSFF5  :=
//    SD3->D3_ITEM    :=
//    SD3->D3_OK      :=
//    SD3->D3_ITEMCTA :=
//    SD3->D3_CLVL    :=
//    SD3->D3_PROJPMS :=
//    SD3->D3_TASKPMS :=  
//    SD3->D3_ORDEM   :=
//    SD3->D3_SERVIC  :=
//    SD3->D3_STSERV  :=
//    SD3->D3_OSTEC   :=
//    SD3->D3_POTENCI :=
//    SD3->D3_TPESTR  :=
//    SD3->D3_REGATEN :=
//    SD3->D3_DOCSWN  :=
//    SD3->D3_ITEMSWN :=
//    SD3->D_E_L_E_T_ :=
//    SD3->R_E_C_N_O_ :=
//    SD3->D3_ITEMGRD :=
//    SD3->D3_PMACNUT :=
//    SD3->D3_PMICNUT :=
//    SD3->D3_DIACTB  :=
//    SD3->D3_NODIA   :=
    SD3->D3_XCHVDOC := aArray240[5]+AllTrim(StrZero(aArray240[6],7))    
    SD3->(MsUnLock())

	//Restaurar a filial
	cFilant := cFilOld
	SM0->(MsSeek(cEmpAnt + cFilAnt))     
RestArea(aArea_SD3)			
RestArea(aArea_SF5)			
RestArea(aArea_Corr)
Return(lRet)