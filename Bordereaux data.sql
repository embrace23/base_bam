USE [Platform]
GO

/*
REPORTE: BORDEREAUX DATA
TABLAS CONECTADAS: Tickets, Patients, Clients
PIVOT: Patient_id de Tickets con id de Patients - Client_id de Tickets con id de Clients
COLUMNAS POR TABLA: 
	1) Tickets: created_on, ticket_id, ticket_name, city, state, country_of_assistance, fee_type, case_type, chief_complaint, provider_institution, provider_name, 
	date_of_event_ocurrencia, date_of_service, currency_estimate_to_client, estimate to_client, pax_in_ofac, voucher_upload, courtesy, 
	medical_reports_included, coo_apertura, auditoria_medica_auditor, ticket_type, ticket_father_id, personal_information_upload, service_survey, received_via, 
	preexistence, currency_paid_by_credit_card, amount_paid_by_credit_card, preexistence
	2) Patients: first_name, last_name, member_id, issuance_country, effective_date, term_date, plan, document_number, email
	3) Clients: company_name
*/
SELECT [dvWMCTickets].[created_on] AS "Creation Date & Time (GMT-3)", 
	[dvWMCClients].[company_name] AS "Client", 
	[dvWMCTickets].[ticket_id] AS "Ticket ID",
	[dvWMCTickets].[clients_reference_number] AS "Client Reference Number",
	[dvWMCTickets].[bordereaux_status] AS "Bordereaux status",
	[dvWMCTickets].[ticket_state] AS "Case status",
	[dvWMCTickets].[mr_aud] AS "MR",
	[dvWMCTickets].[final_invoices] AS "Final invoice",
	[dvWMCTickets].[personal_docs] AS "Personal docs",
	[dvWMCTickets].[repricing_status] AS "Repricing status",
	[dvWMCTickets].[fee_type] AS "Fee Type", 
	[dvWMCTickets].[case_type] AS "Case Type", 
	[dvWMCTickets].[country_of_assistance] AS "Country of Assistance",
	[dvWMCTickets].[provider_name] AS "Institution", 
	CONCAT([dvWMCPatients].[first_name], ', ', [dvWMCPatients].[last_name]) AS "Full name", 
	[dvWMCTickets].[tope] AS "Tope",
	[dvWMCTickets].[currency_estimate_to_client] AS "Currency Estimate to client", 
	[dvWMCTickets].[estimate_to_client] AS "Estimate to client", 
	[dvWMCTickets].[most_recent_bdx_update] AS "Most recent bdx update",
	--bdx cost
	[dvWMCTickets].[fee] AS "Currency cost WMC",
	[dvWMCTickets].[access_fee] AS "Cost WMC",
	[dvWMCTickets].[currency_paid_by_credit_card] AS "Currency Paid by CREDIT CARD", 
	[dvWMCTickets].[amount_paid_by_credit_card] AS "Amount Paid by CREDIT CARD",
	--claim amount usd
	[dvWMCClaims].[claim_number] AS "Claim number",
	[dvWMCClaims].[claim_date] AS "Claim Date",
	[dvWMCTickets].[modified_on] AS "Modified On",
	[dvWMCTickets].[date_of_event_ocurrencia] AS "Date of event/ocurrencia",
	[dvWMCTickets].[hero_ticket_id] AS "Hero Ticket ID",
	[dvWMCTickets].[cost_in_usd] AS "Cost in USD"
	[dvWMCTickets].[final_invoices_text] AS "Final invoices text",
	[dvWMCTickets].[personal_docs_text] AS "Personal docs text",
	FROM [dbo].[dvWMCTickets]
	JOIN [dbo].[dvWMCPatients] on [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]
	JOIN[dbo].[dvWMCClients] on [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
	LEFT JOIN [dbo].[dvWMCTicketClaimItem] ON [dbo].[dvWMCTicketClaimItem].[ticket_id] = [dbo].[dvWMCTickets].[id]
	LEFT JOIN [dbo].[dvWMCClaimItems] ON [dbo].[dvWMCTicketClaimItem].[claimitem_id] = [dbo].[dvWMCClaimItems].[id]
	LEFT JOIN [dbo].[dvWMCClaims] ON [dbo].[dvWMCClaimItems].[claim_number] = [dbo].[dvWMCClaims].[claim_number]
GO