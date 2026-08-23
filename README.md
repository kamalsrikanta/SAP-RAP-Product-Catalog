# SAP RAP Product Catalog

A transactional SAP ABAP RESTful Application Programming Model (RAP) application for managing products through a SAP Fiori Elements UI.

## Features

- Product Create, Read, Update and Delete
- Managed RAP Draft
- Fiori Elements List Report and Object Page
- Price validation
- Automatic creation user and timestamp
- Submit for Approval
- Approve
- Reject with mandatory rejection reason
- Status-dependent action enablement
- Submission and approval timestamps
- OData V4 UI service

## Business Workflow

```text
NEW
 |
 | Submit for Approval
 v
SUBMITTED
 |          |
 | Approve  | Reject
 v          v
APPROVED   REJECTED
              |
              | Submit again
              v
           SUBMITTED
```

## RAP Architecture

```text
Fiori Elements UI
       |
       v
OData V4 UI Service Binding
       |
       v
Service Definition
       |
       v
Consumption CDS View
       |
       v
Interface CDS View
       |
       v
RAP Behavior Definition
       |
       v
Behavior Implementation
       |
       v
Persistence + Draft Tables
```

## Main Objects

| Object | Purpose |
|---|---|
| `ZCJ_PRODUCT` | Product persistence table |
| `ZCJ_PRODUCT_D` | Draft persistence table |
| `ZCJ_I_PRODUCT` | Interface/root CDS view |
| `ZCJ_C_PRODUCT` | Consumption/projection CDS view |
| `ZBP_CJ_I_PRODUCT` | Behavior implementation |
| `ZCJ_PRODUCT_SRV` | OData service definition |
| `ZCJ_PRODUCT_UI` | OData V4 UI service binding |
| Metadata Extension | Fiori Elements UI annotations |

## Product Fields

- Product ID
- Product Name
- Description
- Category
- Price
- Currency
- Stock
- Status
- Rejection Reason
- Created By / Created At
- Submitted At
- Approved By / Approved At
- Last Changed At

## RAP Behavior

### Standard Operations

```text
Create
Update
Delete
```

### Draft Operations

```text
Edit
Activate
Discard
Resume
Prepare
```

### Custom Actions

```text
submitForApproval
approve
reject
```

The actions use instance feature control so that only valid workflow actions are enabled for the current status.

## Status Rules

### Submit for Approval

Allowed for:

```text
NEW
REJECTED
```

### Approve

Allowed for:

```text
SUBMITTED
```

### Reject

Allowed for:

```text
SUBMITTED
```

## Validations

### Price

A save validation rejects:

```text
Price <= 0
```

with:

> Price must be greater than zero

### Rejection Reason

Rejecting a submitted product requires a rejection reason.

If it is empty, the application displays:

> Rejection reason is required.

## Automatic Creation Data

On creation, the determination initializes:

```text
CreatedBy
CreatedAt
Status = NEW
```

## Workflow Data

Submission records:

```text
Status = SUBMITTED
SubmittedAt
```

Approval records:

```text
Status = APPROVED
ApprovedBy
ApprovedAt
```

Rejection changes the status to:

```text
REJECTED
```

while retaining the rejection reason.

## Screenshots

### Service Binding

![Service Binding](screenshots/01-service-binding.png)

### Product List

![Product List](screenshots/02-product-list.png)

### Product Statuses

![Product Statuses](screenshots/04-product-list-statuses.png)

### Price Validation

![Price Validation](screenshots/03-price-validation.png)

### Draft / Edit

![Draft Edit](screenshots/05-draft-edit.png)

### Submitted Product

![Submitted Product](screenshots/06-product-submitted.png)

### Rejection Validation

![Rejection Validation](screenshots/07-rejection-validation.png)

### Rejected Product

![Rejected Product](screenshots/09-rejected-product.png)

### Product Object Page

![Product Object Page](screenshots/10-product-object-page.png)

## Technologies

- SAP ABAP
- ABAP RESTful Application Programming Model (RAP)
- CDS
- ABAP Behavior Definition
- ABAP Behavior Implementation
- OData V4
- SAP Fiori Elements
- Eclipse / ABAP Development Tools (ADT)

## Key RAP Concepts Demonstrated

1. Root CDS view entities
2. Projection/consumption CDS views
3. Managed RAP BO
4. Managed draft
5. Behavior definitions
6. Behavior implementation
7. Determinations
8. Validations
9. Instance feature control
10. Custom actions
11. Transactional query provider contract
12. OData V4 service definition
13. OData V4 UI service binding
14. Fiori Elements metadata annotations
15. ETag / last-changed handling

## Repository Structure

```text
ZCJ-Product-Catalog/
├── README.md
├── screenshots/
└── src/
    └── ABAP development objects
```

## Future Enhancements

- Role-based authorization
- Separate requester and approver users
- Email/approval notifications
- Additional business validations
- Value helps
- Reporting/analytics
- SAP BTP deployment documentation

## Project Status

**Completed**

The current application demonstrates the complete product lifecycle:

```text
Create
  ↓
Draft
  ↓
Validate
  ↓
Submit for Approval
  ↓
Approve / Reject
  ↓
Final Workflow Status
```
