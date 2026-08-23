CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateProduct FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validateProduct.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features
      FOR Product RESULT result.

    METHODS approve FOR MODIFY
      keys FOR ACTION Product~approve RESULT result.

    METHODS reject FOR MODIFY
      keys FOR ACTION Product~reject RESULT result.

    METHODS setCreationData FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Product~setCreationData.

    METHODS submitForApproval FOR MODIFY
      keys FOR ACTION Product~submitForApproval RESULT result.

ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD validateProduct.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      FIELDS ( Price )
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      IF product-Price <= 0.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Price must be greater than zero'
          )
        ) TO reported-product.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setCreationData.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      FIELDS ( CreatedBy CreatedAt )
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    DELETE products WHERE CreatedBy IS NOT INITIAL
                     AND CreatedAt IS NOT INITIAL.

    MODIFY ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      UPDATE FIELDS ( CreatedBy CreatedAt Status )
      WITH VALUE #(
        FOR product IN products
        (
          %tky      = product-%tky
          CreatedBy = cl_abap_context_info=>get_user_technical_name( )
          CreatedAt = utclong_current( )
          Status    = 'NEW'
        )
      )
      REPORTED DATA(update_reported).

  ENDMETHOD.

  METHOD approve.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      IF product-Status <> 'SUBMITTED'.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only submitted products can be approved.'
          )
        ) TO reported-product.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

        CONTINUE.

      ENDIF.

      MODIFY ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        UPDATE FIELDS ( Status ApprovedBy ApprovedAt )
        WITH VALUE #(
          (
            %tky       = product-%tky
            Status     = 'APPROVED'
            ApprovedBy = cl_abap_context_info=>get_user_technical_name( )
            ApprovedAt = utclong_current( )
          )
        )
        REPORTED DATA(update_reported)
        FAILED DATA(update_failed).

      READ ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        ALL FIELDS
        WITH VALUE #(
          (
            %tky = product-%tky
          )
        )
        RESULT DATA(updated_products).

      LOOP AT updated_products INTO DATA(updated_product).

        APPEND VALUE #(
          %tky   = updated_product-%tky
          %param = updated_product
        ) TO result.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    result = VALUE #(
      FOR product IN products
      (
        %tky = product-%tky

        %action-submitForApproval =
          COND #(
            WHEN product-Status = 'NEW'
              OR product-Status = 'REJECTED'
            THEN if_abap_behv=>fc-o-enabled
            ELSE if_abap_behv=>fc-o-disabled
          )

        %action-approve =
          COND #(
            WHEN product-Status = 'SUBMITTED'
            THEN if_abap_behv=>fc-o-enabled
            ELSE if_abap_behv=>fc-o-disabled
          )

        %action-reject =
          COND #(
            WHEN product-Status = 'SUBMITTED'
            THEN if_abap_behv=>fc-o-enabled
            ELSE if_abap_behv=>fc-o-disabled
          )
      )
    ).

  ENDMETHOD.

  METHOD reject.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      IF product-Status <> 'SUBMITTED'.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only submitted products can be rejected.'
          )
        ) TO reported-product.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

        CONTINUE.

      ENDIF.

      IF product-RejectionReason IS INITIAL.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Rejection reason is required.'
          )
        ) TO reported-product.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

        CONTINUE.

      ENDIF.

      MODIFY ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          (
            %tky   = product-%tky
            Status = 'REJECTED'
          )
        )
        REPORTED DATA(update_reported)
        FAILED DATA(update_failed).

      READ ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        ALL FIELDS
        WITH VALUE #(
          (
            %tky = product-%tky
          )
        )
        RESULT DATA(updated_products).

      LOOP AT updated_products INTO DATA(updated_product).

        APPEND VALUE #(
          %tky   = updated_product-%tky
          %param = updated_product
        ) TO result.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD submitForApproval.

    READ ENTITIES OF zcj_i_product IN LOCAL MODE
      ENTITY Product
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      IF product-Status <> 'NEW'
        AND product-Status <> 'REJECTED'.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only draft or rejected products can be submitted.'
          )
        ) TO reported-product.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

        CONTINUE.

      ENDIF.

      MODIFY ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        UPDATE FIELDS ( Status SubmittedAt )
        WITH VALUE #(
          (
            %tky        = product-%tky
            Status      = 'SUBMITTED'
            SubmittedAt = utclong_current( )
          )
        )
        REPORTED DATA(update_reported)
        FAILED DATA(update_failed).

      READ ENTITIES OF zcj_i_product IN LOCAL MODE
        ENTITY Product
        ALL FIELDS
        WITH VALUE #(
          (
            %tky = product-%tky
          )
        )
        RESULT DATA(updated_products).

      LOOP AT updated_products INTO DATA(updated_product).

        APPEND VALUE #(
          %tky   = updated_product-%tky
          %param = updated_product
        ) TO result.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
