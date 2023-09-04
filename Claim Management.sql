USE [Platform]
GO
/*
REPORTE: CLAIM MANAGEMENT
TABLAS CONECTADAS: Claims, ClaimItems, Tickets, Clients, TicketClaimItem, Patients
PIVOT: claim_number de Claims con claim_number de ClaimItems - id de ClaimItems con claimitem_id de TicketClaimItem - 
ticket_id de TicketClaimItem con id de Tickets - client_ide de Tickets con id de Clients - provider_id de Tickets con id de ServiceProviders
patient_id de Tickets con id de Patients
COLUMNAS POR TABLA: 
	1) Claim: created_on, total_claim_amount, claim_number, claim_date, currency, total_claim_amount, due_date, total_payment, total_claim_amount,
	facturado_por_bdx, version_bdx, billed_amount, exchange_rate
	2) Claim Items: payment_date, date_of_service, complaint, complaint_otros, complaint_resolve, claim_item_description, payment_date, 
	payment_amount, payment_currency, payment_exchange_rate
	3) Tickets: ticket_id, fee_type, cancellation_reason, rejection_reason, country_of_assistance, state, city, provider_Institution, tope, back_office,
	ticket_state
	4) Clients: company_name
	5) Patients: first_name, last_name
	COLUMNAS FALTANTES: user, provider, state changed on, estado de claim, full names, case status, mr upload,
	Negotiated due date, Negotiated amount, Last state change, Back office

*/
-- Conexión entre Claims y ClaimItems --> claim_number

SELECT [dvWMCClaims].[created_on] AS "Creation Date",
	[dvWMCClaims].[last_state_change_account] AS "User",
	[dvWMCServiceProviders].[institution_name] AS "Provider",
	[dvWMCClaims].[total_claim_amount] AS "Claim Amount",
	[dvWMCClaims].[claim_number] AS "Claim Number",
	[dvWMCClaims].[claim_date] AS "Claim Date",
	[dvWMCClaims].[currency] AS "Claim Currency",
	[dvWMCClaims].[total_claim_amount] AS "Claim Amount in local Currency",
	[dvWMCClaims].[due_date] AS "Expiration Date",
	[dvWMCClaims].[last_state_change_date] AS "State Changed On",
	[dvWMCClaims].[total_payment] AS "Payment Cycle",
	[dvWMCClaims].[state] AS "Estado de claim",
	[dvWMCClaims].[total_claim_amount] AS "Monto Claim Item Asociado", -- ¿Esta bien?
	[dvWMCTickets].[ticket_id] AS "Ticket ID",
	[dvWMCClaimItems].[payment_date] AS "Payed on",
	[dvWMCTickets].[reportado] AS "Reportado",
	[dvWMCTickets].[fee_type] AS "Fee type",
	[dvWMCTickets].[medical_reports_included] AS "Medical Reports Included",
	[dvWMCClients].[company_name] AS "Client",
	CONCAT([dvWMCPatients].[first_name], ' ', [dvWMCPatients].[last_name]) AS "Full name", -- Hay error
	[dvWMCClaimItems].[date_of_service] AS "Date of service",
	[dvWMCTickets].[ticket_state] AS "Case Status",
	[dvWMCTickets].[cancellation_reason] AS "Cancellation reason",
	[dvWMCTickets].[rejection_reason] AS "Rejection reason",
	[dvWMCTickets].[country_of_assistance] AS "Country of Assistance",
	[dvWMCTickets].[state] AS "State",
	[dvWMCTickets].[city] AS "City",
	[dvWMCTickets].[provider_Institution] AS "Institution",
	[dvWMCTickets].[tope] AS "Tope",
	[dvWMCTickets].[mr_upload_date] AS "Mr upload",
	[dvWMCClaimItems].[complaint] AS "Complaint",
	[dvWMCClaimItems].[complaint_otros] AS "Complaint (Otros)",
	[dvWMCTickets].[ticket_father_id] AS "Ticket Padre",
	[dvWMCClaims].[facturado_por_bdx] AS "Facturado por bdx",
	[dvWMCClaims].[mes_bdx] AS "Mes BDX",
	[dvWMCClaims].[anio_bdx] AS "Año BDX",
	--[dvWMCClaims].[version_bdx] AS "Version bdx" --> paso a ser Mes BDX y Año BDX
	[dvWMCClaims].[billed_amount] AS "Billed amount",
	[dvWMCClaimItems].[complaint_resolve] AS "Complaint Resolve",
	[dvWMCClaims].[exchange_rate] AS "Exchange rate",
	[dvWMCClaimItems].[claim_item_description] AS "Claim item description", 
	-- Borre claim description
	[dvWMCClaimItems].[payment_date] AS "Payment Date",
	[dvWMCClaimItems].[payment_amount] AS "Payment Amount",
	[dvWMCClaimItems].[payment_currency] AS "Payment Currency",
	[dvWMCClaimItems].[payment_exchange_rate] AS "Payment Exchange rate",
	[dvWMCClaims].[negotiated_due_date] AS "Negotiated due date",
	[dvWMCClaims].[negotiated_amount] AS "Negotiated amount",	
	[dvWMCClaims].[last_state_change_account] AS "Last state change",		
	[dvWMCTickets].[back_office] AS "Back office"
FROM [dbo].[dvWMCClaims]
JOIN [dbo].[dvWMCClaimItems] ON [dbo].[dvWMCClaims].[claim_number] = [dbo].[dvWMCClaimItems].[claim_number]
LEFT JOIN [dbo].[dvWMCTicketClaimItem] ON [dbo].[dvWMCClaimItems].[id] = [dbo].[dvWMCTicketClaimItem].[claimitem_id]
LEFT JOIN [dbo].[dvWMCTickets] ON [dbo].[dvWMCTicketClaimItem].[ticket_id] = [dbo].[dvWMCTickets].[id]
LEFT JOIN [dbo].[dvWMCClients] ON [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
LEFT JOIN [dbo].[dvWMCServiceProviders] ON [dbo].[dvWMCTickets].[provider_id] = [dbo].[dvWMCServiceProviders].[id]
LEFT JOIN [dbo].[dvWMCPatients] ON [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]