.data
    v: .space 1048576

    cale_fisier: .space 256
    nume_fisier: .space 256
    informatii_fisier: .space 256

    nr_op: .space 4
    op: .space 4
    descriptor: .space 4
    dimensiune: .space 4
    nr: .space 4

    lin: .space 4
    stg: .space 4
    dr: .space 4
    cnt: .space 4
    lin1: .space 4
    stg1: .space 4
    drp1: .space 4

    cit: .asciz "%d"
    afis1: .asciz "%d\n"
    afis: .asciz "%d: ((%d, %d), (%d, %d))\n"
    afis_get: .asciz "((%d, %d), (%d, %d))\n"
    cale: .asciz "%s"

    index2: .long 0
    index1: .space 4

.text

adauga:
    movl $0, lin
    movl $0, stg
    movl $0, dr
    movl $0, cnt
    lea v, %esi

    xorl %edx, %edx
    movl dimensiune, %eax
    addl $7, %eax
    movl $8, %ebx
    divl %ebx
    movl %eax, dimensiune

    et_cautare_stanga:
        movl $1024, %eax
        cmp %eax, stg
        jae et_inc_lin_add

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax
        
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_inc_stanga

        movl stg, %ebx
        inc %ebx
        movl %ebx, dr
    
    et_cautare_dreapta:
        movl $1024, %eax
        cmp %eax, dr
        jae et_inc_lin_add

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax

        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_inc_stanga

        movl dr, %eax
        subl stg, %eax
        inc %eax
        cmp dimensiune, %eax
        je et_gasit
    
        movl dr, %eax
        inc %eax
        movl %eax, dr
        jmp et_cautare_dreapta
    
    et_inc_stanga:
        movl stg, %eax
        inc %eax
        movl %eax, stg
        jmp et_cautare_stanga

    et_gasit:
        movl stg, %eax
        movl %eax, cnt
        movl descriptor, %ebx

    et_adauga_descriptor:
        movl cnt, %eax
        cmp dr, %eax
        ja afisare_interval

        movl lin, %eax
        xor %edx, %edx
        movl $1024, %ecx
        mull %ecx
        addl cnt, %eax

        movl %ebx, (%esi, %eax,4)
        movl cnt, %eax
        inc %eax
        movl %eax, cnt
        jmp et_adauga_descriptor
        
    gata_add:
        ret

get:
    movl $0, stg
    movl $0, dr
    movl $0, lin
    lea v, %esi

    et_stg:
        movl $1024, %eax
        cmp %eax, stg
        jae et_inc_lin_get

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax

        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        je et_gasit_stg

        movl stg, %eax
        inc %eax
        movl %eax, stg
        jmp et_stg

    et_gasit_stg:
        movl stg, %eax
        inc %eax
        movl %eax, dr

    et_dr:
        movl $1024, %eax
        cmp %eax, dr
        jae et_gasit_dr

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax

        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_dr

        movl dr, %eax
        inc %eax
        movl %eax, dr
        jmp et_dr

    et_gasit_dr:
        movl dr, %eax
        dec %eax
        movl %eax, dr
    
    et_afis_get:
        pushl dr
        pushl lin
        pushl stg
        pushl lin
        pushl $afis_get
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx

        ret

delete:
    movl $0, stg
    movl $0, dr
    movl $0, lin
    lea v, %esi

    et_stg_del:
        movl $1024, %eax
        cmp %eax, stg
        jae et_inc_lin_del

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax

        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        je et_gasit_stg_del

        movl stg, %eax
        inc %eax
        movl %eax, stg
        jmp et_stg_del

    et_gasit_stg_del:
        movl stg, %eax
        movl %eax, dr

    et_dr_del:
        movl $1024, %eax
        cmp %eax, dr
        jae et_gasit_dr_del

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax

        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_dr_del

        movl $0, %ebx
        movl %ebx, (%esi,%eax,4)

        movl dr, %eax
        inc %eax
        movl %eax, dr
        jmp et_dr_del

    et_gasit_dr_del:
        movl dr, %eax
        dec %eax
        movl %eax, dr

        jmp afisare_matrice

