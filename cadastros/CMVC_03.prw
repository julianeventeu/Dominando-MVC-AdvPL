#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_03()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB3')
	oBrowse:SetDescription('Cadastro de Disciplinas')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_03' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_03' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_03' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_03' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_03' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_03' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZB3 := FWFormStruct(1,"ZB3")

	oModel := MPFormModel():New("MD_DISC")
	oModel:SetDescription("Cadastro de Disciplinas")
	
	oModel:addFields('MASTERZB3',,oStruZB3)
	oModel:getModel('MASTERZB3'):SetDescription('Dados do DISC')
	
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB2:= FWFormStruct(2, 'ZB3')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_DISC' , oStrZB2,'MASTERZB3' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_DISC', 100)
	oView:SetOwnerView('FORM_DISC','BOX_FORM_DISC')
	
Return oView