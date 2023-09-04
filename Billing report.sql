USE [Platform]

GO
/*
REPORTE: BILLING REPORT
TABLAS CONECTADAS: Tickets, Patients, Clients
PIVOT: Patient_id de Tickets con id de Patients - Client_id de Tickets con id de Clients - id de Tickets con ticket_id de TicketClaimItem
claimitem_id de TicketClaimItem con id de ClaimItems
COLUMNAS POR TABLA: 
	1) Tickets: ticket_id, ticket_name, clients_reference_number, cancellation_reason, rejection_reason, complaint_type, city, state, country_of_assistance
	bordereaux_status, fee_type, case_type, chief_complaint, provider_Institution, provider_name, moneda_tope, estimate_to_client
	reserve_in_usd, amount_paid_by_credit_card, deductible, medical_reports_included, courtesy, coo_apertura, auditoria_medica_auditor, ticket_type
	ticket_father_id, tope, received_via, ticket_state
	1) Patients: first_name, last_name, member_id, document_number, issuance_country, email, service_survey
	3) ClaimItems: claim_number, amount, date_of_service
	4) Clients: company_name
*/
SELECT [dvWMCTickets].[created_on] AS "Creation Date & Time (GMT-3)",
	[dvWMCTickets].[completation_date] AS "Completion date",
	[dvWMCTickets].[ticket_id] AS "Ticket ID", 
	[dvWMCTickets].[ticket_name] AS "Ticket Name",
	[dvWMCTickets].[clients_reference_number] AS "Client Ref. Number",
	[dvWMCPatients].[first_name] AS "Patient's First Name", 
	[dvWMCPatients].[last_name] AS "Patient's Last Name", 
	[dvWMCTickets].[ticket_state] AS "Case status",
	[dvWMCTickets].[cancellation_reason] AS "Cancellation reason", 
	[dvWMCTickets].[rejection_reason] AS "Rejection reason",
	[dvWMCPatients].[date_of_birth] AS "Patient DOB",
	[dvWMCTickets].[complaint_type] AS "Complaint Type",
	[dvWMCClaimItems].[claim_number] AS "Claim Number",
	[dvWMCClaimItems].[amount] AS "Claim item amount",
	[dvWMCClaims].[state] AS "Claim status",
	[dvWMCTickets].[city] AS "City",
	[dvWMCTickets].[state] AS "State",
	[dvWMCTickets].[country_of_assistance] AS "Country of Assistance",
	[dvWMCTickets].[bordereaux_status] AS "Bordereaux status",
	[dvWMCClients].[company_name] AS "Client",
	[dvWMCTickets].[fee_type] AS "Fee type",
	[dvWMCTickets].[case_type] AS "Case type",
	[dvWMCTickets].[chief_complaint] "Chief Complaint History/Sings&Symptoms", 
	[dvWMCTickets].[provider_Institution] AS "Provider", 
	[dvWMCTickets].[provider_name] AS "Institution", 
	[dvWMCServiceProviders].[mobile_phone] AS "Provider's phone number",
 	[dvWMCClaimItems].[date_of_service] AS "Date of Service",
	[dvWMCTickets].[moneda_tope] AS "Moneda",
	[dvWMCTickets].[estimate_to_client] AS "Estimate to client",
	[dvWMCTickets].[reserve_in_usd] AS "Reserve",
	[dvWMCTickets].[amount_paid_by_credit_card] AS "Paid by Credit Card",
	[dvWMCTickets].[deductible] AS "Deductible",
	[dvWMCTickets].[medical_reports_included] AS "Med. Rec. Incl.",
	[dvWMCPatients].[member_id] AS "Member ID",
	[dvWMCTickets].[courtesy] AS "Courtesy",
	[dvWMCPatients].[document_number] AS "Document Number",
	[dvWMCTickets].[coo_apertura] AS "Coo de apertura",
	[dvWMCTickets].[auditoria_medica_auditor] AS "Auditoría médica / Auditor",
	[dvWMCTickets].[ticket_type] AS "Ticket type",
	[dvWMCTickets].[ticket_father_id] AS "Ticket Father ID",
	[dvWMCTickets].[tope] AS "Tope",
	[dvWMCTickets].[received_via] AS "Received via",
	[dvWMCPatients].[issuance_country] AS "Issuance country",
	[dvWMCPatients].[email] AS "Patient’s email",
	[dvWMCTickets].[service_survey] AS "Service survey"
	FROM [dbo].[dvWMCTickets]
	JOIN [dbo].[dvWMCPatients] on [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]
	JOIN[dbo].[dvWMCClients] on [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
	JOIN [dbo].[dvWMCServiceProviders] ON [dbo].[dvWMCTickets].[provider_id] = [dbo].[dvWMCServiceProviders].[id]
	LEFT JOIN [dbo].[dvWMCTicketClaimItem] ON [dbo].[dvWMCTicketClaimItem].[ticket_id] = [dbo].[dvWMCTickets].[id]
	LEFT JOIN [dbo].[dvWMCClaimItems] ON [dbo].[dvWMCTicketClaimItem].[claimitem_id] = [dbo].[dvWMCClaimItems].[id]
	JOIN [dbo].[dvWMCClaims] ON [dbo].[dvWMCClaimItems].[claim_number] = [dbo].[dvWMCClaims].[claim_number]
	order by [Claim Number]
GO