defrag:
    movl $0, stg
    movl $0, dr
    movl $0, lin
    lea v, %esi

    et_cautare_zero:
        movl $1024, %eax
        cmp %eax, stg
        jae et_inc_lin_defrag

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax

        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        je et_gasit_zero

        movl stg, %eax
        inc %eax
        movl %eax, stg
        jmp et_cautare_zero

    et_gasit_zero:
        movl stg, %eax
        movl %eax, dr
    
    et_contor:
        movl $1024, %eax
        cmp %eax, dr
        jae et_cautare_fis

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax

        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_mutare

        movl dr,  %eax
        inc %eax
        movl %eax, dr
        jmp et_contor

    et_mutare:
        movl $1024, %eax
        cmp dr, %eax
        je defrag

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax
        
        movl (%esi,%eax,4), %ecx
        movl $0, (%esi, %eax,4) 

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax

        movl %ecx, (%esi,%eax,4)

        movl dr, %eax
        inc %eax
        movl %eax, dr

        movl stg, %ebx
        inc %ebx
        movl %ebx, stg

        jmp et_mutare
    
        et_cautare_fis:
            movl $0, cnt
            movl dr, %ebx
            subl stg, %ebx
            ;//inc %ebx
            movl %ebx, cnt

            movl $0, stg1
            movl $0, drp1
            movl lin, %eax
            inc %eax
            movl %eax, lin1

        et_cautare_desc:
            movl $1024, %eax
            cmp %eax, stg1
            jae et_inc_lin_defrag1

            movl lin1, %eax
            xorl %edx, %edx
            movl $1024, %ebx
            mull %ebx
            addl stg1, %eax

            movl (%esi,%eax,4), %ebx
            cmp $0, %ebx
            jne et_gasit_desc

            movl stg1, %eax
            inc %eax
            movl %eax, stg1
            jmp et_cautare_desc

        et_gasit_desc:
            movl (%esi,%eax,4), %ebx
            movl %ebx, descriptor

            movl stg1, %eax
            movl %eax, drp1
        
        et_cautare_final:
            movl $1024, %eax
            cmp %eax, drp1
            jae et_mutare_lin

            movl lin1, %eax
            xorl %edx, %edx
            movl $1024, %ebx
            mull %ebx
            addl drp1, %eax

            movl (%esi,%eax,4), %ebx
            cmp descriptor, %ebx
            jne et_mutare_lin

            movl drp1, %eax
            subl stg1, %eax
            inc %eax
            cmp cnt, %eax
            ja et_gata_defrag1_fail

            movl drp1, %eax
            inc %eax
            movl %eax, drp1

            jmp et_cautare_final



        et_mutare_lin:
            movl stg1, %eax
            cmp drp1, %eax
            je et_gata_defrag1

            movl lin1, %eax
            xorl %edx, %edx
            movl $1024, %ebx
            mull %ebx
            addl stg1, %eax

            movl (%esi,%eax,4), %ecx
            movl $0, (%esi, %eax,4)

            movl lin, %eax
            xorl %edx, %edx
            movl $1024, %ebx
            mull %ebx
            addl stg, %eax
        
            movl %ecx, (%esi,%eax,4)

            movl stg, %eax
            inc %eax
            movl %eax, stg

            movl stg1, %eax
            inc %eax
            movl %eax, stg1

            jmp et_mutare_lin

        et_gata_defrag1_fail:
            movl $0, lin1
            movl $0, stg1
            movl $0, drp1

            jmp et_inc_lin_defrag

        et_gata_defrag1:
            movl $0, lin1
            movl $0, stg1
            movl $0, drp1

            movl $0, stg
            movl $0, dr

            jmp et_cautare_zero

    et_gata_defrag:
        jmp afisare_matrice

et_inc_lin_add:
    movl lin, %eax
    inc %eax
    movl %eax, lin

    movl $0, stg
    movl $0, dr

    movl $255, %eax
    cmp %eax, lin
    jae eroare_add

    jmp et_cautare_stanga

eroare_add:
    movl $0, lin
    movl $0, stg
    movl $0, dr
    jmp afisare_interval


