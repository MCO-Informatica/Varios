#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'


user function tstCont()
    local cEmpSF     as character    
    local cFilSF     as character 
    local cIntervalo as character  
    local cTimeIni   as character
    local cTimeEnd   as character
    local cSFJob     as character
    local cViewName  as character 
    local cFunTit    as character

    cEmpSF     := "01"
    cFilSF     := "01"
    cIntervalo := "00:01"
    cTimeIni   := "00:00"
    cTimeEnd   := "24:00"  
    cSFJob     := "ORDERS_69100"     //"ACCOUNTS_69100"   //"PRODUCTS_69100"     //"ORDERS_69100" //
    cViewName  := "SD2_SALESORDERDETAIL_69100_FT"  //"SA1_ACCOUNT_69100"//"SB1_PRODUCT_69100" //"SC5_SALESORDER_69100" //SD2_SALESORDERDETAIL_69100_FT  

    u_SFEXTCTL (cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,;
       cSFJob, cViewName) 
    //u_SFEXPCTL (cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd) 
    //u_SFGETCTL(cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd) 
    //u_SFIMPCTL(cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd) 
    //U_SFINRCTL(cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd) 
return


user function tstMVCSA1()
    Local aButtons as array
    local nOpc     as numeric

    oModelSA1 :=  FWLoadModel("CRMA980") 
    oModelSA1:setOperation( MODEL_OPERATION_INSERT)
    oModelSA1:activate()


    oModelSA1:getModel("SA1MASTER"):setValue("A1_NOME", "TESTE_MVC")

    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

    nOpc := MODEL_OPERATION_UPDATE
    

    FWExecView('','CRMA980', nOpc, , { || .T. }, , ,aButtons,,,,oModelSA1 )
    


return