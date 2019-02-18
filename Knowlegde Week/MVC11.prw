#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC11
Exemplo de legenda no grid

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC11()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Aluno x Turma')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.MVC11' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.MVC11' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.MVC11' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.MVC11' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'         ACTION 'VIEWDEF.MVC11' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copia'     ACTION 'VIEWDEF.MVC11' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel := FWLoadModel("MVC05")
Local oStruZB7 := oModel:GetModel("DETAILZB7"):GetStruct()
Local aAux

    oStruZB7:DeActivate()
       
    aAux := FwStruTrigger( "ZB7_NOTA"     ,; // Campo Dominio       
    "LEGENDA"     ,; // Campo de Contradominio        
    "U_LegMVC11()") // Regra de Preenchimento     

    oStruZB7:AddField('Legenda', 'Legenda', 'LEGENDA', 'C', 20, 0, , , {}, .F., ;  
    FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVC011InitPad()"), .F., .F., .T., , )    

    oStruZB7:AddTrigger( ;   
                        aAux[1]  , ;    // [01] Id do campo de origem   
                        aAux[2]  , ;    // [02] Id do campo de destino   
                        aAux[3]  , ;    // [03] Bloco de codigo de validação da execução do gatilho   
                        aAux[4]  )      // [04] Bloco de codigo de execução do gatilho    

    oStruZB7:Activate()

Return oModel

Static Function ViewDef()
Local oView := FWLoadView("MVC05")
Local oStruZB7 := oView:GetSubView("FORM_NOTA"):GetStruct()

    oStruZB7:DeActivate()
    oStruZB7:AddField( 'LEGENDA','01','Legenda','Legenda',, 'Get' ,'@BMP',,,.F.,,,,,,.T.,, )    
    oStruZB7:Activate()

    oView:SetModel(ModelDef())

Return oView

User Function LegMVC11() 
Local oModel := FWModelActive() 
Local cImg := "br_amarelo_ocean.bmp"
Local nNota      
	
    If oModel:GetID() == "MD_TURMA_ALUNO" .And. oModel:IsActive()
        nNota := oModel:GetValue("DETAILZB7","ZB7_NOTA")            
        cImg := getImg(nNota)
    EndIf
	  
Return cImg

User Function MVC011InitPad()
Local cImg := ""

    If INCLUI 
        cImg := "br_amarelo_ocean.bmp"  
    Else
        cImg := getImg(ZB7->ZB7_NOTA)
    EndIf

Return cImg

Static Function getImg(nNota)
Local cImg

    If nNota >= 7   
        cImg := "br_verde_ocean.bmp"  
    Else   
        cImg := "BR_VERMELHO.BMP"  
    EndIf

Return cImg