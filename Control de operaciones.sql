USE [Platform]
GO

SELECT * FROM [dbo].[dvWMCTickets];

/*
REPORTE: CONTROL DE OPERACIONES
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
	[dvWMCTickets].[ticket_id] AS "Ticket ID", 
	[dvWMCTickets].[ticket_name] "Ticket Name", 
	[dvWMCPatients].[first_name] AS "Patient's First Name", 
	[dvWMCPatients].[last_name] AS "Patient's Last Name", 
	[dvWMCTickets].[ticket_state] AS "Case status",
	[dvWMCTickets].[city] AS "City",
	[dvWMCTickets].[state] AS "State",
	[dvWMCTickets].[country_of_assistance] AS "Country of Assistance",
	[dvWMCClients].[company_name] AS "Client Name", 
	[dvWMCTickets].[fee_type] AS "Fee Type", 
	[dvWMCTickets].[case_type] AS "Case Type", 
	[dvWMCTickets].[chief_complaint] "Chief Complaint History/Sings&Symptoms", 
	[dvWMCTickets].[provider_Institution] AS "Provider", 
	[dvWMCTickets].[provider_name] AS "Institution", 
	[dvWMCTickets].[date_of_event_ocurrencia] AS "Date of event/ocurrencia", 
	[dvWMCTickets].[date_of_service] AS "Date of Service", 
	[dvWMCTickets].[currency_estimate_to_client] AS "Currency Estimate to client", 
	[dvWMCTickets].[estimate_to_client] AS "Estimate to client", 
	[dvWMCTickets].[pax_in_ofac] AS "Pax in OFAC", 
	[dvWMCTickets].[voucher_upload] AS "Voucher",
	[dvWMCPatients].[member_id] AS "Member ID", 
	[dvWMCPatients].[issuing_date] AS "Issuing Date (dd/mm/yyyy)", 
	[dvWMCPatients].[effective_date] AS "Effective Date (dd/mm/yyyy)", 
	[dvWMCPatients].[term_date] AS "Term Date (dd/mm/yyyy)", 
	[dvWMCPatients].[plan] AS "Plan",
	[dvWMCPatients].[issuance_country] AS "Issuance Country",
	[dvWMCTickets].[medical_reports_included] AS "Med. Rec. Incl.",
	[dvWMCTickets].[courtesy] AS "Courtesy", 
	[dvWMCPatients].[document_number] AS "Document number",
	[dvWMCTickets].[coo_apertura] AS "Coo de apertura",
	[dvWMCTickets].[auditoria_medica_auditor] AS "Auditoría médica / Auditor", 
	[dvWMCTickets].[ticket_type] AS "Ticket type",
	[dvWMCTickets].[ticket_father_id] AS "Ticket Father ID",
	[dvWMCTickets].[personal_information_upload] AS "Personal Information",
	[dvWMCTickets].[service_survey] AS "Service survey", 
	[dvWMCTickets].[received_via] AS "Received via", 
	[dvWMCPatients].[email] AS "Patients Email", 
	[dvWMCTickets].[currency_paid_by_credit_card] AS "Currency Paid by CREDIT CARD", 
	[dvWMCTickets].[amount_paid_by_credit_card] AS "Amount Paid by CREDIT CARD",
	[dvWMCTickets].[preexistence] AS "Preexistence"
	FROM [dbo].[dvWMCTickets]
	JOIN [dbo].[dvWMCPatients] on [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]
	JOIN[dbo].[dvWMCClients] on [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
	order by ticket_id desc;
GO


--CODIGO DE DUPLICADOS
/*
SELECT [dvWMCTickets].[ticket_id], COUNT([dvWMCTickets].[ticket_id]) AS [Cantidad de Duplicados]
FROM [dbo].[dvWMCTickets]
JOIN [dbo].[dvWMCPatients] ON [dbo].[dvWMCTickets].[patient_id] = [dbo].[dvWMCPatients].[id]
JOIN [dbo].[dvWMCClients] ON [dbo].[dvWMCTickets].[client_id] = [dbo].[dvWMCClients].[id]
GROUP BY [dvWMCTickets].[ticket_id]
HAVING COUNT([dvWMCTickets].[ticket_id]) > 1
ORDER BY [dvWMCTickets].[ticket_id];
*/