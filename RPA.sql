USE [Platform]
GO

/*
REPORTE: RPA
TABLAS CONECTADAS: Tickets, Patients, Clients, Claims, Claims items
PIVOT: Patient_id de Tickets con id de Patients - Client_id de Tickets con id de Clients - id de Tickets con ticket_id de TicketClaimItem
claim_number de Claims con claim_number de ClaimItem
COLUMNAS POR TABLA: 
	1) Tickets: ticket_state, ticket_id, created_on, fee_type, case_type, chief_complaint, icd10, country_of_assistance, state, city, provider_name
	cost_in_usd, reserve_in_usd, voucher_upload, medical_reports_included, estimate_to_client, reportado, back_office, clients_reference_number
	date_of_event_ocurrencia, date_of_service, back_office, ticket_type, ticket_father_id, tope, currency_paid_by_credit_card, amount_paid_by_credit_card
	cancellation_reason, bordereaux_status, rejection_reason, preexistence, other_icd10_code, hero_ticket_id
	2) Clients: company_name
	3) Patients: date_of_birth, member_id, issuing_date, plan, effective_date, term_date, policy_id, email, 
	4) Claims: total_claim_amount, currency, exchange_rate, issuance_country
COLUMNAS FALTANTES: document, Area of assistance, provider claim, Comprobante de transferencia
*/
SELECT 	[dvWMCTickets].[ticket_state] AS "Case status",
	[dvWMCTickets].[ticket_id] AS "Ticket ID", 
	[dvWMCClients].[company_name] AS "Client",
	--document
	CONCAT([dvWMCPatients].[first_name], ', ', [dvWMCPatients].[last_name]) AS "Full name", 
	[dvWMCPatients].[date_of_birth] AS "Date of birth",
	[dvWMCPatients].[member_id] AS "Member ID",
	[dvWMCPatients].[issuing_date] AS "Issuing date",
	[dvWMCPatients].[plan] AS "Plan",
	[dvWMCPatients].[effective_date] AS "Effective date (dd/mm/yyyy)",
	[dvWMCPatients].[term_date] AS "Term date (dd/mm/yyyy)",
	[dvWMCTickets].[created_on] AS "Creation Date & Time (GMT-3)",
	MONTH([dvWMCTickets].[created_on]) AS "Month of creation",
	YEAR([dvWMCTickets].[created_on]) AS "Year of creation",
	[dvWMCTickets].[fee_type] AS "Fee Type", 
	[dvWMCTickets].[case_type] AS "Case Type",
	[dvWMCTickets].[chief_complaint] AS "Chief complaint",
	[dvWMCTickets].[icd10] AS "ICD10",
	--Area of assistance
	[dvWMCTickets].[country_of_assistance] AS "Country of Assistance",
	[dvWMCTickets].[state] AS "State",
	[dvWMCTickets].[city] AS "City",
	[dvWMCTickets].[provider_name] AS "Institution",
	[dvWMCClaims].[total_claim_amount] AS "Amount",
	[dvWMCClaims].[currency] AS "Currency",
	[dvWMCClaims].[exchange_rate] AS "Exchange rate",
	[dvWMCTickets].[cost_in_usd] AS "Cost in USD",
	[dvWMCTickets].[reserve_in_usd] AS "Reserve in USD",
	[dvWMCTickets].[voucher_upload] AS "Voucher",
	[dvWMCTickets].[medical_reports_included] AS "Medical Reports Included",
	[dvWMCTickets].[mr_upload_date] AS "MR upload",
	[dvWMCTickets].[claim_upload_date] AS "Claim upload",
	[dvWMCTickets].[estimate_to_client] AS "Estimate to client",
	[dvWMCTickets].[reportado] AS "Reportado",
	[dvWMCPatients].[issuance_country] AS "Issuance country",
	[dvWMCTickets].[back_office] AS "Back Office",
	--Provider claim
	--Comprobante de transferencia
	[dvWMCPatients].[policy_id] AS "Policy ID",
	[dvWMCTickets].[clients_reference_number] AS "Client Reference Number",
	[dvWMCPatients].[email] AS "Patient Email",
	[dvWMCTickets].[date_of_event_ocurrencia] AS "Date of event/ocurrencia",
	[dvWMCTickets].[date_of_service] AS "Date of service",
	[dvWMCTickets].[back_office] AS "Back Office",
	[dvWMCTickets].[ticket_type] AS "Ticket type",
	[dvWMCTickets].[ticket_father_id] AS "Ticket Father ID",
	[dvWMCTickets].[tope] AS "Tope",
	[dvWMCTickets].[currency_paid_by_credit_card] AS "Currency Paid by Credit Card",
	[dvWMCTickets].[amount_paid_by_credit_card] AS "Amount Paid by Credit Card",
	[dvWMCTickets].[cancellation_reason] AS "Cancellation Reason",
	[dvWMCTickets].[bordereaux_status] AS "Bordereaux status",
	[dvWMCTickets].[pc_upload] AS "PC upload",
	[dvWMCTickets].[ct_upload] AS "CT upload",
	[dvWMCTickets].[rejection_reason] AS "Rejection reason",
	[dvWMCTickets].[preexistence] AS "Preexistence",
	[dvWMCTickets].[other_icd10_code] AS "Other ICD10 code",
	[dvWMCTickets].[hero_ticket_id] AS "Hero Ticket ID",
	[dvWMCTickets].[modified_on] AS "Ticket modified on"
	FROM [dbo].[dvWMCTickets]
	JOIN [dbo].[dvWMCPatients] on [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]
	JOIN[dbo].[dvWMCClients] on [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
	LEFT JOIN [dbo].[dvWMCTicketClaimItem] ON [dbo].[dvWMCTicketClaimItem].[ticket_id] = [dbo].[dvWMCTickets].[id]
	LEFT JOIN [dbo].[dvWMCClaimItems] ON [dbo].[dvWMCTicketClaimItem].[claimitem_id] = [dbo].[dvWMCClaimItems].[id]
	LEFT JOIN [dbo].[dvWMCClaims] ON [dbo].[dvWMCClaimItems].[claim_number] = [dbo].[dvWMCClaims].[claim_number]
GO