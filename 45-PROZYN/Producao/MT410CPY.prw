#INCLUDE "PROTHEUS.CH"
//#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410CPY  ºAutor  Ronaldo Robes       º Data ³  05/17       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsavel para efetuar a cópia dos pedido de vendaº±±
±±º          ³ 						                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT410CPY
Local aAreaAtu := GetArea() 
Local aAreaC5  := SC5->(GetArea()) 
Local aAreaC6  := SC6->(GetArea())
Local cDescPr  := " "
Local ny := 0
Local aOrigAnt  := {}

//U_RUNTRIGC6()   -comentado por Deo em 23/04/18 - juntei os fontes eliminando o arquivo Runtrigsc5
  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerto dos campos do cabeçalho do pedio para nao ³
//³levar dados incorreto na copia                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->C5_DTLANC := dDatabase                  
M->C5_HORAINC := TIME()
M->C5_USUARIO:=  USRRETNAME(__CUSERID)
M->C5_FECENT := Ctod("  /   /    ")
M->C5_DTEXP := Ctod("  /   /    ")
M->C5_ALTDT := Ctod("  /   /    ")                  
M->C5_ALTHORA := ""
M->C5_ALTUSER := ""
M->C5_PESOL := 0
M->C5_PBRUTO := 0 
M->C5_VOLUME1 := 0 
M->C5_TXREF := 0  
M->C5_TXMOEDA := RecMoeda(M->C5_EMISSAO,M->C5_MOEDA)           
M->C5_ESPECI1 := SPACE(TAMSX3("C5_ESPECI1")[1])
M->C5_NUMPCOM := "" 
M->C5_DTCOL := Ctod("  /   /    ")
M->C5_NUMCOL :=""
M->C5_XBLQFIN := ""
M->C5_XBLQMRG := ""
// M->C5_XBLQMIN := ""
M->C5_NATUREZ	:= SPACE(TAMSX3("C5_NATUREZ")[1]) 
M->C5_YTPBLQ := ""
M->C5_BLQ := ""
M->C5_LGLIBCO := ""
AtuCpoPv()                   

For nY := 1 to Len(acols) 
	//ID0089 - Retirado por incompatibilidade com a release 12.1.017  
	//If ExistTrigger('C6_PRODUTO') 
	//	M->C6_PRODUTO := acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})]
	//	RunTrigger(2,nY,nil,,'C6_PRODUTO')
	//EndIf  
	
	cDescPr  := POSICIONE("SB1",1,xFilial("SB1")+acols [nY,2],"B1_DESC")

//	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})] := cCodPro
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DESCRI"})]  := cDescPr
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTEXPED"})] := Ctod("  /   /    ")
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOTECTL"})] := ""
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_NUMPCOM"})] := ""
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCALIZ"})] := ""
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_XPRCNET"})] := 0
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})] := 0
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTVALID"})] := Ctod("  /   /    ")
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRUNIT"})] := acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRCVEN"})]
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_XNFVEN"})] := ""
	//acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_XNFVITE"})] := ""
	aAdd(aOrigAnt, {acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})],acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CLASFIS"})]}) 

	cDescPr := " "

Next     


If FindFunction("XFciAtuOrigem") //ID00283-Carlos Cavid
	XFciAtuOrigem(aCols,aHeader)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ID0430 - Verificar mensagem de alerta ao copiar pedido para alertar somente quando houver alteração do código da FCI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY := 1 to Len(acols) 
	
	If aOrigAnt[nY][2] <> acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CLASFIS"})]  
	     Aviso(ProcName()+" - Atençao!!!","Produto "+ aOrigAnt[nY][1] + " mudou de faixa na FCI, revise o preço de venda",{"Ok"})
	EndIf
	
Next     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação da natureza³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*SX3->(DbSetOrder(2)) //X3_CAMPO  
__ReadVar := "C5_NATUREZ"
If SX3->(DbSeek("C5_NATUREZ"))
	lValidNat := &(SX3->X3_VALID) .AND. iIf(!Empty(SX3->X3_VLDUSER),&(SX3->X3_VLDUSER),.T.) //Existcpo("SED") .And. MafisGet("NF_NATUREZA")    
    If !lValidNat 
    	//Aviso(ProcName()+ " - Atenção!", "Natureza "+M->C5_NATUREZ + " invalida. Favor informar outra natureza.",{"Ok"})
        M->C5_NATUREZ := Space(TAMSX3("C5_NATUREZ")[1])
    EndIf
EndIf
*/

SX3->(DbSetOrder(1))

U_VALIDVEND() 

RestArea(aAreaC5)
RestArea(aAreaC6)
RestArea(aAreaAtu)
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuCpoPv		ºAutor  ³Microsiga	     º Data ³  15/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização de campos do pedido de venda antes de iniciar a º±±
±±º          ³tela                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCpoPv()

Local aArea := GetArea()

If INCLUI .Or. ALTERA
	M->C5_YESPPES := .F.
EndIf

RestArea(aArea)
Return