et_inc_lin_get:
    movl lin, %eax
    inc %eax
    movl %eax, lin

    movl $0, stg
    movl $0, dr

    movl $255, %eax
    cmp %eax, lin
    jae eroare_get

    jmp et_stg

eroare_get:
    movl $0, lin
    jmp et_afis_get

et_inc_lin_del:
    movl lin, %eax
    inc %eax
    movl %eax, lin

    movl $255, %eax
    cmp %eax, lin
    jae afisare_matrice

    movl $0, stg
    movl $0, dr

    jmp et_stg_del

et_inc_lin_defrag:
    movl lin, %eax
    inc %eax
    movl %eax, lin

    movl $255, %eax
    cmp %eax, lin
    jae et_gata_defrag

    movl $0, stg
    movl $0, dr

    jmp et_cautare_zero

et_inc_lin_defrag1:
    movl lin1, %eax
    inc %eax
    movl %eax, lin1

    movl $255, %eax
    cmp %eax, lin1
    jae et_gata_defrag1_fail

    movl $0, stg1
    movl $0, drp1

    jmp et_cautare_desc

et_inc_lin_afis:
    movl lin, %eax
    inc %eax
    movl %eax, lin

    movl $255, %eax
    cmp %eax, lin
    jae et_gata_afis

    movl $0, stg
    movl $0, dr

    jmp et_int_stg

afisare_interval:
    pushl dr
    pushl lin
    pushl stg
    pushl lin
    pushl descriptor
    pushl $afis
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    ret

afisare_matrice:
    movl $0, stg
    movl $0, dr
    movl $0, lin
    lea v, %esi

    et_int_stg:
        movl $1024, %eax
        cmp %eax, stg
        jae et_inc_lin_afis

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl stg, %eax

        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_gasit_int_stg

        movl stg, %eax
        inc %eax
        movl %eax, stg

        jmp et_int_stg

    et_gasit_int_stg:
        movl lin, %eax 
        xorl %edx, %edx 
        movl $1024, %ebx 
        mull %ebx 
        addl stg, %eax 

        movl (%esi,%eax,4), %ebx
        movl %ebx, descriptor

        movl stg, %eax
        inc %eax
        movl %eax, dr

    et_int_dr:
        movl $1024, %eax
        cmp %eax, stg
        jae et_gasit_int_dr 

        movl lin, %eax
        xorl %edx, %edx
        movl $1024, %ebx
        mull %ebx
        addl dr, %eax

        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_int_dr

        movl dr, %eax
        inc %eax
        movl %eax, dr

        jmp et_int_dr

    et_gasit_int_dr:
        movl dr, %eax
        dec %eax
        movl %eax, dr

        call afisare_interval

        movl dr, %eax
        inc %eax
        movl %eax, stg

        jmp et_int_stg
    
    et_gata_afis:
        ret




.global main

main:
    pushl $nr_op
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    movl $0, index1

et_citire_op:
    movl index1, %ecx
    cmp nr_op, %ecx
    je et_exit

    pushl $op
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    movl op, %ebx

    cmp $1, %ebx
    je et_citire_fis

    cmp $2, %ebx
    je et_get_cit

    cmp $3, %ebx
    je et_delete_cit

    cmp $4, %ebx
    je et_defrag_cit

    cmp $5, %ebx
    je et_concrete_cit

et_final_op:
    movl index1, %ecx
    inc  %ecx
    movl %ecx, index1
    jmp et_citire_op

et_citire_fis:
    pushl  $nr
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    movl $0, index2 

et_add_cit:
    movl index2, %eax
    cmp nr, %eax
    je et_final_op

    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    pushl  $dimensiune
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx
    call adauga

    movl index2, %eax
    inc %eax
    movl %eax, index2
    jmp et_add_cit

et_get_cit:
    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    call get

    jmp et_final_op

et_delete_cit:
    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    call delete

    jmp et_final_op

et_defrag_cit:
    call defrag

    jmp et_final_op

et_concrete_cit:
    pushl $cale_fisier
    pushl $cale
    call scanf
    popl %ebx
    popl %ebx

    call concrete

    jmp et_final_op


et_exit:
    pushl $0
    call fflush     
    popl %ebx

    mov $1, %eax
    xor %ebx, %ebx  
    int $0x80

