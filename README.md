# SAP RAP Product Catalog & Approval Workflow

A transactional **SAP ABAP RESTful Application Programming Model (RAP)** application for managing products through a **SAP Fiori Elements** UI — built to demonstrate a full product lifecycle: managed draft handling, business validations, determinations, and a status-driven approval workflow (Submit → Approve/Reject).

![Status](https://img.shields.io/badge/status-completed%20prototype-brightgreen)
![ABAP](https://img.shields.io/badge/SAP-ABAP%20RAP-blue)
![OData](https://img.shields.io/badge/OData-V4-orange)

---

## 📑 Table of Contents

- [Overview](#-project-overview)
- [Skills Demonstrated](#-skills-demonstrated)
- [Key Features](#-key-features)
- [Business Workflow](#-business-workflow)
- [Architecture](#️-rap-architecture)
- [RAP Objects](#-rap-objects)
- [Data Model](#-product-data-model)
- [Business Logic](#-business-logic)
- [Instance Feature Control](#️-instance-feature-control)
- [Fiori Elements UI](#️-fiori-elements-ui)
- [Screenshots](#-screenshots)
- [How to Explore This Project](#-how-to-explore-this-project)
- [Repository Structure](#️-repository-structure)
- [Authorization](#-authorization)
- [Future Enhancements](#-future-enhancements)
- [Project Status](#-project-status)

---

## 📌 Project Overview

This project shows how a real-world transactional business application can be built end-to-end on the **SAP RAP programming model**, from database tables to a working Fiori Elements UI.

The application allows users to:

- Create and maintain products
- Work with products in draft mode
- Validate product data before saving
- Submit products for approval
- Approve or reject submitted products (with mandatory rejection reason)
- Have available actions automatically adapt to the product's current status
- Track full audit information — who created, submitted, and approved each record
- Access everything through a Fiori Elements List Report / Object Page, exposed via OData V4

---

## 🧠 Skills Demonstrated

| Area | What's shown |
|---|---|
| **Data modeling** | CDS root/projection views, persistence tables, draft tables |
| **RAP behavior** | Behavior Definition, Behavior Projection, Behavior Implementation (ABAP) |
| **Business logic** | Determinations, validations, custom actions, EML (`READ ENTITIES` / `MODIFY ENTITIES`) |
| **Workflow design** | Status-driven state machine with instance feature control |
| **UI** | Fiori Elements (List Report + Object Page), CDS metadata extensions |
| **Service exposure** | OData V4 service definition + service binding |

---

## ✨ Key Features

| Feature | Description |
|---|---|
| Product Management | Create, update, and delete products |
| Managed Draft | Edit products in draft mode before activation |
| Price Validation | Prevents products with invalid prices |
| Creation Determination | Automatically sets creator, creation timestamp, and initial status |
| Submit for Approval | Moves eligible products to `SUBMITTED` |
| Approval | Moves submitted products to `APPROVED` |
| Rejection | Moves submitted products to `REJECTED`, with mandatory reason |
| Instance Feature Control | Enables/disables actions based on product status |
| Audit Information | Tracks creation, submission, and approval details |
| Fiori Elements | List Report and Object Page UI |
| OData V4 | Exposes the transactional application as a UI service |

---

## 🔄 Business Workflow

```text
                         ┌─────────────┐
                         │     NEW     │
                         └──────┬──────┘
                                │ Submit for Approval
                                ▼
                         ┌─────────────┐
                         │  SUBMITTED  │
                         └──────┬──────┘
                                │
                     ┌──────────┴──────────┐
                  Approve                Reject
                     │                     │
                     ▼                     ▼
              ┌─────────────┐      ┌─────────────┐
              │  APPROVED   │      │  REJECTED   │
              └─────────────┘      └──────┬──────┘
                                           │ Submit again
                                           ▼
                                    ┌─────────────┐
                                    │  SUBMITTED  │
                                    └─────────────┘
```

### Status-Based Actions

| Product Status | Submit | Approve | Reject |
|---|:---:|:---:|:---:|
| `NEW` | ✅ | ❌ | ❌ |
| `SUBMITTED` | ❌ | ✅ | ✅ |
| `REJECTED` | ✅ | ❌ | ❌ |
| `APPROVED` | ❌ | ❌ | ❌ |

Action availability is controlled through RAP **instance feature control**.

---

## 🏗️ RAP Architecture

```text
┌─────────────────────────────────────┐
│         SAP Fiori Elements          │
│      List Report / Object Page      │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│       OData V4 UI Service Binding   │
│           ZCJ_PRODUCT_UI             │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│          Service Definition         │
│           ZCJ_PRODUCT_SRV            │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│       Consumption / Projection      │
│           ZCJ_C_PRODUCT              │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│          Interface CDS View         │
│           ZCJ_I_PRODUCT              │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│          RAP Behavior Layer         │
│  Behavior Definition / Projection    │
│  Behavior Implementation             │
│  Determination · Validation          │
│  Custom Actions · Feature Control    │
└──────────────────┬──────────────────┘
                    ▼
┌─────────────────────────────────────┐
│          Persistence Layer          │
│      ZCJ_PRODUCT · ZCJ_PRODUCT_D     │
└─────────────────────────────────────┘
```

---

## 🧩 RAP Objects

| Object | Type | Purpose |
|---|---|---|
| `ZCJ_PRODUCT` | Database Table | Stores active product data |
| `ZCJ_PRODUCT_D` | Draft Table | Stores RAP draft data |
| `ZCJ_I_PRODUCT` | Root CDS View Entity | Interface/root business object |
| `ZCJ_C_PRODUCT` | Projection CDS View | Service-facing projection |
| `ZBP_CJ_I_PRODUCT` | Behavior Implementation | Implements RAP business logic |
| `ZCJ_PRODUCT_SRV` | Service Definition | Exposes the Product entity |
| `ZCJ_PRODUCT_UI` | Service Binding | Publishes the OData V4 UI service |
| Metadata Extension | UI Metadata | Defines Fiori Elements presentation |

---

## 📦 Product Data Model

**Product Information**
`Product ID` · `Product Name` · `Description` · `Category` · `Price` · `Currency` · `Stock`

**Workflow Information**
`Status` · `Rejection Reason` · `Submitted At` · `Approved By` · `Approved At`

**Audit Information**
`Created By` · `Created At` · `Last Changed At`

---

## ⚙️ Business Logic

### 1. Creation Determination
`setCreationData` runs during product creation and automatically sets `CreatedBy`, `CreatedAt`, and `Status = NEW`, using the ABAP runtime context for the creator and current timestamp.

### 2. Price Validation
`validateProduct` runs on save for create/update. Rejects `Price <= 0` with:
> *Price must be greater than zero*

### 3. Submit for Approval
`submitForApproval` is available for `NEW` and `REJECTED` products. Sets `Status = SUBMITTED` and `SubmittedAt = current timestamp`.

### 4. Approval
`approve` is available only for `SUBMITTED` products. Sets `Status = APPROVED`, `ApprovedBy = current user`, `ApprovedAt = current timestamp`.

### 5. Rejection
`reject` is available only for `SUBMITTED` products and requires a rejection reason:
> *Rejection reason is required.*

Sets `Status = REJECTED` and retains the reason.

### EML Usage
The behavior implementation uses **Entity Manipulation Language (EML)** — `READ ENTITIES` and `MODIFY ENTITIES` — for transactional access to the RAP business object.

---

## 🎛️ Instance Feature Control

Available actions are dynamically controlled based on the current product status:

```text
NEW        → Submit for Approval enabled
SUBMITTED  → Approve enabled, Reject enabled
REJECTED   → Submit for Approval enabled
APPROVED   → No workflow action enabled
```

This prevents users from executing workflow operations that aren't valid for the current business state.

---

## 🖥️ Fiori Elements UI

Exposed via OData V4 and consumed with SAP Fiori Elements.

**List Report** — product catalog view with Product ID, Name, Category, Price, Currency, Stock, and Status.

**Object Page** — detailed product information and available workflow actions.

UI metadata is maintained through a CDS metadata extension.

---

## 📷 Screenshots

| | |
|---|---|
| **Service Binding** | ![Service Binding](screenshots/01-service-binding.png) |
| **Product List** | ![Product List](screenshots/02-product-list.png) |
| **Product Statuses** | ![Product Statuses](screenshots/04-product-list-statuses.png) |
| **Price Validation** | ![Price Validation](screenshots/03-price-validation.png) |
| **Draft / Edit** | ![Draft Edit](screenshots/05-draft-edit.png) |
| **Submitted Product** | <img width="945" alt="Submitted Product" src="https://github.com/user-attachments/assets/b82fcf8f-7635-4b55-be1c-41e6aa9a959c" /> |
| **Rejection Validation** | ![Rejection Validation](screenshots/07-rejection-validation.png) |
| **Rejected Product** | <img width="932" alt="Rejected Product" src="https://github.com/user-attachments/assets/dbe0fce1-f029-4e63-b16e-2195b34175b0" /> |
| **Product Object Page** | ![Product Object Page](screenshots/10-product-object-page.png) |

---

## 🚀 How to Explore This Project

This is an ABAP-only repository (no local runtime) — the source is meant to be imported into an SAP system via **Eclipse / ABAP Development Tools (ADT)**.

1. Clone the repo.
2. In ADT, create the objects in this order to respect dependencies: `database/` → `cds/` → `behavior/` → `service/` → `metadata/`.
3. Activate the service binding `ZCJ_PRODUCT_UI` and open it in the Fiori Elements preview.
4. Walk through the workflow: create a product → submit → approve/reject.

*(Screenshots above show the expected result at each stage if you just want to review the outcome without deploying.)*

---

## 🗂️ Repository Structure

```text
SAP-RAP-Product-Catalog/
│
├── README.md
├── SOURCE_OBJECTS.md
├── .gitignore
│
├── screenshots/
│   └── 01–11 ...
│
└── src/
    ├── database/
    │   ├── zcj_product.ddl
    │   └── zcj_product_d.ddl
    │
    ├── cds/
    │   ├── zcj_i_product.ddl
    │   └── zcj_c_product.ddl
    │
    ├── behavior/
    │   ├── zcj_i_product.bdef
    │   ├── zcj_c_product.bdef
    │   └── zbp_cj_i_product.abap
    │
    ├── metadata/
    │   └── zcj_c_product.mde
    │
    └── service/
        └── zcj_product_srv.srvd
```

---

## 🔐 Authorization

Current implementation uses simple authorization settings suitable for a development/trial system. Role-based authorization has not been implemented yet. A production-oriented version could introduce separate **requester** and **approver** roles with appropriate authorization checks.

---

## 🔮 Future Enhancements

- Role-based authorization (requester / approver roles)
- Approval and email notifications
- Additional product validations
- Category and currency value helps
- Search and filtering enhancements
- Product analytics and reporting
- Additional workflow states
- SAP BTP deployment documentation

---

## 🎯 Project Status

**Completed — Functional Prototype**

Tested end-to-end: product creation → draft editing → price validation → submission → approval → rejection → rejection validation → status-based action control → Fiori Elements UI interaction.

---

## 👨‍💻 Author

**Kamal Srikanta**
GitHub: [kamalsrikanta](https://github.com/kamalsrikanta) · Repo: [SAP-RAP-Product-Catalog](https://github.com/kamalsrikanta/SAP-RAP-Product-Catalog)
