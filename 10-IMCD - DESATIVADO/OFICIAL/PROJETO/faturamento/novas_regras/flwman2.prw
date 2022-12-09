#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"

User Function FLWMAN2()
local aAlias := GETAREA() 
Local cFiltro := " "

PRIVATE cAlias   := 'ZE1'
PRIVATE _cCpo  := "ZE1_FILIAL/ZE1_HAWD/ZE1_SEG/ZE1_ASSUNT/ZE1_DT_EMI/ZE1_DT_CON/ZE1_DT_PRO/ZE1_HORA/ZE1_USER"
PRIVATE cCadastro := "Follow-Ups"

If MsgYesNo("Deseja Filtrar o Processo selecionado? (SIM)-Filtrar (NAO)-Todos  ","Filtro")  
	cFiltro   := "ZE1_HAWB = '"+SW6->W6_HAWB+"'" 
	aRotina     := {{"Visualizar" , "U_flwvisu()"   , 0, 2 },;
                                       {"Concluir" , "U_flwConc()"   , 0, 4 },;
                                       {"Incluir Follow" , "U_FLWMAN1()"   , 0, 3 },;
                                       {"Legenda"   , "U_flwleg()", 0, 7, 0, .F. }}       

else
	cFiltro   := "ZE1_DT_CON = ' '" 
	aRotina     := {{"Visualizar" , "U_flwvisu()"   , 0, 2 },;
                                       {"Concluir" , "U_flwConc()"   , 0, 4 },;
                                       {"Legenda"   , "U_flwleg()", 0, 7, 0, .F. }}     
Endif	


aCores  := {{ 'ZE1->ZE1_DT_PRO > ddatabase .AND. EMPTY(ZE1->ZE1_DT_CON)' , 'BR_VERDE'  },;    
            { '!EMPTY(ZE1->ZE1_DT_CON)' , 'BR_CINZA' },;
            { 'ZE1->ZE1_DT_PRO == ddatabase .AND. EMPTY(ZE1->ZE1_DT_CON)'  , 'BR_AZUL' },;
            { 'ZE1->ZE1_DT_PRO < ddatabase .AND. EMPTY(ZE1->ZE1_DT_CON)' , 'BR_VERMELHO' }}    


dbSelectArea("ZE1")
dbSetOrder(1)

mBrowse( ,,,,"ZE1",,,,,,aCores,,,,,,,,cFiltro)

 
RestArea(aAlias)
RETURN NIL    

//user para legendas   -------------------------------- 

User Function flwleg()
   
   aLegenda := { { "BR_AZUL",     "Para a data Presente" },;
                 { "BR_VERDE",    "Dentro do Prazo"   },;
                 { "BR_CINZA",    "Encerrado"   },;
                 { "BR_VERMELHO",    "Atrasado"   }}
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )
   
Return .t.  
                                                        
//User para Visualizar ------------------------------

User function flwvisu()

AxVisual("ZE1",ZE1->(RECNO()),4)

RETURN NIL  

//User para concluir --------------------------------              

User function flwconc()

If MsgYesNo("Deseja Finalizar/Concluir o Follow-Up "+ Alltrim(ZE1->ZE1_HAWB)+ " - Sequencia "+ Alltrim(ZE1->ZE1_SEQ) ,"Conclusão")

RecLock("ZE1", .F.)	
	ZE1->ZE1_DT_CON:= ddatabase
MsUnLock() 

	Alert("Processo Concluído.")

endif

RETURN NIL  

